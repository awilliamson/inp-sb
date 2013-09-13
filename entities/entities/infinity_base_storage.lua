AddCSLuaFile()

DEFINE_BASECLASS("infinity_node")

ENT.PrintName = "SB Infinity Storage"
ENT.Author = "Divran"
ENT.Contact = "arviddivran@gmail.com"
ENT.Purpose = "Base for storage entities"
ENT.Instructions = "Derive from this for anything with resource storage"

ENT.Spawnable = false
ENT.AdminOnly = false

if CLIENT then return end

function ENT:GetWirePorts() return {}, {} end

function ENT:Setup()
	self:SetMultiplier( 1 )
	self:SetBaseMultiplier( self:GetPhysicsObject():GetVolume() / 1000 )
end

function ENT:SetMultiplier( mul )
	self.mul = mul
end

function ENT:GetMultiplier()
	return self.mul
end

function ENT:GetBaseMultiplier()
	return self.basemul
end

function ENT:SetBaseMultiplier( mul )
	self.basemul = mul
end

function ENT:UpdateOutputs() end