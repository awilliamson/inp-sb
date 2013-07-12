-- This is simply a test class for the class system.
-- cls:init(...) is always called for object instantiation
-- ensure that a call to GM.class.registerClass is done with the name of the class (for get and descriptive purposes) as well as the table which is to be the class.

local GM = GM

local Person = GM.LCS.class({name = "John Doe"}) --this is the same as class('Person', Object) or Object:subclass('Person')

function Person:init(name)
	self.name = name
end
function Person:speak()
	print('Hi, I am ' .. self.name ..'.')
end

GM.class.registerClass("Person", Person)