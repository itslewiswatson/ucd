addCommandHandler("tog",
	function ()
		outputDebugString(tostring(not isControlEnabled("fire")))
		toggleControl("fire", not isControlEnabled("fire")) 
	end
)
