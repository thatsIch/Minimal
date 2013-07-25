[meterNote]
Meter = String
MeasureName = MeasureNoteReader
W = #NoteWidth#
H = (#NoteHeight# - 20)
X = 0r
Y = 0R
SolidColor = 00000001
FontColor = FFFFFF
LeftMouseUpAction = [#@#Scripts\Notes\notepad.exe "#CURRENTPATH#note.txt" "#PROGRAMPATH#Rainmeter.exe !UpdateMeasure MeasureNoteReader"]
ClipString = 1