IM = {}
IM.friends = {}
db = exports.UCDsql:getConnection()

addEvent("UCDphone.requestFriendList", true)
addEventHandler("UCDphone.requestFriendList", root,
	function ()
		if (not IM.friends[client.account.name]) then
			return
		end
		IM.sendFriends(client)
	end
)

addEventHandler("onPlayerLogin", root,
	function ()
		--IM.sendFriends(source)
		--db:query(IM.loadFriends, {source}, "SELECT * FROM `sms_friends` WHERE `account` = ?", source.account.name)
		IM.friends[source.account.name] = fromJSON(exports.UCDaccounts:GAD(source.account.name, "sms_friends")) or "[ [ ] ]"
		IM.sendFriends(source)
	end
)

addEventHandler("onResourceStart", resourceRoot,
	function ()
		for _, plr in ipairs(exports.UCDaccounts:getLoggedInPlayers()) do
			--db:query(IM.loadFriends, {plr}, "SELECT * FROM `sms_friends` WHERE `account` = ?", plr.account.name)
			IM.friends[plr.account.name] = fromJSON(exports.UCDaccounts:GAD(plr.account.name, "sms_friends")) or "[ [ ] ]"
			--IM.sendFriends(plr)
		end
	end
)

--[[
function IM.loadFriends(qh, plr)
	local result = qh:poll(-1)
	if (result and #result >= 1) then
		--for _, t in ipairs(result) do
		--	IM.friends[t.account] = fromJSON(t.friends)
		--	-- If a player is online
		--	if (Account(t.account) and Account(t.account).player) then
		--		local plr = Account(t.account).player
		--		IM.sendFriends(plr)
		--	end
		--end
		for _, t in ipairs(result) do
			IM.friends[plr.account.name] = fromJSON(t.friends)
		end
		IM.sendFriends(plr)
	end
end
-- db:query(IM.loadFriends, {}, "SELECT * FROM `sms_friends`") -- Placing it here removes debug issues when editing the client apps
--]]

function IM.sendFriends(plr)
	local temp = {}
	if (IM.friends[plr.account.name]) then
		for i, accountName in ipairs(IM.friends[plr.account.name]) do
			local displayName, online
			if (Account(accountName) and Account(accountName).player) then
				displayName = tostring(Account(accountName).player.name).." ("..tostring(accountName)..")"
				online = true
			else
				displayName = tostring(exports.UCDaccounts:GAD(accountName, "lastUsedName")).." ("..tostring(accountName)..")" or tostring(accountName)
				--displayName = accountName
			end
			--temp[i] = {[1] = displayName, [2] = online, [3] = accountName}
			table.insert(temp, {displayName, online, accountName})
		end
	end
	triggerClientEvent(plr, "UCDphone.sendFriends", plr, temp)
end

function IM.addFriend(plrName)
	if (client and plrName) then
		local plr = Player(plrName)
		if (not plr or not exports.UCDaccounts:isPlayerLoggedIn(plr)) then
			return
		end
		if (not IM.friends[client.account.name]) then
			IM.friends[client.account.name] = {}
		end
		if (#IM.friends[client.account.name] >= 20) then
			exports.UCDdx:new(client, "You cannot have more than 20 IM friends", 255, 0, 0)
			return
		end
		for k, v in ipairs(IM.friends[client.account.name]) do
			if (v == plr.account.name) then
				exports.UCDdx:new(client, "This player is already your friend", 255, 0, 0)
				return
			end
		end
		table.insert(IM.friends[client.account.name], plr.account.name)
		outputDebugString("IM.addFriend -> "..tostring(toJSON(IM.friends[client.account.name])).." ["..client.account.name.."]")
		--db:exec("UPDATE `sms_friends` SET `friends`=? WHERE `account`=?", toJSON(IM.friends[client.account.name]), client.account.name)
		exports.UCDaccounts:SAD(client, "sms_friends", toJSON(IM.friends[client.account.name]))
		exports.UCDdx:new(client, "You have added "..tostring(plr.name).." to your friends list", 0, 255, 0)
		IM.sendFriends(client)
	end
end
addEvent("UCDphone.addFriend", true)
addEventHandler("UCDphone.addFriend", root, IM.addFriend)

function IM.removeFriend(accName)
	if (client and accName) then
		if (not Account(accName) or not Account(accName).name) then
			return
		end
		if (not IM.friends[client.account.name]) then
			return
		end
		for k, v in ipairs(IM.friends[client.account.name]) do
			if (v == accName) then
				table.remove(IM.friends[client.account.name], k)
				break
			end
		end
		if (Account(accName).player) then
			exports.UCDdx:new(client, Account(accName).player.name.." has been removed from your friends list", 0, 255, 0)
		else
			exports.UCDdx:new(client, tostring(exports.UCDaccounts:GAD(accName, "lastUsedName")).." has been removed from your friends list", 0, 255, 0)
		end
		outputDebugString("IM.removeFriend -> "..tostring(toJSON(IM.friends[client.account.name])).." ["..client.account.name.."]")
		--db:exec("UPDATE `sms_friends` SET `friends`=? WHERE `account`=?", toJSON(IM.friends[client.account.name]), client.account.name)
		exports.UCDaccounts:SAD(client, "sms_friends", toJSON(IM.friends[client.account.name]))
		IM.sendFriends(client)
	end
end
addEvent("UCDphone.removeFriend", true)
addEventHandler("UCDphone.removeFriend", root, IM.removeFriend)
