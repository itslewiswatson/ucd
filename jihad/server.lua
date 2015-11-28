-- Table that stores some data
local jihad = {}
local math = math

-- The time the player should wait before he can jihad again, in seconds
local wait = 60

-- Command to start the jihad attack
addCommandHandler( "jihad", 
	function ( thePlayer )
		if ( jihad[ thePlayer ] ) and ( getTickCount() - jihad[ thePlayer ] < ( wait * 1000 ) ) then
			outputChatBox( "You can't jihad right now, you need to wait 60 seconds!", thePlayer, 225, 0, 0 )
		else
			jihad[ thePlayer ] = getTickCount()
			local x, y, z = getElementPosition( thePlayer )
			playJihadSound( thePlayer )
			--local spark = createObject( 2046, x, y, z )
			--setElementCollisionsEnabled ( spark, false )
			--attachElements( spark, thePlayer )
			--setTimer( destroyElement, 600, 1, spark )
			setTimer( startExplosions, 10000, 1, thePlayer )
		end
	end
)

-- Function that plays the sound for all nearby players
function playJihadSound( thePlayer )
	if ( isElement( thePlayer ) ) then
		local x, y, z = getElementPosition( thePlayer )
		for k, aPlayer in ipairs ( getElementsByType( "player" ) ) do
			local x2, y2, z2 = getElementPosition( aPlayer )
			if ( getDistanceBetweenPoints2D( x, y, x2, y2 ) <= 80 ) then
				triggerClientEvent( aPlayer, "onClientPlayJihadSound", aPlayer, thePlayer )
			end
		end
	end
end

-- Function that creates the explosions
function startExplosions ( thePlayer )
	if ( isElement( thePlayer ) ) then
		local x, y, z = getElementPosition( thePlayer ) 
		createExplosion ( x, y, z, 10, thePlayer )
		for i = 1, 5 do
			local x, y, z = getElementPosition( thePlayer ) 
			createExplosion ( x - math.random( 8 ) + math.random( 8 ), y  - math.random( 8 ) + math.random( 8 ), z, 10, thePlayer )
		end
	end
end