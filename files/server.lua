--[[
	--// Project: United Social Gamers
	--// Date: 27.07.2015
	--// Author: Lewis Watson (Noki)
	--// Purpose: File system module operator for USG.
	
	-------------------------------------------------------------------------------------------------------
	-------------------------------------------------------------------------------------------------------
	-------------------------------------------------------------------------------------------------------
	DISCLAIMER: THIS RESOURCE IS VERY DANGEROUS IF YOU MESS AROUND WITH IT. DO NOT, I REPEAT, DO NOT TOUCH THIS UNLESS YOU KNOW WHAT YOU ARE DOING. MESSING WITH THIS CAN CAUSE YOUR SYSTEM TO BECOME NON-FUNCTIONAL
	-------------------------------------------------------------------------------------------------------
	-------------------------------------------------------------------------------------------------------
	-------------------------------------------------------------------------------------------------------
--]]

-- Windows = "C:/"; Linux = "//"
local FILE_SYSTEM = createFilesystemInterface()
local rootDir = FILE_SYSTEM.createTranslator("C:/")
 
-- Function that returns whether the given path is a directory path.
function isPathDirectory(path)
   local firstChar = string.sub(path, 1, 1)
   local lastChar = string.sub(path, #path, #path)
	if ((firstChar == "/") or (firstChar == "\\")) and (lastChar == "/") then
		return true
	else
		return false
	end
end

-- This is absolute from the root directory [NOT RELATIVE]
function mkdir(path)
	if (isPathDirectory(path)) then
		local createdDirectory = rootDir.createDir(path)
		if (not createdDirectory) then
			return false
		end
	else
		return false
	end
	return true
end
--mkdir("/MTA/test/noki/")

----------------------------------------------------------------

url = "http://puu.sh/jd7mJ/33092ae3a6.png http://puu.sh/jaUDF/1754cad5f6.png http://puu.sh/jbK1M/714bae6e4c.png"
url = string.gsub(url, "%s", " ") -- Don't remove it, or whitespace will not be detected correctly

function fetchImage()
	links = {}

	if (url:find(" ")) then
		whiteSpace = 0
		
		for i = 1, #url do
			if (string.sub(url, i, i) == " ") then
				whiteSpace = whiteSpace + 1
			end
		end
		
		-- If this were Python....
		for x=1, (whiteSpace + 1) do
			links[x] = gettok(url, x, string.byte(" "))
		end
	else
		-- Whitespace not found
		links[1] = url
	end
	
	for _, link in pairs(links) do
		fetchRemote(link, callback_fetchImage)
		outputDebugString(link)
	end
end

function callback_fetchImage(responseData, errorCode)
	if (errorCode == 0) then
		
		-- Add timestamp, account name etc to the file name
		-- Each acc name (the one who reported) will have a folder in the web server (usgmta.co/noki for example)
		-- In there we will have reports for each day
		-- Save any pictures and a text file
		
		--[[
		f = fileCreate("oko.jpg")
		fileWrite(f, responseData)
		fileClose(f)
		--]]
	else
		outputDebugString("Failed to retrieve /report image with ERROR ["..errorCode.."]")
	end
end

addCommandHandler("lala", fetchImage)