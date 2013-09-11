AddCSLuaFile()

DEFINE_BASECLASS("infinity_base_storage")

ENT.PrintName = "SB Infinity Test Storage Cache"
ENT.Author = "Divran"
ENT.Contact = "arviddivran@gmail.com"
ENT.Purpose = "herp"
ENT.Instructions = "derp"

ENT.Spawnable = true
ENT.AdminOnly = false

function ENT:SpawnFunction(ply, tr)
	if (not tr.HitWorld) then return end

	local ent = ents.Create("test_storage_cache")
	if IsValid(ent) then
		ent:SetPos( tr.HitPos + Vector(0,0,50) )
		ent:SetModel("models/hunter/blocks/cube4x4x4.mdl")
		ent:Spawn()
		ent:Setup()
	end

	return ent
end

function ENT:Setup()
	self:SetMaxStorage( {
		Energy = 10000,
		Oxygen = 10000,
	} )
		
	self:SetupWirePorts()
	self:UpdateOutputs()
end

function ENT:GetWirePorts()
	local inputs, outputs = self.BaseClass:GetWirePorts()
	for name,_ in pairs( self:GetMaxStorage() ) do
		inputs[#inputs+1] = "Vent " .. name
		outputs[#outputs+1] = name
		outputs[#outputs+1] = "Max " .. name
	end
	return inputs, outputs
end

function ENT:UpdateOutputs()
	--[[
	for name,_ in pairs( self:GetMaxStorage() ) do
		WireLib.TriggerOutput( self, "Max " .. name, self:GetMaxAmount( name ) or 0 )
		WireLib.TriggerOutput( self, name, self:GetAmount( name ) or 0 )
	end
	]]
end