-- This is just a simple point entity.

-- We only use it to represent the position and angle of a spawn point
-- So we don't have to do anything here because the baseclass will 
-- take care of the basics

-- This file only exists so that the entity is created

ENT.Type = "point"
ENT.Race = "0"
--[[
		1 : "Pendrouge"
		2 : "Radijn"
		3 : "Terran"
]]--
--VALUE IS GURANTEED TO BE A STRING
function ENT:KeyValue( key, value )	
	print(key)
	if ( key == "Race" ) then
		if (value == "1") then 
			self.Race = "Pendrouge"
		elseif (value == "2") then
			self.Race =  "Radijn"
		elseif (value == "3") then
			self.Race = "Terran"
		else
			self.Race = value
			print(type(value))
		end
	elseif ( key == "Disable" ) then
		self.Disable = value
	end
end


function ENT:Initialize() 
	print("Hello World from Player Start`")
end
