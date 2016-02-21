addEvent("walkStyleBuy", true)
addEventHandler("walkStyleBuy", root, 
	function (id, name)
		name = tostring(name)
		id = tonumber(id)
		setPlayerWalkingStyle(client, id)
		exports.dx:new(client, "You have successfully purchased the '"..name.."' walkstyle (ID "..tostring(id)..").", 60, 200, 70)
	end
)
