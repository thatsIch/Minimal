-- can I dispose variables?

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
	PAT_TIME = '.-(%d%d):(.-).bis'
	PAT_TO_DATE = '.-bis (%a%a %d%d%. %a%a%a%. %d%d%d%d)'
	PAT_LINK = '.-<link.-href=.(.-). title.-%/>'
	PAT_DESCRIPTION = '.-<content.->.-Terminbeschreibung: (.-)</content>'

	-- variables
	I_TOTAL_COUNT = totalCount()
	I_CURR_COUNT = 0

	-- initialize mDownloadProgress
	SKIN:Bang('!SetOption', 'mDownloadProgress', 'MaxValue', I_TOTAL_COUNT, SKIN:GetVariable('CURRENTCONFIG'))
	SKIN:Bang('!SetOption', 'mDownloadProgress', 'Formula', I_TOTAL_COUNT, SKIN:GetVariable('CURRENTCONFIG'))
end

function totalCount() 
	local count = 0
	local elem = ""

	repeat
		count = count + 1
		elem = getVar('Cal' .. count)
	until not elem

	return count - 1
end

-- TODO set special updaterate Math.min(1h, next appointment + 15m)
function Update()
	-- Reset Table
	T_CAL_RAWFORMAT = {}
	
	-- Reset LoadBar
	displayLoadProgression = function() end

	-- Reset WebParser
	local fetchedUrl = getVar("Cal1")
	SKIN:Bang('!SetOption', 'mWebParser', 'Url', fetchedUrl, SKIN:GetVariable('CURRENTCONFIG'))
	setMeterOption('mWebParser', 'Url', fetchedUrl)
	updateMeasure('mWebParser')
end

function parseNextCalendar()
	local webParser = getMeasure('mWebParser') 
	local currUrl = webParser:GetOption('Url')
	local filePath = webParser:GetStringValue()

	-- open files and fetch data directly since temp files dont survive next cycle
	local fileContent = fetchContent(filePath)

	table.insert(T_CAL_RAWFORMAT, fileContent)
	
	-- get next Cal
	local fetchedUrl = fetchNextCalUrl(currUrl)

	-- display progression
	displayLoadProgression()

	-- check for validity
	if not fetchedUrl then
		prepareRawData()
		return
	end

	-- pass new url and update
	setMeterOption('mWebParser', 'Url', fetchedUrl)
	updateMeasure('mWebParser')
end

-- displays the percentage progression of the loading process
function displayLoadProgression()
	SKIN:Bang('!UpdateMeasure', 'mDownloadProgress', SKIN:GetVariable('CURRENTCONFIG'))
end

-- needs the current url and fetches the next url in line sorted by Variable ID
function fetchNextCalUrl(currUrl)
	local i = 1
	local url = getVar("Cal" .. i)

	-- find current iterator
	while (currUrl ~= url) do
		i = i + 1
		url = getVar("Cal" .. i)
	end

	-- fetch next variable
	return getVar("Cal" .. (i + 1))
end

-- opens a specified file path
function fetchContent(filePath)
	local fileHandle = io.open(filePath)
	local content = ""

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

-- parses the raw data and 
function prepareRawData()

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
			date = string.gsub(date, "&nbsp;", " ") -- remove space

			local toDate = string.match(date, PAT_TO_DATE)

			local title = string.match(entry, PAT_TITLE) or ""
			title = string.gsub(title, "&amp;", "&")
			title = string.gsub(title, "&amp;", "&")

			-- fetch title, overwrite &amp twice cause Gcal saves & this way
			entryAArray['title'] = title

			-- integer date
			entryAArray['pubDate'] = PubDate(date)

			-- integer time
			entryAArray['pubTime'] = PubTime(date)

			-- fetch date in string format
			entryAArray['date'] = os.date("%A, %d. %b", entryAArray['pubDate'])

			-- fetch link of feed
			entryAArray['link'] = string.match(entry, PAT_LINK)

			-- fetch info
			entryAArray['info'] = string.match(entry, PAT_DESCRIPTION)

			-- string color
			entryAArray['color'] = getVar('BarColor' .. i) or getVar('DefaultBarColor')

			-- if both datetimes are different a time is present to be displayed in the title
			if entryAArray['pubDate'] ~= entryAArray['pubTime'] then
				entryAArray['title'] = os.date("%H:%M: ", entryAArray['pubTime']) .. entryAArray['title']
			end

			-- if a second date was found, concatenate it to date
			if toDate then
				entryAArray['date'] = entryAArray['date'] .. ' - ' .. os.date("%A, %d. %b", PubDate(toDate))
			end

			table.insert(tEntries, entryAArray)
		end
	end

	-- sort table
	table.sort(tEntries, function(curr, next) return curr.pubTime < next.pubTime end)

	displayEntries(tEntries)
end

function displayEntries(tEntries)
	local dayIterator = 0
	local elemIterator = 1
	local sMeterDate = ""
	local sMeterBar = ""
	local sMeterInfo = ""

	local lastDate = 0
	local now = os.time()
	local nowTable = os.date("*t", now)
	local today = os.time{
		year = nowTable.year,
		month = nowTable.month,
		day = nowTable.day,
		hour = 0,
		min = 0,
		sec = 0
	}
	local tomorrow = os.time{
		year = nowTable.year,
		month = nowTable.month,
		day = nowTable.day + 1,
		hour = 0,
		min = 0,
		sec = 0
	}

	for id, entry in pairs(tEntries) do
		
		if lastDate ~= entry.pubDate then
			-- clear all MeterBar and MeterInfo after this one
			while isMeter('mD'.. dayIterator ..'E' .. elemIterator .. 'Bar') do
				sMeterBar = 'mD'.. dayIterator ..'E' .. elemIterator .. 'Bar'
				sMeterInfo = 'mD'.. dayIterator ..'E' .. elemIterator .. 'Info'

				setMeterText(sMeterInfo, '')
				setMeterLink(sMeterInfo, '')
				setMeterInfo(sMeterInfo, '')
				updateMeter(sMeterInfo)
				
				setMeterBar(sMeterBar, '00000000')
				updateMeter(sMeterBar)

				elemIterator = elemIterator + 1
			end

			lastDate = entry.pubDate
			dayIterator = dayIterator + 1
			elemIterator = 1

			sMeterDate = 'mD' .. dayIterator .. 'Date'

			if isMeter(sMeterDate) then
				-- check for today and tomorrow display
				if entry.pubDate == today then
					setMeterOption(sMeterDate, 'MeterStyle', 'sDateToday')
				elseif entry.pubDate == tomorrow then 
					setMeterOption(sMeterDate, 'MeterStyle', 'sDateTomorrow')
				else
					setMeterOption(sMeterDate, 'MeterStyle', 'sDate')
				end

				setMeterText(sMeterDate, entry.date)
				updateMeter(sMeterDate)
			else
				break
			end
		end

		sMeterBar = 'mD'.. dayIterator ..'E' .. elemIterator .. 'Bar'
		sMeterInfo = 'mD'.. dayIterator ..'E' .. elemIterator .. 'Info'

		if isMeter(sMeterInfo) and isMeter(sMeterBar) then

			setMeterText(sMeterInfo, entry.title)
			setMeterLink(sMeterInfo, entry.link)
			if entry.info then
				setMeterInfo(sMeterInfo, entry.info)
			end
			updateMeter(sMeterInfo)

			setMeterBar(sMeterBar, entry.color)
			updateMeter(sMeterBar)

			elemIterator = elemIterator + 1
		end
	end

	redraw()
end

	-- WRAPPER
-- ==================================================
function getVar(var)
	return SKIN:GetVariable(var)
end

function getMeasure(measure)
	return SKIN:GetMeasure(measure)
end

function updateMeter(meter)
	SKIN:Bang('!UpdateMeter', meter, SKIN:GetVariable('CURRENTCONFIG'))
end

function updateMeasure(measure)
	SKIN:Bang('!CommandMeasure', measure, 'Update', SKIN:GetVariable('CURRENTCONFIG'))
end

function getMeter(meter)
	return SKIN:GetMeter(meter)
end

function setMeterOption(meter, option, value)
	SKIN:Bang('!SetOption', meter, option, value, SKIN:GetVariable('CURRENTCONFIG'))
end

function setMeterText(meter, text)
	SKIN:Bang('!SetOption', meter, 'Text', text, SKIN:GetVariable('CURRENTCONFIG'))
end

function redraw()
	SKIN:Bang('!Redraw', SKIN:GetVariable('CURRENTCONFIG'))
end

function setMeterBar(meter, color)
	SKIN:Bang('!SetOption', meter, 'SolidColor', color, SKIN:GetVariable('CURRENTCONFIG'))
end

function setMeterLink(meter, link)
	SKIN:Bang('!SetOption', meter, 'LeftMouseUpAction', link, SKIN:GetVariable('CURRENTCONFIG'))
end

function setMeterInfo(meter, info)
	SKIN:Bang('!SetOption', meter, 'ToolTipText', info, SKIN:GetVariable('CURRENTCONFIG'))
end

function setMeterWidth(meter, width)
	SKIN:Bang('!SetOption', meter, 'W', width, SKIN:GetVariable('CURRENTCONFIG'))
end

function setMeterHidden(meter)
	SKIN:Bang('!HideMeter', meter, SKIN:GetVariable('CURRENTCONFIG'))
end

function isMeter(meter)
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
	local hour = string.match(itemDate, PAT_TIME) or 0
	local min = string.match(itemDate, '%:(%d%d)')
	
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
