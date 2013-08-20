local FileReader do
	-- @param fileName string
	-- @return content string
	function FileReader(fileName)
		if not fileName then return end

		local handle = io.open(fileName)
		local content = handle:read('*all')
		io.close(handle)

		return content
	end
end

return FileReader