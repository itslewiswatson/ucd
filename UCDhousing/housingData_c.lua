-- Congratulations, you got rid of this shit

--[[
-- Change this variable sometime to not cause confustion with the houseData table
housingData = {}

-- We shouldn't sync the whole table, maybe just the new additions? I dunno.
function syncHousingTable(sync)
	housingData = sync
end
addEvent("UCDhousing.syncHousingTable", true)
addEventHandler("UCDhousing.syncHousingTable", root, syncHousingTable)

function syncHouse(houseID, houseTable)
	if (not houseID) or (not houseTable) then
		return
	end
	housingData[houseID] = houseTable
	outputDebugString("Synced housing data for houseID = "..houseID)
end
addEvent("UCDhousing.syncHouse", true)
addEventHandler("UCDhousing.syncHouse", root, syncHouse)

-- I didn't want to request the data on resource start, but we'll need a login event of some sort (client-side)
-- This is only for if the resource is restarted
function requestHousingTableSync()
	if (exports.UCDaccounts:isPlayerLoggedIn(localPlayer)) then
		setTimer(
			function ()
				triggerServerEvent("UCDhousing.requestHousingTableSync", localPlayer)
			end, 500, 1, localPlayer
		)
	end
end
addEventHandler("onClientResourceStart", resourceRoot, requestHousingTableSync)

function getHouseData(houseID, column)
	if (not houseID) or (not column) then
		return nil
	end
	if (type(column) ~= "string") or (type(houseID) ~= "number") then
		return false
	end
	
	if (column == "*") then
		return housingData[houseID]
	else
		if (housingData[houseID] == nil) or (housingData[houseID][column] == nil) then
			return nil
		end
	end
	outputDebugString("Client call for getHouseData. Column: "..column.." houseID: "..houseID)
	return housingData[houseID][column]
end
--]]
