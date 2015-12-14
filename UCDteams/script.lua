-- This will create the teams in order (unless the scoreboard shits itself)
local teams = {
	[1] = {"Admins", 195, 195, 195},
	[2] = {"Aviators", 255, 255, 0},
	[3] = {"Law Enforcement", 30, 144, 255}, --0-191-255
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
	source:setTeam(Team.getFromName("Not logged in"))
end
addEventHandler("onPlayerJoin", root, setDefaultTeam)

function isPlayerInTeam(plr, team)
	if (not plr or not team) then return nil end
	if (plr.type ~= "player") then return false end
	
	if (type(team) == "string") then
		if plr.team == Team.getFromName(team) then
			return true
		end
	elseif (team.type == "team") then
		if plr.team == team then
			return true
		end
	end
	
	return false
end

function getTeams()
	return teams
end
