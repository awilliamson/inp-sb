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

	local rand = math.random(0,3)

	if rand >= 2 then
		changeRaceClass(ply, "player_terran")
	elseif rand >= 1 then
		changeRaceClass(ply, "player_radijn")
	elseif rand >= 0 then
		changeRaceClass(ply, "player_pendrouge")
	end
	BaseClass.PlayerInitialSpawn( self, ply )

end

--[[---------------------------------------------------------
   Called on the player's every spawn
-----------------------------------------------------------]]
function GM:PlayerSpawn( ply )	
	local spawners = ents.FindByClass("infinity_player_start")
	for k,v in pairs(spawners) do
		if(ply:getRace() == v.Race)then
			ply:SetPos(v:GetPos())
		end
	end
	--Base GM Stuff:
	
	player_manager.OnPlayerSpawn( ply )
	player_manager.RunClass( ply, "Spawn" )
	
	ply:UnSpectate()
	--Call the player loadout hook
	hook.Call( "PlayerLoadout", GAMEMODE, ply )
	
	--Set player model with the hook
	hook.Call( "PlayerSetModel", GAMEMODE, ply )
end

---
--- Environment Stuffs
---

---
-- Planet data structure
--
-- Case01 -> type of planet, eg planet/cube/planet_color
-- Case02 -> planet radius
-- Case03 -> planet gravity
-- Case04 -> planet atmosphere
-- Case05 -> planet night temperature
-- Case06 -> planet temperature
-- Case07 -> color_id
-- Case08 -> bloom_id
-- Case16 -> process sb1 flags
---

---
-- Planet2 data structure
--
-- Case01 -> type of planet, eg planet/cube/planet_color
-- Case02 -> planet radius
-- Case03 -> planet gravity
-- Case04 -> planet atmosphere
-- Case05 -> planet pressure (ignore)
-- Case06 -> planet night temperature
-- Case07 -> planet temperature
-- Case08 -> process sb3 flags
-- Case09 -> oxygen percentage
-- Case10 -> co2 percentage
-- Case11 -> nitrogen percentage
-- Case12 -> hydrogen percentage
-- Case13 -> planet name
-- Case14 -> unknown
-- Case15 -> color_id
-- Case16 -> bloom_id
---

---
-- Star data structure
--
-- Case01 -> type of planet, eg planet/cube/planet_color
--
-- radius -> 512
-- gravity -> 0 (so you don't fall when inside of it)
-- nighttemperature -> 10000
-- temperature -> 10000
---

---
-- Star2 data structure
--
-- Case01 -> type of planet, eg planet/cube/planet_color
-- Case02 -> star radius
-- Case03 -> star night temperature
-- Case04 -> unknown
-- Case05 -> star temperature
-- Case06 -> star name
---



local env_data = {}
local env_classes = { "envSun", "logic_case" }

local function getKey( key )
	if type(key) ~= "string" then error("Expected String, got",type(key)) return key end
	if string.find(key,"Case") and tonumber( string.sub(key, 5) ) then
		return tonumber( string.sub(key,5) ) or key
	else
		return key
	end
end

local function spawnEnvironments( list )
	for k,v in pairs( list ) do

		PrintTable(v)

		if v[1] == "planet" or v[1] == "planet2" then
			if v[1] == "planet2" then v[6] = v[7] end -- Override night temp as norm temp
			local obj = GM.class.getClass("Celestial"):new()
			local env = GM.class.getClass("Environment"):new( v[3], v[6], v[4] ) --grav,temp,atmos, resources

			local ent = ents.Create("infinity_planet")
			ent:SetPos( v.ent:GetPos())
			ent:SetAngles( v.ent:GetAngles() )
			ent:Spawn()

			local r = v[2]
			ent:PhysicsInitSphere(r)
			ent:SetCollisionBounds( Vector(-r,-r,-r), Vector(r,r,r) )

			-- Create an environment, bind the entity to the environment obj?
			obj:setEnvironment(env)
			obj:setEntity(ent)

			print(obj)

		end
	end
end

--[[
--
-- GM:InitPostEntity( )
-- Called once all map entities have spawned.
--
 ]]

function GM:InitPostEntity()
	print("We're doing post Entity shit")

	local ents = ents.FindByClass("logic_case")
	for _, ent in pairs(ents) do
		local tbl = { ent = ent }
		local vals = ent:GetKeyValues()
		for k, v in pairs(vals) do
			tbl[ getKey( k ) ] = v
		end
		table.insert(env_data, tbl )
	end

	spawnEnvironments( env_data )

	print("We've finished that bollocks")
end