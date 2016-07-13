local mods = {
	{"staff.txd", 217, "skins"},
	{"staff.dff", 217, "skins"},
	{"275.txd", 275, "skins"},
	{"275.dff", 275, "skins"},
	{"66.txd", 66, "skins"},
	{"66.dff", 66, "skins"},
	
	{"hydra.dff", 520, "vehicles"},
	{"shamal.dff", 519, "vehicles"},
	{"seaspar.dff", 447, "vehicles"},
	{"infernus.txd", 411, "vehicles"},
	{"infernus.dff", 411, "vehicles"},
	
	{"wheels.txd", 1074, "wheels"},
	{"wheel_gn1.dff", 1074, "wheels"},
}
local mods2  = {}
local bytes = 0
local pending = {}

function cacheMods()
	--for _, ent in pairs(mods) do
		for _, data in ipairs(mods) do
			local type_ = data[3]
			local fname = data[1]
			local id = data[2]
			local path = data[3].."/"..data[1]
			local f = File(path)
			if (f) then
				bytes = bytes + f.size
				f.pos = 0
				local modData = f:read(f.size)
				local modHash = hash("md5", modData)
				table.insert(mods2, {path, type_, modData, modHash, id}) -- path, modData, modHash, type, id
				f:close()
			else
				outputDebugString("Can't find file '"..tostring(path).."'")
			end
		end
	--end
	outputDebugString(tostring(bytes / 1000000).."mb")
end
addEventHandler("onResourceStart", resourceRoot, cacheMods)

function sendMods(plr)
	local temp = {}
	for _, data in ipairs(mods2) do
		table.insert(temp, {data[1], data[2], data[4], data[5]}) -- path, hash, type
	end
	triggerLatentClientEvent(plr, "UCDmods.onReceivedModList", plr, temp)
end

function requestDownload(list)
	if (not pending[client]) then
		local temp = {}
		for k, v in ipairs(list or {}) do
			for _, data in ipairs(mods2) do
				if (data[1] == v) then
					table.insert(temp, {data[1], data[3], data[5]})
				end
			end
		end
		outputDebugString("requestDownload -> "..tostring(#temp).." items")
		pending[client] = temp
		triggerLatentClientEvent(client, "UCDmods.download", 500000, false, client, temp[1], #temp)
	else
		-- exports.UCDdx:add(client, "ucdmods", "UCDmods - Downloading "..tostring(#temp).." items",  200, 144, 0)
		triggerLatentClientEvent(client, "UCDmods.download", 500000, false, client, pending[client][1], #pending[client])
	end
	table.remove(pending[client], 1)
	if (#pending[client] == 0) then
		pending[client] = nil
	end
end
addEvent("UCDmods.requestDownload", true)
addEventHandler("UCDmods.requestDownload", root, requestDownload)

function requestMods()
	if (#mods2 == 0) then
		-- mods haven't been cached, wait
		Timer(sendMods, 1000, 1, client)
	else
		sendMods(client)
	end
end
addEvent("UCDmods.requestMods", true)
addEventHandler("UCDmods.requestMods", root, requestMods)

addEventHandler("onPlayerQuit", root,
	function ()
		if (pending[client]) then
			pending[client] = nil
		end
	end
)
