
AddCSLuaFile()

DEFINE_BASECLASS( "base_anim" )

ENT.PrintName		= "Resource Log"
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
	
		self:SetModel( "models/props_docks/channelmarker_gib01.mdl" )
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
		activator:AddResource( "Wood", amount );
		
	end

end
