netstats = {
    tab = {},
    window = {},
    tabpanel = {},
    label = {},
	button = {}
}

function convertBytes(bytes)
	bytes = tonumber(bytes)
    return bytes / 1024
end

addEvent("ipAddress", true)
addEventHandler("ipAddress", root, 
	function (playerIP)
		guiSetText(netstats.label[22], ""..tostring(playerIP..""))
	end
)

function actualStatistics()

	local sentBytes = getNetworkStats()["bytesSent"]
	local sentMegabytes = convertBytes(sentBytes)
	local finalSent = exports.UCDutil:tocomma(exports.UCDutil:mathround(sentMegabytes, 2))
	
	local receivedBytes = getNetworkStats()["bytesReceived"]
	local receivedMegabytes = convertBytes(receivedBytes)
	local finalReceived = exports.UCDutil:tocomma(exports.UCDutil:mathround(receivedMegabytes, 2))
	
	-- Network statistics
	guiSetText(netstats.label[11], ""..tostring(getPlayerPing(localPlayer)).." ms")
	guiSetText(netstats.label[12], ""..tostring(getNetworkStats()["packetlossLastSecond"]).."")
	guiSetText(netstats.label[13], ""..tostring(getNetworkStats()["packetlossTotal"]).."")
	guiSetText(netstats.label[14], ""..tostring(finalReceived).." MB")
	guiSetText(netstats.label[15], ""..tostring(finalSent).." MB") -- Converted the bytes to use commas.
	guiSetText(netstats.label[18], ""..tostring(getNetworkStats()["packetsReceived"]).."")
	guiSetText(netstats.label[19], ""..tostring(getNetworkStats()["packetsSent"]).."")
	--guiSetText(netstats.label[22], ""..tostring(getElementData(localPlayer, "IP").."")) -- We don't need the IP here as it will not update at all during connection with the server
	
	-- Performance statistics
	guiSetText(netstats.label[16], ""..tostring(dxGetStatus()["VideoCardName"]).."")
	guiSetText(netstats.label[17], ""..tostring(dxGetStatus()["VideoCardRAM"]).." MB")
	guiSetText(netstats.label[20], ""..tostring(dxGetStatus()["VideoMemoryFreeForMTA"]).." MB")
end

netstats.window[1] = guiCreateWindow(357, 115, 363, 332, "Network and Computer Performance Stats", false)
guiWindowSetSizable(netstats.window[1], false)
guiSetVisible(netstats.window[1], false)
exports.UCDutil:centerWindow(netstats.window[1])

netstats.label[1] = guiCreateLabel(19, 21, 84, 20, "Ping:", false, netstats.window[1])
netstats.label[2] = guiCreateLabel(19, 45, 140, 15, "Packet loss (last second):", false, netstats.window[1])
netstats.label[3] = guiCreateLabel(19, 65, 108, 19, "Packet loss (total):", false, netstats.window[1])
netstats.label[4] = guiCreateLabel(19, 84, 140, 15, "Downloaded (bytes):", false, netstats.window[1])
netstats.label[5] = guiCreateLabel(19, 103, 140, 15, "Uploaded (bytes):", false, netstats.window[1])
netstats.label[6] = guiCreateLabel(19, 124, 140, 15, "Packets received:", false, netstats.window[1])
netstats.label[7] = guiCreateLabel(19, 144, 140, 15, "Packets sent:", false, netstats.window[1])
netstats.label[8] = guiCreateLabel(19, 184, 140, 15, "Graphics card:", false, netstats.window[1])
netstats.label[9] = guiCreateLabel(19, 204, 140, 15, "VRAM:", false, netstats.window[1])
netstats.label[10] = guiCreateLabel(19, 225, 140, 15, "VRAM available:", false, netstats.window[1])
netstats.label[21] = guiCreateLabel(19, 164, 140, 15, "IP Address:", false, netstats.window[1])

netstats.label[11] = guiCreateLabel( 165, 21, 179, 20, "", false, netstats.window[1]) -- Player ping
netstats.label[12] = guiCreateLabel(165, 45, 179, 20, "", false, netstats.window[1]) -- Packets lost in the last second
netstats.label[13] = guiCreateLabel(165, 64, 179, 20, "", false, netstats.window[1]) -- Packets lost since connecting
netstats.label[14] = guiCreateLabel(165, 83, 179, 16, "", false, netstats.window[1]) -- Bytes downloaded
netstats.label[15] = guiCreateLabel(165, 103, 179, 16, "", false, netstats.window[1]) -- Bytes uploaded

netstats.label[16] = guiCreateLabel(165, 183, 179, 16, "", false, netstats.window[1]) -- GPU name
netstats.label[17] = guiCreateLabel(165, 204, 179, 15, "", false, netstats.window[1]) -- VRAM

netstats.label[18] = guiCreateLabel(165, 123, 179, 16, "", false, netstats.window[1]) -- Packets received
netstats.label[19] = guiCreateLabel(165, 143, 179, 16, "", false, netstats.window[1]) -- Packets sent

netstats.label[20] = guiCreateLabel(165, 224, 179, 16, "", false, netstats.window[1]) -- VRAM available for MTA to use.
netstats.label[22] = guiCreateLabel(165, 164, 179, 15, "", false, netstats.window[1]) -- IP address

netstats.button[1] = guiCreateButton(198, 268, 146, 40, "Close", false, netstats.window[1])
netstats.button[2] = guiCreateButton(19, 268, 146, 40, "Refresh", false, netstats.window[1])

function setStatWindowOpen()
	if (guiGetVisible(netstats.window[1]) ~= true) then
		triggerServerEvent("getIP", localPlayer)
		guiSetVisible(netstats.window[1], true)
		showCursor(true)
		actualStatistics()
		refreshTimer = setTimer(actualStatistics, 1000, 0)
	else
		guiSetVisible(netstats.window[1], false)
		showCursor(false)
		killTimer(refreshTimer)
	end
end
addCommandHandler("netstats", setStatWindowOpen)

function manageUI(button, _, _, _)
	if (button == "left") and (source == netstats.button[1]) then
		guiSetVisible(netstats.window[1], false)
		showCursor(false)
		killTimer(refreshTimer)
	elseif (source == netstats.button[2]) and (button == "left") then
		actualStatistics()
	end
end
addEventHandler("onClientGUIClick", guiRoot, manageUI)