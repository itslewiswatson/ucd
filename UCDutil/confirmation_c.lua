function createConfirmationWindow(event, arg, isServerEvent, title, text)
	local confirmation = {window={}, label={}, button={}}
	
	local calledResource = tostring(Resource.getName(sourceResource))
	-- Replace 'UCD' with blank and capitalise the first letter
	if (not title) then
		calledResource = calledResource:gsub("UCD", "")
		calledResource = calledResource:gsub("^%l", string.upper)
		title = "UCD | "..calledResource.." - Confirmation"
	end
	
	confirmation.window[1] = guiCreateWindow(819, 425, 282, 132, title, false)
	guiWindowSetSizable(confirmation.window[1], false)

	confirmation.label[1] = guiCreateLabel(10, 26, 262, 44, tostring(text), false, confirmation.window[1])
	guiLabelSetHorizontalAlign(confirmation.label[1], "center", false)
	confirmation.button[1] = guiCreateButton(47, 85, 76, 36, "Yes", false, confirmation.window[1])
	confirmation.button[2] = guiCreateButton(164, 85, 76, 36, "No", false, confirmation.window[1])
	
	showCursor(true)
	
	-- The purchase house bit underneath is not part of this general function.
	function confirmationWindowClick()
		if (source == confirmation.button[1]) then
			if (isElement(confirmation.window[1])) then
				removeEventHandler("onClientGUIClick", confirmation.window[1], confirmationWindowClick)
				confirmation.window[1]:destroy()
			end
			
			if (event) then
				if (isServerEvent and isServerEvent ~= nil) then
					triggerServerEvent(event, localPlayer, arg)
				else
					triggerEvent(event, localPlayer, arg)
				end
			end
			
			showCursor(false)
			return true
		elseif (source == confirmation.button[2]) then
		
			if (isElement(confirmation.window[1])) then
				removeEventHandler("onClientGUIClick", confirmation.window[1], confirmationWindowClick)
				confirmation.window[1]:destroy()
			end
			
			showCursor(false)
			return false
		end
	end
	addEventHandler("onClientGUIClick", confirmation.window[1], confirmationWindowClick)
	
	if (confirmation.window[1] and isElement(confirmation.window[1])) then
		return true
	else
		return false
	end
end

--[[
-- CALLBACK STRING SHOULD BE IN FORM OF
-- "exports.resource:function(args)"
--]]