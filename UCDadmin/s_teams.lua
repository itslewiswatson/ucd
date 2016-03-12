serials = {
	["7784D1745F2D9DD06DD223333311BEB4"] = true, -- me
	["BC75E981B2E6D61589F7F88BC6968282"] = true, -- vlad
	["674F07092F0E31C8CE71B31AC7E69FA2"] = true, -- luke
	["C9FB384CCFFFAE0A04A8B6094CDDAB93"] = true, -- sp4
	["1B5DE92E5B8B6E0FB512ADC1D6E3D692"] = true, -- franklin
	--["80C55EE8C01CB2102BCD208797A571F4"] = true, -- ashford
	["73F46AEC1A8A786C9380A0DBF63B24E3"] = true,
	["149D42DF5C80AC8654CCD13AC2306384"] = true, -- fuckprino
	["1484D1C8D24BE2569CDC389134212583"] = true, -- soap
	["E0AD3B1CA3C2A3FEC851DAADB18E1C02"] = true, -- carl
	["68B41277286394C74AD831B2DEF48902"] = true, -- felix
	["8D77ADDACDD9DAAF56F7850F63B5B7E2"] = true, -- metall
}

addEventHandler("onPlayerConnect", root,
	function (_, _, _, s)
		if (not serials[s]) then
			cancelEvent(true, "You ain't allowed here my nigga")
		end
	end
)

local adminRanks = {
	[1] = "L1 Admin",
	[2] = "L2 Admin",
	[3] = "L3 Admin",
	[4] = "L4 Admin",
	[5] = "L5 Admin",
	[1337] = "L1337 Admin",
}

if (not getTeamFromName("Admins")) then
	outputDebugString("'Admins' team not found, creating...")
	Team("Admins", 195, 195, 195)
end

function gg(client)
	if (isPlayerAdmin(client)) then
		-- Only here for debug purposes - will be removed upon release
		if (client:getWantedLevel() > 0 and not isPlayerOwner(client)) then exports.dx:new(client, "You cannot go on-duty whilst being wanted", 255, 255, 255) return false end

		--if (isPlayerOwner(client)) then
		--	client:setData("Occupation", "L1337 Admin")
		--else
			client:setData("Occupation", adminRanks[getPlayerAdminRank(client)])
		--end
		
		exports.UCDjobs:setPlayerJob(client, "Admin", 217)
		client:setNametagColor(false)
		exports.UCDdx:new(client, "You are now an on-duty administrator", 255, 255, 255)
	end
	return false
end
addCommandHandler("admin", gg)
