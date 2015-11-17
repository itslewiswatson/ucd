--------------------------------------------------------------------
--// PROJECT: Union of Clarity and Diversity
--// RESOURCE: UCDaccounts
--// DEVELOPER(S): Lewis Watson (Noki)
--// DATE: 13.12.2014
--// PURPOSE: Act as a central accounts resource handling logins.
--// FILE: \UCDaccounts\s_accounts.lua [server]
--------------------------------------------------------------------

db = exports.UCDsql:getConnection()
Accounts = {}

function Accounts.Login(_, theCurrentAccount)
	--outputDebugString("Accounts.Login")
	if (theCurrentAccount:isGuest()) then return end
	
	local accountID = getPlayerAccountID(source)
	local result = GAD(source, "*")
	if result == nil then
		exports.UCDdx:new(source, "We have encountered a database issue. Please contact an administrator.")
		outputDebugString("Player could not log in - data is nil")
	end
	
	local playerX, playerY, playerZ 			= result.x, result.y, result.z
	local playerRot, playerDim, playerInterior 	= result.rot, result.dim, result.interior
	local playerModel 							= result.model
	local playerTeam 							= result.team
	local class, occupation 					= result.class, result.occupation
	local playerWalkstyle 						= result.walkstyle
	local playerHealth, playerArmour 			= result.health, result.armour
	local playerMoney 							= result.money
	local playerWanted 							= result.wanted
	local ntR, ntG, ntB 						= unpack(fromJSON(result.nametag))
	
	source:spawn(playerX, playerY, playerZ + 0.5, playerRot, playerModel, playerInterior, playerDim, Team.getFromName(playerTeam))
	
	setTimer(
		function (source)
			source:setArmor(playerArmour)
			source:setWantedLevel(playerWanted)
			source:setData("Occupation", occupation)
			source:setData("Class", class)
			source:setWalkingStyle(playerWalkstyle) --exports.UCDwalkstyle:setPlayerWalkingStyle(source, playerWalkstyle)			
		end, 1000, 1, source
	)
	
	source:setNametagColor(ntR, ntG, ntB)
	source:setMoney(playerMoney)
	source:setStat(24, 1000)
	source:setHealth(playerHealth)
	
	setCameraTarget(source, source)
	fadeCamera(source, true, 2)
	db:exec("UPDATE `accounts` SET `serial`=?, `ip`=?, `lastUsedName`=? WHERE `id`=?", source:getSerial(), source:getIP(), source:getName(), accountID)
	source:setData("accountID", accountID, true)
end
addEventHandler("onPlayerLogin", root, Accounts.Login)

--------------------------------------------------------------------------------------------------------------------------------------------------------------------

function Accounts.Save(plr)
	if (plr:getType() ~= "player") then return nil end
	if (plr:getAccount():isGuest()) then return false end
	
	local id = exports.UCDaccounts:getPlayerAccountID(plr)
	local playerX, playerY, playerZ = plr:getPosition().x, plr:getPosition().y, plr:getPosition().z
	local rot = getPedRotation(plr) -- I would use Element:getRotation, but that doesn't return quite correct values yet
	local dim = plr:getDimension()
	local interior = plr:getInterior()
	local team = plr:getTeam():getName()
	local money = plr:getMoney()
	local model = plr:getModel()
	local walkstyle = plr:getWalkingStyle() --exports.UCDwalkstyle:getPlayerWalkingStyle(plr)
	local wanted = plr:getWantedLevel()
	local health = plr:getHealth()
	local armour = plr:getArmor()
	local occupation = plr:getData("Occupation")
	local class = plr:getData("Class")
	local nametag = toJSON({plr:getNametagColor()})

	db:exec("UPDATE `accounts` SET `lastUsedName`=?, `ip`=?, `serial`=? WHERE `id`=?", 
		plr.name,
		plr.ip,
		plr.serial,
		id 
	)
	
	-- It's more efficient here to have one query and not 16 different ones that would come from using SAD
	db:exec("UPDATE `accountData` SET `x`=?, `y`=?, `z`=?, `rot`=?, `dim`=?, `interior`=?, `team`=?, `money`=?, `model`=?, `walkstyle`=?, `wanted`=?, `health`=?, `armour`=?, `occupation`=?, `class`=?, `nametag`=? WHERE `id`=?",
		playerX,
		playerY,
		playerZ,
		rot,
		dim,
		interior,
		team,
		money,
		model,
		walkstyle,
		wanted,
		health,
		armour,
		occupation,
		class,
		nametag,
		id
	)
	
	-- Use a timer here to reduce load on the server at once (from SQL queries and tables being accessed)
	setTimer(
		function (id)
			-- We cache the account here only because we didn't in the above query
			--cachePlayerAccount(plr)
			cacheAccount(id) -- This is a rather inefficent method come to think of it
		end, 1000, 1, id
	)
end

function Accounts.OnQuit()
	if (source:getAccount():getName() == "guest") then return false end
	Accounts.Save(source)
end
addEventHandler("onPlayerQuit", root, Accounts.OnQuit)

function Accounts.SaveAll()
	--for _, v in pairs(Element.getAllByType("player")) do
	for _, v in pairs(getAllLoggedInPlayers()) do
		Accounts.Save(v)
	end
end
--addCommandHandler("saveall", Accounts.SaveAll)

function Accounts.Stop()
	Accounts.SaveAll()
end
addEventHandler("onResourceStop", resourceRoot, Accounts.Stop)
