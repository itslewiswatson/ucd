function doAnim(block, anim)
	if (not exports.UCDchecking:canPlayerDoAction(client, "DoAnim")) then
		return false
	end
	client:setAnimation(block, anim)
end
addEvent("onPlayerPerformAnimation", true)
addEventHandler("onPlayerPerformAnimation", resourceRoot, doAnim)