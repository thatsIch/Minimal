; Field
[ySearchField]
Text = Search...
X = 0r
Y = 0r
W = #NavigationWidth#
H = (#ButtonSize# + 2 * #ButtonPadding#)
Padding = 5,4,-5,-4
ClipString = 1
SolidColor = #ColorHighDefault#
AntiAlias = 1
UpdateDivider = -1

[ySearchButton]
ImageName = #@#Images\FeedReader\Search.ico
X = 0R
Y = 0r
W = #ButtonSize#
H = #ButtonSize#
Padding = #ButtonPadding#,#ButtonPadding#,#ButtonPadding#,#ButtonPadding#
SolidColor = #ColorMediumDefault#
ColorMatrix1 = -1;0;0;0;0
ColorMatrix2 = 0;-1;0;0;0
ColorMatrix3 = 0;0;-1;0;0
ColorMatrix5 = 1;1;1;0;1
AntiAlias = 1
UpdateDivider = -1

[ySearch]
X = (0 - #NavigationWidth#)r
Y = 0r
W = (#NavigationWidth# + #ButtonSize# + 2 * #ButtonPadding#)
H = (#ButtonSize# + 2 * #ButtonPadding#)
UpdateDivider = -1

; Seperator
[ySearchSeperator]
X = (2 * #NavigationPadding#)
Y = (#NavigationPadding#)R
W = (#NavigationWidth# + #ButtonSize# + 2 * #ButtonPadding# + #NavigationPadding#)
H = #SeperatorWeight#
SolidColor = #ColorMediumDefault#
UpdateDivider = -1
