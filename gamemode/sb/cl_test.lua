local GM = GM
local class = GM.class
local Person = GM.class.getClass("Person")

--local p1 = class.new("Person", "Billy the Kid") -- this is equivalent to AgedPerson('Billy the Kid', 13) - the :new part is implicit
--local p2 = class.new("Person", "Luke Skywalker")

local p1 = Person:new("Billy the kid")

p1:speak()
--p2:speak()
