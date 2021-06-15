local MODULE = {};
MODULE.Name = "Props";
MODULE.Hooks = MODULE.Hooks or {};
MODULE.Nets = MODULE.Nets or {};
MODULE.Stored = {};
MODULE.Cleanup = {};
MODULE.Config = {};
MODULE.Config.Models = {
	["models/props_borealis/bluebarrel001.mdl"] = true,
	["models/props_interiors/vendingmachinesoda01a.mdl"] = 	 true,
	["models/props_interiors/vendingmachinesoda01a_door.mdl"] = true,
	["models/props_junk/trafficcone001a.mdl"] = true,
	["models/props_junk/trashbin01a.mdl"] = true,
	["models/props_junk/plasticcrate01a.mdl"] = true,
	["models/props_c17/shelfunit01a.mdl"] = true,
	["models/props_c17/furnituretable001a.mdl"] =  true,
	["models/props_c17/furnituredrawer001a_chunk05.mdl"] =  true,
	["models/props_c17/furnituredrawer001a_chunk06.mdl"] = true,
	["models/props_c17/furnituredrawer002a.mdl"] =  true,
	["models/props_junk/wood_crate002a.mdl"] =  true,
	["models/props_junk/wood_pallet001a.mdl"] = true,
	["models/props_junk/cardboard_box004a_gib01.mdl"] = true,
	["models/props_junk/cardboard_box001a.mdl"] =  true,
	["models/props_junk/wood_crate001a.mdl"] =  true,
	["models/props_c17/furnituretable003a.mdl"] =  true,
	["models/props_c17/furnituredrawer003a.mdl"] =  true,
	["models/props_c17/furnituredrawer001a_chunk03.mdl"] = true,
	["models/props_c17/furnituredrawer001a_chunk02.mdl"] = true,
	["models/props_c17/furnituredrawer001a_chunk01.mdl"] = true,
	["models/props_c17/furnituredrawer001a.mdl"] = true,
	["models/props_c17/furniturecupboard001a.mdl"] = true,
	["models/props_junk/cardboard_box003a.mdl"] =  true,
	["models/props_c17/furnituredresser001a.mdl"] =  true,
	["models/props_c17/furnituretable002a.mdl"] =  true,
	["models/props_borealis/borealis_door001a.mdl"] = true,
	["models/props_borealis/mooring_cleat01.mdl"] =  true,
	["models/props_c17/canister01a.mdl"] = 	true,
	["models/props_c17/canister02a.mdl"] = 	 true,
	["models/props_c17/canister_propane01a.mdl"] = true,
	["models/props_c17/furniturebathtub001a.mdl"] =  true,
	["models/props_c17/furniturebed001a.mdl"] =  true,
	["models/props_c17/furniturewashingmachine001a.mdl"] =  true,
	["models/props_c17/oildrum001.mdl"] = 	 true,
	["models/props_c17/oildrum001_explosive.mdl"] = true,
	["models/props_c17/pulleywheels_small01.mdl"] = true,
	["models/props_c17/pulleywheels_large01.mdl"] = true,
	["models/props_debris/metal_panel02a.mdl"] =  true,
	["models/props_debris/metal_panel01a.mdl"] =  true,
	["models/props_interiors/radiator01a.mdl"] = true,
	["models/props_interiors/refrigerator01a.mdl"] =  true,
	["models/props_interiors/refrigeratordoor01a.mdl"] = true,
	["models/props_interiors/refrigeratordoor02a.mdl"] = true,
	["models/props_junk/metalbucket01a.mdl"] =  true,
	["models/props_junk/metalbucket02a.mdl"] =  true,
	["models/props_junk/metalgascan.mdl"] = 	 true,
	["models/props_junk/trashdumpster02.mdl"] =  true,
	["models/props_junk/trashdumpster01a.mdl"] =  true,
	["models/props_junk/sawblade001a.mdl"] =  true,
	["models/props_junk/trashdumpster02b.mdl"] =  true,
	["models/props_wasteland/kitchen_counter001c.mdl"] = true,
	["models/props_wasteland/kitchen_counter001a.mdl"] = true,
	["models/props_wasteland/kitchen_counter001b.mdl"] = true,
	["models/props_wasteland/kitchen_counter001d.mdl"] = true,
	["models/props_c17/fence01a.mdl"] = 	 true,
	["models/props_c17/fence01b.mdl"] = 	 true,
	["models/props_c17/fence02a.mdl"] = 	 true,
	["models/props_c17/fence02b.mdl"] = 	 true,
	["models/props_c17/fence03a.mdl"] = 	 true,
	["models/props_c17/fence04a.mdl"] = 	 true,
	["models/props_c17/furniturestove001a.mdl"] =  true,
	["models/props_lab/blastdoor001a.mdl"] = 	 true,
	["models/props_lab/blastdoor001c.mdl"] = 	 true,
	["models/props_c17/concrete_barrier001a.mdl"] = true,
	["models/props_c17/gravestone001a.mdl"] =  true,
	["models/props_c17/gravestone002a.mdl"] =  true,
	["models/props_c17/gravestone003a.mdl"] =  true,
	["models/props_c17/gravestone004a.mdl"] = true,
	["models/props_c17/gravestone_cross001b.mdl"] = true,
	["models/props_junk/cinderblock01a.mdl"] = true,
	["models/props_wasteland/medbridge_post01.mdl"] =  true,
	["models/props_c17/furniturecouch001a.mdl"] = true,
	["models/props_c17/furniturecouch002a.mdl"] = true,
	["models/props_combine/breenglobe.mdl"] = true,
	["models/props_combine/breendesk.mdl"] = true,
	["models/props_combine/breenchair.mdl"] = true,
	["models/props_combine/breenglobe.mdl"] = true,
	["models/combine_helicopter/helicopter_bomb01.mdl"] = true,
	["models/props_interiors/furniture_couch02a.mdl"] = true,
	["models/props_interiors/furniture_lamp01a.mdl"] = true,
	["models/props_interiors/sinkkitchen01a.mdl"] = true,
	["models/props_lab/kennel_physics.mdl"] = true,
	["models/props_lab/filecabinet02.mdl"] = true,
	["models/props_vehicles/tire001b_truck.mdl"] = true,
	["models/props_vehicles/tire001c_car.mdl"] = true,
	["models/props_vehicles/apc_tire001.mdl"] = true,
	["models/props_trainstation/trainstation_clock001.mdl"] = true,
	["models/props_wasteland/barricade001a.mdl"] =  true,
	["models/props_wasteland/barricade002a.mdl"] =  true,
	["models/props_wasteland/light_spotlight01_lamp.mdl"] = true,
	["models/props_wasteland/wheel01.mdl"] = true,
	["models/props_wasteland/wheel01a.mdl"] = true,
	["models/props_wasteland/wheel02a.mdl"] = true,
	["models/props_wasteland/wheel02b.mdl"] = true,

};


local pMeta = FindMetaTable( "Player" );

function pMeta:AddCleanup( ent )
	if( Base.Props.Cleanup[self] == nil ) then
		Base.Props.Cleanup[self] = {};
	end;
	table.insert( Base.Props.Cleanup[self], ent );
end;

function pMeta:CheckLimit( str )
	return 99999;
end;

function MODULE:OnLoad()
	Base.Props = self;
end;

function MODULE:SpawnProp( client, model )
	if( self.Config.Models[model] ) then
		if( self.Stored[client] == nil ) then
			self.Stored[client] = {};
		end;
		
		local prop = ents.Create( "prop_physics" );
		prop:SetModel( model );
		local obbMax = prop:OBBMaxs();
		local obbMin = prop:OBBMins();
		prop:SetPos( client:GetEyeTrace().HitPos );
		prop:SetAngles( client:GetAngles() );
		prop:Spawn();
		
		local physObj = prop:GetPhysicsObject();
		local min, max = physObj:GetAABB();
		local dist = ( min - max ):Length() --obbMax:Distance( obbMin );
		print( dist );
		prop:SetPos( client:GetEyeTrace().HitPos + client:GetUp() * (dist / 2) );
		prop.Owner = client;
		self.Stored[client][prop] = true;
		undo.Create( "prop" );
			undo.AddEntity( prop );
			undo.SetPlayer( client );
		undo.Finish();
	end;
end;

function MODULE.Hooks:CanTool( client, trace, tool )
	print( client.jobName );
	if( client.jobName == "Builder" ) then
		return true;
	end;
end;

function MODULE.Nets:SpawnProp( client )
	local model = net.ReadString();
	self:SpawnProp( client, model );
end;

Base.Modules:RegisterModule( MODULE );