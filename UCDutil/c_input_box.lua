confirm = {
    button = {},
    window = {},
    label = {},
    edit = {}
}

confirm.window[1] = nil

function createInputBox(title, message, default, action, var1, var2)
	if (confirm.window[1] == nil) then
		confirm.window[1] = guiCreateWindow(792, 480, 324, 111, "", false)
		confirm.window[1].alpha = 255
		guiWindowSetSizable(confirm.window[1], false)
		centerWindow(confirm.window[1])
		confirm.button[1] = guiCreateButton(58, 82, 101, 19, "Confirm", false, confirm.window[1])
		confirm.button[2] = guiCreateButton(169, 82, 101, 19, "Cancel", false, confirm.window[1])
		confirm.edit[1] = guiCreateEdit(35, 47, 260, 25, "", false, confirm.window[1])
		confirm.label[1] = guiCreateLabel(36, 21, 259, 20, "", false, confirm.window[1])
		guiLabelSetHorizontalAlign(confirm.label[1], "center", false)
		guiLabelSetVerticalAlign(confirm.label[1], "center")
	end
	confirm.window[1]:setText(tostring(title))
	confirm.label[1]:setText(tostring(message))
	confirm.edit[1]:setText(tostring(default))
	
	confirm.window[1]:setVisible(true)
	guiBringToFront(confirm.window[1])
	guiSetProperty(confirm.window[1], "AlwaysOnTop", "true")
	
	action_ = action
	
	addEventHandler("onClientGUIClick", confirm.window[1], clickInputBox)
	
	var = {[1] = var1, [2] = var2}
end

function closeInputBox()
	if (confirm.window[1]) then
		removeEventHandler("onClientGUIClick", confirm.window[1], clickInputBox)
		action_ = nil
		destroyElement(confirm.window[1])
		confirm.window[1] = nil
		var = {}
	end
end

function clickInputBox(button)
	if (button == "left") then
		if (source == confirm.button[1]) then
			local text = confirm.edit[1].text
			triggerServerEvent(action_, var[1], var[2], text)
			action_ = nil
			closeInputBox()
		elseif (source == confirm.button[2]) then
			action_ = nil
			closeInputBox()
		end
	end
end
