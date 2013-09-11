AddCSLuaFile()

DEFINE_BASECLASS("infinity_base_storage")

ENT.PrintName = "SB Infinity Generator"
ENT.Author = "Divran"
ENT.Contact = "arviddivran@gmail.com"
ENT.Purpose = "Base for resource generation"
ENT.Instructions = "Derive from this for anything with resource generation"

ENT.Spawnable = false
ENT.AdminOnly = false

function ENT:Setup()
	self:SetupWirePorts()
end

function ENT:GetWirePorts()
	local inputs, outputs = self.BaseClass:GetWirePorts()
	inputs[#inputs+1] = "On"
	inputs[#inputs+1] = "Multiplier"
	return inputs, outputs
end

function ENT:Think()
	if self:IsOn() then
		self:Generate()
	end
end

function ENT:Generate()
end

function ENT:IsOn()
	return self.on
end

function ENT:Toggle()
	if not self:IsLinked() then return end

	if self:IsOn() then
		self.on = false
	else
		self.on = true
	end
end

function ENT:Use( ply )
	if hook.Run( "CanTool", ply, { Entity = self }, "sb_canuse" ) then
		self:Toggle()
	end
end

-- Init register ( use ENUM )

-- Hook onto draw for world/hud tips

-- Off/On methods + Toggle

-- Restore support & GarryDupe