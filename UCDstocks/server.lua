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
-- db:query(SELECT * FROM `stocks__history` WHERE `account`=? AND `acronym`=?, account, acronym)
-- 

function sendStocks()
	local temp = {}
	local own = {}
	for acronym, info in pairs(stocks) do
		local stockCount = 0
		local _, shareholders = getShareholders(acronym)
		for k, amount in pairs(shares[source.account.name] or {}) do
			if (k == acronym) then
				if (not own[acronym]) then
					own[acronym] = {}
				end
				own[acronym] = {amount}
				
				stockCount = stockCount + amount
			end
		end
		temp[acronym] = {info.name, info.price, info.prev, shareholders or 0, info.total, stockCount, info.mininvest, info.minsell}
		if (own and own[acronym] and #own[acronym] > 0) then
			local p = 0
			local result = db:query("SELECT `price` FROM `stocks__history` WHERE `account`=? AND `acronym`=? AND `action`=?", source.account.name, acronym, "bought"):poll(-1)
			if (result and #result > 0) then
				for i = 1, #result do
					if (result[i + 1]) then
						p = result[i].price + result[i + 1].price
					else
						p = p + result[i].price
					end
				end
				table.insert(own[acronym], p)
				outputDebugString(#own[acronym])
			end
		end
	end
	triggerLatentClientEvent(source, "UCDstocks.toggleGUI", source, temp or {}, own or {})
end
addEvent("UCDstocks.getStocks", true)
addEventHandler("UCDstocks.getStocks", root, sendStocks)

function buyStock()
	
end

function onStockMarketUpdate()
	triggerClientEvent(exports.UCDaccounts:getLoggedInPlayers(), "onStockMarketUpdate", resourceRoot)
	for _, plr in ipairs(exports.UCDaccounts:getLoggedInPlayers()) do
		triggerEvent("UCDstocks.getStocks", plr)
	end
end
addEvent("onStockMarketUpdate")
addEventHandler("onStockMarketUpdate", root, onStockMarketUpdate)

