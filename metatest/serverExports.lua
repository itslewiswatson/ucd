--[[
local t = 

Test = {}
Test.__index = Test

function Test.create(balance)
   local acnt = {}             -- our new object
   setmetatable(acnt, Test)  -- make Test handle lookup
   acnt.balance = balance      -- initialize our object
   return acnt
end

function Test:withdraw(amount)
   self.balance = self.balance - amount
end

function getTestClass()
	return t
end
]]

Test = {}
Test.__index = Test

-- Static function
-- Like Element.getAllByType()
function Test.create(balance)
   local t = {}
   setmetatable(t, Test)
   t.balance = balance
   return t
end

-- Instance function
-- Like player:setHealth()
function Test:withdraw(amount)
	outputDebugString(self.balance)
	self.balance = self.balance - amount
	outputDebugString(self.balance)
end

--acc = Test.create(1000)
--acc:withdraw(10)
s = [[
function Player:test()
	outputDebugString(self:getName())
end
]]

function getTestClass()
	return s
end 
