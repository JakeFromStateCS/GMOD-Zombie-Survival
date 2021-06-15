
AddCSLuaFile()

DEFINE_BASECLASS( "base_anim" )

ENT.PrintName		= "Resource Rock"
ENT.Author			= "Matt."
ENT.Information		= "A rock that can be used for crafting"
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
	
		self:SetModel( "models/props_wasteland/rockgranite03b.mdl" )
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetMoveType( MOVETYPE_VPHYSICS )
		self:SetSolid( SOLID_VPHYSICS )
		self:SetUseType( SIMPLE_USE )
		local phys = self:GetPhysicsObject()
		if ( IsValid( phys ) ) then
			phys:Wake()
		end
	end
	
end


if ( CLIENT ) then

	function ENT:Draw()
		
		self:DrawModel();
		
	end

end

function ENT:Use( activator, caller )

	self:Remove()
	
	if ( activator:IsPlayer() ) then
		local amount = self:GetNWInt( "Amount" );
		activator:AddResource( "Stone", amount );
		
	end

end
