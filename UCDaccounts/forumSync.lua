function createGameAccount(account, password)
	local a = Account.add(account, password)
	outputDebugString("createGameAccount > "..tostring(a))
	return not (not a)
end

function changeGamePassword(account, password)
	local a = Account(account)
	if (a) then
		outputDebugString("Successfully changed password for "..tostring(account))
		return a:setPassword(password)
	end
	outputDebugString("Couldn't change password for "..tostring(account))
	return false
end