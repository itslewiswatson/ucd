local counter = 0
local starttick
local currenttick
local player = getLocalPlayer()

addEventHandler( "onClientRender", root,
	function ()
		if not starttick then
			starttick = getTickCount()
		end
		counter = counter + 1
		currenttick = getTickCount()
		if currenttick - starttick >= 1000 then
			counter = counter - 1 -- So it ACTUALLY displays the correct FPS, and not 1 more frame than it actually is.
			setElementData( player, "FPS" , counter, true )
			counter = 0
			starttick = false
		end
	end
)
