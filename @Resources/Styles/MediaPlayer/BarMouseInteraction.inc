; Style Bar Dummy
[yBarDummy]
X = 0r
Y = (-2)r

; Style Bar
[yBarMouseInteraction]
X = 0R
Y = 0r
W = (#SCREENAREAWIDTH#/100)
H = 9
SolidColor = 00000001
LeftMouseDownAction = [!CommandMeasure "mBarMouseInteraction" "LeftDownAction()"]
LeftMouseUpAction = [!CommandMeasure "mBarMouseInteraction" "LeftUpAction('#CURRENTSECTION#')"]
MouseOverAction = [!CommandMeasure "mBarMouseInteraction" "OverAction('#CURRENTSECTION#')"]
;Comment in for Volume interaction
;RightMouseDownAction = [!CommandMeasure "mBarMouseInteraction" "RightDownAction()"]
;RightMouseUpAction = [!CommandMeasure "mBarMouseInteraction" "RightUpAction('#CURRENTSECTION#')"]