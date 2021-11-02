serials = {
	["7784D1745F2D9DD06DD223333311BEB4"] = true, -- Noki
	["BC75E981B2E6D61589F7F88BC6968282"] = true, -- Vladimir
	["674F07092F0E31C8CE71B31AC7E69FA2"] = true, -- Luke
	["C9FB384CCFFFAE0A04A8B6094CDDAB93"] = true, -- Surface Pro 4
	["1B5DE92E5B8B6E0FB512ADC1D6E3D692"] = true, -- Franklin
	--["80C55EE8C01CB2102BCD208797A571F4"] = true, -- Ashford
	["73F46AEC1A8A786C9380A0DBF63B24E3"] = true, -- Cydia
	["149D42DF5C80AC8654CCD13AC2306384"] = true, -- fuckprino
	["1484D1C8D24BE2569CDC389134212583"] = true, -- Soap
	["E0AD3B1CA3C2A3FEC851DAADB18E1C02"] = true, -- Carl
	["68B41277286394C74AD831B2DEF48902"] = true, -- Felix
	["8D77ADDACDD9DAAF56F7850F63B5B7E2"] = true, -- Metall
	["F4053F8BB8D476A77A9A4866476EDAA1"] = true, -- Metall 2
	["7B8CA70E3161C1AD51D076A2B669F252"] = true, -- Foley
	--["70BD5F0030584BBDC179E0132FFF4093"] = true, -- Swagy
	["3B73D3F1F1CF12FA1580098CBC021D52"] = true, -- Flower Power
	["A795D5B58ABC590056748F061E102542"] = true, -- Sotiris
	["52DA46FA1AC97F1E45CF10F82ED91192"] = true, -- Thor
	["9B4E3FBD3D71FCD5267E8B11A4FC1C53"] = true, -- Zed
	["153917885526E4D3E13389F7015DEB94"] = true, -- Dustin
	["559620B7114A2FBE3233BAAC4C1E74E3"] = true, -- iAssassin
	["0E452FE9CE85B6ACF9F268F3D095A5A2"] = true, -- Aymen
	["8A227ED9C2C4A2D465975BB5D52A64A1"] = true, -- Matrix
	["67E50D4ACE87F78290EEC402CD890544"] = true, -- Valentim
	["136C9AA8BAAD17020796C7E4643C3454"] = true, -- Paschi
	["957AA36CDF402DCF62E92656167E8CF3"] = true, -- Beast
	["A7597F4CA3836678D276BD0916A43333"] = true, -- Rambo
	["27938D764ECFFED5A2B4DED372DE2E03"] = true, -- Dennis
	["2C30C68C0C0BFEB1270EAE3BAFA099F3"] = true, -- Risk
	["DE21A77C9E4C842C3AD1B7926A5ABBE4"] = true, -- Risk 2
	["2B63894067D21C0A100F90E754B73234"] = true, -- HellStunter
	["C59A119C6645EEC5260B4F4FC5415D94"] = true, -- Ruller
	["B84362665C4DEA0224923686818BC153"] = true, -- PutQ
	--["9DAED17A924092F99DE4992A206AEE42"] = true, -- Aymen 2
}

-- open for business as of the 30th July 2016 (29th for most other people)
--[[
addEventHandler("onPlayerConnect", root,
	function (_, _, _, s)
		if (not serials[s]) then
			cancelEvent(true, "Email noki@zorque.xyz to gain access")
		end
	end
)
--]]

local adminRanks = {
	[1] = "L1 Admin",
	[2] = "L2 Admin",
	[3] = "L3 Admin",
	[4] = "L4 Admin",
	[5] = "L5 Admin",
}

addEventHandler("onResourceStart", resourceRoot,
	function ()
		if (not getTeamFromName("Admins")) then
			outputDebugString("'Admins' team not found, creating...")
			Team("Admins", 195, 195, 195)
		end
	end
)

function gg(client)
	if (isPlayerAdmin(client)) then
		if (client:getWantedLevel() > 0) then
			exports.UCDlogging:adminLog(client, client.name.." did /admin with "..tostring(client:getWantedLevel()).." stars")
		end

		client:setData("Occupation", adminRanks[getPlayerAdminRank(client)])
		
		exports.UCDwanted:setWantedPoints(client, 0)
		exports.UCDjobs:setPlayerJob(client, "Admin", 217)
		client:setNametagColor(false)
		exports.UCDdx:new(client, "You are now an on-duty administrator", 255, 255, 255)
	end
end
addCommandHandler("admin", gg, false, false)

--[[
addEventHandler("onPlayerChangeNick", root,
	function (old, new)
		if (new:lower():find("[ucd]") and not isPlayerAdmin(source)) then
			outputDebugString(source.name.." using [ucd], cancelling")
			cancelEvent()
		end
	end
)
]]--
