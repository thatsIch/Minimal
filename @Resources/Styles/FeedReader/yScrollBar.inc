[yScrollUpArrow]
Y = (5 * #NavigationPadding# + 2 * #ButtonSize# + 4 * #ButtonPadding# + #SeperatorWeight#)
Padding = -2, -5, 2, 6
Text = "5"

[yScrollBarTopAnchor]
X = 0r
Y = 0R
UpdateDivider = -1

[yScrollBarArea]
X = 0r
Y = 0R
W = (#ButtonSize# / 2)
H = 0
AntiAlias = 1
SolidColor = #ColorMediumDefault#
UpdateDivider = -1

[yScrollBarAreaBG]
X = 0r
Y = [iScrollBarTopAnchor:Y]
W = (#ButtonSize# / 2)
H = (#Rows# * (#EntryHeight# + #EntryPadding#) + 2 * #BarWeight# + 3 * #EntryPadding# - 7 * #NavigationPadding# - 2 * #ButtonSize# - 4 * #ButtonPadding# - #SeperatorWeight# - 8)
SolidColor = #Transparent#
AntiAlias = 1
UpdateDivider = -1

[yScrollBarBotAnchor]
X = 0r
Y = 0R
UpdateDivider = -1

[yScrollDownArrow]
X = 0r
Y = 0R
Padding = -2, -1, 2, 2
Text = "6"

[yScrollBarArrows]
W = (#ButtonSize# / 2)
H = (#ButtonSize# / 2)
X = (#NavigationWidth# + 2 * #NavigationPadding# + #ButtonSize#)
FontFace = Webdings
FontColor = #ColorMediumDefault#
SolidColor = #Transparent#
AntiAlias = 1
UpdateDivider = -1