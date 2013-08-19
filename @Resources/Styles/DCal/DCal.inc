; Loader
; ==================================================
[yLoader]
X = 0
Y = 5
W = 0
H = 3
SolidColor = #BarColorHigh#

[yLoaderBG]
X = 0
Y = 5
W = #SCREENAREAWIDTH#
H = 3
SolidColor = #BarColorLow#


; Date
; ==================================================
[sDate]
X = (0 + 0)R
Y = 5
FontSize = #FontSizeMedium#
FontFace = #FontFamily#
FontColor = #FontColorLow#
AntiAlias = 1

; Seperator
; ==================================================
[sSeperator]
X = 0r
Y = 0R
W = #DayWidth#
H = 3
SolidColor = #SeperatorColor#

[sDummy] 
X = (0 + 9)r
Y = 0R

; Elements
; ========
[sEBar]
X = (0 - 7)r
Y = (0 + 15)r
W = 3
H = 12

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