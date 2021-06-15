local MODULE = {};
MODULE.Hooks = {};
MODULE.Nets = {};
MODULE.Name = "Resources";
MODULE.Data = {};
MODULE.Stored = {};
MODULE.Config = {};


function MODULE:OnLoad()
	Base.Resource = self;
	self:LoadResources();
end;



function MODULE:RegisterResource( RESOURCE )
	if( RESOURCE.Name ) then
		self.Stored[RESOURCE.Name] = RESOURCE;
	end;
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



function MODULE:GetPlayerResources( client )
	local data = self.Data[client];
	return ( data or {} );
end;

function MODULE:GetPlayerResource( client, resource )
	local data = self.Data[client];
	if( data == nil ) then
		return 0;
	end;
	return ( data[resource] or 0 );
end;

function MODULE.Hooks:HUDPaint()
	
end;

function MODULE.Hooks:OnReloaded()
	Base.Modules:NetMessage( "RequestResources" );
end;

function MODULE.Nets:SyncPlayerResource()
	local client = net.ReadEntity();
	local name = net.ReadString();
	local amount = net.ReadFloat();
	
	if( self.Data[client] == nil ) then
		self.Data[client] = {};
	end;
	
	self.Data[client][name] = amount;
end;

function MODULE.Nets:SyncResource()
	local name = net.ReadString();
	local amount = net.ReadFloat();
	if( self.Data[LocalPlayer()] == nil ) then
		self.Data[LocalPlayer()] = {};
	end;
	self.Data[LocalPlayer()][name] = amount;
end;

Base.Modules:RegisterModule( MODULE );