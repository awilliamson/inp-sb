local GM = GM
local class = GM.class
local const = GM.constants
local internal = GM.internal

local os = os
local tonumber = tonumber
local tostring = tostring
local table = table
local pairs = pairs
local error = error
local string = string
local Color = Color
local math = math

--== HUD SYSTEM FUNCTIONS ==--
internal.hud = {}

function GM:registerHUDComponent(name, component)
	if not component.is_A or not component:is_A( GM.class.getClass("HudComponent") ) then error("Component is not a HudComponent. Failed to register, "..name) return end
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

-- Locals for the panels so we can reference them throughout cl_hud
local generated = false

local healthPanel, health, health_txt, armor, armor_txt -- Health Panel & Children
local secClock, minClock, hrClock, fpsInd -- Clock & FPS
local secLabel, minLabel, hrLabel, fpsLabel -- Some labels for Clock & FPS
local secN, minN, hrN, fpsN -- Numbers for the Clock & FPS
local ammoPanel, ammo, ammo_txt, alt -- Ammo Panel & Children

local wepTable = {}

local function calcAmmo()

	local ammo, maxAmmo, secondaryAmmo
	local wep = LocalPlayer():GetActiveWeapon()

	if wep:IsValid() then
		ammo = wep:Clip1()

		if ammo ~= nil and ammo > 0 then

			-- Add Wep max ammo if it doesn't exist. Otherwise update ammo amount if we have something bigger
			if not wepTable[ wep:GetClass() ] or ammo > wepTable[ wep:GetClass() ] then
				wepTable[ wep:GetClass() ] = ammo or 0
			end
		end

		secondaryAmmo = wep:GetSecondaryAmmoType() and LocalPlayer():GetAmmoCount( wep:GetSecondaryAmmoType()) or 0
		maxAmmo = wepTable[ wep:GetClass() ]
	end

	return ammo, maxAmmo, secondaryAmmo
end

local function genComponents()
	if not generated then

		---
		--- Health Panel - Bottom Left
		---

		healthPanel = GM.class.getClass("HudPanel"):new( 0, 0, 0, 0, Color(50,50,50,150), true)
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
		--- End of HealthPanel
		---

		---
		--- Clock & FPS - Top
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
		hrClock:setMaxValue( 12 )
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
		fpsInd:setPos( hrClock:getX() - hrClock:getRadius() - fpsInd:getRadius() - 10,hrClock:getY() )

		local think = fpsInd.think
		fpsInd.think = function(self)
			if tostring(os.time())[-1] % 2 == 0 then
				self:setTarget(1/math.Clamp(FrameTime(), 0.0001, 10))
			end
			think(self)
		end

		---
		--- LABELS
		---

		secLabel = GM.class.getClass("TextElement"):new(0 ,0, Color(255,255,255,255), "Seconds")
		minLabel = GM.class.getClass("TextElement"):new(0 ,0, Color(255,255,255,255), "Minutes")
		hrLabel = GM.class.getClass("TextElement"):new(0, 0, Color(255,255,255,255), "Hours")
		fpsLabel = GM.class.getClass("TextElement"):new(0, 0, Color(255,255,255,255), "FPS")

		secN = GM.class.getClass("TextElement"):new(0 ,0, Color(255,255,255,255), "00")
		minN = GM.class.getClass("TextElement"):new(0 ,0, Color(255,255,255,255), "00")
		hrN = GM.class.getClass("TextElement"):new(0, 0, Color(255,255,255,255), "00")
		fpsN = GM.class.getClass("TextElement"):new(0, 0, Color(255,255,255,255), "00")

		secLabel:setPos( secClock:getX() - secLabel:getWidth()/2, secClock:getY() + secClock:getRadius() + secLabel:getHeight()/2 )
		minLabel:setPos( minClock:getX() - minLabel:getWidth()/2, minClock:getY() + minClock:getRadius() + minLabel:getHeight()/2 )
		hrLabel:setPos( hrClock:getX() - hrLabel:getWidth()/2, hrClock:getY() + hrClock:getRadius() + hrLabel:getHeight()/2 )
		fpsLabel:setPos( fpsInd:getX() - fpsLabel:getWidth()/2, fpsInd:getY() + fpsInd:getRadius() + fpsLabel:getHeight()/2 )

		secN:setPos( secClock:getX() - secN:getHeight()/2, secClock:getY() - secN:getHeight()/2 )
		minN:setPos( minClock:getX() - minN:getWidth()/2, minClock:getY() - minN:getHeight()/2 )
		hrN:setPos( hrClock:getX() - hrN:getWidth()/2, hrClock:getY() - hrN:getHeight()/2 )

		local think = secN.think
		secN.think = function(self)
			local val = ""
			local time = math.floor(secClock:getValue())
			if time < 10 then
				val = "0"..tostring(time)
			else
				val = tostring( time )
			end

			self:setText( val )
			--secN:setPos( secClock:getX() - secN:getHeight()/2, secClock:getY() - secN:getHeight()/2 )
			think(self)
		end

		local think = minN.think
		minN.think = function(self)
			local val = ""
			local time = math.floor(minClock:getValue())
			if time < 10 then
				val = "0"..tostring(time)
			else
				val = tostring( time )
			end

			self:setText( val )

			--minN:setPos( minClock:getX() - minN:getWidth()/2, minClock:getY() - minN:getHeight()/2 )
			think(self)
		end

		local think = hrN.think
		hrN.think = function(self)
			local val = ""
			local time = math.floor(os.date("%H")) -- To display 24 hour time, whilst the dial is repeated by 12
			if time < 10 then
				val = "0"..tostring(time)
			else
				val = tostring( time )
			end

			self:setText( val )

			--hrN:setPos( hrClock:getX() - hrN:getWidth()/2, hrClock:getY() - hrN:getHeight()/2 )
			think(self)
		end

		local think = fpsN.think
		fpsN.think = function(self)
			self:setText( tostring( math.floor(fpsInd:getValue())) )
			fpsN:setPos( fpsInd:getX() - fpsN:getWidth()/2, fpsInd:getY() - fpsN:getHeight()/2 )
			think(self)
		end

		---
		--- END OF LABELS
		---



		---
		--- End of FPS & Clock
		---

		---
		--- Ammo Panel - Bottom Right
		---

		ammoPanel = GM.class.getClass("HudPanel"):new( 0, 0, 0, 0, Color(50,50,50,150), true)
		ammoPanel:setPadding(10,10)

		local think = ammoPanel.think
		ammoPanel.think = function(self)
			think(self)

			self:setPos( ScrW() - 30 - self:getWidth(), ScrH() - 30 - self:getHeight() )

			local ammo, maxAmmo, _ = calcAmmo()
			if ammo and maxAmmo and maxAmmo > 0 then
				self:setVisible(true)
			else
				self:setVisible(false)
			end

		end

		ammo = GM.class.getClass("HudBarIndicator"):new(0,0,120,10,0,100,Color(255,255,255,255),Color(255,255,255,20))
		ammo_txt = GM.class.getClass("TextElement"):new(ammo:getX(), ammo:getY() + ammo:getHeight(), Color(255,255,255,255), "Ammo")
		ammo:setSmoothFactor(0.3)

		local think = ammo.think
		ammo.think = function(self)
			local ammo, maxAmmo, _ = calcAmmo()

			if ammo and ammo >= 0 and maxAmmo and maxAmmo > 0 then
				self:setMaxValue( maxAmmo )
				self:setTarget( ammo )
			end

			think(self)
		end

		local think = ammo_txt.think
		ammo_txt.think = function(self)
			think(self)

			local ammo, maxAmmo, _ = calcAmmo()
			self:setText( string.format("Ammo: %s/%s", ammo, maxAmmo) )
		end

		alt = GM.class.getClass("TextElement"):new(ammo_txt:getX(), ammo_txt:getY() + ammo_txt:getHeight(), Color(255,255,255,255), "Alt")

		local think = alt.think
		alt.think = function(self)
			think(self)

			local _, _, secondaryAmmo = calcAmmo()
			self:setText( string.format("Alt: %s", secondaryAmmo ) )
		end

		ammoPanel:addChild(ammo):addChild(ammo_txt):addChild(alt)
		---
		---	End of Ammo Panel
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

	if LocalPlayer():Alive() then
		-- HealthPanel
		healthPanel:render()

		-- AmmoPanel
		ammoPanel:render()

		-- Clock [ ORDER IMPORTANT ]
		secClock:render()
		minClock:render()
		hrClock:render()

		-- FPS meter
		fpsInd:render()

		-- Labels [ ORDER NOT IMPORTANT ]
		secLabel:render()
		minLabel:render()
		hrLabel:render()
		fpsLabel:render()

		-- Numbers [ ORDER NOT IMPORTANT ]
		secN:render()
		minN:render()
		hrN:render()
		fpsN:render()
	end

end

local function hidehud(name)
	for k, v in pairs{ "CHudHealth", "CHudBattery", "CHudAmmo", "CHudSecondaryAmmo" } do
		if name == v then return false end
	end
end
hook.Add("HUDShouldDraw", "SBDisableDefault", hidehud)