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
		guiWindowSetSizable(confirm.window[1], false)
		

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
			if (action_ == "UCDadmin.giveVehicle" and tonumber(confirm.edit[1]:getText()) == nil) then
				if (not getVehicleModelFromName(confirm.edit[1]:getText())) then
					exports.UCDdx:new("You must specify a valid vehicle name or ID", 255, 0, 0)
					return
				end
			end
			triggerServerEvent(action_, var[1], var[2], confirm.edit[1]:getText())
			
			--[[		
			if (action_ == "kickPlayer") then
				triggerServerEvent("aPlayer", localPlayer, varOne, "kick", guiGetText(aInputValue))
			elseif (action_ == "setHealth") then
				triggerServerEvent("aPlayer", localPlayer, varOne, "sethealth", guiGetText(aInputValue))
			elseif (action_ == "setArmor") then
				triggerServerEvent("aPlayer", localPlayer, varOne, "setarmour", guiGetText(aInputValue))
			elseif (action_ == "setNick") then
				triggerServerEvent("aPlayer", localPlayer, varOne, "setnick", guiGetText(aInputValue))
			elseif (action_ == "shout") then
				triggerServerEvent("aPlayer", localPlayer, varOne, "shout", guiGetText(aInputValue))
			elseif (action_ == "setMoney") then
				triggerServerEvent("aPlayer", localPlayer, varOne, "setmoney", guiGetText(aInputValue))
			elseif (action_ == "setDimension") then
				triggerServerEvent("aPlayer", localPlayer, varOne, "setdimension", guiGetText(aInputValue))
			elseif (action_ == "setCurrentAmmo") then
				aSetCurrentAmmo(guiGetText(aInputValue))
			elseif (action_ == "setGameType") then
				triggerServerEvent("aServer", localPlayer, "setgame", guiGetText(aInputValue))
			elseif (action_ == "setMapName") then
				triggerServerEvent("aServer", localPlayer, "setmap", guiGetText(aInputValue))
			elseif (action_ == "setWelcome") then
				triggerServerEvent("aServer", localPlayer, "setwelcome", guiGetText(aInputValue))
			elseif (action_ == "setServerPassword") then
				triggerServerEvent("aServer", localPlayer, "setpassword", guiGetText(aInputValue))
			elseif (action_ == "serverShutdown") then
				triggerServerEvent("aServer", localPlayer, "shutdown", guiGetText(aInputValue))
			elseif (action_ == "unbanIP") then
				triggerServerEvent("aBans", localPlayer, "unbanip", guiGetText(aInputValue))
			elseif (action_ == "unbanSerial") then
				triggerServerEvent("aBans", localPlayer, "unbanserial", guiGetText(aInputValue))
			elseif (action_ == "banIP") then
				triggerServerEvent("aBans", localPlayer, "banip", guiGetText(aInputValue))
			elseif (action_ == "banSerial") then
				triggerServerEvent("aBans", localPlayer, "banserial", guiGetText(aInputValue))
			elseif (action_ == "settingChange") then
				triggerServerEvent("aAdmin", localPlayer, "settings", "change", varOne, varTwo, guiGetText(aInputValue))
			elseif (action_ == "aclCreateGroup") then
				triggerServerEvent("aAdmin", localPlayer, "aclcreate", "group", guiGetText(aInputValue))
			elseif (action_ == "aclCreate") then
				triggerServerEvent("aAdmin", localPlayer, "aclcreate", "acl", guiGetText(aInputValue))
			elseif (action_ == "aclAddObject") then
				triggerServerEvent("aAdmin", localPlayer, "acladd", "object", varOne, guiGetText(aInputValue))
			elseif (action_ == "aclAddRight") then
				triggerServerEvent("aAdmin", localPlayer, "acladd", "right", varOne, guiGetText(aInputValue))
			end
			-]]
			
			action_ = nil
			closeInputBox()
		elseif (source == confirm.button[2]) then
			action_ = nil
			closeInputBox()
		end
	end
end
