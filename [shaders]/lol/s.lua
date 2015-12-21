addEvent("onUpdateShamalRGB", true)
addEventHandler("onUpdateShamalRGB", root,
	function (r, g, b)
		for _, v in pairs(Element.getAllByType("player")) do
			if v ~= client then
				outputDebugString("syncing")
				triggerClientEvent(v, "onSyncShamalRGB", v, r, g, b)
			end
		end
	end
)
