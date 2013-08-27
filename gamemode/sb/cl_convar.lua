local GM = GM
local CreateClientConVar = CreateClientConVar
local GetConVar = GetConVar

CreateClientConVar("SB_CoreGlow", "1", true ) -- Enable core glow by default
CreateClientConVar("SB_Bloom", "1", true ) -- Enable Bloom on planets
CreateClientConVar("SB_Color", "1", true ) -- Enable Color on planets

GM.convars.coreglow = {
	get = function() return GetConVar("SB_CoreGlow"):GetBool() end,
	set = function(self, val) RunConsoleCommand( "SB_CoreGlow", tonumber(val) ) end
}

GM.convars.bloom = {
	get = function() return GetConVar("SB_Bloom"):GetBool() end,
	set = function(self, val) RunConsoleCommand( "SB_Bloom", tonumber(val) ) end
}

GM.convars.color = {
	get = function() return GetConVar("SB_Color"):GetBool() end,
	set = function(self, val) RunConsoleCommand( "SB_Color", tonumber(val) ) end
}

