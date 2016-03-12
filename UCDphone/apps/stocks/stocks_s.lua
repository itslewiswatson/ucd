Stocks = {}

function Stocks.get()
	local all = exports.UCDstocks:getStocks()
	local own = exports.UCDstocks:getPlayerStocks(source)
	triggerLatentClientEvent(source, "UCDphone.populateStocks", source, all or {}, own or {})
end
addEvent("UCDphone.getStocks", true)
addEventHandler("UCDphone.getStocks", root, Stocks.get)
