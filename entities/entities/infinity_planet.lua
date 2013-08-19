AddCSLuaFile()
DEFINE_BASECLASS("base_anim")

local GM = GAMEMODE

ENT.PrintName = "Infinity Planet"
ENT.Author = "Radon"
ENT.Contact = "radon@inp.io"

ENT.celestial = nil -- This refers to what will be the parent object which houses env and ent data

ENT.Spawnable = false
ENT.AdminOnly = false

function ENT:Initialize()
	if SERVER then

		self:SetModel("models/props_lab/huladoll.mdl")
		self:SetMoveType( MOVETYPE_NONE ) -- We don't want these planets to move
		self:SetSolid( SOLID_NONE ) -- We want people to be able to pass through it...
		self:PhysicsInitSphere( 1 ) -- Create a standard physics sphere
		self:SetCollisionBounds( Vector(-1,-1,-1), Vector(1,1,1) )
		self:SetTrigger( true )
		self:GetPhysicsObject():EnableMotion( false ) -- DON'T MOVE!
		self:DrawShadow( false ) -- That would be bad.

		local phys = self:GetPhysicsObject()
		if phys:IsValid() then
			phys:Wake()
		end

		self:SetNotSolid(true) -- It's not solid ofc

	end
end

if SERVER then

	function ENT:StartTouch( ent )
		--Add player to the environment
		self:getCelestial():getEnvironment():addEntity( ent )
		print("Begin Tocuh", self)
	end

	function ENT:EndTouch( ent )
		--Remove player from the environment
		self:getCelestial():getEnvironment():removeEntity( ent )
		print("End Touch", self)
	end

	function ENT:Think()
		self:getCelestial():Think()
	end

end

if CLIENT then

	function ENT:Draw()
	    -- Ensure the client doesn't see the huladoll
	end

end

function ENT:CanTool()
	return false -- So the ent cannot be tooled ( parent, rope etc )
end

function ENT:GravGunPunt()
	return false -- So the player can't move the planet
end

function ENT:GravGunPickupAllowed()
	return false -- So the player can't pick the planet up and run off with it.
end
