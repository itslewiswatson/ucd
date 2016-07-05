-------------------------------------------------------------------
--// PROJECT: Union of Clarity and Diversity
--// RESOURCE: UCDcore
--// DEVELOPER(S): Lewis Watson (Noki)
--// DATE: 17.05.2014
--// PURPOSE: A core resource. 
--// FILE: \UCDcore\core.lua [server]
-------------------------------------------------------------------

db = exports.UCDsql:getConnection()

-- This is so we don't get weird symbols in the db
-- This snippet doesn't like to work in UCDsql for some reason.
local charset = db:exec("SET NAMES `utf8mb4`")
if (not charset) then
	outputDebugString("["..getThisResource():getName().."] Failed to encode database with utf8m4")
else
	outputDebugString("["..getThisResource():getName().."] Successfully encoded database with utf8m4")
end


function getGameVersion()
	local qh = db:query("SELECT `version` FROM `core`")
	local ver = qh:poll(-1)
	return tostring(ver[1].version)
end

setGameType("UCD "..getGameVersion())
setMinuteDuration(10000)
setFPSLimit(60)
setServerPassword("")
for i = 0, 49 do setGarageOpen(i, true) end

-----------------------------------------------------
-- ARR (automatic resource restarter)
-- This is used to make sure certain resources remain in a healthy state
-----------------------------------------------------

local ARR = { 
	"UCDreload",
	"UCDdata",
	"UCDplaytime",
}
--[[
function autoRestart()
	for i, resource in pairs(ARR) do
		local restart = restartResource(getResourceFromName(resource))
		if (restart == true) then
			outputDebugString("[ARR] Resource '"..resource.."' automatically restarted")
		else
			outputDebugString("[ARR] Cannot restart resource: "..resource.." - contact developer")
			break
		end
	end
end

function autoRestartTimer()
	restartTimer = setTimer(autoRestart, 2400000, 0) -- restart on every hour of server uptime
end
addEventHandler("onResourceStart", resourceRoot, autoRestartTimer)
--]]

-----------------------------------------------------
-- Kill command
-----------------------------------------------------

addCommandHandler( "kill",
	function ( client )
		if ( getElementType( client ) ~= "player" ) then return end
		if ( getTeamName( getPlayerTeam( client ) ) == "Not logged in" ) then return end
		if ( not getPlayerAccount( client ) ) then return end
		if ( isPedInVehicle( client ) ) then exports.UCDdx:new( client, "You cannot kill yourself whilst in a vehicle", 255, 0, 0 ) return end
		if ( isPedOnGround( client ) ~= true ) then exports.UCDdx:new( client, "You must be on the ground in order to kill yourself", 255, 0, 0 ) return end
		if ( getPlayerWantedLevel( client ) ~= 0 ) then exports.UCDdx:new( client, "You cannot kill yourself whilst wanted", 255, 0, 0 ) return end
		if ( getTeamName( getPlayerTeam( client ) ) == "Admins" )	then
			exports.UCDdx:new( client, "Instant administrator death", 255, 255, 255 )
			killPed( client )
			return
		end
		
		exports.UCDdx:new( client, "You will be killed in 10 seconds", 255, 0, 0 )
		toggleAllControls( client, false, true, false )
		setElementFrozen( client, true )
		setTimer(
			function ()
				killPed( client )
				toggleAllControls( client, true )
			end, 10000, 1
		)
		
	end
)
