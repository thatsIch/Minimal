; ==================================================
; ScrollBar
;
; indicating how many feeds are in that category
; and enables you to scroll within
; ==================================================
; Up
[sScrollbarArrowUp]
Meter = String
MeterStyle = yScrollBarArrows | yScrollUpArrow
LeftMouseUpAction = [!CommandMeasure "mParser" "shiftOnePageInCategory(-1)" "#CURRENTCONFIG#"]

; Area
[iScrollBarTopAnchor]
Meter = Image
MeterStyle = yScrollBarTopAnchor

[iScrollbarBarArea]
Meter = Image
MeterStyle = yScrollBarArea

[iScrollbarBarAreaBG]
Meter = Image
MeterStyle = yScrollBarAreaBG
MouseScrollUpAction = [!CommandMeasure "mParser" "shiftCategory(-1)" "#CURRENTCONFIG#"]
MouseScrollDownAction = [!CommandMeasure "mParser" "shiftCategory(1)" "#CURRENTCONFIG#"]
MouseOverAction = [!SetOption "iScrollbarBarArea" "SolidColor" "#ColorMediumHover#" "#CURRENTCONFIG#"] [!UpdateMeter "iScrollbarBarArea" "#CURRENTCONFIG#"] [!Redraw "#CURRENTCONFIG#"]
MouseLeaveAction = [!SetOption "iScrollbarBarArea" "SolidColor" "#ColorMediumDefault#" "#CURRENTCONFIG#"] [!UpdateMeter "iScrollbarBarArea" "#CURRENTCONFIG#"] [!Redraw "#CURRENTCONFIG#"]

[iScrollBarBotAnchor]
Meter = Image
MeterStyle = yScrollBarBotAnchor

; Down
[sScrollbarArrowDown]
Meter = String
MeterStyle = yScrollBarArrows | yScrollDownArrow
LeftMouseUpAction = [!CommandMeasure "mParser" "shiftOnePageInCategory(1)" "#CURRENTCONFIG#"]
