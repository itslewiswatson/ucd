function createGameAccount(account, password)
	local a = Account.add(account, password)
	outputDebugString("createGameAccount > "..tostring(a))
	return not (not a)
end
