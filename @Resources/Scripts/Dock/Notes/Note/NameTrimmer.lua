-- upon build
function Initialize()
	-- extract note iteration
	local configname = SKIN:GetVariable("CURRENTCONFIG")
	configname = string.match(configname, "(%d+)")

	-- write value to meter
	SKIN:Bang('!SetOption', 'sHeader', 'Text', '- ' .. configname .. ' -')
end