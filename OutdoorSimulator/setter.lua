-- information provided:
-- * sunrise
-- * sunset
-- * solar noon
-- * civil twilight begin (civil dawn)
-- * civil twilight end (civil dusk)
-- * nautical twilight begin (nautical dawn)
-- * nautical twilight end (nautical dusk)
-- * astronical twilight begin (astronomical dawn)
-- * astronical twilight end (astronomical dusk)
--
-- thus some information must be interpolated
-- 
-- order ascending:
-- * solar midnight 
-- * astronomical dawn
-- * nautical dawn
-- * civil dawn 
-- * sunrise
-- * solar noon
-- * sunset
-- * civil dusk
-- * nautical dusk
-- * astronomical dusk
-- * ... repeat
-- 
-- there are dates and latitudes where there is not even a sunrise thus also no dawn and dusk.
-- need to handle it somehow
-- should caclulate it and if not the timephase before is shifted
-- technically at first there is no astronomical twilight
-- thus the whole night is naught
-- after that 

debug = true

function Initialize()
	-- os.time() returns current system time
	-- table.foreach(os.date('*t', os.time()), print) 


	AstronomicalDawnMeasure = SKIN:GetMeasure('AstronomicalTwilightBegin')
	AstronomicalDawnTimeMeasure = SKIN:GetMeasure('AstronomicalTwilightBeginTime')
	NauticalDawnMeasure = SKIN:GetMeasure('NauticalTwilightBeginTime')
	CivilDawnMeasure = SKIN:GetMeasure('CivilTwilightBeginTime')
	SunriseTimeMeasure = SKIN:GetMeasure('SunriseTime')
	SolarNoonTimeMeasure = SKIN:GetMeasure('SolarNoonTime')
	SunsetTimeMeasure = SKIN:GetMeasure('SunsetTime')
	CivilDuskMeasure = SKIN:GetMeasure('CivilTwilightEndTime')
	NauticalDuskMeasure = SKIN:GetMeasure('NauticalTwilightEndTime')
	AstronomicalDuskMeasure = SKIN:GetMeasure('AstronomicalTwilightEndTime')
end

function Update()
	print(AstronomicalDawnMeasure:GetStringValue())
	print("--" .. parseDateTimeToInstant(AstronomicalDawnMeasure:GetStringValue()))

	local now = os.time()

	local original = extractTimesIntoTable()
	local offset = tranposeTableByInstant(original, now)
	local extrapolated = extrapolateTimeTable(offset, now)
	if debug then
		local sorted = sortpairs(extrapolated)
		dump(sorted)
	end

	local TimeTable = {}
	TimeTable.Now = os.time()
	
	-- debug line to shift time manually
	-- TimeTable.Now = TimeTable.Now + 3600 * 17

	-- transposeToNextDayOnNewDay handles when now is a new day but no internet connection is there to update the measures
	TimeTable.AstronomicalDawn = transposeToNextDayOnNewDay(parseDateStringToInstant(AstronomicalDawnTimeMeasure:GetStringValue()), TimeTable.Now)
	TimeTable.LastAstronomicalDawn = decrementDay(TimeTable.AstronomicalDawn)
	TimeTable.NextAstronomicalDawn = incrementDay(TimeTable.AstronomicalDawn)
	TimeTable.AstronomicalDusk = transposeToNextDayOnNewDay(parseDateStringToInstant(AstronomicalDuskMeasure:GetStringValue()), TimeTable.Now)
	TimeTable.LastAstronomicalDusk = decrementDay(TimeTable.AstronomicalDusk)

	TimeTable.NauticalDawn = transposeToNextDayOnNewDay(parseDateStringToInstant(NauticalDawnMeasure:GetStringValue()), TimeTable.Now)
	TimeTable.NauticalDusk = transposeToNextDayOnNewDay(parseDateStringToInstant(NauticalDuskMeasure:GetStringValue()), TimeTable.Now)
	
	TimeTable.CivilDawn = transposeToNextDayOnNewDay(parseDateStringToInstant(CivilDawnMeasure:GetStringValue()), TimeTable.Now)
	TimeTable.CivilDusk = transposeToNextDayOnNewDay(parseDateStringToInstant(CivilDuskMeasure:GetStringValue()), TimeTable.Now)

	TimeTable.Sunrise = transposeToNextDayOnNewDay(parseDateStringToInstant(SunriseTimeMeasure:GetStringValue()), TimeTable.Now)
	TimeTable.SolarNoon = transposeToNextDayOnNewDay(parseDateStringToInstant(SolarNoonTimeMeasure:GetStringValue()), TimeTable.Now)
	TimeTable.Sunset = transposeToNextDayOnNewDay(parseDateStringToInstant(SunsetTimeMeasure:GetStringValue()), TimeTable.Now)
	TimeTable.SolarMidnight = math.floor((TimeTable.NextAstronomicalDawn + TimeTable.AstronomicalDusk) / 2)
	TimeTable.LastSolarMidnight = math.floor((TimeTable.AstronomicalDawn + TimeTable.LastAstronomicalDusk) / 2)



	-- single section
	if extrapolated.AstronomicalDawn <= now and now < extrapolated.NauticalDawn then
		print("astronomical dawn <= now < nautical dawn")
		setWallpaper("astronomical_dawn")

	-- single section
	elseif extrapolated.NauticalDawn <= now and now < extrapolated.CivilDawn then
		print("nautical dawn <= now < civil dawn")
		setWallpaper("nautical_dawn")

	-- single section
	elseif extrapolated.CivilDawn <= now and now < extrapolated.Sunrise then
		print("civil dawn <= now < sunrise")
		setWallpaper("civil_dawn")

	-- single section 
	elseif extrapolated.Sunset <= now and now < extrapolated.CivilDusk then
		print("sunset <= now < civil dusk")
		setWallpaper("sunset")

	-- single section
	elseif extrapolated.CivilDusk <= now and now < extrapolated.NauticalDusk then
		print("civil dusk <= now < nautical dusk")
		setWallpaper("civil_dusk")

	-- single section
	elseif extrapolated.NauticalDusk <= now and now < extrapolated.AstronomicalDusk then
		print("nautical dusk <= now < astronomical dusk")
		setWallpaper("nautical_dusk")

	-- special starter image with sections
	-- always correct
	-- no special handling required 
	-- sunrise < solar noon
	-- per definition the solar noon is between sunrise and sunset
	elseif extrapolated.Sunrise <= now and now < extrapolated.SolarNoon then
		print("sunrise <= now < solar noon")
		setWallpaperByTimeSectionWithStartImage(extrapolated.Sunrise, extrapolated.SolarNoon, now, 15, "sunrise", "day_start")

	-- special starter image with sections
	-- always correct
	-- no special handling required 
	-- solar noon < sunset
	-- per definition the solar noon is between sunrise and sunset
	elseif extrapolated.SolarNoon <= now and now < extrapolated.Sunset then
		print("solar noon <= now < sunset")
		setWallpaperByTimeSectionWithStartImage(extrapolated.SolarNoon, extrapolated.Sunset, now, 15, "solar_noon", "day_end")

	-- from astronomical dusk till dawn we need to prepare it
	-- because there can be funky times where one is on another day
	-- TODO check later cases
	-- the whole logic is flawed because we times are not correctly parsed!!!

	-- this section is for dusk over midnight till dawn
	-- every other possibility is already handled

	-- special starter image with sections
	elseif extrapolated.SolarMidnight <= now and now < extrapolated.AstronomicalDawn then
		print("solar midnight <= now < astronomical dawn")
		setWallpaperByTimeSectionWithStartImage(extrapolated.SolarMidnight, extrapolated.AstronomicalDawn, now, 12, "solar_mightnight", "night_end")

	-- special handle case when new day comes
	-- because the solar midnight is after 0:00
	elseif TimeTable.SolarMidnight <= TimeTable.Now and TimeTable.Now < TimeTable.NextAstronomicalDawn then
		print("solar midnight <= now < next astronomical dawn")
		setWallpaperByTimeSectionWithStartImage(TimeTable.SolarMidnight, TimeTable.NextAstronomicalDawn, TimeTable.Now, 12, "solar_mightnight", "night_end")		

	-- special handle case when new day came and all normal times are shifted
	-- now > 00:00, every timestamp > now
	elseif TimeTable.LastSolarMidnight <= TimeTable.Now and TimeTable.Now < TimeTable.AstronomicalDawn then
		print("last solar midnight <= now < astronomical dawn")
		setWallpaperByTimeSectionWithStartImage(TimeTable.LastSolarMidnight, TimeTable.AstronomicalDawn, TimeTable.Now, 12, "solar_mightnight", "night_end")		


	-- case if solar midnight is before 00:00
	elseif TimeTable.AstronomicalDusk <= TimeTable.Now and TimeTable.Now < TimeTable.SolarMidnight then
		print("astronomical dusk <= now < solar midnight")
		setWallpaperByTimeSectionWithStartImage(TimeTable.AstronomicalDusk, TimeTable.SolarMidnight, TimeTable.Now, 12, "astronomical_dusk", "night_start")
	
	-- case if solar midnight is after 00:00 could be that astronomical date is not updated yet
	else
		print("found unhandled case.")
		local sorted = sortpairs(TimeTable)
		dump(sorted)
	end

	-- local sorted = sortpairs(TimeTable)
	-- dump(sorted)
end

function sortpairs(tbl)
	local sorted = {}

	for k,v in pairs(tbl) do
		table.insert(sorted, { key = k, value = v }) 
	end

	table.sort(sorted, function(curr, next) return curr.value > next.value end)

	return sorted
end  

function dump(o)
	for index, kv in ipairs(o) do
		local timestamp = kv.value
		local formatted = os.date("%d.%m.%Y - %H:%M:%S", timestamp)
		print(timestamp .. " = " .. formatted .. " -> " .. kv.key)
	end
	-- if type(o) == 'table' then
	--	 local s = '{ '
	--	 for k,v in pairs(o) do
	--		 if type(k) ~= 'number' then k = '"'..k..'"' end
	--		 s = s .. '['..k..'] = ' .. dump(v) .. ','
	--	 end
	--	 return s .. '} '
	-- else
	--	 return tostring(o)
	-- end
end

function setWallpaperByTimeSectionWithStartImage(startInstant, endInstant, currentInstant, sectionCount, initial, cont)
	if debug then
		print("setting wallpaper with start: '" .. startInstant .. "', end '" .. endInstant .. "', current '" .. currentInstant .. "', count '" .. sectionCount .. "', initial '" .. initial .. "' and cont '" .. cont .. "'")
	end

	local timesection = getTimeSectionByCount(startInstant, endInstant, currentInstant, sectionCount)
	if timesection == 0 then 
		print("setting initial wallpaper '" .. initial .. "'")
		setWallpaper(initial)
	else 
		print("setting continuous wallpapaer '" .. cont .. timesection .. "'")
		setWallpaper(cont .. timesection)
	end
end

function setWallpaper(imageName)
	if debug then 
		print("setting to " .. imageName) 
	end
	
	local filePath = SKIN:MakePathAbsolute('backgrounds\\' .. imageName .. '.png')
	local fileHandle = io.open(filePath, "r")
	
	if fileHandle ~= nil then
		io.close(fileHandle)
		SKIN:Bang('!SetWallpaper "backgrounds\\'.. imageName .. '.png" Fill')
	else
		SKIN:Bang('!SetWallpaper "backgrounds\\'.. imageName .. '.jpg" Fill')
	end
end


-- example 2019-06-20T03:26:29+00:00
function parseDateTimeToInstant(dateTime)
	local year, month, day, hour, min, sec = string.match(dateTime, "(%d%d%d%d)-(%d%d)-(%d%d)T(%d%d):(%d%d):(%d%d)+00:00")
	
	local now = os.time()
	local tablerized = os.date("*t", now)

	tablerized.year = year
	tablerized.month = month
	tablerized.day = day
	tablerized.hour = hour
	tablerized.min = min
	tablerized.sec = sec

	local time = os.time(tablerized)

	return time
end

function parseDateStringToInstant(dateString)
	local now = os.time()
	local tablerized = os.date("*t", now)
	local hour, min, sec = string.match(dateString, "(%d%d):-(%d%d):(%d%d)")

	tablerized.hour = hour
	tablerized.min = min
	tablerized.sec = sec

	return os.time(tablerized)
end

function incrementDay(instant)
	local tablerized = os.date("*t", instant) 
	tablerized.day = tablerized.day + 1

	return os.time(tablerized)
end

function decrementDay(instant)
	local tablerized = os.date("*t", instant) 
	tablerized.day = tablerized.day - 1

	local after = os.time(tablerized)

	return after
end

function incrementDaysOfInstantToNow(instant, now)
	local tablerizedinstant = os.date("*t", instant) 
	local tablerizednow = os.date("*t", now) 
	tablerizedinstant.year = tablerizednow.year
	tablerizedinstant.month = tablerizednow.month
	tablerizedinstant.day = tablerizednow.day

	return os.time(tablerizedinstant)
end

-- Compute the difference in seconds between local time and UTC.
function getTimeZoneOffsetInSeconds()
	local now = os.time()
	return os.difftime(now, os.time(os.date("!*t", now)))
end

function getTimeSectionByCount(startInstant, endInstant, currentInstant, count)
	if not (startInstant <= currentInstant) then print("start instant '"..startInstant.."' is not before current instant '"..currentInstant.."'.") end
	if not (currentInstant <= endInstant) then print("current instant '" .. currentInstant .. "' is not before end instant '" .. endInstant .. "'.") end
	if not (count > 0) then print("count is not greater than zero with '" .. count .. "'.") end

	local diff = endInstant - startInstant
	local sectionWidth = diff / count
	local offset = currentInstant - startInstant
	local timesection = math.floor(offset / sectionWidth)

	return timesection
end

-- debug helper to print UNIX timestamp as UTC time
function printTime(name, instant)
	print(name .. ": " .. os.date("!%Y-%m-%dT%TZ", instant))
end

-- all times are on the same date on today
function extractTimesIntoTable()
	local extracted = {}

	extracted.NauticalDawn = parseDateStringToInstant(NauticalDawnMeasure:GetStringValue())
	extracted.CivilDawn = parseDateStringToInstant(CivilDawnMeasure:GetStringValue())
	extracted.Sunrise = parseDateStringToInstant(SunriseTimeMeasure:GetStringValue())
	extracted.SolarNoon = parseDateStringToInstant(SolarNoonTimeMeasure:GetStringValue())
	extracted.Sunset = parseDateStringToInstant(SunsetTimeMeasure:GetStringValue())
	extracted.CivilDusk = parseDateStringToInstant(CivilDuskMeasure:GetStringValue())
	extracted.NauticalDusk = parseDateStringToInstant(NauticalDuskMeasure:GetStringValue())

	-- there is a case where astronical twilight is not calculated correctly by the service
	if SKIN:GetMeasure('AstronomicalTwilightBegin'):GetStringValue() == "1970-01-01T00:00:01+00:00" then
		print("invalid value detected. Assuming values")

		extracted.AstronomicalDawn = extracted.NauticalDawn - 3600
		extracted.AstronomicalDusk = extracted.NauticalDusk + 3600
	else 
		extracted.AstronomicalDawn = parseDateStringToInstant(AstronomicalDawnTimeMeasure:GetStringValue())
		extracted.AstronomicalDusk = parseDateStringToInstant(AstronomicalDuskMeasure:GetStringValue())
	end

	return extracted
end

-- this is used to determine if an instant needs to be transposed to the next day
-- if for example the internet is down. So it uses the old values from the measures
-- and increment the day by 1 if now is the next day
function transposeToNextDayOnNewDay(instant, now)
	local tablerizednow = os.date("*t", now)
	local tablerizedinstant = os.date("*t", instant)

	local sameYear = tablerizednow.year == tablerizedinstant.year
	local sameMonth = tablerizednow.month == tablerizedinstant.month
	local sameDay = tablerizednow.day == tablerizedinstant.day
	if sameYear and sameMonth and sameDay then 
		return instant
	else 
		return incrementDaysOfInstantToNow(instant, now)
	end
end

function sameDate(first, second)
	local sameYear = first.year == second.year
	local sameMonth = first.month == second.month
	local sameDay = first.day == second.day

	return sameYear and sameMonth and sameDay
end 

function daysDifference(first, second)
	return math.floor(math.abs(first - second)/60/60/24)
end

function daysInSeconds(days)
	return days * 60 * 60 * 24
end

function tranposeTableByInstant(tbl, instant)
	-- we only need to compare one entry because all entries are on the same date
	local first = tbl.SolarNoon

	local days = daysDifference(first, instant)
	local secs = daysInSeconds(days)

	local transposed = {}

	-- copies all keys and values into the new table
	for k,v in pairs(tbl) do
		-- we can add here because the instant is always in the future or present thus secs is always positive
		local newV = v + secs

		transposed[k] = newV
	end

	return transposed
end

-- we can extrapolate some values which could be important like
-- * solar midnight
-- * previous values
-- * next values
-- 
-- to determine the solar midnight we can add or substract 12h from solar noon
-- 
function extrapolateTimeTable(timeTable, now)
	local extrapolated = {}

	for k,v in pairs(timeTable) do
		extrapolated[k] = v
	end

	extrapolated.SolarMidnight = calculateSolarMidnight(timeTable.SolarNoon)
	extrapolated.Now = now
	
	return extrapolated
end

function calculateSolarMidnight(solarNoon)
	local tablerized = os.date("*t", solarNoon) 
	if tablerized.hour >= 12 then
		tablerized.hour = tablerized.hour - 12
	else
		tablerized.hour = tablerized.hour + 12
	end

	return os.time(tablerized)
end

function convertUnixToJulian(unixSeconds)
	return ( unixSeconds / 86400.0 ) + 2440587.5;
end
