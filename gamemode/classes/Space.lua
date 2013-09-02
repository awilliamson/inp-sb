local GM = GM

local C = GM.class.getClass("Environment"):extends({
	name = "Space",
	gravity = 1/math.pow(10,308),
	atmosphere = 0,
	temperature = 14,
	pressure = 0,
	radius = 0,
	resources = {},
	entities = {},
	celestial = nil
})

function C:addEntity( o )
	self:getEntities()[ o ] = true
end

function C:removeEntity( o )
	self:getEntities()[ o ] = nil
end

function C:updateEntities()
	for v, _ in pairs(self:getEntities()) do
		if GM:isValid( v ) then
				if not v.getEnvironment or v:getEnvironment() ~= self then
					self:setEnvironment( v, self )
				end
		else
			self:removeEntity( v )
		end
	end
end

GM.class.registerClass("Space", C)