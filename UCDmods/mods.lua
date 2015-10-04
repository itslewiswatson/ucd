function applyMods()	
	local skin = engineLoadTXD( "gold.txd", true )
	engineImportTXD(skin, 519)

	local staff = engineLoadTXD( "staff.txd", true )
	engineImportTXD(staff, 217)
	local staff = engineLoadDFF( "staff.dff", 217 )
	engineReplaceModel( staff, 217 )
end
addEventHandler( "onClientResourceStart", resourceRoot, applyMods )