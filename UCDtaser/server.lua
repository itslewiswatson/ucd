local antiSpam = {}

addEvent("onPlayerTased", true)
addEventHandler("onPlayerTased", root,
	function (cop)
		if (antiSpam[source]) then return end
		if (source:getData("tased")) then return end
		if (exports.UCDlaw:isPlayerArrested(source)) then return end
		if (source.inVehicle) then return end
		if (source.alpha ~= 255) then return end
		antiSpam[source] = true
		Timer(function (source) if (isElement(source)) then antiSpam[source] = nil end end, 5000, 1, source)
		source:setAnimation("CRACK", "crckidle2")
		source:setData("tased", "full")
		cop.weaponSlot = 1
		source.weaponSlot = 0
		Timer(
			function (source)
				if (isElement(source)) then
					source:setAnimation()
					source:setData("tased", "half")
					Timer(
						function(source)
							source:removeData("tased")
						end, 1500, 1, source
					)
				end
			end, 2250, 1, source
		)
	end
)