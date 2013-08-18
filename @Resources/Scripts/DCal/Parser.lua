-- upon webparser creation
function Initialize()
	-- tables
	T_CAL_RAWFORMAT = {}
	T_MONTH_NUM = {Jan=1;Feb=2;Mar=3;Apr=4;Mai=5;Jun=6;Jul=7;Aug=8;Sep=9;Okt=10;Nov=11;Dez=12;}

	-- pattern
	PAT_ENTRY = '<entry.-</entry>'
	PAT_TITLE = '.-<title.->(.-)</title>.-'
	PAT_DATE = '.-Wann: (.-)&lt'
	PAT_DATE_TIME = '(%a%a) (%d+)%. (.-)%.? (%d%d%d%d)'
	PAT_TIME = '(%d%d)%:(%d%d)'
	
	
end

function parseNextCalendar()
	print("called parseNextCalendar")

	local webParser = SKIN:GetMeasure('mWebParser')
	local currUrl = webParser:GetOption('Url')

	-- store fetched file path
	local filePath = webParser:GetStringValue()

	-- check if file exists
	if not filePath then
		print("filePath not valid: " .. filePath)
		return
	end

	-- open files and fetch data directly since temp files dont survive next cycle
	table.insert(T_CAL_RAWFORMAT, fetchContent(filePath))
	

	-- get next Cal
	local fetchedUrl = fetchNextCalUrl(currUrl)

	-- check for validity
	if not fetchedUrl then
		prepareRawData()
		return
	end

	-- pass new url and update
	SKIN:Bang('!SetOption', 'mWebParser', 'Url', fetchedUrl)
	SKIN:Bang('!CommandMeasure', 'mWebParser', 'Update')
end

-- needs the current url and fetches the next url in line sorted by Variable ID
function fetchNextCalUrl(currUrl)
	local iterator = 1
	local url = SKIN:GetVariable("Cal" .. iterator)

	-- find current iterator
	while (currUrl ~= url) do
		iterator = iterator + 1
		url = SKIN:GetVariable("Cal" .. iterator)
	end

	-- fetch next variable
	iterator = iterator + 1
	url = SKIN:GetVariable("Cal" .. iterator)

	return url
end

-- opens a specified file path
function fetchContent(filePath)
	local fileHandle = io.open(filePath)
	local content = fileHandle:read('*all')
	io.close(fileHandle)

	return content
end

function prepareRawData()
	print("Prepare the raw Data.")
	
	if not isTable (T_CAL_RAWFORMAT) then
		print("T_CAL_RAWFORMAT is not a table.")
		return
	end

	for _, rawCals in pairs(T_CAL_RAWFORMAT) do
		print("RAW CAL")
		for entry in string.gmatch(rawCals, PAT_ENTRY) do

		end
	end
end

function isTable(obj)
	return (type(obj) == "table")
end

function printTable(table)

	for k,v in pairs(table) do
		print(k .. ": " .. v)
	end
end