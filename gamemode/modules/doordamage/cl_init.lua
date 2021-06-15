MODULE = MODULE or {};
MODULE.Hooks = {};
MODULE.Nets = {};
MODULE.Name = "Door Damage"; 
MODULE.Stored = {};
MODULE.Doors = {};
MODULE.DoorTimes = {};
MODULE.Config = {};
MODULE.Config.DoorHealth = 200;
MODULE.Config.DoorClasses = {
	"func_door",
	"prop_door_rotating",
	"prop_door_dynamic",
	"prop_door"
}
MODULE.Config.ResetTime = 300;

function MODULE.Nets:DoorInfo()
	local ent = net.ReadEntity();
	local door = net.ReadEntity();
	local time = net.ReadFloat();
	self.Stored[ent] = door;
	self.DoorTimes[ent] = time;
	door.DeathTime = time;
	door.ResetTime = time + self.Config.ResetTime;
	door.Door = ent;
--	print( door, ent, time );
end;

function MODULE.Hooks:Think()
	for ent,time in pairs( self.DoorTimes ) do
		if( time + self.Config.ResetTime < CurTime() ) then
			self.Stored[ent] = nil;
			self.DoorTimes[ent] = nil;
		end;
	end;
end;

Base.Modules:RegisterModule( MODULE );