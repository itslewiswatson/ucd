db = exports.UCDsql:getConnection()
adminLog = {}

addEventHandler("onResourceStart", resourceRoot,
	function ()
		db:query(cacheDatabase, {}, "SELECT FROM_UNIXTIME(FLOOR(`datum`)) AS `tick`, `name`, `serial`, `log_` FROM `adminlog` ORDER BY logID DESC LIMIT 500")
	end
)

function cacheDatabase(qh)
	local result = qh:poll(0)
	for _, row in pairs(result) do
		table.insert(
            adminLog,
            {
                ["date"] = row.tick,
                ["account"] = row.name,
                ["serial"] = row.serial,
                ["action"] = row["log_"]
            }
        )
	end
	outputDebugString("["..tostring(getThisResource().name).."] Admin log successfully cached!")
end

function onRequestFetchAdminLog()
    if (not isPlayerAdmin(client)) then return end
    triggerClientEvent("UCDadmin.populateAdminLog", client, adminLog)
end
addEvent("UCDadmin.fetchAdminLog", true)
addEventHandler("UCDadmin.fetchAdminLog", root, onRequestFetchAdminLog)