-- Some base celestial stuff in here, mainly to do with ent tying in.
local GM = GM

local C = GM.LCS.class({
	env = nil,
	ent = nil
})

function C:init(ent, env)
	self:setEntity(ent or self:getEntity() )
	self:setEnvironment(env or self:getEnvironment() )
end

function C:getEntity()
	return self.ent
end

function C:setEntity( ent )
	if ent ~= nil and ent.isValid and ent:isValid() then
		if not ent:getCelestial() or ent:getCelestial() ~= self then
			ent:setCelestial( self )

			print("Celestial: (should be false) ", (env:getCelestial() ~= self) )
		end

		self.ent = ent
	else
		return false
	end
end

function C:getEnvironment()
	return self.env
end

function C:setEnvironment( env )
	if env ~= nil and env.is_A and env:is_A( GM.class.getClass("Environment")) then
		if not env:getCelestial() or env:getCelestial() ~= self then
			env:setCelestial( self )

			print("Celestial: (should be false) ", (env:getCelestial() ~= self) )
		end

		self.env = env
	else
		return false
	end
end

function C:Think()
	-- We don't need to run Think on ent as that's what started all this.
	self:getEnvironment():Think() -- Cause env to update things
end

GM.class.registerClass("Celestial", C)