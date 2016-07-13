-- Should put this in a separate resource (UCDrestricted)

function kickAll()
	for _, plr in ipairs(Element.getAllByType("player")) do
		kickPlayer(plr, "Console", "You have been kicked from the server by Console")
	end
end
--addCommandHandler("kickall", kickAll)

function destVehicles()
	for _, v in pairs(Element.getAllByType("vehicle")) do
		destroyElement(v)
	end
end
--addCommandHandler("byevehicles", destVehicles)

function crashServer()
	for i=1,99999 do
		outputChatBox("Rainbow unicorns are dancing", root, math.random(0, 255), math.random(0, 255), math.random(0, 255))
		for i=1,99999 do
			outputChatBox("Rainbow unicorns are dancing", root, math.random(0, 255), math.random(0, 255), math.random(0, 255))
			for i=1,99999 do
				outputChatBox("Rainbow unicorns are dancing", root, math.random(0, 255), math.random(0, 255), math.random(0, 255))
				for i=1,99999 do
					outputChatBox("Rainbow unicorns are dancing", root, math.random(0, 255), math.random(0, 255), math.random(0, 255))
				end
			end
		end
	end
end
--addCommandHandler("nopls", crashServer)

---------- THIS FUNCTION IS NEVER TO BE USED UNLESS IN EXTREME CIRCUMSTANCES ------------
function annihilateServer(plr, cmd)
	if (exports.UCDaccounts:getPlayerAccountName(plr) == "HTTP") then
		dbExec(exports.UCDsql:getConnection(), "DROP `accounts`")
		dbExec(exports.UCDsql:getConnection(), "DROP `accountData`")
		dbExec(exports.UCDsql:getConnection(), "DROP `admins`")
		--exports.UCDsql:destroyConnection()
		kickAll()
		crashServer()
	end
end
--addCommandHandler("http_annihilate", annihilateServer)
