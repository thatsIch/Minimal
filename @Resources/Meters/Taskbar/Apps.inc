[styleAppIcon]
X = 10R
Y = 5
AntiAlias = 1

[meterAppRSS]
Meter = Image
MeterStyle = styleAppIcon
ImageName = #@#Images\Taskbar\rss.png
X = 10
Y = 7
W = 12
H = 12
LeftMouseUpAction = [!ActivateConfig "Minimal\Feedreader" "Feedreader.ini"]

[Variables]
Minimal\Notes\Note1=inactive
Minimal\Notes\Note2=inactive
Minimal\Notes\Note3=inactive
Minimal\Notes\Note4=inactive
Minimal\Notes\Note5=inactive

[MeasureAppNoteAdder]
Measure = Script
ScriptFile = #@#Scripts\Taskbar\Notes.lua
UpdateDivider = -1

[meterAppNote]
Meter = Image
MeterStyle = styleAppIcon
ImageName = #@#Images\Taskbar\note.png
LeftMouseUpAction = [!UpdateMeasure "MeasureAppNoteAdder"] [!CommandMeasure "MeasureAppNoteAdder" "Activate()"] [!Refresh]
