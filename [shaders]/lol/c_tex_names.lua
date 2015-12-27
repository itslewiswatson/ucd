addEventHandler("onClientResourceStart", resourceRoot,
	function ()
		shamalShader = dxCreateShader('tex_names.fx', 0, 0, false, 'vehicle')
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
	dxSetShaderValue(shamalShader, 'gColor', r / 255, g / 255, b / 255, a / 155)
	if sync ~= "a" then
		triggerServerEvent("onUpdateShamalRGB", localPlayer, r, g, b)
	end
end

function updatergb(cmd, nr, ng, nb, sync)
	if (nr and ng and nb) then
		local nr, ng, nb = tonumber(nr), tonumber(ng), tonumber(nb)
		update(nr, ng, nb, 120, sync)
	end
end
addCommandHandler("rgb", updatergb)

addEvent("onSyncShamalRGB", true)
addEventHandler("onSyncShamalRGB", root, function (r, g, b) executeCommandHandler("rgb", r.." "..g.." "..b.." a") end)

