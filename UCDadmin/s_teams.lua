serials = {
	["7784D1745F2D9DD06DD223333311BEB4"] = true, -- me
	["BC75E981B2E6D61589F7F88BC6968282"] = true, -- vlad
	["674F07092F0E31C8CE71B31AC7E69FA2"] = true, -- luke
	["C9FB384CCFFFAE0A04A8B6094CDDAB93"] = true, -- sp4
	["1B5DE92E5B8B6E0FB512ADC1D6E3D692"] = true, -- franklin
	--["80C55EE8C01CB2102BCD208797A571F4"] = true, -- ashford
	["73F46AEC1A8A786C9380A0DBF63B24E3"] = true,
}

addEventHandler("onPlayerConnect", root,
	function (_, _, _, s)
		if (not serials[s]) then
			cancelEvent(true, "You ain't allowed here my nigga")
		end
	end
)

local adminRanks = {
	[1] = "Trial Administrator",
	[2] = "Administrator",
	[3] = "Senior Administrator",
	[4] = "Super Administrator",
	[5] = "Lead Administrator",
}

if (not getTeamFromName("Admins")) then
	outputDebugString("'Admins' team not found, creating...")
	Team("Admins", 195, 195, 195)
end

function gg(client)
	if (isPlayerAdmin(client)) then
		-- Only here for debug purposes - will be removed upon release
		if (client:getWantedLevel() > 0 and not isPlayerOwner(client)) then exports.dx:new(client, "You cannot go on-duty whilst being wanted", 255, 255, 255) return false end

		if (isPlayerOwner(client)) then
			client:setData("Class", "Owner")
		else
			client:setData("Class", adminRanks[getPlayerAdminRank(client)])
		end
		
		--client:setTeam(Team.getFromName("Admins"))
		exports.UCDteams:setPlayerTeam(client, "Admins")
		client:setModel(217)
		if (exports.UCDaccounts:GAD(client, "jobModel") ~= 217) then
			exports.UCDaccounts:SAD(client, "jobModel", 217)
		end
		client:setNametagColor(false)
		client:setData("Occupation", "Administrator" )
		exports.UCDdx:new(client, "You are now an on-duty administrator", 255, 255, 255)
		--exports.UCDjobs:setPlayerJob()
	end
	return false
end
addCommandHandler("admin", gg)
