addEvent("onUpdateShamalRGB", true)
addEventHandler("onUpdateShamalRGB", root,
	function (r, g, b, a)
		for _, v in pairs(Element.getAllByType("player")) do
			if v ~= client then
				outputDebugString("syncing")
				triggerClientEvent(v, "onSyncShamalRGB", v, r, g, b, a)
			end
		end
	end
)
