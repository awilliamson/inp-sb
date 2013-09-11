AddCSLuaFile()

DEFINE_BASECLASS("infinity_base_generator")

ENT.PrintName = "Solar Generator"
ENT.Author = "Radon"
ENT.Contact = "sb@inp.io"
ENT.Purpose = "Generating energy from solar power"
ENT.Instructions = "Point the top purple/black bit towards to hot glowly thing"

ENT.Spawnable = true
ENT.AdminOnly = false


function ENT:SpawnFunction(ply, tr)
	if (not tr.HitWorld) then return end

	local ent = ents.Create("infinity_solar")
	if IsValid(ent) then
		ent:SetPos( tr.HitPos + Vector(0,0,50) )
		ent:SetModel("models/props_phx/life_support/panel_medium.mdl")
		ent:Spawn()
		ent:Setup()
	end

	return ent
end

function ENT:GetWirePorts()
	local inputs, outputs = self.BaseClass:GetWirePorts()
	outputs[#outputs+1] = "Generated Energy"
	return inputs, outputs
end

function ENT:Generate()
	self:SupplyResource( "Energy", 10 )
end

if CLIENT then
	function ENT:Draw()
		if GAMEMODE:fuzzyLook(self) then
			GAMEMODE:AddWorldTip(self:EntIndex(), nil, 0.5, self:GetPos(), self)
		end

		self:DrawModel()
	end
end