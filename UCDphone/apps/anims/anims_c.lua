Anims = {}
Anims.open = false

local animsTable =
	-- ["Category"] = {["Name"] = {"blockname", "animname"}}
{
	["Carry"] =
	{
		["Carry partial"] = {"carry", "crry_prtial"},
	},
	["Pull"] =
	{
		["Pull upleft"] = {"airport", "thrw_barl_thrw"},
	},
}

function Anims.create()
	phone.anims = {button = {}}
	
	phone.anims.gridlist = GuiGridList(19, 90, 272, 355, false, phone.image["phone_window"])
	phone.anims.gridlist.sortingEnabled = false
	phone.anims.gridlist:addColumn("Animation/category name", 0.94)
	for category, anims in pairs(animsTable) do
		phone.anims.gridlist:setItemText(phone.anims.gridlist:addRow(), 1, category, true, false)
		for name, data in pairs(anims) do
			local row = phone.anims.gridlist:addRow()
			phone.anims.gridlist:setItemText(row, 1, name, false, false)
			phone.anims.gridlist:setItemData(row, 1, data[1].." "..data[2], false, false)
		end
	end
	
	phone.anims.button["do"] = GuiButton(19, 450, 272, 35, "Do animation", false, phone.image["phone_window"])
	
	phone.anims.button["stop"] = GuiButton(19, 490, 272, 35, "Stop animation", false, phone.image["phone_window"])
	
	Anims.all = {phone.anims.gridlist, phone.anims.button["do"], phone.anims.button["stop"]}
	
	for _, gui in pairs(Anims.all) do
		gui.visible = false
	end
end
Anims.create()

function Anims.toggle()
	for _, gui in pairs(Anims.all) do
		gui.visible = not gui.visible
		Anims.open = gui.visible
	end
end

function Anims.perform(anim, block)
	if (not localPlayer.onGround or localPlayer.inWater or localPlayer:getData("a") == "HouseRob") then
		return false
	end
	if (not anim) then
		local block, anim = localPlayer:getAnimation()
		for category, anims in pairs(animsTable) do
			for name, data in pairs(anims) do
				if (data[1] == block and data[2] == anim) then
					triggerServerEvent("onPlayerPerformAnimation", resourceRoot)
					break
				end
			end
		end
		return false
	end
	triggerServerEvent("onPlayerPerformAnimation", resourceRoot, anim, block)
end

function Anims.cmd(cmd)
	-- /stopanim(performing)
	if (cmd == "stopanim") then
		Anims.perform()
	end
	-- Anims with cmds(performing)
	for category, anims in pairs(animsTable) do
		for name, data in pairs(anims) do
			if (name:gsub(" ", ""):lower() == cmd) then
				Anims.perform(data[1], data[2])
			end
		end
	end
end

function Anims.cmds()
	-- /stopanim(adding command)
	addCommandHandler("stopanim", Anims.cmd)
	-- Anims with cmds(adding commands)
	for category, anims in pairs(animsTable) do
		for name, data in pairs(anims) do
			addCommandHandler(name:lower():gsub(" ", ""), Anims.cmd)
		end
	end
end
Anims.cmds()

Anims["do"] = function(button)
	if (source ~= phone.anims.button["do"] or button ~= "left") then
		return false
	end
	if (not localPlayer:getAnimation()) then
		local row = phone.anims.gridlist:getSelectedItem()
		if (not row or row == -1) then
			return false
		end
		local str = split(phone.anims.gridlist:getItemData(row, 1), " ")
		local block, anim = str[1], str[2]
		Anims.perform(block, anim)
	end
end
addEventHandler("onClientGUIClick", phone.anims.button["do"], Anims["do"])

function Anims.stop(button)
	if (source ~= phone.anims.button["stop"] or button ~= "left") then
		return false
	end
	if (localPlayer:getAnimation()) then
		Anims.perform()
	end
end
addEventHandler("onClientGUIClick", phone.anims.button["stop"], Anims.stop)