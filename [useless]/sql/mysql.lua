local sql = exports.sqlite:getConnection()

function getConnection()
	return sql
end

function query(...)
    if isElement(sql) then
        local qh = dbQuery(sql,...)
        return dbPoll(qh,-1)
    end
	return false
end

function querySingle(str,...)
	if not str:find("LIMIT 1") then
		str = str.." LIMIT 1"
	end
	local result = query(str,...)
	if result then
		return result[1]
	end
	return false
end

function exec(str,...)
	if isElement(sql) then
		return dbExec(sql,str,...)
	end
	return false
end

function doesColumnExist(aTable,column)
	local theTable = query("DESCRIBE `??`",aTable)
	if theTable then
		for k, v in ipairs(theTable) do
			if v.Field == column then
				return true
			end
		end
	end
	return false
end

function creatColumn(aTable,aColumn,aType)
	if aTable and column and aType then
		return exec("ALTER TABLE `??` ADD `??` ??",aTable,aColumn,aType)
	end
end