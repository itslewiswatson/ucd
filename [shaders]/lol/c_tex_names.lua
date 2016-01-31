addEventHandler("onClientResourceStart", resourceRoot,
	function ()		
		local wires = dxCreateShader("tex_names.fx", 0, 0, false)
		engineApplyShaderToWorldTexture(wires, "telewires_law")
		engineApplyShaderToWorldTexture(wires, "telewireslong")
		engineApplyShaderToWorldTexture(wires, "telewireslong2")
		engineApplyShaderToWorldTexture(wires, "antenna1")
		dxSetShaderValue(wires, "gColor", 255, 0, 0, 0)
		
		local markers = dxCreateShader("overlay.fx")
		dxSetShaderValue(markers, "gTexture", dxCreateTexture("marker.png"))
		engineApplyShaderToWorldTexture(markers, "CJ_W_GRAD")
	end
)

addCommandHandler("cp", 
	function () 
		if (colorPicker.GUI.selectWindow.visible) then
			colorPicker.closeSelect()
		else
			colorPicker.openSelect()
		end
	end
)

function updateColor()
	if (not colorPicker.isSelectOpen) then return end
	local r, g, b = colorPicker.updateTempColors()
	if (localPlayer.vehicle and isElement(localPlayer.vehicle)) then
		local r1, g1, b1, r2, g2, b2 = getVehicleColor(localPlayer.vehicle, true)
		if (guiCheckBoxGetSelected(checkColor1)) then
			r1, g1, b1 = r, g, b
		end
		if (guiCheckBoxGetSelected(checkColor2)) then
			r2, g2, b2 = r, g, b
		end
		--if (guiCheckBoxGetSelected(checkColor3)) then
		--	setVehicleHeadLightColor(localPlayer.vehicle, r, g, b)
		--end
		setVehicleColor(localPlayer.vehicle, r1, g1, b1, r2, g2, b2)
		tempColors = {r1, g1, b1, r2, g2, b2}
	end
end
addEventHandler("onClientRender", root, updateColor)

-----

addEventHandler( "onClientResourceStart", resourceRoot,
    function()
 
        -- Create shader
        
    end
)
 
