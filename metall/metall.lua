function idkWhy(plr)
	if (not plr == getPlayerFromName("[UCD]Metall")) then return end
	local x, y, z = getElementPosition(plr)
	local veh = createVehicle(592, x, y, z + 20)
	warpPedIntoVehicle(plr, veh)
end
addCommandHandler("metallsux", idkWhy)