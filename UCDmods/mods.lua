function fetchMods()
	triggerServerEvent("UCDmods.requestMods", resourceRoot)
end
addEventHandler("onClientResourceStart", resourceRoot, fetchMods)

function onReceivedModList(list)
	local toDownload = {}
	for _, data in ipairs(list) do
		if (not File.exists(":UCDmods/"..data[1])) then
			table.insert(toDownload, data[1]) -- File doesn't exist, download
			--outputDebugString("[exist] Inserting "..tostring(data[1]))
		else
			local f = File(":UCDmods/"..data[1])
			f.pos = 0
			local fileData = f:read(f.size)
			if (hash("md5", fileData):lower() ~= data[3]:lower()) then -- If the hashes do not match (hashes are a mix of lower and upper case for some reason)
				table.insert(toDownload, data[1])
				--outputDebugString("[md5] Inserting "..tostring(data[1]))
			else
				-- We have the file and it's correct, apply it
				applyMod(data[1], data[4])
			end
			f:close()
		end
	end
	triggerServerEvent("UCDmods.requestDownload", resourceRoot, toDownload)
	exports.UCDdx:add("ucdmods", "UCDmods - Downloading "..tostring(#toDownload).." items",  200, 0, 200)
end
addEvent("UCDmods.onReceivedModList", true)
addEventHandler("UCDmods.onReceivedModList", root, onReceivedModList)

function onCompleteDownload(mods, left)
	--outputDebugString("Completed download - "..tostring(#mods).." items")
	exports.UCDdx:add("ucdmods", "UCDmods - Downloading "..tostring(left).." items", 200, 0, 200)
	if (left <= 0) then
		exports.UCDdx:add("ucdmods", "UCDmods - Download complete", 200, 0, 200)
		Timer(
			function ()
				exports.UCDdx:del("ucdmods")
			end, 5000, 1
		)
		return
	else
		triggerServerEvent("UCDmods.requestDownload", resourceRoot)
	end
	local data = mods
	--for i, data in ipairs(mods) do
		local path = data[1]
		local f = File.new(path)
		f.pos = 0
		f:write(data[2])
		f:flush()
		f:close()
		applyMod(path, data[3])
	--end
end
addEvent("UCDmods.download", true)
addEventHandler("UCDmods.download", root, onCompleteDownload)

function applyMod(name, id)
	outputDebugString("Applying "..tostring(name).." on id "..tostring(id))
	if (name:match("txd")) then
		engineImportTXD(engineLoadTXD(name, true), id)
	else
		engineReplaceModel(engineLoadDFF(name, id), id)
	end
end
