[yDropdownDummy]
X = (2 * #NavigationPadding#)
Y = ([iCategorySelector:Y] + [iCategorySelector:H])
UpdateDivider = -1

[yCategorySelectorDropdown]
Group = DropDown
X = (2 * #NavigationPadding#)
Y = 0R
W = (#NavigationWidth#)
H = (#ButtonSize# + 2 * #ButtonPadding#)
Padding = 5,4,-5,-4
SolidColor = #ColorHighDefault#
AntiAlias = 1
Hidden = 1
UpdateDivider = -1
MouseOverAction = [!SetOption "#CURRENTSECTION#" "SolidColor" "#ColorHighHover#" "#CURRENTCONFIG#"] [!UpdateMeter "#CURRENTSECTION#" "#CURRENTCONFIG#"] [!Redraw "#CURRENTCONFIG#"]
MouseLeaveAction = [!SetOption "#CURRENTSECTION#" "SolidColor" "#ColorHighDefault#" "#CURRENTCONFIG#"] [!UpdateMeter "#CURRENTSECTION#" "#CURRENTCONFIG#"] [!Redraw "#CURRENTCONFIG#"]
LeftMouseUpAction = [!SetOption "#CURRENTSECTION#" "SolidColor" "#ColorHighDefault#" "#CURRENTCONFIG#"] [!UpdateMeter "#CURRENTSECTION#" "#CURRENTCONFIG#"] [!Redraw "#CURRENTCONFIG#"]
LeftMouseDownAction = [!SetOption "#CURRENTSECTION#" "SolidColor" "#ColorHighClick#" "#CURRENTCONFIG#"] [!UpdateMeter "#CURRENTSECTION#" "#CURRENTCONFIG#"] [!Redraw "#CURRENTCONFIG#"]