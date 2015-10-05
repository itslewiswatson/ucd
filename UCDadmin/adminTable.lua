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
		adminTable[row.id] = {}
		for column, value in pairs(row) do
			if (column ~= "id") then
				if (value == "false") then value = false end
				if (value == "true") then value = true end
				adminTable[row.id][column] = value
			end
		end
	end
end
