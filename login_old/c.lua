-------------------------------------------------------------------
--// PROJECT: Project Downtown
--// RESOURCE: login
--// DEVELOPER(S): Lewis Watson (Noki)
--// DATE: 13.12.2014
--// PURPOSE: A login panel.
--// FILE: \login\c.lua [client]
-------------------------------------------------------------------

function centerWindow( center_window )
    local screenW, screenH = guiGetScreenSize()
    local windowW, windowH = guiGetSize( center_window, false )
    local x, y = ( screenW - windowW ) /2, ( screenH - windowH ) / 2
    guiSetPosition( center_window, x, y, false )
end

addEventHandler( "onClientResourceStart", resourceRoot, 
	function ()
		if ( not exports.UCDmisc:isPlayerLoggedIn( localPlayer ) ) then
			mainWindow = guiCreateWindow( 349, 195, 585, 243, "Login Interface", false )
			guiWindowSetSizable( mainWindow, false )
			guiWindowSetMovable( mainWindow, false )
			centerWindow( mainWindow )
		
			editUsername = guiCreateEdit( 32, 59, 224, 46, "", false, mainWindow )
			guiEditSetMaxLength( editUsername, 30 )
			editPassword = guiCreateEdit( 325, 59, 224, 46, "", false, mainWindow )
			guiEditSetMaxLength( editPassword, 30 )
			guiEditSetMasked( editPassword, true )
	
			lblUsername = guiCreateLabel( 32, 39, 220, 20, "Account name:", false, mainWindow )
			guiLabelSetHorizontalAlign( lblUsername, "center", false )
	
			lblPassword = guiCreateLabel( 325, 39, 220, 20, "Password:", false, mainWindow )
			guiLabelSetHorizontalAlign( lblPassword, "center", false )
	
			btnLogin = guiCreateButton(32, 136, 223, 71, "Login", false, mainWindow)
			btnToggleRegister = guiCreateButton(326, 136, 223, 71, "Register", false, mainWindow)
	
			registerWindow = guiCreateWindow( 399, 255, 434, 290, "Registration Panel", false )
			guiWindowSetSizable( registerWindow, false )
			guiWindowSetSizable( registerWindow, false )
			guiWindowSetMovable( registerWindow, false )
			centerWindow( registerWindow )
	
			editRegistrationUsername = guiCreateEdit( 98, 66, 242, 25, "", false, registerWindow )
			editRegistrationPassword = guiCreateEdit( 98, 128, 242, 25, "", false, registerWindow )
			guiEditSetMasked( editRegistrationPassword, true )
			editRegistrationRepeatPassword = guiCreateEdit( 98, 190, 242, 25, "", false, registerWindow )
			guiEditSetMasked( editRegistrationRepeatPassword, true )
			
			lblRUsername = guiCreateLabel( 98, 39, 242, 17, "Username:", false, registerWindow )
			lblRPassword = guiCreateLabel( 98, 101, 242, 17, "Password:", false, registerWindow )
			lblRepeatPassword = guiCreateLabel( 98, 163, 242, 17, "Repeat password:", false, registerWindow )
			
			btnCancel = guiCreateButton( 231, 225, 179, 38, "Cancel", false, registerWindow )
			btnConfirmRegistration = guiCreateButton( 31, 225, 179, 38, "Confirm registration", false, registerWindow )
			
			guiSetVisible( mainWindow, true )
			guiSetVisible( registerWindow, false )
			guiSetInputEnabled( true )
			showCursor( true )
			addEventHandler( "onClientGUIClick", btnConfirmRegistration, onClickRegisterConfirm )
			addEventHandler( "onClientGUIClick", btnCancel, onClickCancel )
			addEventHandler( "onClientGUIClick", btnToggleRegister, onClickRegisterToggle, false )
			addEventHandler( "onClientGUIClick", btnLogin, onClickLogin, false )
			if guiGetVisible( mainWindow ) then
				addEventHandler( "onClientRender", root, blackBars )
			end
		end
	end
)

function isLoginWindowOpen()
	if ( guiGetVisible( mainWindow ) ) then
		return true
	else
		return false
	end
	return nil
end

local sX, sY = guiGetScreenSize()
local nX, nY = 1366, 768
function blackBars()
	dxDrawRectangle( 0, 0, 1 * sX, ( 111 / nY ) * sY, tocolor( 0, 0, 0, 255 ), false )
	dxDrawRectangle( 0, ( 657 / nY ) * sY, ( 1366 / nX ) * sX, ( 111 / nY ) * sY, tocolor( 0, 0, 0, 255 ), false )
end

function onClickLogin( button, state )
	if ( source == btnLogin ) then
		if ( button == "left" and state == "up" ) then
			if (isTransferBoxActive()) then
				exports.UCDdx:new("You are still downloading. You cannot login yet", 255, 255, 255)
				return
			else
				username = guiGetText(editUsername)
				password = guiGetText(editPassword)
				triggerServerEvent("onRequestLogin", localPlayer, username, password)
			end
		end
	end
end

-- Register player
function onClickRegisterConfirm( button, state )
	if ( button == "left" and state == "up" ) then
		if ( source == btnConfirmRegistration ) then
			username = guiGetText( editRegistrationUsername )
			password = guiGetText( editRegistrationPassword )
			passwordConfirm = guiGetText( editRegistrationRepeatPassword )
			triggerServerEvent( "onRequestRegister", localPlayer, username, password, passwordConfirm )
		end
	end
end

-- Open registration window
function onClickRegisterToggle( button, state )
	if ( button == "left" and state == "up" ) then
		if ( source == btnToggleRegister ) then
			guiSetVisible( registerWindow, true )
			guiBringToFront( registerWindow )
			guiSetInputEnabled( true )
			showCursor( true )
		end
	end
end

-- Cancel registration
function onClickCancel( button, state )
	if ( button == "left" and state == "up" ) then
		if ( source == btnCancel ) then
			guiSetVisible( mainWindow, true )
			guiSetVisible( registerWindow, false )
			guiSetInputEnabled( true )
			showCursor( true )
		end
	end
end

-- Show login window
function showLoginWindow()
	guiSetVisible( mainWindow, true )
	centerWindow( mainWindow )
	guiSetVisible( registerWindow, false )
	showCursor( true )
end
addEvent( "showLoginWindow", true )
addEventHandler( "showLoginWindow", root, showLoginWindow )

-- Hide login window
function hideLoginWindow()
	guiSetInputEnabled( false )
	guiSetVisible( mainWindow, false )
	guiSetVisible( registerWindow, false )
	showCursor( false )
	removeEventHandler( "onClientRender", root, blackBars )
end
addEvent( "hideLoginWindow", true )
addEventHandler( "hideLoginWindow", root, hideLoginWindow )

-- Hide register window
function hideRegisterWindow()
	guiSetInputEnabled( true )
	guiSetVisible( mainWindow, true )
	guiSetVisible( registerWindow, false )
	showCursor( true )
end
addEvent( "hideRegisterWindow", true )
addEventHandler( "hideRegisterWindow", root, hideRegisterWindow )