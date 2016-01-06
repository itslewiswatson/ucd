function applyMods()	
	engineImportTXD(engineLoadTXD("staff.txd", true), 217)
	engineReplaceModel(engineLoadDFF("staff.dff", 217), 217)
	
	engineImportTXD(engineLoadTXD("66.txd", true), 66)
	engineReplaceModel(engineLoadDFF("66.dff", 66), 66)
	
	engineImportTXD(engineLoadTXD("275.txd", true), 275)
	engineReplaceModel(engineLoadDFF("275.dff", 275), 275)
	
	engineImportTXD(engineLoadTXD("infernus.txd", true), 411)
	engineReplaceModel(engineLoadDFF("infernus.dff", 411), 411)
	
	engineReplaceModel(engineLoadDFF("hydra.dff", 520), 520)
	engineReplaceModel(engineLoadDFF("shamal.dff", 519), 519)
	engineReplaceModel(engineLoadDFF("seaspar.dff", 447), 447)
	
end
addEventHandler( "onClientResourceStart", resourceRoot, applyMods )