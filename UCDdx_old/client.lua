function dxDrawColorText( str, ax, ay, bx, by, color, scale, font, alignX, alignY )
	bx, by, color, scale, font = bx or ax, by or ay, color or tocolor( 255, 255, 255, 255 ), scale or 1, font or "default"
	if alignX then
		if alignX == "center" then
			ax = ax + (bx - ax - dxGetTextWidth(str:gsub( "#%x%x%x%x%x%x","" ), scale, font ) ) / 2
		elseif alignX == "right" then
			ax = bx - dxGetTextWidth(str:gsub( "#%x%x%x%x%x%x","" ), scale, font)
		end
	end
	if alignY then
		if alignY == "center" then
			ay = ay + ( by - ay - dxGetFontHeight( scale, font ) ) / 2
		elseif alignY == "bottom" then
			ay = by - dxGetFontHeight( scale, font )
		end
	end
	local alpha = string.format( "%08X", color ):sub( 1, 2 )
	local pat = "(.-)#(%x%x%x%x%x%x)"
	local s, e, cap, col = str:find( pat, 1 )
	local last = 1
	while s do
		if cap == "" and col then color = tocolor( getColorFromString( "#"..col..alpha ) ) end
		if s ~= 1 or cap ~= "" then
			local w = dxGetTextWidth( cap, scale, font )
			dxDrawText( cap, ax, ay, ax + w, by, color, scale, font )
			ax = ax + w
			color = tocolor( getColorFromString( "#"..col..alpha ) )
		end
		last = e + 1
		s, e, cap, col = str:find(pat, last)
	end
	if last <= #str then
		cap = str:sub( last )
		dxDrawText( cap, ax, ay, ax + dxGetTextWidth( cap, scale, font ), by, color, scale, font )
	end
end
------------------------------------------------
gMinimized=false
gMinimized=false
gEnabled=true
gScreen = {}
gScreen.x,gScreen.y = guiGetScreenSize()
ContextBar = {
	height = 28,
	speed = 20,
	step = -2,
	life = 5000,
	update = 0,
	textColour = { 255, 255, 0, 100 },
	lineColour = { 0, 0, 0 },
	entries = {}
}

function math.lerp( from, to, t )
    return from + ( to - from ) * t
end

function ContextBar.add2( _, text )
	ContextBar.add( text )
end

function ContextBar.add( text, r, g, b )
	if not gEnabled then
		return false
	end
	
	if gMinimized then
		return false
	end

	local y = gScreen.y - ContextBar.height
	y = gScreen.y - (#ContextBar.entries*ContextBar.height)-28
	y = gScreen.y-y
	if text=="" or text == nil then return false end
	if #ContextBar.entries > 0 then
		for k,v in pairs(ContextBar.entries) do
			if v.text == text then return false end
		end
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
	--y=gScreen.y-y
	local pixelsPerSecond = (1000 / ContextBar.speed) * ContextBar.step
	local alphaStep = -((y + ContextBar.height) / pixelsPerSecond)/2

	ContextBar.entries[#ContextBar.entries + 1] = {
		text = text,
		creation = getTickCount(),
		y = y,
		r=r,
		g=g,
		b=b,
		landed = false,
		alphaStep = alphaStep == 0 and 0.05 or (1 / ( ( alphaStep * 1000 ) / ContextBar.speed) ),
		alpha = alphaStep == 0 and 1 or 0,
	}
	outputConsole( text )
	return true
end
addCommandHandler("dx", ContextBar.add2 )

addEventHandler("onClientRender", root,
	function()
		for _,bar in ipairs(ContextBar.entries) do
			dxDrawRectangle(0, bar.y, gScreen.x, ContextBar.height, tocolor(0, 0, 0, math.lerp(0, 170, bar.alpha)), true)
			dxDrawText(bar.text, 0, bar.y, gScreen.x, bar.y + ContextBar.height, tocolor(bar.r, bar.g, bar.b, math.lerp(0, 255, bar.alpha)), 1, "default-bold", "center", "center", true, true, true)

			dxDrawLine(0, bar.y, gScreen.x, bar.y, tocolor(ContextBar.lineColour[1], ContextBar.lineColour[2], ContextBar.lineColour[3], math.lerp(0, 255, bar.alpha)), 1, true)
		end

		local tick = getTickCount()

		if tick > (ContextBar.update + ContextBar.speed) then
			ContextBar.update = tick

			if #ContextBar.entries > 0 then
				for i = 1,#ContextBar.entries do
					if ContextBar.entries[i].y < -28 then
						table.remove(ContextBar.entries, i)
					else
						local num = (i*28)-28
						if ContextBar.entries[i].y > num then
						ContextBar.entries[i].alpha = math.min(1, ContextBar.entries[i].alpha + ContextBar.entries[i].alphaStep)
						ContextBar.entries[i].y = ContextBar.entries[i].y + ContextBar.step
						end
						if ContextBar.entries[i].y == 0 then ContextBar.entries[i].landed=true end
						-- make sure we always align the last in the list exactly with the bottom of the screen
						if i ~= 1 and #ContextBar.entries == 2 and ContextBar.entries[i].y > (gScreen.y - ContextBar.height) then
							ContextBar.entries[i].y = gScreen.y - ContextBar.height
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
					ContextBar.entries[1].alpha = ContextBar.entries[1].alpha - ContextBar.entries[1].alphaStep

					if ContextBar.entries[1].alpha <= 0 then
						--ContextBar.entries[1] = nil
						table.remove(ContextBar.entries,1)
					end
				end
			end --]]
		end
	end
)

function new( text, r, g, b )
	ContextBar.add( text, r, g, b )
end
addEvent( "CSGdx.createNewDxMessage", true )
addEventHandler( "CSGdx.createNewDxMessage", localPlayer, new )

--------bottom bar

gEnabled=true
gScreen = {}
gScreen.x,gScreen.y = guiGetScreenSize()
ContextBarBot = {
	height = 28,
	speed = 20,
	step = 1,
	life = 7000,
	update = 0,
	textColour = {255,255,0,100},
	lineColour = {0, 0, 0},
	entries = {}
}

function math.lerp(from, to, t)
    return from + (to - from) * t
end

function ContextBarBot.add2(_,text)
	ContextBarBot.add(text)
end

function ContextBarBot.add(text,r,g,b)
	if not gEnabled then
		return
	end

	local y = gScreen.y - ContextBarBot.height
	y = gScreen.y - (#ContextBarBot.entries*ContextBarBot.height)-28-28


	if #ContextBarBot.entries > 0 then
		for k,v in pairs(ContextBarBot.entries) do
			if v.text == text then return end
		end
		if #ContextBarBot.entries > 2 then
			ContextBarBot.life = 4000
		elseif #ContextBarBot.entries > 3 then
			ContextBarBot.life = 3500
		elseif #ContextBarBot.entries > 4 then
			ContextBarBot.life = 2000
		else
			ContextBarBot.life = 5000
		end
		--y = ContextBarBot.entries[#ContextBarBot.entries].y - ContextBarBot.height
	end
	--y=gScreen.y-y
	local pixelsPerSecond = (1000 / ContextBarBot.speed) * ContextBarBot.step
	local alphaStep = ((gScreen.y - y) / pixelsPerSecond)

	ContextBarBot.entries[#ContextBarBot.entries + 1] = {
		text = text,
		creation = getTickCount(),
		y = y,
		r=r,
		g=g,
		b=b,
		landed = false,
		alphaStep = alphaStep == 0 and 0.05 or (1 / ((alphaStep * 1000) / ContextBarBot.speed)),
		alpha = alphaStep == 0 and 1 or 0,
	}
end

addCommandHandler("dxbot",ContextBarBot.add2)

addCommandHandler("cleardx",function()
	for k,v in pairs(ContextBarBot.entries) do
		table.remove(ContextBarBot.entries,k)
	end
	for k,v in pairs(ContextBar.entries) do
		table.remove(ContextBar.entries,k)
	end
end)

addEventHandler("onClientRender", root,
	function()
		for _,bar in ipairs(ContextBarBot.entries) do
			dxDrawRectangle(gScreen.x*0.25, bar.y,gScreen.x*0.5, ContextBarBot.height, tocolor(0, 0, 0, math.lerp(0, 170, bar.alpha)), true)
			local alCalc = math.lerp(0, 255, bar.alpha)*6
			if alCalc > 255 then alCalc = 255 end
			dxDrawColorText(bar.text, gScreen.x*0.25, bar.y, gScreen.x*0.75, bar.y + ContextBarBot.height, tocolor(bar.r, bar.g, bar.b, alCalc), 1, "default-bold", "center", "center", true, true, true)

			dxDrawLine(gScreen.x*0.25, bar.y, gScreen.x*0.75, bar.y, tocolor(ContextBarBot.lineColour[1], ContextBarBot.lineColour[2], ContextBarBot.lineColour[3], math.lerp(0, 255, bar.alpha)), 1, true)
		end

		local tick = getTickCount()
		if #ContextBarBot.entries > 0 then
			ContextBarBot.life = 4000
		elseif #ContextBarBot.entries > 1 then
			ContextBarBot.life = 3500
		elseif #ContextBarBot.entries > 2 then
			ContextBarBot.life = 2000
		else
			ContextBarBot.life = 5000
		end
		if tick > (ContextBarBot.update + ContextBarBot.speed) then
			ContextBarBot.update = tick

			if #ContextBarBot.entries > 0 then
				for i = 1,#ContextBarBot.entries do
					if ContextBarBot.entries[i].y > gScreen.y then
						table.remove(ContextBarBot.entries, i)
					else
						local num = (i*28)
						if ContextBarBot.entries[i].y < gScreen.y-num then
						ContextBarBot.entries[i].alpha = math.min(1, ContextBarBot.entries[i].alpha + ContextBarBot.entries[i].alphaStep)
						ContextBarBot.entries[i].y = ContextBarBot.entries[i].y + ContextBarBot.step
						end
						if ContextBarBot.entries[i].y == gScreen.y-28 then ContextBarBot.entries[i].landed=true end
						-- make sure we always align the last in the list exactly with the bottom of the screen
						if i ~= 1 and #ContextBarBot.entries == 2 and ContextBarBot.entries[i].y > (gScreen.y - ContextBarBot.height) then
							ContextBarBot.entries[i].y = gScreen.y - ContextBarBot.height
						end
					end
				end
			end

			if ContextBarBot.entries[1] ~= nil then
				if not ContextBarBot.entries[1].landed then
					ContextBarBot.entries[1].landed = true
					ContextBarBot.entries[1].creation = tick
				end

				if tick > (ContextBarBot.entries[1].creation + ContextBarBot.life) then
					ContextBarBot.entries[1].alpha = ContextBarBot.entries[1].alpha - ContextBarBot.entries[1].alphaStep

					if ContextBarBot.entries[1].alpha <= 0 then
						--ContextBarBot.entries[1] = nil
						table.remove(ContextBarBot.entries,1)
					end
				end
			end --]]
		end
	end
)



function createNewDxMessageBot(text,r,g,b)
	ContextBarBot.add(text,r,g,b)
end
addEvent("CSGdx.createNewDxMessageBot",true)
addEventHandler("CSGdx.createNewDxMessageBot",localPlayer,createNewDxMessageBot)

function toggleDxRendering(state)
	if (state) then
		gMinimized = state
	else
		return
	end
end
--addEventHandler("onClientMinimize",root,function() toggleDxRender(true) end)
--addEventHandler("onClientRestore",root,function() toggleDxRender(false) end)