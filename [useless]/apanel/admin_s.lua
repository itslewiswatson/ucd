--[[function _kickPlayer( plr, cmd, target, ... )
	if ( not hasObjectPermissionTo( plr, "function.kickPlayer", false ) ) then return false end
	if not target then exports.dx:new( plr, "You must specify a player to kick", 255, 0, 0 ) return nil end
	local kp = exports.misc:getPlayerFromPartialName( target )
	if kp then
		local reason = table.concat( {...}, " " ) 
		local plrName = getPlayerName( plr )
		local kpName = getPlayerName( kp )
		if plrName == kpName then exports.dx:new( plr, "You cannot kick yourself", 255, 0, 0 ) return false end
		if ( not reason ) or ( reason == "" ) then
			reasonMsg = ""
		else
			reasonMsg = "("..reason..")"
		end
		kickPlayer( kp, plr, reason )
		outputDebugString( kpName.." has been kicked by "..plrName.." "..reasonMsg )
		outputServerLog( kpName.." has been kicked by "..plrName.." "..reasonMsg )
		outputChatBox( kpName.." has been kicked by "..plrName.." "..reasonMsg, root, 255, 0, 0 )
	else
		exports.dx:new( plr, "There is no player named "..target, 255, 0, 0 )
	end
end
addCommandHandler( "kick", _kickPlayer, true )

function reconnectPlayer( plr, cmd, target )
	if ( not hasObjectPermissionTo( plr, "function.kickPlayer", false ) ) then return false end
	if not target then exports.dx:new( plr, "You must specify a player you want to reconnect", 255, 0, 0 ) return nil end
	local targetargetPlayer = exports.misc:getPlayerFromPartialName( target )
	if targetPlayer then
		local recPlayerName = getPlayerName( targetPlayer )
		local clientName = getPlayerName( plr )
		if recPlayerName == clientName then exports.dx:new( plr, "You cannot reconnect yourself this way", 255, 0, 0 ) return false end
		if ( getTeamName( getPlayerTeam( targetPlayer ) ) == "Admins" ) then exports.dx:new( plr, "You cannot kick an on-duty admin", 255, 0, 0 ) return false end-- We might reconstruct this and use rank tables etc.
		
		local plrRedirection = redirectPlayer( targetPlayer, "", 0 )
		if ( plrRedirection ) then
			outputChatBox( clientName.." reconnected "..targetPlayerName, root, 255, 0, 0 )
			outputServerLog( plr.." reconnected "..targetPlayerName ) -- idek?
		end		
	else
		exports.dx:new( plr, "We couldn't find a player matching that name", 255, 0, 0 )
	end
end
addCommandHandler( "recon", reconnectPlayer )

function _banPlayer( cmd, target, reason, length )
	-- _banPlayer( string targetName, string reason, float length )
	-- This will automatically ban their account and serial
	local banReason = table.concat( { reason }, " " )
	if ( not hasObjectPermissionTo( thePlayer, "function.kickPlayer", false ) ) then return false end
	
	if not target and not reason and not length then
		outputChatBox( "Syntax is /ban playerName banReason banLength", thePlayer, 0, 255, 0 )
		return nil
	else
		if target then
			if reason then
				if length then
					if tonumber( length ) == nil then
						exports.dx:new( thePlayer, "Enter a valid ban time", 255, 0, 0 )
						return false
					end
				else
					exports.dx:new( thePlayer, "You must enter a ban time amount", 255, 0, 0 )
					return nil
				end
			else
				exports.dx:new( thePlayer, "You must specify a ban reason", 255, 0, 0 )
				return nil
			end
		else
			exports.dx:new( thePlayer, "You must specify a player to ban", 255, 0, 0 )
			return nil
		end
	end
	
	local targetPlayer = exports.misc:getPlayerFromPartialName( target )
	if ( targetPlayer ) then
		local banner = getPlayerName( thePlayer )
		local banned = getPlayerName( targetPlayer )
		local bannedPlayerAccount = getPlayerAccount( targetPlayer )

		local serialBan = addBan( nil, nil, getPlayerSerial( targetPlayer ), thePlayer, tostring( banReason ), length )
		local accountBan = setAccountData( bannedPlayerAccount, "banned", true )
		if serialBan or accountBan then
			outputChatBox( banned.." has been banned by "..banner.." ("..banReason..")", root, 255, 255, 0 )
		else
			return false
		end		
	else
		exports.dx:new( thePlayer, "There is no player called "..target.." currently online.", 255, 0, 0 )
		return false
	end
	
end
addCommandHandler( "ban", _banPlayer, true )]]


function unbanAccount( accountName )
	local accountName = tostring( accountName )
	local account = getAccount( accountName )
	
	if not accountName then
		outputDebugString( "Invalid argument passed: accountName" )
		return nil
	end
	
	if account ~= false then
		outputDebugString( "Found account "..accountName )
		local accountBan = getAccountData( account, "isAccountBanned" )
		if ( accountBan ~= false ) then
			setAccountData( account, "isAccountBanned", false )
			setAccountData( account, "isAccountBannedReason", "" )
			setAccountData( account, "isAccountBannedLength", "" )
		else
			outputDebugString( "Account "..accountName.." is not banned" )
			return false
		end
	else
		outputDebugString( "Could not find account "..accountName )
		return false
	end
	outputServerLog( "Successfully unbanned account "..accountName )
	return true
end

function banAccount( accountName, reason, length )
	local accountName = tostring( accountName )
	local banReason = table.concat( { reason }, " " )
	
	if not accountName and not banReason and not length then
		outputDebugString( "Invalid argument passed: all" )
		return nil
	else
		if accountName then
			if banReason then
				if length then
					if ( tonumber( length ) == nil ) then
						outputDebugString( "A valid ban time was not entered" )
						return false
					end
				else
					outputDebugString( "Invalid argument passed: length" )
					return nil
				end
			else
				outputDebugString( "Invalid argument passed: banReason" )
				return nil
			end
		else
			outputDebugString( "Invalid argument passed: accountName" )
			return nil
		end
	end
	
	local account = getAccount( accountName )
	if account ~= false then
	
		outputDebugString( "Found account "..accountName )
		local accountBan = setAccountData( account, "isAccountBanned", true )
		local accountBanReason = setAccountData( account, "isAccountBannedReason", tostring( banReason ) )
		local accountBanLength = setAccountData( account, "isAccountBannedLength", tostring( length ) )
		local accountPlayer = getAccountPlayer( account )
		local accountPlayerName = getPlayerName( accountPlayer )
		local accountPlayerKick = kickPlayer( accountPlayer, "accounts", "Your account has been banned" )
		
		if ( accountBan ) then
			if ( accountPlayer ) then
				if ( accountPlayerKick ) then
					outputDebugString( "Successfully banned account: '"..accountName.."' and kicked account owner "..accountPlayerName )
				else
					outputDebugString( "Successfully banned account: '"..accountName.."' but failed to kicked account owner "..accountPlayerName )
				end
			else
				outputDebugString( "Successfully banned account: '"..accountName"'" )
			end
		else
			outputDebugString( "Failed to initiate ban on account: "..accountName )
			return false
		end
	else
		outputDebugString( "Failed to find account "..accountName )
		return false
	end
	outputServerLog( "Banned account '"..accountName.."'. Reason: '"..banReason.."' Length: "..length )
	return true
end


--[[function _banSerial( serial, reason, length )
	--local serial = tostring( serial )
	local banReason = table.concat( { reason }, " " )
	
	if not serial and not banReason and not length then
		outputDebugString( "Invalid argument passed: all" )
		return nil
	else
		if serial then
			if banReason then
				if length then
					if ( tonumber( length ) == nil ) then
						outputDebugString( "A valid ban time was not entered" )
						return false
					end
				else
					outputDebugString( "Invalid argument passed: length" )
					return nil
				end
			else
				outputDebugString( "Invalid argument passed: banReason" )
				return nil
			end
		else
			outputDebugString( "Invalid argument passed: serial" )
			return nil
		end
	end
	
	local serialLength = string.len( serial )
	if ( serialLength ~= 32 ) then
		outputDebugString( "Invalid serial passed. Not 32 chars." )
		return false
	else
		for k, v in pairs( getBans() ) do
			local checkSerialBan = getBanSerial( v )
			if ( checkSerialBan == serial ) then
				outputDebugString( "Serial is already banned!" )
				return false
			else
				outputDebugString( "Banned serial" )
			end
		end
	end
end
addCommandHandler( "banserial", _banSerial )
]]--


