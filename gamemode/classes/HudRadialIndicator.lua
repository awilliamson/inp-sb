local GM = GM
local Color = Color
local math = math
local surface = surface
local slice = GM.util.tableSlice
local smooth = GM.util.smoother

local C = GM.class.getClass("HudComponent"):extends({
	value = 0,
	maxvalue = 0,
	width = 0, -- Smallest of width/height will determine radius, so circle doesn't go out of bounds
	height = 0,
	radius = 0, -- Radius will be set during init, based on the above
	color = Color(150,150,255,255),
	backgroundColor = Color(150,255,150,255),
	fill = true, -- Fill represents the style, whether it should have val color from top all the way clockwise to currvalue, or if it should be like a pip, either side of the value.
	pipSize = 5, -- Pcnt of the whole circle is the pip, value lies at the mid point of the pip
	target = 0,
	smoothFactor = 0.15
})

function C:init(x,y,w,h,val,maxval,col,bgcol,fill)
	self:super('init', x, y)

	self:setWidth(w)
	self:setHeight(h)

	self:setValue(val)
	self:setMaxValue(maxval)

	self:setColor(col)
	self:setBackgroundColor(bgcol)

	if fill ~= nil then
		self:setFill(fill)
	end

	-- Initial radius setting stuff
	local r = self:calcRadius()
	self:setRadius( r )

	self:setWidth( r*2 )
	self:setHeight( r*2 )

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

function C:isFill()
	return self.fill
end

function C:setFill(bool)
	if type(bool) ~= "boolean" then error("Expected boolean, got "..type(bool)) return end
	self.fill = bool
	return
end

function C:getPipSize()
	return self.pipSize
end

function C:setPipSize(p)
	if type(p) ~= "number" then error("Expected Number, got "..type(p) ) return end
	self.pipSize = p
	return
end

function C:getRadius()
	return self.radius
end

function C:setRadius( r )
	if type(r) ~= "number" then error("Expected Number, got "..type(r) ) return end

	self.radius = r
	return
end

function C:calcRadius()
	return ((self:getWidth()<self:getHeight()) and self:getWidth()/2 or self:getHeight()/2)
end

local function colorNegate(clr)
	local clr = GM.util:deepCopyTable(clr)
	if type(clr) ~= "table" or not clr.a or not clr.r or not clr.g or not clr.b then error("Expected table ( clr ), got "..type(clr)) return clr end

	--Get negative of the clr
	clr.r = 255 - clr.r
	clr.g = 255 - clr.g
	clr.b = 255 - clr.b
	clr.a = 255
	return clr
end

local function renderBackgroundCircle(self)
	local circ = {}
	for i=1, 360 do
		circ[i] = {	x = self:getX() + math.cos( math.rad(i) ) * self:getRadius(), y = self:getY() + math.sin(math.rad(i)) * self:getRadius()	}
	end

	surface.SetTexture(0)
	surface.SetDrawColor(self:getBackgroundColor())
	surface.DrawPoly(circ)
end

local function renderFillIndicator(self)
	-- This is a fill indicator which will be value color up to the current value, examples include FPS

	local circ = {}

	table.insert(circ, {x= self:getX(), y= self:getY()})

	for i=1, 360 do
		if i/360 < self:getValue()/self:getMaxValue() then
			table.insert(circ, {		x = self:getX() + math.cos( math.rad(i-90) ) * (self:getRadius()*(99/100)), y = self:getY() + math.sin( math.rad(i-90) ) * self:getRadius()*(99/100)	} )
		end
	end

	table.insert(circ, {x= self:getX(), y= self:getY()})

	if (#circ-2) > 180 then -- We've gone over a semi circle so crop that shit down

		local semi = {}
		local seg = {}

		semi = slice(circ, 2, 181)
		table.insert(semi, {x= self:getX(), y= self:getY()})

		seg = slice(circ, 181)
		table.insert(semi, {x= self:getX(), y= self:getY()})


		local clr = self:getColor()
		clr.a = 255

		surface.SetTexture(0)
		surface.SetDrawColor( clr )
		surface.DrawPoly( semi )

		surface.SetTexture(0)
		surface.SetDrawColor( clr )
		surface.DrawPoly( seg )
	else


		surface.SetTexture(0)
		surface.SetDrawColor( self:getColor() )
		surface.DrawPoly( circ )

	end


end

local function renderNonFillIndicator(self)
	-- This is just a segement indicator, the ceter being the current value, examples clock.

	local circ = {}

	table.insert(circ, {x= self:getX(), y= self:getY()})

	local ppDeg = 360 / self:getMaxValue() -- point per degree. Cuts 360 degrees up to find how many degrees per point
	local transVal = ppDeg * (self:getValue()) -- transformed value. degrees/point * points = degrees :D

	for i=transVal - (((self:getPipSize()-1)/2)*ppDeg), transVal + (((self:getPipSize()-1)/2)*ppDeg) do -- Go 2 points either side for the segment. Total coverage of pipSize points
		table.insert(circ, {		x = self:getX() + math.cos( math.rad(i-90) ) * (self:getRadius()*(99/100)), y = self:getY() + math.sin( math.rad(i-90) ) * self:getRadius()*(99/100)	} )
	end

	table.insert(circ, {x= self:getX(), y= self:getY()})

	surface.SetTexture(0)
	surface.SetDrawColor( self:getColor() )
	surface.DrawPoly( circ )



end

local function renderCoverCircle(self)
	local circ = {}
	for i=1, 360 do
		circ[i] = {	x = self:getX() + math.cos( math.rad(i-90) ) * (self:getRadius()*(3/5)), y = self:getY() + math.sin(math.rad(i-90)) * (self:getRadius()*(3/5))	}
	end
	surface.SetTexture(0)
	surface.SetDrawColor( colorNegate( self:getBackgroundColor() ) )
	surface.DrawPoly(circ)
end

function C:think()
	if self:getTarget() ~= self:getValue() then
		self:setValue( smooth(self:getTarget(), self:getValue(), self:getSmoothFactor()) )
	end
end

function C:render()
	self:super('render') -- Call back to HudComponent

	-- Think will be called from the top Super class' render func.
	-- This will end up setting the radius for us as defined above
	if self:isVisible() then
		renderBackgroundCircle(self) -- Background circle first

		if self:isFill() then -- Check what type of indicator we want. Whether we want it to fill from top -> value or just have a segment filled near the value
			renderFillIndicator(self)
		else
			renderNonFillIndicator(self)
		end

		renderCoverCircle(self) -- Center cover circle to hide things
	end

end

GM.class.registerClass("HudRadialIndicator", C)

