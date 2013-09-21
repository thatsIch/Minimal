; Date
; ==================================================
[sDateDefault]
X = (0 + 0)R
Y = 5
FontSize = #FontSizeMedium#
FontFace = #FontFamily#
FontColor = #Transparent#
AntiAlias = 1
Text = "."
UpdateDivider = -1

[sDate]
X = (0 + 0)R
Y = 5
FontSize = #FontSizeMedium#
FontFace = #FontFamily#
FontColor = #FontColorLow#
AntiAlias = 1
UpdateDivider = -1

[sDateToday]
X = (0 + 0)R
Y = 5
FontSize = #FontSizeMedium#
FontFace = #FontFamily#
FontColor = FFFFFF
StringEffect = Border
FontEffectColor = #BarColor1#
AntiAlias = 1
UpdateDivider = -1

[sDateTomorrow]
X = (0 + 0)R
Y = 5
FontSize = #FontSizeMedium#
FontFace = #FontFamily#
FontColor = FFFFFF
StringEffect = Border
FontEffectColor = #BarColor2#
AntiAlias = 1
UpdateDivider = -1

; Seperator
; ==================================================
[sSeperator]
MeasureName = mDownloadProgress
Group = gDownloadProgress
X = 0r
Y = 0R
W = #DayWidth#
H = 3
BarColor = #BarColorHigh#
SolidColor = #SeperatorColor#
BarOrientation = Horizontal
Flip = 1

[sDummy] 
X = (0 + #DaySpacing#)r
Y = 0R
UpdateDivider = -1

; Elements
; ========
[sEBar]
X = (0 - 7)r
Y = (0 + 15)r
W = 3
H = 12
UpdateDivider = -1

[sEInfo]
X = (0 + 4)R
Y = (0 - 1)r
W = #DayWidth#
H = 16
FontSize = #FontSizeMedium#
FontFace = #FontFamily#
FontColor = #FontColorHigh#
SolidColor = #Transparent#
AntiAlias = 1
ClipString = 1
UpdateDivider = -1