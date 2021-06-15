local MODULE = {};
MODULE.Name = "Items";
MODULE.Hooks = MODULE.Hooks or {};
MODULE.Nets = MODULE.Nets or {};
MODULE.Stored = {};
MODULE.Config = {};


local pMeta = FindMetaTable( "Player" );

function MODULE:OnLoad()
	Base.Items = self;
	self:LoadItems();
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

function MODULE:SpawnItem( client, item )
	if( self.Stored[item] ) then
		
		local prop = ents.Create( self.Stored[item].Class );
		local obbMax = prop:OBBMaxs();
		local obbMin = prop:OBBMins();
		prop:SetPos( client:GetEyeTrace().HitPos );
		prop:SetAngles( client:GetAngles() );
		prop:Spawn();
		
		local physObj = prop:GetPhysicsObject();
		if( physObj:IsValid() ) then
			local min, max = physObj:GetAABB();
			local dist = ( min - max ):Length() --obbMax:Distance( obbMin );
			prop:SetPos( client:GetEyeTrace().HitPos );
		end;
		prop.Owner = client;
	end;
end;

function MODULE:RegisterItem( ITEM )
	if( ITEM.Name ) then
		print( ITEM.Name );
		self.Stored[ITEM.Name] = ITEM;
	end;
end;

function MODULE.Nets:SpawnItem( client )
	local name = net.ReadString();
	self:SpawnItem( client, name );
end;

Base.Modules:RegisterModule( MODULE );