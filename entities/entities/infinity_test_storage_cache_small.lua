AddCSLuaFile()

DEFINE_BASECLASS("base_gmodentity")

ENT.PrintName = "Test Storage Small"
ENT.Author = "Divran"
ENT.Contact = "arviddivran@gmail.com"
ENT.Purpose = "herp"
ENT.Instructions = "derp"

ENT.Spawnable = true
ENT.AdminOnly = false

function ENT:SpawnFunction(ply, tr)
	if (not tr.HitWorld) then return end

	local ent = ents.Create("infinity_test_storage_cache")
	if IsValid(ent) then
		ent:SetPos( tr.HitPos + Vector(0,0,50) )
		ent:SetModel("models/hunter/blocks/cube2x2x2.mdl")
		ent:Spawn()
	end

	return ent
end

-- this entity is temporary until we get a tool