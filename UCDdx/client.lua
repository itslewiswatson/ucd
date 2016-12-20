sX, sY = guiGetScreenSize()
local enabled = true

local Shout = { -- hell yeah
	enabled = true,
	scale = 2.5,
	life = 10000,
	extralife = 150,
	color = {255, 140, 0},
	uppercase = false,
	font = "default-bold",
	entries = {}
}
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

function enable(new)
	enabled = new == "Yes" and true or false
end
enable(exports.UCDsettings:getSetting("dxmsgs"))

function ContextBar.add(text, r, g, b)
	--local y = sY - ContextBar.height
	--y = sY - (#ContextBar.entries * ContextBar.height) - ContextBar.height
	--y = sY - y
	if (not enabled) then
		outputChatBox(tostring(text), r, g, b)
		return
	end
	local y = -23
	
	--if text == "" or text == nil then return false end
	--[[
	if #ContextBar.entries > 0 then
		--for k,v in pairs(ContextBar.entries) do
		--	if v.text == text then return false end
		--end
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
	]]

	ContextBar.entries[#ContextBar.entries + 1] = 
	{
		text = tostring(text),
		creation = getTickCount(),
		y = y,
		r = r,
		g = g,
		b = b,
		landed = false,
		--finished = false,
		inAnim = false,
	}
	outputConsole(text)
	return true
end
--addCommandHandler("dx", function () ContextBar.add("The quick brown fox jumps over the lazy dog "..exports.UCDutil:randomstring(2), math.random(0, 255), math.random(0, 255), math.random(0, 255)) end)
addCommandHandler("getdx", function () outputDebugString(#ContextBar.entries) end)

addCommandHandler("cleardx",
	function ()
		ContextBar.entries = {}
	end
)

addEventHandler("onClientRender", root,
	function ()
		--for _, bar in ipairs(ContextBar.entries) do
		for i = 1, #ContextBar.entries do
			if i <= 4 then
			--[[
			dxDrawRectangle(0, bar.y, sX, ContextBar.height, tocolor(0, 0, 0, math.lerp(0, 170, bar.alpha)), true)
			
			dxDrawText(bar.text, 0, bar.y, sX, bar.y + ContextBar.height, tocolor(bar.r, bar.g, bar.b, math.lerp(0, 255, bar.alpha)), 1, "default-bold", "center", "center", true, true, true)

			dxDrawLine(0, bar.y, sX, bar.y, tocolor(ContextBar.lineColour[1], ContextBar.lineColour[2], ContextBar.lineColour[3], math.lerp(0, 255, bar.alpha)), 1, true)
			--]]
			
			--dxDrawRectangle(sX / 4, bar.y, sX / 2, ContextBar.height, tocolor(0, 0, 0, 63), false)			
			dxDrawText(ContextBar.entries[i].text, sX / 4 + 1, ContextBar.entries[i].y + 1, (sX / 4) * 3 + 1, (ContextBar.height + ContextBar.entries[i].y) + 1, tocolor(0, 0, 0, 255), 1.25, "default-bold", "center", "center", false, false, false, false, false)
			dxDrawText(ContextBar.entries[i].text, sX / 4 + 1, ContextBar.entries[i].y - 1, (sX / 4) * 3 + 1, (ContextBar.height + ContextBar.entries[i].y) - 1, tocolor(0, 0, 0, 255), 1.25, "default-bold", "center", "center", false, false, false, false, false)
			dxDrawText(ContextBar.entries[i].text, sX / 4 - 1, ContextBar.entries[i].y + 1, (sX / 4) * 3 - 1, (ContextBar.height + ContextBar.entries[i].y) + 1, tocolor(0, 0, 0, 255), 1.25, "default-bold", "center", "center", false, false, false, false, false)
			dxDrawText(ContextBar.entries[i].text, sX / 4 - 1, ContextBar.entries[i].y - 1, (sX / 4) * 3 - 1, (ContextBar.height + ContextBar.entries[i].y) - 1, tocolor(0, 0, 0, 255), 1.25, "default-bold", "center", "center", false, false, false, false, false)
			dxDrawText(ContextBar.entries[i].text, sX / 4, ContextBar.entries[i].y, (sX / 4) * 3, ContextBar.height + ContextBar.entries[i].y, tocolor(ContextBar.entries[i].r, ContextBar.entries[i].g, ContextBar.entries[i].b, 255), 1.25, "default-bold", "center", "center", false, false, false, false, false)
			
			-- default
			--[[
			dxDrawRectangle(480, 0, 960, 23, tocolor(0, 0, 0, 63), false)
			dxDrawText(bar.text, 480, 0, 1440, 23, tocolor(255, 255, 255, 255), 1.00, "default-bold", "center", "center", false, false, false, false, false)
			]]
			end
		end
		
		--outputDebugString(tostring(#ContextBar.entries))

		local tick = getTickCount()

		if tick > (ContextBar.update + ContextBar.speed) then
			ContextBar.update = tick

			if #ContextBar.entries > 0 then
				for i = 1, #ContextBar.entries do
					if ContextBar.entries[i] and i <= 4 then
						if ContextBar.entries[i].y < -23 and ContextBar.entries[i].inAnim then --if it has landed
							table.remove(ContextBar.entries, i)
						else
							if (not ContextBar.entries[i].inAnim) then
								ContextBar.entries[i].y = ContextBar.entries[i].y - ContextBar.step
							end
							local num = (i * ContextBar.height) - ContextBar.height
							if ContextBar.entries[i].y > num then
								ContextBar.entries[i].y = ContextBar.entries[i].y + ContextBar.step
							end
							if ContextBar.entries[i].y >= num and not ContextBar.entries[i].inAnim then
								ContextBar.entries[i].inAnim = true
							end
							--if ContextBar.entries[i].y == 0 then ContextBar.entries[i].landed = true end
							-- make sure we always align the last in the list exactly with the bottom of the screen
							if i ~= 1 and #ContextBar.entries == 2 and ContextBar.entries[i].y > (sY - ContextBar.height) then
								ContextBar.entries[i].y = sY - ContextBar.height
							end
						end
					end
				end
			end
			
			local toAdd = 0
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

				if tick + toAdd > (ContextBar.entries[1].creation + ContextBar.life) then
					-- We step that out of the screen [acting as an animation]
					ContextBar.entries[1].y = ContextBar.entries[1].y + ContextBar.step
					-- Let's push the other ones up
					for i = 1, #ContextBar.entries do
						if (i ~= 1) then
							ContextBar.entries[i].y = ContextBar.entries[i].y + ContextBar.step
						end
					end
				end
			end
			
		end
		
		for i, v in ipairs(Shout.entries) do
			if (i ~= 1) then Shout.entries[i][2] = getTickCount() return end -- draw one only, others delayed
			local scale = Shout.scale
			local tX, tY = (sX - dxGetTextWidth(v[1], scale, Shout.font)) / 2, sY - dxGetFontHeight(scale, Shout.font)
			while (tX <= 0) do
				scale = scale - 0.01
				tX, tY = (sX - dxGetTextWidth(v[1], scale, Shout.font)) / 2, sY - dxGetFontHeight(scale, Shout.font)
			end
			local alpha = (((Shout.life + (#v[1] * Shout.extralife)) - (getTickCount() - v[2])) / (Shout.life + (#v[1] * Shout.extralife))) * 255
			-- idk how did i do all of this math but it works :D
			dxDrawText(v[1], tX + 1, tY + 1, _, _, tocolor(0, 0, 0, alpha), scale, Shout.font, _, _, _, _, true)
			dxDrawText(v[1], tX + 1, tY + 1, _, _, tocolor(0, 0, 0, alpha), scale, Shout.font, _, _, _, _, true)
			dxDrawText(v[1], tX - 1, tY - 1, _, _, tocolor(0, 0, 0, alpha), scale, Shout.font, _, _, _, _, true)
			dxDrawText(v[1], tX - 1, tY - 1, _, _, tocolor(0, 0, 0, alpha), scale, Shout.font, _, _, _, _, true)
			dxDrawText(v[1], tX, tY, _, _, tocolor(Shout.color[1], Shout.color[2], Shout.color[3], alpha), scale, Shout.font, _, _, _, _, true)
			if ((getTickCount() - v[2]) > (Shout.life + (#v[1] * Shout.extralife))) then
				table.remove(Shout.entries, i)
			end
		end
		
	end
)

function shout(text)
	if (not text or not tostring(text)) then return false, "text missing" end
	if (not Shout.enabled) then new(text, 255, 0, 0) return false, "dx instead" end
	if (Shout.uppercase) then text = text:upper() end
	table.insert(Shout.entries, {text, getTickCount()})
end
addEvent("UCDdx.shout", true)
addEventHandler("UCDdx.shout", resourceRoot, shout)
-- shout(exports.ucdutil:randomstring(18))

function new(text, r, g, b)
	ContextBar.add(text, r, g, b)
end
addEvent("UCDdx.createNewDxMessage", true)
addEventHandler("UCDdx.createNewDxMessage", localPlayer, new)
