Music = {}
Music.stations = 
{
	{"[All] 102.9 Hot Tomato", "http://s4.viastreaming.net:8765/listen.pls"},
	{"[Hard Dance] Q-Dance Radio", "http://radio.q-dance.nl/q-danceradio.pls"},
	{"[Hardstyle] NERadio Hardstyle", "http://listen.hardstyle.nu/listen.pls"},
	{"[House] NERadio House/Trance", "http://listen.neradio.fm/listen.pls"},
	{"[Other] Radio Metro", "http://www.radiometro.com.au/songapp/Radio-Metro.pls"},
	{"[Top 40] Power 181", "http://www.181.fm/winamp.pls?station=181-power&file=181-power.pls"},
	{"[Swedish] NERadio Sweden", "http://www.neradio.se/listen.pls"},
}
Music.trackPlaying = nil
Music.tracks = {
	--[1] = {"Girls' Generation - Gee", "http://music.zorque.xyz/gg/gee.mp3"}
}
Music.open = false

function Music.create()
	phone.music = {tab = {}, staticimage = {}, tabpanel = {}, edit = {}, button = {}, label = {}, gridlist = {}, progress = {}}
	phone.music.tabpanel["all"] = GuiTabPanel(19, 87, 271, 388, false, phone.image["phone_window"])
	
	-- Music
	phone.music.tab["Music"] = GuiTab("Music", phone.music.tabpanel["all"])
	phone.music.gridlist["Music"] = GuiGridList(0, 0, 271, 260, false, phone.music.tab["Music"])
	guiGridListSetSortingEnabled(phone.music.gridlist["Music"], false)
	guiGridListAddColumn(phone.music.gridlist["Music"], "Track", 0.45)
	guiGridListAddColumn(phone.music.gridlist["Music"], "Link", 0.45)
	phone.music.edit["track_title"] = GuiEdit(5, 303, 170, 23, "Title", false, phone.music.tab["Music"])
	phone.music.edit["track_link"] = GuiEdit(5, 331, 170, 23, "Link", false, phone.music.tab["Music"])
	phone.music.button["add_track"] = GuiButton(185, 303, 76, 51, "Add song", false, phone.music.tab["Music"])
	phone.music.button["remove_track"] = GuiButton(95, 270, 76, 23, "Remove", false, phone.music.tab["Music"])
	
	-- Load in from XML file into Music.tracks table
	
	
	-- Create user tracks here if they exist
	
	
	-- Radio
	phone.music.tab["Radio"] = GuiTab("Radio", phone.music.tabpanel["all"])
	phone.music.gridlist["Radio"] = GuiGridList(0, 26, 267, 334, false, phone.music.tab["Radio"])
	guiGridListSetSortingEnabled(phone.music.gridlist["Radio"], false)
	guiGridListAddColumn(phone.music.gridlist["Radio"], "Station", 0.9)
	phone.music.label["banner"] = GuiLabel(0, 0, 271, 22, "Double click on a station to play", false, phone.music.tab["Radio"])
	--phone.music.label["banner"]:setColor(195, 195, 195)
	guiLabelSetHorizontalAlign(phone.music.label["banner"], "center", false)
	guiLabelSetVerticalAlign(phone.music.label["banner"], "center")
	
	for i, info in ipairs(Music.stations) do
		local row = guiGridListAddRow(phone.music.gridlist["Radio"])
		guiGridListSetItemText(phone.music.gridlist["Radio"], row, 1, info[1], false, false)
		guiGridListSetItemColor(phone.music.gridlist["Radio"], row, 1, 0, 255, 0)
	end
	
	-- Shared
	phone.music.button["stop"] = GuiButton(23, 482, 112, 35, "Stop", false, phone.image["phone_window"])
	phone.music.button["vol_down"] = GuiButton(145, 482, 69, 17, "Vol -", false, phone.image["phone_window"])
	phone.music.button["vol_up"] = GuiButton(218, 482, 69, 17, "Vol +", false, phone.image["phone_window"])
	phone.music.progress["volume"] = GuiProgressBar(145, 501, 142, 16, false, phone.image["phone_window"])
	
	Music.all = {
		phone.music.tabpanel["all"], phone.music.button["stop"], phone.music.button["vol_down"], phone.music.button["vol_up"], phone.music.progress["volume"]
	}
	for _, gui in pairs(Music.all) do
		gui.visible = false
	end
end
Music.create()

function Music.toggle()
	for _, gui in pairs(Music.all) do
		gui.visible = not gui.visible
		Music.open = gui.visible
	end
end

function Music.loadUserTracks()
	phone.music.gridlist["Music"]:clear()
	if ((track and isElement(track)) or (stream and isElement(stream))) then
		Music.stop()
	end
	for i = 1, #Music.tracks do
		local row = guiGridListAddRow(phone.music.gridlist["Music"])
		guiGridListSetItemText(phone.music.gridlist["Music"], row, 1, tostring(Music.tracks[i][1]), false, false)
		guiGridListSetItemText(phone.music.gridlist["Music"], row, 2, tostring(Music.tracks[i][2]), false, false)
	end
end

function Music.stop()
	if (stream and isElement(stream)) then
		stream:stop()
		outputDebugString("Stopped radio")
	end
	if (track and isElement(track)) then
		track:stop()
		outputDebugString("Stopped track")
		Music.trackPlaying = nil
	end
	exports.UCDdx:del("music")
	for i = 0, guiGridListGetRowCount(phone.music.gridlist["Radio"]) - 1 do
		guiGridListSetItemColor(phone.music.gridlist["Radio"], i, 1, 0, 255, 0)
	end
end
addEventHandler("onClientGUIClick", phone.music.button["stop"], Music.stop, false)

function Music.play()
	if (source == phone.music.gridlist["Radio"]) then
		local row = guiGridListGetSelectedItem(phone.music.gridlist["Radio"])
		if (row and row ~= -1) then
			Music.stop()
			local link = Music.stations[row + 1][2]
			if (not Music.volume) then
				Music.volume = 0.5
			end
			outputDebugString("Playing "..link)
			stream = Sound(link)
			stream.volume = Music.volume
			phone.music.progress["volume"].progress = Music.volume * 100 --// 0.5 -> 50
			
			guiGridListSetItemColor(phone.music.gridlist["Radio"], row, 1, 255, 200, 0)
		end
	else
		local row = guiGridListGetSelectedItem(phone.music.gridlist["Music"])
		if (row and row ~= -1) then
			Music.stop()
			local link = guiGridListGetItemText(phone.music.gridlist["Music"], row, 2)
			local name = guiGridListGetItemText(phone.music.gridlist["Music"], row, 1)
			if (link) then
				outputDebugString("Playing "..link)
				track = Sound(link, true)
				if (track) then
					if (not Music.volume) then
						Music.volume = 0.5
					end
					Music.trackPlaying = row + 1
					track.volume = Music.volume
					phone.music.progress["volume"].progress = Music.volume * 100 --// 0.5 -> 50
				else
					outputDebugString("Error in Music.play - couldn't resolve Sound(link)")
				end
			end
		end
	end
end
addEventHandler("onClientGUIDoubleClick", phone.music.gridlist["Radio"], Music.play, false)
addEventHandler("onClientGUIDoubleClick", phone.music.gridlist["Music"], Music.play, false)

function Music.changeVolume()
	local m
	if (stream and isElement(stream)) then
		m = stream
	elseif (track and isElement(track)) then
		m = track
	else
		outputDebugString("Nothing playing")
		return
	end
	
	if (source == phone.music.button["vol_down"]) then
		if ((math.floor(m.volume * 100) / 100) - 0.1 < 0) then
			return
		end
		m.volume = m.volume - 0.1
	else
		if ((math.floor(m.volume * 100) / 100) + 0.1 > 1) then
			return
		end
		m.volume = m.volume + 0.1
	end
	phone.music.progress["volume"].progress = m.volume * 100
	Music.volume = m.volume
end
addEventHandler("onClientGUIClick", phone.music.button["vol_down"], Music.changeVolume, false)
addEventHandler("onClientGUIClick", phone.music.button["vol_up"], Music.changeVolume, false)

function Music.onStreamTitleChange(title)
	if (stream and isElement(stream) and source == stream) then
		--outputDebugString("title > "..tostring(title))
		--outputDebugString("stream_title > "..tostring(stream:getMetaTags()["stream_title"]))
		if (stream:getMetaTags()["stream_title"] == title) then
			--exports.UCDdx:new("Now playing: "..tostring(title), 255, 200, 0)
			exports.UCDdx:add("music", tostring(title), 255, 200, 0)
			--phone.music.label["banner"].text = tostring(title) -- I would put 'Now playing'at the start, but it clips off the phone
			--phone.music.label["banner"]:setColor(255, 200, 0)
		end
	end
end
addEventHandler("onClientSoundChangedMeta", root, Music.onStreamTitleChange)

function Music.onPlayerUserTrack(suc)
	if (track and isElement(track) and source == track) then
		if (Music.trackPlaying) then
			local name = Music.tracks[Music.trackPlaying][1]
			if (suc) then
				--exports.UCDdx:new("Now playing: "..tostring(name), 255, 200, 0)
				exports.UCDdx:add("music", tostring(name), 255, 200, 0)
			else
				exports.UCDdx:new("Failed to play: "..tostring(name), 255, 200, 0)
				Music.stop()
			end
		end
	end
end
addEventHandler("onClientSoundStream", root, Music.onPlayerUserTrack) -- Maybe add in Music.play instead?

function Music.cacheTracks()
	local f
	if (not File.exists("@usertracks.xml")) then
		f = XML("@usertracks.xml", "tracks")
	else
		f = XML.load("@usertracks.xml")
	end
	local tracks = f:getChildren()
	for i, v in ipairs(tracks) do
		local title, link = v:getAttribute("title"), v:getAttribute("link")
		table.insert(Music.tracks, {title, link})
	end
	f:saveFile()
	f:unload()
	Music.loadUserTracks()
end
Music.cacheTracks()

function Music.addTrack()
	local title = phone.music.edit["track_title"].text
	local link = phone.music.edit["track_link"].text
	
	if (title:gsub(" ", "") == "" or title:gsub(" ", ""):lower() == "title") then
		exports.UCDdx:new("Please enter a title for this track", 255, 0, 0)
		return
	end
	if (link:gsub(" ", "") == "" or link:gsub(" ", ""):lower() == "link") then
		exports.UCDdx:new("Please enter a link for this track", 255, 0, 0)
		return
	end
	if (link:sub(1, 7) ~= "http://" and link:sub(1, 8) ~= "https://") then
		exports.UCDdx:new("Links must start with 'http://' or 'https://'", 255, 0, 0)
		return
	end
	
	link = link:gsub(" ", "%20")
	
	if (track and isElement(track)) then
		Music.stop()
	end
	
	table.insert(Music.tracks, {title, link})
	
	local f = XML.load("@usertracks.xml")
	local newTrack = f:createChild("track")
	newTrack:setAttribute("title", tostring(title))
	newTrack:setAttribute("link", tostring(link))
	
	f:saveFile()
	f:unload()
	
	Music.loadUserTracks()
end
addEventHandler("onClientGUIClick", phone.music.button["add_track"], Music.addTrack, false)

function Music.removeTrack()
	local row = guiGridListGetSelectedItem(phone.music.gridlist["Music"])
	if (row and row ~= -1) then
		-- Only stop playing if there is a track playing, not a radio stream
		if (track and isElement(track)) then
			Music.stop()
		end
		
		table.remove(Music.tracks, row + 1)
		
		-- Unload node from file
		local f = XML.load("@usertracks.xml")
		if (not f) then
			outputDebugString("fuck xml")
			return false
		end
		
		f:getChildren()[row + 1]:destroy()
		f:saveFile()
		f:unload()
		
		Music.loadUserTracks()
	else
		exports.UCDdx:new("You must select a track to remove", 255, 0, 0)
	end
end
addEventHandler("onClientGUIClick", phone.music.button["remove_track"], Music.removeTrack, false)
