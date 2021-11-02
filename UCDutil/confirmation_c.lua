confirmation = {window={}, label={}, button={}}

confirmation.window[1] = nil

function createConfirmationWindow(event, argument, serverOrClient, title, text)
	calledResource = tostring(Resource.getName(sourceResource))
	-- Replace 'UCD' with blank and capitalise the first letter
	if (not title) then
		calledResource = calledResource:gsub("UCD", "")
		calledResource = calledResource:gsub("^%l", string.upper)
		title = "UCD | "..calledResource.." - Confirmation"
	end
	
	if (confirmation.window[1] == nil) then
		confirmation.window[1] = guiCreateWindow(819, 425, 282, 132, title, false)
		confirmation.window[1].alpha = 255
		centerWindow(confirmation.window[1])
		guiWindowSetSizable(confirmation.window[1], false)
		
		confirmation.label[1] = guiCreateLabel(10, 26, 262, 44, tostring(text), false, confirmation.window[1])
		guiLabelSetHorizontalAlign(confirmation.label[1], "center", true)
		confirmation.button[1] = guiCreateButton(47, 85, 76, 36, "Yes", false, confirmation.window[1])
		confirmation.button[2] = guiCreateButton(164, 85, 76, 36, "No", false, confirmation.window[1])
	end
	
	action_ = event
	isServerEvent = serverOrClient
	arg = argument
	
	confirmation.window[1]:setVisible(true)
	guiBringToFront(confirmation.window[1])
	guiSetProperty(confirmation.window[1], "AlwaysOnTop", "true")
	if (#getEventHandlers("onClientGUIClick", confirmation.window[1], clickConfirmationWindow) == 0) then
		addEventHandler("onClientGUIClick", confirmation.window[1], clickConfirmationWindow)
	end
end

function closeConfirmationWindow()
	if (confirmation.window[1]) then
		removeEventHandler("onClientGUIClick", confirmation.window[1], clickConfirmationWindow)
		action_ = nil
		confirmation.window[1]:destroy()
		confirmation.window[1] = nil
		var = {}
	end
end

function clickConfirmationWindow(button)
	if (button == "left") then
		if (source == confirmation.button[1]) then
			if (action_) then
				if (isServerEvent and isServerEvent ~= nil) then
					triggerServerEvent(action_, localPlayer, arg)
				else
					triggerEvent(action_, localPlayer, arg)
				end
			end
			
			action_ = nil
			closeConfirmationWindow()
			
		elseif (source == confirmation.button[2]) then
			action_ = nil
			closeConfirmationWindow()
		end
	end
end
