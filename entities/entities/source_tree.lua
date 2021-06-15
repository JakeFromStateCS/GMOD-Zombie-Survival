
AddCSLuaFile()

DEFINE_BASECLASS( "base_gmodentity" )

ENT.PrintName		= "Source Tree"
ENT.Author			= "Matt."
ENT.Information		= "A tree that can be cut down for wood"
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
		self:SetModel( "models/props_foliage/tree_deciduous_01a-lod.mdl" )
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetMoveType( MOVETYPE_VPHYSICS )
		self:SetSolid( SOLID_VPHYSICS )
		self:SetUseType( SIMPLE_USE )
		local phys = self:GetPhysicsObject()
		if ( IsValid( phys ) ) then
			phys:EnableMotion( false )
		end
	else

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
		local ang = self:GetAngles() + Angle( 0, -90, -90 )--( self:GetPos() - LocalPlayer():GetPos() ):Angle() + Angle( 0, -90, -90 );
		local pos = self:GetPos() + self:GetUp() * 50 - self:GetForward() * 10;
		local barWidth = 40;
		local scale = 0.1;
		--cam.Start3D2D( pos, ang, 0.5 );
			--surface.SetDrawColor( Color( 255, 150, 150 ) );
			--surface.DrawRect( -barWidth / 2, 0, barWidth / startHP * health, 5 );
		--cam.End3D2D();
		
		cam.Start3D2D( self:GetPos() + self:GetUp() * 3, self:GetAngles(), scale );
			local maxSize = 150 / ( scale * 2 );
			local size = maxSize / startHP * health;
			local maxCornerRad = math.floor( maxSize / 4 );
			local cornerRad = math.floor( size / 24 );
			draw.RoundedBox( maxCornerRad, -maxSize / 2, -maxSize / 2, maxSize, maxSize, Color( 0, 0, 0, 200 ) );
			draw.RoundedBox( cornerRad, -size / 2, -size / 2, size, size, Color( 255, 150, 150, 200 ) );
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
		for i=1,math.random( 3, max * 2 ) do
			local log = ents.Create( "resource_log" );
			log:SetPos( self:GetPos() + self:GetUp() * ( i * 50 ) );
			log:SetAngles( Angle( 0, 0, 0 ) );
			log:Spawn();
			log:SetNWInt( "Amount", 1 );
		end;
		self:Remove();
	else
		self:SetNWInt( "Health", health - damage );
		self.attacker = dmgInfo:GetAttacker();
	end;
end


--[[---------------------------------------------------------
   Name: Use
-----------------------------------------------------------]]
function ENT:Use( activator, caller )



end
