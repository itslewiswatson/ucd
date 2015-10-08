-------------------------------------------------------------------
--// PROJECT: Union of Clarity and Diversity
--// RESOURCE: UCDlogin
--// DEVELOPER(S): Lewis Watson (Noki)
--// DATE: 13.12.2014
--// PURPOSE: Handling player logins.
--// FILE: \UCDlogin\s.lua [server]
-------------------------------------------------------------------

local db = exports.UCDsql:getConnection()

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
	
	-- My own bc I am god
	{1380.4105, -748.9726, 104.6013, 1460.8162, -1051.0956, 95.9769},
	{2139.718, 1899.7533, 12.9899, 2034.3885, 1921.8209, 14.3957},
	{-1211.5592, -2928.3223, 67.2434, -1071.653, -2823.7144, 46.9938},
	{-1026.7146, -1613.5925, 89.238, -1123.5228, -1659.3414, 77.2198},
	{964.5377, 2575.6436, 23.3776, 993.2688, 2548.8789, 20.6946},
}

function startMatrix()
	fadeCamera(source, true, 1.5)
	local x, y, z, lx, ly, lz = unpack(matrixViewPositions[math.random(#matrixViewPositions)])
	setCameraMatrix(source, x, y, z, lx, ly, lz)
	showPlayerHudComponent(source, "all", false)
	showChat(source, false)
	setPlayerNametagColor(source, false)
end
addEventHandler("onPlayerJoin", root, startMatrix)

function joinText()
	local text = {}
	plr = Player("Noki")
	display = textCreateDisplay()
	textDisplayAddObserver(display, plr)
	text[1] = textCreateTextItem("Welcome to the Union of Clarity and Diversity", 0.37, 0.2)
	text[2] = textCreateTextItem("Loading resources...", 0.45, 0.5)
	for i=1, #text do
		textDisplayAddText(display, text[i])
		textItemSetScale(text[i], 2)
	end
end
--addEventHandler("onResourceStart", root, joinText)

-- Login handling
function loginPlayer(usr, passwd)
	--[[if (username ~= "") then
		if (password ~= "") then
			local mtaAccount = getAccount(username, password)
			if (mtaAccount ~= false) then
				logIn(client, mtaAccount, password)
				triggerClientEvent(client, "hideLoginWindow", root)
			else
				exports.UCDdx:new(client, "Incorrect account name or password", 255, 255, 255)
			end
		else
			exports.UCDdx:new(client, "Please enter your password", 255, 255, 255)
		end
	else
	--]]
	
	-- All handled client-side
	--[[
	if (usr == "") and (passwd == "") then
		exports.UCDdx:new(client, "Please enter your account credentials", 255, 255, 255)
	else
		if (usr == "") and (passwd ~= "") then
			exports.UCDdx:new(client, "Please enter your account name", 255, 255, 255)
		elseif (usr ~= "") and (passwd == "") then
			exports.UCDdx:new(client, "Please enter your password", 255, 255, 255)
		elseif (user ~= "") and (passwd ~= "") then
	--]]
	
	-- Maybe have a label that you constantly need to update instead of using UCDdx
	
	if (getAccount(usr)) then
		if (getAccount(usr, passwd)) then
			logIn(client, getAccount(usr), passwd)
			triggerClientEvent(client, "UCDlogin.hideLoginInterface", resourceRoot)
			triggerClientEvent(client, "UCDlogin.destroyInterface", resourceRoot)
			exports.UCDlogging:new(client, "login", "Logged into account: "..usr, client:getIP())
		else
			exports.UCDdx:new(client, "Incorrect password.", 255, 255, 255)
		end
	else
		exports.UCDdx:new(client, "There is no account matching this name.", 255, 255, 255)
	end
	--[[
		end
	end
	--]]
	--end
end
addEvent("UCDlogin.logIn", true)
addEventHandler("UCDlogin.logIn", root, loginPlayer)

-- Registration here
function registerPlayer(usr, email, passwd, conf)
	if (not getAccount(usr)) then
		local addedAccount = exports.UCDaccounts:registerAccount(client, usr, passwd, email)
		if (not addedAccount) then
			exports.UCDdx:new(client, "An unknown error has occurred! Please choose a different account name/password and try again.", 255, 255, 255)
			return false
		end
		triggerClientEvent(client, "UCDlogin.hideRegistrationInterface", resourceRoot) -- Hides the window
		triggerClientEvent(client, "UCDlogin.showLoginInterface", resourceRoot) -- Shows login window
		exports.UCDdx:new(client, "You have successfully registered! Account name: "..usr.."", 255, 255, 255)
		exports.UCDlogging:new(client, "register", "registered account: "..usr, client:getIP())
		return true
	end
end

addEvent("UCDlogin.register", true)
addEventHandler("UCDlogin.register", root, registerPlayer)

function login_handler()
	source:setData("isLoggedIn", true)
	-- source:setData("isPlayerLoggedIn", true)
	if (Resource.getFromName("UCDhud"):getState() == "running" or Resource.getFromName("UCDhud"):getState() == "starting") then
		setTimer(
			function (source)
				for _, v in pairs(exports.UCDhud:getDisabledHUD()) do
					source:setHudComponentVisible(v, false)
				end
				source:setHudComponentVisible("radar", true)
				source:setHudComponentVisible("radio", true)
				source:setHudComponentVisible("crosshair", true)
			end, 1000, 1, source
		)
	else
		source:setHudComponentVisible("all", true)
	end
	showChat(source, true)
	-- Used for debug right now
	local pDim = source:getDimension()
	if (pDim ~= 0 and exports.UCDaccounts:isPlayerOwner(source)) then
		outputChatBox("You are not in dimension 0!", source, 255, 255, 255)
	end
end
addEventHandler("onPlayerLogin", root, login_handler)

function isAccount(name)
	local send
	if (getAccount(name)) then
		send = false
	else
		send = true
	end
	triggerClientEvent(client, "UCDlogin.updateValidationLabel", resourceRoot, send)
end
addEvent("UCDlogin.isAccount", true)
addEventHandler("UCDlogin.isAccount", root, isAccount)