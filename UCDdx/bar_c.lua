local sX, sY = guiGetScreenSize()

local bar = {}
--bar[0] = {t = "Press Z: House Info", r = 255, g = 255, b = 0}
--bar[1] = {t = "Press N: House Rob", r = 255, g = 0, b = 0}

function add(key, text, red, green, blue, ind)
	if (not text or not red or not green or not blue) then return end
	for i, v in pairs(bar) do
		if (v.k == key) then
			if (not ind) then
				ind = i
			end
			--bar[i] = {k = key, t = text, r = red, g = green, b = blue}
			table.remove(bar, i)
			table.insert(bar, ind, {k = key, t = text, r = red, g = green, b = blue})
			
			return
		end
	end
	if (not ind) then
		ind = #bar + 1
	end
	if (ind <= 0) then
		ind = 1
	end
	if (not bar[ind - 1] and ind ~= 1) then
		while (not bar[ind - 1]) do
			ind = ind - 1
		end
	end
	table.insert(bar, ind, {k = key, t = text, r = red, g = green, b = blue})
	return true
end
--add("x", "The mitochrondria is the powerhouse of the cell", 255, 255, 255)
addEventHandler("onClientRender", root,
	function ()
		add("ucd", "UCD Alpha", 255, 255, 255, 1)
	end
)

addEvent("UCDdx.bar:add", true)
addEventHandler("UCDdx.bar:add", root, add)

function del(key)
	if (not key) then return false end
	for ind, v in pairs(bar) do
		if (v.k == key) then
			table.remove(bar, ind)
			return true
		end
	end
	return false
end
addEvent("UCDdx.bar:del", true)
addEventHandler("UCDdx.bar:del", root, del)

function isText(text)
	if (not text) then return false end
	for k, v in pairs(bar) do
		if (v.t == text) then
			return true
		end
	end
	return false
end

--729

addEventHandler("onClientRender", root,
	function ()
		if (isPlayerMapVisible()) then return end
		local baseY, baseX = nil, 219
		if (localPlayer.vehicle) then
			baseY = 150
		else
			baseY = 39
		end
		--for i = 0, #bar do
		for i = #bar, 1, -1 do
			if (bar[i]) then
				--outputDebugString(i.." | "..bar[i].t)
				local r, g, b = bar[i].r, bar[i].g, bar[i].b			
				dxDrawText(tostring(bar[i].t)--[[.." | "..i]], sX - baseX, sY - baseY - (i * 19) + 19, sX - 10, sY - 20, tocolor(r, g, b, 200), 1.2, "default-bold", "right", "top", false, false, false, true, false)
				--dxDrawText(tostring(bar[i].t).." | "..i, sX - baseX, sY - baseY - (i * 19) + 19, sX - 10, sY - 20, tocolor(r, g, b, 200), (scaleX + scaleY) / (1 + (2 / 3)), "default-bold", "right", "top", false, false, false, false, false)
				--dxDrawText(tostring(bar[i].t).." | "..i, sX - baseX, baseY - (i * 19) + 19, 1356, 748, tocolor(r, g, b, 200), 1.2, "default-bold", "right", "top", false, false, false, false, false)
			end
		end
	end
)
