vowels = {["a"] = true, ["e"] = true, ["i"] = true, ["o"] = true, ["u"] = true}

function warpToPlayer(plr)
	
end
addEvent("UCDadmin.warpToPlayer", true)
addEventHandler("UCDadmin.warpToPlayer", root, warpToPlayer)

function warpPlayerTo(plr, warpTo)
	
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

function spectatePlayer(plr)
	if (isPlayerOwner(plr) and not isPlayerOwner(client)) then return false end
	if (getPlayerAdminRank(plr) == 5 and getPlayerAdminRank(client) ~= 5) then return false end
	
end
addEvent("UCDadmin.spectate", true)
addEventHandler("UCDadmin.spectate", root, spectatePlayer)

function slapPlayer(plr, hp)
	if (plr and client and hp and isPlayerAdmin(client)) then
		plr:kill()
		exports.UCDdx:new(client, "You have slapped "..plr.name.." for "..hp.." HP", 0, 255, 0)
		exports.UCDdx:new(plr, "You have been slapped by "..client.name.." for "..hp.." HP", 0, 255, 0)
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
		plr:setDimension(dimension)
		exports.UCDdx:new(client, "You have set "..plr.name.."'s dimension to "..dimension, 0, 255, 0)
		exports.UCDdx:new(client, "Your dimension has been set to "..dimension.." by "..plr.name, 0, 255, 0)
	end
end
addEvent("UCDadmin.setDimension", true)
addEventHandler("UCDadmin.setDimension", root, setPlayerDimension)

function setPlayerInterior(plr, interior)
	if (plr and client and isPlayerAdmin(client)) then
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
			
			-- Possibly add this vehicle to a table so he can /djv it
			spawnedVehicle = Vehicle(vehicle, plr.position, 0, 0, getPedRotation(plr), "PEN15")
			warpPedIntoVehicle(plr, spawnedVehicle)
			
		else -- We're dealing with a vehicle name
			spawnedVehicle = Vehicle(Vehicle.getModelFromName(vehicle), plr.position, 0, 0, getPedRotation(plr), "PEN15")
			warpPedIntoVehicle(plr, spawnedVehicle)
		end
		
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
	
end
addEvent("UCDadmin.fixVehicle", true)
addEventHandler("UCDadmin.fixVehicle", root, fixVehicle_)

function ejectPlayerFromVehicle(plr)
	
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
