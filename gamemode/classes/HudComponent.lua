local GM = GM
local type = type
local error = error
local C = GM.LCS.class({
	x = 0,
	y = 0,
	visible = true,
	parent = nil
})

function C:init(x, y)
	self:setX(x or self:getX())
	self:setY(y or self:getY())
end

function C:getX()
	return self.x
end

function C:setX(x)
	if type(x) ~= "number" then error("Expected number, got "..type(x)) return end
	self.x = x
end

function C:getY()
	return self.y
end

function C:setY(y)
	if type(y) ~= "number" then error("Expected number, got "..type(y)) return end
	self.y = y
end

function C:getPos()
	return self:getX(), self:getY()
end

function C:setPos(x, y)
	if type(x) ~= "number" or type(y) ~= "number" then error("Expected number, got x:",type(x),",y: ",type(y)) return end
	self:setX( x )
	self:setY( y )
	return
end

function C:isVisible()
	return self.visible
end

function C:setVisible(bool)
	if type(bool) ~= "boolean" then error("Expected boolean, got "..type(bool)) return end
	self.visible = bool
end

function C:getParent()
	return self.parent
end

function C:setParent(p)
	if not p.is_A or p.is_A( self ) == false then error("Expected HudComponent") return end
	self.parent = p
end

function C:getXOff()
	return self:getX() - ( self:getParent():getX() or 0 ) or 0
end

function C:getYOff()
	return self:getY() - ( self:getParent():getY() or 0 ) or 0
end

function C:think()
	-- Do some thinking in here prior to rendering
end

function C:render()
	self:think() -- Think before rendering
end

GM.class.registerClass("HudComponent", C)

