local MODULE = {};
MODULE.Hooks = {};
MODULE.Nets = {};
MODULE.Name = "Skills";
MODULE.Data = {};
MODULE.ExpData = {};
MODULE.Stored = {};
MODULE.Config = {};
MODULE.Config.BaseExp = 400;
MODULE.Config.ExpAddition = 100;

/*
	Levels:
		Maxlogs in one stack = 4
		4 / 2 = 2 * 10 = 20;
		( level 1 ) 400 / 20 = 20 wood
		
		LevelExp = Level1Exp + ( ( level - 1 ) * Level1Exp + ( ( level - 1 ) * 100 ) );
		LevelExp = 400 + ( ( 2 - 1 ) * 400 + ( ( 2 - 1 ) * 100 ) );
		LevelExp = 400 + ( 400 + 100 );
		LevelExp = 900;
		
		
*/



local pMeta = FindMetaTable( "Player" );



function pMeta:SetSkill( name, amount )
	Base.Skill:SetPlayerSkill( self, name, amount );
end;



function pMeta:GetSkill( name )
	return Base.Skill:GetPlayerSkill( self, name );
end;



function MODULE:OnLoad()
	Base.Skill = self;
	self:LoadSkills();
end;



/*
	function RegisterSkill( SKILL/Table ):
		Stores the table based on the name of the skill
*/
function MODULE:RegisterSkill( SKILL )
	local name = SKILL.Name;
	if( name ) then
		print( name );
		self.Stored[name] = SKILL;
	end;
end;



function MODULE:LoadSkills()
	local folder = "blrp/gamemode/skills/";
	for _,file in pairs( file.Find( folder .. "*.lua", "LUA" ) ) do
		if( SERVER ) then
			AddCSLuaFile( folder .. file );
			include( folder .. file );
		else
			include( folder .. file );
		end;
	end;
end;



function MODULE:LoadPlayerSkills( client )
	if( self.Data[client] == nil ) then
		self.Data[client] = {};
	end;
	for name,_ in pairs( self.Stored ) do
		local data = tonumber( client:GetPData( name, 1 ) );
		self:SetPlayerSkill( client, name, data );
	end;
end;



/*
	function SyncPlayerSkills( client/Player ):
		Loops through the players skill table
		Sends a net message to the client with the skill name and amount
*/
function MODULE:SyncPlayerSkills( client )
	local data = self.Data[client];
	if( data ) then
		for name,amount in pairs( data ) do
			Base.Modules:NetMessage( client, "SyncSkill", name, amount );
		end;
	end;
end;



/*
	function SyncPlayerSkill( client/Player, name/String ):
		Syncs a single resource to the client using a netmessage
*/
function MODULE:SyncPlayerSkill( client, name )
	local data = self:GetPlayerSkill( client, name );
	Base.Modules:NetMessage( client, "SyncSkill", name, data );
end;



/*
	function GetPlayerSkill( client/Player, name/String ):
		Checks if the player has a valid data table
		If not, load their skills which creates a table
		If theyre new. Return their data or 0
*/
function MODULE:GetPlayerSkill( client, name )
	local skillTab = self.Data[client];
	if( skillTab == nil ) then
		self:LoadPlayerSkills( client );
		skillTab = self.Data[client];
	end;
	return ( skillTab[name] or 1 );
end;



/*
	function AddPlayerSkill( client/Player, resource/String, addAmount/Float ):
		Gets the player resource using GetPlayerSkill
		Sets the player resource to amount + addAmount using SetPlayerResource
*/
function MODULE:AddPlayerSkill( client, name, addAmount )
	local amount = self:GetPlayerSkill( client, name );
	self.Data[client][name] = amount + addAmount;
	self:SavePlayerSkill( client, name );
	self:SyncPlayerSkill( client, name );
	Base.Notice:Add( client, "+" .. addAmount .. " " ..name .. ".", self.Stored[name].Color );
end;



/*
	function SavePlayerSkill( client/Player, name/String ):
		Gets the player resource amount then saves it
		Using whatever method, currently SetPData
*/
function MODULE:SavePlayerSkill( client, name )
	local amount = self:GetPlayerSkill( client, name );
	client:SetPData( name, amount );
end;



/*
	function SetPlayerSkill( client/Player, name/String, amount/Float ):
		Creates a data table for the client if its nil
		Sets the skill data to the amount
		Syncs the data to the client
*/
function MODULE:SetPlayerSkill( client, name, amount )
	if( self.Data[client] == nil ) then
		self.Data[client] = {};
	end;
	self.Data[client][name] = amount;
	self:SavePlayerSkill( client, name );
	self:SyncPlayerSkill( client, name );
	Base.Notice:Add( client, "+" .. amount .. " " .. name .. ".", Color( 0, 0, 0 ) );
end;



function pMeta:SetExperience( skill, amount )
	Base.Skill:SetPlayerExperience( self, skill, amount );
end;

function pMeta:AddExperience( skill, amount )
	Base.Skill:AddPlayerExperience( self, skill, amount );
end;



function MODULE:LoadPlayerExperiences( client )
	if( self.ExpData[client] == nil ) then
		self.ExpData[client] = {};
	end;
	for name,_ in pairs( self.Stored ) do
		local data = tonumber( client:GetPData( name .. "_Exp", 0 ) );
		self:SetPlayerExperience( client, name, data );
	end;
end;



function MODULE:SyncPlayerExperiences( client )
	local data = self.ExpData[client];
	if( data == nil ) then
		self:LoadPlayerExperiences( client );
		data = self.ExpData[client];
	end;
	for name,skill in pairs( data ) do
		Base.Modules:NetMessage( client, "SyncExperience", name, skill );
	end;
end;



function MODULE:SyncPlayerExperience( client, name )
	local data = self:GetPlayerExperience( client, name );
	Base.Modules:NetMessage( client, "SyncExperience", name, data );
end;



/*
	function SavePlayerExperience( client/Player, name/String ):
		Gets the player resource amount then saves it
		Using whatever method, currently SetPData
*/
function MODULE:SavePlayerExperience( client, name )
	local amount = self:GetPlayerExperience( client, name );
	client:SetPData( name .. "_Exp", amount );
end;



function MODULE:GetPlayerExperience( client, skill )
	local data = self.ExpData[client];
	if( data == nil ) then
		self:LoadPlayerExperiences( client );
		data = self.ExpData[client][skill];
	else
		data = data[skill];
	end;
	return data;
end;



/*
	
*/
function MODULE:SetPlayerExperience( client, skill, amount )
	if( self.ExpData[client] == nil ) then
		self.ExpData[client] = {};
	end;
	local level = self:GetPlayerSkill( client, skill );
	local maxExp = self.Config.BaseExp + ( level * self.Config.BaseExp + level * 100 );
	if( amount > maxExp ) then
		self:SetPlayerSkill( client, skill, level + 1 );
		amount = amount - maxExp;
	end;
	self.ExpData[client][skill] = amount;
	self:SyncPlayerExperience( client, skill );
	self:SavePlayerExperience( client, skill );
end;



/*
	function AddPlayerExperience( client/Player, skill/String, amount/Number ):
		Adds the experience to the players experience
*/
function MODULE:AddPlayerExperience( client, skill, amount )
	local exp = self:GetPlayerExperience( client, skill );
	local level = self:GetPlayerSkill( client, skill );
	local maxExp = self.Config.BaseExp + ( level * self.Config.BaseExp + level * 100 );
	self:SetPlayerExperience( client, skill, exp + amount );
	--Base.Notice:Add( client, "+" .. amount .. " " .. skill .. " (" .. exp .. "/" .. maxExp .. ".", Color( 0, 0, 0 ) );
end;



--=================================
--|            HOOKS              |
--=================================



/*
	HOOK: PlayerAuthed( client/Player ):
		Loads the player resources and syncs them using
		LoadPlayerResources
*/
function MODULE.Hooks:PlayerAuthed( client )
	timer.Simple( 1, function()
		self:LoadPlayerSkills( client );
		self:LoadPlayerExperiences( client );
	end );
end;



/*
	HOOK: OnReloaded():
		Reloads all the resources
		Reloads all player data and resyncsD
*/
function MODULE.Hooks:OnReloaded()
	self:OnLoad();
	for _,client in pairs( player.GetAll() ) do
		self:LoadPlayerSkills( client );
		self:LoadPlayerExperiences( client );
	end;
end;


/*
	HOOK: EntityTakeDamage( client ):
		Changes the damage the client does to entites
		Also changes the damage the entity receives from others
*/
function MODULE.Hooks:EntityTakeDamage( ent, dmgInfo )
	local attacker = dmgInfo:GetAttacker();
	local damage = dmgInfo:GetDamage();
	if( attacker:IsPlayer() ) then
		local weapon = attacker:GetActiveWeapon();
		if( weapon:IsValid() ) then
			local ammoType = Base.Jobs.Config.AmmoTypes[weapon:GetPrimaryAmmoType()];
			local mult = 0;
			for _,SKILL in pairs( self.Stored ) do
				if( SKILL.AmmoType == ammoType ) then
					local skill = attacker:GetSkill( SKILL.Name );

					mult = mult + SKILL.Mult * skill;
					
					if( SKILL.ExpRate ) then
						attacker:AddExperience( SKILL.Name, SKILL.ExpRate );
					end;
				elseif( SKILL.AmmoTypes ) then
					if( table.HasValue( SKILL.AmmoTypes, ammoType ) ) then
						local skill = attacker:GetSkill( SKILL.Name );

						mult = mult + SKILL.Mult * skill;
						if( SKILL.ExpRate ) then
							attacker:AddExperience( SKILL.Name, SKILL.ExpRate );
						end;
					end;
				elseif( SKILL.Resource ) then
					local RESOURCE = Base.Resource.Stored[SKILL.Resource];
					if( RESOURCE.Source ) then
						if( ent:GetClass() == RESOURCE.Source ) then
							local skill = attacker:GetSkill( SKILL.Name );
							mult = mult + SKILL.Mult * skill;
						end;
					end;
				end;
			end;
			print( mult );
			dmgInfo:ScaleDamage( 1 + mult );
			return dmgInfo;
		end;
	end;
end;



--=================================
--|         NET MESSAGES          |
--=================================



function MODULE.Nets:RequestSkills( client )
	self:SyncPlayerSkills( client );
end;

function MODULE.Nets:RequestExperiences( client )
	self:SyncPlayerExperiences( client );
end;



Base.Modules:RegisterModule( MODULE );

