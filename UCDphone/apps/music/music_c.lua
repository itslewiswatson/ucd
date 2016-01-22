Music = {}
Music.stations = 
{
	{"[Hard Dance] Q-Dance", "http://radio.q-dance.nl/q-danceradio.pls"},
	{"[Hardstyle] NERadio Hardstyle", "http://listen.hardstyle.nu/listen.pls"},
	{"[House/Trance] NERadio House/Trance", "http://listen.neradio.fm/listen.pls"},
	{"[Top 40] Power 181", "http://www.181.fm/winamp.pls?station=181-power&file=181-power.pls"},
	{"[Swedish] NERadio Sweden", "http://www.neradio.se/listen.pls"},
}
Music.stationIndex = {}
local stream

function Music.create()
	phone.music = {label = {}, button = {}, gridlist = {}, progress = {}}
	
	phone.music.label["banner"] = guiCreateLabel(19, 89, 271, 17, "Double click on a station to play", false, phone.image["phone_window"])
	guiLabelSetHorizontalAlign(phone.music.label["banner"], "center", false)
	phone.music.gridlist["radio"] = guiCreateGridList(19, 110, 271, 366, false, phone.image["phone_window"])
	guiGridListAddColumn(phone.music.gridlist["radio"], "Station", 0.9)
	phone.music.button["stop"] = guiCreateButton(23, 482, 112, 35, "Stop", false, phone.image["phone_window"])
	phone.music.button["vol_down"] = guiCreateButton(145, 482, 69, 17, "Vol -", false, phone.image["phone_window"])
	phone.music.button["vol_up"] = guiCreateButton(218, 482, 69, 17, "Vol +", false, phone.image["phone_window"])
	phone.music.progress["volume"] = guiCreateProgressBar(145, 501, 142, 16, false, phone.image["phone_window"])
	
	for i, info in ipairs(Music.stations) do
		local row = guiGridListAddRow(phone.music.gridlist["radio"])
		guiGridListSetItemText(phone.music.gridlist["radio"], row, 1, info[1], false, false)
		Music.stationIndex[row] = info[2]
	end
	
	Music.all = {
		phone.music.label["banner"], phone.music.gridlist["radio"], phone.music.button["stop"], phone.music.button["vol_down"], phone.music.button["vol_up"], phone.music.progress["volume"]
	}	
	for _, gui in pairs(Music.all) do
		gui.visible = false
	end
end
Music.create()

function Music.toggle()
	for _, gui in pairs(Music.all) do
		gui.visible = not gui.visible
	end
end

function Music.play()
	local row = guiGridListGetSelectedItem(phone.music.gridlist["radio"])
	if (row and row ~= -1) then
		Music.stop()
		local link = Music.stationIndex[row]
		outputDebugString("Playing "..link)
		stream = Sound(link)
		stream.volume = 0.5
		phone.music.progress["volume"].progress = 50
	end
end
addEventHandler("onClientGUIDoubleClick", phone.music.gridlist["radio"], Music.play, false)
-- Fish Man - One Pound Fish (Danceboy Remix)
-- Coone - Starfuckers
function Music.stop()
	if (stream and isElement(stream)) then
		stream:stop()
		outputDebugString("Stopped radio")
		phone.music.progress["volume"].progress = 0
	end
end
addEventHandler("onClientGUIClick", phone.music.button["stop"], Music.stop, false)

function Music.changeVolume()
	if (not stream or not isElement(stream)) then
		return
	end
	if (source == phone.music.button["vol_down"]) then
		stream.volume = stream.volume - 0.1
	else
		stream.volume = stream.volume + 0.1
	end
	phone.music.progress["volume"].progress = stream.volume * 100
end
addEventHandler("onClientGUIClick", phone.music.button["vol_down"], Music.changeVolume, false)
addEventHandler("onClientGUIClick", phone.music.button["vol_up"], Music.changeVolume, false)

addEventHandler("onClientSoundChangedMeta", root,
	function (streamTitle)
		if (stream and isElement(stream)) then
			if (stream:getMetaTags()["stream_title"] == streamTitle) then
				exports.UCDdx:new("Now playing: "..tostring(streamTitle), 255, 200, 0)
			end
		end
	end
)