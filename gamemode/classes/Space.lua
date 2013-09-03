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

function C:updateEntity( e )
	-- This is where we set an ents gravity and physical vars

	e:SetGravity( math.max( self:getGravity(), 0.000001 ) )

	local phys = e:GetPhysicsObject()
	if IsValid(phys) and e and not e:IsPlayer() then
		if self:getGravity() > 0.01 then
			phys:EnableGravity( true )
		else
			phys:EnableGravity( false )
		end

		if self:getPressure() > 0.01 then
			phys:EnableDrag( true )
		else
			phys:EnableDrag( false )
		end

	end

	if e:IsPlayer() then
		e:SetRunSpeed(1/math.pow(10,30))
		e:SetWalkSpeed(1/math.pow(10,30))
	end

end


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