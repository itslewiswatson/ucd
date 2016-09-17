function fixAdminVeh(plr)
	if (not plr.vehicle or not isPlayerAdmin(plr) or plr.team.name ~= "Admins") then return end
	if (math.floor(plr.vehicle.health / 10) ~= 100) then
		exports.UCDvehicles:fix(plr.vehicle)
		exports.UCDdx:new(plr, "Your "..plr.vehicle.name.." has been fixed", 255, 255, 0)
	else
		exports.UCDdx:new(plr, "Your "..plr.vehicle.name.." does not need to be fixed", 255, 255, 0)
	end
end
addCommandHandler("fix", fixAdminVeh)

function toggleJetpack(plr)
	if (Resource.getFromName("freeroam").state == "running") then return end
	if (isPlayerAdmin(plr) and plr.team.name == "Admins") then
		if (doesPedHaveJetPack(plr)) then
			removePedJetPack(plr)
		else
			givePedJetPack(plr)
		end
	end
end
addCommandHandler("jetpack", toggleJetpack)

function flipVehicle(plr)
	if (plr.team.name ~= "Admins" or not isPlayerAdmin(plr)) then return end
	if (plr.vehicle) then
		local rX, rY, rZ = getElementRotation(plr.vehicle)
		plr.vehicle:setRotation(0, 0, (rX > 90 and rX < 270) and (rZ + 180) or rZ)
	end
end
addCommandHandler("flip", flipVehicle)

function damageProof(plr)
	if (isPlayerAdmin(plr) and plr.team.name == "Admins") then
		if (plr.vehicle) then
			plr.vehicle.damageProof = not plr.vehicle.damageProof
			exports.UCDdx:new(plr, "Your "..tostring(plr.vehicle.name).." is "..tostring((plr.vehicle.damageProof and "now") or "no longer").." damage proof", 0, 255, 0)
		end
	end
end
addCommandHandler("dmgproof", damageProof)

function invisMe(plr)
	if (isPlayerAdmin(plr) and plr.team.name == "Admins") then
		local alpha = plr:getAlpha() == 0 and 255 or 0
		if (alpha == 255) then
			exports.UCDblips:unhidePlayerBlip(plr)
		else
			exports.UCDblips:hidePlayerBlip(plr)
		end
		plr:setAlpha(alpha)
		plr:setNametagShowing(alpha == 255 and true or false)
	end
end
addCommandHandler("invis", invisMe)