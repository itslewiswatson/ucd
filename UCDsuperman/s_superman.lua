local Superman = {}

-- Static global values
local rootElement = getRootElement()
local thisResource = getThisResource()

-- Resource events
addEvent("superman:start", true)
addEvent("superman:stop", true)

--
-- Start/stop functions
--
function Superman.Start()
  local self = Superman

  addEventHandler("superman:start", rootElement, self.clientStart)
  addEventHandler("superman:stop", rootElement, self.clientStop)
end
addEventHandler("onResourceStart", getResourceRootElement(thisResource), Superman.Start, false)

function Superman.clientStart()
  setElementData(client, "superman:flying", true)
end

function Superman.clientStop()
  setElementData(client, "superman:flying", false)
end
