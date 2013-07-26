local GM = GM

local C = GM.class.getClass("HudComponent"):extends({
	color = Color(255,255,255,255),
	width = 0,
	height = 0,
	xalign = TEXT_ALIGN_LEFT,
	ftext = "",
	font = "HudHintTextSmall"
})

function C:init(x, y, clr, ftext, xalign)
	self:super('init', x, y)
	self:setColor( clr )
	self:setText(ftext)
	self:setAlign(xalign or self.xalign)
end

function C:getFont()
	return self.font
end

function C:setFont(f)
	if type(f) ~= "string" then error("Expected string, got "..type(f) ) return end
	self.font = f
end

function C:getText()
	return self.ftext
end

function C:setText(s)
	if type(s) ~= "string" then error("Exptected String, got "..type(s)) return end
	self.ftext = s
end

function C:getAlign()
	return self.xalign
end

function C:setAlign(a)
	if type(a) ~= "number" or a > 5 or a < 0 then error("Unexpected align type") return end
	self.xalign = a
	return                            y
end

function C:getColor()
	return self.color
end

function C:setColor(c)
	if type(c) ~= "table" or not c.a or not c.r or not c.g or not c.b then error("Expected table ( Color ), got "..type(c)) return end
	self.color = c
	return
end

local function calcWidth(self)
	local t

	t = self:getText()

	while type(t) == nil do
		local t = self:getText()
	end

	local w = 6 * #t
	return w -- surface.GetTextSize just doesn't work consistently, we're using a monospaced font anyway.
end

local function calcHeight(self)
	return 14 -- surface.GetTextSize just doesn't work consistently, we're using a monospaced font anyway.
end

function C:getWidth()
	self.width = calcWidth(self)
	return self.width
end

function C:getHeight()
	self.height = calcHeight(self)
	return self.height
end

function C:setWidth()
	-- Nothing!
	-- We want to override default behaviour for get/set width
	return
end

function C:setHeight()
	-- Nothing!
	-- We want to override default behaviour for get/set height
	return
end

function C:render()
	self:super('render')
	if self:isVisible() then
		surface.SetFont( "SBHud" ) -- This is a custom font set in cl_fonts
		surface.SetTextColor( self:getColor() )
		surface.SetTextPos( self:getX(), self:getY() )
		surface.DrawText( self:getText() )
	end
end

GM.class.registerClass("TextElement", C)