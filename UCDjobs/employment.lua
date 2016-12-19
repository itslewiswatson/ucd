employment = {}
local sX, sY = guiGetScreenSize()

employment.window = GuiWindow(0, 0, 269, 80, "UCD | Employment", false)
employment.window.sizeble = false
employment.window.visible = false
employment.window:setPosition(sX / 2 - 269 / 2, sY - 80, false, false)
employment.toggle = GuiButton(9, 26, 120, 43, "Start/End Shift", false, employment.window)
employment.quit = GuiButton(139, 26, 120, 43, "Quit Job", false, employment.window)

function toggleGUI()
	if (not exports.UCDaccounts:isPlayerLoggedIn(localPlayer)) then
		return
	end
	employment.window.visible = not employment.window.visible
	if (F5.window.visible and not employment.window.visible) then return end
	showCursor(employment.window.visible)
end
addCommandHandler("jobgui", toggleGUI, false, false)
addCommandHandler("jobsgui", toggleGUI, false, false)
addCommandHandler("jobui", toggleGUI, false, false)
addCommandHandler("jobsui", toggleGUI, false, false)
bindKey("F3", "up", "jobgui")

function forceClose()
	employment.window.visible = false
	showCursor(false)
end
addEvent("UCDjobs.forceClose", true)
addEventHandler("UCDjobs.forceClose", root, forceClose)

function onClick()
	if (source == employment.toggle) then
		triggerServerEvent("UCDjobs.onPlayerToggleShift", localPlayer)
	else
		exports.UCDutil:createConfirmationWindow("UCDjobs.onAttemptQuitJob", nil, true, "Quit Job?", "Are you sure you want to quit your job?")
	end
end
addEventHandler("onClientGUIClick", employment.toggle, onClick, false)
addEventHandler("onClientGUIClick", employment.quit, onClick, false)
