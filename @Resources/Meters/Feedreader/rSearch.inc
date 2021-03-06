; ==================================================
; Search
;
; enables you to search within your feeds 
; after certain things
; ==================================================
; Search Field
[sSearchField]
Meter = String
MeterStyle = ySearchField

; Icon
[sSearchButton]
Meter = Image
MeterStyle = ySearchButton

; Invis Elem to catch events
[iSearch]
Meter = Image
MeterStyle = ySearch
MouseOverAction = [!SetOption "sSearchField" "SolidColor" "#ColorHighHover#" "#CURRENTCONFIG#"] [!UpdateMeter "sSearchField" "#CURRENTCONFIG#"] [!SetOption "sSearchButton" "SolidColor" "#ColorMediumHover#" "#CURRENTCONFIG#"] [!UpdateMeter "sSearchButton" "#CURRENTCONFIG#"] [!Redraw "#CURRENTCONFIG#"]
MouseLeaveAction = [!SetOption "sSearchField" "SolidColor" "#ColorHighDefault#" "#CURRENTCONFIG#"] [!UpdateMeter "sSearchField" "#CURRENTCONFIG#"] [!SetOption "sSearchButton" "SolidColor" "#ColorMediumDefault#" "#CURRENTCONFIG#"] [!UpdateMeter "sSearchButton" "#CURRENTCONFIG#"] [!Redraw "#CURRENTCONFIG#"]
LeftMouseDownAction = [!SetOption "sSearchField" "SolidColor" "#ColorHighClick#" "#CURRENTCONFIG#"] [!UpdateMeter "sSearchField" "#CURRENTCONFIG#"] [!SetOption "sSearchButton" "SolidColor" "#ColorMediumClick#" "#CURRENTCONFIG#"] [!UpdateMeter "sSearchButton" "#CURRENTCONFIG#"] [!Redraw "#CURRENTCONFIG#"]
LeftMouseUpAction = [!SetOption "sSearchField" "SolidColor" "#ColorHighDefault#" "#CURRENTCONFIG#"] [!UpdateMeter "sSearchField" "#CURRENTCONFIG#"] [!SetOption "sSearchButton" "SolidColor" "#ColorMediumDefault#" "#CURRENTCONFIG#"] [!UpdateMeter "sSearchButton" "#CURRENTCONFIG#"] [!CommandMeasure "mSearchInputText" "ExecuteBatch 1" "#CURRENTCONFIG#"] [!UpdateMeasure "mSearchInputText" "#CURRENTCONFIG#"]  [!Redraw "#CURRENTCONFIG#"]


; Seperator
[sSearchSeperator]
Meter = Image
MeterStyle = ySearchSeperator