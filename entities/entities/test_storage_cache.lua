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
	end

	return ent
end

function ENT:Setup()
	local storage = {}
	
	for name,_ in pairs( GAMEMODE:getResourceTypes() ) do
		storage[name] = GAMEMODE:newResource( name )
		storage[name]:setMaxAmount( 10000 )
	end

	self:SetStorage( storage )
end