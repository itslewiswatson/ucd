function updateSpecificResource(res, no)
	if (source and res and no) then
		-- Get table of devs, for now just source
		--triggerClientEvent(source, "UCDadmin.updateSpecificResource", source, )
	end
end
addEvent("UCDadmin.updateSpecificResource")
addEventHandler("UCDadmin.updateSpecificResource", root, updateSpecificResource)

function restartResource_(name, no)
	if (client and name and no and isPlayerAdmin(client)) then
		local res = Resource.getFromName(name)
		if (res.state ~= "running" and res.state ~= "starting") then
			exports.UCDdx:new(client, name.." is not running", 255, 255, 0)
			return
		end
		local res_ = res:restart()
		if (not res_) then
			exports.UCDdx:new(client, name.." was unable to restart", 255, 255, 0)
			return
		end
		exports.UCDdx:new(client, name.." has been restarted", 0, 255, 0)
	end
end
addEvent("UCDadmin.restartResource", true)
addEventHandler("UCDadmin.restartResource", root, restartResource_)

function startResource_(name, no)
	if (client and name and no and isPlayerAdmin(client)) then
		local res = Resource.getFromName(name)
		if (res.state == "running" or res.state == "starting") then
			exports.UCDdx:new(client, name.." is already running or has been started", 255, 255, 0)
			return
		elseif (res.state == "failed to load") then
			exports.UCDdx:new(client, name.." has failed to load", 255, 255, 0)
			return
		elseif (res.state == "stopping") then
			exports.UCDdx:new(client, name.." is stopping", 255, 255, 0)
			return
		end
		local res_ = res:start(true)
		if (not res_) then
			exports.UCDdx:new(client, name.." was unable to start", 255, 255, 0)
			return
		end
		exports.UCDdx:new(client, name.." has been started", 0, 255, 0)
		-- Send a callback to the client to update the resource
	end
end
addEvent("UCDadmin.startResource", true)
addEventHandler("UCDadmin.startResource", root, startResource_)

function stopResource_(name, no)
	if (client and name and no and isPlayerAdmin(client)) then
		local res = Resource.getFromName(name)
		if (res.state == "stopped" or res.state ~= "running") then
			exports.UCDdx:new(client, name.." is not running", 255, 255, 0)
			return
		end
		local res_ = res:stop()
		if (not res_) then
			exports.UCDdx:new(client, name.." was unable to stop", 255, 255, 0)
			return
		end
		exports.UCDdx:new(client, name.." has been stopped", 0, 255, 0)
		-- Send a callback to the client to update the resource
	end
end
addEvent("UCDadmin.stopResource", true)
addEventHandler("UCDadmin.stopResource", root, stopResource_)
