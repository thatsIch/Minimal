function Initialize()
   AstronomicalDawnMeasure = SKIN:GetMeasure('AstronomicalTwilightBeginTime')
   NauticalDawnMeasure = SKIN:GetMeasure('NauticalTwilightBeginTime')
   CivilDawnMeasure = SKIN:GetMeasure('CivilTwilightBeginTime')
   SunriseTimeMeasure = SKIN:GetMeasure('SunriseTime')
   SolarNoonTimeMeasure = SKIN:GetMeasure('SolarNoonTime')
   SunsetTimeMeasure = SKIN:GetMeasure('SunsetTime')
   CivilDuskMeasure = SKIN:GetMeasure('CivilTwilightEndTime')
   NauticalDuskMeasure = SKIN:GetMeasure('NauticalTwilightEndTime')
   AstronomicalDuskMeasure = SKIN:GetMeasure('AstronomicalTwilightEndTime')
   NowMeasure = SKIN:GetMeasure('Now')
end

function Update()
   local TimeTable = {}

   TimeTable.Now = parseDateStringToInstant(NowMeasure:GetStringValue())
   -- debug line to shift time manually
   -- TimeTable.Now = TimeTable.Now + 3600 * 17

   -- transposeToNextDayOnNewDay handles when now is a new day but no internet connection is there to update the measures
   TimeTable.AstronomicalDawn = transposeToNextDayOnNewDay(parseDateStringToInstant(AstronomicalDawnMeasure:GetStringValue()), TimeTable.Now)
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

   -- special starter image with sections
   if TimeTable.SolarMidnight <= TimeTable.Now and TimeTable.Now < TimeTable.AstronomicalDawn then
      setWallpaperByTimeSectionWithStartImage(TimeTable.SolarMidnight, TimeTable.AstronomicalDawn, TimeTable.Now, 12, "solar_mightnight", "night_end")

   -- special handle case when new day comes
   elseif TimeTable.SolarMidnight <= TimeTable.Now and TimeTable.Now < TimeTable.NextAstronomicalDawn then
      setWallpaperByTimeSectionWithStartImage(TimeTable.SolarMidnight, TimeTable.NextAstronomicalDawn, TimeTable.Now, 12, "solar_mightnight", "night_end")      

   -- special handle case when new day came and all normal times are shifted
   -- now > 00:00, every timestamp > now
   elseif TimeTable.LastSolarMidnight <= TimeTable.Now and TimeTable.Now < TimeTable.AstronomicalDawn then
      setWallpaperByTimeSectionWithStartImage(TimeTable.LastSolarMidnight, TimeTable.AstronomicalDawn, TimeTable.Now, 12, "solar_mightnight", "night_end")      

   -- single section
   elseif TimeTable.AstronomicalDawn <= TimeTable.Now and TimeTable.Now < TimeTable.NauticalDawn then
      setWallpaper("astronomical_dawn")

      -- single section
   elseif TimeTable.NauticalDawn <= TimeTable.Now and TimeTable.Now < TimeTable.CivilDawn then
      setWallpaper("nautical_dawn")

   -- single section
   elseif TimeTable.CivilDawn <= TimeTable.Now and TimeTable.Now < TimeTable.Sunrise then
      setWallpaper("civil_dawn")

   -- special starter image with sections
   elseif TimeTable.Sunrise <= TimeTable.Now and TimeTable.Now < TimeTable.SolarNoon then
      setWallpaperByTimeSectionWithStartImage(TimeTable.Sunrise, TimeTable.SolarNoon, TimeTable.Now, 15, "sunrise", "day_start")

   -- special starter image with sections
   elseif TimeTable.SolarNoon <= TimeTable.Now and TimeTable.Now < TimeTable.Sunset then
      setWallpaperByTimeSectionWithStartImage(TimeTable.SolarNoon, TimeTable.Sunset, TimeTable.Now, 15, "solar_noon", "day_end")

   -- single section 
   elseif TimeTable.Sunset <= TimeTable.Now and TimeTable.Now < TimeTable.CivilDusk then
      setWallpaper("sunset")

   -- single section
   elseif TimeTable.CivilDusk <= TimeTable.Now and TimeTable.Now < TimeTable.NauticalDusk then
      setWallpaper("civil_dusk")

   -- single section
   elseif TimeTable.NauticalDusk <= TimeTable.Now and TimeTable.Now < TimeTable.AstronomicalDusk then
      setWallpaper("nautical_dusk")

   -- case if solar midnight is before 00:00
   elseif TimeTable.AstronomicalDusk <= TimeTable.Now and TimeTable.Now < TimeTable.SolarMidnight then
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
   --    local s = '{ '
   --    for k,v in pairs(o) do
   --       if type(k) ~= 'number' then k = '"'..k..'"' end
   --       s = s .. '['..k..'] = ' .. dump(v) .. ','
   --    end
   --    return s .. '} '
   -- else
   --    return tostring(o)
   -- end
end

function setWallpaperByTimeSectionWithStartImage(startInstant, endInstant, currentInstant, sectionCount, initial, cont)
   local timesection = getTimeSectionByCount(startInstant, endInstant, currentInstant, sectionCount)
   if timesection == 0 then 
      setWallpaper(initial)
   else 
      setWallpaper(cont .. timesection)
   end
end

function setWallpaper(imageName)
   SKIN:Bang('!SetWallpaper "backgrounds\\'.. imageName .. '.jpg" Fill')
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

   return os.time(tablerized)
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