local MODULE = {};
MODULE.Hooks = {};
MODULE.Nets = {};
MODULE.Name = "Resources";
MODULE.Data = {};
MODULE.Stored = {};
MODULE.Config = {};
MODULE.Resources = {};
MODULE.SpawnQueue = {};
--
local pMeta = FindMetaTable( "Player" );


/*
	function pMeta(Player):AddResource( resource/String, amount/Float ):
		Uses the global SetPlayerResource in the
		Base.Resource table to set the player resource
*/
function pMeta:AddResource( resource, amount )
	Base.Resource:AddPlayerResource( self, resource, amount );
end;



/*
	function pMeta(Player):SetResource( resource/String, amount/Float ):
		Uses the global SetPlayerResource in the
		Base.Resource table to set the player resource
*/
function pMeta:SetResource( resource, amount )
	Base.Resource:SetPlayerResource( self, resource, amount );
end;



/*
	function OnLoad():
		Defines a global variable for the module
		Loads all the resource types
*/
function MODULE:OnLoad()
	Base.Resource = self;
	self:LoadResources();
end;


/*
	function LoadResources():
		Loops through all the files in the "blrp/gamemode/resources/" directory
		Each file defines a local table then calls RegisterResource on the table
*/
function MODULE:LoadResources()
	local folder = "blrp/gamemode/resources/";
	for _,file in pairs( file.Find( folder .. "*.lua", "LUA" ) ) do
		if( SERVER ) then
			AddCSLuaFile( folder .. file );
			include( folder .. file );
		else
			include( folder .. file );
		end;
	end;
end;



/*
	function RegisterResource( RESOURCE/Table ):
		Checks if the resource table can be stored with the name
		Then stores it
*/
function MODULE:RegisterResource( RESOURCE )
	local name = RESOURCE.Name;
	if( name ) then
		self.Stored[name] = RESOURCE;
	end;
end;



/*
	function LoadPlayerResources( client/Player ):
		Creates a data table for the player if its nil
		Loops through all valid resources and loads player data
		Calls SetPlayerResource with the client, resourceName and data
*/
function MODULE:LoadPlayerResources( client )
	if( self.Data[client] == nil ) then
		self.Data[client] = {};
	end;
	for name,_ in pairs( self.Stored ) do
		local data = tonumber( client:GetPData( name, 0 ) );
		self:SetPlayerResource( client, name, data );
	end;
end;



/*
	function SyncPlayerResources( client/Player ):
		Loops through the players resource table
		Sends a net message to the client with the resource name and amount
*/
function MODULE:SyncPlayerResources( client )
	local data = self.Data[client];
	for name,amount in pairs( data ) do
		Base.Modules:NetMessage( client, "SyncResource", name, amount );
	end;
end;



/*
	function SyncPlayerResource( client/Player, name/String ):
		Syncs a single resource to the client using a netmessage
*/
function MODULE:SyncPlayerResource( client, name )
	local data = self:GetPlayerResource( client, name );
	Base.Modules:NetMessage( client, "SyncResource", name, data );
end;



/*
	function GetPlayerResource( client/Player, resource/String ):
		Checks if the player has a valid data table
		If not, load their resources which creates a table
		If theyre new. Return their data or 0
*/
function MODULE:GetPlayerResource( client, resource )
	local resourceTab = self.Data[client];
	if( resourceTab == nil ) then
		self:LoadPlayerResources( client );
		resourceTab = self.Data[client];
	end;
	return ( resourceTab[resource] or 0 );
end;



/*
	function AddPlayerResource( client/Player, resource/String, addAmount/Float ):
		Gets the player resource using GetPlayerResource
		Sets the player resource to amount + addAmount using SetPlayerResource
*/
function MODULE:AddPlayerResource( client, resource, addAmount )
	local amount = self:GetPlayerResource( client, resource );
	if( self.Data[client] == nil ) then
		self.Data[client] = {};
	end;
	self.Data[client][resource] = amount + addAmount;
	self:SavePlayerResource( client, resource );
	self:SyncPlayerResource( client, resource );
	Base.Notice:Add( client, "+" .. addAmount .. " " .. resource .. ".", self.Stored[resource].Color );
end;



/*
	function SavePlayerResource( client, resource ):
		Gets the player resource amount then saves it
		Using whatever method, currently SetPData
*/
function MODULE:SavePlayerResource( client, resource )
	local amount = self:GetPlayerResource( client, resource );
	client:SetPData( resource, amount );
end;



/*
	function SetPlayerResource( client/Player, resource/String, amount/Float ):
		Creates a data table for the client if its nil
		Sets the resource data to the amount
		Syncs the data to the client
*/
function MODULE:SetPlayerResource( client, resource, amount )
	if( self.Data[client] == nil ) then
		self.Data[client] = {};
	end;
	self.Data[client][resource] = amount;
	self:SavePlayerResource( client, resource );
	self:SyncPlayerResource( client, resource );
	Base.Notice:Add( client, amount .. "x " .. resource .. ".", self.Stored[resource].Color );
end;



function MODULE:SpawnSources()
	for _,SOURCE in pairs( self.Stored ) do
		local map = string.lower( game.GetMap() );
		local spawnTab = SOURCE.Sources[map];
		if( !spawnTab ) then
			continue;
		end;
		for id,tab in pairs( spawnTab ) do
			local ent = ents.Create( SOURCE.Source );
			ent:SetPos( tab.pos );
			ent:SetAngles( tab.ang );
			ent:Spawn();
			ent.sourceID = id;
			ent.SourceName = SOURCE.Name;
		end;
	end;
end;

function MODULE:RemoveSources()
	for _,SOURCE in pairs( self.Stored ) do
		local ents = ents.FindByClass( SOURCE.Source );
		for _,ent in pairs( ents ) do
			ent:Remove();
		end;
	end;
end;


--=================================
--|            HOOKS              |
--=================================



/*
	HOOK: InitPostEntity():
		Spawn all the source entities ( Trees, rocks, etc ) when the gamemode loads
*/
function MODULE.Hooks:InitPostEntity()
	self:SpawnSources();
end;



/*
	HOOK: PlayerAuthed( client/Player ):
		Loads the player resources and syncs them using
		LoadPlayerResources
*/
function MODULE.Hooks:PlayerAuthed( client )
	timer.Simple( 1, function()
		self:LoadPlayerResources( client );
	end );
end;



/*
	HOOK: EntityRemoved( ent/Source ):
		When a source is removed, we add it to the table of
		Sources that need to be respawned ( SpawnQueue )
*/
function MODULE.Hooks:EntityRemoved( ent )
	local class = ent:GetClass();
	if( ent.sourceID ) then
		local SOURCE = self.Stored[ent.SourceName];
		self.SpawnQueue[ent.sourceID] = {
			time = CurTime() + SOURCE.RespawnTime,
			class = class,
			name = ent.SourceName
		};
		for name,SKILL in pairs( Base.Skill.Stored ) do
			if( SKILL.Resource ) then
				if( SKILL.Resource == SOURCE.Name ) then
					if( ent.attacker ) then
						ent.attacker:AddExperience( SKILL.Name, SKILL.ExpRate );
					end;
				end;
			end;
		end;
	end;
end;



/*
	HOOK: OnReloaded():
		Reloads all the resources
		Reloads all player data and resyncsD
*/
function MODULE.Hooks:OnReloaded()
	self:OnLoad();
	for _,client in pairs( player.GetAll() ) do
		self:LoadPlayerResources( client );
	end;
	self:RemoveSources();
	self:SpawnSources();
end;



/*
	HOOK: Think():
		Loops through the SpawnQueue table which is a table
		Of sources ( Trees, rocks, etc ) that have been mined and need to be respawned
		Respawns them if their timer is over the respawn time
*/
function MODULE.Hooks:Think()
	for id,tab in pairs( self.SpawnQueue ) do
		if( tab.time < CurTime() ) then
			local map = string.lower( game.GetMap() );
			local SOURCE = self.Stored[tab.name];
			local posTab = SOURCE.Sources[map][id];
			local ent = ents.Create( tab.class );
			ent:SetPos( posTab.pos );
			ent:SetAngles( posTab.ang );
			ent:Spawn();
			ent.sourceID = id;
			ent.SourceName = SOURCE.Name;
			self.SpawnQueue[id] = nil;
		end;
	end;
end;



--=================================
--|         NET MESSAGES          |
--=================================



/*
	NETMESSAGE: RequestResources( client/Player ):
		Received from the client when the clientside code refreshes
		Resyncs all data to the client
*/
function MODULE.Nets:RequestResources( client )
	self:SyncPlayerResources( client );
end;

Base.Modules:RegisterModule( MODULE );