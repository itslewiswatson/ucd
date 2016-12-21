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
local nX, nY = 1920, 1080
local login = {edit = {}, button = {}, label = {}, checkbox = {}}
local registration = {button = {}, window = {}, label = {}, edit = {}}
local scale = {
	[1] = 2,
	[2] = 2,
	[3] = 2,
	[4] = 2,
	[5] = 2,
}
local b2s = {}
local buttons = {
	{(567 / nX) * sX, (433 / nY) * sY, dxGetTextWidth("Login", 2, "default-bold"), (30 / nY) * sY},
	{(567 / nX) * sX, (483 / nY) * sY, dxGetTextWidth("Register", 2, "default-bold"), (30 / nY) * sY},
	{(567 / nX) * sX, (533 / nY) * sY, dxGetTextWidth("About UCD", 2, "default-bold"), (30 / nY) * sY},
	{(567 / nX) * sX, (583 / nY) * sY, dxGetTextWidth("Admins Online", 2, "default-bold"), (30 / nY) * sY},
	{(567 / nX) * sX, (633 / nY) * sY, dxGetTextWidth("Disconnect", 2, "default-bold"), (30 / nY) * sY},
}
local scalar = 5
if (dxGetTextWidth("Union of Clarity and Diversity", 5, "default-bold") > sX) then
	scalar = 3
end

-- Interpolation shit
local start = false
local index
local inout

function centerWindow(center_window)
    local windowW, windowH = guiGetSize(center_window, false)
    local x, y = (sX - windowW) /2, (sY - windowH) / 2
    guiSetPosition(center_window, x, y, false)
end

function trunc()
	if (index and start) then
		for k, v in pairs(scale) do
			if (k == index) then
				if (inout == "in") then
					local now = getTickCount()
					local endTime = start + 500
					local elapsed = now - start
					local duration = endTime - start
					local prog = elapsed / duration
					scale[index] = interpolateBetween(Vector3(scale[index], 0, 0), Vector3(3, 0, 0), prog, "Linear")
				else
					local now = getTickCount()
					local endTime = start + 250
					local elapsed = now - start
					local duration = endTime - start
					local prog = elapsed / duration
					scale[index] = interpolateBetween(Vector3(scale[index], 0, 0), Vector3(2, 0, 0), prog, "Linear")
					
					if (prog >= 1) then
						index = nil
						start = false
					end
				end
			else
				if (not start) then
					return
				end
				local now = getTickCount()
				local endTime = start + 250
				local elapsed = now - start
				local duration = endTime - start
				local prog = elapsed / duration
				scale[k] = interpolateBetween(Vector3(scale[k], 0, 0), Vector3(2, 0, 0), prog, "Linear")
			end
		end
	end
end
addEventHandler("onClientRender", root, trunc)

-- Button animations
addEventHandler("onClientMouseEnter", guiRoot,
	function ()
		if (b2s[source]) then
			inout = "in"
			index = b2s[source]
			start = getTickCount()
		end
	end
)

addEventHandler("onClientMouseLeave", guiRoot,
	function (_, _, o)
		if (b2s[source]) then
			inout = "out"
			index = b2s[source]
			start = getTickCount()
		end
	end
)

function drawElements()
	dxDrawRectangle(0, 0, sX, sY, tocolor(0, 0, 0, 75), false, false, false, false) 
	if (login.button.visible) then
		dxDrawText("Remember my credentials", 	(1086 / nX) * sX, (595 / nY) * sY, (1329 / nX) * sX, (612 / nY) * sY, tocolor(255, 255, 255, 255), 1, "default-bold", "left", "center", false, false, false, false, true)
		dxDrawText("Account Name", 				(1047 / nX) * sX, (433 / nY) * sY, (1329 / nX) * sX, (463 / nY) * sY, tocolor(255, 255, 255, 255), 2, "default-bold", "left", "center", false, false, false, false, true)
		dxDrawText("Password", 					(1047 / nX) * sX, (513 / nY) * sY, (1329 / nX) * sX, (543 / nY) * sY, tocolor(255, 255, 255, 255), 2, "default-bold", "left", "center", false, false, false, false, true)
	end
	if (registration.button.visible) then
		dxDrawText("Account Name", (1047 / nX) * sX, 		(323 / nY) * sY, (1329 / nX) * sX, (353 / nY) * sY, tocolor(255, 255, 255, 255), 2, "default-bold", "left", "center", false, false, false, false, true)
		dxDrawText("Email", (1047 / nX) * sX, 				(413 / nY) * sY, (1329 / nX) * sX, (443 / nY) * sY, tocolor(255, 255, 255, 255), 2, "default-bold", "left", "center", false, false, false, false, true)
		dxDrawText("Password", (1047 / nX) * sX, 			(493 / nY) * sY, (1329 / nX) * sX, (523 / nY) * sY, tocolor(255, 255, 255, 255), 2, "default-bold", "left", "center", false, false, false, false, true)
		dxDrawText("Confirm Password", (1047 / nX) * sX, 	(573 / nY) * sY, (1329 / nX) * sX, (603 / nY) * sY, tocolor(255, 255, 255, 255), 2, "default-bold", "left", "center", false, false, false, false, true)
	end	
	
	dxDrawText("Login", (567 / nX) * sX, (433 / nY) * sY, (725 / nX) * sX, (463 / nY) * sY, tocolor(255, 255, 255, 255), scale[1], "default-bold", "left", "center", false, false, false, false, true)
	dxDrawText("Register", (567 / nX) * sX, (483 / nY) * sY, (725 / nX) * sX, (513 / nY) * sY, tocolor(255, 255, 255, 255), scale[2], "default-bold", "left", "center", false, false, false, false, true)
	dxDrawText("About UCD", (567 / nX) * sX, (533 / nY) * sY, (725 / nX) * sX, (563 / nY) * sY, tocolor(255, 255, 255, 255), scale[3], "default-bold", "left", "center", false, false, false, false, true)
	dxDrawText("Admins Online", (567 / nX) * sX, (583 / nY) * sY, (725 / nX) * sX, (613 / nY) * sY, tocolor(255, 255, 255, 255), scale[4], "default-bold", "left", "center", false, false, false, false, true)
	dxDrawText("Disconnect", (567 / nX) * sX, (633 / nY) * sY, (725 / nX) * sX, (663 / nY) * sY, tocolor(255, 255, 255, 255), scale[5], "default-bold", "left", "center", false, false, false, false, true)
	
	dxDrawText("Union of Clarity and Diversity", 0, (150 / nY) * sY, sX, (244 / nY) * sY, tocolor(255, 255, 255, 255), scalar or 5, "default-bold", "center", "center", false, false, false, false, true)
end

function onClientClick(button, state, aX, aY)
	-- Register button
	local rX, rY = (567 / nX) * sX, (483 / nY) * sY
	local rW, rH = rX + dxGetTextWidth("Register", 2, "default-bold"), rY + (30 / nY) * sY
	
	-- Login button
	local lX, lY = (567 / nX) * sX, (433 / nY) * sY
	local lW, lH = lX + dxGetTextWidth("Login", 2, "default-bold"), lY + (30 / nY) * sY
	
	if (button == "left" and state == "up") then
		-- Register button 
		if (aX >= rX and aX <= rW and aY >= rY and aY <= rH) then
			onClickRegister(button, state, true)
		end
		-- Login button
		if (aX >= lX and aX <= lW and aY >= lY and aY <= lH) then
			if (RPE) then
				for k, v in pairs(RPE) do
					v.visible = false
				end
			end
			if (LPE) then
				for k, v in pairs(LPE) do
					v.visible = true
				end
			end
		end
	end
end
addEventHandler("onClientClick", root, onClientClick)

function displayUpdates(data)
	if (data == "ERROR") then
		data = "Could not fetch updates - try again later"
	else
		data = tostring(data):gsub("\n\n\n", "\n\n")
	end
	login.memo.text = data
end

-- Actual login 
addEventHandler("onClientResourceStart", resourceRoot,
	function ()
		if (not isPlayerLoggedIn(localPlayer)) then
			triggerServerEvent("UCDaccounts.removeLoginText", resourceRoot)
			triggerServerEvent("UCDadmin.banCheck", resourceRoot)
		
			guiSetInputEnabled(true)
			
			for k, v in ipairs(buttons) do
				local b = GuiButton(v[1], v[2], v[3], v[4], "", false)
				b2s[b] = k
				b.alpha = 0 
			end
			
			login.button 					= GuiButton((1047 / nX) * sX, (622 / nY) * sY, (272 / nX) * sX, (42 / nY) * sY, "Login", false)
			login.checkbox 					= GuiCheckBox((1061 / nX) * sX, (595 / nY) * sY, (15 / nX) * sX, (17 / nY) * sY, "", false, false)	
			login.edit["usr"] 				= GuiEdit((1037 / nX) * sX, (467 / nY) * sY, (292 / nX) * sX, (40 / nY) * sY, "", false)
			login.edit["passwd"] 			= GuiEdit((1037 / nX) * sX, (549 / nY) * sY, (292 / nX) * sX, (40 / nY) * sY, "", false)
			login.memo 						= GuiMemo((577 / nX) * sX, (719 / nY) * sY, (740 / nX) * sX, (316 / nY) * sY, "", false)
			login.memo.text 				= "Fetching updates..."
			login.memo.readOnly 			= true
			login.edit["passwd"].masked 	= true
			login.button.enabled 			= true
			
			fetchRemote("http://ucdmta.com/updates.php", displayUpdates)
			
			LPE = {login.button, login.checkbox, login.edit["usr"], login.edit["passwd"]}
			for k, v in pairs(LPE) do
				v.visible = false
			end
			
			addEventHandler("onClientGUIClick", login.button, onClickLogin, false)
			--addEventHandler("onClientGUIClick", login.button[2], onClickRegister, false)
			--addEventHandler("onClientGUIChanged", guiRoot, onLoginEditsChanged)
			
			registration.button 							= GuiButton((1047/ nX) * sX, (657 / nY) * sY, (272 / nX) * sX, (42 / nY) * sY, "Register", false)
			registration.edit["usr"] 						= GuiEdit((1037/ nX) * sX, (367 / nY) * sY, (292 / nX) * sX, (40 / nY) * sY, "", false)
			registration.edit["email"] 						= GuiEdit((1037/ nX) * sX, (447 / nY) * sY, (292 / nX) * sX, (40 / nY) * sY, "", false)
			registration.edit["passwd"] 					= GuiEdit((1037/ nX) * sX, (527 / nY) * sY, (292 / nX) * sX, (40 / nY) * sY, "", false)
			registration.edit["passwd_confirm"] 			= GuiEdit((1037/ nX) * sX, (607 / nY) * sY, (292 / nX) * sX, (40 / nY) * sY, "", false)
			registration.edit["passwd"].masked 				= true
			registration.edit["passwd_confirm"].masked 		= true
			
			--[[
			registration.button = GuiButton((1047/ nX) * sX, (707 / nY) * sY, (272 / nX) * sX, (42 / nY) * sY, "Register", false)
			registration.edit["usr"] = GuiEdit((1037/ nX) * sX, (417 / nY) * sY, (292 / nX) * sX, (40 / nY) * sY, "", false)
			registration.edit["email"] = GuiEdit((1037/ nX) * sX, (497 / nY) * sY, (292 / nX) * sX, (40 / nY) * sY, "", false)
			registration.edit["passwd"] = GuiEdit((1037/ nX) * sX, (577 / nY) * sY, (292 / nX) * sX, (40 / nY) * sY, "", false)
			registration.edit["passwd_confirm"] = GuiEdit((1037/ nX) * sX, (657 / nY) * sY, (292 / nX) * sX, (40 / nY) * sY, "", false)
			]]
			
			RPE = {registration.button, registration.edit["usr"], registration.edit["email"], registration.edit["passwd"], registration.edit["passwd_confirm"]}
			for k, v in pairs(RPE) do
				v.visible = false
			end
			
			addEventHandler("onClientGUIClick", registration.button, onClickRegisterConfirm, false)
			--addEventHandler("onClientGUIChanged", registration.window[1], onRegistrationEditsChanged)
			
			if (File.exists("@credentials.xml")) then
				local f = XML.load("@credentials.xml")
				login.edit["usr"]:setText(tostring(f:findChild("usr", 0):getValue()))
				login.edit["passwd"]:setText(tostring(teaDecode(f:findChild("passwd", 0):getValue(), keys.xml)))
				f:unload()
				login.checkbox:setSelected(true)
			end
		end
	end
)

function isLoginWindowOpen()
	if (not login.button:getVisible()) or (not isElement(login.button)) then
		return false
	end 
	return true
end

function onLoginEditsChanged()
	if (source == login.edit["usr"] or source == login.edit["passwd"]) then
		local usr, passwd = login.edit["usr"].text, login.edit["passwd"].text
		if (usr:len() >= 3 and not usr:match("%W") and passwd:len() >= 6) then
			login.button:setEnabled(true)
		else
			login.button:setEnabled(false)
		end
	end
end

function onRegistrationEditsChanged()
	-- Account name
	if (source == registration.edit[1]) then
		local usr = source.text
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
	elseif (source == registration.edit["email"]) then
		local email = source.text:lower()
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
	elseif (source == registration.edit["passwd"]) then
		local pass = registration.edit["passwd"].text
		if (not pass or pass == "") then
			registration.label[8].text = "Enter your desired password"
			registration.label[8]:setColor(255, 255, 0)
		else
			if (pass:len() < 6) then
				registration.label[8].text = "Password is too short"
				registration.label[8]:setColor(255, 0, 0)
			else
				registration.label[8].text = "Valid password"
				registration.label[8]:setColor(0, 255, 0)
			end
		end
	-- Password confirmation
	elseif (source == registration.edit["passwd_confirm"]) then
		local conf = registration.edit["passwd_confirm"].text
		if (not conf or conf == "") then
			registration.label[9].text = "Re-enter your password"
			registration.label[9]:setColor(255, 255, 0)
		else
			if (conf ~= registration.edit["passwd"].text) then
				registration.label[9].text = "Passwords do not match"
				registration.label[9]:setColor(255, 0, 0)
			else
				registration.label[9].text = "Passwords match"
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
	if (source == login.button) then
		if (button == "left" and state == "up") then
			if (isTransferBoxActive()) then
				exports.UCDdx:new("You are still downloading server files - you cannot login yet", 255, 255, 255)
			else
				local usr = login.edit["usr"].text
				local passwd = login.edit["passwd"].text
				
				if (usr == "" and passwd == "") then
					exports.UCDdx:new("Please enter your account credentials", 255, 255, 255)
				else
					if (usr == "" and passwd ~= "") then
						exports.UCDdx:new("Please enter your account name", 255, 255, 255)
					elseif (usr ~= "" and passwd == "") then
						exports.UCDdx:new("Please enter your password", 255, 255, 255)
					elseif (user ~= "" and passwd ~= "") then
						triggerServerEvent("UCDaccounts.login.logIn", resourceRoot, usr, passwd)
						exports.UCDdx:new("Loading...", 255, 255, 255)
						toggleLogin()
					end
				end
			end
		end
	end
end

-- Register player
function onClickRegisterConfirm(button, state)
	if (button == "left" and state == "up") then
		if (source == registration.button) then
			local usr = registration.edit["usr"].text
			local email = registration.edit["email"].text
			local passwd = registration.edit["passwd"].text
			local conf = registration.edit["passwd_confirm"].text
			if (passwd ~= conf) then
				exports.UCDdx:new("Your passwords do not match", 255, 255, 255)
				return
			end
			triggerEvent("UCDaccounts.login.toggleRegisterConfirm", resourceRoot, false)
			triggerServerEvent("UCDaccounts.login.register", resourceRoot, usr, email, passwd, conf)
		end
	end
end

function toggleRegisterConfirm(state)
	if (source) then
		registration.button.enabled = state
	end
end
addEvent("UCDaccounts.login.toggleRegisterConfirm", true)
addEventHandler("UCDaccounts.login.toggleRegisterConfirm", root, toggleRegisterConfirm)

-- Open registration window
function onClickRegister(button, state, login)
	if (button == "left" and state == "up"and login == true) then
		--if (source == login.button[2]) then
			--guiSetVisible(registration.window[1], true)
			--exports.UCDutil:centerWindow(registration.window[1])
			--guiBringToFront(registration.window[1])
			--guiSetInputEnabled(true)
			
			if (RPE) then
				for _, v in pairs(RPE) do
					v.visible = true
				end
			end
			
			-- Hide other login elements
			if (LPE) then
				for _, v in pairs(LPE) do
					v.visible = false
				end
			end
			
			if (not isCursorShowing()) then showCursor(true) end
		--end
	end
end

-- Cancel registration
function onClickCancel(button, state)
	if (button == "left" and state == "up") then
		if (source == registration.button[2]) then
			guiSetVisible(registration.window[1], false)
			guiSetInputEnabled(true)
			
			-- Hide other login elements
			for _, v in pairs(LPE) do
				v:setVisible(true)
			end
			
			if (not isCursorShowing()) then showCursor(true) end
		end
	end
end

-- Show login window
function showLoginInterface()
	for _, v in pairs(RPE) do
		v.visible = false
	end
	for _, v in pairs(LPE) do
		v.visible = true
	end
	showCursor(true)
	addEventHandler("onClientRender", root, drawElements)
end
addEvent("UCDaccounts.login.showLoginInterface", true)
addEventHandler("UCDaccounts.login.showLoginInterface", root, showLoginInterface)

-- Hide login window
function hideLoginInterface()
	guiSetInputEnabled(false)
	for _, v in pairs(LPE) do
		v:setVisible(false)
	end
	showCursor(false)
	--removeEventHandler("onClientRender", root, drawElements)
end
addEvent("UCDaccounts.login.hideLoginInterface", true)
addEventHandler("UCDaccounts.login.hideLoginInterface", root, hideLoginInterface)

-- Hide register window
function hideRegistrationInterface()
	for _, v in pairs(RPE) do
		v.visible = false
	end
end
addEvent("UCDaccounts.login.hideRegistrationInterface", true)
addEventHandler("UCDaccounts.login.hideRegistrationInterface", root, hideRegistrationInterface)

-- We won't need to keep it in memory as the player will only use it once
function destroyInterface()
	if (isCursorShowing()) then showCursor(false) end
	for _, v in pairs(LPE) do
		v:destroy()
	end
	for _, v in pairs(RPE) do
		v:destroy()
	end
	login.memo:destroy()
	login = nil
	removeEventHandler("onClientRender", root, drawElements)
end
addEvent("UCDaccounts.login.destroyInterface", true)
addEventHandler("UCDaccounts.login.destroyInterface", root, destroyInterface)

function toggleLogin()
	if (login and login.button and isElement(login.button)) then
		login.button.enabled = not login.button.enabled
	end
end
addEvent("UCDaccounts.login.toggleLogin", true)
addEventHandler("UCDaccounts.login.toggleLogin", root, toggleLogin)

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
	if guiCheckBoxGetSelected(login.checkbox) then
		local usr = login.edit["usr"].text
		local passwd = teaEncode(login.edit["passwd"].text, keys.xml)
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
