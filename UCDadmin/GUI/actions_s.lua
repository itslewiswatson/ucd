vowels = {["a"] = true, ["e"] = true, ["i"] = true, ["o"] = true, ["u"] = true}

function givePlayerWeapon_(plr, weapon, amount)
	if (plr and client and weapon and amount and isPlayerAdmin(client)) then
		giveWeapon(plr, weapon, amount, true)
		local weaponName = getWeaponNameFromID(weapon)
		if (vowels[weaponName:sub(1, 1):lower()]) then
			exports.UCDdx:new(client, "You have given "..plr.name.." an "..weaponName.." ("..amount..")", 0, 255, 0)
			exports.UCDdx:new(plr, client.name.." has given you an "..weaponName.." ("..amount..")", 0, 255, 0)
		else
			exports.UCDdx:new(client, "You have given "..plr.name.." a "..weaponName.." ("..amount..")", 0, 255, 0)
			exports.UCDdx:new(plr, client.name.." has given you a "..weaponName.." ("..amount..")", 0, 255, 0)
		end
	end
end
addEvent("UCDadmin.giveWeapon", true)
addEventHandler("UCDadmin.giveWeapon", root, givePlayerWeapon_)

function warpToPlayer(plr)
	if (plr and client and isPlayerAdmin(client)) then
		if (client == plr) then return end
		if (plr.dimension ~= client.dimension) then
			client.dimension = plr.dimension
		end
		if (plr.interior ~= client.interior) then
			client.interior = plr.interior
		end
		if (plr.vehicle) then
			local seats = plr.vehicle.maxPassengers + 100
			local i = 0
			while (i < seats) do
				if (not getVehicleOccupant(plr.vehicle, i)) then
   					client:warpIntoVehicle(plr.vehicle, i)
					break
				end
				i = i + 1
			end
			if (i >= seats) then
				exports.UCDdx:new(client, "This player's vehicle is full", 255, 0, 0)
				return
			end
		end
		
		local position = plr.matrix.position + plr.matrix.forward * 2
		client:setPosition(position)
		exports.UCDdx:new(client, "You have warped to "..plr.name, 0, 255, 0)
	end
end
addEvent("UCDadmin.warpToPlayer", true)
addEventHandler("UCDadmin.warpToPlayer", root, warpToPlayer)

function warpPlayerTo(plr, warpTo)
	if (plr and client and warpTo and isPlayerAdmin(client)) then
		if (isElement(warpTo) and warpTo.type == "player") then
			if (plr == warpTo) then
				return
			end
			if (plr.vehicle) then
				plr:removeFromVehicle(plr.vehicle)
			end
			if (plr.dimension ~= warpTo.dimension) then
				plr.dimension = warpTo.dimension
			end
			if (plr.interior ~= warpTo.interior) then
				plr.interior = warpTo.interior
			end
			local position = warpTo.matrix.position + warpTo.matrix.forward * 2
			plr:setPosition(position)
			if (warpTo == client) then
				exports.UCDdx:new(plr, client.name.." has warped you to them", 0, 255, 0)
				exports.UCDdx:new(client, "You have warped "..plr.name.." to you", 0, 255, 0)
			else
				exports.UCDdx:new(plr, "You have been warped to "..warpTo.name.." by "..client.name, 0, 255, 0)
				exports.UCDdx:new(client, "You have warped "..plr.name.." to "..warpTo.name, 0, 255, 0)
			end
		end
	end
end
addEvent("UCDadmin.warpPlayerTo", true)
addEventHandler("UCDadmin.warpPlayerTo", root, warpPlayerTo)

function reconnectPlayer(plr)
	if (plr and client and isPlayerAdmin(client)) then
		if (isPlayerOwner(plr) and not isPlayerOwner(client)) then return end
		exports.UCDdx:new(client, "You have reconnected "..plr.name, 0, 255, 0)
		plr:redirect("", getServerPort()) -- Redirects to the same server with the same port
		outputChatBox(plr.name.." has been reconnected by "..client.name, root, 255, 140, 0)
	end
end
addEvent("UCDadmin.reconnect", true)
addEventHandler("UCDadmin.reconnect", root, reconnectPlayer)

function kickPlayer_(plr, reason)
	if (plr and client and reason and isPlayerAdmin(client)) then
		if (isPlayerOwner(plr) and not isPlayerOwner(client)) then return end
		if reason == " " or reason == "" then
			exports.UCDdx:new(client, "You have kicked "..plr.name, 0, 255, 0)
			plr:kick(client)
			outputChatBox(plr.name.." has been kicked by "..client.name, root, 255, 140, 0)
			return
		end
		exports.UCDdx:new(client, "You have kicked "..plr.name.." for '"..reason.."'", 0, 255, 0)
		plr:kick(client, reason) -- Set char limit on client [64]
		outputChatBox(plr.name.." has been kicked by "..client.name.." ("..reason..")", root, 255, 140, 0)
	end
end
addEvent("UCDadmin.kick", true)
addEventHandler("UCDadmin.kick", root, kickPlayer_)

function freezePlayer(ele, plr_)
	if (ele and isElement(ele)) then
		if (ele.type == "player") then
			if ele.frozen then
				ele.frozen = false
				toggleAllControls(ele, true)
				exports.UCDdx:new(ele, "You have been unfrozen by "..client.name, 0, 255, 0)
				exports.UCDdx:new(client, "You have unfrozen "..ele.name, 0, 255, 0)
			else
				ele.frozen = true
				exports.UCDdx:new(ele, "You have been frozen by "..client.name, 0, 255, 0)
				exports.UCDdx:new(client, "You have frozen "..ele.name, 0, 255, 0)
				toggleAllControls(ele, false, true, false)
			end
		elseif (ele.type == "vehicle") then
			if ele.frozen then
				ele.frozen = false
				for _, plr in pairs(ele.occupants) do
					exports.UCDdx:new(plr, "The vehicle you are currently in has been unfrozen by "..client.name, 0, 255, 0)
				end
				exports.UCDdx:new(client, "You have unfrozen "..plr_.name.."'s "..ele.name, 0, 255, 0)
			else
				ele.frozen = true
				for _, plr in pairs(ele.occupants) do
					exports.UCDdx:new(plr, "The vehicle you are currently in has been frozen by "..client.name, 0, 255, 0)
				end
				exports.UCDdx:new(client, "You have frozen "..plr_.name.."'s "..ele.name, 0, 255, 0)
			end
		end
	end
end
addEvent("UCDadmin.freeze", true)
addEventHandler("UCDadmin.freeze", root, freezePlayer)

function shoutToPlayer(plr, text)
	-- Have to make this post GUI
end
addEvent("UCDadmin.shout", true)
addEventHandler("UCDadmin.shout", root, shoutToPlayer)

spectating = {}
function spectatePlayer(plr)
	if (plr == client) then return end
	if (isPlayerOwner(plr) and not isPlayerOwner(client)) then return end
	if (getPlayerAdminRank(plr) == 5 and getPlayerAdminRank(client) ~= 5) then return end
	if (spectating[client] == plr) then
		client.cameraTarget = client
		spectating[client] = nil
		exports.UCDdx:new(client, "You are no longer spectating "..plr.name, 0, 255, 0)
		return
	end
	exports.UCDdx:new(client, "You are now spectating "..plr.name, 0, 255, 0)
	spectating[client] = plr
	client.cameraTarget = plr
end
addEvent("UCDadmin.spectate", true)
addEventHandler("UCDadmin.spectate", root, spectatePlayer)

function slapPlayer(plr)
	if (plr and client and isPlayerAdmin(client)) then
		plr:kill()
		exports.UCDdx:new(client, "You have slapped "..plr.name, 0, 255, 0)
		exports.UCDdx:new(plr, "You have been slapped by "..client.name, 0, 255, 0)
	end
end
addEvent("UCDadmin.slap", true)
addEventHandler("UCDadmin.slap", root, slapPlayer)

function renamePlayer(plr, newName)
	if (plr and client and newName and isPlayerAdmin(client)) then
		exports.UCDdx:new(client, "You have changed "..plr.name.."'s name to "..newName, 0, 255, 0)
		plr:setName(tostring(newName)) -- Set max edit length on client GUI
		exports.UCDdx:new(plr, "You name has been changed to "..newName.." by "..client.name, 0, 255, 0)
	end
end
addEvent("UCDadmin.rename", true)
addEventHandler("UCDadmin.rename", root, renamePlayer)

function takeScreenshotOfPlayer(plr)
	-- This one will take a while
end
addEvent("UCDadmin.takeScreenshot", true)
addEventHandler("UCDadmin.takeScreenshot", root, takeScreenshotOfPlayer)

function setPlayerMoney_(plr, newAmount)
	
end
addEvent("UCDadmin.setMoney", true)
addEventHandler("UCDadmin.setMoney", root, setPlayerMoney_)

function setPlayerModel(plr, model)
	if (plr and client and model and isPlayerAdmin(client)) then
		local model_ = tonumber(model)
		if model_ >= 0 and model_ <= 311 then
			plr:setModel(model_)
			exports.UCDdx:new(client, "You have set the model of "..plr.name.." to "..model_, 0, 255, 0)
			exports.UCDdx:new(plr, "Your model has been set to "..model_.." by "..client.name, 0, 255, 0)
		end
	end
end
addEvent("UCDadmin.setModel", true)
addEventHandler("UCDadmin.setModel", root, setPlayerModel)

function setPlayerHealth(plr, health)
	if (plr and client and isPlayerAdmin(client)) then
		local health_ = tonumber(health)
		if health_ then
			if health_ >= 0 and health_ <= 200 then
				plr:setHealth(health_)
				exports.UCDdx:new(client, "You have set the health of "..plr.name.." to "..health_, 0, 255, 0)
				exports.UCDdx:new(plr, "Your health has been set to "..health_.." by "..client.name, 0, 255, 0)
			end
		end
	end
end
addEvent("UCDadmin.setHealth", true)
addEventHandler("UCDadmin.setHealth", root, setPlayerHealth)

function setPlayerArmour(plr, armour)
	if (plr and client and isPlayerAdmin(client)) then
		local armour_ = tonumber(armour)
		if armour_ then
			if armour_ >= 0 and armour_ <= 100 then
				plr.armor = armour_
				exports.UCDdx:new(client, "You have set the armour of "..plr.name.." to "..armour_, 0, 255, 0)
				exports.UCDdx:new(plr, "Your armour has been set to "..armour_.." by "..client.name, 0, 255, 0)
			end
		end
	end
end
addEvent("UCDadmin.setArmour", true)
addEventHandler("UCDadmin.setArmour", root, setPlayerArmour)

function setPlayerDimension(plr, dimension)
	if (plr and client and isPlayerAdmin(client)) then
		if (tonumber(dimension) == nil or (tonumber(dimension) < 0 or tonumber(dimension) > 65535)) then
			exports.UCDdx:new(client, "You must enter a valid dimension between 0 and 65535", 255, 0, 0)
			return
		end
		plr:setDimension(dimension)
		exports.UCDdx:new(client, "You have set "..plr.name.."'s dimension to "..dimension, 0, 255, 0)
		exports.UCDdx:new(plr, "Your dimension has been set to "..dimension.." by "..client.name, 0, 255, 0)
	end
end
addEvent("UCDadmin.setDimension", true)
addEventHandler("UCDadmin.setDimension", root, setPlayerDimension)

function setPlayerInterior(plr, interior)
	if (plr and client and isPlayerAdmin(client)) then
		if (tonumber(interior) == nil or (tonumber(interior) < 0 or tonumber(interior) > 255)) then
			exports.UCDdx:new(client, "You must enter a valid interior between 0 and 255", 255, 0, 0)
			return
		end
		plr:setInterior(interior)
		exports.UCDdx:new(client, "You have set "..plr.name.."'s interior to "..interior, 0, 255, 0)
		exports.UCDdx:new(plr, "Your interior has been set to "..interior.." by "..plr.name, 0, 255, 0)
	end
end
addEvent("UCDadmin.setInterior", true)
addEventHandler("UCDadmin.setInterior", root, setPlayerInterior)

function giveVehicle(plr, vehicle)
	if (plr and client and vehicle and isPlayerAdmin(client)) then
		local spawnedVehicle
		
		-- We're dealing with a vehicle ID
		if tostring(vehicle):match("%d") and tonumber(vehicle) ~= false and tonumber(vehicle) ~= nil then
			if (not Vehicle.getNameFromModel(vehicle) or Vehicle.getNameFromModel(vehicle) == "" or Vehicle.getNameFromModel(vehicle) == " ") then
				exports.UCDdx:new(client, "You must specify a valid vehicle name or ID", 255, 0, 0)
				return
			end
			-- Possibly add this vehicle to a table so he can /djv it
			spawnedVehicle = Vehicle(vehicle, plr.position, 0, 0, getPedRotation(plr), "PEN15")
			
		else -- We're dealing with a vehicle name
			if (not Vehicle.getModelFromName(vehicle)) then
				exports.UCDdx:new(client, "You must specify a valid vehicle name or ID", 255, 0, 0)
				return
			end
			spawnedVehicle = Vehicle(Vehicle.getModelFromName(vehicle), plr.position, 0, 0, getPedRotation(plr), "PEN15")
		end
		
		spawnedVehicle.dimension = plr.dimension
		spawnedVehicle.interior = plr.interior
		client:warpIntoVehicle(spawnedVehicle)
		spawnedVehicle:setData("owner", client.name)
		spawnedVehicle:setColor(math.random(0, 255), math.random(0, 255), math.random(0, 255), math.random(0, 255), math.random(0, 255), math.random(0, 255))
		
		if vowels[spawnedVehicle.name:sub(1, 1):lower()] then
			exports.UCDdx:new(plr, "You have been given an "..spawnedVehicle.name.." by "..client.name, 0, 255, 0)
			exports.UCDdx:new(client, "You have given "..plr.name.." an "..spawnedVehicle.name, 0, 255, 0)
		else
			exports.UCDdx:new(plr, "You have been given a "..spawnedVehicle.name.." by "..client.name, 0, 255, 0)
			exports.UCDdx:new(client, "You have given "..plr.name.." a "..spawnedVehicle.name, 0, 255, 0)
		end
	end
end
addEvent("UCDadmin.giveVehicle", true)
addEventHandler("UCDadmin.giveVehicle", root, giveVehicle)

function fixVehicle_(plr, vehicle)
	if (plr and client and vehicle and isPlayerAdmin(client)) then
		if (plr.vehicle ~= vehicle or vehicle.type ~= "vehicle") then
			return
		end
		if (vehicle:getData("vehicleID") and type(vehicle:getData("vehicleID")) == number) then
			if (getPlayerAdminRank(client) < 4) then
				exports.UCDdx:new(client, "You are not allowed to fix player vehicles until L4", 255, 0, 0)
				return
			end
			exports.UCDvehicles:setVehicleData(vehicle:getData("vehicleID"), "health", 1000)
		end
		triggerEvent("onVehicleFixed", vehicle)
		vehicle:fix()
		vehicle.health = 1000
		exports.UCDdx:new(client, "You have fixed "..plr.name.."'s "..vehicle.name, 0, 255, 0)
		exports.UCDdx:new(plr, client.name.." has fixed your "..vehicle.name, 0, 255, 0)
	end
end
addEvent("UCDadmin.fixVehicle", true)
addEventHandler("UCDadmin.fixVehicle", root, fixVehicle_)

function ejectPlayerFromVehicle(plr, vehicle)
	if (plr and client and vehicle and isPlayerAdmin(client)) then
		if (plr.vehicle ~= vehicle or vehicle.type ~= "vehicle") then
			return
		end
		plr:removeFromVehicle(vehicle)
		exports.UCDdx:new(client, "You have ejected "..plr.name.." from their "..vehicle.name, 0, 255, 0)
		exports.UCDdx:new(plr, "You have been ejected from your "..vehicle.name.." by "..plr.name, 0, 255, 0)
	end
end
addEvent("UCDadmin.ejectPlayer", true)
addEventHandler("UCDadmin.ejectPlayer", root, ejectPlayerFromVehicle)

function destroyVehicle(plr, vehicle)
	if (plr and client and isPlayerAdmin(client)) then
		-- The vehicle may have been a player vehicle and hence already destroyed client-side
		if vehicle then
			vehicle:destroy()
		end
		exports.UCDdx:new(plr, "Your vehicle has been destroyed by "..client.name, 0, 255, 0)
		exports.UCDdx:new(client, "You have destroyed "..client.name.."'s vehicle", 0, 255, 0)
	end
end
addEvent("UCDadmin.destroyVehicle", true)
addEventHandler("UCDadmin.destroyVehicle", root, destroyVehicle)

function disableVehicle(plr, vehicle)
	
end
addEvent("UCDadmin.disableVehicle", true)
addEventHandler("UCDadmin.disableVehicle", root, disableVehicle)

function blowVehicle_(plr, vehicle)
	
end
addEvent("UCDadmin.blowVehicle", true)
addEventHandler("UCDadmin.blowVehicle", root, blowVehicle_)
