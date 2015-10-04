--
-- s_skidmarks.lua
--

g_Settings = {}

-----------------------------------------------------------------------------
-- onClientReady
-----------------------------------------------------------------------------
addEvent( "onClientReady", true )
addEventHandler( "onClientReady", resourceRoot,
	function()
		-- Send initial settings to player
		sendSettings( client )
	end
)


-----------------------------------------------------------------------------
-- Command
-----------------------------------------------------------------------------
addCommandHandler( "skidmarks",
	function ( player, command, arg1, arg2 )
		if isPlayerInACLGroup(player, g_Settings.admingroup ) then
			if selectPreset(arg1) then
				outputChatBox( "Setting changed to " .. tostring(arg1), player )
			else
				outputChatBox( "Incorrect input for command", player )
			end
		else
			outputChatBox( "You are not in the correct ACL group", player )
		end
	end
)


-----------------------------------------------------------------------------
-- Change preset
-----------------------------------------------------------------------------
function selectPreset( id )
	local id = tonumber(id)
	if id and id >= 1 and id <= 4 then
		set('presetID',id)
		-- Send updated settings to all players
		cacheSettings ()
		sendSettings ()
		return true
	end
	return false
end


---------------------------------------------------------------------------
--
-- Settings
--
---------------------------------------------------------------------------
function cacheSettings()
	g_Settings = {}
	g_Settings.presetID		= getNumber('presetID',1)
	g_Settings.admingroup	= getString('admingroup','Admin')
end

-- Initial cache
addEventHandler('onResourceStart', resourceRoot,
	function()
		cacheSettings()
		resourceStartTime = getTickCount()
	end
)

-- Send initial settings to player
addEvent( "onClientReady", true )
addEventHandler( "onClientReady", resourceRoot,
	function()
		sendSettings( client )
		-- Turn shader on at client now
		local verbose = getTickCount() - resourceStartTime < 5000
		triggerClientEvent ( client, "onClientStartShader", resourceRoot, verbose )
	end
)


-- React to admin panel changes
addEventHandler('onSettingChange', resourceRoot,
	function(name, oldvalue, value)
		cacheSettings()
		sendSettings()
	end
)

-- Send settings to one client or all of them
function sendSettings( target )
	triggerClientEvent ( target or root, "onClientUpdateSettings", resourceRoot, g_Settings )
end

