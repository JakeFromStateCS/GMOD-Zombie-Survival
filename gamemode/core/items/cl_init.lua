local MODULE = {};
MODULE.Name = "Items";
MODULE.Hooks = MODULE.Hooks or {};
MODULE.Nets = MODULE.Nets or {};
MODULE.Stored = {};
MODULE.Config = {};

function MODULE:OnLoad()
	Base.Items = self;
	self:LoadItems();
end;

function MODULE:RegisterItem( ITEM )
	if( ITEM.Name ) then
		self.Stored[ITEM.Name] = ITEM;
	end;
end;

function MODULE:LoadItems()
	local folder = "blrp/gamemode/items/";
	for _,file in pairs( file.Find( folder .. "*.lua", "LUA" ) ) do
		if( SERVER ) then
			AddCSLuaFile( folder .. file );
			include( folder .. file );
		else
			include( folder .. file );
		end;
	end;
end;

Base.Modules:RegisterModule( MODULE );