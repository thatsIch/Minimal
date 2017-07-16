-- upon webparser creation
function Initialize()

	-- Libs
	local libspath = SKIN:GetVariable('CURRENTPATH').."parser\\" 

	Meters, Measures, Variables = dofile(libspath .. "InterfaceOOPAccess.lua")(SKIN)
	FileReader = dofile(libspath .. "FileReader.lua")
	Display = dofile(libspath .. "display.lua")
	DateTime = dofile(libspath .. "datetime.lua")

	-- tables

	-- used to globally store all calendars before processing
	-- is resetted in the end of one iteration cycle
	RAW_CALS = {}

	-- pattern
	-- timezone related pattern
	PAT_VTIMEZONE = 'BEGIN:VTIMEZONE\n(.-)\nEND:VTIMEZONE'
	PAT_TZ_DAYLIGHT = 'BEGIN:DAYLIGHT\n(.-)\nEND:DAYLIGHT'
	PAT_TZ_STANDARD = 'BEGIN:STANDARD\n(.-)\nEND:STANDARD'
	PAT_TZ_OFFSETFROM = 'TZOFFSETFROM:([+-]%d%d%d%d)\n'
	PAT_TZ_OFFSETTO = 'TZOFFSETTO:([+-]%d%d%d%d)\n'
	PAT_TZ_NAME = 'TZNAME:(%a-)\n'
	PAT_TZ_DTSTART = '(%d%d%d%d)(%d%d)(%d%d)T(%d%d)(%d%d)(%d%d)'
	PAT_TZ_RRULE = 'RRULE:(.-)\n'
	PAT_TZ_RRULE_FREQ = 'FREQ=(%a+)'
	PAT_TZ_RRULE_BYMONTH = 'BYMONTH=(%d+)'
	PAT_TZ_RRULE_BYDAY = 'BYDAY=([-%d%a]+)'

	-- event related pattern
	PAT_ENTRY = 'BEGIN:VEVENT\n(.-)\nEND:VEVENT'
	PAT_TITLE = '.-SUMMARY:(.-)\nTRANSP:.-'
	PAT_PLACE = '.-LOCATION:(.-)\nSEQUENCE:'	
	
	PAT_START_DATE = 'DTSTART;VALUE=DATE:(.-)\n'
	PAT_END_DATE = 'DTEND;VALUE=DATE:(.-)\n'

	PAT_START_DATE_TIME = '.-DTSTART:(.-)\n'
	PAT_END_DATE_TIME = '.-DTEND:(.-)\n'

	PAT_START_ZONED_DATE_TIME = 'DTSTART;TZID=.-:(.-)\n'
	PAT_END_ZONED_DATE_TIME = 'DTEND;TZID=.-:(.-)\n'

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

	print(DateTime("20150911T203309Z"):spanticks())
	-- print(DateTime("19700329T020000"):fmt("%A, %d. %B %Y"))
	-- print(DateTime("20150117"):fmt("%A, %d. %B %Y"))
	-- print(DateTime("20140205T131500Z"):fmt("%A, %d. %B %Y"))

	-- no coroutines

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
	Display.updateLoadProgression()

	-- check for validity
	if not fetchedUrl then
		prepareRawData()

		-- Reset Table
		RAW_CALS = {}

		-- Reset Url Counter
		I_CURR_URL_COUNT = 1

		-- Reset LoadBar
		Display.updateLoadProgression = function() return nil end

		-- Reset WebParser to first Calendar
		Measures.mWebParser.Url = Variables.Cal1
		return
	end

 	-- pass new url and update
 	Measures.mWebParser.Url = fetchedUrl
 	Measures.mWebParser.forceUpdate()
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
	local now = DateTime(true)
	for index, rawCals in pairs(RAW_CALS) do
		local calname = string.match(rawCals, 'X%-WR%-CALNAME:(.-)\n')

		-- apparently its faster in lua to parse everything into a string and work on it via gstring gsub etc
		for rawEntry in string.gmatch(rawCals, PAT_ENTRY) do
			-- optimization: only events ending after now should be taken; events could have started in the past, does not matter
			local startDateObject = extractStartDateObjectFromRawEntry(rawEntry)
			local endDateObject = extractEndDateObjectFromRawEntry(rawEntry, startDateObject)
			local isFutureEvent = endDateObject >= now

			-- need also handle recurring events
			-- they can have excluded dates
			-- 1. on a regular basis like anniversary
			-- 2. limited by a time frame


			local isRelevant = isFutureEvent or false or false

			if isFutureEvent then
				local entry = extractEntryFromRaw(rawEntry, startDateObject, endDateObject, index, calname)

				table.insert(entries, entry)
			end
		end
	end

	-- sort table
	table.sort(entries, function(curr, next) return curr.start < next.start end)

	Display.renderEvents(entries)
	
	print("finished preparing raw data of #" .. #entries .. " entries.")
end

function extractEntryFromRaw(rawEntry, startDateObject, endDateObject, index, calname)
	local entry = {}
	
	entry['start'] = startDateObject
	entry['end'] = endDateObject
	entry['displayText'] = extractDisplayTextFromRawEntry(rawEntry, startDateObject)
	entry['tooltip'] = extractTooltipFromRawEntry(rawEntry, startDateObject, endDateObject, calname)
	entry['color'] = Variables['BarColor' .. index] or Variables['DefaultBarColor']
	entry['header'] = extractHeaderFromInstants(startDateObject, endDateObject)

	return entry
end

function extractStartDateObjectFromRawEntry(rawEntry)
	-- default case runnung a time span
	local startDateTime = string.match(rawEntry, PAT_START_DATE_TIME)
	if not not startDateTime then
		return DateTime(startDateTime)
	end

	-- special case that it is an event runs whole day
	local startDate = string.match(rawEntry, PAT_START_DATE)
	if not not startDate then
		return DateTime(startDate)
	end

	-- super special case with zones; newer events
	local startZonedDateTime = string.match(rawEntry, PAT_START_ZONED_DATE_TIME)
	if not not startZonedDateTime then
		return DateTime(startZonedDateTime)
	end

	print("IllegalStateException: found startDateTime and startDate nil for " .. rawEntry)
end

-- return default if no end date was found
function extractEndDateObjectFromRawEntry(rawEntry, default)
	-- default case runnung a time span
	local endDateTime = string.match(rawEntry, PAT_END_DATE_TIME)
	if endDateTime then
		return DateTime(endDateTime)
	end

	-- special case that it is an event runs whole day
	local endDate = string.match(rawEntry, PAT_END_DATE)
	if endDate then
		return DateTime(endDate)
	end

	-- super special case with zones; newer events
	local endZonedDateTime = string.match(rawEntry, PAT_END_ZONED_DATE_TIME)
	if endZonedDateTime then
		return DateTime(endZonedDateTime)
	end

	-- default case if nothing matches because no end date was defined
	return default
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
function extractDisplayTextFromRawEntry(rawEntry, startDateObject)
	local title = string.match(rawEntry, PAT_TITLE)
	local startDate = string.match(rawEntry, PAT_START_DATE)
	
	if startDate then
		return title
	else 
		local formatted = startDateObject:fmt("%H:%M: ")
		return formatted .. title
	end
end

-- info is displayed as tool tip
-- contains date, place, description
-- start instant and end instant can be the same -> ignore end instant
function extractTooltipFromRawEntry(rawEntry, startDateObject, endDateObject, calname) 
	local date = startDateObject:fmt("%A, %d. %b")

	local place = string.match(rawEntry, PAT_PLACE)
	local summary = string.match(rawEntry, PAT_SUMMARY)
	local description = string.match(rawEntry, PAT_DESCRIPTION)
	if description then
		description = '#CRLF#' .. description
	else 
		description = ""
	end
	
	if endDateObject > startDateObject then
		local formattedEndDate = endDateObject:fmt("%A, %d. %b")

		-- found whole day event
		local isStartOfDay = (startDateObject:gethours() == 0 and startDateObject:getminutes() == 0 and startDateObject:getseconds() == 0)
		local isEndOfDay = (endDateObject:gethours() == 0 and endDateObject:getminutes() == 0 and endDateObject:getseconds() == 0)
		if (isStartOfDay and isEndOfDay) then
			if isStartOneDayApartFromEnd(startDateObject, endDateObject) then
				return calname .. '#CRLF#' .. date .. '#CRLF#' .. place .. '#CRLF#' .. summary .. description
			else 
				return calname .. '#CRLF#' .. date .. " - " .. formattedEndDate .. '#CRLF#' .. place .. '#CRLF#' .. summary .. description
			end
		else
			if isSameDay(startDateObject, endDateObject) then
				local formattedStartTime = startDateObject:fmt("%H:%M")
				local formattedEndTime = endDateObject:fmt("%H:%M")
				
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
function extractHeaderFromInstants(startDateObject, endDateObject)
	local formattedStartDate = startDateObject:fmt("%A, %d. %b")
	-- we have to substract the end date to get the display date when the events ends
	local formattedEndDate = endDateObject:fmt("%A, %d. %b")

	-- could be real events split over multiple days or a whole day event
	if endDateObject > startDateObject then
		-- found whole day event
		if isWholeDayEvent(startDateObject, endDateObject) then
			if isStartOneDayApartFromEnd(startDateObject, endDateObject) then
				return formattedStartDate
			else 
				return formattedStartDate .. " - " .. formattedEndDate				
			end
		else
			if isSameDay(startDateObject, endDateObject) then
				return formattedStartDate
			end
		end

		return formattedStartDate .. " - " .. formattedEndDate

	-- end date was optional and thus return same end instant than start instant
	else  
		return formattedStartDate
	end
end


-- ==================================================
-- WRAPPER
-- ==================================================

function isStartOneDayApartFromEnd(startDateObject, endDateObject)
	local start = startDateObject:copy()
	start:adddays(1)

	return start:getdate() == endDateObject:getdate()
end

function isWholeDayEvent(startDateObject, endDateObject)
	local isStartOfDay = (startDateObject:gethours() == 0 and startDateObject:getminutes() == 0 and startDateObject:getseconds() == 0)
	local isEndOfDay = (endDateObject:gethours() == 0 and endDateObject:getminutes() == 0 and endDateObject:getseconds() == 0)
	
	return isStartOfDay and isEndOfDay
end

function isSameDay(startDateObject, endDateObject)
	local startDate = DateTime(startDateObject:getdate())
	local endDate = DateTime(endDateObject:getdate())

	local isSameDay = startDate == endDate

	return isSameDay
end