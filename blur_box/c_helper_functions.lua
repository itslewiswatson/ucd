---------------------------------------------------------------------------------------------------
-- Version check
---------------------------------------------------------------------------------------------------
function isMTAUpToDate()
	local mtaVer = getVersion().sortable
	if getVersion ().sortable < "1.3.4-9.05899" then
		return false
	else
		return true
	end
end


---------------------------------------------------------------------------------------------------
-- output table
---------------------------------------------------------------------------------------------------
function sortedBoxOutput(inTable,isSo,distFade,maxCoronas)
	local boxTempTable = {}
	for index,thisBox in ipairs(inTable) do
		local w = #boxTempTable + 1
		if not boxTempTable[w] then 
			boxTempTable[w] = {} 
		end
		boxTempTable[w].enabled = thisBox.enabled
		boxTempTable[w].size =  thisBox.size
		boxTempTable[w].pos = thisBox.pos
		boxTempTable[w].color = thisBox.color	
	end
	return boxTempTable
end
	
function removeEmptyEntry(inTable)
	local outTable = {}
	for index,value in ipairs(inTable) do
		if inTable[index].enabled then
		local w = #outTable + 1
			outTable[w] = value
		end
	end
	return outTable
end
