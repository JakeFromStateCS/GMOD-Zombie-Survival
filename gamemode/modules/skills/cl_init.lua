local MODULE = {};
MODULE.Hooks = {};
MODULE.Nets = {};
MODULE.Name = "Skills";
MODULE.Data = {};
MODULE.ExpData = {};
MODULE.Stored = {};
MODULE.Config = {};
MODULE.Config.BaseExp = 400;

function MODULE:OnLoad()
	Base.Skill = self;
	self:LoadSkills();
end;



function MODULE:RegisterHooks( SKILL )
	local hooks = SKILL.Hooks;
	if( hooks ) then
		for name,func in pairs( hooks ) do
			
		end;
	end;
end;



/*

*/
function MODULE:RegisterSkill( SKILL )
	local name = SKILL.Name;
	if( name ) then
		print( name );
		self.Stored[name] = SKILL;
		self:RegisterHooks( SKILL );
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



function MODULE:GetPlayerSkill( client, name )
	local data = self.Data[client];
	return ( data[name] or 0 );
end;



function MODULE:GetPlayerSkills( client )
	local data = self.Data[client];
	return ( data or {} );
end;



function MODULE:GetPlayerExperiences( client )
	local data = self.ExpData[client];
	return ( data or {} );
end;



function MODULE:GetPlayerExperience( client, name )
	local data = self.ExpData[client];
	if( data ) then
		return ( data[name] or 0 );
	end;
	return 0;
end



--=================================
--|            HOOKS              |
--=================================



function MODULE.Hooks:OnReloaded()
	Base.Modules:NetMessage( "RequestSkills" );
	Base.Modules:NetMessage( "RequestExperiences" );
end;

function MODULE.Hooks:OnExperienceUpdate( name, data )
	local level = self:GetPlayerSkill( LocalPlayer(), name );
	local maxExp = Base.Skill.Config.BaseExp + ( level * Base.Skill.Config.BaseExp + ( 100 * level ) );
	
	if( self.ExpMenu == nil ) then
		self.ExpMenu = vgui.Create( "BLRP_EXPInfo" );
		self.ExpMenu:SetPos( ScrW() - self.ExpMenu:GetWide(), ScrH() / 2 - self.ExpMenu:GetTall() );
		self.ExpMenu:SetData( name, data );
	else
		self.ExpMenu:SetData( name, data );
	end;
	timer.Create( "BLRP_EXPMenu", 1, 2, function()
		if( self.ExpMenu ) then
			self.ExpMenu:Remove();
		end;
		self.ExpMenu = nil;
	end );
end;


--
--=================================
--|         NET MESSAGES          |
--=================================

function MODULE.Nets:SyncExperience()
	local name = net.ReadString();
	local data = net.ReadFloat();
	print( "SYNCEXPERIENCE", name, data );
	hook.Call( "OnExperienceUpdate", GAMEMODE, name, data );
	if( self.ExpData[LocalPlayer()] == nil ) then
		self.ExpData[LocalPlayer()] = {};
	end;
	
	self.ExpData[LocalPlayer()][name] = data;
end;


function MODULE.Nets:SyncSkill()
	local name = net.ReadString();
	local data = net.ReadFloat();
	
	if( self.Data[LocalPlayer()] == nil ) then
		self.Data[LocalPlayer()] = {};
	end;
	
	self.Data[LocalPlayer()][name] = data;
end;

Base.Modules:RegisterModule( MODULE );

