--
-- c_hud_mask.lua
--

----------------------------------------------------------------
-- onClientResourceStart
----------------------------------------------------------------
addEventHandler( "onClientResourceStart", resourceRoot,
	function()
		-- Create things
        hudMaskShader = dxCreateShader("hud_mask.fx")
		radarTexture = dxCreateTexture("images/radar.jpg")
		maskTexture1 = dxCreateTexture("images/square_mask.png")
		--maskTexture2 = dxCreateTexture("images/sept_mask.png")

		-- Check everything is ok
		bAllValid = hudMaskShader and radarTexture and maskTexture1-- and maskTexture2

		if not bAllValid then
			outputChatBox("Could not create some things. Please use debugscript 3")
		else
			dxSetShaderValue(hudMaskShader, "sPicTexture", radarTexture)
			dxSetShaderValue(hudMaskShader, "sMaskTexture", maskTexture1)
		end
	end
)

-----------------------------------------------------------------------------------
-- onClientRender
-----------------------------------------------------------------------------------
addEventHandler( "onClientRender", root,
    function()
		if not bAllValid then return end

		dxSetShaderValue(hudMaskShader, "sMaskTexture", maskTexture1)

		--
		-- Transform world x, y into -0.5 to 0.5
		--
		local x, y = getElementPosition(localPlayer)
		x = ( x ) / 6000
		y = ( y ) / -6000
		dxSetShaderValue(hudMaskShader, "gUVPosition", x, y)

		--
		-- Zoom
		--
		local zoom = 14
		dxSetShaderValue(hudMaskShader, "gUVScale", 1 / zoom, 1 / zoom)

		--
		-- Rotate to camera direction - OPTIONAL
		--
		local _, _, camrot = getElementRotation(getCamera())
		dxSetShaderValue(hudMaskShader, "gUVRotAngle", math.rad(-camrot))

		--
		-- Draw
		--
		local startX, startY = 100, 500
		local pr = getPedRotation(localPlayer)
		dxDrawImage(startX, startY, 250, 250, hudMaskShader, 0, 0, 0, tocolor(255, 255, 255, 210))
		dxDrawRectangle((startX + 125) + math.rad(x * camrot), (startY + 125) + math.rad(y * camrot), 10, 10, tocolor(0, 0, 0, 255))
		--dxDrawImage((startX + 125) + math.rad(x * camrot), startY + 125, 24, 24, "images/radar_centre.png")
		--dxDrawImage((startX + 125 - 6) + math.rad(x * -camrot), (startY + 125 - 6) + math.rad(y), 24, 24, "images/radar_centre.png", camrot - pr)
    end
)
