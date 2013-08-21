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
LeftMouseUpAction = [!CommandMeasure "mParser" "shiftCategory(-1)" "#CURRENTCONFIG#"]

; Down
[sScrollbarArrowDown]
Meter = String
MeterStyle = yScrollBarArrows | yScrollDownArrow
LeftMouseUpAction = [!CommandMeasure "mParser" "shiftCategory(1)" "#CURRENTCONFIG#"]

; Area
[iScrollbarBarArea]
Meter = Image
MeterStyle = yScrollBarArea