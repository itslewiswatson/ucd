addEventHandler("onClientResourceStart", resourceRoot,
	function ()
		shamalShader = dxCreateShader('tex_names.fx', 0, 0, true, 'vehicle')
		engineApplyShaderToWorldTexture(shamalShader, 'shamalbody256')
		
		wires = dxCreateShader('tex_names.fx', 0, 0, false)
		engineApplyShaderToWorldTexture(wires, 'telewires_law')
		engineApplyShaderToWorldTexture(wires, 'telewireslong')
		engineApplyShaderToWorldTexture(wires, 'telewireslong2')
		engineApplyShaderToWorldTexture(wires, 'antenna1')
		
		dxSetShaderValue(wires, 'gColor', 255, 0, 0, 0)
		
		dd = dxCreateShader('tex_names.fx', 0, 0, false)
		engineApplyShaderToWorldTexture(dd, 'waterclear256')
		dxSetShaderValue(dd, 'gColor', 255, 255, 0, 255)
	end
)
	
function update(r, g, b, a, sync)
	--dxSetShaderValue(shamalShader, 'gColor', r / 255, g / 255, b / 255, a / 255)
	dxSetShaderValue(shamalShader, 'gColor', r, g, b, a)
	outputDebugString("Set shamal to "..r.." "..g.." "..b.." "..a)
	if sync ~= "a" then
		triggerServerEvent("onUpdateShamalRGB", localPlayer, r, g, b)
	end
end

function updatergb(cmd, nr, ng, nb, na, sync)
	if (nr and ng and nb and na) then
		local nr, ng, nb = tonumber(nr), tonumber(ng), tonumber(nb), tonumber(na)
		update(nr, ng, nb, na, sync)
	end
end
addCommandHandler("rgb", updatergb)


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
	local r, g, b, a = colorPicker.updateTempColors()
	outputDebugString(a)
	if (localPlayer.vehicle) then
		setVehicleColor(localPlayer.vehicle, r, g, b)
	end
	--update(r, g, b, a, "a")
	--dxSetShaderValue(shamalShader, 'gColor', r / 255, g / 255, b / 255, a / 255)
--	if (moddingVeh and isElement(moddingVeh)) then
	--	local r1, g1, b1, r2, g2, b2 = getVehicleColor(moddingVeh, true)
	--	if (guiCheckBoxGetSelected(checkColor1)) then
	--		r1, g1, b1 = r, g, b
	--	end
	--	if (guiCheckBoxGetSelected(checkColor2)) then
	--		r2, g2, b2 = r, g, b
	--	end
		--if (guiCheckBoxGetSelected(checkColor3)) then
		--	setVehicleHeadLightColor(moddingVeh, r, g, b)
		--end
	--	setVehicleColor(moddingVeh, r1, g1, b1, r2, g2, b2)
	--	tempColors = {r1, g1, b1, r2, g2, b2}
	--end
end
addEventHandler("onClientRender", root, updateColor)

addEvent("onSyncShamalRGB", true)
addEventHandler("onSyncShamalRGB", root, function (r, g, b) executeCommandHandler("rgb", r.." "..g.." "..b.." a") end)

