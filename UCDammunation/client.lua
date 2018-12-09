ammoConfirm = {button = {}, window = {}, edit = {}}
ammuGUI = {button = {}, window = {}, staticimage = {}, label = {}, scrollpane = {}}

local buttonToID = {
	[1] = 22, [2] = 24, [3] = 23, [4] = 25, [5] = 27, [6] = 26, [7] = 28, [8] = 29, [9] = 32, [10] = 30, [11] = 31, [12] = 33, [13] = 34, [14] = 38, [30] = 16, [31] = 18, [32] = 39, [33] = 17,
}
--local idToButton = {
--	[22] = 1, [23] = 2, [24] = 3, [25] = 4, [26] = 5, [27] = 6, [30] = 7, [31] = 8, [28] = 9, [32] = 10, [29] = 11, [33] = 12, [34] = 13, [38] = 14,
--}

local robbery = false

function updateGUI(t)
	local temp = {}
	for x, y in pairs(t) do
		temp[y] = true
	end
	for i, v in pairs(buttonToID) do
		-- If they own the weapon
		if (i >= 20) then
			ammuGUI.button[i].enabled = true
		else
			if (temp[v]) then
				ammuGUI.button[i].enabled = false
				ammuGUI.button[i + 14].enabled = true
			else
				ammuGUI.button[i].enabled = true
				ammuGUI.button[i + 14].enabled = false
			end
		end
	end
end
addEvent("UCDammunation.update", true)
addEventHandler("UCDammunation.update", root, updateGUI)

function createGUI()
	
        ammuGUI.window = GuiWindow(181, 100, 375, 546, "UCD | Ammunation", false)
        ammuGUI.window.alpha = 230
		ammuGUI.window.sizable = false
		ammuGUI.window.visible = false
		exports.UCDutil:centerWindow(ammuGUI.window)
		
        ammuGUI.scrollpane = guiCreateScrollPane(9, 24, 356, 479, false, ammuGUI.window)
		
		local all = {
			{"colt 45", "Colt .45", prices[22][1], prices[22][2]},
			{"deagle", "Deagle", prices[23][1], prices[23][2]},
			{"silenced", "Silenced", prices[24][1], prices[24][2]},
			{"shotgun", "Shotgun", prices[25][1], prices[25][2]},
			{"combat shotgun", "SPAS-12", prices[27][1], prices[27][2]},
			{"sawed-off", "Sawn-off\nShotgun", prices[26][1], prices[26][2]},
			{"uzi", "Uzi", prices[28][1], prices[28][2]},
			{"mp5", "MP5", prices[29][1], prices[29][2]},
			{"tec-9", "Tec-9", prices[32][1], prices[32][2]},
			{"ak-47", "AK-47", prices[30][1], prices[30][2]},
			{"m4", "M4", prices[31][1], prices[31][2]},
			{"rifle", "Country Rifle", prices[33][1], prices[33][2]},
			{"sniper", "Sniper Rifle", prices[34][1], prices[34][2]},
			{"minigun", "Minigun", prices[38][1], prices[38][2]},
			
			{"grenade", "Grenade", prices[16][2]},
			{"molotov", "Molotov", prices[18][2]},
			{"satchel", "Satchel", prices[39][2]},
			{"teargas", "Teargas", prices[17][2]},
		}
		
		for i = 1, #all do
			local pos = i * 64
			if i == 0 then pos = 0 end
			
			ammuGUI.staticimage[i] = guiCreateStaticImage(0, pos, 64, 64, ":UCDhud/icons/"..all[i][1]..".png", false, ammuGUI.scrollpane)
			ammuGUI.label[i] = guiCreateLabel(64, pos, 92, 64, tostring(all[i][2]), false, ammuGUI.scrollpane)
			
			if (i <= 14) then
				ammuGUI.button[i] = GuiButton(156, pos + 6, 84, 53, "Buy Weapon ($"..tostring(exports.UCDutil:tocomma(all[i][3]))..")", false, ammuGUI.scrollpane)
				ammuGUI.button[i + 14] = GuiButton(248, pos + 6, 84, 53, "Buy Ammo\n($"..tostring(all[i][4])..")", false, ammuGUI.scrollpane)
			else
				local t = "Buy a "..all[i][1]
				if (t == "Buy a teargas") then
					t = "Buy teargas"
				end
				-- Armour needs to be 29 for compatibility reasons
				local x = i
				if (x + 14 >= 29) then
					x = x + 1
				end
				ammuGUI.button[x + 14] = GuiButton(156, pos + 6, 175, 53, tostring(t).."\n("..tostring(exports.UCDutil:tocomma(all[i][3]))..")", false, ammuGUI.scrollpane)
			end
		end
		
		ammuGUI.button[29] = GuiButton(0, ((38 / 2) * 64) + 6, 330, 53, "Buy Armour\n($1,000)", false, ammuGUI.scrollpane) -- Hacky fix I'm not proud of
        ammuGUI.button[29].enabled = false
		ammuGUI.button[34] = GuiButton(10, 513, 355, 23, "Close", false, ammuGUI.window)
		
		for i = 1, #ammuGUI.label do
			guiLabelSetHorizontalAlign(ammuGUI.label[i], "center", false)
			guiLabelSetVerticalAlign(ammuGUI.label[i], "center")
		end
		
		addEventHandler("onClientGUIClick", ammuGUI.window, handleClick)
	
	--[[
	ammuGUI.window = GuiWindow(564, 264, 806	, 574, "UCD | Ammunation", false)
	ammuGUI.window.alpha = 230
	ammuGUI.window.sizable = false
	ammuGUI.window.visible = false
	exports.UCDutil:centerWindow(ammuGUI.window)
	
	ammuGUI.label[1] = GuiLabel(84, 30, 72, 64, "Colt .45", false, ammuGUI.window)
	ammuGUI.label[2] = GuiLabel(84, 94, 72, 64, "Desert Eagle", false, ammuGUI.window)
	ammuGUI.label[3] = GuiLabel(84, 158, 72, 64, "Silenced", false, ammuGUI.window)
	ammuGUI.label[4] = GuiLabel(84, 286, 72, 64, "Sawn-off\n Shotgun", false, ammuGUI.window)
	ammuGUI.label[5] = GuiLabel(84, 350, 72, 64, "SPAS-12", false, ammuGUI.window)
	ammuGUI.label[6] = GuiLabel(84, 222, 72, 64, "Shotgun", false, ammuGUI.window)
	ammuGUI.label[7] = GuiLabel(84, 414, 72, 64, "AK-47", false, ammuGUI.window)
	ammuGUI.label[8] = GuiLabel(84, 478, 72, 64, "M4", false, ammuGUI.window)
	ammuGUI.label[9] = GuiLabel(458, 30, 72, 64, "Uzi", false, ammuGUI.window)
	ammuGUI.label[10] = GuiLabel(458, 94, 72, 64, "Tec-9", false, ammuGUI.window)
	ammuGUI.label[11] = GuiLabel(458, 158, 72, 64, "MP5", false, ammuGUI.window)
	ammuGUI.label[12] = GuiLabel(458, 222, 72, 64, "Country Rifle", false, ammuGUI.window)
	ammuGUI.label[13] = GuiLabel(458, 286, 72, 64, "Sniper Rifle", false, ammuGUI.window)
	for i = 1, 13 do
		guiLabelSetHorizontalAlign(ammuGUI.label[i], "center", false)
		guiLabelSetVerticalAlign(ammuGUI.label[i], "center")
	end
	
	ammuGUI.button[1] = GuiButton(166, 36, 78, 48, "Buy Weapon\n($12,000)", false, ammuGUI.window) -- Colt
	ammuGUI.button[2] = GuiButton(166, 104, 78, 48, "Buy Weapon\n($24,000)", false, ammuGUI.window) -- Deagle
	ammuGUI.button[3] = GuiButton(166, 168, 78, 48, "Buy Weapon\n($18,000)", false, ammuGUI.window) -- Silenced
	ammuGUI.button[4] = GuiButton(166, 232, 78, 48, "Buy Weapon\n($36,000)", false, ammuGUI.window) -- Shotgun
	ammuGUI.button[5] = GuiButton(166, 296, 78, 48, "Buy Weapon\n($40,000)", false, ammuGUI.window) -- Sawn-off
	ammuGUI.button[6] = GuiButton(166, 360, 78, 48, "Buy Weapon\n($47,000)", false, ammuGUI.window) -- SPAS-12
	ammuGUI.button[7] = GuiButton(166, 424, 78, 48, "Buy Weapon\n($56,000)", false, ammuGUI.window) -- AK-47
	ammuGUI.button[8] = GuiButton(166, 488, 78, 48, "Buy Weapon\n($69,000)", false, ammuGUI.window) -- M4
	ammuGUI.button[9] = GuiButton(530, 36, 78, 48, "Buy Weapon\n($25,000)", false, ammuGUI.window) -- Uzi
	ammuGUI.button[10] = GuiButton(530, 104, 78, 48, "Buy Weapon\n($25,000)", false, ammuGUI.window) -- Tec-9
	ammuGUI.button[11] = GuiButton(530, 168, 78, 48, "Buy Weapon\n($18,000)", false, ammuGUI.window) -- MP5
	ammuGUI.button[12] = GuiButton(530, 232, 78, 48, "Buy Weapon\n($32,000)", false, ammuGUI.window) -- Country Rifle
	ammuGUI.button[13] = GuiButton(530, 296, 78, 48, "Buy Weapon\n($75,000)", false, ammuGUI.window) -- Sniper Rifle
	ammuGUI.button[14] = GuiButton(715, 104, 78, 48, "Buy MG-42\n($5,000,000)", false, ammuGUI.window)
	
	ammuGUI.button[15] = GuiButton(254, 36, 78, 48, "Buy Ammo\n($3)", false, ammuGUI.window) -- Colt
	ammuGUI.button[16] = GuiButton(254, 104, 78, 48, "Buy Ammo\n($20)", false, ammuGUI.window) -- Deagle
	ammuGUI.button[17] = GuiButton(254, 168, 78, 48, "Buy Ammo\n($3)", false, ammuGUI.window) -- Silenced
	ammuGUI.button[18] = GuiButton(254, 232, 78, 48, "Buy Ammo\n($30)", false, ammuGUI.window) -- Shotgun
	ammuGUI.button[19] = GuiButton(254, 296, 78, 48, "Buy Ammo\n($30)", false, ammuGUI.window) -- Sawn-off
	ammuGUI.button[20] = GuiButton(254, 360, 78, 48, "Buy Ammo\n($30)", false, ammuGUI.window) -- SPAS-12
	ammuGUI.button[21] = GuiButton(254, 424, 78, 48, "Buy Ammo\n($16)", false, ammuGUI.window) -- AK-47
	ammuGUI.button[22] = GuiButton(254, 488, 78, 48, "Buy Ammo\n($16)", false, ammuGUI.window) -- M4
	ammuGUI.button[23] = GuiButton(618, 36, 78, 48, "Buy Ammo\n($10)", false, ammuGUI.window) -- Uzi
	ammuGUI.button[24] = GuiButton(618, 104, 78, 48, "Buy Ammo\n($10)", false, ammuGUI.window) -- Tec-9
	ammuGUI.button[25] = GuiButton(618, 168, 78, 48, "Buy Ammo\n($8)", false, ammuGUI.window) -- MP5
	ammuGUI.button[26] = GuiButton(618, 232, 78, 48, "Buy Ammo\n($50)", false, ammuGUI.window) -- Country Rifle
	ammuGUI.button[27] = GuiButton(618, 296, 78, 48, "Buy Ammo\n($100)", false, ammuGUI.window) -- Sniper
	ammuGUI.button[28] = GuiButton(715, 168, 78, 48, "Buy MG-42 ammo\n($12)", false, ammuGUI.window)
	
	ammuGUI.button[29] = GuiButton(715, 36, 78, 48, "Buy Armour\n($1000)", false, ammuGUI.window)
	
	ammuGUI.button[30] = GuiButton(469, 380, 94, 54, "Buy a grenade\n($2,000)", false, ammuGUI.window)
	ammuGUI.button[31] = GuiButton(469, 466, 94, 54, "Buy a molotov\n($1,500)", false, ammuGUI.window)
	ammuGUI.button[32] = GuiButton(686, 380, 94, 54, "Buy a satchel charge\n($2,000)", false, ammuGUI.window)
	ammuGUI.button[33] = GuiButton(686, 466, 94, 54, "Buy tear gas\n($1,500)", false, ammuGUI.window)
	
	ammuGUI.button[34] = GuiButton(659, 538, 135, 26, "Close", false, ammuGUI.window)
	
	addEventHandler("onClientGUIClick", ammuGUI.window, handleClick)
	
	ammuGUI.staticimage[1] = guiCreateStaticImage(10, 30, 64, 64, ":UCDhud/icons/colt 45.png", false, ammuGUI.window)
	ammuGUI.staticimage[2] = guiCreateStaticImage(10, 94, 64, 64, ":UCDhud/icons/deagle.png", false, ammuGUI.window)
	ammuGUI.staticimage[3] = guiCreateStaticImage(10, 158, 64, 64, ":UCDhud/icons/silenced.png", false, ammuGUI.window)
	ammuGUI.staticimage[4] = guiCreateStaticImage(10, 222, 64, 64, ":UCDhud/icons/shotgun.png", false, ammuGUI.window)
	ammuGUI.staticimage[5] = guiCreateStaticImage(10, 286, 64, 64, ":UCDhud/icons/sawed-off.png", false, ammuGUI.window)
	ammuGUI.staticimage[6] = guiCreateStaticImage(10, 350, 64, 64, ":UCDhud/icons/combat shotgun.png", false, ammuGUI.window)
	ammuGUI.staticimage[7] = guiCreateStaticImage(10, 414, 64, 64, ":UCDhud/icons/ak-47.png", false, ammuGUI.window)
	ammuGUI.staticimage[8] = guiCreateStaticImage(10, 478, 64, 64, ":UCDhud/icons/m4.png", false, ammuGUI.window)
	ammuGUI.staticimage[9] = guiCreateStaticImage(374, 30, 64, 64, ":UCDhud/icons/uzi.png", false, ammuGUI.window)
	ammuGUI.staticimage[10] = guiCreateStaticImage(374, 94, 64, 64, ":UCDhud/icons/tec-9.png", false, ammuGUI.window)
	ammuGUI.staticimage[11] = guiCreateStaticImage(374, 158, 64, 64, ":UCDhud/icons/mp5.png", false, ammuGUI.window)
	ammuGUI.staticimage[12] = guiCreateStaticImage(374, 222, 64, 64, ":UCDhud/icons/rifle.png", false, ammuGUI.window)
	ammuGUI.staticimage[13] = guiCreateStaticImage(374, 286, 64, 64, ":UCDhud/icons/sniper.png", false, ammuGUI.window)
	ammuGUI.staticimage[14] = guiCreateStaticImage(374, 365, 85, 85, ":UCDhud/icons/grenade.png", false, ammuGUI.window)
	ammuGUI.staticimage[15] = guiCreateStaticImage(374, 450, 85, 85, ":UCDhud/icons/molotov.png", false, ammuGUI.window)
	ammuGUI.staticimage[16] = guiCreateStaticImage(590, 365, 85, 85, ":UCDhud/icons/satchel.png", false, ammuGUI.window)
	ammuGUI.staticimage[17] = guiCreateStaticImage(590, 450, 85, 85, ":UCDhud/icons/teargas.png", false, ammuGUI.window)
	--]]
	
	ammoConfirm.window[1] = guiCreateWindow(1417, 441, 331, 108, "UCD | Ammunation - Ammo", false)
	exports.UCDutil:centerWindow(ammoConfirm.window[1])
	ammoConfirm.window[1].sizable = false
	ammoConfirm.window[1].alpha = 255
	ammoConfirm.window[1].visible = false
	ammoConfirm.edit[1] = guiCreateEdit(9, 24, 312, 33, "", false, ammoConfirm.window[1])
	ammoConfirm.edit[1].maxLength = 4
	ammoConfirm.button[1] = GuiButton(10, 65, 148, 34, "Buy", false, ammoConfirm.window[1])
	ammoConfirm.button[2] = GuiButton(173, 65, 148, 34, "Close", false, ammoConfirm.window[1])
	addEventHandler("onClientGUIClick", ammoConfirm.button[1], onClickAmmoBuy, false)
	addEventHandler("onClientGUIClick", ammoConfirm.button[2], toggleAmmoConfirmation, false)
	addEventHandler("onClientGUIChanged", ammoConfirm.edit[1], onAmmoConfirmationChanged, false)
end
addEventHandler("onClientResourceStart", resourceRoot, createGUI)

function toggleGUI(tbl)
	ammuGUI.window.visible = not ammuGUI.window.visible
	showCursor(ammuGUI.window.visible)
	guiSetInputMode(ammuGUI.window.visible and "no_binds_when_editing" or "allow_binds")
	if (tbl and type(tbl) == "table") then
		updateGUI(tbl)
	end
end
addEvent("UCDammunation.open", true)
addEventHandler("UCDammunation.open", root, toggleGUI)

function toggleAmmoConfirmation(weaponID)
	ammo_weapon_id = nil
	ammoConfirm.window[1].visible = not ammoConfirm.window[1].visible
	if (weaponID and type(weaponID) == "number") then
		ammo_weapon_id = weaponID
		guiBringToFront(ammoConfirm.window[1])
		local price = prices[weaponID][2]
		ammoConfirm.button[1].text = "Buy ($"..exports.UCDutil:tocomma(price)..")"
		ammoConfirm.edit[1].text = "1"
	end
end
function onAmmoConfirmationChanged()
	local ammo = ammoConfirm.edit[1].text
	outputDebugString(ammo)
	if (ammo and tonumber(ammo)) then
		ammoConfirm.button[1].text = "Buy ($"..exports.UCDutil:tocomma(prices[ammo_weapon_id][2] * ammo)..")"
	end
end
function onClickAmmoBuy()
	local ammo = ammoConfirm.edit[1].text
	if (ammo and tonumber(ammo)) then
		local amount = prices[ammo_weapon_id][2] * ammo
		if (amount > localPlayer:getMoney()) then
			exports.UCDdx:new("You cannot afford to purchase this much ammo", 255, 0, 0)
			return
		end
		if (robbery) then
			exports.UCDdx:new("You can't buy ammo while you're robbing the ammunation!", 255, 0, 0)
			return
		end
		triggerServerEvent("UCDammunation.buyAmmo", localPlayer, ammo_weapon_id, ammo)
		toggleAmmoConfirmation()
	else
		exports.UCDdx:new("You need to enter a valid number", 255, 0, 0)
	end
end

function handleClick()
	-- Only handle buttons
	local btnIndex
	for i = 1, #ammuGUI.button do
		if (source == ammuGUI.button[i]) then
			btnIndex = i
		end
	end
	if (not btnIndex) then return end
	
	if (source == ammuGUI.button[34]) then
		toggleGUI()
	elseif (source == ammuGUI.button[29]) then
		-- not done yet
		-- armour
	else
	
		local explosives = {[ammuGUI.button[30]] = true, [ammuGUI.button[31]] = true, [ammuGUI.button[32]] = true, [ammuGUI.button[33]] = true}
		if (explosives[source]) then
			toggleAmmoConfirmation(buttonToID[btnIndex])
			return
		end
		
		if (buttonToID[btnIndex] and getWeaponNameFromID(buttonToID[btnIndex])) then
			-- Buying a weapon
			local price = prices[buttonToID[btnIndex]][1]
			if (localPlayer:getMoney() < price) then
				exports.UCDdx:new("You cannot afford to purchase this weapon", 255, 0, 0)
				return
			end
			if (robbery) then
				exports.UCDdx:new("You can't purchase a weapon while you're robbing the ammunation!", 255, 0, 0)
				return
			else
				
			end
			local wepName = getWeaponNameFromID(buttonToID[btnIndex])
			if (wepName == "Combat Shotgun") then
				wepName = "SPAS-12"
			end
			exports.UCDutil:createConfirmationWindow("UCDammunation.buyWeapon", buttonToID[btnIndex], true, "UCD | Ammunation - Confirmation", "Are you sure you want to buy a "..wepName.."?")
		else
			local a = buttonToID[btnIndex - 14]
			--outputDebugString(tostring(getWeaponNameFromID(buttonToID[btnIndex - 14])))
			toggleAmmoConfirmation(a)
		end
	end
end