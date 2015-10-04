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

addEvent( "walkStyleBuy", true )
addEventHandler( "walkStyleBuy", root, 
	function ( id, name )
		name = tostring( name )
		id = tonumber( id )
		setPedWalkingStyle( client, id )
		exports.dx:new( client, "You have successfully purchased the '"..name.."' walkstyle (ID "..tostring( id )..").", 60, 200, 70 )
		setElementData( client, "walkstyle", tonumber( id ), true )
	end
)
