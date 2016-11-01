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
      print("test")
      local timesection = getTimeSectionByCount(SolarMidnight, AstronomicalDawn, Now, 12)
      if timesection == 0 then 
         SKIN:Bang('!SetWallpaper "backgrounds\\solar_mightnight.jpg" Fill')
      else 
         SKIN:Bang('!SetWallpaper "backgrounds\\night_end' .. timesection .. '.jpg" Fill')
      end

   -- single section
   elseif AstronomicalDawn <= Now and Now < NauticalDawn then
      SKIN:Bang('!SetWallpaper "backgrounds\\astronomical_dawn.jpg" Fill')

      -- single section
   elseif NauticalDawn <= Now and Now < CivilDawn then
      SKIN:Bang('!SetWallpaper "backgrounds\\nautical_dawn.jpg" Fill')  

   -- single section
   elseif CivilDawn <= Now and Now < SunriseTime then
      SKIN:Bang('!SetWallpaper "backgrounds\\civil_dawn.jpg" Fill') 

   -- special starter image with sections
   elseif SunriseTime <= Now and Now < SolarNoonTime then
      local timesection = getTimeSectionByCount(SunriseTime, SolarNoonTime, Now, 15)
      if timesection == 0 then 
         SKIN:Bang('!SetWallpaper "backgrounds\\sunrise.jpg" Fill')
      else 
         SKIN:Bang('!SetWallpaper "backgrounds\\day_start' .. timesection .. '.jpg" Fill')
      end

   -- special starter image with sections
   elseif SolarNoonTime <= Now and Now < SunsetTime then
      local timesection = getTimeSectionByCount(SolarNoonTime, SunsetTime, Now, 15)
      if timesection == 0 then 
         SKIN:Bang('!SetWallpaper "backgrounds\\solar_noon.jpg" Fill')
      else 
         SKIN:Bang('!SetWallpaper "backgrounds\\day_end' .. timesection .. '.jpg" Fill')
      end

   -- single section 
   elseif SunsetTime <= Now and Now < CivilDusk then
      SKIN:Bang('!SetWallpaper "backgrounds\\sunset.jpg" Fill')  

   -- single section
   elseif CivilDusk <= Now and Now < NauticalDusk then
      SKIN:Bang('!SetWallpaper "backgrounds\\civil_dusk.jpg" Fill')  

   -- single section
   elseif NauticalDusk <= Now and Now < AstronomicalDusk then
      SKIN:Bang('!SetWallpaper "backgrounds\\nautical_dusk.jpg" Fill')  

   elseif AstronomicalDusk <= Now or Now < SolarMidnight then
      local timesection = getTimeSectionByCount(AstronomicalDusk, SolarMidnight, Now, 12)
      if timesection == 0 then 
         SKIN:Bang('!SetWallpaper "backgrounds\\astronomical_dusk.jpg" Fill')
      else 
         SKIN:Bang('!SetWallpaper "backgrounds\\night_start' .. timesection .. '.jpg" Fill')
      end

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

-- Compute the difference in seconds between local time and UTC.
function getTimeZoneOffsetInSeconds()
  local now = os.time()
  return os.difftime(now, os.time(os.date("!*t", now)))
end

function getTimeSectionByCount(startInstant, endInstant, currentInstant, count)
   assert(startInstant <= currentInstant)
   assert(currentInstant <= endInstant)
   assert(count > 0)

   local diff = endInstant - startInstant
   local sectionWidth = diff / count
   local offset = currentInstant - startInstant
   local timesection = math.floor(offset / sectionWidth)

   return timesection
end