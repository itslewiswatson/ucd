local wait = {}
function clear(plr)
	wait[plr] = nil
end

function gluePlayer(slot, vehicle, x, y, z, rotX, rotY, rotZ)
	if (exports.UCDactions:getAction(client) == "BC") then
		exports.UCDbc:bcDrop()
		return
	end
	if (wait[client] or not exports.UCDchecking:canPlayerDoAction(client, "Glue")) then
		return
	end
	client:attach(vehicle, x, y, z, rotX, rotY, rotZ)
	setPedWeaponSlot(client, slot)
end
addEvent("gluePlayer",true)
addEventHandler("gluePlayer", root, gluePlayer)

function ungluePlayer()
	detachElements(source)
	wait[source] = true
	Timer(clear, 1000, 1, source)
end
addEvent("ungluePlayer",true)
addEventHandler("ungluePlayer", root, ungluePlayer)

function onPlayerContactWithVehicle(_, ele)
	if (ele and ele.type == "vehicle") then
		if (exports.UCDactions:getAction(source) == "BC") then
			exports.UCDbc:bcDrop()
			return
		end
		if (wait[source] or not exports.UCDchecking:canPlayerDoAction(source, "Glue")) then
			return
		end
		outputDebugString("got contact - triggering client")
		triggerClientEvent(source, "UCDglue.glue", source)
	end
end
addEventHandler("onPlayerContact", root, onPlayerContactWithVehicle)

