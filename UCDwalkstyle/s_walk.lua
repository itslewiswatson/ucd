--[[
_setPedWalkingStyle = setPedWalkingStyle
function setPedWalkingStyle( player, style )
	local bool = _setPedWalkingStyle( player, style )
	if bool then
		setElementData( player, "WalkingStyle", style )
		return bool
	end
end

function getPedWalkingStyle( player )
	if player and getElementType( player ) == "player" then
		local style = getElementData( player, "WalkingStyle" )
		if style and type( style ) == "number" then
			return style
		else
			return false
		end
	else 
		return false
	end
end

function onQuit()
	local acc = getPlayerAccount( source )
	if ( isGuestAccount( acc ) ) then return end
	if ( acc ) then
		setAccountData( acc, "walking-style", tonumber( getPedWalkingStyle( source ) ) )
	end
end
addEventHandler( "onPlayerQuit", root, onQuit )

function onLogin( _, theCurrentAccount )
	local acc = getPlayerAccount( source )
	local accountData = getAccountData( theCurrentAccount, "walking-style" )
	if ( accountData  == nil ) then 
		setPedWalkingStyle( source, 0 )
		setAccountData( theCurrentAccount, "walking-style", 0 )
		return
	end
	if ( accountData ) then
		local walkstyle = getAccountData( theCurrentAccount, "walking-style" ) 
		setPedWalkingStyle( source, tonumber( walkstyle ) )
	end
end
addEventHandler( "onPlayerLogin", root, onLogin )
]]
------------------------------------------------------------------

-- ATROCIOUS CODE HOLY SHIT THIS IS BAD

local playerStyles = {}

function getPlayerWalkingStyle(plr)
	if (not plr) then return nil end
	if (plr:getType() ~= "player") then return false end
	if (not playerStyles[plr] or playerStyles[plr] == nil) then return false end
	return playerStyles[plr]
end

addEventHandler("onPlayerLogin", root, 
	function () 
		local ws = exports.UCDaccounts:GAD(source, "walkstyle")
		if ws ~= nil and ws ~= false then
			playerStyles[source] = ws
		end
	end
)

addEvent( "walkStyleBuy", true )
addEventHandler( "walkStyleBuy", root, 
	function ( id, name )
		name = tostring( name )
		id = tonumber( id )
		setPedWalkingStyle( client, id )
		exports.dx:new( client, "You have successfully purchased the '"..name.."' walkstyle (ID "..tostring( id )..").", 60, 200, 70 )
		playerStyles[client] = id
		--setElementData( client, "walkstyle", tonumber( id ), true )
	end
)
