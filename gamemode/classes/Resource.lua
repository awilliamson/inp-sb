-- For resources such as Oxygen, Nitrogen, Carbon Dioxide etc
local GM = GM

local C = GM.LCS.class({
	name = "",
	amount = 0
})

function C:init(n, a)
	self:setName( n or self:getName())
	self:setAmount( a or self:getAmount())
end

function C:getName()
	return self.name
end

function C:setName( n )
	if type(n) ~= "number" then error("Expected number, got"..type(n)) return end
	self.name = n
	return
end

function C:getAmount()
	return self.amount
end

function C:setAmount( a )
	if type(a) ~= "number" then error("Expected number, got"..type(a)) return end
	self.amount = a
	return
end


