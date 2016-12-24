local limit = 12
local lastLogins = {}
local db = exports.UCDsql:getConnection()

addEventHandler("onResourceStart", resourceRoot,
	function ()
		for _, plr in ipairs(exports.UCDaccounts:getLoggedInPlayers()) do
			cacheFor(plr.account.name)
		end
	end
)

addEventHandler("onPlayerLogin", root,
	function ()
		cacheFor(source.account.name)
	end
)

function cacheFor(account)
	db:query(cacheLogins, {account}, "SELECT `name`, `type2` AS `ip`, FROM_UNIXTIME(FLOOR(`tick`)) AS `datum`, `serial` FROM `logging` WHERE `account` = ? AND `type` = 'login' ORDER BY `tick` DESC LIMIT ?", account, limit)
end

function cacheLogins(qh, account)
	local result = qh:poll(0)
	lastLogins[account] = result
end

function getLastLogins(account)
	return lastLogins[account]
end

function sendToGUI(plr, receiver)
	local logins = getLastLogins(plr.account.name)
	triggerLatentClientEvent(receiver, "UCDlastLogins.onPopulateClient", resourceRoot, plr.account.name, plr.serial, plr.ip, logins)
end

function getSelfLastLogins()
	if (not exports.UCDaccounts:isPlayerLoggedIn(client)) then
		return
	end
	sendToGUI(client, client)
end
addEvent("UCDlastLogins.onRequestSelfLogins", true)
addEventHandler("UCDlastLogins.onRequestSelfLogins", root, getSelfLastLogins)