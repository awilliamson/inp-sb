-- Class for environments which will be bound to celestial objects

local GM = GM

local C = GM.LCS.class({
	name = "",
	gravity = 0,
	atmosphere = 0,
	temperature = 0,
	pressure = 0,
	radius = 0,
	resources = {},
	entities = {},
	celestial = nil
})

function C:init(g,t,a, r, res, n)
	self:setName( n or self:getName() )
	self:setGravity( g or self:getGravity() )
	self:setTemperature( t or self:getTemperature() )
	self:setAtmosphere( a or self:getAtmosphere() )
	self:setResources( res or self:getResources() )
	self:setRadius( r or self:getRadius() )
	self:setPressure( self:getGravity() * self:getAtmosphere() )
end

function C:getName()
	return self.name
end

function C:describe()
	return self:getName()
end

function C:setName( n )
	if type(n) ~= "string" then error("Expected string, got", type(n)) return end
	self.name = n
	return
end
--[[
function C:setEnvironmentOnEntity( ent, env )
	if env ~= nil and env.is_A and env:is_A( GM.class.getClass("Environment")) then

		-- If the current ent doesn't have an environment or it's not the same as the one we're setting, then remove the ent from the old place
		if ent.getEnvironment and ent:getEnvironment() ~= env then
			ent:getEnvironment():removeEntity( ent )
		end

		env:addEntity( ent )

		-- Assign the env to the ent's getEnvironment function
		local this = env
		ent.getEnvironment = function()
			return this
		end

		return true
	else
		error("Expected Environment on setEnvironmentOnEntity()")
		return false
	end
end

function C:checkContainedEntities()
	for k,v in pairs( self:getEntities() ) do

		if self:entInRadius( v ) then

			if v:IsPlayer() then
				print(v, "in radius of ",self:getName())
			end

			-- When things are added to the entities table, we should go and set their environments correctly
			if v.getEnvironment and v:getEnvironment() ~= self then self:setEnvironmentOnEntity( v, self ) end


			-- Set our attributes on the player
			local phys = v:GetPhysicsObject()
			if IsValid(phys) then
				if self:getGravity() <= 0 then
					v:SetGravity(0.00001)
				else
					v:SetGravity(self:getGravity())
				end

				if self:getGravity() > 0.01 then
					phys:EnableGravity( true )
				else
					phys:EnableGravity( false )
				end

				if self:getPressure() > 0.01 then
					phys:EnableDrag( true )
				else
					phys:EnableDrag( false)
				end

			end

		else -- Out of radius, waiting for endTouch to catch up
			self:removeEntity( v )
		end
	end
end   ]]

function C:updateEnvironmentOnEntities()
	for k, v in pairs( self:getEntities() ) do
		self:updateEntity( v )
	end
end

function C:updateEntity( e )
	-- This is where we set an ents gravity and physical vars
	local phys = e:GetPhysicsObject()
	if IsValid(phys) then
		if self:getGravity() <= 0 then
			e:SetGravity(0.00001)
		else
			e:SetGravity(self:getGravity())
		end

		if self:getGravity() > 0.01 then
			phys:EnableGravity( true )
		else
			phys:EnableGravity( false )
		end

		if self:getPressure() > 0.01 then
			phys:EnableDrag( true )
		else
			phys:EnableDrag( false)
		end

	end
end

function C:setEnvironment( e, v )
	if v.is_A and v:is_A( GM.class.getClass("Environment")) and e.getEnvironment == nil or e:getEnvironment() ~= v then

		local this = v
		e.getEnvironment = function()
			return this
		end

		v:updateEntity( e )

	end
end

function C:updateEntities()
	for k,v in pairs( self:getEntities() ) do
		if GM:isValid( v ) then
			if self:getCelestial():getEntity():GetPos():Distance( v:GetPos() ) <= self:getRadius() then
				if not v.getEnvironment or v:getEnvironment() ~= self then
					self:setEnvironment( v, self )
				end
			else
				if v.getEnvironment and v:getEnvironment() ~= GM:getSpace() then
					self:setEnvironment( v, GM:getSpace() )
				end
			end
		else
			self:removeEntity(v)
		end

	end
end

function C:getEntities()
	return self.entities
end

function C:hasEntity( o )
	return self:getEntities()[o:EntIndex()] ~= nil
end

function C:addEntity( o )
	self:getEntities()[ o:EntIndex() ] = o
	return
end

function C:removeEntity( o )
	if self:getEntities()[ o:EntIndex() ] then
		table.remove( self:getEntities(), o:EntIndex() )
		if o.getEnvironment == nil or o:getEnvironment() == self then --On remove, set them back to space
			self:setEnvironment( o, GM:getSpace() )
		end

	end
	return
end

function C:getCelestial()
	return self.celestial
end

function C:setCelestial( p )
	if not p.is_A or not p:is_A( GM.class.getClass("Celestial") ) then error("Expected celestial to be a Celestial Object, got "..p:getClass() or type(p)) return end
	self.celestial = p
	return
end

function C:getGravity()
	return self.gravity
end

function C:setGravity( g )
	if not tonumber(g) then error("Expected number, got "..type(g))return end
	self.gravity = tonumber(g)
	return
end

function C:getTemperature()
	return self.temperature
end

function C:setTemperature( t )
	if not tonumber(t) then error("Expected number, got "..type(t)) return end
	self.temperature = tonumber(t)
	return
end

function C:getAtmosphere()
	return self.atmosphere
end

function C:setAtmosphere( a )
	if not tonumber(a) then error("Expected number, got "..type(a)) return end
	self.atmosphere = tonumber(a)
	return
end

function C:getRadius()
	return self.radius
end

function C:setRadius( r )
	if not tonumber(r) then error("Expected number, got "..type(r)) return end
	self.radius = tonumber(r)
	return
end

function C:getPressure()
	return self.pressure
end

function C:setPressure( p )
	if not tonumber(p) then error("Expected number, got "..type(p)) return end
	self.pressure =  tonumber(p)
	return
end

function C:getResources()
	return self.resources
end

function C:setResources( r )
	if type(r) ~= "table" then error("Expected table, got "..type(r)) return end
	self.resources = r
	return
end

function C:getResource( r )
	local res = self:getResources()
	return ( r.getName and res[r:getName()] and res[r:getName()].is_A and res[r:getName()]:is_A( GM.class.getClass("Resource") ) ) and res[r:getName()] or nil
end

function C:getResourceAmount( r )
	local res = self:getResource( r )
	if not res then error("Expected Resource, got"..type(res)) return end
	if not res.getAmount then error("Resource does not have the ability to get amount") return end
	return res:getAmount()
end

function C:addResource( r, a )
	if not self:getResource( r ) then -- Ensure we don't have it in there already first
		for k,v in pairs(self:getResources()) do
			if v:getName() == r:getName() then -- We've got ourselves the same named resource
				if a then
					v:setAmount( a )
				end
				return
			else
				if a then r:setAmount(a) end
				self.resource[r:getName()] = r
			end
		end
	end
	return
end

function C:setResource( r, a )
	if not r.is_A or not r:is_A( GM.class.getClass("Resource") ) then error("Expected resource, got"..type(r)) return end
	if not self:getResource( r ) then
		-- The resource isn't already in there so let's add it
		self:addResource( r, a )
	end
	if self:getResource( r ) then
		r:setAmount( a )
	end
	return
end

function C:Think()
	self:updateEntities()
end

GM.class.registerClass("Environment", C)



