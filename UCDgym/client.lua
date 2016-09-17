local styles =
{
	["walk"] =
	{
		[0] = "Default", --{"Default", 0},
		[69] = "Sneak", --{"Sneak", 69},
		[119] = "Shuffle", --{"Shuffle", 119},
		[120] = "Old Man", --{"Old Man", 120},
		[121] = "Gang 1", --{"Gang 1", 121},
		[122] = "Gang 2", --{"Gang 2", 122},
		[123] = "Old Fat Man", --{"Old Fat Man", 123},
		[124] = "Fat Man", --{"Fat Man", 124},
		[125] = "Male Jogger", --{"Male Jogger", 125},
		[126] = "Drunk", --{"Drunk", 126},
		[127] = "Blind", --{"Blind", 127},
		[128] = "SWAT", --{"SWAT", 128},
		[129] = "Woman", --{"Woman", 129},
		[130] = "Shopping", --{"Shopping", 130},
		[131] = "Busy Woman", --{"Busy Woman", 131},
		[132] = "Sexy Woman", --{"Sexy Woman", 132},
		[133] = "Pro", --{"Pro", 133},
		[134] = "Old Woman", --{"Old Woman", 134},
		[135] = "Fat Woman", --{"Fat Woman", 135},
		[136] = "Female Jogger", --{"Female Jogger", 136},
		[137] = "Old Fat Woman" --{"Old Fat Woman", 137},
	},
	["fight"] =
	{
		[4] = "Standard",
		[5] = "Boxing",
		[6] = "Kung Fu",
		[7] = "Knee Head",
		[15] = "Grab Kick",
		[16] = "Elbows"
	}
}

local prices =
{
	["walk"] =
	{
		[0] = 0,
		[69] = 5000,
		[119] = 1000,
		[120] = 1000,
		[121] = 1500,
		[122] = 1500,
		[123] = 1000,
		[124] = 1000,
		[125] = 1500,
		[126] = 2000,
		[127] = 5000,
		[128] = 5000,
		[129] = 2000,
		[130] = 1000,
		[131] = 1500,
		[132] = 2500,
		[133] = 5000,
		[134] = 1000,
		[135] = 1000,
		[136] = 2500,
		[137] = 1000
	},
	["fight"] =
	{
		[4] = 0,
		[5] = 2500,
		[6] = 2500,
		[7] = 5000,
		[15] = 2500,
		[16] = 5000
	}
}

local window = GuiWindow(0, 0, 400, 425, "", false)
window.visible = false
window.movable = false
window.sizable = false
local sX, sY = guiGetScreenSize()
window:setPosition((sX-400)/2, (sY-425)/2, false)
local gridlist = GuiGridList(0, 22.5, 400, 350, false, window)
gridlist:addColumn("Name", 0.5)
gridlist:addColumn("Price", 0.2)
gridlist:addColumn("ID", 0.2)
local select = GuiButton(0, (22.5+350+5), 190, 500, "Change", false, window)
local exit = GuiButton(210, (22.5+350+5), 200, 500, "Close", false, window)

function fillGrid(style)
	gridlist:clear()
	for id, name in pairs(styles[style]) do
		local row = gridlist:addRow()
		gridlist:setItemText(row, 1, name, false, false)
		gridlist:setItemText(row, 2, "$"..exports.UCDutil:tocomma(prices[style][id]), false, false)
		gridlist:setItemText(row, 3, id, false, false)
	end
	window.text = "UCD | Change your "..(style == "fight" and "fighting style" or "walking style")
end

addEvent("showStyleGUI", true)
addEventHandler("showStyleGUI", resourceRoot,
	function (style)
		window.visible = true
		showCursor(true)
		fillGrid(style)
	end
)

addEventHandler("onClientGUIClick", root,
	function (button, state)
		local style = (window.text:find("fight") and "fight" or "walk")
		local fullstyle = (style == "fight" and "fighting style" or "walking style")
		if (state ~= "up") then return end
		if (source == exit) then
			window.visible = false
			showCursor(false)
		elseif (source == select) then
			local row = gridlist:getSelectedItem()
			if (row and row ~= -1) then
				local id = tonumber(gridlist:getItemText(row, 3))
				local name = gridlist:getItemText(row, 1)
				if (id ~= localPlayer.walkingStyle) then
					triggerServerEvent("buyStyle", resourceRoot, style, name, prices[style][id], id)
				else
					exports.UCDdx:new("You already have this "..fullstyle, 255, 0, 0)
				end
			else
				exports.UCDdx:new("You have to select a "..fullstyle, 255, 0, 0)
			end
		end
	end
)