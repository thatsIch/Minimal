[Variables]
NoteHeight = 240
NoteWidth = 320

; Background
[Background]
Meter = Image
ImageName = ..\Template\Abstraction\Background.png
ImageAlpha = 100
W = #NoteWidth#
H = #NoteHeight#
UpdateRate = -1

; Foreground
[Note]
Meter = String

W = #NoteWidth#
H = #NoteHeight#
X = 0r
Y = 0r
SolidColor = 00000001
FontColor = FFFFFF
ClipString = 1
UpdateRate = -1
FontFace=Segoe UI
AntiAlias=1

MeasureName = NoteReader
LeftMouseUpAction = [#CURRENTPATH#..\Template\Abstraction\notepad.exe "#CURRENTPATH#note.txt" "#PROGRAMPATH#Rainmeter.exe !CommandMeasure NoteReader Update #CURRENTCONFIG#"]

; ContentReader
[NoteReader]
Measure = Plugin
Plugin = WebParser
URL = file://#CURRENTPATH#note.txt
RegExp = "(?si)(.*)"
StringIndex = 0
UpdateRate = -1
ForceReload = 1
FinishAction = [!UpdateMeter "Note"] [!Redraw]
