local spam = {}

function antiSpam()
	if (spam[source]) then
		spam[source] = 1
	elseif (spam[source] >= 5) then
		cancelEvent()
		exports.UDCdx:new(source, "Refrain from command spamming, please")
	else
		spam[source] = spam[source] + 1
	end
end
addEventHandler("onPlayerCommand", root, antiSpam)


function clearAntiSpam()
	spam = {}
end
setTimer(clearAntiSpam, 1000, 0)
