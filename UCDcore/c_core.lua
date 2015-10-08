-------------------------------------------------------------------
--// PROJECT: Project Downtown
--// RESOURCE: core
--// DEVELOPER(S): Lewis Watson (Noki)
--// DATE: 13.12.2014
--// PURPOSE: A client side core resource. 
--// FILE: core\c_core.lua [client]
-------------------------------------------------------------------

local ver = "Alpha"
function getGameVersion()
	return ver
end

setBirdsEnabled(false)
setCloudsEnabled(false)
setAmbientSoundEnabled("gunfire", false)
setOcclusionsEnabled(false)
setBlurLevel(0)