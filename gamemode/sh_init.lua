--sh_init.lua
/*
	sh_init.lua
*/

Base = {};
Base.Name = "DarkRP";

Base.Modules = Base.Modules or {};

if( SERVER ) then
	AddCSLuaFile();
	AddCSLuaFile( "sh_config.lua" );
	util.AddNetworkString( Base.Name .. "_NetMsg" );
end;

include( "sh_config.lua" );

Base.Modules.FolderName = "blrp/gamemode/";
Base.Modules.Stored = {};
Base.Modules.HookTypes = {};
Base.Modules.Nets = {};
Base.Modules.PostLoads = {};

GM.Name = Base.Name;

function Base.Modules:OnLoad()
end;

function Base.Modules:LoadNotice( realm, modName )
	--local suffix = string.upper( string.sub( realm, 1, 2 ) );
	--local color = Base.Config.Colors[suffix];
	--MsgC( Base.Config.ConsoleColor, "[GAMEMODE-" .. suffix .. "] " );
	--MsgC( color, "[GM-" .. suffix .. "] |" );
	MsgC( Base.Config.ConsoleColor, "    (" );
	MsgC( Base.Config.ModColor, "module" );
	MsgC( Base.Config.ConsoleColor, ") " .. modName .. "\n" );
end;

function Base.Modules:HookRegisterNotice( realm, modName, hookName )
	--local suffix = string.upper( string.sub( realm, 1, 2 ) );
	--local color = Base.Config.Colors[suffix];
	--MsgC( Base.Config.ConsoleColor, "[GAMEMODE-" .. suffix .. "] " );
	--MsgC( color, "[GM-" .. suffix .. "] |" );
	MsgC( Base.Config.ConsoleColor, "     - (" );
	MsgC( Base.Config.HookColor, "hook" );
	MsgC( Base.Config.ConsoleColor, ") " .. hookName .. "\n" );--.. " from" );
	--MsgC( Base.Config.ModColor, " MODULE" );--
	--MsgC( Base.Config.ConsoleColor, ": " .. modName .. "\n" );
end;

function Base.Modules:NetRegisterNotice( realm, modName, netName )
	local suffix = string.upper( string.sub( realm, 1, 2 ) );
	local color = Base.Config.Colors[suffix];
	--MsgC( Base.Config.ConsoleColor, "[GAMEMODE-" .. suffix .. "] " );
	--MsgC( color, "[GM-" .. suffix .. "] |" );
	MsgC( Base.Config.ConsoleColor, "     - (" );
	MsgC( Base.Config.NetColor, "net" );
	MsgC( Base.Config.ConsoleColor, ") " .. netName .. "\n" );
	--MsgC( Base.Config.ModColor, " MODULE" );
	--MsgC( Base.Config.ConsoleColor, ": " .. modName .. "\n" );
end;

function Base.Modules:RegisterModule( MODULE )
	if( MODULE.Name ) then
		if( Base.Config.Debug ) then
			self:LoadNotice( MODULE.Realm, MODULE.Name );
		end;
		if( MODULE.OnLoad ) then
			MODULE:OnLoad();
		end;
		self.Stored[MODULE.Name] = MODULE;
		self:RegisterHooks( MODULE );
		self:RegisterNets( MODULE );


		if( MODULE.PostLoad ) then
			self.PostLoads[MODULE.Name] = MODULE.PostLoad;
		end;
	end;
end;

function Base.Modules:RunPostLoads()
	for modName, PostLoad in pairs( self.PostLoads ) do
		PostLoad( self.Stored[modName] );
	end;
end;

function Base.Modules:LoadCore()
	if( Base.Config.Debug ) then
		MsgC( Base.Config.ConsoleColor, "\n    Base.Core\n" );
		MsgC( Base.Config.HookColor, "    ------------------------\n" );
	end;
	local fileTab = {file.Find( Base.Modules.FolderName ..  "core/*", "LUA" )};
	for k,v in pairs( fileTab[2] ) do
		for k, file in pairs( file.Find( Base.Modules.FolderName .. "core/" .. v .. "/*.lua", "LUA") ) do
			local path = Base.Modules.FolderName .. "core/" .. v .. "/"
			if( file~= nil ) then
				local prefix = string.sub( file, 1, 3 );
				if( string.match( prefix, "_" ) ) then
					path = path .. file;
					MODULE = {};
					MODULE.Hooks = {};
					MODULE.Nets = {};
					MODULE.Config = {};
					MODULE.Realm = prefix;
					if( Base.Config.Debug ) then
						MODULE.Path = path;
					end;
					if( prefix == "cl_" ) then
						if( SERVER ) then
							AddCSLuaFile( path );
						else
							include( path );
						end;
					elseif( prefix == "sv_" ) then
						if( SERVER ) then
							include( path );
						end;
					elseif( prefix == "sh_" ) then
						if( SERVER ) then
							AddCSLuaFile( path );
							include( path );
						else
							include( path );
						end;
					
					end;

					MODULE = nil;
				end;
			end;
		end;
	end;
end;

function Base.Modules:LoadModules()
	if( Base.Config.Debug ) then
		MsgC( Base.Config.ConsoleColor, "\n    Base.Modules\n" );
		MsgC( Base.Config.HookColor, "    ------------------------\n" );
	end;
	local fileTab = {file.Find( Base.Modules.FolderName ..  "modules/*", "LUA" )};
	for k,v in pairs( fileTab[2] ) do
		for k, file in pairs( file.Find( Base.Modules.FolderName .. "modules/" .. v .. "/*.lua", "LUA") ) do
			local path = Base.Modules.FolderName .. "modules/" .. v .. "/"
			if( file~= nil ) then
				local prefix = string.sub( file, 1, 3 );
				if( string.match( prefix, "_" ) ) then
					path = path .. file;
					MODULE = {};
					MODULE.Hooks = {};
					MODULE.Nets = {};
					MODULE.Config = {};
					MODULE.Realm = prefix;
					if( Base.Config.Debug ) then
						MODULE.Path = path;
					end;
					if( prefix == "cl_" ) then
						if( SERVER ) then
							AddCSLuaFile( path );
						else
							include( path );
						end;
					elseif( prefix == "sv_" ) then
						if( SERVER ) then
							include( path );
						end;
					elseif( prefix == "sh_" ) then
						if( SERVER ) then
							AddCSLuaFile( path );
							include( path );
						else
							include( path );
						end;
					
					end;

					MODULE = nil;
				end;
			end;
		end;
	end;
	self:RunPostLoads();
end;

function Base.Modules:RegisterHooks( MODULE )
	if( MODULE.Name and MODULE.Hooks ) then
		for name,func in pairs( MODULE.Hooks ) do
			if( self.HookTypes[name] == nil or !self.HookTypes[name] ) then
				self.HookTypes[name] = {};
				hook.Add( name, "Base.Modules_" .. name, function( ... )
					
					local time = SysTime();
					local tab = self.HookTypes[name];
					if( tab == nil and !self.Reloading ) then
						hook.Remove( name, "Base.Modules_" .. name );
						return;
					elseif( tab ~= nil ) then
						local retVar = nil;
						for modName, func in pairs( tab ) do
							retVar = func( self.Stored[modName], ... );
						end;
						if( retVar ~= nil ) then
							return retVar;
						end;
					end;
					if( SysTime() - time > 0.001 ) then
						print( "MODULE: " .. MODULE.Name .. " is taking forever in hook: " .. name .. " - " .. SysTime() - time );
					end;
				
				end );
			end;
			self.HookTypes[name][MODULE.Name] = func;
			--table.insert( Base.Modules.HookTypes[name], func );
			if( Base.Config.Debug ) then
				if( SERVER ) then
					self:HookRegisterNotice( "sv_", MODULE.Name, name );
				else
					self:HookRegisterNotice( "cl_", MODULE.Name, name );
				end;
			end;
		end;
	end;
end;

function Base.Modules:DisableHook( modName, hookType )
	local MODULE = Base.Modules.Stored[modName];
	if( MODULE ) then
		if( MODULE.Hooks ) then
			if( MODULE.Hooks[hookType] ) then
				if( Base.Modules.HookTypes[hookType][modName] ~= nil ) then
					Base.Modules.HookTypes[hookType][modName] = nil;
				end
				hook.Remove( hookType, "Base.Modules_" .. hookType );
			end;
		end;
	end;
end;

function Base.Modules:DisableHooks( modName )
	local MODULE = Base.Modules.Stored[modName];
	if( MODULE ) then
		if( MODULE.Hooks ) then
			for name, func in pairs( MODULE.Hooks ) do
				self:DisableHook( modName, name );
			end;
		end;
	end;
end;

function Base.Modules:RegisterNets( MODULE )
	if( MODULE.Name and MODULE.Nets ) then
		for name,func in pairs( MODULE.Nets ) do
			--if( Base.Modules.Nets[name] == nil ) then
				if( Base.Config.Debug ) then
					if( SERVER ) then
						self:NetRegisterNotice( "sv_", MODULE.Name, name );
					else
						self:NetRegisterNotice( "cl_", MODULE.Name, name );
					end;
				end;
				Base.Modules.Nets[name] = { ["module"] = MODULE.Name, ["func"] = func };
			--end;
		end;
	end;
end;

function Base.Modules:NetMessage( client, netMsg, ... )
	local tab = { ... }
	local clients = {};
	if( type( client ) == "string" ) then
		table.insert( tab, 1, netMsg );
		netMsg = client;
		client = nil;
		clients = player.GetAll();
	elseif( type( client ) == "table" ) then
		for k,v in pairs( client ) do
			if( type( v ) == "Player" ) then
				table.insert( clients, v );
			end;
		end;
	elseif( type( client ) == "Player" ) then
		clients = client;
	end;
--
	if( Base.Config.Debug ) then
		MsgC( Color( 255, 150, 150 ), "     - (netmsg)" );
		MsgC( Color( 255, 255, 255 ), ": Starting Message " ..  netMsg .. "\n" );
	end;
	local types = {
		["Number"] = "Float",
		["NextBot"] = "Entity",
		["Player"] = "Entity",
		["NPC"] = "Entity",
		["Table"] = "Table",
		["Vehicle"] = "Entity"
	}--
	net.Start( Base.Name .. "_NetMsg" );
		net.WriteString( netMsg );
		if( CLIENT ) then
			net.WriteEntity( LocalPlayer() );
		end;
		for k,v in pairs( tab ) do
			local typeName = type( v ):gsub("^%l", string.upper);
			if( types[typeName] ) then
				typeName = types[typeName];
				--print( "writing " .. typeName );
				--print( v );
			else
				--print( typeName );
			end;
			local func = net["Write" .. typeName];
			if( func ) then
				func( v );
			end;
		end;
	if( CLIENT ) then
		net.SendToServer();
	else
		net.Send( clients );
	end;
end;

function Base.Modules.NetReceive()
	local netMsg = net.ReadString();
	if( netMsg ) then
		if( SERVER ) then
			
		else
		end;
		local netTab = Base.Modules.Nets[netMsg];
		if( netTab ) then
			if( Base.Config.Debug ) then
				MsgC( Color( 255, 150, 150 ), "(NET)" );
				MsgC( Color( 255, 255, 255 ), ": Receiving Message " ..  netMsg .. "\n" );
			end;
			
			if( CLIENT ) then
				netTab.func( Base.Modules.Stored[netTab.module] );
			else
				local client = net.ReadEntity();
				netTab.func( Base.Modules.Stored[netTab.module], client );
			end;
		end;
	end;
end;
net.Receive( Base.Name .. "_NetMsg", Base.Modules.NetReceive );

function Base.Modules.OnGamemodeLoaded()
	Base.Modules:LoadCore();
	Base.Modules:LoadModules();
end;
hook.Add( "OnGamemodeLoaded", "Base.Modules.OnGamemodeLoaded", Base.Modules.OnGamemodeLoaded );

function Base.Modules.OnReloaded()
	Base.Modules:LoadCore();
	Base.Modules:LoadModules();
end;
hook.Add( "OnReloaded", "Base.Modules.OnReloaded", Base.Modules.OnReloaded );

function GM:InitPostEntity()
	
end;