--
function Initialize()

	-- fetch all Calendars
	local cals = {}
	local iterator = 1
	local cal = SKIN:GetVariable("Cal" .. iterator)
	local mWebParser = SKIN:GetMeasure("mWebParser")

	repeat
		-- SKIN:Bang('!SetOption', 'mWebParser', 'Url', cal)
		-- SKIN:Bang('!CommandMeasure', 'mWebParser', 'Update')
		-- print(mWebParser:GetOption('Url'))		
		-- print(mWebParser:GetValue())
		iterator = iterator + 1
		cal = SKIN:GetVariable("Cal" .. iterator)
	until not cal

	-- print(mWebParser:GetValue())

	print("parser funzt")
	-- printTable(cals)
end

function Update()

end

function parseNextCalendar()
	local webParser = SKIN:GetMeasure('mWebParser')
	local currUrl = webParser:GetOption('Url')

	-- iterate through cal list to determine which ID currently is
	local iterator = 1
	local url = SKIN:GetVariable("Cal" .. iterator)

	-- find current iterator
	while (currUrl ~= url) do
		iterator = iterator + 1
		url = SKIN:GetVariable("Cal" .. iterator)
	end

	
end

function printTable(table)

	for k,v in pairs(table) do
		print(k .. ": " .. v)
	end
end