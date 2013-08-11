AddCSLuaFile()
DEFINE_BASECLASS("base_anim")

local GM = GAMEMODE

ENT.PrintName = "Infinity Planet"
ENT.Author = "Radon"
ENT.Contact = "radon@inp.io"

ENT.celestial = nil -- This refers to what will be the parent object which houses env and ent data

ENT.Spawnable = false
ENT.AdminOnly = false



function genMesh(r)
	if(type(r) == "number") then
		--Icosphere of R radius
		local Mesh = {}
		
		return Mesh
	else
		--Unit Icosphere
		local Mesh = {}
		
		
		
		return Mesh
	
	end
end




function ENT:Initialize()
	if SERVER then

		self:SetModel("models/props_lab/huladoll.mdl")	
		self:SetMoveType( MOVETYPE_NONE ) -- We don't want these planets to move
		self:SetSolid( SOLID_NONE ) -- We want people to be able to pass through it...
		self:PhysicsFromMesh(
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

	function ENT:getCelestial()
		return self.celestial
	end

	function ENT:setCelestial( c )
		if not c.is_A or not c:is_A( GM.class.getClass("Celestial") ) then error("Expected celestial to be a Celestial Object, got "..c:getClass() or type(c)) return end
		self.celestial = c
		return
	end

	function ENT:StartTouch( ent )
		--Add player to the environment
	end

	function ENT:EndTouch( ent )
		--Remove player from the environment
	end

	function ENT:Think()
		if self:getCelestial() then
			self:getCelestial():Think() -- Call the super to think
		end

		self:NextThink( CurTime() + 0.2 )
	end

end

if CLIENT then

	--function ENT:Draw()
	    -- Ensure the client doesn't see the huladoll
	--end

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
