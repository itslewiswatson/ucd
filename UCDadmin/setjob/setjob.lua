local jobs = exports.UCDjobsTable:getJobTable()

for name, data in pairs(jobs) do -- Insert all jobs into gridlist
	if (#name > 0) then
		local row = setJob.jobsGrid:addRow()
		local r, g, b = 255, 255, 255
		if (data.colour and type(data.colour) == "table") then
			r, g, b = data.colour.r, data.colour.g, data.colour.b
		else
			if (data.team and Team.getFromName(data.team)) then
				r, g, b = Team.getFromName(data.team):getColor()
			end
		end
		setJob.jobsGrid:setItemText(row, 1, name, false, false)
		setJob.jobsGrid:setItemColor(row, 1, r, g, b)
	end
end

for _, plr in ipairs(Element.getAllByType("player")) do -- Insert all players into gridlist
	local row = setJob.playersGrid:addRow()
	local r, g, b = 255, 255, 255
	if (plr.team) then
		r, g, b = plr.team:getColor()
	end
	setJob.playersGrid:setItemText(row, 1, tostring(plr.name), false, false)
	setJob.playersGrid:setItemColor(row, 1, r, g, b)
end

function connect_quit_change_nick(oldNick, newNick) -- Keep the players gridlist up-to-date
	if (eventName == "onClientPlayerJoin") then
		setJob.playersGrid:setItemText(setJob.playersGrid:addRow(), 1, source.name, false, false)
	elseif (eventName == "onClientPlayerQuit") then
		for i = 1, setJob.playersGrid.rowCount do
			if (setJob.playersGrid:getItemText(i, 1) == source.name) then
				setJob.playersGrid:removeRow(i)
			end
		end
	elseif (eventName == "onClientPlayerChangeNick") then
		for i = 0, setJob.playersGrid.rowCount do
			if (setJob.playersGrid:getItemText(i, 1) == oldNick) then
				setJob.playersGrid:setItemText(i, 1, newNick, false, false)
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
		if (source == setJob.jobsGrid) then
			local row = setJob.jobsGrid:getSelectedItem()
			setJob.skinsGrid:clear()
			if (row and row ~= -1) then
				local name = setJob.jobsGrid:getItemText(row, 1)
				local skins = jobs[setJob.jobsGrid:getItemText(row, 1)].skins
				if (skins) then
					if (type(skins) == "table") then
						for _, data in pairs(skins) do
							local _row = setJob.skinsGrid:addRow()
							setJob.skinsGrid:setItemText(_row, 1, data[2], false, false)
							setJob.skinsGrid:setItemText(_row, 2, data[1], false, false)
						end
					end
				end
			end
		elseif (source == setJob.cancelButton) then
			setJob.window.visible = false
			if (not adminPanel.window.visible) then
				showCursor(false)
			end
		elseif (source == setJob.setButton or source == setJob.removeButton) then
			local player = Player(setJob.playersGrid:getItemText(setJob.playersGrid:getSelectedItem()))
			if (player) then
				local selected_job, selected_model
				if (source == setJob.setButton) then
					selected_job = setJob.jobsGrid:getItemText(setJob.jobsGrid:getSelectedItem())
					selected_model = setJob.skinsGrid:getItemText(setJob.skinsGrid:getSelectedItem(), 2)
					if ((not selected_model or selected_model == "") and guiGridListGetRowCount(setJob.skinsGrid) ~= 0) then
						exports.UCDdx:new("You must select a skin from the list", 255, 0, 0)
						return
					end
				else
					selected_job = ""
				end
				triggerServerEvent("UCDadmin.setjob.setJob", resourceRoot, player, selected_job, selected_model)
			end
		end
	end
)

function openGUI(player)
	setJob.window.visible = true
	guiBringToFront(setJob.window)
	showCursor(true)
	if (not player) then return end
	for i = 0, setJob.playersGrid.rowCount do
		if (setJob.playersGrid:getItemText(i, 1) == player.name) then
			setJob.playersGrid:setSelectedItem(i, 1)
		end
	end
end
addEvent("UCDadmin.setjob.openGUI", true)
addEventHandler("UCDadmin.setjob.openGUI", resourceRoot, openGUI)