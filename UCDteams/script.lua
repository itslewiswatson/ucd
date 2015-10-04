-- This will create the teams in order (unless the scoreboard shits itself)
local teams = {
	[1] = {"Admins", 195, 195, 195},
	[2] = {"Aviators", 255, 255, 0},
	[3] = {"Law Enforcement", 0, 0, 0},
	[4] = {"Criminals", 200, 5, 5},
	[5] = {"Unemployed", 220, 70, 240},
	[6] = {"Not logged in", 255, 255, 255},
}

function createTeams()
	for i, v in ipairs(teams) do
		Team(v[1], v[2], v[3], v[4])
	end
end
addEventHandler("onResourceStart", resourceRoot, createTeams)

--[[local teams = {
	["Admins"] 			= {195, 195, 195},
	["Aviators"] 		= {255, 255, 0},
	["Law Enforcement"] = {0, 0, 0},
	["Criminals"] 		= {200, 5, 5},
	["Unemployed"] 		= {220, 70, 240},
	["Not logged in"] 	= {255, 255, 255},
}

function createTeams()
	for i, v in pairs(teams) do
		createTeam(i, v[1], v[2], v[3])
	end
end
addEventHandler("onResourceStart", resourceRoot, createTeams)]]

--------

function setDefaultTeam()
	setPlayerTeam(source, getTeamFromName("Not logged in"))
end
addEventHandler("onPlayerJoin", root, setDefaultTeam)

function isPlayerInTeam(plr, team)
	if (not plr) then return nil end
	if (getElementType(plr) ~= "player") then return false end
	
	if (not team) then return nil end
	local team = getTeamFromName(team)
	if (not getTeamName(team)) then
		return false
	end
	if (getPlayerTeam(plr) ~= team) then
		return false
	end
	
	return true
end

function getTeamTable()
	return teams
end
