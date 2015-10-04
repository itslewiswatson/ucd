addCommandHandler( "Reload weapon",
	function ()
		local task = getPedSimplestTask( localPlayer )
		
		-- Remove the ability to reload with a full clip in some weapons to avoid network abuse (purposely desyncing etc).
		local ammo = getPedAmmoInClip( localPlayer )
		local wep = getPedWeapon( localPlayer )
		if ( ( wep == 23 and ammo == 17 ) or ( wep == 24 and ammo == 7 ) or ( wep == 27 and ammo == 7 ) or ( wep == 29 and ammo == 30 )
		or ( wep == 30 and ammo == 50 ) or ( wep == 31 and ammo == 50 ) ) then 
			return
		end
		
		-- Prevent instant reload while performing a jump
		if ( ( task == "TASK_SIMPLE_JUMP" or task == "TASK_SIMPLE_IN_AIR" or task == "TASK_SIMPLE_LAND" ) and not doesPedHaveJetPack( localPlayer ) ) then return end
		
		-- If you reload and press shift at the exact same time you're able to instant reload so temporarily disable jump
		if ( isControlEnabled( "jump" ) ) then
			toggleControl( "jump", false )
			addEventHandler( "onClientRender", root, enableJump )
		end
		
		triggerServerEvent( "onPlayerReload", localPlayer )
	end
)

bindKey( "r", "down", "Reload weapon" )

-- Disable jumping for at least 4 frames after pressing reload to prevent instant reload
local frames = 0

function enableJump()
	if ( frames >= 3 ) then
		toggleControl( "jump", true )
		removeEventHandler( "onClientRender", root, enableJump )
		frames = 0
	else
		frames = frames + 1
	end
end