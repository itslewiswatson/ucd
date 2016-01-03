-- This will create the teams in order (unless the scoreboard shits itself)
local teams = {
	[1] = {"Admins", 195, 195, 195},
	[2] = {"Citizens", 255, 255, 0},
	[3] = {"Law Enforcement", 30, 144, 255}, --0-191-255
	[4] = {"Criminals", 200, 5, 5},
	[5] = {"Gangsters", 112, 13, 200},
	[6] = {"Unemployed", 220, 70, 240},
	[7] = {"Not logged in", 255, 255, 255},
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
	source.team = Team.getFromName("Not logged in")
end
addEventHandler("onPlayerJoin", root, setDefaultTeam)

function onPlayerTeamChange(oldTeam, newTeam)
	-- source is the player whose team changed
	-- oldTeam and newTeam should contain team elements
	-- use Team.getFromName to get the team names
end
addEvent("onPlayerTeamChange", true)
addEventHandler("onPlayerTeamChange", root, onPlayerTeamChange)

_setPlayerTeam = setPlayerTeam
function setPlayerTeam(plr, team)
	if (not plr or not team) then return end
	if ((team.type ~= "userdata" and type(team) ~= "string") or not isElement(plr) or plr.type ~= "player") then return false end
	
	local oldTeam
	local newTeam
	
	oldTeam = plr.team
	if (type(team) == "string") then
		if (not Team.getFromName(team)) then
			return false
		end
		plr.team = Team.getFromName(team)
		newTeam = Team.getFromName(team)
	elseif (team.type == "team") then
		plr.team = team
		newTeam = team
	end
	-- Trigger onPlayerTeamChange event
	triggerEvent("onPlayerTeamChange", plr, oldTeam, newTeam)
	return true
end

function isPlayerInTeam(plr, team)
	if (not plr or not team) then return end
	if (not isElement(plr) or plr.type ~= "player") then return false end
	
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
