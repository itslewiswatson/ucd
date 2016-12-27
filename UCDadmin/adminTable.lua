db = exports.UCDsql:getConnection()
adminTable = {}

addEventHandler("onResourceStart", resourceRoot,
	function ()
		db:query(createAdminTable, {}, "SELECT * FROM `admins`")
	end
)

function createAdminTable(qh)
	local result = qh:poll(-1)
	for _, row in pairs(result or {}) do
		adminTable[row.account] = {}
		for column, value in pairs(row) do
			if (column ~= "account") then
				adminTable[row.account][column] = value
			end
		end
	end
	for _, plr in ipairs(Element.getAllByType("player")) do
		if (isPlayerAdmin(plr)) then
			sendPermissions(plr)
		end
	end
	outputDebugString("["..tostring(getThisResource().name).."] Admins successfully cached!")
end
