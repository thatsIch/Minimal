; Style Control Element
[yControl]
X = 0R
Y = 0r
FontFace = Webdings
FontColor = FFFFFF
FontSize = 14
SolidColor = 00000001
MouseOverAction = [!SetOption "#CURRENTSECTION#" "FontColor" "FF8800"] [!UpdateMeter "#CURRENTSECTION#"] [!Redraw]
MouseLeaveAction = [!SetOption "#CURRENTSECTION#" "FontColor" "FFFFFF"] [!UpdateMeter "#CURRENTSECTION#"] [!Redraw]

; Style Previous Control
[yPrev]
Text = "7"

[yPlay]
Text = "4"

[yPause]
Text = ";"
Hidden = 1

[yStop]
Text = "<"

[yNext]
Text = "8"