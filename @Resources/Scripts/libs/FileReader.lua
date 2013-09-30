local FileReader do
	-- @param fileName string
	-- @return content string
	function FileReader(fileName)
		if not fileName then 
			print("IllegalArgumentEXception: " .. fileName .. " not a valid name.")
			return "" 
		end

		local fileHandle = io.open(fileName)
		if fileHandle == nil then
			io.close(fileHandle)
			print("IOEXception: " .. filePath .. " not found.")
			return ""
		else 
			local content = fileHandle:read('*all')
			io.close(fileHandle)

			return content
		end
	end
end

return FileReader