; Edge
[yBorderEdge]
SolidColor = #OpaqueWhite#30
UpdateDivider = -1

; Corner
[yBorderCorner]
RotationAngle = (PI/2)
W = (4 * #NavigationPadding#)
H = (4 * #NavigationPadding#)
Solid = 1
LineColor = #OpaqueWhite#30
LineLength = (2 * #NavigationPadding#)
LineWidth = 1
AntiAlias = 1
UpdateDivider = -1

; ============================================
; Top
[yBorderTL]
StartAngle = (pi)
X = 0
Y = 0

[yBorderT]
W = (#NavigationWidth# + #ButtonSize# + 2 * #ButtonPadding# + #SeperatorWeight# + #EntryPadding# + #Cols# * (#EntryPadding# + #EntryWidth#) )
H = (2 * #NavigationPadding#)
X = (2 * #NavigationPadding#)
Y = 0

[yBorderTR]
StartAngle = (3/2*pi)
X = (0 - 2 * #NavigationPadding#)R
Y = 0

; Center
[yBorderL]
W = (2 * #NavigationPadding#)
H = (#rows# * (#EntryHeight# + #EntryPadding#) + 2 * #BarWeight# + #EntryPadding# + 2 * (#EntryPadding# - #NavigationPadding#))
X = 0
Y = (2 * #NavigationPadding#)

[yBorderR]
W = (2 * #NavigationPadding#)
H = (#rows# * (#EntryHeight# + #EntryPadding#) + 2 * #BarWeight# + #EntryPadding# + 2 * (#EntryPadding# - #NavigationPadding#))
X = (#NavigationWidth# + #ButtonSize# + 2 * #ButtonPadding# + #SeperatorWeight# + 2 * #EntryPadding# + #Cols# * (#EntryPadding# + #EntryWidth#) )
Y = (2 * #NavigationPadding#)

; Bottom
[yBorderBL]
StartAngle = (pi/2)
X = 0
Y = (0 - 2 * #NavigationPadding#)R

[yBorderB]
W = (#NavigationWidth# + #ButtonSize# + 2 * #ButtonPadding# + #SeperatorWeight# + #EntryPadding# + #Cols# * (#EntryPadding# + #EntryWidth#) )
H = (2 * #NavigationPadding#)
X = (2 * #NavigationPadding#)
Y = (2 * #NavigationPadding#)r

[yBorderBR]
StartAngle = (0)
X = (0 - 2 * #NavigationPadding#)R
Y = (0 - 2 * #NavigationPadding#)r
