function createGameAccount(account, password)
	local a = Account.new(account, password)
	outputDebugString("createGameAccount > "..tostring(a))
	return not (not a)
end
