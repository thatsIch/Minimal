; ==================================================
; Background Style
; ==================================================
; Center
[styleFeedReaderBackground]
W = #FeedreaderBackgroundWidth#
H = #FeedreaderBackgroundHeight#
X = #FeedreaderBackgroundCornerRadius#
Y = #FeedreaderBackgroundCornerRadius#
SolidColor = #FeedreaderBackgroundColor#

; Edge
[styleFeedReaderBackgroundEdge]
SolidColor = #FeedreaderBackgroundColor#

; Corner
[styleFeedReaderBackgroundCorner]
RotationAngle = (PI/2)
SolidColor = 00000000
W = (2*#FeedreaderBackgroundCornerRadius#)
H = (2*#FeedreaderBackgroundCornerRadius#)
Solid = 1
LineColor = #FeedreaderBackgroundColor#
LineLength = (#FeedreaderBackgroundCornerRadius#)
LineWidth = 1
AntiAlias = 1

; specific edge settings 
; ==================================================
[styleFeedReaderBackgroundEdgeTop]
W = #FeedreaderBackgroundWidth#
H = #FeedreaderBackgroundCornerRadius#
X = #FeedreaderBackgroundCornerRadius#
Y = 0

[styleFeedReaderBackgroundEdgeBottom]
W = #FeedreaderBackgroundWidth#
H = #FeedreaderBackgroundCornerRadius#
X = #FeedreaderBackgroundCornerRadius#
Y = (#FeedreaderBackgroundHeight# + #FeedreaderBackgroundCornerRadius#)

[styleFeedReaderBackgroundEdgeLeft]
W = #FeedreaderBackgroundCornerRadius#
H = #FeedreaderBackgroundHeight#
X = 0
Y = #FeedreaderBackgroundCornerRadius#

[styleFeedReaderBackgroundEdgeRight]
W = #FeedreaderBackgroundCornerRadius#
H = #FeedreaderBackgroundHeight#
X = (#FeedreaderBackgroundWidth# + #FeedreaderBackgroundCornerRadius#)
Y = #FeedreaderBackgroundCornerRadius#

; specific corner settings
; ==================================================
[styleFeedReaderBackgroundCornerTopLeft]
StartAngle = (pi)
X = 0
Y = 0

[styleFeedReaderBackgroundCornerTopRight]
StartAngle = (3/2*pi)
X = (#FeedreaderBackgroundWidth#)
Y = 0

[styleFeedReaderBackgroundCornerBottomLeft]
StartAngle = (pi/2)
X = 0
Y = (#FeedreaderBackgroundHeight#)

[styleFeedReaderBackgroundCornerBottomRight]
StartAngle = (0)
X = (#FeedreaderBackgroundWidth#)
Y = (#FeedreaderBackgroundHeight#)




; ==================================================
; Forground Style
; ==================================================
; Center
[styleFeedReaderForeground]
W = #FeedreaderForegroundWidth#
H = #FeedreaderForegroundHeight#
X = #FeedreaderBackgroundCornerRadius#
Y = #FeedreaderBackgroundCornerRadius#
SolidColor = #FeedreaderForegroundColor#

; Edge
[styleFeedReaderForegroundEdge]
SolidColor = #FeedreaderForgroundColor#

; Corner
[styleFeedReaderForegroundCorner]
RotationAngle = (PI/2)
SolidColor = 00000000
W = (2*#FeedreaderForegroundCornerRadius#)
H = (2*#FeedreaderForegroundCornerRadius#)
Solid = 1
LineColor = #FeedreaderForegroundColor#
LineLength = (#FeedreaderForegroundCornerRadius#)
LineWidth = 1
AntiAlias = 1

; specific edge settings 
; ==================================================
[styleFeedReaderForegroundEdgeTop]
W = #FeedreaderBackgroundWidth#
H = #FeedreaderForegroundCornerRadius#
X = #FeedreaderBackgroundCornerRadius#
Y = #FeedreaderForegroundCornerRadius#

[styleFeedReaderForegroundEdgeBottom]
W = #FeedreaderBackgroundWidth#
H = #FeedreaderForegroundCornerRadius#
X = #FeedreaderBackgroundCornerRadius#
Y = (#FeedreaderBackgroundHeight# + #FeedreaderBackgroundCornerRadius#)

[styleFeedReaderForegroundEdgeLeft]
W = #FeedreaderForegroundCornerRadius#
H = #FeedreaderBackgroundHeight#
X = #FeedreaderForegroundCornerRadius#
Y = #FeedreaderBackgroundCornerRadius#

[styleFeedReaderForegroundEdgeRight]
W = #FeedreaderForegroundCornerRadius#
H = #FeedreaderBackgroundHeight#
X = (#FeedreaderBackgroundWidth# + #FeedreaderBackgroundCornerRadius#)
Y = #FeedreaderBackgroundCornerRadius#

; specific corner settings
; ==================================================
[styleFeedReaderForegroundCornerTopLeft]
StartAngle = (pi)
X = #FeedreaderForegroundOffset#
Y = #FeedreaderForegroundOffset#

[styleFeedReaderForegroundCornerTopRight]
StartAngle = (3/2*pi)
X = (#FeedreaderBackgroundWidth# + #FeedreaderForegroundOffset#)
Y = #FeedreaderForegroundOffset#

[styleFeedReaderForegroundCornerBottomLeft]
StartAngle = (pi/2)
X = #FeedreaderForegroundOffset#
Y = (#FeedreaderBackgroundHeight# + #FeedreaderForegroundOffset#)

[styleFeedReaderForegroundCornerBottomRight]
StartAngle = (0)
X = (#FeedreaderBackgroundWidth# + #FeedreaderForegroundOffset#)
Y = (#FeedreaderBackgroundHeight# + #FeedreaderForegroundOffset#)



; ==================================================
; Seperator Style
; ==================================================
[styleFeedReaderNaviContentSeperator]
SolidColor = #FeedReaderNaviContentSeperatorColor#
W = #FeedReaderNaviContentSeperatorWidth#
H = #FeedReaderNaviContentSeperatorHeight#
X = (#FeedReaderNaviContentSeperatorOffset# + #FeedreaderBackgroundCornerRadius#)
Y = #FeedreaderBackgroundCornerRadius#



; ==================================================
; Search Style
; ==================================================
; Seperator
[styleFeedReaderNaviSearchSeperator]
X = (#FeedreaderBackgroundCornerRadius#)
Y = 39
W = (#FeedReaderNaviContentSeperatorOffset#)
H = 2
SolidColor = 666666

; Field
[styleFeedReaderNaviSearchField]
Text = Search...
X = 14
Y = 14
W = (#FeedReaderNaviContentSeperatorOffset# - 5)
H = 16
SolidColor = FFFFFF
AntiAlias = 1

; Icon
[styleFeedReaderNaviSearchButtonBackground]
X = 281
Y = #FeedreaderBackgroundCornerRadius#
W = 24
H = 24
SolidColor = 666666

[styleFeedReaderNaviSearchButton]
ImageName = #@#Images\FeedReader\Search.ico
X = (4)r
Y = (4)r
W = 16
H = 16
SolidColor = 00000001
AntiAlias = 1
ColorMatrix1=-1;0;0;0;0
ColorMatrix2=0;-1;0;0;0
ColorMatrix3=0;0;-1;0;0
ColorMatrix5=1;1;1;0;1


; ==================================================
; Entry Style
; ==================================================
; Row
[styleFeedReaderEntryDummyRow1]
Y = (5 + #EntryPadding# + 0 * (#EntryHeight# + #EntryPadding#))

[styleFeedReaderEntryDummyRow2]
Y = (5 + #EntryPadding# + 1 * (#EntryHeight# + #EntryPadding#))

[styleFeedReaderEntryDummyRow3]
Y = (5 + #EntryPadding# + 2 * (#EntryHeight# + #EntryPadding#))

[styleFeedReaderEntryDummyRow4]
Y = (5 + #EntryPadding# + 3 * (#EntryHeight# + #EntryPadding#))

; Col
[styleFeedReaderEntryDummyCol1]
X = (#FeedReaderNaviContentSeperatorOffset# + #FeedreaderBackgroundCornerRadius# + #EntryPadding#)

[styleFeedReaderEntryDummyCol2]
X = (312 + 33 + 255 + 33)

[styleFeedReaderEntryDummyCol3]
X = (312 + 33 + 255 + 33 + 255 + 33)

; Elements
[styleFeedReaderEntryDummy]
W = 0
H = 0

[styleFeedReaderEntryDescription]
W = #EntryWidth#
H = 140
X = 0r
Y = 0r
AntiAlias = 1
ClipString = 2
FontColor = 333333
Text = Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.

[styleFeedReaderEntryImage]
W = #EntryWidth#
H = #EntryHeight#
X = 0r
Y = (0)r
SolidColor = 999999
PreserveAspectRatio = 2

[styleFeedReaderEntryTitle]
W = #EntryWidth#
H = 40
X = 0r
Y = 103r
SolidColor = 00000066
FontColor = FFFFFF
AntiAlias = 1
FontSize = 14
StringStyle = Bold
ClipString = 2
Text = Muffin Cake Bakery Station