allapps = 
{
	[1] = IM,
	[3] = "exports.UCDwebBrowser:toggleBrowser() togglePhone()",
	[9] = Money,
}

function toggleApp(i)
	if (allapps[i]) then
		if (type(allapps[i]) == "string") then
			loadstring(allapps[i])()
			return
		end
		allapps[i].toggle()
		t(not allapps[i].all[1].visible)
	end
end

function t(state)
	for x, y in pairs({phone.home.image, phone.home.label}) do
		for i, ele in pairs(y) do
			ele.visible = state
		end
	end
end
