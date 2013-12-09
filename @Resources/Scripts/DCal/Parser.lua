-- upon webparser creation
function Initialize()

	-- Libs
	Meters, Measures, Variables = dofile(SKIN:GetVariable('@').."Scripts\\libs\\InterfaceOOPAccess.lua")(SKIN)
	FileReader = dofile(Variables['@'].."Scripts\\Libs\\FileReader.lua")
	PrettyPrint = dofile(Variables['@'].."Scripts\\Libs\\PrettyPrint.lua")

	-- tables
	T_CAL_RAWFORMAT = {}
	T_MONTH_NUM = {Jan=1;Feb=2;Mar=3;Apr=4;Mai=5;Jun=6;Jul=7;Aug=8;Sep=9;Okt=10;Nov=11;Dez=12;}

	-- pattern
	PAT_ENTRY = '<entry.-</entry>'
	PAT_TITLE = '.-<title.->(.-)</title>.-'
	PAT_PLACE = '.-Wo: (.-)&lt'	
	PAT_DATE = '.-Wann: (.-)&lt'
	PAT_DATE_TIME = '(%a%a) (%d+)%. (.-)%.? (%d%d%d%d)'
	PAT_TIME = '.-(%d%d):(.-).bis'
	PAT_TO_DATE = '.-bis (%a%a %d%d%. %a%a%a%. %d%d%d%d)'
	PAT_LINK = '.-<link.-href=.(.-). title.-%/>'
	PAT_DESCRIPTION = '.-<content.->.-Terminbeschreibung: (.-)</content>'

	-- variables
	I_TOTAL_COUNT = getCalendarCount()
	I_CURR_URL_COUNT = 1
end

function getCalendarCount() 
	local count = 0
	local elem = ""

	repeat
		count = count + 1
		elem = Variables['Cal' .. count]
	until not elem

	return count - 1
end

function checkOnline()
	local filePath = Measures.mWebParser:GetStringValue()
	if filePath == "" then
		print("offline mode")
	end
end

function parseNextCalendar()
	local webParser = Measures.mWebParser
	local filePath = webParser:GetStringValue()

	-- open files and fetch data directly since temp files dont survive next cycle
	local fileContent = FileReader(filePath)

	table.insert(T_CAL_RAWFORMAT, fileContent)
	
	-- get next Cal
	local fetchedUrl = fetchNextCalUrl()

	-- display progression
	displayLoadProgression()

	-- check for validity
	if not fetchedUrl then
		prepareRawData()

		-- Reset Table
		T_CAL_RAWFORMAT = {}

		-- Reset Url Counter
		I_CURR_URL_COUNT = 1

		-- Reset LoadBar
		displayLoadProgression = function() return nil end

		-- Reset WebParser to first Calendar
		Measures.mWebParser.Url = Variables.Cal1
		return
	end

	-- pass new url and update
	Measures.mWebParser.Url = fetchedUrl
	Measures.mWebParser.forceUpdate()
end

-- displays the percentage progression of the loading process
function displayLoadProgression()
	-- Measures.mDownloadProgress.update()
	Meters.mD1Date.Text = Meters.mD1Date.Text .. "."
	Meters.mD1Date.update()
end

-- needs the current url and fetches the next url in line sorted by Variable ID
function fetchNextCalUrl()
	if I_CURR_URL_COUNT < I_TOTAL_COUNT then
		I_CURR_URL_COUNT = I_CURR_URL_COUNT + 1
		return Variables["Cal" .. I_CURR_URL_COUNT]
	else
		return nil
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

			local place = string.match(entry, PAT_PLACE) or ""
			place = string.gsub(place, "&amp;", "&") -- remove &
			place = string.gsub(place, "&auml;", "ä") -- remove ä
			place = string.gsub(place, "&ouml;", "ö") -- remove ä
			place = string.gsub(place, "&uuml;", "ü") -- remove ä

			local toDate = string.match(date, PAT_TO_DATE)

			local title = string.match(entry, PAT_TITLE) or ""
			title = string.gsub(title, "&amp;", "&")
			title = string.gsub(title, "&amp;", "&")

			local info = string.match(entry, PAT_DESCRIPTION) or ""
			info = string.gsub(info, "&amp;", "&")
			info = string.gsub(info, "&amp;", "&")
			info = string.gsub(info, "&quot;", "\"")
			info = string.gsub(info, ";", Variables.CRLF)

			
			entryAArray['title'] = title 												-- fetch title, overwrite &amp twice cause Gcal saves & this way
			entryAArray['pubDate'] = PubDate(date)										-- integer date
			entryAArray['pubTime'] = PubTime(date)										-- integer time
			entryAArray['date'] = os.date("%A, %d. %b", entryAArray['pubDate'])			-- fetch date in string format
			entryAArray['link'] = string.match(entry, PAT_LINK)							-- fetch link of feed
			entryAArray['info'] = date .. '#CRLF#' .. place .. '#CRLF#' .. info			-- fetch info
			entryAArray['color'] = Variables['BarColor' .. i] or Variables['DefaultBarColor']	-- string color
			
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
	local dayIterator, elemIterator = 0, 1
	local sMeterDate, sMeterBar, sMeterInfo = "", "", ""

	local lastDate = 0
	local today, tomorrow = Time.getToday(), Time.getTomorrow()

	for id, entry in pairs(tEntries) do

		-- check if a new day started
		if lastDate ~= entry.pubDate then
			-- clear all MeterBar and MeterInfo after this one
			while Meters['mD'.. dayIterator ..'E' .. elemIterator .. 'Bar'].isMeter() do
				sMeterBar = Meters['mD'.. dayIterator ..'E' .. elemIterator .. 'Bar']
				sMeterInfo = Meters['mD'.. dayIterator ..'E' .. elemIterator .. 'Info']

				sMeterInfo.MeterStyle = "sEInfoDefault"
				sMeterInfo.Text = ""
				sMeterInfo.update()
				
				sMeterBar.SolidColor = "00000000"
				sMeterBar.update()

				elemIterator = elemIterator + 1
			end

			lastDate = entry.pubDate
			dayIterator = dayIterator + 1
			elemIterator = 1

			sMeterDate = Meters['mD' .. dayIterator .. 'Date']

			if sMeterDate.isMeter() then
				-- check for today and tomorrow display
				if entry.pubDate == today then
					sMeterDate.MeterStyle = "sDateToday"
				elseif entry.pubDate == tomorrow then 
					sMeterDate.MeterStyle = "sDateTomorrow"
				else 
					sMeterDate.MeterStyle = "sDateDefault"
				end

				sMeterDate.Text = entry.date
				sMeterDate.update()
			else
				break
			end
		end

		sMeterBar = Meters['mD'.. dayIterator ..'E' .. elemIterator .. 'Bar']
		sMeterInfo = Meters['mD'.. dayIterator ..'E' .. elemIterator .. 'Info']

		if sMeterInfo.isMeter() and sMeterBar.isMeter() then

			sMeterInfo.MeterStyle = "sEInfoHighlight"
			sMeterInfo.Text = entry.title
			sMeterInfo.LeftMouseUpAction = entry.link
			sMeterInfo.ToolTipText = entry.info or ""
			sMeterInfo.update()

			sMeterBar.SolidColor = entry.color
			sMeterBar.update()

			elemIterator = elemIterator + 1
		end
	end

	Meters.redraw()
end

-- ==================================================
-- WRAPPER
-- ==================================================
Time = {}

function Time.getNow()
	return os.time()
end

function Time.getToday()
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

	return today
end

function Time.getTomorrow()
	local now = os.time()
	local nowTable = os.date("*t", now)
	local tomorrow = os.time{
		year = nowTable.year,
		month = nowTable.month,
		day = nowTable.day + 1,
		hour = 0,
		min = 0,
		sec = 0
	}

	return tomorrow
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