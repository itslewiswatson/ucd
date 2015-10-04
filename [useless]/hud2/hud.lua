local sX, sY = guiGetScreenSize()
local nX, nY = 1366, 768
local hudEnabled = true -- Enable the HUD by default
local disabledHUD = { "health", "armour", "breath", "clock", "money", "weapon", "ammo", "area_name" }

-- We should move these functions to somewhere we can call them from. NGCutil would be a good resource name to store export functions like these.
function tocomma( number )
	while true do  
		number, k = string.gsub( number, "^(-?%d+)(%d%d%d)", '%1,%2' )
		if ( k == 0 ) then
			break
		end
	end
	return number
end
function math.round( number, decimals, method )
    decimals = decimals or 0
    local factor = 10 ^ decimals
    if ( method == "ceil" or method == "floor" ) then return math[method]( number * factor ) / factor
    else return tonumber( ( "%."..decimals.."f" ):format( number ) ) end
end
local counter = 0
local starttick
local currenttick
local player = getLocalPlayer()
addEventHandler( "onClientRender", root,
	function ()
		if not starttick then
			starttick = getTickCount()
		end
		counter = counter + 1
		currenttick = getTickCount()
		if currenttick - starttick >= 1000 then
			counter = counter - 1 -- So it ACTUALLY displays the correct FPS, and not 1 more frame than it actually is.
			setElementData( player, "FPS" , counter )
			counter = 0
			starttick = false
		end
	end
)

function toggleHUD()
	if not hudEnabled then
		for i, v in pairs( disabledHUD ) do
			showPlayerHudComponent( v, false )
		end
		hudEnabled = true
	else
		for i, v in pairs( disabledHUD ) do
			showPlayerHudComponent( v, true )
		end
		hudEnabled = nil
	end
end
addCommandHandler( "hud", toggleHUD )

function renderClock()
	if ( not isPlayerHudComponentVisible( "radar" ) or isPlayerMapVisible() or not hudEnabled ) then return end

	local h, m = getTime()
	
	if m < 10 then
		m = "0"..m
	end
	if h < 10 then
		h = "0"..h
	end
	
	dxDrawText( h..":"..m, ( 1308 / nX ) * sX, ( 26 / nY ) * sY, ( 1357 / nX ) * sX, ( 47 / nY ) * sY, tocolor( 0, 0, 0, 255 ), 1.50, "default", "left", "top", false, false, false, false, false )
	dxDrawText( h..":"..m, ( 1308 / nX ) * sX, ( 24 / nY ) * sY, ( 1357 / nX ) * sX, ( 45 / nY ) * sY, tocolor( 0, 0, 0, 255 ), 1.50, "default", "left", "top", false, false, false, false, false )
	dxDrawText( h..":"..m, ( 1306 / nX ) * sX, ( 26 / nY ) * sY, ( 1355 / nX ) * sX, ( 47 / nY ) * sY, tocolor( 0, 0, 0, 255 ), 1.50, "default", "left", "top", false, false, false, false, false )
	dxDrawText( h..":"..m, ( 1306 / nX ) * sX, ( 24 / nY ) * sY, ( 1355 / nX ) * sX, ( 45 / nY ) * sY, tocolor( 0, 0, 0, 255 ), 1.50, "default", "left", "top", false, false, false, false, false )
	dxDrawText( h..":"..m, ( 1307 / nX ) * sX, ( 25 / nY ) * sY, ( 1356 / nX ) * sX, ( 46 / nY ) * sY, tocolor( 255, 255, 255, 255 ), 1.50, "default", "left", "top", false, false, false, false, false )
end
addEventHandler( "onClientRender", root, renderClock )

function renderMoney()
	if ( not isPlayerHudComponentVisible( "radar" ) or isPlayerMapVisible() or not hudEnabled ) then return end

	local money = getPlayerMoney( localPlayer )
	local money = tocomma( money )
	
	dxDrawText( "$"..money, ( 1184 / nX ) * sX, ( 26 / nY ) * sY, ( 1289 / nX ) * sX, ( 47 / nY ) * sY, tocolor( 0, 0, 0, 255 ), 1.50, "default", "right", "top", false, false, false, false, false )
	dxDrawText( "$"..money, ( 1184 / nX ) * sX, ( 24 / nY ) * sY, ( 1289 / nX ) * sX, ( 45 / nY ) * sY, tocolor( 0, 0, 0, 255 ), 1.50, "default", "right", "top", false, false, false, false, false )
	dxDrawText( "$"..money, ( 1182 / nX ) * sX, ( 26 / nY ) * sY, ( 1287 / nX ) * sX, ( 47 / nY ) * sY, tocolor( 0, 0, 0, 255 ), 1.50, "default", "right", "top", false, false, false, false, false )
	dxDrawText( "$"..money, ( 1182 / nX ) * sX, ( 24 / nY ) * sY, ( 1287 / nX ) * sX, ( 45 / nY ) * sY, tocolor( 0, 0, 0, 255 ), 1.50, "default", "right", "top", false, false, false, false, false )
	dxDrawText( "$"..money, ( 1183 / nX ) * sX, ( 25 / nY ) * sY, ( 1288 / nX ) * sX, ( 46 / nY ) * sY, tocolor( 255, 255, 255, 255 ), 1.50, "default", "right", "top", false, false, false, false, false )
end
addEventHandler( "onClientRender", root, renderMoney )

function renderWeaponAmmo()
	if ( not isPlayerHudComponentVisible( "radar" ) or isPlayerMapVisible() or not hudEnabled ) then return end
	
	local wepSlot = getPedWeaponSlot( localPlayer )
	local clipAmmo = getPedAmmoInClip( localPlayer )
	local totalAmmo = getPedTotalAmmo( localPlayer )
	local wepID = getPedWeapon( localPlayer )
	local ammoIndicatorText = clipAmmo.."/"..totalAmmo - clipAmmo
	
	if ( wepSlot == 6 ) or ( wepSlot == 8 ) or ( wepID == 25 ) or ( wepID == 35 ) or ( wepID == 36 ) then
		ammoIndicatorText = tostring( totalAmmo )
	end

	if ( wepSlot == 0 ) or ( wepSlot == 1 ) or ( wepSlot == 10 ) or ( wepID == 44 ) or ( wepID == 45 ) or ( wepSlot == 12 ) or ( wepID == 46 ) then
		return
	end
	
	dxDrawText( ammoIndicatorText, ( 1185 / nX ) * sX, ( 195 / nY ) * sY, ( 1358 / nX ) * sX, ( 221 / nY ) * sY, tocolor( 0, 0, 0, 255 ), 1.50, "default", "right", "center", false, false, false, false, false )
	dxDrawText( ammoIndicatorText, ( 1185 / nX ) * sX, ( 193 / nY ) * sY, ( 1358 / nX ) * sX, ( 219 / nY ) * sY, tocolor( 0, 0, 0, 255 ), 1.50, "default", "right", "center", false, false, false, false, false )
	dxDrawText( ammoIndicatorText, ( 1183 / nX ) * sX, ( 195 / nY ) * sY, ( 1356 / nX ) * sX, ( 221 / nY ) * sY, tocolor( 0, 0, 0, 255 ), 1.50, "default", "right", "center", false, false, false, false, false )
	dxDrawText( ammoIndicatorText, ( 1183 / nX ) * sX, ( 193 / nY ) * sY, ( 1356 / nX ) * sX, ( 219 / nY ) * sY, tocolor( 0, 0, 0, 255 ), 1.50, "default", "right", "center", false, false, false, false, false )
	dxDrawText( ammoIndicatorText, ( 1184 / nX ) * sX, ( 194 / nY ) * sY, ( 1357 / nX ) * sX, ( 220 / nY ) * sY, tocolor( 255, 255, 255, 255 ), 1.50, "default", "right", "center", false, false, false, false, false )
end
addEventHandler( "onClientRender", root, renderWeaponAmmo )

function renderHealth()
	if ( not isPlayerHudComponentVisible( "radar" ) or isPlayerMapVisible() or not hudEnabled ) then return end
	
	totalHealth = getPedStat( localPlayer, 24 )
	if totalHealth == 1000 then
		totalHealth = 200
	else
		totalHealth = 100
	end
	local currHealth = getElementHealth( localPlayer )
	
	dxDrawRectangle( ( 1183 / nX ) * sX, ( 94 / nY ) * sY, ( 173 / nX ) * sX, ( 23 / nY ) * sY, tocolor( 255, 0, 0, 255 ), false )
	dxDrawText( currHealth.."/"..totalHealth, ( 1245 / nX ) * sX, ( 99 / nY ) * sY,	( 1294 / nX ) * sX, ( 111 / nY ) * sY, tocolor( 0, 0, 0, 255 ), 1.00, "default", "left", "top", false, false, false, false, false ) -- health
	dxDrawText( currHealth.."/"..totalHealth, ( 1245 / nX ) * sX, ( 97 / nY ) * sY, ( 1294 / nX ) * sX, ( 109 / nY ) * sY, tocolor( 0, 0, 0, 255 ), 1.00, "default", "left", "top", false, false, false, false, false ) -- health
	dxDrawText( currHealth.."/"..totalHealth, ( 1243 / nX ) * sX, ( 99 / nY ) * sY, ( 1292 / nX ) * sX, ( 111 / nY ) * sY, tocolor( 0, 0, 0, 255 ), 1.00, "default", "left", "top", false, false, false, false, false ) -- health
	dxDrawText( currHealth.."/"..totalHealth, ( 1243 / nX ) * sX, ( 97 / nY ) * sY, ( 1292 / nX ) * sX, ( 109 / nY ) * sY, tocolor( 0, 0, 0, 255 ), 1.00, "default", "left", "top", false, false, false, false, false ) -- health
	dxDrawText( currHealth.."/"..totalHealth, ( 1244 / nX ) * sX, ( 98 / nY ) * sY, ( 1293 / nX ) * sX, ( 110 / nY ) * sY, tocolor( 255, 255, 255, 255 ), 1.00, "default", "left", "top", false, false, false, false, false ) -- health]]--
end
addEventHandler( "onClientRender", root, renderHealth )

function renderArmour()
	if ( not isPlayerHudComponentVisible( "radar" ) or isPlayerMapVisible() or not hudEnabled ) then return end

	local armourLevel = math.round( getPedArmor( localPlayer ) )
		
	dxDrawRectangle( ( 1238 / nX ) * sX, ( 56 / nY ) * sY, ( 118 / nX ) * sX, ( 23 / nY ) * sY, tocolor( 155, 155, 155, 255 ), false ) -- armour
	dxDrawText( armourLevel, ( 1239 / nX ) * sX, ( 60 / nY ) * sY, ( 1357 / nX ) * sX, ( 80 / nY ) * sY, tocolor( 0, 0, 0, 255 ), 1.00, "default", "center", "center", false, false, false, false, false ) -- armour
	dxDrawText( armourLevel, ( 1239 / nX ) * sX, ( 58 / nY ) * sY, ( 1357 / nX ) * sX, ( 78 / nY ) * sY, tocolor( 0, 0, 0, 255 ), 1.00, "default", "center", "center", false, false, false, false, false ) -- armour
	dxDrawText( armourLevel, ( 1237 / nX ) * sX, ( 60 / nY ) * sY, ( 1355 / nX ) * sX, ( 80 / nY ) * sY, tocolor( 0, 0, 0, 255 ), 1.00, "default", "center", "center", false, false, false, false, false ) -- armour
	dxDrawText( armourLevel, ( 1237 / nX ) * sX, ( 58 / nY ) * sY, ( 1355 / nX ) * sX, ( 78 / nY ) * sY, tocolor( 0, 0, 0, 255 ), 1.00, "default", "center", "center", false, false, false, false, false ) -- armour
	dxDrawText( armourLevel, ( 1238 / nX ) * sX, ( 59 / nY ) * sY, ( 1356 / nX ) * sX, ( 79 / nY ) * sY, tocolor( 255, 255, 255, 255 ), 1.00, "default", "center", "center", false, false, false, false, false ) -- armour]]--
end
addEventHandler( "onClientRender", root, renderArmour )

function renderOxygen()
	if ( not isPlayerHudComponentVisible( "radar" ) or isPlayerMapVisible() or not hudEnabled ) then return end
	if ( not isElementInWater( localPlayer ) ) then return end
	
	local oxygenLevel = math.round( getPedOxygenLevel( localPlayer ) / 10 )
	
	dxDrawRectangle( ( 1183 / nX ) * sX, ( 56 / nY ) * sY, ( 49 / nX ) * sX, ( 23 / nY ) * sY, tocolor( 1, 144, 157, 255 ), false ) -- oxygen
	dxDrawText( oxygenLevel, ( 1184 / nX ) * sX, ( 60 / nY ) * sY, ( 1232 / nX ) * sX, ( 80 / nY ) * sY, tocolor( 0, 0, 0, 255), 1.00, "default", "center", "center", false, false, false, false, false ) -- oxygen
	dxDrawText( oxygenLevel, ( 1184 / nX ) * sX, ( 58 / nY ) * sY, ( 1232 / nX ) * sX, ( 78 / nY ) * sY, tocolor( 0, 0, 0, 255 ), 1.00, "default", "center", "center", false, false, false, false, false ) -- oxygen
	dxDrawText( oxygenLevel, ( 1182 / nX ) * sX, ( 60 / nY ) * sY, ( 1230 / nX ) * sX, ( 80 / nY ) * sY, tocolor( 0, 0, 0, 255 ), 1.00, "default", "center", "center", false, false, false, false, false ) -- oxygen
	dxDrawText( oxygenLevel, ( 1182 / nX ) * sX, ( 58 / nY ) * sY, ( 1230 / nX ) * sX, ( 78 / nY ) * sY, tocolor( 0, 0, 0, 255 ), 1.00, "default", "center", "center", false, false, false, false, false ) -- oxygen
	dxDrawText( oxygenLevel, ( 1183 / nX ) * sX, ( 59 / nY ) * sY, ( 1231 / nX ) * sX, ( 79 / nY ) * sY, tocolor( 255, 255, 255, 255 ), 1.00, "default", "center", "center", false, false, false, false, false ) -- oxygen ]]--
end
addEventHandler( "onClientRender", root, renderOxygen )

function renderWeapon()
	if ( not isPlayerHudComponentVisible( "radar" ) or isPlayerMapVisible() or not hudEnabled ) then return end

	local currWep = getPedWeapon( localPlayer )
	if currWep == 0 then
		imageDir = "icons/fist.png"
	elseif currWep == 1 then
		imageDir = "icons/brassknuckle.png"
	elseif currWep == 2 then
		imageDir = "icons/golfclub.png"
	elseif currWep == 24 then
		imageDir = "icons/desert_eagle.png"
	elseif currWep == 27 then
		imageDir = "icons/shotgspa.png"
	elseif currWep == 29 then
		imageDir = "icons/mp5lng.png"
	elseif currWep == 30 then
		imageDir = "icons/ak47.png"
	elseif currWep == 33 then
		imageDir = "icons/cuntgun.png"
	elseif currWep == 34 then
		imageDir = "icons/sniper.png"
	elseif currWep == 22 then
		imageDir = "icons/colt45.png"
	elseif currWep == 23 then
		imageDir = "icons/silenced.png"
	elseif currWep == 25 then
		imageDir = "icons/chromegun.png"
	elseif currWep == 26 then
		imageDir = "icons/sawnoff.png"
	elseif currWep == 28 then
		imageDir = "icons/micro_uzi.png"
	elseif currWep == 32 then
		imageDir = "icons/tec9.png"
	elseif currWep == 16 then
		imageDir = "icons/grenade.png"
	elseif currWep == 31 then
		imageDir = "icons/m4.png"
	elseif currWep == 35 then
		imageDir = "icons/rocketla.png"
	elseif currWep == 3 then
		imageDir = "icons/nitestick.png"
	elseif currWep == 4 then
		imageDir = "icons/knifecur.png"
	elseif currWep == 5 then
		imageDir = "icons/bat.png"
	elseif currWep == 6 then
		imageDir = "icons/shovel.png"
	elseif currWep == 7 then
		imageDir = "icons/poolcue.png"
	elseif currWep == 8 then
		imageDir = "icons/katana.png"
	elseif currWep == 9 then
		imageDir = "icons/chnsaw.png"
	elseif currWep == 17 then
		imageDir = "icons/teargas.png"
	elseif currWep == 18 then
		imageDir = "icons/molotov.png"
	elseif currWep == 39 then
		imageDir = "icons/satchel.png"
	elseif currWep == 42 then
		imageDir = "icons/fireextinguisher.png"
	elseif currWep == 10 then
		imageDir = "icons/gun_dildo1.png"
	elseif currWep == 11 then
		imageDir = "icons/gun_dildo2.png"
	elseif currWep == 12 then
		imageDir = "icons/gun_vibe1.png"
	elseif currWep == 14 then
		imageDir = "icons/flowera.png"
	elseif currWep == 15 then
		imageDir = "icons/gun_cane.png"
	elseif currWep == 36 then
		imageDir = "icons/heatseek.png"
	elseif currWep == 38 then
		imageDir = "icons/minigun.png"
	elseif currWep == 46 then
		imageDir = "icons/parachute.png"
	elseif currWep == 45 then
		imageDir = "icons/infared.png"
	elseif currWep == 44 then
		imageDir = "icons/nightvis.png"
	elseif currWep == 40 then
		imageDir = "icons/detonator.png"
	elseif currWep == 43 then
		imageDir = "icons/camera.png"
	elseif currWep == 41 then
		imageDir = "icons/spraycan.png"
	elseif currWep == 37 then
		imageDir = "icons/flamethrower.png"
	end
	
	-- Gun is drawn at 0.75 of actual image size (256 x 80)
	dxDrawImage( ( 1163 / nX ) * sX, ( 127 / nY ) * sY, ( 204.8 / nX ) * sX, ( 65 / nY ) * sY, imageDir, 0, 0, 0, tocolor( 255, 255, 255, 255 ), false )
end
addEventHandler( "onClientRender", root, renderWeapon )

technic = dxCreateFont( "technic.ttf", 10 )
function renderPingFPS()
	if ( not isPlayerHudComponentVisible( "radar" ) or isPlayerMapVisible() or not hudEnabled ) then return end

	local ping = getPlayerPing( localPlayer )
	local fps = getElementData( localPlayer, "FPS" )
	
	dxDrawText( "FPS: "..fps.. "  Ping: "..ping, ( 1167 / nX ) * sX, ( 3 / nY ) * sY, ( 1357 / nX ) * sX, ( 26 / nY ) * sY, tocolor( 0, 0, 0, 255 ), 1, "default-bold", "right", "center", false, false, false, false, false )
	dxDrawText( "FPS: "..fps.. "  Ping: "..ping, ( 1167 / nX ) * sX, ( 1 / nY ) * sY, ( 1357 / nX ) * sX, ( 24 / nY ) * sY, tocolor( 0, 0, 0, 255 ), 1, "default-bold", "right", "center", false, false, false, false, false )
	dxDrawText( "FPS: "..fps.. "  Ping: "..ping, ( 1165 / nX ) * sX, ( 3 / nY ) * sY, ( 1355 / nX ) * sX, ( 26 / nY ) * sY, tocolor( 0, 0, 0, 255 ), 1, "default-bold", "right", "center", false, false, false, false, false )
	dxDrawText( "FPS: "..fps.. "  Ping: "..ping, ( 1165 / nX ) * sX, ( 1 / nY ) * sY, ( 1355 / nX ) * sX, ( 24 / nY ) * sY, tocolor( 0, 0, 0, 255 ), 1, "default-bold", "right", "center", false, false, false, false, false )
	dxDrawText( "FPS: "..fps.. "  Ping: "..ping, ( 1166 / nX ) * sX, ( 2 / nY ) * sY, ( 1356 / nX ) * sX, ( 25 / nY ) * sY, tocolor( 255, 255, 255, 255 ), 1, "default-bold", "right", "center", false, false, false, false, false )--]]
end
addEventHandler( "onClientRender", root, renderPingFPS )


function renderZone()
	if ( not isPlayerHudComponentVisible( "radar" ) or isPlayerMapVisible() or not hudEnabled ) then return end
	local pX, pY, pZ = getElementPosition( localPlayer )
	local localZone = getZoneName( pX, pY, pZ )
	local cityZone = getZoneName( pX, pY, pZ, true )
	local textToRender = string.upper( localZone..", "..cityZone )
	
	if ( localZone == cityZone ) then
		textToRender = string.upper( localZone )
	end
	if ( localZone == "Unknown" ) or ( cityZone == "Unknown" ) then
		textToRender = string.upper( "San Andreas" )
	end
	
	dxDrawText( textToRender, ( 89 / nX ) * sX, ( 562 / nY ) * sY, ( 279 / nX ) * sX, ( 565 / nY ) * sY, tocolor(255, 255, 255, 255), 1.00, technic, "center", "center", false, false, false, false, false)
end
addEventHandler( "onClientRender", root, renderZone )
