--these are the banned vehicle ids where you cannot get drift points.
local BannedIDs = { 432, 532 }

local rootElem = getRootElement()
local thisRoot = getResourceRootElement(getThisResource())
local player = getLocalPlayer()
local vehicle
local size = 1.4
local modo = 0.01
local score = 0
local screenScore = 0
local tick
local idleTime
local multTime
local driftTime
local mult = 1
local tablamult = {350,1400,4200,11200}
local anterior = 0
local mejor = 0

local screenWidth, screenHeight = guiGetScreenSize()
local x1,y1,x2,y2 = screenWidth*0.2,screenHeight*0.1,screenWidth*0.8,screenHeight*0.8

local SF = ColShape.Rectangle(-3000, -952, 2000, 2500)
--createRadarArea(-3000, -952, 2000, 2500, 255, 255, 255, 100)

addEventHandler("onClientResourceStart", resourceRoot,
	function()
		addEventHandler("onClientRender", root, showText)
		if (exports.UCDaccounts:isPlayerLoggedIn(localPlayer)) then
			triggerServerEvent("driftClienteListo", resourceRoot)
		end
	end
)

addEventHandler("onClientResourceStop", thisRoot,
	function()
		removeEventHandler("onClientRender", root, showText)
	end
)

addEventHandler("onClientVehicleDamage", root, 
	function ()
		if (source and source.controller and source.controller == localPlayer) then
			triggerEvent("driftCarCrashed", source)
		end
	end
)

function isValidVehicle()
	local temp = getPedOccupiedVehicle(player)
	
	if not temp or getVehicleOccupant(temp,0) ~= player or getVehicleType(temp) ~= "Automobile" then
		return false
	end
	
	local vehID = getElementModel(temp)
	for k,v in ipairs(BannedIDs) do if vehID == v then return false end end
	
	return temp
end

function math.round(number, decimals, method)
    decimals = decimals or 0
    local factor = 10 ^ decimals
    if (method == "ceil" or method == "floor") then return math[method](number * factor) / factor
    else return tonumber(("%."..decimals.."f"):format(number)) end
end

function showText()
	--dxDrawText(string.format("Best Drift: %s - %d",global_nombre,global_mejor),24,screenHeight-280,screenWidth,screenHeight,White,0.85,"pricedown")
	
	vehicle = isValidVehicle()
	
	if (not vehicle) then return end
	if (not localPlayer:isWithinColShape(SF)) then return end
	
	if size > 1.3 then 
		modo = -0.01 
	elseif size < 1.2 then 
		modo = 0.01 
	end
	size = size + modo
	
	if (localPlayer.team.name ~= "Criminals") then
		return
	end
	
	
	tick = getTickCount()
	local angulo,velocidad = angle()
	local tempBool = tick - (idleTime or 0) < 750
	if not tempBool and score ~= 0 then
			
		local cash = 0
		if (not mejor) then
			mejor = 0
		end
		
		if (score > mejor) then
			mejor = score
			-- setElementData(player, "Best Drift", mejor)
			-- Set the player's max drift to this
			triggerLatentServerEvent("UCDdrift.setPlayerBestDrift", resourceRoot, mejor)
		end
		triggerEvent("onVehicleDriftEnd", resourceRoot, tick-driftTime - 750)
		triggerLatentServerEvent("UCDdrift.addPlayerTotalDrift", resourceRoot, score)
		triggerLatentServerEvent("UCDdrift.onPlayerFinishDrift", resourceRoot)
		score = 0
	end
	
	if angulo ~= 0 then
		if score == 0 then 
			triggerEvent("onVehicleDriftStart", resourceRoot)
			driftTime = tick
		end
		if tempBool then
			score = score + math.floor(angulo*velocidad)*mult
		else
			score = math.floor(angulo*velocidad)*mult
		end
		if TempCol == Red then
			TempCol = Yellow
		end
		screenScore = score
		idleTime = tick
	end
	
	if (isPlayerMapVisible()) then return end
	
	--local temp2 = string.format("Factor: X%d\n%s",mult,mult~=5 and string.format("Gain X%d with %d",mult+1,tablamult[mult]) or "MAX")
	--dxDrawText(temp2, 20,195,screenWidth,screenHeight, Yellow, 1.2, "sans","left","top", false,true,false)
	
	if velocidad <= 0.3 and mult ~= 1 then
		--dxDrawText("\n\nToo Slow!", 20,195,screenWidth,screenHeight, Yellow, 1.2, "sans","left","top", false,true,false)
		exports.UCDdx:add("drift", "Drift: Too slow!", 200, 0, 0)
	end
	
	if tick - (idleTime or 0) < 3000 then
		local temp = "DRIFT"
		if score >= 100000 then
			temp = "DRIFT\n\nDrift King!"
		elseif score >= 50000 then
			temp = "DRIFT\n\nInsane Drift!"
		elseif score >= 20000 then
			temp = "DRIFT\n\nOutrageous!"
		elseif score >= 15000 then
			temp = "DRIFT\n\nColossal!"
		elseif score >= 7000 then
			temp = "DRIFT\n\nSuberb!"
		elseif score >= 3000 then
			temp = "DRIFT\n\nGreat Drift!"
		elseif score >= 1000 then
			temp = "DRIFT\n\nGood Drift!"
		end
		--dxDrawText(temp, x1,y1,x2,y2, TempCol, 2.2, "sans","center","top", false,true,false)
		--dxDrawText(string.format("\n%d",screenScore),  x1,y1-10,x2,y2, TempCol, size+0.15, "pricedown","center","top", false,true,false)
		exports.UCDdx:add("drift", "Drift: "..tostring(exports.UCDutil:tocomma(screenScore)), 200, 0, 0)
	else
		exports.UCDdx:del("drift")
	end
end

function angle()
	local vx,vy,vz = getElementVelocity(vehicle)
	local modV = math.sqrt(vx*vx + vy*vy)
	
	if not isVehicleOnGround(vehicle) then return 0,modV end
	
	local rx,ry,rz = getElementRotation(vehicle)
	local sn,cs = -math.sin(math.rad(rz)), math.cos(math.rad(rz))
	
	local deltaT = tick - (multTime or 0)
	if mult~= 1 and modV <= 0.3 and deltaT > 750 then
		mult = mult-1
		multTime = tick
	elseif deltaT > 1500 then
		local temp = 1
		if score >= 11200 then
			temp = 5
		elseif score >= 4200 then
			temp = 4
		elseif score >= 1400 then
			temp = 3
		elseif score >= 350 then
			temp = 2
		end
		if temp>mult then
			mult = temp
			multTime = tick
		end
	end
	
	if modV <= 0.2 then return 0,modV end --speed over 40 km/h
	
	local cosX = (sn*vx + cs*vy)/modV
	if cosX > 0.966 or cosX < 0 then return 0,modV end --angle between 15 and 90 degrees
	return math.deg(math.acos(cosX))*0.5, modV
end

addEvent("driftCarCrashed", true)
addEventHandler("driftCarCrashed", rootElem, 
	function()
		if score ~= 0 then
			score = 0
			mult = 1
			TempCol = Red
			triggerEvent("onVehicleDriftEnd", rootElem, 0)
		end
	end
)

addEvent("UCDdrift.syncRecord", true)
addEventHandler("UCDdrift.syncRecord", root,
	function (score)
		mejor = score
		outputDebugString("Highest score = "..tostring(mejor))
	end
)
