-- Warp panel by HellStunter
function toggleWPGUI(thePlayer)
	if (not exports.UCDaccounts:isPlayerLoggedIn(thePlayer)) then return end
   if (isPlayerAdmin(thePlayer) and thePlayer.team.name == "Admins") then
        triggerClientEvent(thePlayer, "UCDadmin.onToggleWPGUI", resourceRoot)
   end
end
addCommandHandler("wp", toggleWPGUI)