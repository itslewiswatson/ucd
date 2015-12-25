local antiSpam = {}
local range = 100

function doChat( plr, _, ... )
	local player = plr
	if ( antiSpam[ player ] ) then 
		exports.UCDdx:new( player, "Your last sent message was less than one second ago!", 255, 0, 0 )
		return false
	end
	local msg = table.concat( { ... }, " " )
	if msg == "" or msg == " " then return end
	if ( not exports.UCDaccounts:isPlayerLoggedIn( plr ) ) then return false end
	local pX, pY, pZ = getElementPosition( plr )
	local plrNick = getPlayerName( plr )
	for _, v in pairs( getElementsByType( "player" ) ) do
		if ( exports.UCDutil:isPlayerInRangeOfPoint( v, pX, pY, pZ, range ) ) then
			if ( getElementDimension( plr ) == ( getElementDimension( v ) ) ) then
				if ( getElementInterior( plr ) == ( getElementInterior( v ) ) ) then
					outputChatBox( "* "..msg.." ("..plrNick..")", v, 200, 50, 150 )
				end
			end
		end
	end
end
addCommandHandler( "do", doChat )

-- /me is handled in server.lua