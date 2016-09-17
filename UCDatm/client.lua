local sX, sY = guiGetScreenSize()
local window = GuiWindow(0, 0, 400, 400, "UCD | Banking", false)
window.movable = false
window.sizable = false
window.visible = false

for _, data in ipairs(atms) do
	local atm = Object(2942, data.x, data.y, data.z-0.35, 0, 0, data.rot-180)
	atm.breakable = false
end

window:setPosition((sX - 400) / 2, (sY - 400) / 2, false)
local label = GuiLabel(0, 22.5, 400, 15, "", false, window)
label:setColor(0, 255, 0)
label.font = "default-bold-small"
label:setHorizontalAlign("center")
GuiLabel(10, (22.5+17.5+2), 400, 25, "Amount:", false, window)
local mEdit = GuiEdit(60, (22.5+17.5), 400, 25, "", false, window)
local exit = GuiButton(0, (400-35), 400, 35, "Close", false, window)
local withdraw = GuiButton(0, (22.5+17.5+27.5), 190, 30, "Withdraw", false, window)
local deposit = GuiButton(205, (22.5+17.5+27.5), 195, 30, "Deposit", false, window)
GuiLabel(10, (22.5+17.5+27.5+34.5+5), 400, 30, "Account:", false, window)
local aEdit = GuiEdit(60, (22.5+17.5+27.5+32.5+5), 400, 25, "", false, window)
local aSend = GuiButton(0, (22.5+17.5+27.5+32.5+10+30), 400, 30, "Send to written account name", false, window)
local logList = GuiGridList(0, (22.5+17.5+27.5+32.5+10+30+35), 400, 185, false, window)
logList.sortingEnabled = false
logList:addColumn("Log", 0.6)
logList:addColumn("Date", 0.3)
local antiSpam = nil
local oldText = ""

function formatTick(tick)
	local full = getRealTime(tick)
	return string.format("%02d:%02d:%02d %02d/%02d/%04d",
		full.second,
		full.minute,
		full.hour,
		full.monthday,
		full.month + 1,
		full.year + 1900
	)
end

function toggleGUI(show, balance, logs, src)
	window.visible = show
	showCursor(show)
	guiSetInputMode(show and "no_binds_when_editing" or "allow_binds")
	if (not balance) then
		balance = 0
	end
	logList:clear()
	if (logs) then
		for i = 1, #logs do
			local row = logList:addRow()
			logList:setItemText(row, 1, logs[i].action, false, false)
			logList:setItemText(row, 2, formatTick(logs[i].tick), false, false)
		end
	end
	label.text = "Bank balance: $"..exports.UCDutil:tocomma(balance)
end
addEvent("toggleBankingGUI", true)
addEventHandler("toggleBankingGUI", resourceRoot, toggleGUI)

addEventHandler("onClientGUIChanged", root,
	function ()
		if (source == mEdit) then
			local text = mEdit.text
			text = text:gsub(",", "")
			text = text:gsub(" ", "")
			text = text:gsub("%.", "")
			if (not tonumber(text) and text ~= "") then
				mEdit.text = oldText
				return
			end
			mEdit.text = exports.UCDutil:tocomma(text)
			if (not getKeyState("backspace")) then
				mEdit.caretIndex = mEdit.text:len()
			end
			oldText = mEdit.text
		end
	end
)

function getBankBalance()
	local money = label.text
	money = gettok(money, 2, "$")
	money = money:gsub(",", "")
	return tonumber(money)
end

addEventHandler("onClientGUIClick", root,
	function (button, state)
		if (button == "left" and state == "up") then
			local amount, msg, r, g, b, action, account, doAction
			if (source == deposit or source == withdraw or source == aSend) then
				if (antiSpam) then return end
				amount = mEdit.text:gsub(",", "")
				amount = amount:gsub(" ", "")
				amount = tonumber(amount)
				action = source == deposit and "deposit" or source == withdraw and "withdraw" or source == aSend and "send"
				antiSpam = true
				Timer(function () antiSpam = false end, 10000, 1)
				if (not amount) then
					exports.UCDdx:new("Write an amount first", 255, 0, 0)
					return
				end
				if (amount <= 0) then
					exports.UCDdx:new("You can't "..action.." $0 or less", 255, 0, 0)
					return
				end
				if (source == aSend) then
					account = aEdit.text
					if (account:gsub(" ", "") == "") then
						exports.UCDdx:new("Write an account name first", 255, 0, 0)
						return
					end
				end
			end
			if (source == exit) then
				toggleGUI(false)
			elseif (source == deposit) then
				if (getPlayerMoney() > amount) then
					msg = "Deposited $"..exports.UCDutil:tocomma(amount)
					r, g, b = 0, 255, 0
					doAction = true
				else
					msg = "Not enough money to deposit $"..exports.UCDutil:tocomma(amount)
					r, g, b = 255, 0, 0
					doAction = false
				end
			elseif (source == withdraw) then
				if (amount <= getBankBalance()) then
					msg = "Withdrawn $"..exports.UCDutil:tocomma(amount)
					r, g, b = 0, 255, 0
					doAction = true
				else
					msg = "Not enough money in bank to withdraw $"..exports.UCDutil:tocomma(amount)
					r, g, b = 255, 0, 0
					doAction = false
				end
			elseif (source == aSend) then
				if (amount <= getBankBalance()) then
					doAction = true
				else
					msg = "Not enough money in bank to send"
					r, g, b = 255, 0, 0
				end
			end
			if (msg) then
				exports.UCDdx:new(msg, r, g, b)
			end
			if (doAction) then
				triggerServerEvent("doBankAction", resourceRoot, action, amount, account)
			end
		end
	end
)