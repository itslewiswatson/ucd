-------------------------------------------------------------------
--// PROJECT: Union of Clarity and Diversity
--// RESOURCE: UCDaccounts
--// DEVELOPER(S): Lewis Watson (Noki)
--// DATE: 13.12.2014
--// PURPOSE: A login interface.
--// FILE: \UCDaccounts\login\client.lua [client]
-------------------------------------------------------------------

-- XML is the one used to save credentials on a client's computer [We could possibly use a unique signature per person]
-- C2S is the one used to encrypt client-to-server transfer, so we aren't passing plain text (easily snooped)
local keys = {xml = [[7C6933A1239C7493F7F8A71A0EDA9553]], C2S = [[place_hash_here]]}
local sX, sY = guiGetScreenSize()
login = {edit = {}, button = {}, label = {}, checkbox = {}}
registration = {button = {}, window = {}, label = {}, edit = {}}
function centerWindow(center_window)
    local screenW, screenH = guiGetScreenSize()
    local windowW, windowH = guiGetSize(center_window, false)
    local x, y = (screenW - windowW) /2, (screenH - windowH) / 2
    guiSetPosition(center_window, x, y, false)
end

-- Actual login
addEventHandler("onClientResourceStart", resourceRoot, 
	function ()
		if (not isPlayerLoggedIn(localPlayer)) then
			triggerServerEvent("UCDaccounts.removeLoginText", resourceRoot)
			triggerServerEvent("UCDadmin.banCheck", resourceRoot)
		
			guiSetInputEnabled(true)
			--showCursor(true)
			
			login.button[1] = guiCreateButton((sX / 2) - (87 / 2) - 100, (sY / 2), 87, 34, "Login", false)
			login.button[1]:setFont("default-bold-small")
			login.button[1]:setProperty("NormalTextColour", "FFAAAAAA")
			login.button[1]:setEnabled(false)

			login.button[2] = guiCreateButton((sX / 2) - (87 / 2), (sY / 2), 87, 34, "Register", false)
			login.button[2]:setFont("default-bold-small")
			login.button[2]:setProperty("NormalTextColour", "FFAAAAAA")
			
			login.button[3] = guiCreateButton((sX / 2) + 100 - (87 / 2), (sY / 2), 87, 34, "Forgot password", false)
			login.button[3]:setFont("default-bold-small")
			login.button[3]:setProperty("NormalTextColour", "FFAAAAAA")
			
			login.label[1] = guiCreateLabel((sX / 2) - (87 / 2) + 8, (sY / 2) - 25, 108, 16, "Save credentials", false)
			
			login.checkbox[1] = guiCreateCheckBox((sX / 2) - (87 / 2) - 13, (sY / 2) - 25, 15, 18, "", false, false)
			
			-- 104.5
			-- len of button[1,2,3] = 287
			-- len of edits = 296
			-- (296-287)/2 = 4.5
			-- Because of the edits not being the same length as the total of buttons
			-- Make them same length or not???
			login.edit[1] = guiCreateEdit((sX / 2) - 104.5 - (87 / 2), (sY / 2) - 104, 296, 30, "", false)
			login.edit[2] = guiCreateEdit((sX / 2) - 104.5 - (87 / 2), (sY / 2) - 64, 296, 30, "", false)
			--login.edit[1] = guiCreateEdit((sX / 2) - 104.5 - (87 / 2), 280, 296, 30, "", false)
			--login.edit[2] = guiCreateEdit((sX / 2) - 104.5 - (87 / 2), 320, 296, 30, "", false)
			guiEditSetMasked(login.edit[2], true)    
	
			loginPanelElements = {login.button[1], login.button[2], login.button[3], login.edit[1], login.edit[2], login.label[1], login.label[2], login.checkbox[1], login.checkbox[2]}
			for k, v in pairs(loginPanelElements) do
				v.visible = false
			end
			
			
			addEventHandler("onClientGUIClick", login.button[1], onClickLogin, false)
			addEventHandler("onClientGUIClick", login.button[2], onClickRegister, false)
			addEventHandler("onClientGUIChanged", guiRoot, onLoginEditsChanged)
	-----------------------------------------------------
			registration.window[1] = guiCreateWindow(667, 651, 617, 455, "UCD | Registration", false)
			registration.window[1]:setSizable(false)
			registration.window[1]:setVisible(false)
			centerWindow(registration.window[1])

			registration.edit[1] = guiCreateEdit(10, 46, 328, 25, "", false, registration.window[1])
			registration.edit[1]:setMaxLength(16)
			
			registration.edit[2] = guiCreateEdit(10, 98, 328, 23, "", false, registration.window[1])
			
			registration.edit[3] = guiCreateEdit(10, 180, 328, 25, "", false, registration.window[1])
			guiEditSetMasked(registration.edit[3], true)
			registration.edit[1]:setMaxLength(32)
			registration.edit[4] = guiCreateEdit(10, 232, 328, 25, "", false, registration.window[1])
			guiEditSetMasked(registration.edit[4], true)
			registration.edit[1]:setMaxLength(32)
			
			registration.label[1] = guiCreateLabel(10, 29, 328, 17, "Account name - [Max: 16; Min 3]", false, registration.window[1])
			registration.label[2] = guiCreateLabel(10, 81, 328, 17, "Email - we will need this for account recovery", false, registration.window[1])
			registration.label[3] = guiCreateLabel(10, 163, 328, 17, "Password - [Max 32; Min 6]", false, registration.window[1])
			registration.label[4] = guiCreateLabel(10, 215, 328, 17, "Repeat password - so we know you wrote the right one", false, registration.window[1])
			
			registration.button[1] = guiCreateButton(102, 400, 179, 38, "Register", false, registration.window[1])
			guiSetProperty(registration.button[1], "NormalTextColour", "FFAAAAAA")
			registration.button[1]:setEnabled(false)
			registration.button[2] = guiCreateButton(342, 400, 179, 38, "Cancel", false, registration.window[1])
			guiSetProperty(registration.button[2], "NormalTextColour", "FFAAAAAA")
			
			registration.label[5] = guiCreateLabel(348, 98, 242, 23, "Enter your email address", false, registration.window[1])
			registration.label[5]:setColor(255, 255, 0)
			guiLabelSetHorizontalAlign(registration.label[5], "center", false)
			guiLabelSetVerticalAlign(registration.label[5], "center")
			
			registration.label[6] = guiCreateLabel(348, 48, 242, 23, "Enter your desired account name", false, registration.window[1])
			registration.label[6]:setColor(255, 255, 0)
			guiLabelSetHorizontalAlign(registration.label[6], "center", false)
			guiLabelSetVerticalAlign(registration.label[6], "center")
			
			registration.label[7] = guiCreateLabel(0, 127, 617, 23, "___________________________________________________________________________________________", false, registration.window[1])
			guiLabelSetHorizontalAlign(registration.label[7], "center", false)
			
			registration.label[8] = guiCreateLabel(348, 182, 242, 23, "Enter your desired password", false, registration.window[1])
			guiLabelSetHorizontalAlign(registration.label[8], "center", false)
			guiLabelSetVerticalAlign(registration.label[8], "center")
			registration.label[8]:setColor(255, 255, 0)
			registration.label[9] = guiCreateLabel(348, 234, 242, 23, "Re-enter your password", false, registration.window[1])
			guiLabelSetHorizontalAlign(registration.label[9], "center", false)
			guiLabelSetVerticalAlign(registration.label[9], "center")
			registration.label[9]:setColor(255, 255, 0)
			
			registration.label[10] = guiCreateLabel(0, 263, 617, 23, "___________________________________________________________________________________________", false, registration.window[1])
			guiLabelSetHorizontalAlign(registration.label[10], "center", false)   
			registration.label[11] = guiCreateLabel(10, 290, 597, 79, "- Account names can only contain A -Z, a - z or 0 - 9 and are case sensitive.\n- Passwords can contain symbols and even characters from languages other than English.\n- Passwords are hashed using bcrypt, which is inherently more secure than what other servers use.\n- bcrypt courtesy of Orange, qaisjp, Jusonex, ixjf & sbx320 (https://github.com/pzduniak/ml_bcrypt).\n- You are able to change your password or email at any time. Your account name cannot be changed.", false, registration.window[1])
			registration.label[12] = guiCreateLabel(10, 369, 617, 23, "___________________________________________________________________________________________", false, registration.window[1])
			guiLabelSetHorizontalAlign(registration.label[12], "center", false)   
			
			addEventHandler("onClientGUIClick", registration.button[1], onClickRegisterConfirm)
			addEventHandler("onClientGUIClick", registration.button[2], onClickCancel, false)
			addEventHandler("onClientGUIChanged", registration.window[1], onRegistrationEditsChanged)
			
			if (File.exists("@credentials.xml")) then
				local f = XML.load("@credentials.xml")
				login.edit[1]:setText(tostring(f:findChild("usr", 0):getValue()))
				login.edit[2]:setText(tostring(teaDecode(f:findChild("passwd", 0):getValue(), keys.xml)))
				f:unload()
				
				login.checkbox[1]:setSelected(true)
			end
		end
	end
)

function isLoginWindowOpen()
	if (not login.button[1]:getVisible()) or (not isElement(login.button[1])) then
		return false
	end
	return true
end

function onLoginEditsChanged()
	if (source == login.edit[1] or source == login.edit[2]) then
		local usr, passwd = login.edit[1]:getText(), login.edit[2]:getText()
		if (usr:len() >= 3 and not usr:match("%W") and passwd:len() >= 6) then
			login.button[1]:setEnabled(true)
		else
			login.button[1]:setEnabled(false)
		end
	end
end

function onRegistrationEditsChanged()
	-- Account name
	if (source == registration.edit[1]) then
		local usr = source:getText()
		if (not usr or usr == "") then
			registration.label[6]:setText("Enter your desired account name")
			registration.label[6]:setColor(255, 255, 0)
		else
			if (usr:match("%W")) then
				registration.label[6]:setText("Account name can only contain A- Z, 0 - 9")
				registration.label[6]:setColor(255, 0, 0)		
			else 
				if (usr:len() < 3) then
					registration.label[6]:setText("Account name is too short")
					registration.label[6]:setColor(255, 0, 0)
				else
					-- Syntax is correct, just need to check if it's an actual account
					registration.label[6]:setText("Checking")
					registration.label[6]:setColor(255, 255, 0)
					triggerServerEvent("UCDaccounts.login.isAccount", localPlayer, usr)
				end
			end
		end
	-- Emails
	elseif (source == registration.edit[2]) then
		local email = source:getText():lower()
		if (email == "" or not email) then
			registration.label[5]:setText("Enter your email address")
			registration.label[5]:setColor(255, 255, 0)
		elseif (not email:find("@")) or (email:find(" ")) or (not email:find(".")) then
			registration.label[5]:setText("Invalid email address")
			registration.label[5]:setColor(255, 0, 0)
		else
			local domain = gettok(email, 2, "@")
			if (not domain) then
				registration.label[5]:setText("Invalid email address")
				registration.label[5]:setColor(255, 0, 0)
			elseif (domain:match("%.")) then
				local usrname = gettok(email, 1, "@")
				local sitename = gettok(domain, 1, ".")
				local extension = gettok(domain, 2, ".")
				if (not extension or extension:len() == 0 or extension:match("%W") or sitename:match("%W") or usrname:match("%W")) then
					if usrname:match("%W") ~= "." and usrname:match("%W") ~= "_" then
						registration.label[5]:setText("Invalid email address")
						registration.label[5]:setColor(255, 0, 0)
					else
						registration.label[5]:setText("Valid email address")
						registration.label[5]:setColor(0, 255, 0)
					end
				else
					if (extension:find("%_") or domain:find("%_") or sitename:find("%_")) then
						registration.label[5]:setText("Invalid email address")
						registration.label[5]:setColor(255, 0, 0)
					else	
						if (usrname:find("%_")) then
							registration.label[5]:setText("Valid email address")
							registration.label[5]:setColor(0, 255, 0)
						else
							registration.label[5]:setText("Valid email address")
							registration.label[5]:setColor(0, 255, 0)
						end
					end
				end
			end
		end
	-- Password
	elseif (source == registration.edit[3]) then
		local pass = registration.edit[3]:getText()
		if (not pass or pass == "") then
			registration.label[8]:setText("Enter your desired password")
			registration.label[8]:setColor(255, 255, 0)
		else
			if (pass:len() < 6) then
				registration.label[8]:setText("Password is too short")
				registration.label[8]:setColor(255, 0, 0)
			else
				registration.label[8]:setText("Valid password")
				registration.label[8]:setColor(0, 255, 0)
			end
		end
	-- Password confirmation
	elseif (source == registration.edit[4]) then
		local conf = registration.edit[4]:getText()
		if (not conf or conf == "") then
			registration.label[9]:setText("Re-enter your password")
			registration.label[9]:setColor(255, 255, 0)
		else
			if (conf ~= registration.edit[3]:getText()) then
				registration.label[9]:setText("Passwords do not match")
				registration.label[9]:setColor(255, 0, 0)
			else
				registration.label[9]:setText("Passwords match")
				registration.label[9]:setColor(0, 255, 0)
			end
		end
	end
	
	-- This handles the registration button in the registration window
	if (registration.window[1]:getVisible() == true) then
		local ar, ag, ab = registration.label[5]:getColor()
		local br, bg, bb = registration.label[6]:getColor()
		local cr, cg, cb = registration.label[8]:getColor()
		local dr, dg, db = registration.label[9]:getColor()
		if (ar == 0 and ag == 255 and ab == 0) and (br == 0 and bg == 255 and bb == 0) and (cr == 0 and cg == 255 and cb == 0) and (dr == 0 and dg == 255 and db == 0) then
			registration.button[1]:setEnabled(true)
		else
			registration.button[1]:setEnabled(false)
		end
	end
	Timer(
		function ()
			if (registration.window[1]:getVisible() == true) then
				local ar, ag, ab = registration.label[5]:getColor()
				local br, bg, bb = registration.label[6]:getColor()
				local cr, cg, cb = registration.label[8]:getColor()
				local dr, dg, db = registration.label[9]:getColor()
				if (ar == 0 and ag == 255 and ab == 0) and (br == 0 and bg == 255 and bb == 0) and (cr == 0 and cg == 255 and cb == 0) and (dr == 0 and dg == 255 and db == 0) then
					registration.button[1]:setEnabled(true)
				else
					registration.button[1]:setEnabled(false)
				end
			end
		end, (getPlayerPing(localPlayer) + 50) or 400, 1
	)
end

function onClickLogin(button, state)
	if (source == login.button[1]) then
		if (button == "left" and state == "up") then
			if (isTransferBoxActive()) then
				exports.UCDdx:new("You are still downloading. You cannot login yet.", 255, 255, 255)
			else
				local usr = guiGetText(login.edit[1])
				local passwd = guiGetText(login.edit[2])
				
				if (usr == "") and (passwd == "") then
					exports.UCDdx:new("Please enter your account credentials", 255, 255, 255)
				else
					if (usr == "") and (passwd ~= "") then
						exports.UCDdx:new("Please enter your account name", 255, 255, 255)
					elseif (usr ~= "") and (passwd == "") then
						exports.UCDdx:new("Please enter your password", 255, 255, 255)
					elseif (user ~= "") and (passwd ~= "") then
						triggerServerEvent("UCDaccounts.login.logIn", localPlayer, usr, passwd) -- need to 	t this [do not pass plain text]
					end
				end
			end
		end
	end
end

-- Register player
function onClickRegisterConfirm(button, state)
	if (button == "left" and state == "up") then
		if (source == registration.button[1]) then
			if (registration.button[1]:getVisible() == true) then
				local usr = registration.edit[1]:getText()
				local email = registration.edit[2]:getText()
				local passwd = registration.edit[3]:getText()
				local conf = registration.edit[4]:getText()			
				if (passwd ~= conf) then
					exports.UCDdx:new("Your passwords do not match", 255, 255, 255)
					return
				end
				triggerEvent("UCDaccounts.login.toggleRegisterConfirm", localPlayer, false)
				triggerServerEvent("UCDaccounts.login.register", localPlayer, usr, email, passwd, conf)
			end
		end
	end
end

function toggleRegisterConfirm(state)
	if (source) then
		login.button[2].enabled = state
	end
end
addEvent("UCDaccounts.login.toggleRegisterConfirm", true)
addEventHandler("UCDaccounts.login.toggleRegisterConfirm", root, toggleRegisterConfirm)

-- Open registration window
function onClickRegister(button, state)
	if (button == "left" and state == "up") then
		if (source == login.button[2]) then
			guiSetVisible(registration.window[1], true)
			exports.UCDutil:centerWindow(registration.window[1])
			guiBringToFront(registration.window[1])
			guiSetInputEnabled(true)
			
			-- Hide other login elements
			for _, v in pairs(loginPanelElements) do
				v:setVisible(false)
			end
			
			if (not isCursorShowing()) then showCursor(true) end
		end
	end
end

-- Cancel registration
function onClickCancel(button, state)
	if (button == "left" and state == "up") then
		if (source == registration.button[2]) then
			guiSetVisible(registration.window[1], false)
			guiSetInputEnabled(true)
			
			-- Hide other login elements
			for _, v in pairs(loginPanelElements) do
				v:setVisible(true)
			end
			
			if (not isCursorShowing()) then showCursor(true) end
		end
	end
end

-- Show login window
function showLoginInterface()
	if (registration.window[1]:getVisible() == true) then
		registration.window[1]:setVisible(false)
	end
	for _, v in pairs(loginPanelElements) do
		v.visible = true
	end
	showCursor(true)
end
addEvent("UCDaccounts.login.showLoginInterface", true)
addEventHandler("UCDaccounts.login.showLoginInterface", root, showLoginInterface)

-- Hide login window
function hideLoginInterface()
	guiSetInputEnabled(false)
	for _, v in pairs(loginPanelElements) do
		v:setVisible(false)
	end
	if (registration.window[1]:getVisible() == true) then
		registration.window[1]:setVisible(false)
	end
	--if (isCursorShowing()) then showCursor(false) end
	--removeEventHandler("onClientRender", root, blackBars)
	showCursor(false)
end
addEvent("UCDaccounts.login.hideLoginInterface", true)
addEventHandler("UCDaccounts.login.hideLoginInterface", root, hideLoginInterface)

-- Hide register window
function hideRegistrationInterface()
	guiSetInputEnabled(true)
	if (registration.window[1]:getVisible() == true) then
		registration.window[1]:setVisible(false)
	end
	if (not isCursorShowing()) then showCursor(true) end
end
addEvent("UCDaccounts.login.hideRegistrationInterface", true)
addEventHandler("UCDaccounts.login.hideRegistrationInterface", root, hideRegistrationInterface)

-- We won't need to keep it in memory as the player will only use it once
function destroyInterface()
	if (isCursorShowing()) then showCursor(false) end
	if (isElement(registration.window[1])) then
		registration.window[1]:destroy()
		registration = nil
	end
	if (isElement(login.button[1])) then
		for _, v in pairs(loginPanelElements) do
			v:destroy()
		end
		login = nil
		loginPanelElements = nil
	end
end
addEvent("UCDaccounts.login.destroyInterface", true)
addEventHandler("UCDaccounts.login.destroyInterface", root, destroyInterface)

-- Callback for checking if an account exists
function updateValidationLabel(value, bad)
	registration.label[6]:setText(value)
	if (bad == true) then
		registration.label[6]:setColor(255, 0, 0)
	else
		registration.label[6]:setColor(0, 255, 0)
	end
	--[[
	if (value == true) then
		registration.label[6]:setText("Available account name")
		registration.label[6]:setColor(0, 255, 0)
	elseif (value == false) then
		registration.label[6]:setText("This account name is taken")
		registration.label[6]:setColor(255, 0, 0)
	else
		registration.label[6]:setText("An error has occured")
		registration.label[6]:setColor(255, 0, 0)
	end
	--]]
end
addEvent("UCDaccounts.login.updateValidationLabel", true)
addEventHandler("UCDaccounts.login.updateValidationLabel", root, updateValidationLabel)

function xmllol()
	if guiCheckBoxGetSelected(login.checkbox[1]) then
		local usr = login.edit[1].text
		local passwd = teaEncode(login.edit[2].text, keys.xml)
		if (not File.exists("@credentials.xml")) then
			local f = XML("@credentials.xml", "login")
			f:createChild("usr"):setValue(usr)
			f:createChild("passwd"):setValue(passwd)
			f:saveFile()
			f:unload()
		else
			local f = XML.load("@credentials.xml")
			f:findChild("usr", 0):setValue(usr)
			f:findChild("passwd", 0):setValue(passwd)
			f:saveFile()
			f:unload()
		end
	else
		if (File.exists("@credentials.xml")) then
			File.delete("@credentials.xml")
		end
	end
end
addEvent("UCDaccounts.login.saveAccountCredentials", true)
addEventHandler("UCDaccounts.login.saveAccountCredentials", root, xmllol)
