[meterDay2Date]
Meter = String
MeterStyle = styleGcalDate
Text = Mittwoch, 09. Jan

[meterDay2BarDummy]
Meter = Image
MeterStyle = styleGcalBar
X = 0r
Y = 0r
SolidColor = 00000000

[meterDay2EventDummy]
Meter = String
MeterStyle = styleGcalDesc
Text = ""

[meterDay2Bar1]
Meter = Image
MeterStyle = styleGcalBar

[meterDay2Event1]
Meter = String
MeterStyle = styleGcalDesc

[meterDay2Bar2]
Meter = Image
MeterStyle = styleGcalBar

[meterDay2Event2]
Meter = String
MeterStyle = styleGcalDesc

[meterDay2Bar3]
Meter = Image
MeterStyle = styleGcalBar

[meterDay2Event3]
Meter = String
MeterStyle = styleGcalDesc

[meterDay2Bar4]
Meter = Image
MeterStyle = styleGcalBar

[meterDay2Event4]
Meter = String
MeterStyle = styleGcalDesc

[meterDay2DummyReset]
Meter = Image
X = ([meterDay1Date:X] + 250)
Y = [meterDay2Date:Y]
DynamicVariables = 1
;[meterDay2MoreEvents]
;Meter = String
;MeterStyle = styleGcalMoreEvents