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
   local AstronomicalDawn = parseDateStringToInstant(AstronomicalDawnMeasure:GetStringValue())
   local NauticalDawn = parseDateStringToInstant(NauticalDawnMeasure:GetStringValue())
   local CivilDawn = parseDateStringToInstant(CivilDawnMeasure:GetStringValue())
   local SunriseTime = parseDateStringToInstant(SunriseTimeMeasure:GetStringValue())
   local SolarNoonTime = parseDateStringToInstant(SolarNoonTimeMeasure:GetStringValue())
   local SunsetTime = parseDateStringToInstant(SunsetTimeMeasure:GetStringValue())
   local CivilDusk = parseDateStringToInstant(CivilDuskMeasure:GetStringValue())
   local NauticalDusk = parseDateStringToInstant(NauticalDuskMeasure:GetStringValue())
   local AstronomicalDusk = parseDateStringToInstant(AstronomicalDuskMeasure:GetStringValue())
   local SolarMidnight = (incrementDay(AstronomicalDawn) + AstronomicalDusk) / 2

   local Now = parseDateStringToInstant(NowMeasure:GetStringValue())

   -- special starter image with sections
   if SolarMidnight <= Now and Now <= AstronomicalDawn then
      setWallpaperByTimeSectionWithStartImage(SolarMidnight, AstronomicalDawn, Now, 12, "solar_mightnight", "night_end")

   -- single section
   elseif AstronomicalDawn <= Now and Now < NauticalDawn then
      setWallpaper("astronomical_dawn")

      -- single section
   elseif NauticalDawn <= Now and Now < CivilDawn then
      setWallpaper("nautical_dawn")

   -- single section
   elseif CivilDawn <= Now and Now < SunriseTime then
      setWallpaper("civil_dawn")

   -- special starter image with sections
   elseif SunriseTime <= Now and Now < SolarNoonTime then
      setWallpaperByTimeSectionWithStartImage(SunriseTime, SolarNoonTime, Now, 15, "sunrise", "day_start")

   -- special starter image with sections
   elseif SolarNoonTime <= Now and Now < SunsetTime then
      setWallpaperByTimeSectionWithStartImage(SolarNoonTime, SunsetTime, Now, 15, "solar_noon", "day_end")

   -- single section 
   elseif SunsetTime <= Now and Now < CivilDusk then
      setWallpaper("sunset")

   -- single section
   elseif CivilDusk <= Now and Now < NauticalDusk then
      setWallpaper("civil_dusk")

   -- single section
   elseif NauticalDusk <= Now and Now < AstronomicalDusk then
      setWallpaper("nautical_dusk")

   elseif AstronomicalDusk <= Now or Now < SolarMidnight then
      setWallpaperByTimeSectionWithStartImage(AstronomicalDusk, SolarMidnight, Now, 12, "astronomical_dusk", "night_start")
   end
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

-- Compute the difference in seconds between local time and UTC.
function getTimeZoneOffsetInSeconds()
  local now = os.time()
  return os.difftime(now, os.time(os.date("!*t", now)))
end

function getTimeSectionByCount(startInstant, endInstant, currentInstant, count)
   if not (startInstant <= currentInstant) then print("start instant '"..startInstant.."' is not before current instant '"..currentInstant.."'.")
   if not (currentInstant <= endInstant) then print("current instant '" .. currentInstant .. "' is not before end instant '" .. endInstant .. "'.")
   if not (count > 0) then print("count is not greater than zero with '" .. count .. "'.")

   local diff = endInstant - startInstant
   local sectionWidth = diff / count
   local offset = currentInstant - startInstant
   local timesection = math.floor(offset / sectionWidth)

   return timesection
end