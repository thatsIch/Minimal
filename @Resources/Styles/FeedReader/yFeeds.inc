[yFeedItemDummy]
X = 0r
Y = 0R
UpdateDivider = -1

[yFeedItem]
X = 0r
Y = 0R
W = (#NavigationWidth#)
H = (#ButtonSize# + 2 * #ButtonPadding#)
Padding = 5, 4, -5, -4
FontColor = #ColorLowDefault#
SolidColor = #Transparent#
AntiAlias = 1
UpdateDivider = -1
MouseOverAction = [!SetOption "#CURRENTSECTION#" "FontColor" "#ColorLowHover#" "#CURRENTCONFIG#"] [!UpdateMeter "#CURRENTSECTION#" "#CURRENTCONFIG#"] [!Redraw "#CURRENTCONFIG#"]
MouseLeaveAction = [!SetOption "#CURRENTSECTION#" "FontColor" "#ColorLowDefault#" "#CURRENTCONFIG#"] [!UpdateMeter "#CURRENTSECTION#" "#CURRENTCONFIG#"] [!Redraw "#CURRENTCONFIG#"]
LeftMouseDownAction = [!SetOption "#CURRENTSECTION#" "FontColor" "#ColorLowClick#" "#CURRENTCONFIG#"] [!UpdateMeter "#CURRENTSECTION#" "#CURRENTCONFIG#"] [!Redraw "#CURRENTCONFIG#"]
LeftMouseUpAction = [!SetOption "#CURRENTSECTION#" "FontColor" "#ColorLowDefault#" "#CURRENTCONFIG#"] [!UpdateMeter "#CURRENTSECTION#" "#CURRENTCONFIG#"] [!Redraw "#CURRENTCONFIG#"]
MouseScrollUpAction = [!CommandMeasure "mParseScript" "shiftCategory(-3)" "#CURRENTCONFIG#"]
MouseScrollDownAction = [!CommandMeasure "mParseScript" "shiftCategory(3)" "#CURRENTCONFIG#"]