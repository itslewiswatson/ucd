function getPlayerFromPartialName(name)
    local name = name and name:gsub("#%x%x%x%x%x%x", ""):lower() or nil
    if name then
        for _, player in ipairs(getElementsByType("player")) do
            local name_ = getPlayerName(player):gsub("#%x%x%x%x%x%x", ""):lower()
            if name_:find(name, 1, true) then
                return player
            end
        end
    end
end

function takePlayerScreenshot( client, cmd, target )
	if ( not target ) then exports.dendxmsg:createNewDxMessage( client, "You must specify a player", 255, 0, 0 ) return end
	local target = getPlayerFromPartialName( target )
	local plrName = getPlayerName( target )
	if ( plrName ) then
		theScreenshot = takePlayerScreenShot( target, 1024, 768, "gg", 100, 9999999999999999 )
		if theScreenshot then
			exports.UCDdx:new( client, "Taken screenshot of '"..plrName.."'. Downloading now", 255, 255, 255 )
		else
			exports.UCDdx:new( client, "Couldn't take screenshot. Unknown reason", 255, 255, 255 )
		end
	else
		exports.dendxmsg:createNewDxMessage( client, "There is no player named "..plrName, 255, 0, 0 )
		return
	end
end
addCommandHandler( "takess", takePlayerScreenshot )

addEventHandler( "onPlayerScreenShot", root,
	function ( _, _, pixels )
		triggerClientEvent( source, "ss", resourceRoot, pixels )
	end
)
