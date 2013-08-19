local GM = GM
local CreateConVar = CreateConVar
local GetConVar = GetConVar
local game = game

CreateConVar("SB_NoClip", "1")
CreateConVar("SB_AdminSpaceNoclip", "1") -- Makes it so admins can no clip in space, defaults to yes
CreateConVar("SB_SuperAdminSpaceNoclip", "1") -- Makes it so admins can no clip in space, defaults to yes
CreateConVar("SB_PlanetNoClipOnly", "1") -- Make it so admins can let players no clip in space.

CreateConVar("SB_EnableDrag", "1") -- Make it drag also gets affected, on by default.
CreateConVar("SB_InfiniteResources", "0") -- Makes it so that a planet can't run out of resources, off by default.

GM.convars.noclip = {
	get = function() return GetConVar("SB_NoClip"):GetBool() end,
	set = function(self, val) game.ConsoleCommand("SB_NoClip "..tonumber(val).."\n") end
}

GM.convars.adminspacenoclip = {
	get = function() return GetConVar("SB_AdminSpaceNoclip"):GetBool() end,
	set = function(self, val) game.ConsoleCommand("SB_AdminSpaceNoclip "..tonumber(val).."\n") end
}

GM.convars.superadminspacenoclip = {
	get = function() return GetConVar("SB_SuperAdminSpaceNoclip"):GetBool() end,
	set = function(self, val) game.ConsoleCommand("SB_SuperAdminSpaceNoclip "..tonumber(val).."\n") end
}

GM.convars.planetnocliponly = {
	get = function() return GetConVar("SB_PlanetNoClipOnly"):GetBool() end,
	set = function(self, val) game.ConsoleCommand("SB_PlanetNoClipOnly "..tonumber(val).."\n") end
}

GM.convars.drag = {
	get = function() return GetConVar("SB_EnableDrag"):GetBool() end,
	set = function(self, val) game.ConsoleCommand("SB_EnableDrag "..tonumber(val).."\n") end
}

GM.convars.resources = {
	get = function() return GetConVar("SB_InfiniteResources"):GetBool() end,
	set = function(self, val) game.ConsoleCommand("SB_InfiniteResources "..tonumber(val).."\n") end
}