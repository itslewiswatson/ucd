addEventHandler("onColShapeHit", LV,
	function (ele, matchingDimension)
		if (ele.type == "player" and matchingDimension) then
			outputDebugString("Entered LV")
			triggerEvent("onPlayerEnterLV", ele)
		end
	end
)

addEventHandler("onColShapeLeave", LV,
	function (ele, matchingDimension)
		if (ele.type == "player" and matchingDimension) then
			outputDebugString("Left LV")
			triggerEvent("onPlayerLeaveLV", ele)
		end
	end
)

function onPlayerLeaveLV()
	
end
addEvent("onPlayerLeaveLV", true)
addEventHandler("onPlayerLeaveLV", root, onPlayerLeaveLV)

function onPlayerEnterLV()
	
end
addEvent("onPlayerEnterLV", true)
addEventHandler("onPlayerEnterLV", root, onPlayerEnterLV)
