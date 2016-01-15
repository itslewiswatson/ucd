LV = createColRectangle(901.67871, 601.66272, 2050, 2400)

function isElementInLV(ele)
	if (not ele or not isElement(ele)) then return nil end
	if (isElementWithinColShape(ele, LV)) then
		return true
	end
	return false
end
