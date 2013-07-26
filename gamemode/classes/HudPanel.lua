-- Extends HudComponent
local GM = GM
local type = type
local error = error
local C = GM.class.getClass("HudComponent"):extends({
	backgroundColor = Color(255,255,255,0), -- No background
	width = 0,
	height = 0,
	autosize = false,
	paddingX = 0,
	paddingY = 0,
	children ={}
})

function C:init(x, y, width, height, backgroundColor, autosize)
	self:super('init', x, y)

	self:setWidth(width or self:getWidth())
	self:setHeight(height or self:getHeight())

	self:setBackgroundColor(backgroundColor or self:getBackgroundColor())

	if autosize ~= nil then
		self:setAutoSize(autosize)
	end

end

-------------------------------------
-- Get of X & Y is from parent --
-------------------------------------

function C:setX(x)
	local dx = x - self:getX()
	if dx and dx ~= 0 then self:updateChildren( dx, 0 ) end
	self:super('setX', x)
end

function C:setY(y)
	local dy = y - self:getY()
	if dy and dy ~= 0 then self:updateChildren( 0, dy ) end
	self:super('setY', y)
end

function C:getPaddingX()
	return self.paddingX
end

function C:setPaddingX( x )
	if type(x) ~= "number" then error("Expected number, got "..type(x)) return end
	self.paddingX = x
	return
end

function C:getPaddingY()
	return self.paddingY
end

function C:setPaddingY( y )
	if type(y) ~= "number" then error("Expected number, got "..type(y)) return end
	self.paddingY = y
	return
end

function C:getPadding()
	return self:getPaddingX(), self:getPaddingY()
end

function C:setPadding(x,y)
	if type(x) ~= "number" or type(y) ~= "number" then error("Expected number, got x:",type(x),",y: ",type(y)) return end
	self:setPaddingX(x)
	self:setPaddingY(y)
	return
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

function C:getBackgroundColor()
	return self.backgroundColor
end

function C:setBackgroundColor(c)
	if type(c) ~= "table" or not c.a or not c.r or not c.g or not c.b then error("Expected table ( Color ), got "..type(c)) return end
	self.backgroundColor = c
	return
end

function C:isAutoSize()
	return self.autosize
end

function C:setAutoSize(a)
	if type(a) ~= "boolean" then error("Expected boolean, got "..type(a)) return end
	self.autosize = a
	return
end

function C:getChildren()
	return self.children
end

function C:setChildren(c)
	for k,v in c do
		self.children[k] = v
	end
	return
end

function C:addChild(c)
	for _, v in pairs( self:getChildren() ) do
		if c == v then return self end
	end

	if not c.getParent then error("Child, ",c,", does not have a getParent method") return end
	if not c.setParent then error("Child, ",c,", does not have a setParent method") return end
	if c:getParent() ~= self then
		if c:getParent() ~= nil then
			c:getParent():removeChild(c)
		end

		c:setParent(self)


		-- Convert their x and y to local with respect to the parent panel
		c:setX( self:getX() + c:getX() + self:getPaddingX() )
		c:setY( self:getY() + c:getY() + self:getPaddingY() )

		table.insert(self:getChildren(), c)
	end

	self:resize()
	return self
end

function C:removeChild(c)
	if not c.getParent and not c:getParent() == self then error("Child, ",c,", does not have a getParent method or it is currently not a child of us") return end
	if c.getChildren(self)[c] then self.children[c] = nil end
	return
end

function C:updateChildren(dx, dy)
	if not dx or not dy then return end

	for _, c in pairs( self:getChildren() ) do
		c:setPos( c:getX() + dx, c:getY() + dy)
	end
	return
end

function C:calcSize()

	local wn = 0
	local hn = 0

	--Changed to use numbers instead, this means less work because no more table sorting
	if #self:getChildren() <= 0 then
		return self:getWidth(), self:getHeight()
	else
		for _,v in pairs( self:getChildren() ) do

			if v:getWidth() + v:getXOff() > wn then
				wn = v:getWidth() + v:getXOff() + self:getPaddingX()
			end
			if v:getHeight() + v:getYOff() > hn then
				hn = v:getHeight() + v:getYOff() + self:getPaddingY()
			end
		end

		return wn,hn
	end
end

function C:resize(xb, yb)

	if type(xb) ~= "boolean" then xb = true end
	if type(yb) ~= "boolean" then yb = true end

	local w,h = self:calcSize()

	if xb then
		self:setWidth(w)
	end
	if yb then
		self:setHeight(h)
	end
end

function C:render()
	self:super('render')

	if self:isAutoSize() and self.calcSize then
		self:resize()
	end

	if self:isVisible() then

		draw.RoundedBox( 0, self:getX(), self:getY(), self:getWidth(), self:getHeight(), self:getBackgroundColor() )

		for _, v in pairs( self:getChildren() ) do
			v:render()
		end

	end
end

GM.class.registerClass("HudPanel", C)