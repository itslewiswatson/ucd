function createConfirmationWindow(text, callbackString, arg)
	local confirmation = {window={}, label={}, button={}}
	
	local calledResource = tostring(Resource.getName(sourceResource))
	-- Replace 'UCD' with blank and capitalise the first letter
	calledResource = calledResource:gsub("UCD", "")
	calledResource = calledResource:gsub("^%l", string.upper)
	outputDebugString(callbackString)
	
	confirmation.window[1] = guiCreateWindow(819, 425, 282, 132, "UCD | "..calledResource.." - Confirmation", false)
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
			
			
			if (callbackString ~= "") then
				outputDebugString("UCDutil: argument passed = "..tostring(arg))
				local arg = arg
				outputDebugString(callbackString)
				loadstring(callbackString)(arg) -- This runs it straight away and allows argument passing
				assert(loadstring(callbackString))(arg) -- This runs it straight away and allows argument passing
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
end

--[[
-- CALLBACK STRING SHOULD BE IN FORM OF
-- "exports.resource:function(args)"
--]]