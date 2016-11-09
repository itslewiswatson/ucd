addEvent("onClientPlayerGetJob", true)
addEventHandler("onClientPlayerGetJob", root, 
	function (jobName)
		adminDX(jobName)
	end
)

addEventHandler("onClientResourceStart", resourceRoot,
	function ()
		if (exports.UCdaccounts:isPlayerLoggedIn(localPlayer)) then
			adminDX(localPlayer:getData("Occupation"))
		end
	end
)

addEventHandler("onClientPlayerLogin", root,
	function ()
		if (source == localPlayer) then
			adminDX(localPlayer:getData("Occupation"))
		end
	end
)

function adminDX(jobName)
	--if (source == localPlayer) then
		if (jobName and (jobName == "Admin" or jobName:match("Admin") == "Admin")) then
			exports.UCDdx:add("admin", tostring(localPlayer:getData("Occupation")), 255, 255, 255, 1)
		else
			exports.UCDdx:del("admin")
		end
	--end
end
