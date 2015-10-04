-------------------------------------------------------------------
--// PROJECT: Union of Clarity and Diversity
--// RESOURCE: UCDlogin
--// DEVELOPER(S): Lewis Watson (Noki)
--// DATE: 13.12.2014
--// PURPOSE: A login panel.
--// FILE: \UCDlogin\c.lua [client]
-------------------------------------------------------------------

login = {edit = {}, button = {}, label = {}, checkbox = {}}
registration = {button = {}, window = {}, label = {}, edit = {}}

-- Actual login
addEventHandler("onClientResourceStart", resourceRoot, 
	function ()
		--if (not exports.UCDutil:isPlayerLoggedIn(localPlayer)) then		
			sX, sY = guiGetScreenSize()
			nX, nY = 1366, 768
			
			guiSetInputEnabled(true)
			showCursor(true)
			
			login.button[1] = guiCreateButton(680, 389, 87, 34, "Login", false)
			guiSetFont(login.button[1], "default-bold-small")
			guiSetProperty(login.button[1], "NormalTextColour", "FFAAAAAA")
			login.button[1]:setEnabled(false)

			login.button[2] = guiCreateButton(785, 389, 87, 34, "Register", false)
			guiSetFont(login.button[2], "default-bold-small")
			guiSetProperty(login.button[2], "NormalTextColour", "FFAAAAAA")

			login.button[3] = guiCreateButton(889, 389, 87, 34, "Forgot password", false)
			guiSetFont(login.button[3], "default-bold-small")
			guiSetProperty(login.button[3], "NormalTextColour", "FFAAAAAA")

			login.label[1] = guiCreateLabel(712, 361, 108, 16, "Save account name", false)
			login.label[2] = guiCreateLabel(855, 361, 108, 16, "Save password", false)

			login.checkbox[1] = guiCreateCheckBox(690, 361, 15, 18, "", false, false)
			login.checkbox[2] = guiCreateCheckBox(830, 361, 15, 18, "", false, false)

			login.edit[1] = guiCreateEdit(680, 280, 296, 30, "", false)
			login.edit[2] = guiCreateEdit(680, 320, 296, 30, "", false)
			guiEditSetMasked(login.edit[2], true)    
	
			loginPanelElements = {login.button[1], login.button[2], login.button[3], login.edit[1], login.edit[2], login.label[1], login.label[2], login.checkbox[1], login.checkbox[2]}
			
			addEventHandler("onClientGUIClick", login.button[1], onClickLogin, false)
			addEventHandler("onClientGUIClick", login.button[2], onClickRegister, false)
			addEventHandler("onClientGUIChanged", guiRoot, onLoginEditsChanged)
			--addEventHandler("onClientRender", root, blackBars)
	-----------------------------------------------------
			
			registration.window[1] = guiCreateWindow(667, 651, 617, 455, "UCD | Registration [Beta]", false)
			registration.window[1]:setSizable(false)
			registration.window[1]:setVisible(false)
			exports.UCDutil:centerWindow(registration.window[1])

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
			registration.label[11] = guiCreateLabel(10, 290, 597, 79, "- Account names can only contain A -Z, a - z or 0 - 9 and are case sensitive.\n- Passwords can contain symbols and even characters from languages other than English.\n- Passwords are hashed using bcrypt, which is inherently more secure than what other servers use.\n- bcrypt courtesy of pzduniak, qaisjp, Jusonex, ixjf & sbx320 (https://github.com/pzduniak/ml_bcrypt).\n- You are able to change your password or email at any time. Your account name cannot be changed.", false, registration.window[1])
			registration.label[12] = guiCreateLabel(10, 369, 617, 23, "___________________________________________________________________________________________", false, registration.window[1])
			guiLabelSetHorizontalAlign(registration.label[12], "center", false)   
			
			addEventHandler("onClientGUIClick", registration.button[1], onClickRegisterConfirm)
			addEventHandler("onClientGUIClick", registration.button[2], onClickCancel, false)
			addEventHandler("onClientGUIChanged", registration.window[1], onRegistrationEditsChanged)

			--[[
			registration.window[1] = guiCreateWindow(399, 255, 434, 290, "UCD | Registration Panel", false)
			registration.window[1]:setSizable(false)
			registration.window[1]:setMovable(false)
			registration.window[1]:setVisible(false)
			exports.UCDutil:centerWindow(registration.window[1])
			
			editRegistrationUsername = guiCreateEdit(98, 66, 242, 25, "", false, registration.window[1])
			editRegistrationPassword = guiCreateEdit(98, 128, 242, 25, "", false, registration.window[1])
			guiEditSetMasked(editRegistrationPassword, true)
			editRegistrationRepeatPassword = guiCreateEdit(98, 190, 242, 25, "", false, registration.window[1])
			guiEditSetMasked(editRegistrationRepeatPassword, true)
			lblRUsername = guiCreateLabel(98, 39, 242, 17, "Username:", false, registration.window[1])
			lblRPassword = guiCreateLabel(98, 101, 242, 17, "Password:", false, registration.window[1])
			lblRepeatPassword = guiCreateLabel(98, 163, 242, 17, "Repeat password:", false, registration.window[1])
			btnCancel = guiCreateButton(231, 225, 179, 38, "Cancel", false, registration.window[1])
			btnConfirmRegistration = guiCreateButton(31, 225, 179, 38, "Confirm registration", false, registration.window[1])
			
			addEventHandler("onClientGUIClick", btnConfirmRegistration, onClickRegisterConfirm)
			addEventHandler("onClientGUIClick", btnCancel, onClickCancel)
			--]]
		--end
	end
)

function isLoginWindowOpen()
	if (not login.button[1]:getVisible()) or (not isElement(login.button[1])) then
		return false
	end
	return true
end

local sX, sY = guiGetScreenSize()
local nX, nY = 1366, 768
function blackBars()
	dxDrawRectangle(0, 0, 1 * sX, (111 / nY) * sY, tocolor(0, 0, 0, 255), false)
	dxDrawRectangle(0, (657 / nY) * sY, (1366 / nX) * sX, (111 / nY) * sY, tocolor(0, 0, 0, 255), false)
end

function onLoginEditsChanged()
	if (source == login.edit[1] or source == login.edit[2]) then
		local usr, passwd = login.edit[1]:getText(), login.edit[2]:getText()
		if (usr:len() >= 3 and not usr:match("%W") and passwd:len() >= 6) then
			login.button[1]:setEnabled(true)
		else
			login.button[1]:setEnabled(false)
		end
	else
		outputDebugString("no parent")
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
					triggerServerEvent("UCDlogin.isAccount", localPlayer, usr)
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
					if usrname:match("%W") ~= "." then
						registration.label[5]:setText("Invalid email address")
						registration.label[5]:setColor(255, 0, 0)
					else
						registration.label[5]:setText("Valid email address")
						registration.label[5]:setColor(0, 255, 0)
					end
				else
					registration.label[5]:setText("Valid email address")
					registration.label[5]:setColor(0, 255, 0)
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
						triggerServerEvent("UCDlogin.logIn", localPlayer, usr, passwd) -- need to encrypt this [do not pass plain text]
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
				triggerServerEvent("UCDlogin.register", localPlayer, usr, email, passwd, conf)
				
			end
		end
	end
end

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
		v:setVisible(true)
	end
	if (not isCursorShowing()) then showCursor(true) end
end
addEvent("UCDlogin.showLoginInterface", true)
addEventHandler("UCDlogin.showLoginInterface", root, showLoginInterface)

-- Hide login window
function hideLoginInterface()
	guiSetInputEnabled(false)
	for _, v in pairs(loginPanelElements) do
		v:setVisible(false)
	end
	if (registration.window[1]:getVisible() == true) then
		registration.window[1]:setVisible(false)
	end
	if (isCursorShowing()) then showCursor(false) end
	--removeEventHandler("onClientRender", root, blackBars)
end
addEvent("UCDlogin.hideLoginInterface", true)
addEventHandler("UCDlogin.hideLoginInterface", root, hideLoginInterface)

-- Hide register window
function hideRegistrationInterface()
	guiSetInputEnabled(true)
	if (registration.window[1]:getVisible() == true) then
		registration.window[1]:setVisible(false)
	end
	if (not isCursorShowing()) then showCursor(true) end
end
addEvent("UCDlogin.hideRegistrationInterface", true)
addEventHandler("UCDlogin.hideRegistrationInterface", root, hideRegistrationInterface)

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
addEvent("UCDlogin.destroyInterface", true)
addEventHandler("UCDlogin.destroyInterface", root, destroyInterface)

-- Callback for checking if an account exists
function updateValidationLabel(value)
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
end
addEvent("UCDlogin.updateValidationLabel", true)
addEventHandler("UCDlogin.updateValidationLabel", root, updateValidationLabel)

-- new proposed ui
--[[
login = {
    button = {},
    edit = {},
    checkbox = {},
    label = {}
}
addEventHandler("onClientResourceStart", resourceRoot,
    function()
        login.button[1] = guiCreateButton(680, 389, 87, 34, "Login", false)
        guiSetFont(login.button[1], "default-bold-small")
        guiSetProperty(login.button[1], "NormalTextColour", "FFAAAAAA")


        login.button[2] = guiCreateButton(785, 389, 87, 34, "Register", false)
        guiSetFont(login.button[2], "default-bold-small")
        guiSetProperty(login.button[2], "NormalTextColour", "FFAAAAAA")


        login.button[3] = guiCreateButton(889, 389, 87, 34, "Forgot password", false)
        guiSetFont(login.button[3], "default-bold-small")
        guiSetProperty(login.button[3], "NormalTextColour", "FFAAAAAA")


        login.label[1] = guiCreateLabel(712, 361, 108, 16, "Save account name", false)


        login.label[2] = guiCreateLabel(855, 361, 108, 16, "Save password", false)


        login.checkbox[1] = guiCreateCheckBox(690, 361, 15, 18, "", false, false)


        login.checkbox[2] = guiCreateCheckBox(830, 361, 15, 18, "", false, false)


        login.edit[1] = guiCreateEdit(680, 280, 296, 30, "thisis32characterslongithinkidkmaybe", false)


        login.edit[2] = guiCreateEdit(680, 320, 296, 30, "thisis32characterslongithinkidkmaybe", false)
        guiEditSetMasked(login.edit[2], true)    
    end
)

-- old 
		login.button[1] = guiCreateButton((449 / nX) * sX, (368 / nY) * sY, (132 / nX) * sX, (60 / nY) * sY, "Login", false)
			login.button[1]:setFont("default-bold-small")
			login.button[1]:setProperty("NormalTextColour", "FFAAAAAA")
	
			login.button[2] = guiCreateButton((635 / nX) * sX, (368 / nY) * sY, (132 / nX) * sX, (60 / nY) * sY, "Register", false)
			login.button[2]:setFont("default-bold-small")
			login.button[2]:setProperty("NormalTextColour", "FFAAAAAA")

			login.button[3] = guiCreateButton((827 / nX) * sX, (368 / nY) * sY, (132 / nX) * sX, (60 / nY) * sY, "Forgot password", false)
			login.button[3]:setFont("default-bold-small")
			login.button[3]:setProperty("NormalTextColour", "FFAAAAAA")
	
			-- Account name
			login.edit[1] = guiCreateEdit((449 / nX) * sX, (275 / nY) * sY, (231 / nX) * sX, (42 / nY) * sY, "", false)
			login.edit[1]:setMaxLength(32)
	
			-- Password
			login.edit[2] = guiCreateEdit((728 / nX) * sX, (275 / nY) * sY, (231 / nX) * sX, (42 / nY) * sY, "", false)
			login.edit[2]:setMasked(true)    
			login.edit[2]:setMaxLength(32)
	
			loginPanelElements = {login.button[1], login.button[2], login.button[3], login.edit[1], login.edit[2]}
--]]
