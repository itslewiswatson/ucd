function add(plr, key, text, red, green, blue, ind)
	return triggerLatentClientEvent(plr, "UCDdx.bar:add", plr, key, text, red, green, blue, ind)
end

function del(plr, key)
	return triggerLatentClientEvent(plr, "UCDdx.bar:del", plr, key)
end
