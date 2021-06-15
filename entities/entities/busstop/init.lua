AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/props_trainstation/bench_indoor001a.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self.Seats = {};
	local phys = self:GetPhysicsObject()

	phys:Wake()

	self.damage = 10

	for i=1, 4 do
		local Seat = ents.Create( "prop_vehicle_prisoner_pod" );
		Seat:SetModel( "models/nova/chair_wood01.mdl" );
		Seat:SetKeyValue( "vehiclescript" , "scripts/vehicles/prisoner_pod.txt" );
		Seat:SetPos( self:GetPos() - Vector( 0, 0, 17 ) + self:GetRight() * ( i - 1 ) * 20 - self:GetRight() * 30 );
		Seat:SetAngles( self:GetAngles() - Angle( 0, 90, 0 ) );
		Seat:SetParent( self );
		Seat:Spawn();
		Seat:SetRenderMode( 1 );
		Seat:SetColor( Color( 255, 255, 255, 0 ) );
		--Seat:setKeysNonOwnable( true );
		local physObj = Seat:GetPhysicsObject();
		if( physObj:IsValid() ) then
			physObj:EnableMotion( false );
			physObj:EnableCollisions( false );
		end;
		self.Seats[i] = Seat;
	end;
end

function ENT:OnTakeDamage(dmg)
	self.damage = self.damage - dmg:GetDamage()

	if (self.damage <= 0) then
		local effectdata = EffectData()
		effectdata:SetOrigin(self:GetPos())
		effectdata:SetMagnitude(2)
		effectdata:SetScale(2)
		effectdata:SetRadius(3)
		util.Effect("Sparks", effectdata)
		--self:Remove()
	end
end

function ENT:Use(activator,caller)
	
	--self:Remove()
end

function ENT:OnRemove()	
end