Notes = {}
Notes.open = false

function Notes.create()
	phone.notes = {memo = {}}
	
	phone.notes.memo["notes"] = GuiMemo(18, 95, 274, 434, "", false, phone.image["phone_window"])
	
	Notes.all = {
		phone.notes.memo["notes"]
	}
	
	for _, gui in pairs(Notes.all) do
		gui.visible = false
	end
	
	-- Load the notes in when the resource starts
	if (File.exists("@notes.txt")) then
		local f = File("@notes.txt", true)
		local contents = f:read(f.size)
		phone.notes.memo["notes"].text = contents
		f:close()
	else
		phone.notes.memo["notes"].text = ""
	end
end
Notes.create()

function Notes.toggle()
	for _, gui in pairs(Notes.all) do
		gui.visible = not gui.visible
		Notes.open = gui.visible
	end
end

-- Save the notes every time the app closes
addEventHandler("onClientGUIClick", phone.button["home"],
	function ()
		if (not isHomeScreenOpen()) then
			Notes.save()
		end
	end, false, "high"
)

function Notes.save()
	if (File.exists("@notes.txt")) then
		File.delete("@notes.txt")
	end
	local f = File.new("@notes.txt")
	f:write(phone.notes.memo["notes"].text)
	f:flush()
	f:close()
end
addEventHandler("onClientResourceStop", resourceRoot, Notes.save)
