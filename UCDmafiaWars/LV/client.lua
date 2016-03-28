local t

addEventHandler("onClientColShapeHit", LV,
	function (ele, matchingDimension)
		if (ele.type == "player" and ele == localPlayer and matchingDimension) then
			exports.UCDdx:add("welcometolv", "Welcome to Las Venturas", 255, 255, 0)
			t = Timer(function () exports.UCDdx:del("welcometolv") end, 5000, 1)
		end
	end
)

addEventHandler("onClientColShapeLeave", LV,
	function (ele, matchingDimension)
		if (ele.type == "player" and ele == localPlayer and matchingDimension) then
			exports.UCDdx:del("welcometolv")
			if (t and isTimer(t)) then
				t:destroy()
				t = nil
			end
		end
	end
)
