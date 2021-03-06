; Top
; ==================================================
[yBackgroundTL]
StartAngle = (pi)
X = #NavigationPadding#
Y = #NavigationPadding#

[yBackgroundT]
W = (#NavigationWidth# + #ButtonSize# + 2 * #ButtonPadding# + #SeperatorWeight# + #EntryPadding# + #Cols# * (#EntryPadding# + #EntryWidth#) )
H = #NavigationPadding#
X = (2 * #NavigationPadding#)
Y = #NavigationPadding#

[yBackgroundTR]
StartAngle = (3/2*pi)
X = (0 - #NavigationPadding#)R
Y = #NavigationPadding#

; Center
; ==================================================
[yBackgroundL]
W = #NavigationPadding#
H = (#rows# * (#EntryHeight# + #EntryPadding#) + 2 * #BarWeight# + #EntryPadding# + 2 * (#EntryPadding# - #NavigationPadding#))
X = #NavigationPadding#
Y = (2 * #NavigationPadding#)

[yBackground]
W = (#NavigationWidth# + #ButtonSize# + 2 * #ButtonPadding# + #SeperatorWeight# + #EntryPadding# + #Cols# * (#EntryPadding# + #EntryWidth#) )
H = (#rows# * (#EntryHeight# + #EntryPadding#) + 2 * #BarWeight# + #EntryPadding# + 2 * (#EntryPadding# - #NavigationPadding#))
X = 0R
Y = 0r
SolidColor = #OpaqueWhite#
UpdateDivider = -1

[yBackgroundR]
W = #NavigationPadding#
H = (#rows# * (#EntryHeight# + #EntryPadding#) + 2 * #BarWeight# + #EntryPadding# + 2 * (#EntryPadding# - #NavigationPadding#))
X = 0R
Y = 0r

; Bottom
; ==================================================
[yBackgroundBL]
StartAngle = (pi/2)
X = #NavigationPadding#
Y = (0 - #NavigationPadding#)R

[yBackgroundB]
W = (#NavigationWidth# + #ButtonSize# + 2 * #ButtonPadding# + #SeperatorWeight# + #EntryPadding# + #Cols# * (#EntryPadding# + #EntryWidth#) )
H = #NavigationPadding#
X = (2 * #NavigationPadding#)
Y = (#NavigationPadding#)r

[yBackgroundBR]
StartAngle = (0)
X = (0 - #NavigationPadding#)R
Y = (0 - #NavigationPadding#)r


; ==================================================
; Edge
; ==================================================
[yBackgroundEdge]
SolidColor = #OpaqueWhite#
UpdateDivider = -1

; Corner
[yBackgroundCorner]
RotationAngle = (PI/2)
SolidColor = #Transparent#
W = (2*#NavigationPadding#)
H = (2*#NavigationPadding#)
Solid = 1
LineColor = #OpaqueWhite#
LineLength = (#NavigationPadding#)
LineWidth = 1
AntiAlias = 1
UpdateDivider = -1