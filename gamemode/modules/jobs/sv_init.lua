local MODULE = {};
MODULE.Name = "Jobs";
MODULE.Hooks = {};
MODULE.Nets = {};
MODULE.Stored = {};
MODULE.Members = {};
MODULE.Config = {};
MODULE.Config.AmmoTypes = {
	"AR2",
	"AlyxGun",
	"Pistol",
	"SMG1",
	"357",
	"XBowBolt",
	"Buckshot",
	"RPG_Round",
	"SMG1_Grenade",
	[26] = "SMG1",
	[-1] = "Melee"
};

local pMeta = FindMetaTable( "Player" );

function MODULE:LoadNotice( JOB )
	MsgC( Base.Config.ConsoleColor, "        (" );
	MsgC( Base.Config.NetColor, "job" );
	MsgC( Base.Config.ConsoleColor, ") " );
	MsgC( JOB.Color, JOB.Name .. "\n" );
end;

function MODULE:HookRegisterNotice( hookName )
	MsgC( Base.Config.ConsoleColor, "     - (" );
	MsgC( Base.Config.HookColor, "hook" );
	MsgC( Base.Config.ConsoleColor, ") " .. hookName .. "\n" );--.. " from" );
end;

function MODULE:NetRegisterNotice( realm, modName, netName )
	MsgC( Base.Config.ConsoleColor, "     - (" );
	MsgC( Base.Config.NetColor, "net" );
	MsgC( Base.Config.ConsoleColor, ") " .. netName .. "\n" );
end;

function MODULE:OnLoad()
	Base.Jobs = self;
	self:LoadJobs();
end;

function MODULE:LoadJobs()
	local folder = "blrp/gamemode/jobs/";
	for _,file in pairs( file.Find( folder .. "*.lua", "LUA" ) ) do
		print( file );
		if( SERVER ) then
			AddCSLuaFile( folder .. file );
			include( folder .. file );
		else
			include( folder .. file );
		end;
	end;
end;

function MODULE:RegisterJob( JOB )
	if( JOB.Name ) then
		if( JOB.Default ) then
			self.DefJob = JOB.Name;
			self.DefStats = JOB.Stats;
		end;
		self.Stored[JOB.Name] = JOB;
		self:LoadNotice( JOB );
	end;
end;

function MODULE:GetJobs()
	return self.Stored;
end;

function pMeta:GetJob()
	if( self.jobName ) then
		return self.jobName;
	end;
end;

function MODULE:GetJobMembers( jobName )

end;

function MODULE:GetPlayerJob( client )
	return client.jobName;
end;



function MODULE:SetPlayerJob( client, jobName )
	if( client.jobName ~= nil ) then
		hook.Call( "PlayerChangeJob", GAMEMODE, client, client.jobName, jobName );
	end;
	client.jobName = jobName;
	
	self:SetStats( client );
	self.Hooks.PlayerModel( self, client );
	self.Hooks.PlayerLoadout( self, client );
	
	Base.Modules:NetMessage( "SetJob", client, jobName );
	client:Spawn();
end;

function MODULE:GetPlayerDefaultJob( client )
	for jobName,JOB in pairs( self.Stored ) do
		if( JOB.Default ) then
			return jobName;
		end;
	end;
end;

function MODULE:GetJobWeapons( jobName )
	local JOB = self.Stored[jobName];
	if( JOB ) then
		if( JOB.Weapons ) then
			return JOB.Weapons;
		end;
	end;
	return {};
end;

function MODULE:SetStats( client )
	local jobID = self:GetPlayerJob( client );
	local JOB = self.Stored[jobID];
	if( JOB ) then
		local stats = JOB.Stats;
		if( stats == nil ) then
			stats = self.DefStats;
		end;
		client:SetHealth( stats.health );
		client:SetArmor( stats.armor );
		client:SetWalkSpeed( stats.walkSpeed );
		client:SetRunSpeed( stats.runSpeed );
	end;
end;

function MODULE.Hooks:PlayerChangeJob( client, oldJob, newJob )
	if( self.Members[newJob] == nil ) then
		self.Members[newJob] = {};
	end;
	if( self.Members[oldJob] == nil ) then
		self.Members[oldJob] = {};
	end;
	
	table.insert( self.Members[newJob], client );
	
	for index,member in pairs( self.Members[oldJob] ) do
		if( member == client ) then
			table.remove( self.Members[oldJob], index );
		end;
	end;
end;


/*
	HOOK: PlayerInitialSpawn( client ):
		Sets the clients health, armor, runspeed, walkspeed, etc based on their class
*/
function MODULE.Hooks:PlayerInitialSpawn( client )
	local jobName = self:GetPlayerDefaultJob( client );
	self:SetPlayerJob( client, jobName );
end;

function MODULE.Hooks:PlayerModel( client )
	local jobName = self:GetPlayerJob( client );
	print( jobName );
	print( "HELLO" );
	local JOB = self.Stored[jobName];
	if( JOB ) then
		if( JOB.Models ) then
			local modelID = client.modelID or 1;
			local model = JOB.Models[modelID];
			print( model );
			client:SetModel( model );
		end;
	end;
end;

/*
	HOOK: PlayerLoadout( client ):
		Sets the client loadout based on their jobs weapons
*/
function MODULE.Hooks:PlayerLoadout( client )
	client:StripWeapons();
	local jobName = self:GetPlayerJob( client );
	local weapons = self:GetJobWeapons( jobName );
	for className,ammo in pairs( weapons ) do
		client:Give( className );
		local weapon = client:GetWeapon( className );
		if( weapon:IsValid() ) then
			local ammoType = weapon:GetPrimaryAmmoType();
			client:SetAmmo( ammo, ammoType );
		end;
	end;
end;

/*
	HOOK: PlayerSpawn( client ):
		Sets the clients health, armor, runspeed, walkspeed, etc based on their class
*/
function MODULE.Hooks:PlayerSpawn( client )
	local jobName = self:GetPlayerJob( client );
	if( jobName == nil ) then
		local defaultJob = self:GetPlayerDefaultJob( client );
		self:SetPlayerJob( client, defaultJob );
	else
		self:SetStats( client );
		self.Hooks.PlayerModel( self, client );
		self.Hooks.PlayerLoadout( self, client );
	end;
end;








function MODULE.Nets:SetJob( client )
	local jobName = net.ReadString();
	self:SetPlayerJob( client, jobName );
end;

Base.Modules:RegisterModule( MODULE );