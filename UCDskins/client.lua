local shop = {}
local sX, sY = guiGetScreenSize()
local prevSkin

shop.window = guiCreateWindow(0, 0, 287, 457, "UCD | Skins", false)
shop.window.visible = false
shop.window.sizable = false
shop.window:setPosition(sX - 287, (sY / 2) - (457 / 2), false)
shop.gridlist = guiCreateGridList(10, 27, 267, 374, false, shop.window)
guiGridListAddColumn(shop.gridlist, "Name", 0.6)
guiGridListAddColumn(shop.gridlist, "ID", 0.3)
shop.take = guiCreateButton(10, 408, 129, 39, "Take Skin", false, shop.window)
shop.close = guiCreateButton(148, 408, 129, 39, "Close", false, shop.window)

for i = 0, table.maxn(skinTable) do
	if (skinTable[i]) then
		local row = guiGridListAddRow(shop.gridlist)
		guiGridListSetItemText(shop.gridlist, row, 1, tostring(skinTable[i]), false, false)
		guiGridListSetItemText(shop.gridlist, row, 2, tostring(i), false, false)
	end
end

function onMarkerHit(ele, matchingDimension)
	if (ele and ele.type == "player" and ele == localPlayer and matchingDimension) then
		toggleGUI()
		prevSkin = localPlayer.model
	end
end

local markers = 
{
	-- ZIP
	{x = 161.6074, y = -83.9468, z = 1001.8047, dimRange = {20000, 20002}, interior = 18},
	
	-- Binco
	{x = 207.5932, y = -101.0621, z = 1005.2578, dimRange = {20000, 20003}, interior = 15},
	
	-- Sub Urban
	{x = 203.846, y = -44.1494, z = 1001.8047, dimRange = {20000, 20001}, interior = 1},
	
	-- Pro Laps
	{x = 207.0891, y = -130.1548, z = 1003.5078, dimRange = {20000, 20000}, interior = 3},
}
for _, info in ipairs(markers) do
	for i = info.dimRange[1], info.dimRange[2] do
		local m = Marker(info.x, info.y, info.z - 1, "cylinder", 2, 150, 150, 255, 170)
		m.dimension = i
		m.interior = info.interior
		addEventHandler("onClientMarkerHit", m, onMarkerHit)
	end
end

function toggleGUI()
	shop.window.visible = not shop.window.visible
	showCursor(shop.window.visible)
	if (not shop.window.visible) then
		if (localPlayer.model ~= prevSkin) then
			localPlayer.model = prevSkin
		end
	end
end
addEventHandler("onClientGUIClick", shop.close, toggleGUI, false)

addEventHandler("onClientGUIClick", shop.gridlist,
	function ()
		local row = guiGridListGetSelectedItem(shop.gridlist)
		if (row and row ~= -1) then
			localPlayer.model = tonumber(guiGridListGetItemText(shop.gridlist, row, 2))
		else
			localPlayer.model = prevSkin
		end
	end, false
)

function takeSkin()
	local row = guiGridListGetSelectedItem(shop.gridlist)
	if (row and row ~= -1) then
		triggerServerEvent("UCDskins.takeSkin", localPlayer, tonumber(guiGridListGetItemText(shop.gridlist, row, 2)))
		toggleGUI()
	end
end
addEventHandler("onClientGUIClick", shop.take, takeSkin, false)
addEventHandler("onClientGUIDoubleClick", shop.gridlist, takeSkin, false)
