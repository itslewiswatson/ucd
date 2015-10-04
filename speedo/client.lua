-- Once in how many frames should the data be refreshed?
local rpf = 4

local clr = tocolor(0, 255, 0)
local clr2 = tocolor(0, 255, 0)
local clrWhite = tocolor(255,255,255)

local resolutionFactor = guiGetScreenSize()/720 --4
local borderSize = 0.5

local drawing = false
local veh = false
local speed = false
local renderTarget = false
local minX = 2
local nosOn = false
local scrnX, scrnY = guiGetScreenSize()
local twoDMode = false

local mph = false

infNOSTeams = {
["Admin"] = true,
}

function saveConf()
	local conf = fileCreate("speed.conf")
	if conf then
		fileWrite(conf, toJSON({mph,twoDMode}))
		fileClose(conf)
	else
		outputDebugString("Speedo: Creating configuration file failed!")
	end
end

function loadConf()
	if fileExists("speed.conf") then
		local conf = fileOpen("speed.conf")
		if conf then
			local confString = fileRead(conf, fileGetSize(conf))
			local array = fromJSON(confString)
			if array then
				mph = array[1]
				twoDMode = array[2]
			end
		end
	else
		saveConf()
	end
end
loadConf()

addEventHandler("onClientVehicleEnter", root,
function(player, seat)
	if player == localPlayer and isElement(source) then --and getVehicleType(source) ~= "Plane" then
		toggleSpeed(true)
	end
end)

addEventHandler("onClientVehicleExit", root,
function(player, seat)
	if player == localPlayer and isElement(source) then
		toggleSpeed(false)
	end
end)

function toggleSpeed(setTo)
	drawing = setTo
	veh = getPedOccupiedVehicle(localPlayer)
	if setTo then
		minX = getElementBoundingBox(veh)
		i = 15
		if not isElement(renderTarget) then renderTarget = dxCreateRenderTarget(232 * resolutionFactor, 102 * resolutionFactor, true) end
		addEventHandler("onClientPreRender", root, drawSpeed)
	end
end

function drawSpeed()
	if drawing and isElement(veh) and getPedOccupiedVehicle(localPlayer) == veh then	
		if (getTickCount() % (rpf + 1)) == 0 then
			speed = getSpeed()
			health = ((getElementHealth(veh) - 200) * (5/4)) / 1000
			if health > 1 then health = 1 end
			if health < 0 then health = 0 end
			
			-- Calculate the color!
			local r, g, b = HSV(health * (1/3), 1, 1)
			clr = tocolor(r, g, b)
			
			dxSetRenderTarget(renderTarget, true)
			local str = tostring(math.floor(speed))
			if mph then str = str .. "mph" else str = str .. "kmh" end
			dxDrawBorderedText(str, 0, 0, 230 * resolutionFactor, 90 * resolutionFactor, clr, 5 * resolutionFactor, "default", "right", "bottom", true)
			
			local damage = math.floor((health * 219) + 10)
			dxDrawLine((10 * resolutionFactor) - (2 * borderSize), 95 * resolutionFactor, 229 * resolutionFactor + (2 * borderSize), 95 * resolutionFactor, tocolor(0, 0, 0), (8 * resolutionFactor) + (4 * borderSize))
			dxDrawLine(10 * resolutionFactor, 95 * resolutionFactor, 229 * resolutionFactor, 95 * resolutionFactor, tocolor(255, 0, 0), 8 * resolutionFactor)
			dxDrawLine(10 * resolutionFactor, 95 * resolutionFactor, damage * resolutionFactor, 95 * resolutionFactor, clr, 8 * resolutionFactor)
			
			-- Nitrous Oxide time!			
			if getVehicleUpgradeOnSlot(veh, 8) ~= 0 then
				local nitroLevel = math.floor(getVehicleNitroLevel(veh)*100)
				local nitro = "NOS: ".. tostring(nitroLevel) .. "%"

				if getPlayerTeam(localPlayer) and infNOSTeams[getTeamName(getPlayerTeam(localPlayer))] then
					setVehicleNitroLevel(veh, 1)
					nitroLevel = 100
					nitro = "NOS: ∞"
				end
				
				-- Calculate the color
				local nHue = (nitroLevel / 100) * (1/3)
				local nR, nG, nB = HSV(nHue, 1, 1)
				clr2 = tocolor(nR, nG, nB)
				dxDrawBorderedText(nitro, 0, 0, 230 * resolutionFactor, 40 * resolutionFactor, clr2, 2 * resolutionFactor, "default", "right", "top", true)
			end
			
			dxSetRenderTarget()
		end
		if renderTarget then
			if twoDMode then
				dxDrawImage(scrnX-270, scrnY-130, 230, 100, renderTarget)
			else
				x,y,z,lx,ly,lz,x2,y2,z2 = getPositionFromElementOffset(minX-1.3,0,minX+0.5,-5)	---2.5,0,-1.3,-5
				dxDrawMaterialLine3D(x2,y2,z2,x,y,z, renderTarget, 2.2, clrWhite,lx,ly,lz)
			end
		end
	else
		removeEventHandler("onClientPreRender", root, drawSpeed)
	end
end

function getSpeed()
	if veh then
		local x,y,z = getElementVelocity(veh)
		if mph then
			return (x^2 + y^2 + z^2) ^ 0.5 * 100	--MPH
		else
			return (x^2 + y^2 + z^2) ^ 0.5 * 1.8 * 100	--KPH
		end
	else
		return 0
	end
end

function getPositionFromElementOffset(offX,offY,offX2,offY2)
	local offZ = -0.5
	local m = getElementMatrix ( veh )  -- Get the matrix
	local x = offX * m[1][1] + offY * m[2][1] + offZ * m[3][1] + m[4][1]  -- Apply transform
	local y = offX * m[1][2] + offY * m[2][2] + offZ * m[3][2] + m[4][2]
	local z = offX * m[1][3] + offY * m[2][3] + offZ * m[3][3] + m[4][3]
	
	local x2 = offX2 * m[1][1] + offY2 * m[2][1] + offZ * m[3][1] + m[4][1]  -- Apply transform
	local y2 = offX2 * m[1][2] + offY2 * m[2][2] + offZ * m[3][2] + m[4][2]
	local z2 = offX2 * m[1][3] + offY2 * m[2][3] + offZ * m[3][3] + m[4][3]
	
	offZ = 0.5
	local x3 = offX * m[1][1] + offY * m[2][1] + offZ * m[3][1] + m[4][1]  -- Apply transform
	local y3 = offX * m[1][2] + offY * m[2][2] + offZ * m[3][2] + m[4][2]
	local z3 = offX * m[1][3] + offY * m[2][3] + offZ * m[3][3] + m[4][3]
	
	return x, y, z, x2, y2, z2, x3, y3, z3                            -- Return the transformed point
end

function getType()
	return mph
end

function toggleType()
	mph = not mph
	saveConf()
end
addCommandHandler("speedounit", toggleType)
addCommandHandler("speedotype", function() twoDMode = not twoDMode saveConf() end)

bindKey("vehicle_fire", "both",
function(_,state)
	veh = getPedOccupiedVehicle(localPlayer)
	if veh and state == "up" and isVehicleNitroActivated(veh) and getVehicleController(veh) == localPlayer then
		setVehicleNitroActivated(veh, false)
		nosOn = false
	elseif veh and state == "down" and getVehicleController(veh) == localPlayer then
		setVehicleNitroActivated(veh, true)
		nosOn = true
	end
end)

function HSV(h, s, v)
 
  local r, g, b
 
  local i = math.floor(h * 6)
  local f = h * 6 - i
  local p = v * (1 - s)
  local q = v * (1 - f * s)
  local t = v * (1 - (1 - f) * s)
 
  local switch = i % 6
  if switch == 0 then
    r = v g = t b = p
  elseif switch == 1 then
    r = q g = v b = p
  elseif switch == 2 then
    r = p g = v b = t
  elseif switch == 3 then
    r = p g = q b = v
  elseif switch == 4 then
    r = t g = p b = v
  elseif switch == 5 then
    r = v g = p b = q
  end
 
  return math.floor(r*255), math.floor(g*255), math.floor(b*255)
 
end

function dxDrawBorderedText(text, left, top, right, bottom, color, scale, font, alignX, alignY, clip, wordBreak,postGUI)
    for oX = -borderSize, borderSize do
        for oY = -borderSize, borderSize do
            dxDrawText(text, left + oX, top + oY, right + oX, bottom + oY, tocolor(0, 0, 0, 255), scale, font, alignX, alignY, clip, wordBreak,postGUI)
        end
    end
    dxDrawText(text, left, top, right, bottom, color, scale, font, alignX, alignY, clip, wordBreak, postGUI)
end

if getPedOccupiedVehicle(localPlayer) then toggleSpeed(true) end

setDevelopmentMode(true)