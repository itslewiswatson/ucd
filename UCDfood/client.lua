local sX, sY = guiGetScreenSize()

GUIEditor = {button = {}, window = {}, staticimage = {}}
GUIEditor.window[1] = GuiWindow((sX / 2) - (444 / 2), sY - 227, 444, 227, "", false)
GUIEditor.window[1].sizable = false
GUIEditor.window[1].visible = false
GUIEditor.button[1] = GuiButton(10, 160, 135, 24, "$20", false, GUIEditor.window[1])
GUIEditor.button[2] = GuiButton(155, 160, 135, 24, "$50", false, GUIEditor.window[1])
GUIEditor.button[3] = GuiButton(300, 160, 135, 24, "$100", false, GUIEditor.window[1])
GUIEditor.button[4] = GuiButton(313, 194, 122, 23, "Close", false, GUIEditor.window[1])

function disablePedDamage()
	cancelEvent()
end
function onHitMarker(plr, matchingDimension)
	if (plr == localPlayer and matchingDimension) then
		toggleGUI(plr.interior)
	end
end

local foodInfo = 
{
	[9] = 
	{
		title = "Cluckin' Bell",
		meals = {"Cluckin' Nuggets", "Cluckin' Burger", "Cluckin' Deluxe"},
		key = "cluckin",
	},
	[5] = 
	{
		title = "Well Stacked Pizza Co.",
		meals = {"Hawaiian Pizza", "Meatlovers Pizza", "Supreme Pizza"},
		key = "pizza",
	},
	[10] = 
	{
		title = "Burger Shot",
		meals = {"Happy Meal", "Whopper Combo", "Full Stack"},
		key = "burger",
	},
}
local prices = {[1] = 20, [2] = 50, [3] = 100}
local peds = 
{
	-- Cluckin' Bell
	{x = 370.8895, y = -4.4927, z = 1001.8589, rot = 175, ped = 167, dimRange = {12000, 12011}, interior = 9},
	-- Well Stacked Pizza Co.
	{x = 376.7075, y = -117.2782, z = 1001.4922, rot = 175, ped = 155, dimRange = {12000, 12008}, interior = 5},
	-- Burger Shot
	{x = 376.4685, y = -65.8479, z = 1001.5078, rot = 180, ped = 205, dimRange = {12000, 12009}, interior = 10},
}
for _, info in ipairs(peds) do
	for i = info.dimRange[1], info.dimRange[2] do
		local ped = createPed(info.ped, info.x, info.y, info.z, info.rot)
		ped.dimension = i
		ped.interior = info.interior
		ped.frozen = true
		addEventHandler("onClientPedDamage", ped, disablePedDamage)
	end
end

local markers = 
{
	-- Cluckin' Bell
	{x = 370.9452, y = -6.2, z = 1001.8589, dimRange = {12000, 12011}, interior = 9},
	-- Well Stacked Pizza Co.
	{x = 376.7208, y = -118.96, z = 1001.4995, dimRange = {12000, 12008}, interior = 5},
	-- Burger Shot
	{x = 376.4685, y = -67.6, z = 1001.5151, dimRange = {12000, 12009}, interior = 10},
}
for _, info in pairs(markers) do
	for i = info.dimRange[1], info.dimRange[2] do
		local m = Marker(info.x, info.y, info.z - 1, "cylinder", 1, 255, 0, 0, 210)
		m.dimension = i
		m.interior = info.interior
		addEventHandler("onClientMarkerHit", m, onHitMarker)
	end
end

function createGUI(key)
	GUIEditor.staticimage[1] = GuiStaticImage(10, 26, 135, 134, ":UCDfood/"..key.."_small.png", false, GUIEditor.window[1])
	GUIEditor.staticimage[2] = GuiStaticImage(155, 26, 135, 134, ":UCDfood/"..key.."_medium.png", false, GUIEditor.window[1])
	GUIEditor.staticimage[3] = GuiStaticImage(304, 26, 131, 134, ":UCDfood/"..key.."_large.png", false, GUIEditor.window[1])	
end

function toggleGUI(i)
	GUIEditor.window[1].visible = not GUIEditor.window[1].visible
	showCursor(GUIEditor.window[1].visible)
	if (i and type(i) == "number") then
		local info = foodInfo[i]
		GUIEditor.window[1].visible = true
		GUIEditor.window[1].text = info.title
		for index in ipairs(foodInfo[i].meals) do
			GUIEditor.button[index].text = info.meals[index].." - $"..prices[index]
		end
		createGUI(info.key)
	end
end
addEventHandler("onClientGUIClick", GUIEditor.button[4], toggleGUI, false)

function purchaseFoodItem()
	local price, amount
	for i = 1, 3 do
		if (GUIEditor.button[i] == source) then
			amount = i
			break
		end
	end
	if (not amount or amount == nil) then return end
	price = prices[amount]
	outputDebugString(price)
	triggerServerEvent("UCDfood.purchaseMeal", localPlayer, price)
end
addEventHandler("onClientGUIClick", GUIEditor.window[1], purchaseFoodItem)
