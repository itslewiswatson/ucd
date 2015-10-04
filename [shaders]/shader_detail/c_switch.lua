--
-- c_switch.lua
--

----------------------------------------------------------------
----------------------------------------------------------------
-- Effect switching on and off
--
--	To switch on:
--			triggerEvent( "onClientSwitchDetail", root, true )
--
--	To switch off:
--			triggerEvent( "onClientSwitchDetail", root, false )
--
----------------------------------------------------------------
----------------------------------------------------------------

--------------------------------
-- onClientResourceStart
--		Auto switch on at start
--------------------------------
addEventHandler( "onClientResourceStart", resourceRoot,
	function()
		triggerEvent( "onClientSwitchDetail", resourceRoot, true )
	end
)

--------------------------------
-- Command handler
--		Toggle via command
--------------------------------
addCommandHandler( "detail",
	function()
		triggerEvent( "onClientSwitchDetail", resourceRoot, not bEffectEnabled )
	end
)


--------------------------------
-- Switch effect on or off
--------------------------------
function handleOnClientSwitchDetail( bOn )
	--outputDebugString( "switchDetail: " .. tostring(bOn) )
	if bOn then
		enableDetail()
	else
		disableDetail()
	end
end

addEvent( "onClientSwitchDetail", true )
addEventHandler( "onClientSwitchDetail", resourceRoot, handleOnClientSwitchDetail )
