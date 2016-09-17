local ped = createPed(271, 296, -41, 1001, 1)
setElementInterior(ped, 1)
 
function pedOptimizations()
   
    cancelEvent()
end
addEventHandler("onClientPedDamage", ped, pedOptimizations)
 
function startRobbery(target)
    if target and getElementType(target) == "ped" then 
        if getPlayerTeam(localPlayer) and getTeamName(getPlayerTeam(localPlayer)) == "Criminals" and getControlState("aim_weapon") then
        end
    end
end
addEventHandler("onClientPlayerTarget", localPlayer, startRobbery)