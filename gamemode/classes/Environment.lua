-- Class for environments which will be bound to celestial objects

local GM = GM

local C = GM.LCS.class({
	gravity = 0,
	atmosphere = 0,
	temperature = 0,
	pressure = 0,
	resources = {},
	entities = {},
	celestial = nil
})

function C:init(g,t,a,r)
	self:setGravity( g or self:getGravity() )
	self:setTemperature( t or self:getTemperature() )
	self:setAtmosphere( a or self:getAtmosphere() )
	self:setResources( r or self:getResources() )
	self:setPressure( self:getGravity() * self:getAtmosphere() )
end

function C:getEntities()
	return self.entities
end

function C:addEntity( o )
	if o.EntIndex and o:EntIndex() and not self.entities[ o:EntIndex() ] then
		self.entities[ o:EntIndex() ] = o
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
	self.temperature = t
	return
end

function C:getAtmosphere()
	return self.atmosphere
end

function C:setAtmosphere( a )
	if not tonumber(a) then error("Expected number, got "..type(a)) return end
	self.atmosphere = a
	return
end

function C:getPressure()
	return self.pressure
end

function C:setPressure( p )
	if type(p) ~= "number" then error("Expected number, got "..type(p)) return end
	self.pressure = p
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
		self:addResource( r, a)
	end
	if self:getResource( r ) then
		r:setAmount( a )
	end
	return
end

function C:Think()
	for k, v in pairs( self:getEntities() ) do



	end
end

GM.class.registerClass("Environment", C)



