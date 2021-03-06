-- upon webparser creation
function Initialize()

	-- Libs
	local ooppath = SKIN:GetVariable('CURRENTPATH').."parser\\InterfaceOOPAccess.lua"
	Meters, Measures, Variables = dofile(ooppath)(SKIN)

	local readerpath = Variables['CURRENTPATH'].."parser\\FileReader.lua"
	FileReader = dofile(readerpath)

	-- tables
	RAW_CALS = {}
	T_MONTH_NUM = {Jan=1;Feb=2;Mar=3;Apr=4;Mai=5;Jun=6;Jul=7;Aug=8;Sep=9;Okt=10;Nov=11;Dez=12;}

	-- pattern
	PAT_ENTRY = 'BEGIN:VEVENT\n(.-)\nEND:VEVENT'
	PAT_TITLE = '.-SUMMARY:(.-)\nTRANSP:.-'
	PAT_PLACE = '.-LOCATION:(.-)\nSEQUENCE:'	
	
	PAT_START_DATE = 'DTSTART;VALUE=DATE:(.-)\n'
	PAT_END_DATE = 'DTEND;VALUE=DATE:(.-)\n'

	PAT_START_DATE_TIME = '.-DTSTART:(.-)\n'
	PAT_END_DATE_TIME = '.-DTEND:(.-)\n'

	PAT_START_ZONED_DATE_TIME = 'DTSTART;TZID=.-:(.-)\n'
	PAT_END_ZONED_DATE_TIME = 'DTEND;TZID=.-:(.-)\n'

	PAT_PARSE_DATE = '(%d%d%d%d)(%d%d)(%d%d)'
	PAT_PARSE_DATE_TIME = '(%d%d%d%d)(%d%d)(%d%d)T(%d%d)(%d%d)(%d%d)'

	-- FREQ could be:
	-- - SECONDLY
	-- - MINUTELY
	-- - HOURLY
	-- - DAILY
	-- - WEEKLY
	-- - MONTHLY
	-- - YEARLY
	PAT_PARSE_RRULE_FREQ = 'RRULE:FREQ=(%a+)'
	PAT_PARSE_RRULE_UNTIL = 'RRULE:.-UNTIL=([%a%d]+)'

	-- The WKST rule part specifies the day on which the workweek starts.
    -- Valid values are MO, TU, WE, TH, FR, SA and SU. This is significant
    -- when a WEEKLY RRULE has an interval greater than 1, and a BYDAY rule
    -- part is specified. This is also significant when in a YEARLY RRULE
    -- when a BYWEEKNO rule part is specified. The default value is MO.
	PAT_PARSE_RRULE_WKST = 'RRULE:.-WKST=(%a%a)'

	-- The BYDAY rule part specifies a COMMA character (US-ASCII decimal 44)
 	-- separated list of days of the week; MO indicates Monday; TU indicates
 	-- Tuesday; WE indicates Wednesday; TH indicates Thursday; FR indicates
 	-- Friday; SA indicates Saturday; SU indicates Sunday.
	PAT_PARSE_RRULE_BYDAY = 'RRULE:.-BYDAY=(%a%a)'

	-- does not exist anymore
	-- PAT_LINK = '.-<link.-href=.(.-). title.-%/>' 

	-- this is the title given in the calendar
	PAT_SUMMARY = '.-SUMMARY:(.-)\nTRANSP:'

	-- additional information added to the event. Could be empty
	PAT_DESCRIPTION = 'DESCRIPTION:(.-)\nLAST%-MODIFIED:'

	-- -- variables
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

	table.insert(RAW_CALS, fileContent)
	
	-- get next Cal
	local fetchedUrl = fetchNextCalUrl()

	-- display progression
	displayLoadProgression()

	-- check for validity
	if not fetchedUrl then
		prepareRawData()

		-- Reset Table
		RAW_CALS = {}

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
	Meters.mD1Date.Text = Meters.mD1Date.Text .. "."
	Meters.mD1Date.update()
end

-- needs the current url and fetches the next url in line sorted by Variable ID
function fetchNextCalUrl()
	if I_CURR_URL_COUNT < I_TOTAL_COUNT then
		I_CURR_URL_COUNT = I_CURR_URL_COUNT + 1
		local nextCalUrl = Variables["Cal" .. I_CURR_URL_COUNT]

		return nextCalUrl
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
	local entries = {}

	-- iterate over each calendar
	-- now is the start of today, so display all events which are today
	local now = getDateFromToday()
	for index, rawCals in pairs(RAW_CALS) do
		local calname = string.match(rawCals, 'X%-WR%-CALNAME:(.-)\n')

		-- apparently its faster in lua to parse everything into a string and work on it via gstring gsub etc
		for rawEntry in string.gmatch(rawCals, PAT_ENTRY) do
			-- optimization: only events ending after now should be taken; events could have started in the past, does not matter
			local startInstant = extractStartInstantFromRawEntry(rawEntry)
			local endInstant = extractEndInstantFromRawEntry(rawEntry, startInstant)
			local isFutureEvent = endInstant >= now

			-- need also handle recurring events
			-- they can have excluded dates
			-- 1. on a regular basis like anniversary
			-- 2. limited by a time frame


			local isRelevant = isFutureEvent or false or false

			if isFutureEvent then
				local entry = extractEntryFromRaw(rawEntry, startInstant, endInstant, index, calname)

				table.insert(entries, entry)
			end
		end
	end

	-- sort table
	table.sort(entries, function(curr, next) return curr.startInstant < next.startInstant end)

	displayEntries(entries)
	
	print("finished preparing raw data of #" .. #entries .. " entries.")
end

function extractEntryFromRaw(rawEntry, startInstant, endInstant, index, calname)
	local entry = {}
	
	entry['startInstant'] = startInstant
	entry['startDate'] = getDateFromInstant(startInstant)
	entry['endInstant'] = endInstant
	entry['endDate'] = getDateFromInstant(endInstant)
	entry['displayText'] = extractDisplayTextFromRawEntry(rawEntry, startInstant)
	entry['tooltip'] = extractTooltipFromRawEntry(rawEntry, startInstant, entry['endInstant'], calname)
	entry['color'] = Variables['BarColor' .. index] or Variables['DefaultBarColor']
	entry['header'] = extractHeaderFromInstants(startInstant, entry['endInstant'])

	return entry
end

function extractStartInstantFromRawEntry(rawEntry)
	-- default case runnung a time span
	local startDateTime = string.match(rawEntry, PAT_START_DATE_TIME)
	
	-- special case that it is an event runs whole day
	local startDate = string.match(rawEntry, PAT_START_DATE)

	-- super special case with zones; newer events
	local startZonedDateTime = string.match(rawEntry, PAT_START_ZONED_DATE_TIME)
	
	if not not startDateTime then
		return extractDateTimeFromUTCString(startDateTime)
	elseif not not startDate then
		return extractDateFromUTCString(startDate)
	elseif not not startZonedDateTime then
		return extractDateTimeFromUTCString(startZonedDateTime)
	else
		print("IllegalStateException: found startDateTime and startDate nil for " .. rawEntry)
	end
end

-- return default if no end date was found
function extractEndInstantFromRawEntry(rawEntry, default)
	-- default case runnung a time span
	local endDateTime = string.match(rawEntry, PAT_END_DATE_TIME)

	-- special case that it is an event runs whole day
	local endDate = string.match(rawEntry, PAT_END_DATE)

	-- super special case with zones; newer events
	local endZonedDateTime = string.match(rawEntry, PAT_END_ZONED_DATE_TIME)

	if not not endDateTime then
		return extractDateTimeFromUTCString(endDateTime)
	elseif not not endDate then
		return extractDateFromUTCString(endDate)
	elseif not not endZonedDateTime then
		return extractDateFromUTCString(endZonedDateTime)
	else
		return default
	end
end

-- title is displayed directly on the meter
-- contains special handling depending if it contains time and if this ends on a different date
-- dates are collected in a bin later on
-- dates without times are sorted to the top
-- dates with times are sorted by time and displayed in the title in front
-- due to space reasons only the start time is displayed
-- example: 
-- | Daily Event
-- 10:00 Event
-- 11:00 Event
function extractDisplayTextFromRawEntry(rawEntry, startInstant)
	local title = string.match(rawEntry, PAT_TITLE)
	local startDate = string.match(rawEntry, PAT_START_DATE)
	
	if startDate then
		return title
	else 
		local formatted = os.date("%H:%M: ", startInstant)
		return formatted .. title
	end
end

-- info is displayed as tool tip
-- contains date, place, description
-- start instant and end instant can be the same -> ignore end instant
function extractTooltipFromRawEntry(rawEntry, startInstant, endInstant, calname) 
	local date = os.date("%A, %d. %b", startInstant)

	local place = string.match(rawEntry, PAT_PLACE)
	local summary = string.match(rawEntry, PAT_SUMMARY)
	local description = string.match(rawEntry, PAT_DESCRIPTION)
	if description then
		description = '#CRLF#' .. description
	else 
		description = ""
	end
	
	if endInstant > startInstant then
		local startTime = getTimeFromInstant(startInstant)
		local endTime = getTimeFromInstant(endInstant)
		local formattedEndDate = os.date("%A, %d. %b", endInstant - 86400)

		-- found whole day event
		if (startTime == 0) and (endTime == 0) then
			if isStartOneDayApartFromEnd(startInstant, endInstant) then
				return calname .. '#CRLF#' .. date .. '#CRLF#' .. place .. '#CRLF#' .. summary .. description
			else 
				return calname .. '#CRLF#' .. date .. " - " .. formattedEndDate .. '#CRLF#' .. place .. '#CRLF#' .. summary .. description
			end
		else
			local startDate = getDateFromInstant(startInstant)
			local endDate = getDateFromInstant(endInstant)

			local isSameDay = startDate == endDate
			if isSameDay then
				local formattedStartTime = os.date("%H:%M", startInstant)
				local formattedEndTime = os.date("%H:%M", endInstant)
				
				return calname .. '#CRLF#' .. date .. '#CRLF#' .. formattedStartTime .. " - " .. formattedEndTime .. '#CRLF#' .. place .. '#CRLF#' .. summary .. description
			end
		end

		return calname .. '#CRLF#' .. date .. " - " .. formattedEndDate .. '#CRLF#' .. place .. '#CRLF#' .. summary .. description

	-- special case where no end date was defined
	else 
		return calname .. '#CRLF#' .. date .. '#CRLF#' .. place .. '#CRLF#' .. summary .. description
	end
end

-- header is displayed as the bin collection
-- apparently the end date is optional if the start time and end time are equal ^= instant
-- whole day events have unequal dates and have no time and are exactly 1 day offs, so basically 0 seconds off
function extractHeaderFromInstants(startInstant, endInstant)
	local formattedStartDate = os.date("%A, %d. %b", startInstant)
	-- we have to substract the end date to get the display date when the events ends
	local formattedEndDate = os.date("%A, %d. %b", endInstant - 86400)

	-- could be real events split over multiple days or a whole day event
	if endInstant > startInstant then
		local startTime = getTimeFromInstant(startInstant)
		local endTime = getTimeFromInstant(endInstant)

		-- found whole day event
		if (startTime == 0) and (endTime == 0) then
			if isStartOneDayApartFromEnd(startInstant, endInstant) then
				return formattedStartDate
			else 
				return formattedStartDate .. " - " .. formattedEndDate				
			end
		else
			local startDate = getDateFromInstant(startInstant)
			local endDate = getDateFromInstant(endInstant)

			local isSameDay = startDate == endDate
			if isSameDay then
				return formattedStartDate
			end
		end

		return formattedStartDate .. " - " .. formattedEndDate

	-- end date was optional and thus return same end instant than start instant
	else  
		return formattedStartDate
	end
end

function displayEntries(tEntries)
	local dayIterator, elemIterator = 0, 1
	local sMeterDate, sMeterBar, sMeterInfo = "", "", ""

	local lastDate = 0

	-- used to differentiate the styles for near events
	local today, tomorrow = getDateFromToday(), getDateFromTomorrow()

	for id, entry in pairs(tEntries) do

		-- check if a new day started
		if lastDate ~= entry.startDate then
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

			lastDate = entry.startDate
			dayIterator = dayIterator + 1
			elemIterator = 1

			sMeterDate = Meters['mD' .. dayIterator .. 'Date']

			if sMeterDate.isMeter() then
				-- check for today and tomorrow display
				if entry.startDate == today then
					sMeterDate.MeterStyle = "sDateToday"
				elseif entry.startDate == tomorrow then 
					sMeterDate.MeterStyle = "sDateTomorrow"
				else 
					sMeterDate.MeterStyle = "sDateDefault"
				end

				sMeterDate.Text = entry.header
				sMeterDate.update()
			else
				break
			end
		end

		sMeterBar = Meters['mD'.. dayIterator ..'E' .. elemIterator .. 'Bar']
		sMeterInfo = Meters['mD'.. dayIterator ..'E' .. elemIterator .. 'Info']

		if sMeterInfo.isMeter() and sMeterBar.isMeter() then

			sMeterInfo.MeterStyle = "sEInfoHighlight"
			sMeterInfo.Text = entry.displayText
			-- sMeterInfo.LeftMouseUpAction = entry.link
			sMeterInfo.ToolTipText = entry.tooltip or ""
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
function getDateFromToday()
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

function getDateFromTomorrow() 
	local now = os.time()
	local nowTable = os.date("*t", now)
	local tomorrow = os.time({
		year = nowTable.year,
		month = nowTable.month,
		day = nowTable.day + 1,
		hour = 0,
		min = 0,
		sec = 0
	})

	return tomorrow
end

function isStartOneDayApartFromEnd(startInstant, endInstant)
	local start = os.date("*t", startInstant)
	local offset = os.time({
		year = start.year,
		month = start.month,
		day = start.day + 1,
		hour = start.hour,
		min = start.min,
		sec = start.sec
	})

	return offset == endInstant
end

function getTimeFromInstant(instant)
	local instantTime = os.date("*t", instant)

	local time = 0
	time = time + instantTime.hour * 60 * 60
	time = time + instantTime.min * 60
	time = time + instantTime.sec

	return time
end

function getDateFromInstant(instant)
	local nowTable = os.date("*t", instant)
	local date = os.time({
		year = nowTable.year,
		month = nowTable.month,
		day = nowTable.day,
		hour = 0,
		min = 0,
		sec = 0
	})

	return date
end

function extractDateFromUTCString(utc)
	local year, month, day = string.match(utc, PAT_PARSE_DATE)

	-- need to handle time before 1970
	if year < "1970" then
		year = "1970"
	end

	local extracted = os.time({
		year = year, 
		month = month, 
		day = day, 
		hour = 0,
		min = 0,
		sec = 0
	})

	return extracted
end

function extractDateTimeFromUTCString(utc)
	local year, month, day, hour, min, sec = string.match(utc, PAT_PARSE_DATE_TIME)

	-- need to handle time before 1970
	if year < "1970" then
		year = "1970"
	end

	local date = os.time({
		year = year, 
		month = month, 
		day = day, 
		hour = hour,
		min = min,
		sec = sec
	})

	return date
end
