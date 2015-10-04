local locations = {
	{ "LS - Train Station", 1746.989, -1943.890, 12.568 },
	{ "LS - Airport", 1685.616, -2334.474, 12.546 },
	{ "LS - Docks", 2440.779, -2437.625, 12.621 },
	{ "LS - Ganton", 2273.818, -1669.269, 14.342 },
	{ "LS - Pig Pen", 2435.896, -1247.588, 22.893 },
	{ "LS - Jefferson", 2335.129, -1144.176, 25.993 },
	{ "LS - East Prison Release", 2749.955, -1423.4, 30.649 },
	{ "LS - West Prison Release", 408.801, -1566.401, 26.576 },
	{ "LS - Skate Park", 1948.622, -1451.891, 12.547 },
	{ "LS - Bank and Vehicle Recovery", 1515.874, -1024.371, 22.82 },
	{ "LS - All Saints Hospital", 1183.712, -1348.314, 13.185 },
	{ "LS - Graveyard", 953.74, -1119.075, 22.829 },
	{ "LS - Santa Maria Beach", 524.966, -1738.658, 11.025 },
	{ "LS - Court House", 1508.187, -1746.456, 12.547} ,
	
	{ "RC - Dillimore", 691.693, -649.351, 15.332 },
	{ "RC - Blueberry", 171.198, -132.268, 0.578 },
	{ "RC - Montgomery", 1297.23, 312.536, 18.555 },
	{ "RC - Palamino Creek", 2235.049, 32.134, 25.484 },
	
	{ "FC - Farm", -1071.262, -1340.191, 128.695 },
	{ "WS - Angel Pine", -2173.921, -2285.746, 29.625 },
	
	{ "SF - Train Station", -1973.238, 117.546,  26.687 },
	{ "SF - Airport", -1421.593, -287.498, 13.148 },
	{ "SF - Hospital", -2690.539, 574.532, 13.758 },
	{ "SF - Battery Point", -2600.743, 1348.53, 6.188 },
	{ "SF - Garcia", -2269.558, -140.308, 34.32 },
	{ "SF - Train to Seaside City", -3068.241, -177.19, 0.369 },
	
	{ "SC - Shopping District", -3603.275, -348.027, 0.45 },
	{ "SC - Train Station", -4507.031, -188.211, 0.469 },
	{ "SC - Farm", -4854.04, -123.041, 6.956 },
	{ "SC - Airport", -5522.749, -218.524, 1.53 },
	{ "SC - Hospital", -5346.968, 7.303, 6.686 },
	
	{ "TR - El Quebrados", -1504.573, 2582.22, 54.836 },
	{ "TR - Sherman Dam", -893.534, 1992.152, 59.695 },
	{ "TR - Bayside Marina", -2280.573, 2345.299, 3.976 },
	
	{ "BC - Verdant Meadows Air Strip", 422.820, 2539.364, 15.524 },
	{ "BC - Hunter Quarry", 810.255, 856.354, 10.062 },
	{ "BC - Fort Carson", -255.575, 1108.153, 18.742 },
	
	{ "LV - Hospital", 1631.35, 1850.89, 9.82 },
	{ "LV - Airport", 1311.952, 1262.574, 9.82 },

}

local markers = {}
local costDivider = 3.5

addEventHandler( "onResourceStart", resourceRoot,
	function ()
		for i, loc in ipairs ( locations ) do
			local marker = createMarker( loc[2], loc[3], loc[4], "cylinder", 2, 255, 137, 0 )
			markers[marker] = loc
			addEventHandler( "onMarkerHit", marker, destMarker )
		end
	end
)

function destMarker( plr, dimMatch )
	if ( not dimMatch or not isElement( plr ) or getElementType( plr ) ~= "player" or isPedInVehicle( plr ) ) then
		return false
	end
	
	local locs = {}
	local x, y, z = getElementPosition( plr )
	
	for i, loc in ipairs ( locations ) do
		local cost = getDistanceBetweenPoints3D( x, y, z, loc[2], loc[3], loc[4] )
		local cost = math.floor( cost / costDivider )
		table.insert( locs, {loc[1], cost } )
	end
	
	triggerClientEvent( plr, "transport.gui", plr, locs )
end

function travelToDest( dest )
	local x, y, z = getElementPosition( client )
	
	for i, loc in ipairs ( locations ) do
		if ( loc[1] == dest ) then
			local cost = getDistanceBetweenPoints3D( x, y, z, loc[2], loc[3], loc[4] )
			local cost = math.floor( cost / costDivider )
			
			if ( cost > getPlayerMoney( client ) ) then
				exports.DENdxmsg:createNewDxMessage( client, "You don't have enough money to go to "..tostring( dest ), 255, 0, 0 )
				return false
			end
			
			if ( cost < 2 ) then
				exports.DENdxmsg:createNewDxMessage( client, "You're already at "..tostring( dest ), 255, 0, 0 )
				return false
			end

			setElementPosition( client, loc[2], loc[3], loc[4] + 1 )
			return true
		end
	end
end
addEvent( "transport.travel", true )
addEventHandler( "transport.travel", root, travelToDest )