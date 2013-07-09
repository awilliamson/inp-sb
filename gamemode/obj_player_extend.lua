AddCSLuaFile()

local player_manager = player_manager

local meta = FindMetaTable( "Player" )

if not meta then error("Why is there no Player Metatable?") return end

function meta:getRace()
	return player_manager.RunClass( self, "getRace" )
end

function meta:getRaceColor()
	return player_manager.RunClass( self, "getRaceColor" )
end

-- Analytics

function meta:createUser()
	hook.Call( "SBClCreateUser" )
end

function meta:updateUser()
	hook.Call( "SBClUpdateUser" )
end