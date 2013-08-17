; Style Control Element
[yControl]
X = 0R
Y = 0r
FontFace = Webdings
FontColor = #IconNormalColor#
FontSize = 14
SolidColor = 00000001
MouseOverAction = [!SetOption "#CURRENTSECTION#" "FontColor" "#IconHoverCover#"] [!UpdateMeter "#CURRENTSECTION#"] [!Redraw]
MouseLeaveAction = [!SetOption "#CURRENTSECTION#" "FontColor" "#IconNormalColor#"] [!UpdateMeter "#CURRENTSECTION#"] [!Redraw]

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