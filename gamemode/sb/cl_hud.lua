local GM = GM
local class = GM.class
local const = GM.constants
local internal = GM.internal

--== HUD SYSTEM FUNCTIONS ==--
internal.hud = {}

function GM:registerHUDComponent(name, component)
	if not component.is_A or not component:is_A("HudComponent") then error("Component is not a HudComponent. Failed to register, "..name) return end
	internal.hud[name] = component
end

function GM:getHudComponentByName(name)
	return internal.hud[name]
end

function GM:getHudComponentByClass(classname)
	local ret = {}
	for k, v in pairs(internal.hud) do
		if v.is_A and v:is_A(classname) then
		   table.insert(ret, v)
		end
	end
	return ret
end

--==========================--


-------------------------
--------------------------
-------------------------
local generated = false
local healthPanel, health, health_txt, armor, armor_txt
local secClock, minClock, hrClock, fpsInd

local function genComponents()
	if not generated then

		healthPanel = GM.class.getClass("HudPanel"):new( 200, 100,500,500,Color(50,50,50,150), true)
		healthPanel:setPadding(10,10)

		local think = healthPanel.think
		healthPanel.think = function(self)
			think(self)

			self:setPos( 30, ScrH() - 30 - self:getHeight())

		end

		health = GM.class.getClass("HudBarIndicator"):new(0,0,120,10,0,100,Color(255,255,255,255),Color(255,255,255,20))
		health_txt = GM.class.getClass("TextElement"):new(health:getX(),health:getY()+ health:getHeight(),Color(255,255,255,255),"Health")
		health:setSmoothFactor(0.3)

		local think = health.think
		health.think = function(self)
			self:setTarget( LocalPlayer():Health() )

			think(self)
		end

		local think = health_txt.think
		health_txt.think = function(self)
			think(self)

			self:setText( string.format("Health: %s", math.Round(health:getValue())).."%" )
		end

		armor = GM.class.getClass("HudBarIndicator"):new(0,health_txt:getY() + health_txt:getHeight() + 10,120,10,0,100,Color(255,255,255,255),Color(255,255,255,20))
		armor_txt = GM.class.getClass("TextElement"):new(armor:getX(), armor:getY()+ armor:getHeight(),Color(255,255,255,255), "Armor")
		armor:setSmoothFactor(0.3)

		local think = armor.think
		armor.think = function(self)
			self:setTarget( LocalPlayer():Armor() )

			think(self)
		end

		local think = armor_txt.think
		armor_txt.think = function(self)
			think(self)

			self:setText( string.format("Armor: %s", math.Round(armor:getValue())).."%" )
		end

		healthPanel:addChild(health):addChild(health_txt):addChild(armor):addChild(armor_txt)

		---
		--- Below is the top panel area for the clock and FPS meter
		---

		-- Seconds
		secClock = GM.class.getClass("HudRadialIndicator"):new(0,0,60,60,0,0,Color(255,255,255,255),Color(50,50,50,80),false)
		secClock:setMaxValue( 60 ) -- 60 seconds in a minute hurr durr
		secClock:setPos( math.Round(ScrW()/2 + secClock:getRadius() + secClock:getRadius()*2 + 10/2), math.Round(secClock:getHeight()/2 + 10) )
		secClock:setSmoothFactor(0.5)

		local think = secClock.think
		secClock.think = function(self)
			self:setTarget( tonumber(os.date("%S")) )
			think(self)
		end

		-- Minutes
		minClock = GM.class.getClass("HudRadialIndicator"):new(0,0,60,60,0,0,Color(255,255,255,255),Color(50,50,50,80),false)
		minClock:setMaxValue( 60 ) -- 60 seconds in a minute hurr durr
		minClock:setPos( secClock:getX() - secClock:getRadius() - minClock:getRadius() - 10,secClock:getY() )
		minClock:setSmoothFactor(0.6)

		local think = minClock.think
		minClock.think = function(self)
			self:setTarget( tonumber(os.date("%M") + os.date("%S")/60) )
			think(self)
		end

		-- Hours
		hrClock = GM.class.getClass("HudRadialIndicator"):new(0,0,60,60,0,0,Color(255,255,255,255),Color(50,50,50,80),false)
		hrClock:setMaxValue( 12 ) -- 60 seconds in a minute hurr durr
		hrClock:setPipSize(1.8)
		hrClock:setPos( minClock:getX() - minClock:getRadius() - hrClock:getRadius()- 10,minClock:getY() )
		hrClock:setSmoothFactor(0.6)

		local think = hrClock.think
		hrClock.think = function(self)
			self:setTarget( tonumber( (os.date("%H") % 12 ) + (os.date("%M")/60)) )
			think(self)
		end

		-- FPS
		fpsInd = GM.class.getClass("HudRadialIndicator"):new(0,0,60,60,0,0,Color(255,255,255,255),Color(50,50,50,80))
		fpsInd:setMaxValue( GetConVarNumber("fps_max") or 0 )
		fpsInd:setPos( hrClock:getX() - hrClock:getRadius() - fpsInd:getRadius()- 10,hrClock:getY() )

		local think = fpsInd.think
		fpsInd.think = function(self)
			if tostring(os.time())[-1] % 2 == 0 then
				self:setTarget(1/math.Clamp(FrameTime(), 0.0001, 10))
			end
			think(self)
		end

		---
		--- End of FPS & Clock
		---

		---
		--- Register components
		---

		GM:registerHUDComponent("HealthPanel", healthPanel) -- Optional, allows external lua scripts to call up the HUD elements for hooking etc
		-- Don't bother with clock as it's not in a frame, and won't be used for anything other than defined here.

		---
		--- End Component Registration
		---

		generated = true
	end
end

function GM:HUDPaint()
	genComponents()

	-- HealthPanel
	healthPanel:render()

	-- Clock [ ORDER IMPORTANT ]
	secClock:render()
	minClock:render()
	hrClock:render()

	-- FPS meter
	fpsInd:render()


end

local function hidehud(name)
	for k, v in pairs{ "CHudHealth", "CHudBattery", "CHudAmmo", "CHudSecondaryAmmo" } do
		if name == v then return false end
	end
end
hook.Add("HUDShouldDraw", "SBDisableDefault", hidehud)