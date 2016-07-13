screenWidth, screenHeight = guiGetScreenSize()

function toggleBrowser()
	-- 1.5.3 hasn't been released yet
	if (isBrowserSupported and type(isBrowserSupported) == "function") then
		if (not isBrowserSupported()) then
			outputChatBox("Your operating system does not support the browser. Please consider upgrading to a newer OS version", 255, 0, 0)
			return false
		end
	end
	if (WebBrowserGUI.instance) then
		local b = WebBrowserGUI.instance
		if b.m_Window.visible then
			showCursor(false)
			b.m_Window.visible = false
		else
			showCursor(true)
			b.m_Window.visible = true
		end
	else
		showBrowser()
	end
	return true
end
addCommandHandler("browser", toggleBrowser)

function showBrowser()
	if WebBrowserGUI.instance ~= nil then return end
	WebBrowserGUI.instance = WebBrowserGUI:new()
end
