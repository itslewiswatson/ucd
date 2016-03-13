db = exports.UCDsql:getConnection()
stocks = {}
shareholders = {}
shares = {}

addEventHandler("onResourceStart", resourceRoot,
	function ()
		db:query(cacheStocks, {}, "SELECT * FROM `stocks__`")
	end
)

function cacheStocks(qh)
	local result = qh:poll(-1)
	for i, row in ipairs(result or {{}}) do
		stocks[row.acronym] = {}
		for column, value in pairs(row) do
			if (column ~= "acronym") then
				if (column == "prev" or column == "price") then
					value = exports.UCDutil:mathround(value, 2)
				end
				stocks[row.acronym][column] = value
			end
		end
	end
	outputDebugString("Stocks successfully cached!")
	db:query(cacheShareholders, {}, "SELECT * FROM `stocks__holders`")
end

function cacheShareholders(qh)
	local result = qh:poll(-1)
	for i, row in ipairs(result or {{}}) do
		if (not shareholders[row.acronym]) then
			shareholders[row.acronym] = {}
		end
		table.insert(shareholders[row.acronym], row.account)
	end
	cacheShares(result)
end

function cacheShares(result)
	for i, row in ipairs(result or {{}}) do
		if (not shares[row.account]) then
			shares[row.account] = {}
		end
		shares[row.account][row.acronym] = row.amount
	end
end

function getStockPrice(stockName)
	if (not stockName or not stocks[stockName] or not stocks[stockName][price]) then return false end
	return stocks[stockName][price]
end

function getStockName(stockName)
	if (not stockName or not stocks[stockName] or not stocks[stockName][name]) then return false end
	return stocks[stockName][name]
end

function getShareholders(stockName)
	if (not stockName or not stocks[stockName] or not shareholders[stockName]) then return end
	return shareholders[stockName], #shareholders[stockName]
end

-- 
-- db:query(SELECT * FROM `stocks__transactions` WHERE `account`=? AND `acronym`=?, account, acronym)
-- 

function getPlayerStocks(plr)
	if (not plr) then return end
	if (not isElement(plr) or plr.type ~= "player" or not exports.UCDaccounts:isPlayerLoggedIn(plr)) then return false end
	local own = {}
	for acronym, info in pairs(stocks) do
		for k, amount in pairs(shares[plr.account.name] or {}) do
			if (k == acronym) then
				if (not own[acronym]) then
					own[acronym] = {}
				end
				own[acronym] = {amount}
			end
		end
		if (own and own[acronym] and #own[acronym] > 0) then
			-- OLD METHOD
			--[[
			local p = 0
			local result = db:query("SELECT `price` FROM `stocks__transactions` WHERE `account` = ? AND `acronym` = ? AND `action` = ?", plr.account.name, acronym, "bought"):poll(-1)
			if (result and #result > 0) then
				for i = 1, #result do
					if (result[i + 1]) then
						p = result[i].price + result[i + 1].price
					else
						p = p + result[i].price
					end
				end
				table.insert(own[acronym], p)
				--outputDebugString(#own[acronym])
			end
			]]--
			local p = 0
			local sind = -1
			local result = db:query("SELECT `price`, `action` FROM `stocks__transactions` WHERE `account` = ? AND `acronym` = ? ORDER BY `transacID` DESC", plr.account.name, acronym):poll(-1)
			if (result and #result >= 1) then
				for i = 1, #result do
					if (result[i].action == "sold") then
						p = p - result[i].price
					else
						p = p + result[i].price
					end
				end
				table.insert(own[acronym], p)
				--outputDebugString(tostring(acronym).." -> "..tostring(p))
			end
		end
	end
	return own
end

function getStocks()
	local temp = {}
	for acronym, info in pairs(stocks) do
		local stockCount = getAvailableStocks(acronym)
		local _, shareholders = getShareholders(acronym)
		temp[acronym] = {info.name, info.price, info.prev, shareholders or 0, info.total, stockCount, info.mininvest, info.minsell}
	end
	return temp
end

function getAvailableStocks(stockName)
	if (not stocks[stockName]) then return false end
	local stockCount = stocks[stockName].total	
	for i, info in pairs(shares) do
		for acronym, amount in pairs(info) do
			if (acronym == stockName) then
				stockCount = stockCount - amount
			end
		end
	end
	return stockCount
end

function sendStocks(show)
	local temp = getStocks()
	local own = getPlayerStocks(source)
	triggerLatentClientEvent(source, "UCDstocks.toggleGUI", source, temp or {}, own or {}, show)
end
addEvent("UCDstocks.getStocks", true)
addEventHandler("UCDstocks.getStocks", root, sendStocks)

function sellStocks(stockName, amount, clientPrice)
	if (client and stockName and amount and clientPrice) then
		local amount = tonumber(amount)
		local clientPrice = math.floor(clientPrice)
		local price = math.floor(stocks[stockName].price * amount)
		local options = shares[client.account.name][acronym]
		
		if (not stocks[stockName]) then
			exports.UCDdx:new(client, "This stock no longer exists", 255, 0, 0)
			return
		end
		if (not shares[client.account.name] or not shares[client.account.name][acronym]) then
			exports.UCDdx:new(client, "You do not own any options of this stock", 255, 0, 0)
			return
		end
		if (clientPrice ~= price) then
			exports.UCDdx:new(client, "Prices have changed since you tried to sell these stocks. Please sell them again.", 255, 0, 0)
			return
		end
		if (amount > stocks[stockName].total or amount > options) then
			exports.UCDdx:new(client, "You don't own this many stock options", 255, 0, 0)
			return
		end
		
		if (options - amount == 0) then
			shares[client.account.name][stockName] = nil
			db:exec("DELETE FROM `stocks__holders` WHERE `account` = ? AND `acronym` = ?", client.account.name, stockName)
		else
			shares[client.account.name][stockName] = options - amount
			db:exec("UPDATE `stocks__holders` SET `amount` = `amount` - ? WHERE `account` = ? AND `acronym` = ?", amount, client.account.name, stockName)
		end
		
		client.money = client.money + price
		exports.UCDdx:new(client, "Sold "..tostring(exports.UCDutil:tocomma(amount)).." stock options of "..tostring(stockName).." for $"..tostring(exports.UCDutil:tocomma(price)), 0, 255, 0)
		db:exec("INSERT INTO `stocks__transactions` (`acronym`, `account`, `price`, `options`, `action`) VALUES (?, ?, ?, ?, ?)", stockName, client.account.name, price, amount, "sold")
		
		triggerEvent("UCDstocks.getStocks", client)
		triggerEvent("UCDphone.getStocks", client)
	end
end

function buyStock(stockName, amount, clientPrice)
	if (client and stockName and amount and clientPrice) then
		local amount = tonumber(amount)
		local clientPrice = math.floor(clientPrice)
		local price = math.floor(stocks[stockName].price * tonumber(amount))
		
		if (not stocks[stockName]) then
			exports.UCDdx:new(client, "This stock no longer exists", 255, 0, 0)
			return
		end
		-- Mainly used for when someone has high ping
		if (clientPrice ~= price) then	
			exports.UCDdx:new(client, "Prices have changed since you tried to purchase these stocks. Please purchase them again.", 255, 0, 0)
			return
		end
		local available = getAvailableStocks(stockName)
		if (available == 0) then
			exports.UCDdx:new(client, "No stocks options are available", 255, 0, 0)
			return
		end
		if (available < tonumber(amount)) then
			exports.UCDdx:new(client, "There aren't this many stock options available", 255, 0, 0)
			return
		end
		if (client.money < price) then
			exports.UCDdx:new(client, "You don't have enough money to buy this quantity of stock options", 255, 0, 0)
		end
		
		if (not shareholders[stockName]) then
			shareholders[stockName] = {}
		end
		
		local hasStock
		for _, v in pairs(shareholders[stockName]) do
			if (v == client.account.name) then
				hasStock = true
				break
			end
		end
		if (not hasStock) then
			table.insert(shareholders[stockName], client.account.name)
		end
		if (not shares[client.account.name]) then
			shares[client.account.name] = {}
		end
		if (not shares[client.account.name][stockName]) then
			shares[client.account.name][stockName] = 0
			db:exec("INSERT INTO `stocks__holders` (`account`, `acronym`, `amount`) VALUES (?, ?, ?)", client.account.name, stockName, amount) -- Use column names
		else
			db:exec("UPDATE `stocks__holders` SET `amount` = `amount` + ? WHERE `account` = ? AND `acronym` = ?", amount, client.account.name, stockName)
		end
		shares[client.account.name][stockName] = shares[client.account.name][stockName] + amount
		client.money = client.money - price
		exports.UCDdx:new(client, "You have bought "..tostring(exports.UCDutil:tocomma(amount)).." stock options of "..tostring(stockName).." for $"..tostring(exports.UCDutil:tocomma(price)), 0, 255, 0)
		db:exec("INSERT INTO `stocks__transactions` (`acronym`, `account`, `price`, `options`, `action`) VALUES (?, ?, ?, ?, ?)", stockName, client.account.name, price, amount, "bought")
		
		triggerEvent("UCDstocks.getStocks", client)
		triggerEvent("UCDphone.getStocks", client)
	end
end
addEvent("UCDstocks.buyStock", true)
addEventHandler("UCDstocks.buyStock", root, buyStock)

function onStockMarketUpdate()
	--triggerClientEvent(exports.UCDaccounts:getLoggedInPlayers(), "onClientStockMarketUpdate", resourceRoot)
	for _, plr in ipairs(exports.UCDaccounts:getLoggedInPlayers()) do
		triggerEvent("UCDstocks.getStocks", plr, false)
		triggerEvent("UCDphone.getStocks", plr)
	end
end
addEvent("onStockMarketUpdate")
addEventHandler("onStockMarketUpdate", root, onStockMarketUpdate)

function updateStockMarket()
	for name in pairs(stocks) do
		local currPrice = stocks[name]["price"]
		local percent = {}
		percent[20] = currPrice * 0.3
		percent[150] = currPrice * 1.5
		local low = math.random(percent[20], currPrice)
		local high = math.random(currPrice, percent[150])
		
		
		stocks[name]["prev"] = currPrice
		stocks[name]["price"] = math.random(low, high)
		triggerEvent("onStockMarketUpdate", resourceRoot)
		appendStockHistory(name)
	end
end
addCommandHandler("fuckstocks", updateStockMarket)

function appendStockHistory(stockName)
	local price = stocks[stockName]["price"]
	db:exec("INSERT INTO `stocks__history` (`datum`, `acronym`, `price`) VALUES (UNIX_TIMESTAMP(), ?, ?)", stockName, price)
end

function getStockHistory(stockName, limit)
	local result = db:query("SELECT `acronym`, `price`, FROM_UNIXTIME(`datum`) AS `datum` FROM `stocks__history` WHERE `acronym` = ? ORDER BY `datum` DESC LIMIT ?", stockName, limit):poll(-1)
	return result or {}
end

function getHistory(stockName)
	if (client and stockName) then
		local hist = getStockHistory(stockName, 10)
		triggerLatentClientEvent(client, "UCDstocks.showHistory", client, hist or {})
	end
end
addEvent("UCDstocks.getHistory", true)
addEventHandler("UCDstocks.getHistory", root, getHistory)
