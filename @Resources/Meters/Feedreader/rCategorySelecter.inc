; Field
[sCategorySelectorText]
Meter = String
MeterStyle = yCategorySelectorText

; Button
[iCategorySelectorButton]
Meter = Image
MeterStyle = yCategorySelectorButton

; Invis Element to catch events
[iCategorySelector]
Meter = Image
MeterStyle = yCategorySelector
MouseOverAction = [!SetOption "sCategorySelectorText" "SolidColor" "#ColorHighHover#" "#CURRENTCONFIG#"] [!UpdateMeter "sCategorySelectorText" "#CURRENTCONFIG#"] [!SetOption "iCategorySelectorButton" "SolidColor" "#ColorMediumHover#" "#CURRENTCONFIG#"] [!UpdateMeter "iCategorySelectorButton" "#CURRENTCONFIG#"] [!Redraw "#CURRENTCONFIG#"]
MouseLeaveAction = [!SetOption "sCategorySelectorText" "SolidColor" "#ColorHighDefault#" "#CURRENTCONFIG#"] [!UpdateMeter "sCategorySelectorText" "#CURRENTCONFIG#"] [!SetOption "iCategorySelectorButton" "SolidColor" "#ColorMediumDefault#" "#CURRENTCONFIG#"] [!UpdateMeter "iCategorySelectorButton" "#CURRENTCONFIG#"] [!Redraw "#CURRENTCONFIG#"]
LeftMouseDownAction = [!SetOption "sCategorySelectorText" "SolidColor" "#ColorHighClick#" "#CURRENTCONFIG#"] [!UpdateMeter "sCategorySelectorText" "#CURRENTCONFIG#"] [!SetOption "iCategorySelectorButton" "SolidColor" "#ColorMediumClick#" "#CURRENTCONFIG#"] [!UpdateMeter "iCategorySelectorButton" "#CURRENTCONFIG#"] [!Redraw "#CURRENTCONFIG#"]
LeftMouseUpAction = [!SetOption "sCategorySelectorText" "SolidColor" "#ColorHighDefault#" "#CURRENTCONFIG#"] [!UpdateMeter "sCategorySelectorText" "#CURRENTCONFIG#"] [!SetOption "iCategorySelectorButton" "SolidColor" "#ColorMediumDefault#" "#CURRENTCONFIG#"] [!UpdateMeter "iCategorySelectorButton" "#CURRENTCONFIG#"] [!ToggleMeterGroup "DropDown" "#CURRENTCONFIG#"] [!UpdateMeterGroup "DropDown" "#CURRENTCONFIG#"] [!Redraw "#CURRENTCONFIG#"]
