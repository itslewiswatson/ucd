-- Numbers are for GUI buttons
-- If a number is not there, it means it is false
-- Permissions are inherited from the rank below
-- 
local permissions = {
	[1] = {
		[1] = true, -- warp to player
		[2] = true, -- punish
		[3] = true, -- spectate
		[4] = true, -- warp player to
		[5] = true, -- reconnect
		[6] = true, -- kick
		[7] = true, -- freeze
		[9] = true, -- slap
		[10] = true, -- rename
		[11] = true, -- view punishments
		[12] = true, -- screenshot
		[17] = true, -- dimension
		[18] = true, -- interior
		[19] = true, -- fix vehicle
		[21] = true, -- destroy vehicle
		[25] = true, -- view weapons
		[29] = true, -- freeze vehicle
		["mute"] = true,
		["admin jail"] = true,
		["jetpack"] = true,
		["unmute"] = true,
		["unjail"] = true,
	},
	[2] = {
		[8] = true, -- shout
		[13] = true, -- set model
		[15] = true, -- set health
		[16] = true, -- set armour
		[20] = true, -- eject
		[22] = true, -- disable vehicle
		[23] = true, -- set job
	},
	[3] = {
		["manage punish"] = true,
		["ban"] = true,
		[27] = true, -- give vehicle
		[30] = true, -- last logins
	},
	[4] = {
		[26] = true, -- give weapon
	},
	[5] = {
		[14] = true, -- set money
	},
	[1337] = {
		
	},
}

function canAdminDoAction(plr, action)
	if (not isPlayerAdmin(plr) or not getPlayerAdminRank(plr)) then return end
	return getRankPerms(getPlayerAdminRank(plr))[action] or false
end

function getRankPerms(rank)
	if (not rank) then return end
	local temp = {}
	for ind, ent in pairs(permissions) do
		if (ind <= rank) then
			for k, v in pairs(ent) do
				temp[k] = v
			end
		end
	end
	if (rank == 1337) then
		temp[-1] = true
	end
	return temp
end

function sendPermissions(plr)
	if (not isPlayerAdmin(plr)) then return end
	local rank = getPlayerAdminRank(plr)
	triggerClientEvent(plr, "UCDadmin.onReceivedPermissions", plr, getRankPerms(rank))
end

addEvent("UCDadmin.getPermissions", true)
addEventHandler("UCDadmin.getPermissions", root,
	function ()
		sendPermissions(client)
	end
)

addEventHandler("onPlayerLogin", root,
	function ()
		--if (source.account.name ~= "guest" and adminTable[source.account.name]) then
		if (isPlayerAdmin(source)) then
			sendPermissions(source)
		end
	end
)
