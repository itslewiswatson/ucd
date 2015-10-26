sX, sY = guiGetScreenSize()

ContextBar = {
	height = 23,
	speed = 20,
	step = -1,
	life = 5000,
	update = 0,
	textColour = { 255, 255, 0, 100 },
	lineColour = { 0, 0, 0 },
	entries = {}
}

function math.lerp( from, to, t )
    return from + ( to - from ) * t
end

function ContextBar.add(text, r, g, b)
	local y = sY - ContextBar.height
	y = sY - (#ContextBar.entries * ContextBar.height) - ContextBar.height
	y = sY - y
	if text == "" or text == nil then return false end
	if #ContextBar.entries > 0 then
	--[[
		for k,v in pairs(ContextBar.entries) do
			if v.text == text then return false end
		end
		--]]
		if #ContextBar.entries > 2 then
			ContextBar.life = 4000
		elseif #ContextBar.entries > 3 then
			ContextBar.life = 3500
		elseif #ContextBar.entries > 4 then
			ContextBar.life = 2000
		else
			ContextBar.life = 7000
		end
		--y = ContextBar.entries[#ContextBar.entries].y - ContextBar.height
	end
	--y=sY-y

	ContextBar.entries[#ContextBar.entries + 1] = 
	{
		text = text,
		creation = getTickCount(),
		y = y,
		r = r,
		g = g,
		b = b,
		landed = false,
	}
	outputConsole(text)
	return true
end
--addCommandHandler("dx", function () ContextBar.add("The quick brown fox jumps over the lazy dog "..exports.UCDutil:randomstring(2), math.random(0, 255), math.random(0, 255), math.random(0, 255)) end)
--addCommandHandler("getdx", function () outputDebugString(#ContextBar.entries) end)

addEventHandler("onClientRender", root,
	function ()
		for _, bar in ipairs(ContextBar.entries) do
			--[[
			dxDrawRectangle(0, bar.y, sX, ContextBar.height, tocolor(0, 0, 0, math.lerp(0, 170, bar.alpha)), true)
			
			dxDrawText(bar.text, 0, bar.y, sX, bar.y + ContextBar.height, tocolor(bar.r, bar.g, bar.b, math.lerp(0, 255, bar.alpha)), 1, "default-bold", "center", "center", true, true, true)

			dxDrawLine(0, bar.y, sX, bar.y, tocolor(ContextBar.lineColour[1], ContextBar.lineColour[2], ContextBar.lineColour[3], math.lerp(0, 255, bar.alpha)), 1, true)
			--]]
			
			dxDrawRectangle(sX / 4, bar.y, sX / 2, ContextBar.height, tocolor(0, 0, 0, 63), false)
			dxDrawText(bar.text, sX / 4, bar.y, (sX / 4) * 3, ContextBar.height + bar.y, tocolor(bar.r, bar.g, bar.b, 255), 1.00, "default-bold", "center", "center", false, false, false, false, false)
			
			-- default
			--[[
			dxDrawRectangle(480, 0, 960, 23, tocolor(0, 0, 0, 63), false)
			dxDrawText(bar.text, 480, 0, 1440, 23, tocolor(255, 255, 255, 255), 1.00, "default-bold", "center", "center", false, false, false, false, false)
			]]
		end

		local tick = getTickCount()

		if tick > (ContextBar.update + ContextBar.speed) then
			ContextBar.update = tick

			if #ContextBar.entries > 0 then
				for i = 1,#ContextBar.entries do
					if ContextBar.entries[i] then
						if ContextBar.entries[i].y < -23 then
							table.remove(ContextBar.entries, i)
						else
							local num = (i * 23) - 23
							if ContextBar.entries[i].y > num then
								ContextBar.entries[i].y = ContextBar.entries[i].y + ContextBar.step
							end
							if ContextBar.entries[i].y == 0 then ContextBar.entries[i].landed = true end
							-- make sure we always align the last in the list exactly with the bottom of the screen
							if i ~= 1 and #ContextBar.entries == 2 and ContextBar.entries[i].y > (sY - ContextBar.height) then
								ContextBar.entries[i].y = sY - ContextBar.height
							end
						end
					end
				end
			end
			
			local toAdd=0
			if #ContextBar.entries > 2 then
				toAdd = 2000
			elseif #ContextBar.entries > 3 then
				toAdd = 4000
			elseif #ContextBar.entries > 4 then
				toAdd = 6000
			else
				toAdd = 0
			end
			
			if ContextBar.entries[1] ~= nil then
				if not ContextBar.entries[1].landed then
					ContextBar.entries[1].landed = true
					ContextBar.entries[1].creation = tick
				end

				if tick+toAdd > (ContextBar.entries[1].creation + ContextBar.life) then
					if ContextBar.entries[1].y < -23 then
						table.remove(ContextBar.entries, 1)
						outputDebugString("table.remove 1")
						return
					end
					-- We step that out of the screen [acting as an animation]
					ContextBar.entries[1].y = ContextBar.entries[1].y + ContextBar.step
					-- Let's push the other ones up
					for i=1, #ContextBar.entries do
						ContextBar.entries[i].y = ContextBar.entries[i].y + ContextBar.step
					end
				end
			end 
		end
	end
)

function new(text, r, g, b)
	ContextBar.add(text, r, g, b)
end
addEvent("CSGdx.createNewDxMessage", true)
addEventHandler("CSGdx.createNewDxMessage", localPlayer, new)
