local sX, sY = guiGetScreenSize()
local window = GuiWindow(0, (sY * 0.39833334088326), sX, sY, "UCD | Logging", false)
window:setSize(sX, (sY - (sY * 0.39833334088326)), false)
window.visible = false
local list = GuiGridList(0, 20, sX, sY, false, window)
list.sortingEnabled = false
list:addColumn("Name", 0.1)
list:addColumn("Account", 0.05)
list:addColumn("Action", 0.25+0.21)
list:addColumn("Date", 0.08)
list:addColumn("Type 1", 0.05)
list:addColumn("Type 2", 0.05)
list:addColumn("Serial", 0.18)

function table.reverse(t)
    local reversedTable = {}
    local itemCount = #t
    for k, v in ipairs(t) do
        reversedTable[itemCount + 1 - k] = v
    end
    return reversedTable
end

function formatTick(tick)
	tick = getRealTime(tonumber(tick))
	return string.format("%02d:%02d:%02d - %02d/%02d/%04d",
		tick.second,
		tick.minute,
		tick.hour,
		tick.monthday,
		tick.month + 1,
		tick.year + 1900
	)
end

function logsView(logs)
	list:clear()
	logs = table.reverse(logs)
	for _, log in ipairs(logs) do
		for k, v in pairs(log) do
			log[k] = tostring(v)
		end
		local row = list:addRow()
		list:setItemText(row, 1, log.name, false, false)
		list:setItemText(row, 2, log.acc, false, false)
		list:setItemText(row, 3, log.action, false, false)
		list:setItemText(row, 4, formatTick(log.tick), false, false)
		list:setItemText(row, 5, log.type, false, false)
		list:setItemText(row, 6, log.type2, false, false)
		list:setItemText(row, 7, log.serial, false, false)
	end
end
addEvent("logsView", true)
addEventHandler("logsView", resourceRoot, logsView)

addCommandHandler("logs",
	function ()
		if (localPlayer.name == "[UCD]Risk" or localPlayer.name == "[UCD]Hans") then
			window.visible = not window.visible
		end
	end
)