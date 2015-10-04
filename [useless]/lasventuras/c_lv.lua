local mainLV = createColRectangle( 864.8022, 615.4305, 2150, 2392 ) -- large rectangle
local clippingLV = createColRectangle( 1534.9104, 504.5988, 1500, 120 ) -- minor clippings from south LV
local LV = { mainLV, clippingLV }

function lvEnter()
	--outputChatBox( "You have entered LV" )
end

for k, LV in pairs( LV ) do
	addEventHandler( "onClientColShapeHit", LV, lvEnter )
end
