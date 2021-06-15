AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:SetResourceType( name )
	self:SetNWString( "ResourceType", name );
end;

function ENT:SetResourceAmount( amount )
	self:SetNWInt( "ResourceAmount", amount );
end;

function ENT:Initialize()
	self.Destructed = false
	self:SetModel("models/Items/item_item_crate.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self.locked = true
	
	local phys = self:GetPhysicsObject()
	phys:Wake()
	self:SetResourceType( "Stone" );
	self:SetResourceAmount( 1 );
end

function ENT:Use()
	
end
