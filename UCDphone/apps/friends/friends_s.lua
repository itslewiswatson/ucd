friends = {}
blacklist = {}

function requestFriendsList()
	-- We use source here as opposed to client, because this event may be called server-side
	if (not friends[source.account.name]) then
		return false
	end
	local temp = {}
	for acc, perms in pairs(friends[source.account.name]) do
		local onlineLast = 2 --getLastOnline(account)
		local online = false
		local display = exports.UCDaccounts:GAD(acc, "lastUsedName") or acc
		if (Account(acc) and Account(acc).player) then
			online = true
			onlineLast = "Today"
			display = Account(acc).player.name
		end
		table.insert(temp, {acc, display, perms, onlineLast, online})
	end
	triggerLatentClientEvent(source, "SAURfriends.displayFriends", resourceRoot, temp)
end
addEvent("UCDphone.friends.requestFriendsList", true)
addEventHandler("UCDphone.friends.requestFriendsList", root, requestFriendsList)

function requestRequests()
	local account = source.account.name
	if (not requests[account]) then
		return false
	end
	local reqs = {}
	for _, acc in ipairs(requests[account]) do
		local display
		if (Account(acc) and Account(acc).player) then
			display = Account(acc).player.name
		else
			display = exports.UCDaccounts:GAD(acc, "lastUsedName") or acc
		end
		table.insert(reqs, {acc, display})
	end
	triggerLatentClientEvent(source, "UCDphone.friends.onReceivedFriendsList", source, reqs)
end
addEvent("SAURfriends.requestRequests", true)
addEventHandler("SAURfriends.requestRequests", root, requestRequests)
