local GM = GM
local convars = GM.convars
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
	--BaseClass.PlayerInitialSpawn( self, ply )

end

--[[---------------------------------------------------------
   Called on the player's every spawn
-----------------------------------------------------------]]
function GM:PlayerSpawn( ply )	
	local spawners = ents.FindByClass("infinity_player_start")
	for k,v in pairs(spawners) do
		if(ply:getRace() == v.Race)then
			ply:SetPos(v:GetPos())
			ply:SetAngles(v:GetAngles())
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

function GM:PlayerNoClip()
	return GM.convars.noclip:get()
end

function GM:OnReloaded()

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

local function getKey( key )
	if type(key) ~= "string" then error("Expected String, got",type(key)) return key end
	if string.find(key,"Case") and tonumber( string.sub(key, 5) ) then
		return tonumber( string.sub(key,5) ) or key
	else
		return key
	end
end

local function spawnEnvironment( v )

	local obj = GM.class.getClass("Celestial"):new()
	local env
	local ent
	local r

	PrintTable( v )

	local type = v[1]

	if type == "planet" or type == "planet2" or type == "cube" then

		if type == "planet2" or type == "cube" then v[6] = v[7] end -- Override night temp as norm temp

		r = tonumber(v[2])
		env = GM.class.getClass("Environment"):new( v[3], v[6], v[4], r, nil, ((type == "planet2" or type == "cube") and v[13] or "Planet") ) -- grav, temp, atmos, radius, resources, name

	elseif type == "star" then

		r = 512
		env = GM.class.getClass("Environment"):new( 0, 10000, 0, r, nil, "Star" ) -- grav, temp, atmos, radius, resources, name

	elseif type == "star2" then

		r = tonumber(v[2])
		env = GM.class.getClass("Environment"):new( 0, v[5], 0, r, nil, (string.len(v[6] or "") > 0 and v[6] or "Star") )

	end

	if env and obj and r then
		obj:setEnvironment(env) -- Bind Environment IMMEDIATELY!

		ent = ents.Create("infinity_planet")
		ent:SetPos( v.ent:GetPos())
		ent:SetAngles( v.ent:GetAngles() )
		ent:Spawn()

		ent:PhysicsInitSphere(r)
		ent:SetCollisionBounds( Vector(-r,-r,-r), Vector(r,r,r) )


		obj:setEntity(ent) -- Bind the entity to the celestial

	end
end

--[[
--
-- GM:InitPostEntity( )
-- Called once all map entities have spawned.
--
 ]]

local env_classes = { "env_sun", "logic_case" }
local env_data = {}

function GM:InitPostEntity()
	print("We're doing post Entity shit")

	for i=1, #env_classes do
		local env_data = {}
		local ents = ents.FindByClass(env_classes[i])

		for _, ent in pairs(ents) do
			local tbl = { ent = ent }
			local vals = ent:GetKeyValues()
			for k, v in pairs(vals) do
				tbl[ getKey( k ) ] = v
			end
			table.insert(env_data, tbl )
		end

		for k,v in pairs( env_data ) do
			spawnEnvironment( v )
		end

		print("We've finished that bollocks")
	end
end

function GM:OnEnterEnvironment(env, ent)
	if env:getName() ~= "" then
		print(ent, "Entering: ",env:getName(),"\n")
	end
end

function GM:OnLeaveEnvironment(env, ent)
	if env:getName() ~= "" then
		print(ent, "Leaving: ",env:getName(),"\n")
	end
end

--local space = GM.class.getClass("Environment"):new( 0.0000001, 14, 0, 0, nil, "Space") -- grav, temp, atmos, pressure, resources, name
local space = GM.class.getClass("Space"):new()

function GM:getSpace()
    return space
end

--[[
-- Think function, called every frame. This is an actual Gamemode function, disregard the lack of existence in the actual wiki.
 ]]
function GM:Think()
	space:Think() -- Because it's not bound to a celestial :D
end

function GM:OnEntityCreated( e )

	if e.getEnvironment == nil then --On remove, set them back to space
		print("Spac")
		GM:getSpace():addEntity(e)
		GM:getSpace():setEnvironment( e, GM:getSpace() )
	end

end
