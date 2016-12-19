-------------------------------------------------------------------
--// PROJECT: Union of Clarity and Diversity
--// RESOURCE: UCDaccounts
--// DEVELOPER(S): Lewis Watson (Noki)
--// DATE: 13.12.2014
--// PURPOSE: Handling player logins.
--// FILE: \UCDaccounts\login\server.lua [server]
-------------------------------------------------------------------

local db = exports.UCDsql:getConnection()
local restricted = {"UCDhousing", "admin", "UCD", "UCDadmin", "nokizorque"}
local matrixViewPositions = {
	-- Some CSG ones
	-- Silly cunts ty for the coords
	{1305.09973, -860.06250, 83.92583, 1418.49683, -803.08008, 80.69189},
	{2081.45605, 1744.49878, 14.48063, 2166.39648, 1656.14502, 27.01394},
	{2095.71826, 1374.67261, 52.45646, 1955.80347, 1342.64624, 8.55083},
	{-2708.49219, 2108.61475, 95.03329, -2560.98022, 1746.29285, 7.38109},
	{-1813.52527, 580.16193, 371.09628, -1807.63171, 493.84613, 55.5428},
	{1862.90833, -1452.45300, 140.37985, 1528.33813, -1258.09937, 215.22653},
	{1674.29980, -895.24408, 531.87439, 1659.51709, -982.78577, 39.61652},
	{-903.80847, 1740.82678, 171.57216, -720.15826, 2015.47437, 56.53033},
	-- My own bc I am [s]god[/s] I told you I don't believe in christmas kid - Risk (yes, bbc)
	{1380.4105, -748.9726, 104.6013, 1460.8162, -1051.0956, 95.9769},
	{2139.718, 1899.7533, 12.9899, 2034.3885, 1921.8209, 14.3957},
	{-1211.5592, -2928.3223, 67.2434, -1071.653, -2823.7144, 46.9938},
	{-1026.7146, -1613.5925, 89.238, -1123.5228, -1659.3414, 77.2198},
	--{964.5377, 2575.6436, 23.3776, 993.2688, 2548.8789, 20.6946},
}
local display = textCreateDisplay()
local text = {}
text[1] = textCreateTextItem("Welcome to the Union of Clarity and Diversity", 0.5, 0.2, "high", 255, 255, 255, 255, 2, "center", 0)
text[2] = textCreateTextItem("Loading resources...", 0.5, 0.5, "high", 255, 255, 255, 255, 2, "center", 0)
for i = 1, #text do
	textDisplayAddText(display, text[i])
	textItemSetScale(text[i], 2)
end

function startMatrix()
	fadeCamera(source, true, 1.5)
	local x, y, z, lx, ly, lz = unpack(matrixViewPositions[math.random(#matrixViewPositions)])
	setCameraMatrix(source, x, y, z, lx, ly, lz)
	showPlayerHudComponent(source, "all", false)
	showChat(source, false)
	setPlayerNametagColor(source, false)
	source.position = Vector3(0, 0, -5)
	source.frozen = true
end
addEventHandler("onPlayerJoin", root, startMatrix)

function joinText()
	textDisplayAddObserver(display, source)
end
addEventHandler("onPlayerJoin", root, joinText)

function removeLoginText()
	textDisplayRemoveObserver(display, client)
end
addEvent("UCDaccounts.removeLoginText", true)
addEventHandler("UCDaccounts.removeLoginText", root, removeLoginText)

-- Login handling
function loginPlayer2(usr, passwd, plr)
	local plr = client -- REMOVE THIS LINE
	
	--[[
	local result = exports.UCDsql:getForumDatabase():query("SELECT `member_name`, `passwd` FROM `smf_members` WHERE `member_name` = ? LIMIT 1", usr):poll(-1)
	if (not result or #result == 0) then
		if (not result) then
			exports.UCDdx:new(plr, "Database error - try again later", 255, 255, 255)
			return
		end
		exports.UCDdx:new(plr, "There is no account matching this name", 255, 255, 255)
		return
	end
	
	if (result[1].passwd ~= hash("sha1", usr:lower()..passwd)) then
		exports.UCDdx:new(plr, "Incorrect password", 255, 255, 255)
		return false
	end
	--]]
	
	-- Maybe have a label that you constantly need to update instead of using UCDdx
	if (getAccount(usr)) then
		if (getAccount(usr, passwd)) then
			if (getAccount(usr).player) then
				outputChatBox(plr.name.." is trying to log into your account. They have used a correct password. It is recommended you change your password or contact an admin.", getAccount(usr):getPlayer())
				exports.UCDdx:new(plr, "This account is currently in use.", 255, 255, 255)
				triggerClientEvent(plr, "UCDaccounts.login.toggleLogin", plr)
				return
			else
				-- If we have a database error or table error, DO NOT FUCKING LOG THEM IN
				if (not accountData[usr]) then
					exports.UCDdx:new(plr, "We have encountered a database issue. Please contact an administrator.", 255, 255, 255)
					outputDebugString("Player "..plr.name.." could not log in - data is nil")
					triggerClientEvent(plr, "UCDaccounts.login.toggleLogin", plr)
					return false
				end
				if (exports.UCDadmin:isAccountBanned(usr)) then
					exports.UCDdx:new(plr, "This account is banned", 255, 255, 255)
					triggerClientEvent(plr, "UCDaccounts.login.toggleLogin", plr)
					return
				end
				triggerClientEvent(plr, "UCDaccounts.login.saveAccountCredentials", plr, usr, passwd)
				logIn(plr, getAccount(usr), passwd)
				exports.UCDlogging:new(plr, "login", "Logged into account: "..usr, plr.ip)
				exports.UCDdx:new(plr, "Welcome to UCD, "..tostring(plr.name), 255, 255, 255)
			end
		else
			exports.UCDdx:new(plr, "Incorrect password", 255, 255, 255)
		end
	else
		exports.UCDdx:new(plr, "There is no account matching this name", 255, 255, 255)
	end
	triggerClientEvent(plr, "UCDaccounts.login.toggleLogin", plr)
end
addEvent("UCDaccounts.login.logIn", true)
addEventHandler("UCDaccounts.login.logIn", root, loginPlayer2)

-- Registration here
function registerPlayer2(usr, email, passwd, plr)
	local plr = client -- REMOVE THIS LINE
	for _, v in ipairs(restricted) do
		if (usr == v) then
			exports.UCDdx:new(plr, "You cannot register this account name because it is restricted", 255, 255, 255)
			return
		end
	end
	--]]
	if (not getAccount(usr)) then
		local addedAccount = exports.UCDaccounts:registerAccount(plr, usr, passwd, email)
		if (not addedAccount) then
			exports.UCDdx:new(plr, "An unknown error has occurred! Please choose a different account name/password and try again.", 255, 255, 255)
			triggerClientEvent(plr, "UCDaccounts.login.toggleRegisterConfirm", plr, true)
			return false
		end
		triggerClientEvent(plr, "UCDaccounts.login.hideRegistrationInterface", resourceRoot) -- Hides the window
		triggerClientEvent(plr, "UCDaccounts.login.showLoginInterface", resourceRoot) -- Shows login window
		exports.UCDdx:new(plr, "You have successfully registered! Account name: "..usr, 255, 255, 255)
		--exports.UCDdx:new(plr, "This account will also work on the forums - forum.ucdmta.com", 255, 255, 255)
		exports.UCDlogging:new(plr, "register", "registered account: "..usr, plr.ip)
		return true
	end
end
addEvent("UCDaccounts.login.register", true)
addEventHandler("UCDaccounts.login.register", root, registerPlayer2)

function login_handler()
	source:setData("isLoggedIn", true)
	source:setHudComponentVisible("all", true)
	source:setHudComponentVisible("vehicle_name", false)
	showChat(source, true)
	triggerClientEvent(source, "UCDaccounts.login.hideLoginInterface", source)
	triggerClientEvent(source, "UCDaccounts.login.destroyInterface", source)
end
addEventHandler("onPlayerLogin", root, login_handler)

function isAccount(name)
	local msg, found
	for _, v in pairs(Account.getAll()) do
		if (v.name == name) then
			msg = "This account name is taken"
			found = true
			break
		elseif (v.name:lower() == name:lower()) then
			msg = "Account name exists with different case"
			found = true
			break
		end
	end
	if (found == true) then
		triggerClientEvent(client, "UCDaccounts.login.updateValidationLabel", client, msg, true)
	else
		triggerClientEvent(client, "UCDaccounts.login.updateValidationLabel", client, "Available account name", false)
	end
end
addEvent("UCDaccounts.login.isAccount", true)
addEventHandler("UCDaccounts.login.isAccount", root, isAccount)

--[[
addEvent("UCDaccounts.fetchUpdates", true)
addEventHandler("UCDaccounts.fetchUpdates", root,
	function ()
		if (client) then
			local updates = fetchRemote("")
		end
	end
)
]]
