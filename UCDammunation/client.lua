ammoConfirm = {button = {}, window = {}, edit = {}}
ammuGUI = {button = {}, window = {}, staticimage = {}, label = {}}

local buttonToID = {
	[1] = 22, [2] = 24, [3] = 23, [4] = 25, [5] = 26, [6] = 27, [7] = 30, [8] = 31, [9] = 28, [10] = 32, [11] = 29, [12] = 33, [13] = 34, [14] = 38, [30] = 16, [31] = 18, [32] = 39, [33] = 17,
}
--local idToButton = {
--	[22] = 1, [23] = 2, [24] = 3, [25] = 4, [26] = 5, [27] = 6, [30] = 7, [31] = 8, [28] = 9, [32] = 10, [29] = 11, [33] = 12, [34] = 13, [38] = 14,
--}

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
	
	ammuGUI.window[1] = guiCreateWindow(564, 264, 826, 574, "UCD | Ammunation", false)
	ammuGUI.window[1].alpha = 230
	ammuGUI.window[1].sizable = false
	ammuGUI.window[1].visible = false
	exports.UCDutil:centerWindow(ammuGUI.window[1])
	
	ammuGUI.label[1] = guiCreateLabel(84, 30, 72, 64, "Colt .45", false, ammuGUI.window[1])
	ammuGUI.label[2] = guiCreateLabel(84, 94, 72, 64, "Desert Eagle", false, ammuGUI.window[1])
	ammuGUI.label[3] = guiCreateLabel(84, 158, 72, 64, "Silenced", false, ammuGUI.window[1])
	ammuGUI.label[4] = guiCreateLabel(84, 286, 72, 64, "Sawn-off\n Shotgun", false, ammuGUI.window[1])
	ammuGUI.label[5] = guiCreateLabel(84, 350, 72, 64, "SPAS-12", false, ammuGUI.window[1])
	ammuGUI.label[6] = guiCreateLabel(84, 222, 72, 64, "Shotgun", false, ammuGUI.window[1])
	ammuGUI.label[7] = guiCreateLabel(84, 414, 72, 64, "AK-47", false, ammuGUI.window[1])
	ammuGUI.label[8] = guiCreateLabel(84, 478, 72, 64, "M4", false, ammuGUI.window[1])
	ammuGUI.label[9] = guiCreateLabel(458, 30, 72, 64, "Uzi", false, ammuGUI.window[1])
	ammuGUI.label[10] = guiCreateLabel(458, 94, 72, 64, "Tec-9", false, ammuGUI.window[1])
	ammuGUI.label[11] = guiCreateLabel(458, 158, 72, 64, "MP5", false, ammuGUI.window[1])
	ammuGUI.label[12] = guiCreateLabel(458, 222, 72, 64, "Country Rifle", false, ammuGUI.window[1])
	ammuGUI.label[13] = guiCreateLabel(458, 286, 72, 64, "Sniper Rifle", false, ammuGUI.window[1])
	for i = 1, 13 do
		guiLabelSetHorizontalAlign(ammuGUI.label[i], "center", false)
		guiLabelSetVerticalAlign(ammuGUI.label[i], "center")
	end
	
	ammuGUI.button[1] = guiCreateButton(166, 36, 78, 48, "Buy Weapon\n($12,000)", false, ammuGUI.window[1]) -- Colt
	ammuGUI.button[2] = guiCreateButton(166, 104, 78, 48, "Buy Weapon\n($24,000)", false, ammuGUI.window[1]) -- Deagle
	ammuGUI.button[3] = guiCreateButton(166, 168, 78, 48, "Buy Weapon\n($18,000)", false, ammuGUI.window[1]) -- Silenced
	ammuGUI.button[4] = guiCreateButton(166, 232, 78, 48, "Buy Weapon\n($36,000)", false, ammuGUI.window[1]) -- Shotgun
	ammuGUI.button[5] = guiCreateButton(166, 296, 78, 48, "Buy Weapon\n($40,000)", false, ammuGUI.window[1]) -- Sawn-off
	ammuGUI.button[6] = guiCreateButton(166, 360, 78, 48, "Buy Weapon\n($47,000)", false, ammuGUI.window[1]) -- SPAS-12
	ammuGUI.button[7] = guiCreateButton(166, 424, 78, 48, "Buy Weapon\n($56,000)", false, ammuGUI.window[1]) -- AK-47
	ammuGUI.button[8] = guiCreateButton(166, 488, 78, 48, "Buy Weapon\n($69,000)", false, ammuGUI.window[1]) -- M4
	ammuGUI.button[9] = guiCreateButton(540, 36, 78, 48, "Buy Weapon\n($25,000)", false, ammuGUI.window[1]) -- Uzi
	ammuGUI.button[10] = guiCreateButton(540, 104, 78, 48, "Buy Weapon\n($25,000)", false, ammuGUI.window[1]) -- Tec-9
	ammuGUI.button[11] = guiCreateButton(540, 168, 78, 48, "Buy Weapon\n($18,000)", false, ammuGUI.window[1]) -- MP5
	ammuGUI.button[12] = guiCreateButton(540, 232, 78, 48, "Buy Weapon\n($32,000)", false, ammuGUI.window[1]) -- Country Rifle
	ammuGUI.button[13] = guiCreateButton(540, 296, 78, 48, "Buy Weapon\n($75,000)", false, ammuGUI.window[1]) -- Sniper Rifle
	ammuGUI.button[14] = guiCreateButton(725, 104, 78, 48, "Buy MG-42\n($5,000,000)", false, ammuGUI.window[1])
	
	ammuGUI.button[15] = guiCreateButton(254, 36, 78, 48, "Buy Ammo\n($3)", false, ammuGUI.window[1]) -- Colt
	ammuGUI.button[16] = guiCreateButton(254, 104, 78, 48, "Buy Ammo\n($20)", false, ammuGUI.window[1]) -- Deagle
	ammuGUI.button[17] = guiCreateButton(254, 168, 78, 48, "Buy Ammo\n($3)", false, ammuGUI.window[1]) -- Silenced
	ammuGUI.button[18] = guiCreateButton(254, 232, 78, 48, "Buy Ammo\n($30)", false, ammuGUI.window[1]) -- Shotgun
	ammuGUI.button[19] = guiCreateButton(254, 296, 78, 48, "Buy Ammo\n($30)", false, ammuGUI.window[1]) -- Sawn-off
	ammuGUI.button[20] = guiCreateButton(254, 360, 78, 48, "Buy Ammo\n($30)", false, ammuGUI.window[1]) -- SPAS-12
	ammuGUI.button[21] = guiCreateButton(254, 424, 78, 48, "Buy Ammo\n($16)", false, ammuGUI.window[1]) -- AK-47
	ammuGUI.button[22] = guiCreateButton(254, 488, 78, 48, "Buy Ammo\n($16)", false, ammuGUI.window[1]) -- M4
	ammuGUI.button[23] = guiCreateButton(628, 36, 78, 48, "Buy Ammo\n($10)", false, ammuGUI.window[1]) -- Uzi
	ammuGUI.button[24] = guiCreateButton(628, 104, 78, 48, "Buy Ammo\n($10)", false, ammuGUI.window[1]) -- Tec-9
	ammuGUI.button[25] = guiCreateButton(628, 168, 78, 48, "Buy Ammo\n($8)", false, ammuGUI.window[1]) -- MP5
	ammuGUI.button[26] = guiCreateButton(628, 232, 78, 48, "Buy Ammo\n($50)", false, ammuGUI.window[1]) -- Country Rifle
	ammuGUI.button[27] = guiCreateButton(628, 296, 78, 48, "Buy Ammo\n($100)", false, ammuGUI.window[1]) -- Sniper
	ammuGUI.button[28] = guiCreateButton(727, 168, 78, 48, "Buy MG-42 ammo\n($12)", false, ammuGUI.window[1])
	
	ammuGUI.button[29] = guiCreateButton(725, 36, 78, 48, "Buy Armour\n($1000)", false, ammuGUI.window[1])
	
	ammuGUI.button[30] = guiCreateButton(479, 380, 94, 54, "Buy a grenade\n($2,000)", false, ammuGUI.window[1])
	ammuGUI.button[31] = guiCreateButton(479, 466, 94, 54, "Buy a molotov\n($1,500)", false, ammuGUI.window[1])
	ammuGUI.button[32] = guiCreateButton(696, 380, 94, 54, "Buy a satchel charge\n($2,000)", false, ammuGUI.window[1])
	ammuGUI.button[33] = guiCreateButton(696, 466, 94, 54, "Buy tear gas\n($1,500)", false, ammuGUI.window[1])
	
	ammuGUI.button[34] = guiCreateButton(681, 538, 135, 26, "Close", false, ammuGUI.window[1])
	
	addEventHandler("onClientGUIClick", ammuGUI.window[1], handleClick)
	
	ammuGUI.staticimage[1] = guiCreateStaticImage(10, 30, 64, 64, ":UCDhud/icons/colt 45.png", false, ammuGUI.window[1])
	ammuGUI.staticimage[2] = guiCreateStaticImage(10, 94, 64, 64, ":UCDhud/icons/deagle.png", false, ammuGUI.window[1])
	ammuGUI.staticimage[3] = guiCreateStaticImage(10, 158, 64, 64, ":UCDhud/icons/silenced.png", false, ammuGUI.window[1])
	ammuGUI.staticimage[4] = guiCreateStaticImage(10, 222, 64, 64, ":UCDhud/icons/shotgun.png", false, ammuGUI.window[1])
	ammuGUI.staticimage[5] = guiCreateStaticImage(10, 286, 64, 64, ":UCDhud/icons/sawed-off.png", false, ammuGUI.window[1])
	ammuGUI.staticimage[6] = guiCreateStaticImage(10, 350, 64, 64, ":UCDhud/icons/combat shotgun.png", false, ammuGUI.window[1])
	ammuGUI.staticimage[7] = guiCreateStaticImage(10, 414, 64, 64, ":UCDhud/icons/ak-47.png", false, ammuGUI.window[1])
	ammuGUI.staticimage[8] = guiCreateStaticImage(10, 478, 64, 64, ":UCDhud/icons/m4.png", false, ammuGUI.window[1])
	ammuGUI.staticimage[9] = guiCreateStaticImage(384, 30, 64, 64, ":UCDhud/icons/uzi.png", false, ammuGUI.window[1])
	ammuGUI.staticimage[10] = guiCreateStaticImage(384, 94, 64, 64, ":UCDhud/icons/tec-9.png", false, ammuGUI.window[1])
	ammuGUI.staticimage[11] = guiCreateStaticImage(384, 158, 64, 64, ":UCDhud/icons/mp5.png", false, ammuGUI.window[1])
	ammuGUI.staticimage[12] = guiCreateStaticImage(384, 222, 64, 64, ":UCDhud/icons/rifle.png", false, ammuGUI.window[1])
	ammuGUI.staticimage[13] = guiCreateStaticImage(384, 286, 64, 64, ":UCDhud/icons/sniper.png", false, ammuGUI.window[1])
	ammuGUI.staticimage[14] = guiCreateStaticImage(384, 365, 85, 85, ":UCDhud/icons/grenade.png", false, ammuGUI.window[1])
	ammuGUI.staticimage[15] = guiCreateStaticImage(384, 450, 85, 85, ":UCDhud/icons/molotov.png", false, ammuGUI.window[1])
	ammuGUI.staticimage[16] = guiCreateStaticImage(600, 365, 85, 85, ":UCDhud/icons/satchel.png", false, ammuGUI.window[1])
	ammuGUI.staticimage[17] = guiCreateStaticImage(600, 450, 85, 85, ":UCDhud/icons/teargas.png", false, ammuGUI.window[1])
	
	ammoConfirm.window[1] = guiCreateWindow(1417, 441, 331, 108, "UCD | Ammunation - Ammo", false)
	exports.UCDutil:centerWindow(ammoConfirm.window[1])
	ammoConfirm.window[1].sizable = false
	ammoConfirm.window[1].alpha = 255
	ammoConfirm.window[1].visible = false
	ammoConfirm.edit[1] = guiCreateEdit(9, 24, 312, 33, "", false, ammoConfirm.window[1])
	ammoConfirm.edit[1].maxLength = 4
	ammoConfirm.button[1] = guiCreateButton(10, 65, 148, 34, "Buy", false, ammoConfirm.window[1])
	ammoConfirm.button[2] = guiCreateButton(173, 65, 148, 34, "Close", false, ammoConfirm.window[1])
	addEventHandler("onClientGUIClick", ammoConfirm.button[1], onClickAmmoBuy, false)
	addEventHandler("onClientGUIClick", ammoConfirm.button[2], toggleAmmoConfirmation, false)
	addEventHandler("onClientGUIChanged", ammoConfirm.edit[1], onAmmoConfirmationChanged, false)
end
addEventHandler("onClientResourceStart", resourceRoot, createGUI)

function toggleGUI(tbl)
	ammuGUI.window[1].visible = not ammuGUI.window[1].visible
	showCursor(ammuGUI.window[1].visible)
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
			exports.UCDdx:new(client, "You cannot afford to purchase this much ammo", 255, 0, 0)
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
			
			local wepName = getWeaponNameFromID(buttonToID[btnIndex])
			if (wepName == "Combat Shotgun") then
				wepName = "SPAS-12"
			end
			exports.UCDutil:createConfirmationWindow("UCDammunation.buyWeapon", buttonToID[btnIndex], true, "UCD | Ammunation - Confirmation", "Are you sure you want to buy a "..wepName.."?")
		else
			local a = buttonToID[btnIndex - 14]
			outputDebugString(tostring(source.text:gsub("\n", " ")))
			toggleAmmoConfirmation(a)
		end
	end
end
