[mSearchInputText]
Measure = Plugin
Plugin = InputText
UpdateDivider = -1
FocusDismiss = 1
AntiAlias = 1
FontSize = 10
SolidColor = #ColorHighDefault#
X = ([sSearchField:X] + 5)
Y = ([sSearchField:Y] + 4)
W = ([sSearchField:W] - 5)
H = ([sSearchField:H] - 4)
Command1 = [!CommandMeasure "mParseScript" "searchInDatabase('$UserInput$')" "#CURRENTCONFIG#"]