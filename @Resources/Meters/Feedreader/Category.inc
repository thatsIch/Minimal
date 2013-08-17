; ==================================================
; Category
;
; lets you select a specific category
; ==================================================
; Field
[meterFeedReaderCatorySelectorBackground]
Meter = Image
W = 295
H = 24
X = 10
Y = 46
SolidColor = EEEEEE
 
[meterFeedReaderCategorySelectorText]
Meter = String
W = 200
H = 16
X = 14
Y = 50
AntiAlias = 1
Text = Category
 
[meterFeedReaderCategorySelectorIconBackground]
Meter = Image
W = 24
H = 24
X = 281
Y = 46
SolidColor = 666666
 
[meterFeedReaderCategorySelectorIcon]
Meter = Image
ImageName = #@#Images\FeedReader\down.ico
W = 16
H = 16
X = 285
Y = 51
SolidColor = 00000001
AntiAlias = 1
ColorMatrix1=-1;0;0;0;0
ColorMatrix2=0;-1;0;0;0
ColorMatrix3=0;0;-1;0;0
ColorMatrix5=1;1;1;0;1
LeftMouseUpAction = [!ToggleMeterGroup "FeedReaderDropDown"] [!Update]
LeftMouseDownAction = [!SetOption "meterFeedReaderCategorySelectorIconBackground" "SolidColor" "AAAAAA"] [!UpdateMeter "meterFeedReaderCategorySelectorIconBackground"] [!Redraw]
MouseOverAction = [!SetOption "meterFeedReaderCategorySelectorIconBackground" "SolidColor" "444444"] [!UpdateMeter "meterFeedReaderCategorySelectorIconBackground"] [!Redraw]
MouseLeaveAction = [!SetOption "meterFeedReaderCategorySelectorIconBackground" "SolidColor" "666666"] [!UpdateMeter "meterFeedReaderCategorySelectorIconBackground"] [!Redraw]
 
[meterFeedReaderCategorySelectorDropdown1]
Meter = String
Group = FeedReaderDropDown
Text = Category 1
W = 295
H = 24
X = 10
Y = 83
SolidColor = EEEEEE
AntiAlias = 1
StringAlign = LeftCenter
Hidden = 1

[meterFeedReaderCategorySelectorDropdown2]
Meter = String
Group = FeedReaderDropDown
Text = Category 2
W = 295
H = 24
X = 10
Y = 108
SolidColor = EEEEEE
AntiAlias = 1
StringAlign = LeftCenter
Hidden = 1