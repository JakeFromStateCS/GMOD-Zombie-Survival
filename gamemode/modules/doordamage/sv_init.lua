MODULE = MODULE or {};
MODULE.Hooks = {};
MODULE.Nets = {};
MODULE.Name = "Door Damage"; 
MODULE.Stored = {};
MODULE.Doors = {};
MODULE.DoorTimes = {};
MODULE.Config = {};
MODULE.Config.DoorHealth = 100;
MODULE.Config.DoorClasses = {
	"func_door",
	"prop_door_rotating",
	"prop_door_dynamic",
	"prop_door"
}
MODULE.Config.ResetTime = 60;

function MODULE:PostLoad()
	timer.Simple( 2, function()
	for _,class in pairs( self.Config.DoorClasses ) do
		local ents = ents.FindByClass( class );
		for _,ent in pairs( ents ) do
			self:AttachDoor( ent );
		end;
	end;
	for _,ent in pairs( ents.FindByClass( "prop_physics" ) ) do
		if( ent.Door ) then
			ent:Remove();
		end;
	end;
	end );
	Base.DoorDamage = self;
end;

function MODULE:GetHealth( ent )
	return self.Stored[ent];
end;

function MODULE:SetHealth( ent, health )
	self.Stored[ent] = health;
	ent:SetNetworkedInt( "Health", health );
end;

function MODULE:DetachDoor( ent, dmgInfo )
	local vel = Vector( 0, 0, 0 );
	if( dmgInfo ) then
		local attacker = dmgInfo:GetAttacker();
		if( attacker:IsValid() ) then
			if( attacker:IsPlayer() ) then
				vel = attacker:GetForward() * dmgInfo:GetDamage() * 5;
			end;
		end;

	end;
	ent:SetRenderMode( 1 );
	ent:SetColor( Color( 255, 255, 255, 0 ) );
	ent:SetCollisionGroup( COLLISION_GROUP_IN_VEHICLE );
	local door = ents.Create( "prop_physics" );
	door:SetModel( ent:GetModel() );
	door:SetPos( ent:GetPos() );
	door:SetAngles( ent:GetAngles() );
	door:Spawn();
	door:SetMaterial( ent:GetMaterial() );
	door.Door = true;
	door.Parent = ent;
	door:SetNetworkedBool( "Door", true );
	local physObj = door:GetPhysicsObject();
	if( physObj:IsValid() ) then
		--( vel );
		physObj:SetVelocity( vel );
	end;
	self.Doors[ent] = door;
	self.DoorTimes[ent] = CurTime();
	timer.Simple( 1, function()
		Base.Modules:NetMessage( "DoorInfo", ent, door, self.DoorTimes[ent] );
	end );
end;

function MODULE:AttachDoor( ent )
	local door = self.Doors[ent];
	if( door ) then
		ent:Fire( "Open" );
		if( door:IsValid() ) then
			door:Remove();
		end;
		self.Doors[ent] = nil;
	end;
	ent:SetColor( Color( 255, 255, 255, 255 ) );
	ent:SetRenderMode( 0 );
	ent:SetCollisionGroup( COLLISION_GROUP_NONE );
	self:SetHealth( ent, self.Config.DoorHealth );
	self.DoorTimes[ent] = nil;
end;

function MODULE.Hooks:EntityTakeDamage( ent, dmgInfo )
	local attacker = dmgInfo:GetAttacker();
	local damage = dmgInfo:GetDamage();
	--print( ent, attacker, damage );
	if( attacker:IsPlayer()  ) then
		if( attacker:Team() == TEAM_REPAIR  ) then
			return;
		end;
		if( table.HasValue( self.Config.DoorClasses, ent:GetClass() ) ) then
			local health = self:GetHealth( ent );
			if( health ) then
				local newHP = health - damage;
				if( newHP > 0 ) then
					self:SetHealth( ent, newHP );
				else
					self:DetachDoor( ent, dmgInfo );
				end;
			end;
		end;
	end;
end;

function MODULE.Hooks:Think()
	for ent,time in pairs( self.DoorTimes ) do
		if( time + self.Config.ResetTime < CurTime() ) then
			self:AttachDoor( ent );
		end;
	end;
end;

Base.Modules:RegisterModule( MODULE );