-------------------------------------------------------------------
--// PROJECT: N/A
--// RESOURCE: blips
--// DEVELOPER(S): Lewis Watson (Noki)
--// DATE: 06.02.2015
--// PURPOSE: A player blip resource for the MTA community.
--// FILE: blips\playerBlips.lua [server]
-------------------------------------------------------------------

local blip = {}
local blipViewDistance = 1000 -- This is the distance you are able to view blips, default 1000
local showBlipOnDeath = false -- Set this to true to see dead player's blips, false to not. Default false. 

function isPlayerBlipShowing(plr)
	if (not plr) then return nil end
	if (getElementType(plr) ~= "player") then
		return false
	end
	
	if (blip[plr]) then
		return true
	else
		return false
	end
end

function hidePlayerBlip(plr)
	if (not plr) then return nil end
	if (getElementType(plr) ~= "player") then
		return false
	end
	
	if (blip[plr]) then
		if (not isPedDead(plr)) then
			if (getElementAlpha(plr) == 0) then
				-- Invisible, and probably for a reason.
				return "ayy"
			else
				local hide = setElementData(plr, "UCDblips.hidden", true)
				blip[plr] = nil
				if (hide == true) then	
					return true
				end
			end
		else
			return ":("
		end
	else
		-- There are no blips
		return "swag"
	end
end

-- Need to rewrite this function with proper checks
function unhidePlayerBlip(plr)
	if (not plr) then return nil end
	if (getElementType(plr) ~= "player") then
		return false
	end
	
	if (blip[plr]) then
		-- They have a blip, you cannot unhide it
		return false
	else 
		if (getElementData(plr, "UCDblips.hidden") == true) then
			local hidePlr = setElementData(plr, "UCDblips.hide", false)
			if (hidePlr) then
				return true
			else
				return false
			end
		end
	end
end

function applyBlips()
  	for k, player in pairs(getElementsByType("player")) do
		if isPedDead(player) then return end
		if (getElementData(player, "UCDblips.hidden") == true) then return false end
		
		local r, g, b = getPlayerNametagColor(player)
		if not blip[player] then
			blip[player] = createBlipAttachedTo(player, 0, 2, r, g, b, 255, 0, blipViewDistance)
		else
			setBlipColor(blip[player], r, g, b, 255)
		end
	end
end
addEventHandler("onResourceStart", resourceRoot, applyBlips)
setTimer(applyBlips, 500, 0) -- This is to account for name tag colour changes, especially in RPG servers.

function createBlips()
	if (source) then player = source end
	if (getElementData(player, "UCDblips.hidden") == true) then return false end
	
	local r, g, b = getPlayerNametagColor(player)
	if not blip[player] then
		blip[player] = createBlipAttachedTo(player, 0, 2, r, g, b, 255, 0, blipViewDistance)
	else
		setBlipColor(blip[player], r, g, b, 255)
	end
end
addEventHandler("onPlayerSpawn", root, createBlips)

function destroyBlip()
	if (source) then player = source end
	if (blip[player] and isElement(blip[player])) then
		destroyElement(blip[player])
		blip[player] = nil
	end
end
addEventHandler("onPlayerQuit", root, destroyBlip)

function destBlips()
	if (not showBlipOnDeath) then
		destroyBlip(source)
	else
		return -- We don't need to do anything here, just return
	end
end
addEventHandler("onPlayerWasted", root, destBlips)
