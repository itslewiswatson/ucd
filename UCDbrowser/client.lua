screenWidth, screenHeight = guiGetScreenSize()

function toggleBrowser()
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
end
addCommandHandler("browser", toggleBrowser)

function isPointInRect(posX, posY, posX1, posY1, posX2, posY2)
	return (posX > posX1 and posX < posX2) and (posY > posY1 and posY < posY2)
end

function showBrowser()
	if WebBrowserGUI.instance ~= nil then return end
	WebBrowserGUI.instance = WebBrowserGUI:new()
end
