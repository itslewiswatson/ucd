Weather = {}
Weather.valid = {
	0, 1, 2, 3, 4, 5, 6, 7, 10, 11, 12, 13, 14, 15, 17, 18
}
Weather.curr = nil
Weather.prev = nil
Weather.time = (20 * 60) * 1000
Weather.offset = (5 * 60) * 1000

function Weather.cycle()
	local i
	repeat
		i = math.random(#Weather.valid)
	until Weather.valid[i] ~= Weather.prev
	
	Weather.prev = Weather.curr
	Weather.curr = Weather.valid[i]
	
	triggerLatentClientEvent(Element.getAllByType("player"), "UCDphone.weather.onCycleChange", resourceRoot, Weather.curr)
	
	Timer(Weather.cycle, math.random(Weather.time - Weather.offset, Weather.time + Weather.offset), 1)
end
Timer(Weather.cycle, Weather.time, 1)

function Weather.getCurrentCycle()
	triggerLatentClientEvent(client, "UCDphone.weather.onCycleChange", resourceRoot, Weather.curr or 10)
end
addEvent("UCDphone.weather.getCurrentCycle", true)
addEventHandler("UCDphone.weather.getCurrentCycle", root, Weather.getCurrentCycle)
