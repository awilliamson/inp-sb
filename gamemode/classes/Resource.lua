-- For resources such as Oxygen, Nitrogen, Carbon Dioxide etc
local GM = GM

local C = GM.LCS.class({
	name = "",
	amount = 0,
	max = 0
})

function C:init(name, amount, max )
	self:setName( name or self:getName() )
	self:setAmount( amount or self:getAmount() )
	self:setMaxAmount( max or self:getMaxAmount() )
end

function C:getName()
	return self.name
end

function C:setName( n )
	self.name = n
end

function C:getAmount()
	return self.amount
end

function C:setAmount( a )
	self.amount = a
	return
end

function C:getMaxAmount()
	return self.max
end

function C:setMaxAmount( a )
	self.max = a
end

GM.class.registerClass("Resource", C)


