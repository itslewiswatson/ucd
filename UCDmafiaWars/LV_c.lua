local t

addEventHandler("onClientColShapeHit", LV,
	function (ele, matchingDimension)
		if (ele.type == "player" and ele == localPlayer and matchingDimension) then
			exports.UCDdx:add("Welcome to Las Venturas", 255, 255, 0)
			t = Timer(function () exports.UCDdx:del("Welcome to Las Venturas") end, 2500, 1)
		end
	end
)

addEventHandler("onClientColShapeLeave", LV,
	function (ele, matchingDimension)
		if (ele.type == "player" and ele == localPlayer and matchingDimension) then
			exports.UCDdx:del("Welcome to Las Venturas")
			if (t and isTimer(t)) then
				t:kill()
				t = nil
			end
		end
	end
)
