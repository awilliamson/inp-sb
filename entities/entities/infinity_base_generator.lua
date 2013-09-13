AddCSLuaFile()

DEFINE_BASECLASS("infinity_node")

ENT.PrintName = "SB Infinity Generator"
ENT.Author = "Divran"
ENT.Contact = "arviddivran@gmail.com"
ENT.Purpose = "Base for resource generation"
ENT.Instructions = "Derive from this for anything with resource generation"

ENT.Spawnable = false
ENT.AdminOnly = false

if CLIENT then return end

function ENT:Setup()
	self:SetMultiplier( 1 )
	self:SetBaseMultiplier( self:GetPhysicsObject():GetVolume() / 1000 )
	self:SetupWirePorts()
	self:SetUseType( SIMPLE_USE )
end

function ENT:GetWirePorts()
	local inputs, outputs = {}, {}
	inputs[#inputs+1] = "On"
	inputs[#inputs+1] = "Multiplier"
	outputs[#outputs+1] = "On"
	return inputs, outputs
end

function ENT:TriggerInput( name, value )
	if name == "On" then
		if value ~= 0 and not self:IsOn() or value == 0 and self:IsOn() then
			self:Toggle()
		end
	elseif name == "Multiplier" then
		self:SetMultiplier( math.max( value, 0 ) )
	end
end

function ENT:Think()
	if self:IsOn() then
		if not self:IsLinked() then
			self.on = false
		else
			self:Generate()
		end
	end
	self:UpdateOutputs()
	self:NextThink( CurTime() + 1 )
	return true
end

function ENT:Generate()
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
	
	WireLib.TriggerOutput( self, "On", self:IsOn() and 1 or 0 )
end

function ENT:Use( ply )
	self:Toggle()
end