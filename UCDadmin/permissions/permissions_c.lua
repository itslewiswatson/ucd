_permissions = nil

function getPermissions()
	if (exports.UCDaccounts:isPlayerLoggedIn(localPlayer)) then
		triggerServerEvent("UCDadmin.getPermissions", resourceRoot)
	end
end
addEventHandler("onClientResourceStart", resourceRoot, getPermissions)

function isEventHandlerAdded(eventName, attachedTo, func)
	for _, _func in ipairs(getEventHandlers(eventName, attachedTo)) do
		if func == _func then
			return true
		end
	end
	return false
end

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
	if (not isEventHandlerAdded("onClientRender", root, updateInformation)) then
		addEventHandler("onClientRender", root, updateInformation)
	end
end
addEvent("UCDadmin.onReceivedPermissions", true)
addEventHandler("UCDadmin.onReceivedPermissions", root, onReceivedPermissions)
