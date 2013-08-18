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

-- parses the raw data and 
function prepareRawData()
	print("Prepare the raw Data.")
	
	if not isTable (T_CAL_RAWFORMAT) then
		print("T_CAL_RAWFORMAT is not a table.")
		return
	end

	-- build entry table
	-- * title
	-- * date
	-- * time
	-- * date in string
	-- * color of the bar
	local tEntries = {}
	for i, rawCals in pairs(T_CAL_RAWFORMAT) do

		for entry in string.gmatch(rawCals, PAT_ENTRY) do
			
			local entryAArray = {}
			local date = string.match(entry, PAT_DATE)
			date = string.gsub(date, "&amp;", "&") -- remove &
			date = string.gsub(date, "&auml;", "a") -- remove ä

			-- fetch title, overwrite &amp twice cause Gcal saves & this way
			entryAArray['title'] = string.match(entry, PAT_TITLE) or ""
			entryAArray['title'] = string.gsub(entryAArray['title'], "&amp;", "&")
			entryAArray['title'] = string.gsub(entryAArray['title'], "&amp;", "&")

			-- integer date
			entryAArray['pubDate'] = PubDate(date)

			-- integer time
			entryAArray['pubTime'] = PubTime(date)

			-- fetch date in string format
			entryAArray['date'] = os.date("%A, %d. %b", entryAArray['pubDate'])

			-- string color
			entryAArray['color'] = SKIN:GetVariable('BarColor' .. i)

			-- if both datetimes are different a time is present to be displayed in the title
			if entryAArray['pubDate'] ~= entryAArray['pubTime'] then
				local sTime = os.date("%H:%M: ", entryAArray['pubTime'])
				entryAArray['title'] = sTime .. entryAArray['title']
			end

			table.insert(tEntries, entryAArray)
		end
	end

	-- sort table
	table.sort(tEntries, function(curr,next) return curr.pubTime < next.pubTime end)

	displayEntries(tEntries)
end

function displayEntries(tEntries)
	local dayIterator = 1
	local elemIterator = 1
	local sMeterDate = ""
	local sMeterBar = ""
	local sMeterInfo = ""

	for id, entry in pairs(tEntries) do

		sMeterDate = 'mD' .. dayIterator .. 'Date'
		sMeterBar = 'mD'.. dayIterator ..'E' .. elemIterator .. 'Bar'
		sMeterInfo = 'mD'.. dayIterator ..'E' .. elemIterator .. 'Info'

		if isMeterExisting(sMeterInfo) then

			setMeterText(sMeterInfo, entry.title)
			setMeter

			elemIterator = elemIterator + 1
		end
	end

	SKIN:Bang('!Redraw', SKIN:GetVariable('CURRENTCONFIG'))
end


-- WRAPPER: sets the text option of a string meter
function setMeterText(meter, text)
	SKIN:Bang('!SetOption', meter, 'Text', text)
end

function setMeterBar(meter, color)
	SKIN:Bang('!SetOption', meter, 'SolidColor', color)
end



function isMeterExisting(meter)
	if SKIN:GetMeter(meter) then
		return true
	else
		return false
	end
end

-- Zeit konvertieren in absolute Zahl um sortieren zu können
-- Wann: Mi 25. Jul. 2012 10:15 bis 11:45
function PubTime(itemDate)
	local weekday, day, monthText, year = string.match(itemDate, PAT_DATE_TIME)
	local hour, min = string.match(itemDate, PAT_TIME) or 0
	
	local PubTime = os.time({year=year, month=T_MONTH_NUM[monthText], day=day, hour=hour, min=min})

	return PubTime
end 

function PubDate(itemDate)
	local weekday, day, monthText, year = string.match(itemDate, PAT_DATE_TIME)

	local PubDate = os.time(
		{
			year = year, 
			month = T_MONTH_NUM[monthText], 
			day = day, 
			hour = 0, 
			min = 0
		}
	)

	return PubDate
end 

function isTable(obj)
	return (type(obj) == "table")
end

function printTable(table)

	for k,v in pairs(table) do
		print(k .. ": " .. v)
	end
end