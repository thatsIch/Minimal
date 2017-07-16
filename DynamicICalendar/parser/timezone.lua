-- example timezone
-- requires rrule to the calculation for DST
-- requires offset to calculate the hourly offset of the timezones
-- 
-- BEGIN:VTIMEZONE
-- TZID:Europe/Berlin
-- X-LIC-LOCATION:Europe/Berlin
-- BEGIN:DAYLIGHT
-- TZOFFSETFROM:+0100
-- TZOFFSETTO:+0200
-- TZNAME:CEST
-- DTSTART:19700329T020000
-- RRULE:FREQ=YEARLY;BYMONTH=3;BYDAY=-1SU
-- END:DAYLIGHT
-- BEGIN:STANDARD
-- TZOFFSETFROM:+0200
-- TZOFFSETTO:+0100
-- TZNAME:CET
-- DTSTART:19701025T030000
-- RRULE:FREQ=YEARLY;BYMONTH=10;BYDAY=-1SU
-- END:STANDARD
-- END:VTIMEZONE

local exports = {}

local libspath = SKIN:GetVariable('CURRENTPATH').."parser\\" 
local rrulepath = libspath .. "rrule.lua"
local rrule = dofile(rrulepath)


return exports