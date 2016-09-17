local markers = {}
local db = exports.UCDsql:getConnection()

for _, data in ipairs(atms) do
	local marker = Marker(data.x, data.y, data.z-1, "cylinder", 2, 0, 200, 0, 150)
	table.insert(markers, marker)
end

function toggleGUI(plr, show)
	if (show) then
		if (not plr) then plr = client end
		local logs = dbPoll(dbQuery(db, "SELECT * FROM logging WHERE acc=? AND type=?", plr.account.name, "banking"), -1)
		triggerClientEvent(plr, "toggleBankingGUI", resourceRoot, true, exports.UCDaccounts:GAD(plr, "bankbalance"), logs)
	else
		triggerClientEvent(plr, "toggleBankingGUI", resourceRoot, false)
	end
end

addEventHandler("onMarkerHit", root,
	function (plr, matchingDimension)
		local atmHit = false
		for _, marker in ipairs(markers) do
			if (source == marker) then
				atmHit = true
			end
		end	
		if (plr.inVehicle or doesPedHaveJetPack(plr)) then
			atmHit = false
		end
		--if (plr.name ~= "[UCD]Risk") then return end
		if (atmHit and isElement(plr) and plr.type == "player" and matchingDimension) then
			toggleGUI(plr, true)
		end
	end
)

addEventHandler("onMarkerLeave", root,
	function (plr, matchingDimension)
		local atmLeave = false
		for _, marker in ipairs(markers) do
			if (source == marker) then
				atmLeave = true
			end
		end
		if (atmLeave and isElement(plr) and plr.type == "player" and matchingDimension) then
			toggleGUI(plr, false)
		end
	end
)

addEvent("doBankAction", true)
addEventHandler("doBankAction", resourceRoot,
	function (action, amount, account)
		if (action == "withdraw") then
			client:giveMoney(amount)
			exports.UCDlogging:new(client, "banking", "Withdrawn $"..exports.UCDutil:tocomma(amount))
			exports.UCDaccounts:SAD(client, "bankbalance", exports.UCDaccounts:GAD(client, "bankbalance") - amount)
		elseif (action == "deposit") then
			client:takeMoney(amount)
			exports.UCDlogging:new(client, "banking", "Deposited $"..exports.UCDutil:tocomma(amount))
			exports.UCDaccounts:SAD(client, "bankbalance", exports.UCDaccounts:GAD(client, "bankbalance") + amount)
		elseif (action == "send") then
			if (getAccount(tostring(account))) then
				if (account == client.account.name) then
					exports.UCDdx:new(client, "You can't send money to yourself", 255, 0, 0)
					return
				end
				local sBalance = exports.UCDaccounts:GAD(client.account.name, "bankbalance")
				local rBalance = exports.UCDaccounts:GAD(account, "bankbalance")
				exports.UCDaccounts:SAD(account, "bankbalance", rBalance + amount)
				exports.UCDaccounts:SAD(client.account.name, "bankbalance", sBalance - amount)
				exports.UCDdx:new(client, "Sent $"..exports.UCDutil:tocomma(amount).." to account "..account, 0, 255, 0)
				exports.UCDlogging:new(client, "banking", "Sent $"..exports.UCDutil:tocomma(amount).." to account "..account)
			else
				exports.UCDdx:new(client, "Couldn't find account with this name", 255, 0, 0)
			end
		end
		toggleGUI(client, true)
	end
)