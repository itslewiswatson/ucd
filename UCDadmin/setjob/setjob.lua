window = GuiWindow(362, 112, 614, 376, "UCD | Set Job", false)
window.sizable = false
window.visible = false
window.alpha = 1
local screen_width, screen_height = guiGetScreenSize()
window:setPosition((screen_width-614)/2, (screen_height-376)/2, false)
local openType = "source"

players_grid = GuiGridList(9, 25, 187, 281, false, window)
players_grid:addColumn("Player:", 0.9)
jobs_grid = GuiGridList(213, 25, 187, 281, false, window)
jobs_grid:addColumn("Job:", 0.9)
skins_grid = GuiGridList(416, 25, 187, 281, false, window)
skins_grid:addColumn("Skin:", 0.5)
skins_grid:addColumn("Skin ID", 0.4)
set_button = GuiButton(9, 316, 187, 46, "Set player job", false, window)
remove_button = GuiButton(213, 316, 187, 46, "Remove player from job", false, window)
cancel_button = GuiButton(416, 316, 187, 46, "Cancel", false, window)

local jobs = exports.UCDjobsTable:getJobTable()

for name, skins in pairs(jobs) do -- Insert all jobs into gridlist
	if (#name > 0) then
		jobs_grid:setItemText(jobs_grid:addRow(), 1, name, false, false)
	end
end

for _, player in ipairs(Element.getAllByType("player")) do -- Insert all players into gridlist
	players_grid:setItemText(players_grid:addRow(), 1, player.name, false, false)
end

function requestOpenGUI()
	window.visible = not window.visible
	showCursor(window.visible)
	openType = "source"
end
addEvent("onOpenGUIRequest", true)
addEventHandler("onOpenGUIRequest", resourceRoot, requestOpenGUI)

function connect_quit_change_nick(oldNick, newNick) -- Keep the players gridlist up-to-date
	if (eventName == "onClientPlayerJoin") then
		players_grid:setItemText(players_grid:addRow(), 1, source.name, false, false)
	elseif (eventName == "onClientPlayerQuit") then
		for i = 1, players_grid.rowCount do
			if (players_grid:getItemText(i, 1) == source.name) then
				players_grid:removeRow(i)
			end
		end
	elseif (eventName == "onClientPlayerChangeNick") then
		for i = 0, players_grid.rowCount do
			if (players_grid:getItemText(i, 1) == oldNick) then
				players_grid:setItemText(i, 1, newNick, false, false)
			end
		end
	end
end
addEventHandler("onClientPlayerJoin", root, connect_quit_change_nick)
addEventHandler("onClientPlayerQuit", root, connect_quit_change_nick)
addEventHandler("onClientPlayerChangeNick", root, connect_quit_change_nick)

addEventHandler("onClientGUIClick", root,
	function(button, state)
		if (button ~= "left" or state ~= "up") then return end
		if (source == jobs_grid) then
			local row = jobs_grid:getSelectedItem()
			skins_grid:clear()
			if (row and row ~= -1) then
				local name = jobs_grid:getItemText(row, 1)
				local skins = jobs[jobs_grid:getItemText(row, 1)].skins
				if (skins) then
					if (type(skins) == "table") then
						for _, data in pairs(skins) do
							local _row = skins_grid:addRow()
							skins_grid:setItemText(_row, 1, data[2], false, false)
							skins_grid:setItemText(_row, 2, data[1], false, false)
						end
					end
				end
			end
		elseif (source == cancel_button) then
			window:setVisible(false)
			if (openType == "source") then
				showCursor(false)
			end
		elseif (source == set_button or source == remove_button) then
			local player = Player(players_grid:getItemText(players_grid:getSelectedItem()))
			if (player) then
				local selected_job, selected_model
				if (source == set_button) then
					selected_job = jobs_grid:getItemText(jobs_grid:getSelectedItem())
					selected_model = skins_grid:getItemText(skins_grid:getSelectedItem(), 2)
					outputDebugString(tostring(selected_job))
					if ((not selected_model or selected_model == "") and guiGridListGetRowCount(skins_grid) ~= 0) then
						exports.UCDdx:new("You must select a skin from the list", 255, 0, 0)
						return
					end
				else
					if ((not selected_model or selected_model == "") and guiGridListGetRowCount(skins_grid) ~= 0) then
						exports.UCDdx:new("You must select a skin from the list", 255, 0, 0)
						return
					end
					selected_job = ""
				end
				triggerServerEvent("UCDadmin.setjob.setJob", resourceRoot, player, selected_job, selected_model)
			end
		end
	end
)

function openGUIPlayer(player)
	window:setVisible(true)
	guiBringToFront(window)
	showCursor(true)
	openType = "admin panel"
	for i = 1, players_grid.rowCount do
		if (players_grid:getItemText(i, 1) == player.name) then
			players_grid:setSelectedItem(i, 1)
		end
	end
end
addEvent("UCDadmin.setjob.openGUI", true)
addEventHandler("UCDadmin.setjob.openGUI", resourceRoot, openGUIPlayer)