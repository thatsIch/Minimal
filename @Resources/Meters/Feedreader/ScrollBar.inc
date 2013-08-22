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
LeftMouseUpAction = [!CommandMeasure "mParser" "shiftCategory(-30)" "#CURRENTCONFIG#"]

; Area
[iScrollBarTopAnchor]
Meter = Image
MeterStyle = yScrollBarTopAnchor

[iScrollbarBarArea]
Meter = Image
MeterStyle = yScrollBarArea

[iScrollBarBotAnchor]
Meter = Image
MeterStyle = yScrollBarBotAnchor

[iScrollbarBarAreaBG]
Meter = Image
MeterStyle = yScrollBarAreaBG
MouseScrollUpAction = [!CommandMeasure "mParser" "shiftCategory(-1)" "#CURRENTCONFIG#"]
MouseScrollDownAction = [!CommandMeasure "mParser" "shiftCategory(1)" "#CURRENTCONFIG#"]

; Down
[sScrollbarArrowDown]
Meter = String
MeterStyle = yScrollBarArrows | yScrollDownArrow
LeftMouseUpAction = [!CommandMeasure "mParser" "shiftCategory(30)" "#CURRENTCONFIG#"]
