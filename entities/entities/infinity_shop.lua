--INP Spacebuild - Shop
--Brush type
ENT.Type = "brush"

local net = net
--[[
		0 : "Pendrouge"
		1 : "Radijn"
		2 : "Terran"
		3 : "Neutral"
]]--

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
		end
	elseif ( key == "Disable" ) then
		self.Disable = value
	end
end

function ENT:StartTouch( ent )
	if(ent:IsPlayer()) then
		if(ent:getRace() == self.Race) then
			--Race matches, They can access the store
			net.Start("INPSpacebuild-Shop:StartTouch")
			net.WriteString( self.Race )
			net.Send(ent)
		end
	end
end

function ENT:StopTouch( ent )
	if(ent:IsPlayer()) then
		if(ent:getRace() == self.Race) then
			--Race matches, They can access the store
			net.Start( "INPSpacebuild-Shop:StopTouch" )
			net.WriteString( self.Race )
			net.Send(ent)
		end
	end
end

--Net Library Messages
util.AddNetworkString("INPSpacebuild-Shop:StartTouch")
util.AddNetworkString("INPSpacebuild-Shop:StopTouch")

if(CLIENT) then

net.Recieve( "INPSpacebuild-Shop:StartTouch", function( length, client )
	local ShopRace = net.ReadString()
	print("We can shop at shoptype: " + ShopRace)
end)

net.Recieve( "INPSpacebuild-Shop:StopTouch", function( length, client )
	local ShopRace = net.ReadString()
	print("We are no longer at " + ShopRace)
end)

end