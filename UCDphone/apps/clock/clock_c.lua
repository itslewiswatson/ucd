Clock = {}
Clock.open = false
Clock.data = 
{
	weekdays =
	{
		[0] = "Sunday", [1] = "Monday", [2] = "Tuesday", [3] = "Wednesday", [4] = "Thursday", [5] = "Friday", [6] = "Saturday"
	},
	months =
	{
		[0] = "January", [1] = "February", [2] = "March", [3] = "April", [4] = "May", [5] = "June", [6] = "July", [7] = "August", [8] = "September", [9] = "October", [10] = "November", [11] = "December"
	},
	nums = 
	{
		[1] = "st", [2] = "nd", [3] = "rd", [21] = "st", [22] = "nd", [23] = "rd", [31] = "st",
	},
}

function Clock.create()
	phone.clock = {label = {}}
	
	phone.clock.label["hms"] = GuiLabel(19, 106, 271, 18, "13:12:00", false, phone.image["phone_window"])
	phone.clock.label["weekday"] = GuiLabel(19, 134, 271, 18, "Monday", false, phone.image["phone_window"])
	phone.clock.label["formatted_date"] = GuiLabel(19, 162, 271, 18, "29th January, 2016", false, phone.image["phone_window"])
	phone.clock.label["date"] = GuiLabel(19, 190, 271, 18, "29/01/2016", false, phone.image["phone_window"])
	
	Clock.all = {
		phone.clock.label["hms"], phone.clock.label["weekday"], phone.clock.label["formatted_date"], phone.clock.label["date"]
	}
	for _, gui in pairs(Clock.all) do
		gui.visible = false
		guiLabelSetHorizontalAlign(gui, "center", false)
	end
end
Clock.create()

function Clock.toggle()
	for _, gui in pairs(Clock.all) do
		gui.visible = not gui.visible
		Clock.open = gui.visible
	end
	if (phone.clock.label["hms"].visible) then
		Clock.update()
		Clock.timer = Timer(Clock.update, 100, 0)
	else
		if (Clock.timer and Clock.timer.valid) then
			Clock.timer:destroy()
		end
	end
end

function Clock.update()
	local time = getRealTime()
	
	local year = time.year + 1900
	local month = time.month
	local monthday = time.monthday
	local suffix, month_
	if (Clock.data.nums[monthday]) then
		suffix = Clock.data.nums[monthday]
	else
		suffix = "th"
	end
	phone.clock.label["formatted_date"].text = monthday..suffix.." "..Clock.data.months[month]..", "..year
	month_ = month + 1
	if (month_ < 10) then
		month_ = "0"..month_
	end
	phone.clock.label["date"].text = monthday.."/"..month_.."/"..year
	
	local weekday = Clock.data.weekdays[time.weekday]
	phone.clock.label["weekday"].text = tostring(weekday)
	
	local h = time.hour
	local m = time.minute
	local s = time.second
	if (h < 10) then
		h = "0"..h
	end
	if (m < 10) then
		m = "0"..m
	end
	if (s < 10) then
		s = "0"..s
	end
	phone.clock.label["hms"].text = tostring(h..":"..m..":"..s)
end
Clock.update()