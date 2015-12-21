db = exports.UCDsql:getConnection()
adminTable = {}

addEventHandler("onResourceStart", resourceRoot,
	function ()
		db:query(createAdminTable, {}, "SELECT * FROM `admins`")
	end
)

function createAdminTable(qh)
	local result = qh:poll(-1)
	for _, row in pairs(result) do
		adminTable[row.account] = {}
		for column, value in pairs(row) do
			if (column ~= "account") then
				adminTable[row.account][column] = value
			end
		end
	end
end
