Browser = {}
Browser.open = false

function Browser.toggle()
	-- Add check because of old operating systems
	local browser = exports.UCDbrowser:toggleBrowser()
	if (browser) then
		togglePhone()
	end
end
