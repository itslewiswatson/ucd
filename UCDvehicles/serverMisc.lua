-------------------------------------------------------------------
--// PROJECT: Union of Clarity and Diversity
--// RESOURCE: UCDvehicles
--// DEVELOPER(S): Lewis Watson (Noki)
--// DATE: 09/12/2015
--// PURPOSE: Storing miscellaneous server-side functions.
--// FILE: \server2.lua [server]
-------------------------------------------------------------------

-- We need the owner's name to be synced
function onPlayerChangeNick(old, new)
	if (exports.UCDaccounts:isPlayerLoggedIn(source)) then
		for _, vehicle in pairs(Element.getAllByType("vehicle")) do
			if (old == vehicle:getData("owner")) then
				vehicle:setData("owner", new)
			end
		end
	end
end
addEventHandler("onPlayerChangeNick", root, onPlayerChangeNick)

-- UNTESTED
-- This could also conflict with a law system of sorts
function onVehicleStartEnter(plr, seat, jacked, door)
	if (not source:getData("owner")) then return end
	if (seat == 0 and door == 0 and jacked) then
		local driver = source:getOccupant(0)
		if (exports.UCDaccounts:getPlayerAccountName(driver) == source:getData("owner")) then
			cancelEvent()
		end
	end
	-- source is vehicle
end
addEventHandler("onVehicleStartEnter", root, onVehicleStartEnter)

