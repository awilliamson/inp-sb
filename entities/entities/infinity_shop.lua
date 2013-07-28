
ENT.Type = "brush"

--[[
		0 : "Pendrouge"
		1 : "Radijn"
		2 : "Terran"
		3 : "Neutral"
]]--
--Value is a string
function ENT:KeyValue( key, value )	
	if ( key == "Race" ) then
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
			print("Touched by Player matching Race")
		else
			print("Touched by Player")
		end
	end
end

function ENT:Initialize() 
	print("Hello World from Shop with Race: "..self.Race)
end



