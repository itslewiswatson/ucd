addEventHandler("onResourceStop", resourceRoot,
	function ()
		Resource.getFromName("blur_box"):restart()
	end
)