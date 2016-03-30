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
	
	--local accountID = getPlayerAccountID(source)
	
	local result = GAD(source, "*")
	if result == nil then
		exports.UCDdx:new(source, "We have encountered a database issue. Please contact an administrator.")
		outputDebugString("Player could not log in - data is nil")
		return
	end
	
	source.frozen = false
	
	local playerX, playerY, playerZ 			= result.x, result.y, result.z
	local playerRot, playerDim, playerInterior 	= result.rot, result.dim, result.interior
	local playerModel 							= result.model
	local jobModel								= result.jobModel
	local playerTeam 							= result.team
	local occupation 					= result.occupation
	local playerWalkstyle 						= result.walkstyle
	local playerHealth, playerArmour 			= result.health, result.armour
	local playerMoney 							= result.money
	local playerWP	 							= result.wp
	local ntR, ntG, ntB 						= unpack(fromJSON(result.nametag))
	
	if (playerTeam == "Admins" or playerTeam == "Law" or (playerTeam == "Citizens" and occupation ~= "")) then
		source:spawn(playerX, playerY, playerZ + 0.5, playerRot, jobModel, playerInterior, playerDim, Team.getFromName(playerTeam))
	else
		source:spawn(playerX, playerY, playerZ + 0.5, playerRot, playerModel, playerInterior, playerDim, Team.getFromName(playerTeam))
	end
	
	setTimer(
		function (source)
			source:setArmor(playerArmour)
			--source:setWantedLevel(playerWanted)
			exports.UCDwanted:setWantedPoints(source, playerWP)
			source:setWalkingStyle(playerWalkstyle) --exports.UCDwalkstyle:setPlayerWalkingStyle(source, playerWalkstyle)			
		end, 1000, 1, source
	)
	
	source:setData("Occupation", occupation, true)
	source:setNametagColor(ntR, ntG, ntB)
	source:setMoney(playerMoney)
	source:setStat(24, 1000)
	source:setHealth(playerHealth)
	
	setCameraTarget(source, source)
	fadeCamera(source, true, 2)
	db:exec("UPDATE `accounts` SET `serial` = ?, `ip` = ? WHERE `account` = ?", source.serial, source.ip, source.account.name)
	--source:setData("accountID", accountID, true)
	source:setData("accountName", source.account.name, true)
	SAD(source, "lastUsedName", source.name)
	
	triggerClientEvent(Element.getAllByType("player"), "onClientPlayerLogin", source, source.account.name)
end
addEventHandler("onPlayerLogin", root, Accounts.Login)

--------------------------------------------------------------------------------------------------------------------------------------------------------------------

function Accounts.Save(plr)
	if (plr.type ~= "player" or plr.account.guest) then return end
	
	--local id = exports.UCDaccounts:getPlayerAccountID(plr)
	local p = plr.position
	local rot = getPedRotation(plr) -- I would use Element:getRotation, but that doesn't return quite correct values yet
	local dim = plr.dimension or 0
	local interior = plr.interior or 0
	local team = plr.team.name or "Unemployed"
	local money = plr.money
	local walkstyle = plr:getWalkingStyle() --exports.UCDwalkstyle:getPlayerWalkingStyle(plr)
	local wp = exports.UCDwanted:getWantedPoints(plr)
	local health = plr:getHealth()
	local armour = plr:getArmor()
	local occupation = plr:getData("Occupation")
	local nametag = toJSON({plr:getNametagColor()})

	db:exec("UPDATE `accounts` SET `ip`=?, `serial`=? WHERE `account`=?",
		plr.ip,
		plr.serial,
		plr.account.name
	)
		
	-- It's more efficient here to have one query and not 16 different ones that would come from using SAD
	--[[
	db:exec("UPDATE `accountData` SET `x`=?, `y`=?, `z`=?, `rot`=?, `dim`=?, `interior`=?, `team`=?, `money`=?, `walkstyle`=?, `wanted`=?, `health`=?, `armour`=?, `occupation`=?, `nametag`=?, `lastUsedName`=? WHERE `account`=?",
		p.x,
		p.y,
		p.z,
		rot,
		dim,
		interior,
		team,
		money,
		walkstyle,
		wanted,
		health,
		armour,
		occupation,
		nametag,
		plr.name,
		plr.account.name
	)
	--]]
	
	-- I might as well just use SAD to update the table instead of having to bother with a large query which has a much larger load than what multiple SQL queries does
	-- And I'm pretty sure SQL executions can be queued (need to ask Jusonex about that) and as long as we don't have hundreds of players, small optimizations like this shouldn't have too much effect
	-- Plus, the tables will be updated which is a big bonus
	SAD(plr.account.name, "x", p.x)
	SAD(plr.account.name, "y", p.y)
	SAD(plr.account.name, "z", p.z)
	SAD(plr.account.name, "rot", rot)
	SAD(plr.account.name, "dim", dim)
	SAD(plr.account.name, "interior", interior)
	SAD(plr.account.name, "team", team)
	SAD(plr.account.name, "money", money)
	SAD(plr.account.name, "walkstyle", walkstyle) -- Need to change this to a per-change basis
	SAD(plr.account.name, "wp", wp)
	SAD(plr.account.name, "health", health)
	SAD(plr.account.name, "armour", armour)
	SAD(plr.account.name, "occupation", occupation)
	SAD(plr.account.name, "nametag", nametag)
	SAD(plr.account.name, "lastUsedName", plr.name)
	
	-- Use a timer here to reduce load on the server at once (from SQL queries and tables being accessed)
	--[[
	setTimer(
		function (account)
			-- We cache the account here only because we didn't in the above query
			--cachePlayerAccount(plr)
			cacheAccount(account) -- This is a rather inefficent method come to think of it
		end, 1000, 1, plr.account.name
	)
	--]]
end

function Accounts.OnQuit()
	if (source.account.guest) then return false end
	Accounts.Save(source)
end
addEventHandler("onPlayerQuit", root, Accounts.OnQuit)

function Accounts.SaveAll()
	--for _, v in pairs(Element.getAllByType("player")) do
	for _, plr in ipairs(getLoggedInPlayers()) do
		Accounts.Save(plr)
	end
end
--addCommandHandler("saveall", Accounts.SaveAll)

function Accounts.Stop()
	Accounts.SaveAll()
end
addEventHandler("onResourceStop", resourceRoot, Accounts.Stop)
