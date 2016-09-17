-- Warp points by HellStunter
function serverShowGUI(thePlayer)
   if (isPlayerAdmin(thePlayer) and thePlayer.team.name == "Admins") then
        triggerClientEvent(thePlayer, "showGUI", thePlayer)
   end
end
addCommandHandler("wp", serverShowGUI)