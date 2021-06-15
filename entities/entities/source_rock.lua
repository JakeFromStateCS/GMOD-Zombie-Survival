
AddCSLuaFile()

DEFINE_BASECLASS( "base_gmodentity" )

ENT.PrintName		= "Source Rock"
ENT.Author			= "Matt."
ENT.Information		= "A rock that can be mined"
ENT.Category		= "BLRP"

ENT.Editable		= true
ENT.Spawnable		= true
ENT.AdminOnly		= false
ENT.RenderGroup		= RENDERGROUP_TRANSLUCENT


--[[---------------------------------------------------------
   Name: Initialize
-----------------------------------------------------------]]
function ENT:Initialize()

	if ( SERVER ) then
		self:SetModel( "models/props_canal/rock_riverbed02c.mdl" )
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetMoveType( MOVETYPE_VPHYSICS )
		self:SetSolid( SOLID_VPHYSICS )
		self:SetUseType( SIMPLE_USE )
		self.Damage = 0;
		local phys = self:GetPhysicsObject()
		if ( IsValid( phys ) ) then
			phys:EnableMotion( false )
		end
	end;
	
	local health = math.random( 100, 400 );
	self:SetNWInt( "Health", health );
	self:SetNWInt( "StartingHP", health );
end


if ( CLIENT ) then

	function ENT:Draw()
		self:DrawModel();
		
		local health = self:GetNWInt( "Health" );
		local startHP = self:GetNWInt( "StartingHP" );
		local pos = self:GetPos() + self:GetUp() * 10 - self:GetForward() * 30;
		local ang = self:GetAngles() + Angle( 0, -90, -90 );--( pos - LocalPlayer():GetPos() ):Angle() + Angle( 0, -90, -90 );
		--ang.p = 90;
		local barWidth = 40;
		cam.Start3D2D( pos, ang, 0.5 );
			surface.SetDrawColor( Color( 255, 150, 150 ) );
			surface.DrawRect( -barWidth / 2, 0, barWidth / startHP * health, 5 );
		cam.End3D2D();
	end

end



--[[---------------------------------------------------------
   Name: OnTakeDamage
-----------------------------------------------------------]]
function ENT:OnTakeDamage( dmgInfo )

	local damage = dmgInfo:GetDamage();
	local health = self:GetNWInt( "Health" );
	local startHP = self:GetNWInt( "StartingHP" );
	if( health - damage <= 0 ) then
		local max = math.ceil( startHP / 100 );
		for i=1,max do
			local rock = ents.Create( "resource_rock" );
			rock:SetPos( self:GetPos() + self:GetUp() * ( i * 50 ) );
			rock:SetAngles( Angle( 0, 0, 0 ) );
			rock:Spawn();
			rock:SetNWInt( "Amount", 1 );
		end;
		self:Remove();
	else
		local max = math.ceil( startHP / 100 );
		self:SetNWInt( "Health", health - damage );
		self.Damage = self.Damage + damage;
		print( self.Damage );
		if( self.Damage >= 20 ) then
			local val = math.floor( self.Damage / 20 );
			local remain = self.Damage - val * 20;
			
			print( remain );
			self.Damage = remain;
			
			local offsetRight = math.random( -3, 3 ) * 5;
			local offsetUp = math.random( 1, 3 ) * 10;
			
			local rock = ents.Create( "resource_rock" );
			rock:SetPos( self:GetPos() + self:GetUp() * offsetUp + self:GetRight() * offsetRight - self:GetForward() * offsetUp );
			rock:SetAngles( Angle( 0, 0, 0 ) );
			rock:Spawn();
			rock:SetNWInt( "Amount", 1 );
		end;
	end;
end


--[[---------------------------------------------------------
   Name: Use
-----------------------------------------------------------]]
function ENT:Use( activator, caller )

	--self:Remove()
	
	

end
