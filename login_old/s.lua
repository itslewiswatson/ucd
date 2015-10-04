-------------------------------------------------------------------
--// PROJECT: Project Downtown
--// RESOURCE: login
--// DEVELOPER(S): Lewis Watson (Noki)
--// DATE: 13.12.2014
--// PURPOSE: Handling player logins.
--// FILE: \login\s.lua [server]
-------------------------------------------------------------------

local db = exports.UCDsql:getConnection()

local matrixViewPositions = {
	{1305.09973, -860.06250, 83.92583, 1418.49683, -803.08008, 80.69189},
	{2081.45605, 1744.49878, 14.48063, 2166.39648, 1656.14502, 27.01394},
	{2095.71826, 1374.67261, 52.45646, 1955.80347, 1342.64624, 8.55083},
	{-2708.49219, 2108.61475, 95.03329, -2560.98022, 1746.29285, 7.38109},
	{-1813.52527, 580.16193, 371.09628, -1807.63171, 493.84613, 55.5428},
	{1862.90833, -1452.45300, 140.37985, 1528.33813, -1258.09937, 215.22653},
	{1674.29980, -895.24408, 531.87439, 1659.51709, -982.78577, 39.61652},
	{-903.80847, 1740.82678, 171.57216, -720.15826, 2015.47437, 56.53033},
	
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
	source:setHudComponentVisible("all", false)
	showChat(source, false)
	source:setNametagColor(false)
end
addEventHandler("onPlayerJoin", root, startMatrix)

-- Login handling
function loginPlayer(username, password)
	if not (username == "") then
		if not (password == "") then
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
		exports.UCDdx:new(client, "Please enter your account name", 255, 255, 255)
	end
end
addEvent("onRequestLogin", true)
addEventHandler("onRequestLogin", root, loginPlayer)

-- Registration here
function registerPlayer(username, password, passwordConfirm)
	if not (username == "") then
		if not (password == "") then
			if not (passwordConfirm == "") then
				if (password == passwordConfirm) then
					local account = getAccount(username)
					if (account == false) then
						--local addedAcc = addAccount(username, password)
						local addedAccount = exports.UCDaccounts:registerAccount(source, username, password)
						if (addedAccount) then
							triggerClientEvent(source, "hideRegisterWindow", root) -- Hides the window
							exports.UCDdx:new(source, "You have successfully registered! Account name: "..username.."", 255, 255, 255)
						else
							exports.UCDdx:new(source, "An unknown error has occurred! Please choose a different account name/password and try again.", 255, 255, 255)
						end
					else
						exports.UCDdx:new(source, "An account matching this name already exists!", 255, 255, 255)
					end
				else
					exports.UCDdx:new(source, "Passwords do not match!", 255, 255, 255)
				end
			else
				exports.UCDdx:new(source, "Please confirm your password!", 255, 255, 255)
			end
		else
			exports.UCDdx:new(source, "Please enter a password!", 255, 255, 255)
		end
	else
		exports.UCDdx:new(source, "Please enter an account name you would like to register with!", 255, 255, 255)
	end
end
addEvent("onRequestRegister", true)
addEventHandler("onRequestRegister", root, registerPlayer)

function showOnLogin ()
	setElementData(source, "isPlayerLoggedIn", true)
	setTimer(
		function (source)
			--if (getResourceState(getResourceFromName("UCDhud")) == "running" or "starting") then
				local disabledHUD = exports.UCDhud:getDisabledHUD()
				for _, v in pairs(disabledHUD) do
					showPlayerHudComponent(source, v, false)
				end
				showPlayerHudComponent(source, "radar", true)
				showPlayerHudComponent(source, "radio", true)
				showPlayerHudComponent(source, "crosshair", true)
			--end
			showChat(source, true)
			setElementData(source, "isLoggedIn", true)
		end, 1000, 1, source
	)
	
	-- Used for debug right now
	local pDim =  getElementDimension(source)
	if (pDim ~= 0) then
		outputChatBox("You are not in dimension 0!", source, 255, 255, 255)
	end
end
addEventHandler("onPlayerLogin", root, showOnLogin)
