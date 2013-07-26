local GM = GM
local type = type
local error = error
local surface = surface
local Color = Color
local smoother = GM.util.smoother

local C = GM.class.getClass("HudComponent"):extends({
	value = 0,
	maxvalue = 0,
	width = 0,
	height = 0,
	color = Color(150,150,255,255),
	backgroundColor = Color(150,255,150,255),
	target = 0,
	smoothFactor = 0.15
})

function C:init(x, y, width, height, value, maxvalue, color, bgcolor)
	self:super('init',x,y,width,height)

	self:setWidth(width)
	self:setHeight(height)

	self:setValue(value)
	self:setMaxValue(maxvalue)

	self:setColor(color)
	self:setBackgroundColor(bgcolor)
end

-- Get/Set of Width & Height is from this class
function C:getWidth()
	return self.width
end

function C:setWidth(w)
	if type(w) ~= "number" then error("Expected number, got "..type(w)) return end
	self.width = w
	return
end

function C:getHeight()
	return self.height
end

function C:setHeight(h)
	if type(h) ~= "number" then error("Expected number, got "..type(h)) return end
	self.height = h
	return
end

function C:getColor()
	return self.color
end

function C:setColor(c)
	if type(c) ~= "table" or not c.a or not c.r or not c.g or not c.b then error("Expected table ( Color ), got "..type(c)) return end
	self.color = c
	return
end

function C:getBackgroundColor()
	return self.backgroundColor
end

function C:setBackgroundColor(c)
	if type(c) ~= "table" or not c.a or not c.r or not c.g or not c.b then error("Expected table ( Color ), got "..type(c)) return end
	self.backgroundColor = c
	return
end

function C:getValue(v)
	return self.value
end

function C:setValue(v)
	if type(v) ~= "number" then error("Expected Number, got "..type(v) ) return end
	self.value = v
	return
end

function C:getMaxValue()
	return self.maxvalue
end

function C:setMaxValue(v)
	if type(v) ~= "number" then error("Expected Number, got "..type(v) ) return end
	self.maxvalue = v
	return
end

function C:getTarget()
	return self.target
end

function C:setTarget(t)
	if type(t) ~= "number" then error("Expected Number, got "..type(t) ) return end
	self.target = math.Clamp(t, 0, self:getMaxValue() )
	return
end

function C:getSmoothFactor()
	return self.smoothFactor
end

function C:setSmoothFactor(s)
	if type(s) ~= "number" then error("Expected Number, got "..type(s) ) return end
	self.smoothFactor = s
	return
end

function C:think()
	if self:getTarget() ~= self:getValue() then
		self:setValue( smoother(self:getTarget(), self:getValue(), self:getSmoothFactor()) )
	end
end

function C:render()
	self:super('render')
	if self:isVisible() then
		surface.SetTexture(0)
		surface.SetDrawColor(self:getColor()) -- Outline of Background of the bar
		surface.DrawOutlinedRect(self:getX(), self:getY(), self:getWidth(), self:getHeight())

		surface.SetTexture(0)
		surface.SetDrawColor(self:getBackgroundColor()) -- Background of Bar
		surface.DrawRect(self:getX(), self:getY(), self:getWidth(), self:getHeight())

		surface.SetTexture(0)
		surface.SetDrawColor(self:getColor()) --Value of Bar
		if self:getValue() / self:getMaxValue() <= 1 then
			surface.DrawRect(self:getX(), self:getY(), self.width * (self:getValue() / self:getMaxValue()), self:getHeight())
		else
			surface.DrawRect(self:getX(), self:getY(), self.width, self:getHeight())
		end
	end
end

GM.class.registerClass("HudBarIndicator", C)

