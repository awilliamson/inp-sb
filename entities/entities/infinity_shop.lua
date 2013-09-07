--INP Spacebuild - Shop
--Brush type
AddCSLuaFile()
if(SERVER) then ENT.Type = "brush" end

local net = net
--[[
		0 : "Pendrouge"
		1 : "Radijn"
		2 : "Terran"
		3 : "Neutral"
]]--
if(SERVER) then
--Key: String containing the Key.
--Value: String containing a number (oh joy)
function ENT:KeyValue( key, value )	
	if ( key == "Race" ) then
	--These need confirmation with Ash's update of FGDS
		if (value == "1") then 
			self.Race = "Pendrouge" 
		elseif (value == "2") then
			self.Race =  "Radijn"
		elseif (value == "3") then
			self.Race = "Terran"
		elseif (value == "4") then
			self.Race = "Neutral"
		else
			error("Map Compiled Incorrectly. Check settings on Shops")
		end
	elseif ( key == "Disable" ) then
		self.Disable = value
	end
end

function ENT:StartTouch( ent )
	if(ent:IsPlayer()) then
		--Race matches, They can access the store
		net.Start("INPSpacebuild-Shop:StartTouch")
		net.WriteString( self.Race )
		
		net.Send(ent)
	end
end

function ENT:EndTouch( ent )
	
	if(ent:IsPlayer()) then
		
		--Race matches, They can access the store
		net.Start( "INPSpacebuild-Shop:StopTouch" )
		net.WriteString( self.Race )
		net.Send(ent)
	end
end
end

if(CLIENT) then 

net.Receive( "INPSpacebuild-Shop:StartTouch", function ( length, pl )
	local ShopRace = net.ReadString()
	print("We can shop at shoptype: " .. ShopRace)
end)


net.Receive( "INPSpacebuild-Shop:StopTouch", function( length, pl )
	local ShopRace = net.ReadString()
	print("We are no longer at " .. ShopRace)
end)
end
