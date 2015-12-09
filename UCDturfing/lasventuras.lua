lv_main = createColRectangle(875.2869, 620.903, 2300, 2400)
createRadarArea(875.2869, 620.903, 2300, 2400, 255, 255, 255, 100)

lv_bottom = createColRectangle(1334.7622, 545.7134, 1834.5247, 90)
createRadarArea(1334.7622, 545.7134, 1834.5247, 90, 127, 127, 127, 100)

lv_south_pier = createColRectangle(2218.9824, 487.9441, 230, 100)
createRadarArea(2218.9824, 487.9441, 230, 100, 127, 127, 127, 100)

lv = {lv_main, lv_bottom, lv_south_pier}

function isElementInLV(ele)
	if (not ele or not isElement(ele)) then return nil end
	for _, shape in pairs(lv) do
		if (isElementWithinColShape(ele, shape)) then
			return true
		end
	end
	return "nyes"
end
