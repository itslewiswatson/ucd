--[[addEventHandler("onClientResourceStart", resourceRoot,
	function ()
		if (not localPlayer:getData("accountName")) then
			triggerServerEvent("UCDadmin.banCheck", resourceRoot)
		end
	end
)--]]

function banScreen(banData)
	--exports.UCDdx:add("ban", "YOU BANNED HAHAH NIGGA", 255, 0, 0)
	
end
addEvent("UCDadmin.banScreen", true)
addEventHandler("UCDadmin.banScreen", root, banScreen)