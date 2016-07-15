_permissions = nil

function getPermissions()
	if (exports.UCDaccounts:isPlayerLoggedIn(localPlayer)) then
		triggerServerEvent("UCDadmin.getPermissions", resourceRoot)
	end
end
addEventHandler("onClientResourceStart", resourceRoot, getPermissions)

function onReceivedPermissions(permissions)
	_permissions = permissions or {}
	
	if (permissions[-1]) then
		for i = 1, #adminPanel.button do
			if (adminPanel.button[i]) then
				adminPanel.button[i].enabled = true
			end
		end
	else
		for ind in pairs(_permissions) do
			if (adminPanel.button[ind]) then
				adminPanel.button[ind].enabled = true
			end
		end
	end
	
	addEventHandler("onClientRender", root, updateInformation)
end
addEvent("UCDadmin.onReceivedPermissions", true)
addEventHandler("UCDadmin.onReceivedPermissions", root, onReceivedPermissions)
