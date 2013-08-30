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
	if ent ~= nil and IsEntity( ent ) then
		if not ent.getCelestial or ent:getCelestial() ~= self then
			local this = self
			ent.getCelestial = function()
				return this
			end
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

		if not env.getCelestial or env:getCelestial() ~= self then
			local this = self
			env.getCelestial = function()
				return this
			end
		end

		self.env = env
	else
		return false
	end
end

function C:Think()
	self:getEnvironment():Think()
end

GM.class.registerClass("Celestial", C)