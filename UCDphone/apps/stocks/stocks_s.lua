Stocks = {}

function Stocks.get()
	local all = exports.UCDstocks:getStocks()
	local own = exports.UCDstocks:getPlayerStocks(client)
	triggerLatentClientEvent(client, "UCDphone.populateStocks", client, all or {}, own or {})
end
addEvent("UCDphone.getStocks", true)
addEventHandler("UCDphone.getStocks", root, Stocks.get)
