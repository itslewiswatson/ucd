local moderatorRanks = {
	[1] = "Trial Moderator",
	[2] = "Moderator",
	[3] = "Super Moderator",
	[4] = "Lead Moderator",
}

local developerRanks = {
	[1] = "Trial Developer",
	[2] = "Developer",
	[3] = "Super Developer",
	[4] = "Lead Developer",
}

if (not getTeamFromName("Admins")) then
	outputDebugString("'Admins; team not found, creating...")
	Team("Admins", 195, 195, 195 )
end

function gg(client)
	if (hasObjectPermissionTo(client, "command.refresh")) then
		if (client:getWantedLevel() > 0) then exports.dx:new(client, "You cannot go on-duty whilst being wanted", 255, 255, 255) return false end
		-- Note: 
		-- If an owner can script, he/she will also be a lead developer in the database
		-- If an owner cannot script, he/she will be a lead moderator in the database
		if (isPlayerOwner(client)) then
			client:setData("Class", "Owner")
		else
			if (getDeveloperRank(client) ~= 0 ) then
				client:setData("Class", developerRanks[getDeveloperRank(client)], true)
			elseif (getModeratorRank(client) ~= 0) then
				client:setData("Class", moderatorRanks[getModeratorRank(client)], true)
			end
		end
		
		client:setTeam(Team.getFromName("Admins"))
		client:setModel(217)
		client:setNametagColor(false)
		client:setHealth(200)
		client:setData("Occupation", "Administrator" )
		exports.UCDdx:new(client, "You are now an on-duty administrator", 255, 255, 255)
	else
		return false
	end
end
addCommandHandler( "admin", gg )
