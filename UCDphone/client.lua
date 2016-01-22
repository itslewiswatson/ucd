--[[
	Notes:
	- Row positioning and column positiong starts at 0
	- Row -1 is the dock
--]]

local sX, sY = guiGetScreenSize()
local app = {width = 54, height = 54}
local baseX, baseY = 31, 100
local offX, offY = 64, 79
local blur

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
}
phone.image["phone_window"] = GuiStaticImage(sX - 320 --[[abs = 1600]], sY - 622 --[[abs = 458]], 310, 600, ":UCDphone/iphone2.png", false)
phone.image["phone_window"].visible = false
--GUIEditor.label[1] = GuiLabel(20, 71, 268, 17, "UCDphone                                            19:23", false, phone.image["phone_window"])
phone.label["banner"] = GuiLabel(20, 71, 268, 17, " UCDphone", false, phone.image["phone_window"])
phone.label["banner"].font = "default-bold-small"

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
				if (v.all and v.all[1].visible) then
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
}

-- Home screen
for i, info in ipairs(apps) do
	local x, y
	
	-- Work out the x axis
	x = baseX + (offX * info[3][2])
	
	-- If it's a docked row
	if (info[3][1] == -1) then
		y = 449
	else
		y = baseY + (offY * info[3][1])
	end
	
	--phone.home.button[i] = GuiButton(x, y, app.width, app.height, info[1], false, phone.image["phone_window"])
	--phone.home.button[i].alpha = 0
	phone.home.image[i] = GuiStaticImage(x, y, app.width, app.height, ":UCDphone/images/"..info[2], false, phone.image["phone_window"])
	phone.home.label[i] = GuiLabel(x, y + app.height, app.width, 15, info[1], false, phone.image["phone_window"])
	guiLabelSetHorizontalAlign(phone.home.label[i], "center", false)
end

function togglePhone()
	guiSetInputMode("no_binds_when_editing")
	if (blur and isElement(blur)) then
		exports.blur_box:destroyBlurBox(blur)
	else
		blur = exports.blur_box:createBlurBox(sX - 310, sY - 560, 290, 490, 0, 0, 0, 100, false)
	end
	phone.image["phone_window"].visible = not phone.image["phone_window"].visible
	showCursor(phone.image["phone_window"].visible)
end
bindKey("b", "up", togglePhone)

function isHomeScreenOpen()
	if (not phone.image["phone_window"].visible or not phone.home.image[1].visible) then
		return false
	end
	return true
end

addEventHandler("onClientGUIClick", guiRoot,
	function ()
		if (source.parent == phone.image["phone_window"] and source.type == "gui-staticimage") then
			local index, appName
			for i, ele in ipairs(phone.home.image) do
				if (ele == source) then
					index = i
					break
				end
			end
			toggleApp(index)
		end
	end
)
