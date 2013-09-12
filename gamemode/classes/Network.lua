local GM = GM

local C = GM.LCS.class({
	resources = {}
})

function C:init( node )
	self:setNode( node )
	
	for name, _ in pairs( GM:getResourceTypes() ) do
		self.resources[name] = GM:newResource( name )
	end
end

function C:getNode()
	return self.node
end

function C:setNode( node )
	self.node = node
end

GM.class.registerClass("Network", C)


