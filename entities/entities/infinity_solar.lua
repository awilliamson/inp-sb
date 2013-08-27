AddCSLuaFile()

DEFINE_BASECLASS("infinity_base_generator")

ENT.PrintName = "Solar Generator"
ENT.Author = "Radon"
ENT.Contact = "sb@inp.io"
ENT.Purpose = "Generating energy from solar power"
ENT.Instructions = "Point the top purple/black bit towards to hot glowly thing"

ENT.Spawnable = true
ENT.AdminOnly = false

function ENT:Initialize()
	BaseClass.Initialize( self )
	if SERVER then
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetMoveType( MOVETYPE_VPHYSICS )
		self:SetSolid( SOLID_VPHYSICS )

		-- Wake up to party
		local phys = self:GetPhysicsObject()
		if phys and phys:IsValid() then
			phys:Wake()
		end

		self.active = true --- TODO Change this to ent getter and setter later

	end
end

function ENT:SpawnFunction(ply, tr)
	if (not tr.HitWorld) then return end

	local ent = ents.Create("infinity_solar")
	if IsValid(ent) then
		ent:SetPos( tr.HitPos + Vector(0,0,50))
		ent:SetModel("models/props_phx/life_support/panel_medium.mdl")
		ent:Spawn()
	end

	return ent
end

function ENT:SetActive() --disable use, lol
end

if SERVER then

	function ENT:getRate()
	end

	function ENT:Think()
		self:NextThink( CurTime() + 1 )
	end

end
