-- Setting water properties.
height = 10
lsh = 0
SizeVal = 2998
-- Defining variables.
southWest_X = -SizeVal
southWest_Y = -SizeVal
southEast_X = SizeVal
southEast_Y = -SizeVal
northWest_X = -SizeVal
northWest_Y = SizeVal
northEast_X = SizeVal
northEast_Y = SizeVal
 
-- OnClientResourceStart function that creates the water.
function thaResourceStarting( )
    water = createWater( southWest_X, southWest_Y, height, southEast_X, southEast_Y, height, northWest_X, northWest_Y, height, northEast_X, northEast_Y, height )
    setWaterLevel( height )
	
	damWater = createWater( -1434, 2044, 41, -440, 2014, 41, -504, 2854, 41, -340, 2900, 41, false )
						--    x		y	 z	  x		y	z	  x		y	z	  x		y	 z
						---- Clip the edges of the dam!!!!
						
end
addEventHandler( "onResourceStart", resourceRoot, thaResourceStarting ) ---388.68906 2907.07349 135.90408

addEventHandler( "onResourceStop", resourceRoot,
	function ()
		destroyElement( damWater )
		setWaterLevel( 0 )
	end
)