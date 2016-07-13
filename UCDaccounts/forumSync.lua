function createGameAccount(account, password)
	local a = Account.add(account, password)
	outputDebugString("createGameAccount > "..tostring(a))
	return not (not a)
end

function changeGamePassword(account, password)
	local a = Account(account)
	if (a) then
		return a:setPassword(password)
	end
	return false
end