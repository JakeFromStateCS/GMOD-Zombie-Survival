--[[
	PLANNED FEATURES:
		Bus Driver gets paid an amount per player that gets on the bus after waiting near a bus stop
			Say $30/person waiting * 4-5 people waiting = 120-150 per stop
		HUD Displays the next stop and minimap shows it in a different color.

]]--
local MODULE = {};
MODULE.Hooks = {};
MODULE.Nets = {};
MODULE.Name = "Bus Driver";
MODULE.Stored = {};
MODULE.Config = {};

MODULE.Config.BusTeam = "Bus Driver";

MODULE.Config.CashLimit = 100000;

--Amount earned per bus stop
MODULE.Config.AmountPerStop = 200;

--Amount paid per passenger when they enter the bus.
MODULE.Config.BusFare = 30;
MODULE.Config.BusStops = {
	["rp_rockford_v1"] = {
		{
			name = "Nexus",
			pos = Vector( -4106, -7132, 8 ),
			ang = Angle( 0, 90, 0 )
		},
		{
			name = "Hospital",
			pos = Vector( -2078, -4305, 8 ),
			ang = Angle( 0, -180, 0 )
		},
		{
			name = "Downtown",
			pos = Vector( -9569, -3100, 8 ),
			ang = Angle( 0, 0, 0 )
		},
		{
			name = "Car Dealer",
			pos = Vector( -5876, -2020, 8 ),
			ang = Angle( 0, -90, 0 )
		},
		{
			name = "Industrial",
			pos = Vector( -6242, 4177, 130 ),
			ang = Angle( 0, 0, 0 )
		},
		
		
		
	},
	["rp_downtown_v4c_v2"] = {
		{
			name = "Downtown",
			pos = Vector( -1396, 285, -176 ),
			ang = Angle( 0, 0, 0 )
		},
		{
			name =  "Warehouses",
			pos = Vector( -3921, 2199, -176 ),
			ang = Angle( 0, 0, 0 )
		},
		{
			name = "Central",
			pos = Vector( -2835, -1670, -176 ),
			ang = Angle( 0, 0, 0 )
		},
		{
			name = "Residential",
			pos = Vector( -1028, -6508, -173 ),
			ang = Angle( 0, 90, 0 )
		},
		{
			name = "Avenue",
			pos = Vector( 675, -1091, -176 ),
			ang = Angle( 0, 90, 0 )
		},
		{
			name = "Townhomes",
			pos = Vector( 2420,  -1821,  -176 ),
			ang = Angle( 0, 0, 0 )
		},
		{
			name = "Plaza",
			pos = Vector( 2893, 945, -176.1875 ),
			ang = Angle( 0, 180, 0 )
		},
		{
			name = "Slum",
			pos = Vector( 3959, 2539, -176 ),
			ang = Angle( 0, 90, 0 )
		},
		{
			name = "Backlots",
			pos = Vector( 761, 4176,  -176 ),
			ang = Angle( 0, -90, 0 )
		},
		{
			name = "Commercial",
			pos = Vector( 43, 1314, -176 ),
			ang = Angle( 0, 0, 0 )
		},
	},
	["rp_downtown_v4c_mg"] = {
		{
			name = "Downtown",
			pos = Vector( 635, -119, 20 ),
			ang = Angle( 0, 0, 0 )
		},
		{
			name =  "Warehouses",
			pos = Vector( -4170, -875, 20 ),
			ang = Angle( 0, -90, 0 )
		},
		{
			name = "Central",
			pos = Vector( 485, -5330, 20 ),
			ang = Angle( 0, 0, 0 )
		},
		{
			name = "Residential",
			pos = Vector( 7300, -5035, 20 ),
			ang = Angle( 0, 90, 0 )
		},
		{
			name = "Avenue",
			pos = Vector( 7300, -5035, 20 ),
			ang = Angle( 0, 90, 0 )
		},
		{
			name = "Townhomes",
			pos = Vector( 2420,  -1821,  20 ),
			ang = Angle( 0, 0, 0 )
		},
		{
			name = "Plaza",
			pos = Vector( 2893, 945, 20 ),
			ang = Angle( 0, 180, 0 )
		},
		{
			name = "Slum",
			pos = Vector( 3959, 2539, 20 ),
			ang = Angle( 0, 90, 0 )
		},
		{
			name = "Beach",
			pos = Vector( 13367, 4829, 20 ),
			ang = Angle( 0, -90, 0 )
		},
		{
			name = "Backlots",
			pos = Vector( 3498, 7852, 0 ),
			ang = Angle( 0, -90, 0 )
		},
		{
			name = "Commercial",
			pos = Vector( 2326, 3141, 20 ),
			ang = Angle( 0, -90, 0 )
		},
	}
};
MODULE.Stopped = false;
MODULE.BusSpawn = {
	pos = Vector( 3085, 3617, -196 ),
	ang = Angle( 0, 90, 0 )
};
MODULE.Config.VehicleTab = { 	
	Name = "Bus", 
	Class = "prop_vehicle_jeep_old",
	Category = "SligWolf's Vehicle's",
   	busfrontlights = {
		Light1 = { Pos = Vector(-37,-120,35), Ang = Angle(0,10,90) } , 
		Light2 = { Pos = Vector(37,-120,35), Ang = Angle(0,-10,90) } 
	},
	busbacklights = {
		Light3 = { Pos = Vector(-42,182,47), Ang = Angle(0,0,-90) } , 
		Light4 = { Pos = Vector(42,182,47), Ang = Angle(0,0,-90) } 
	},
	BusDoors  = { 
		busdoors1 = { Pos = Vector(0,0,0), Ang = Angle(0,0,0) }
	},
	Author = "SligWolf",
	Information = "Bus made by SligWolf",
	Model = "models/sligwolf/bus/bus.mdl",
	
	SW_PassengersBusNew  = { passenger1 = { Pos = Vector(34,-46,35), Ang = Angle(0,0,0) },
					passenger2 = { Pos = Vector(34,92,35), Ang = Angle(0,0,0) },
					passenger3 = { Pos = Vector(-34,95,35), Ang = Angle(0,180,0) },
					passenger4 = { Pos = Vector(34,166,35), Ang = Angle(0,0,0) },
					passenger5 = { Pos = Vector(0,166,35), Ang = Angle(0,0,0) },
					passenger6 = { Pos = Vector(-34,-44,35), Ang = Angle(0,180,0) },
					passenger7 = { Pos = Vector(-34,166,35), Ang = Angle(0,0,0) }	},
	SeatType = "jeep_seat",
	
	KeyValues = {
					vehiclescript	=	"scripts/vehicles/sligwolf/sw_bus.txt"
				}
}

function MODULE:GetSeats( bus )
	local entTab = {};
	if( bus:IsValid() ) then
		local pos1, pos2 = ( bus:GetPos() - bus:GetForward() * 50 + bus:GetRight() * 180 ), bus:GetPos() + Vector( 0, 0, 10 ) + bus:GetForward() * 50 - bus:GetRight() * 200 + Vector( 0, 0, 120 );
		local boxEnts = ents.FindInBox( pos1, pos2 );
		for _,ent in pairs( boxEnts ) do
			if( ent:GetClass() == "prop_vehicle_prisoner_pod" ) then
				table.insert( entTab, ent );
			end;
		end;
	end;
	return entTab;
end;

function MODULE:GetBoarded( bus )
	local entTab = {};
	if( bus:IsValid() ) then
		local seats = self:GetSeats( bus );
		for _,seat in pairs( seats ) do
			if( seat:IsValid() ) then
				if( seat.GetDriver ) then
					local rider = seat:GetDriver();
					if( rider:IsValid() ) then
--						print( rider );
						table.insert( entTab, rider );
					end;
				end;
			end;
		end;
	end;
	return entTab;
end;

function MODULE:GetEnts( bus )
	local boxEnts = {};
	if( bus:IsValid() ) then
		local pos1, pos2 = ( bus:GetPos() - bus:GetForward() * 50 + bus:GetRight() * 180 ), bus:GetPos() + Vector( 0, 0, 10 ) + bus:GetForward() * 60 - bus:GetRight() * 120 + Vector( 0, 0, 120 );
		boxEnts = ents.FindInBox( pos2, pos1 );
	end;
	return boxEnts;
end;

function MODULE:GetRiding( bus )
	local clients = {};
	local seats = self:GetSeats( bus );
	for _,seat in pairs( seats ) do
		local client = seat:GetDriver();
		if( client:IsValid() ) then
			table.insert( clients, client );
		end;
	end;
	return clients;
end;

if( SERVER ) then

	function MODULE:KickRider( client )

	end;

	function MODULE:BusDoors( vehicle )
		local localpos = vehicle:GetPos() 
		local localang = vehicle:GetAngles()

		if vehicle.VehicleTable then
			if vehicle.VehicleTable.SW_PassengersBusNew then
			vehicle.VehicleTable.SWBusLastHonkHorn = 0		
			vehicle.VehicleTable.SWBusDoorOpenClose = 0
				for swttpabusn,swttpbbusn in pairs(vehicle.VehicleTable.SW_PassengersBusNew) do
					local SeatPosTPBus = localpos + ( localang:Forward() * swttpbbusn.Pos.x) + ( localang:Right() * swttpbbusn.Pos.y) + ( localang:Up() * swttpbbusn.Pos.z)
					local SeatTPBus = ents.Create( "prop_vehicle_prisoner_pod" )
					SeatTPBus:SetModel( "models/nova/jeep_seat.mdl" )
					SeatTPBus:SetKeyValue( "vehiclescript" , "scripts/vehicles/prisoner_pod.txt" )
					SeatTPBus:SetAngles( localang + swttpbbusn.Ang )
					SeatTPBus:SetPos( SeatPosTPBus )
					SeatTPBus:SetMaterial("models/sligwolf/unique_props/nodraw")
						SeatTPBus:DrawShadow( false )
						SeatTPBus:Spawn()
						SeatTPBus:Activate()
					vehicle:DeleteOnRemove( SeatTPBus )
					SeatTPBus:SetParent(vehicle)
					SeatTPBus:SetCollisionGroup(20)
					end
				end
			end
			
		if vehicle.VehicleTable then
			
			
			
		end

		if vehicle.VehicleTable then
			if vehicle.VehicleTable.BusDoors then	
					
			vehicle.BusDoors = {}
			local swbusdoor = vehicle.VehicleTable.BusDoors
			local BusDoorsAngles = vehicle:GetAngles()
			for swbusdoorsA,swbusdoorsB in pairs(swbusdoor) do
			local BusDoorsPos = vehicle:GetPos() + ( BusDoorsAngles:Forward() * swbusdoorsB.Pos.x ) + ( BusDoorsAngles:Right() * swbusdoorsB.Pos.y ) + ( BusDoorsAngles:Up() * swbusdoorsB.Pos.z )
				vehicle.BusDoors[swbusdoorsA] = ents.Create( "prop_physics" )
				vehicle.BusDoors[swbusdoorsA]:SetModel( "models/sligwolf/bus/bus_doors.mdl" )
				vehicle.BusDoors[swbusdoorsA]:SetPos( BusDoorsPos )
				vehicle.BusDoors[swbusdoorsA]:SetAngles( BusDoorsAngles + swbusdoorsB.Ang )
				vehicle.BusDoors[swbusdoorsA]:DrawShadow( false )
				vehicle.BusDoors[swbusdoorsA]:Spawn()
				vehicle.BusDoors[swbusdoorsA]:SetSolid(6)
				vehicle.BusDoors[swbusdoorsA]:SetParent(vehicle)
				vehicle:DeleteOnRemove( vehicle.BusDoors[swbusdoorsA] )
			end
			end
		end

	end;
--
	function MODULE:SpawnBus( client )
		local bus = ents.Create( "prop_vehicle_jeep" );
		bus:SetModel( "models/sligwolf/bus/bus.mdl" );
		bus:SetKeyValue( "vehiclescript" , "scripts/vehicles/sligwolf/sw_bus.txt" );
		bus:SetPos( self.BusSpawn.pos );
		bus:SetAngles( self.BusSpawn.ang );
		bus:Spawn();
		--bus:keysOwn( client );
		bus:Fire( "Lock" );
		bus.VehicleTable = self.Config.VehicleTab;
		--self:BusDoors( bus );
		client.Bus = bus;
		timer.Simple( 2, function()
			Base.Modules.NetMessage( client, "Bus", bus );
		end );
	end;

	function MODULE:RemoveBus( client )
		if( client.Bus ) then
			if( client.Bus:IsValid() ) then
				client.Bus:Remove();
				client.Bus = nil;
			end;
		end;
	end;

	function MODULE:SetStop( client, stop )
		client.Stop = stop;
		Base.Modules.NetMessage( client, "BusStop", stop );
	end;

	function MODULE:SpawnStops()
		local stops = self.Config.BusStops[string.lower( game.GetMap() )];
		if( stops ) then
			for id,tab in pairs( stops ) do
				local busstop = ents.Create( "busstop" );
				busstop:SetPos( tab.pos );
				busstop:SetAngles( tab.ang );
				busstop:Spawn();
				local physObj = busstop:GetPhysicsObject();
				if( physObj:IsValid() ) then
					physObj:EnableMotion( false );
				end;
	--			print( id );
				self.Stored[id] = busstop;
				if( busstop:IsValid() ) then
					busstop:SetNetworkedInt( "Stop", id );
					busstop:SetNetworkedString( "Location", tab.name );
				end;
			end;
		end;
	end;

	function MODULE.Hooks:InitPostEntity()
		self:SpawnStops();
	end;
	
	function MODULE:OnLoad()
		self.Hooks.OnReloaded( self );
		Base.BusDriver = self;
	end;

--[[
	function OnReloaded:
		Removes all the bus stops on the map then respawns them to reset them
		wait two seconds then send the bus driver his stop
]]--
	function MODULE.Hooks:OnReloaded()
		for _,ent in pairs( ents.FindByClass( "busstop" ) ) do
			ent:Remove();
		end;
		self:SpawnStops();

		timer.Simple( 2, function()
			local client = team.GetPlayers( self.Config.BusTeam )[1];
			if( client ) then
				local stop = 9;
				self:SetStop( client, stop );
				Base.Modules.NetMessage( client, "Bus", client.Bus );
			end;
		end );
	end;

	function MODULE.Hooks:PlayerChangeJob( client, oldTeam, newTeam )
		self:RemoveBus( client );
		if( newTeam == self.Config.BusTeam ) then
			local stop = 8;
			self:SetStop( client, stop );
			self:SpawnBus( client );
		end;
	end;

	function MODULE.Hooks:EntityRemoved( client )
		if( client.Bus ) then
			if( client.Bus:IsValid() ) then
				self:RemoveBus( client );
			end;
		end;
	end;


	/*
		PlayerEnteredVehicle:
			Forces the client to pay a fare when they enter a seat on the bus
	*/
	function MODULE.Hooks:PlayerEnteredVehicle( client, seat, role )
		local busDriver = team.GetPlayers( self.Config.BusTeam )[1];
		if( busDriver and client ~= busDriver ) then
			if( busDriver:IsValid() ) then
				local bus = busDriver:GetVehicle();
				if( bus:IsValid() ) then
					local clients = self:GetBoarded( bus );
					if( table.HasValue( clients, client ) ) then
						local cash = client:GetCash();
						if( cash >= self.Config.BusFare ) then
							busDriver:Notify( "You have been paid $" .. self.Config.BusFare .. "." );
							client:Notify( "You paid a $" .. self.Config.BusFare .. " bus fare." );
							client:AddCash( -self.Config.BusFare );
							local cash = busDriver:GetCash();
							local diff = ( cash + self.Config.BusFare ) - self.Config.CashLimit;
							if( diff > 0 ) then
								busDriver:AddCash( self.Config.CashLimit - cash );
								busDriver:AddBank( diff );
							end;
						else
							timer.Simple( 2, function()
								client:ExitVehicle();
								client:Notify( "You're a dirty hobo who can't afford a bus ride." );
							end );
							
						end;
					end;
				end;
			end;
		end;
	end;

	function MODULE.Hooks:Think()
		for _,client in pairs( team.GetPlayers( self.Config.BusTeam ) ) do
			local bus = client:GetVehicle();
			if( bus:IsValid() ) then
				local stop = self.Config.BusStops[string.lower(game.GetMap())][client.Stop];
				if( stop ) then
					local dist = stop.pos:Distance( bus:GetPos() );
					if( dist <= 300 ) then
						if( bus:GetVelocity():Length() <= 20 ) then
							if( self.Stopped == false ) then
								self.StopTimer = CurTime() + 2;
								self.Stopped = true;
							elseif( self.StopTimer < CurTime() ) then

								client.Stop = client.Stop + 1;
								if( client.Stop > #self.Config.BusStops[string.lower( game.GetMap() )] ) then
									client.Stop = 1;
								end;
								
								Base.Modules:NetMessage( client, "BusStop", client.Stop );
								client:Notify( "You recieved $" .. self.Config.AmountPerStop .. " for stopping at a bus stop!" );
								local cash = client:GetCash();
								local diff = ( cash + self.Config.BusFare ) - self.Config.CashLimit;
								if( diff > 0 ) then
									client:AddCash( self.Config.CashLimit - cash );
									client:AddBank( diff );
								else
									client:AddCash( self.Config.AmountPerStop );
								end;

								self.Stopped = false;
							end;
						else
							self.Stopped = false;
						end;
					end;
				end;
			end;
		end;
	end;
	
	
else

	function MODULE:DrawBus( pos, color )
		local scrPos = pos:ToScreen();
		local col = Color( 150, 50, 50 );

		if( color ) then
			col = color;
		end;

		surface.SetFont( "HUDXSmall_Alpha" );
		local w, h = surface.GetTextSize( "Bus Spawn" );
	

		scrPos.x = math.Clamp( scrPos.x, w / 2 + 4, ScrW() - w / 2 );
		scrPos.y = math.Clamp( scrPos.y, h + 16, ScrH() + 10 ) - 20;
		
		
		surface.SetDrawColor( Color( 255, 255, 255 ) );
		
		surface.DrawRect( scrPos.x - 5 - w / 2, scrPos.y - 2 - h / 2 - 10, w + 10, h );
		
		surface.SetDrawColor( col );
		surface.DrawRect( scrPos.x - 5 - w / 2, scrPos.y - 2 - h / 2 - 10, 4, h );
		--draw.RoundedBox( 2, scrPos.x - self.Config.DotSize, scrPos.y - self.Config.DotSize , self.Config.DotSize, self.Config.DotSize + 1, teamColor );
		
		surface.SetFont( "HUDXSmall_Alpha" );
		surface.SetTextColor( Color( 0, 0, 0 ) );
		surface.SetTextPos( scrPos.x - w / 2 + 4, scrPos.y - h / 2 - 12 );
		surface.DrawText( "Bus Spawn" );
		
		surface.SetTextColor( col );
		surface.SetTextPos( scrPos.x - w / 2 + 4, scrPos.y - h / 2 - 12 );
		surface.DrawText( "Bus Spawn" );
	end;
	
	function MODULE:DrawStop( pos, color )
		local scrPos = pos:ToScreen();
		local col = Color( 50, 150, 50 );

		if( color ) then
			col = color;
		end;

		surface.SetFont( "HUDXSmall_Alpha" );
		local w, h = surface.GetTextSize( "Bus Stop" );
	

		scrPos.x = math.Clamp( scrPos.x, w / 2 + 4, ScrW() - w / 2 );
		scrPos.y = math.Clamp( scrPos.y, h + 16, ScrH() + 10 ) - 20;
		
		
		surface.SetDrawColor( Color( 255, 255, 255 ) );
		
		surface.DrawRect( scrPos.x - 5 - w / 2, scrPos.y - 2 - h / 2 - 10, w + 10, h );
		
		surface.SetDrawColor( col );
		surface.DrawRect( scrPos.x - 5 - w / 2, scrPos.y - 2 - h / 2 - 10, 4, h );
		--draw.RoundedBox( 2, scrPos.x - self.Config.DotSize, scrPos.y - self.Config.DotSize , self.Config.DotSize, self.Config.DotSize + 1, teamColor );
		
		surface.SetFont( "HUDXSmall_Alpha" );
		surface.SetTextColor( Color( 0, 0, 0 ) );
		surface.SetTextPos( scrPos.x - w / 2 + 4, scrPos.y - h / 2 - 12 );
		surface.DrawText( "Bus Stop" );
		
		surface.SetTextColor( col );
		surface.SetTextPos( scrPos.x - w / 2 + 4, scrPos.y - h / 2 - 12 );
		surface.DrawText( "Bus Stop" );
	end;


	function MODULE.Nets:BusStop()
		local stop = net.ReadFloat();
--		print( stop );
		self.CurrentStop = stop;
	end;

	function MODULE.Nets:Bus()
		local bus = net.ReadEntity();
--		print( bus );
		self.Bus = bus;
	end;

	function MODULE.Hooks:PreBlipDraw()
		if( self.Bus ) then
			if( self.Bus:IsValid() ) then
				local pos = Base.Minimap:GetRadarPos( self.Bus:GetPos() );
				if( Base.Minimap:ShouldDrawPos( pos ) ) then
					surface.SetDrawColor( 150, 50, 50 );
					surface.DrawRect( pos.x - 7.5, pos.y - 15, 15, 30 );
				end;
			end;
		end;
	end;

	function MODULE.Hooks:PostBlipDraw()
		for _,ent in pairs( ents.FindByClass( "busstop" ) ) do
			local pos = ent:GetPos();
			if( Base.Minimap:ShouldDrawPos( pos ) ) then
				pos = Base.Minimap:GetRadarPos( pos );
				surface.SetDrawColor( Color( 255, 255, 255 ) );
				if( ent:GetNetworkedInt( "Stop" ) == self.CurrentStop ) then
					surface.SetDrawColor( Color( 50, 150, 50 ) );
					self.CurrentStopEnt = ent;
				end;
				surface.DrawRect( pos.x - 5, pos.y - 2.5, 10, 5 );
			end;
		end;
	end;
	--MODULE.CurrentStop = math.random( 1, #MODULE.Config.Stops );--
	function MODULE.Hooks:HUDPaint()
		if( LocalPlayer().jobName == self.Config.BusTeam ) then
			--if( self.CurrentStopEnt ) then
				--if( self.CurrentStopEnt:IsValid() ) then
				if( self.CurrentStop ) then
					if( self.Config.BusStops ) then
						local stop = self.Config.BusStops[string.lower(game.GetMap())][self.CurrentStop];
						if( stop ) then
							self:DrawStop( stop.pos );
						else
							
						end;
					end;
				end;

				for _,ent in pairs( ents.FindByClass( "busstop" ) ) do
					local seats = ent.Seats;
					if( seats ) then
						for _,seats in pairs( seats ) do
							local passenger = seat:GetDriver();
							if( passenger ) then
								if( passenger:IsValid() ) then
									self:DrawStop( ent:GetPos(), Color( 150, 50, 50 ) );
								end;
							end;
						end;
					end;
				end;

				self:DrawBus( self.BusSpawn.pos );
			--end;
		end;
		local bus = LocalPlayer():GetVehicle();
			if( bus:IsValid() ) then
				local pos1, pos2 = ( bus:GetPos() - bus:GetForward() * 50 + bus:GetRight() * 180 ), bus:GetPos() + Vector( 0, 0, 10 ) + bus:GetForward() * 60 - bus:GetRight() * 120 + Vector( 0, 0, 120 );
				pos1, pos2 = pos1:ToScreen(), pos2:ToScreen();
				surface.SetDrawColor( Color( 255, 255, 255 ) );
				surface.DrawRect( pos1.x, pos1.y, 10, 10 );
				
				surface.SetDrawColor( Color( 225, 0, 0 ) );
				surface.DrawRect( pos2.x, pos2.y, 10, 10 );
			end;
	end;

	
end;


Base.Modules:RegisterModule( MODULE );

--Code to respawn bus stops
/*
for _,ent in pairs( ents.FindByClass( "busstop" ) ) do
	ent:Remove();
end;
MODULE:SpawnStops();

timer.Simple( 2, function()
	local client = team.GetPlayers( self.Config.BusTeam )[1];
	if( client ) then
		local stop = 9;
		MODULE:SetStop( client, stop );
		Base.Modules.NetMessage( client, "Bus", client.Bus );
	end;
end );
*/