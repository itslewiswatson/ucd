function applyMods()	
	--local skin = engineLoadTXD( "gold.txd", true )
	--engineImportTXD(skin, 519)

	local staff = engineLoadTXD( "staff.txd", true )
	engineImportTXD(staff, 217)
	local staff = engineLoadDFF( "staff.dff", 217 )
	engineReplaceModel(staff, 217)
	
	engineImportTXD(engineLoadTXD("infernus.txd", true), 411)
	engineReplaceModel(engineLoadDFF("infernus.dff", 411), 411)
	
	engineReplaceModel(engineLoadDFF("hydra.dff", 520), 520)
	engineReplaceModel(engineLoadDFF("shamal.dff", 519), 519)
	engineReplaceModel(engineLoadDFF("seaspar.dff", 447), 447)
	
end
addEventHandler( "onClientResourceStart", resourceRoot, applyMods )