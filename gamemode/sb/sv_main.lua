local GM = GM
local player_manager = player_manager
local BaseClass = GM:getBaseClass()

--[[---------------------------------------------------------
   Name: gamemode:PlayerSpawn( )
   Desc: Called when a player spawns
-----------------------------------------------------------]]
function GM:PlayerSpawn( ply )

	BaseClass.PlayerSpawn( self, ply )

end

local function changeRaceClass(ply, race)
	player_manager.SetPlayerClass( ply, race )
	ply:KillSilent()
end

--[[---------------------------------------------------------
   Called once on the player's first spawn
-----------------------------------------------------------]]
function GM:PlayerInitialSpawn( ply )

	changeRaceClass(ply, "player_terran")
	BaseClass.PlayerInitialSpawn( self, ply )

end