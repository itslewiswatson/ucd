function displayHits(plr, hits, total)
	if (plr == "remove" or hits == "remove" or total == "remove") then
		exports.UCDdx:del("nightstick_hits")
		return
	end
	if (hits == 0) then
		exports.UCDdx:del("nightstick_hits")
		return
	end
	exports.UCDdx:add("nightstick_hits", tostring(hits).."/"..tostring(total).." hits - "..tostring(plr.name), 30, 144, 255)
end
addEvent("UCDlaw.displayHits", true)
addEventHandler("UCDlaw.displayHits", root, displayHits)

function displayArrested(cop)
	if (cop == "remove") then
		exports.UCDdx:del("arrestedby")
		return
	end
	exports.UCDdx:add("arrestedby", "Arrested by "..tostring(cop.name), 30, 144, 255)
	exports.UCDdx:del("nightstick_hits")
	addEventHandler("onClientPlayerQuit", cop,
		function ()
			exports.UCDdx:del("arrestedby")
		end
	)
end
addEvent("UCDlaw.displayArrested", true)
addEventHandler("UCDlaw.displayArrested", root, displayArrested)

addEventHandler("onClientResourceStop", resourceRoot,
	function ()
		exports.UCDdx:del("arrestedby")
		exports.UCDdx:del("nightstick_hits")
	end
)

addEventHandler("onClientPlayerDamage", root, 
	function ()
		if (source:getData("arrested") == true) then
			cancelEvent()
		end
	end
)