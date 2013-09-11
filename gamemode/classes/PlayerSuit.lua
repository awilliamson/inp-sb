-- Class for the players suit, used for surviving in other environments

local GM = GM

local C = GM.LCS.class({
	player = nil, -- Player assigned to the suit
	resources = {}, -- Table of resources contained within the suit
	active = false, -- If the suit is powered up/ active
	intake = nil, -- The resource required for respiration
	outtake = nil, -- The resource produced by respiration
})

function C:init( p, i, o )
	self:setPlayer( p or self:getPlayer() )
	self:setIntake( i or self:getIntake() or GM:getResourceType("Oxygen") )
	self:setOuttake( o or self:getOuttake() or GM:getResourceType("CO2") )
end

function C:getPlayer()
	return self.player
end

function C:setPlayer( p )
	if GM:isValid(p) and p:IsPlayer() then
		self.player = p
	end
end

function C:getIntake()
	return self.intake
end

function C:setIntake( i )
	if i.is_A and i:is_A(GM.class.getClass("Resource")) then
		self.intake = i
		return
	end
	error("Expected Intake to be a Resource")
end

function C:getOuttake()
	return self.outtake
end

function C:setOuttake( o )
	if o.is_A and o:is_A( GM.class.getClass("Resource") ) then
		self.outtake = o
		return
	end
	error("Expected Outtake to be a Resource")
end

function C:isActive()
	return self.active
end

function C:setActive( a )
	if type(a) == "boolean" then
		self.active = a
	end
	error("Expected active to be a boolean got,",type(a))
end

function C:getResources()
	return self.resources
end

function C:setResources( r )
	if type(r) == "table" then
		self.resources = r
		return
	end
	error("Expected a table of resources got,",type(r))
end

GM.class.registerClass("PlayerSuit", C )