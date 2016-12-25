Housing = {}
Housing.cache = {}
db = exports.UCDsql:getConnection()

addEventHandler("onPlayerLogin", root,
	function ()
		if (not Housing.cache[source.account.name]) then
			cacheFor(source.account.name)
		end
		triggerEvent("UCDphone.housing.requestHouses", source)
	end
)

addEventHandler("onResourceStart", resourceRoot,
	function ()
		Timer(
			function ()
				for _, plr in ipairs(Element.getAllByType("player")) do
					if (exports.UCDaccounts:isPlayerLoggedIn(plr)) then
						cacheFor(plr.account.name)
					end
				end
			end, 1000, 1
		)
	end
)

function doCache(qh, account)
	local result = qh:poll(0)
	if (#result >= 1) then
		for _, data in ipairs(result) do
			table.insert(Housing.cache[account], data.houseID)
		end
	end
	if (Account(account) and Account(account).player) then
		triggerEvent("UCDphone.housing.requestHouses", Account(account).player)
	end
end

function cacheFor(account)
	Housing.cache[account] = {}
	db:query(doCache, {account}, "SELECT `houseID` FROM `housing` WHERE `owner` = ? AND `owner` <> 'UCDhousing'", account)
end

function Housing.requestHouses()
	if (source and source.type == "player") then
		if (not exports.UCDaccounts:isPlayerLoggedIn(source)) then
			return false
		end
		
		local toSend = {}
		
		if (not Housing.cache[source.account.name]) then
			cacheFor(source.account.name)
		end
		if (#Housing.cache[source.account.name] >= 1) then
			for _, houseID in ipairs(Housing.cache[source.account.name]) do
				toSend[houseID] = {
					["HouseName"] = exports.UCDhousing:getHouseData(houseID, "houseName"),
					["InteriorID"] = exports.UCDhousing:getHouseData(houseID, "interiorID"),
					["InitialPrice"] = exports.UCDhousing:getHouseData(houseID, "initialPrice"),
					["BoughtFor"] = exports.UCDhousing:getHouseData(houseID, "boughtForPrice"),
					["CurrentPrice"] = exports.UCDhousing:getHouseData(houseID, "currentPrice"),
					["Sale"] = exports.UCDhousing:getHouseData(houseID, "sale"),
					["Open"] = exports.UCDhousing:getHouseData(houseID, "open"),
					["Loc"] = {
						x = exports.UCDhousing:getHouseData(houseID, "x"),
						y = exports.UCDhousing:getHouseData(houseID, "y"),
						z = exports.UCDhousing:getHouseData(houseID, "z"),
					},
				}
			end
		end
		triggerLatentClientEvent(source, "UCDphone.housing.populate", source, toSend)
	end
end
addEvent("UCDphone.housing.requestHouses", true)
addEventHandler("UCDphone.housing.requestHouses", root, Housing.requestHouses)

function Housing.onExchangeHouse(houseID, previousOwner) 
	--outputDebugString("houseID => "..tostring(houseID).." : previousOwner => "..tostring(previousOwner)) -- done
	if (previousOwner ~= "UCDhousing") then
		--[[
		if (Housing.cache[previousOwner]) then
			for i, data in ipairs(Housing.cache[previousOwner]) do
				if (data == houseID) then
					table.remove(Housing.cache[previousOwner], i)
					break
				end
			end
			if (not Housing.cache[source.account.name]) then
				Housing.cache[source.account.name] = {}
			end
			table.insert(Housing.cache[source.account.name], houseID)
		end
		--]]
		-- It's async, we can afford to do this
		-- Besides, how often do houses really get purchased?
		cacheFor(previousOwner)
	end
	cacheFor(source.account.name)
end
addEvent("onPlayerBuyHouse")
addEventHandler("onPlayerBuyHouse", root, Housing.onExchangeHouse)
addEvent("onPlayerSellHouseToBank")
addEventHandler("onPlayerSellHouseToBank", root, Housing.onExchangeHouse)
