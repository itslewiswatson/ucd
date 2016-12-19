function new(p, text, r, g, b)
	local e = false
	if (p) and (text) then if isElement(text) then e = text else e=p end end
	if (not isElement(e)) then return end
	if e == text then
		triggerClientEvent(e, "UCDdx.createNewDxMessage", e, p, r, g, b)
	else
		triggerClientEvent(e, "UCDdx.createNewDxMessage", e, text, r, g, b)
	end
end

function shout(p, text)
	if (not text or not tostring(text) or not p or not isElement(p) or (p.type ~= "player" and p ~= root)) then return end
	triggerClientEvent(p, "UCDdx.shout", resourceRoot, text)
end