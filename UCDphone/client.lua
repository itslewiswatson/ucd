--[[
	Notes:
	- Row positioning and column positiong starts at 0
	- Row -1 is the dock
--]]



-- Phone positioning
local sX, sY = guiGetScreenSize()
local pX, pY = sX - 320, sY - 622
local pW, pH = 310, 600
if (sX == 800 and sY == 600) then
	pX, pY = sX - 310, 0
end

-- Apps
local app = {width = 54, height = 54}
local baseX, baseY = 31, 95--100
local offX, offY = 64, 76--79

local bX, bY, bW, bH = sX + 10, pY + 30, pW - 20, pH - 40
function hhhh()
	dxDrawRectangle(bX, bY, bW, bH, tocolor(0, 0, 0, 100), false, false)
	
	-- Update the time on the phone
	if (phone and phone.label and phone.label["time"] and isElement(phone.label["time"])) then
		
		local t = getRealTime()
		local h, m, m2 = t.hour, t.minute, "AM"
		if (h > 12) then
			h = h - 12
			m2 = "PM"
		end
		if m < 10 then
		m = "0"..m
		end
		if h < 10 then
			h = "0"..h
		end
		phone.label["time"].text = tostring(h)..":"..tostring(m).." "..tostring(m2)
	else
		outputDebugString("D:")
	end
end
addEventHandler("onClientHUDRender", root, hhhh)

phone = 
{
	-- Global scope [all of phone]
	button = {},
	image = {},
	label = {},
	
	-- Home screen/all apps
	home = 
	{
		button = {}, image = {}, label = {},
	},
	
	-- Each app will have their own nested table within, example below
	-- These table declarations are declared in the apps folder
	--[[
	stocks = 
	{
		button = {},
		gridlist = {}
	}
	--]]
}

phone.image["phone_window"] = GuiStaticImage(sX + 10 --[[abs = 1600]], pY, 310, 600, ":UCDphone/iphone3.png", false)
phone.image["phone_window"].visible = false

phone.label["banner"] = GuiLabel(20, 71, 60, 17, " UCDphone", false, phone.image["phone_window"])
phone.label["banner"].font = "default-bold-small"
phone.label["time"] = GuiLabel((310 / 2) - 15, 71, 60, 17, "zyzz brah", false, phone.image["phone_window"])
phone.label["time"].font = "default-bold-small"

phone.button["home"] = GuiButton(130, 535, 50, 50, "", false, phone.image["phone_window"])
phone.button["home"].alpha = 0

addEventHandler("onClientGUIClick", phone.button["home"], 
	function ()
		-- Close the phone if the home screen is open
		if (isHomeScreenOpen()) then 
			togglePhone()
		else
			-- Loop through all the apps in allapps (/apps/apps.lua)
			for i, v in pairs(allapps) do
				-- If it's visible
				--if (v.all and v.all[1].visible) then
				if (v.all and v.open) then
					-- Close it and open the main window
					toggleApp(i)
				end
			end
		end
	end, false
)

local apps = 
{
	-- [id] = {string name, string icon, {int row, int pos}}
	-- Docked
	[1] = {"IM", "im.png", {-1, 0}},
	[2] = {"Music", "music.png", {-1, 1}},
	[3] = {"Browser", "browser.png", {-1, 2}},
	[4] = {"Settings", "settings.png", {-1, 3}},
	
	-- Other
	[5] = {"Notes", "notes.png", {0, 0}},
	[6] = {"Clock", "clock.png", {0, 1}},
	[7] = {"Calculator", "calc.png", {0, 2}},
	[8] = {"Camera", "camera.png", {0, 3}},
	
	[9] = {"Money", "money.png", {1, 0}},
	[10] = {"Mark", "mark.png", {1, 1}},
	[11] = {"Weather", "weather.png", {1, 2}},
	[12] = {"Stocks", "stocks.png", {1, 3}},
	
	[13] = {"Housing", "housing.png", {2, 0}},
	[14] = {"Friends", "friends.png", {2, 1}},
	[15] = {"Mail", "mail.png", {2, 2}},
	[16] = {"Anims", "", {2, 3}},
}

-- Home screen
for i, info in ipairs(apps) do
	local x, y
	
	-- Work out the x axis
	x = baseX + (offX * info[3][2])
	
	-- If it's a docked row
	if (info[3][1] == -1) then
		y = 455
	else
		y = baseY + (offY * info[3][1])
	end
	
	phone.home.image[i] = GuiStaticImage(x, y, app.width, app.height, ":UCDphone/images/"..info[2], false, phone.image["phone_window"])
	phone.home.label[i] = GuiLabel(x, y + app.height, app.width + 3, 15, tostring(info[1]), false, phone.image["phone_window"])
	guiLabelSetHorizontalAlign(phone.home.label[i], "center", false)
end

function togglePhone()
	if (not exports.UCDaccounts:isPlayerLoggedIn(localPlayer)) then
		return
	end
	
	local now = getTickCount()
	guiSetInputMode("no_binds_when_editing")
	showCursor(not phone.image["phone_window"].visible)
	
	if (phone.image["phone_window"].visible) then
		if (#getEventHandlers("onClientRender", root, closePhone) == 0) then
			addEventHandler("onClientRender", root, closePhone)
			
			phone.start = getTickCount()
			phone.finish = phone.start + 150
		else
			outputDebugString("In prog")
		end
	else
		if (#getEventHandlers("onClientRender", root, openPhone) == 0) then
			phone.image["phone_window"].visible = true
			addEventHandler("onClientRender", root, openPhone)
			
			phone.start = getTickCount()
			phone.finish = phone.start + 300
		else
			outputDebugString("In prog")
		end
	end
end
bindKey("b", "down", togglePhone)

function openPhone()	
	local now = getTickCount()
	local duration = phone.finish - phone.start
	local elapsed = now - phone.start
	local prog = elapsed / duration
	
	local x1, y1 = guiGetPosition(phone.image["phone_window"], false)
	local x2, y2 = pX, pY
	
	local x, y = interpolateBetween(x1, y1, 0, x2, y2, 0, prog, "Linear") --, 0.04, 1.7)
	bX, bY = x + 10, y + 20
	phone.image["phone_window"]:setPosition(x, y, false)
	
	if (now >= phone.finish and prog >= 1) then
		removeEventHandler("onClientRender", root, openPhone)
	end
end

function closePhone()
	local now = getTickCount()
	local duration = phone.finish - phone.start
	local elapsed = now - phone.start
	local prog = elapsed / duration
	
	local x1, y1 = guiGetPosition(phone.image["phone_window"], false)
	local x2, y2 = sX + 10, pY
	
	local x, y = interpolateBetween(x1, y1, 0, x2, y2, 0, prog, "Linear")
	bX, bY = x + 10, y + 20
	phone.image["phone_window"]:setPosition(x, y, false)
	
	if (now >= phone.finish and prog >= 1) then
		removeEventHandler("onClientRender", root, closePhone)
		phone.image["phone_window"].visible = false
	end
end

function isHomeScreenOpen()
	if (not phone.image["phone_window"].visible or not phone.home.image[1].visible) then
		return false
	end
	return true
end

function onClickApp()
	if (source.type == "gui-staticimage") then
		local index, appName
		for i, ele in ipairs(phone.home.image) do
			if (ele == source) then
				index = i
				break
			end
		end
		toggleApp(index)
		triggerEvent("UCDphone.onOpenApp", localPlayer, index)
	end
end
addEventHandler("onClientGUIClick", phone.image["phone_window"], onClickApp)