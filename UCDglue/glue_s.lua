local wait = {}
function clear(plr)
	wait[plr] = nil
end

function gluePlayer(slot, vehicle, x, y, z, rotX, rotY, rotZ)
	if (wait[client] or exports.UCDlaw:isPlayerArrested(client)) then
		return
	end
	client:attach(vehicle, x, y, z, rotX, rotY, rotZ)
	setPedWeaponSlot(client, slot)
end
addEvent("gluePlayer",true)
addEventHandler("gluePlayer", root, gluePlayer)

function ungluePlayer()
	detachElements(client)
	wait[client] = true
	Timer(clear, 1000, 1, client)
end
addEvent("ungluePlayer",true)
addEventHandler("ungluePlayer", root, ungluePlayer)

function onPlayerContactWithVehicle(_, ele)
	if (ele and ele.type == "vehicle") then
		if (wait[source]) then
			return
		end
		outputDebugString("got contact - triggering client")
		triggerClientEvent(source, "UCDglue.glue", source)
	end
end
addEventHandler("onPlayerContact", root, onPlayerContactWithVehicle)

