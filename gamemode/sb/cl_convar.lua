local GM = GM
local CreateClientConVar = CreateClientConVar
local GetConVar = GetConVar

CreateClientConVar("SB_CoreGlow", "1", true) -- Enable core glow by default

GM.convars.coreglow = {
	get = function() return GetConVar("SB_CoreGlow"):GetBool() end,
	set = function(self, val) RunConsoleCommand( "SB_CoreGlow", tonumber(val) ) end
}