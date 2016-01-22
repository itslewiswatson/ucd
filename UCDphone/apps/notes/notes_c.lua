Notes = {}

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
		local f = File("@notes.txt")
		local contents = f:read(f.size)
		phone.notes.memo["notes"].text = contents
	end
end
Notes.create()

function Notes.toggle()
	for _, gui in pairs(Notes.all) do
		gui.visible = not gui.visible
	end
end

-- Save the notes every time the app closes
addEventHandler("onClientGUIClick", phone.button["home"],
	function ()
		if (not File.exists("@notes.txt")) then
			File.new("@notes.txt")
		end
		local f = File("@notes.txt")
		f:write(phone.notes.memo["notes"].text)
		f:flush()
		f:close()
	end, false
)
