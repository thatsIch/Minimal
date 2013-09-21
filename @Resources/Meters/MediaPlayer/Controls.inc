[sPrev]
Meter = String
MeterStyle = yControl | yPrev
LeftMouseUpAction = [!CommandMeasure "mPlayer" "Previous"]
UpdateDivider = -1

[sPlay]
Meter = String
MeterStyle = yControl | yPlay
Group = StateSubscriber | StatusSubscriber
LeftMouseUpAction = [!CommandMeasure "mPlayer" "Play"] [!HideMeter #CURRENTSECTION#] [!ShowMeter sPause] [!Redraw "#CURRENTCONFIG#"]
Hidden = (([mPlayerState] * [mPlayerStatus]) % 2)
DynamicVariables = 1
UpdateDivider = -1

[sPause]
Meter = String
MeterStyle = yControl | yPause
Group = StateSubscriber | StatusSubscriber
LeftMouseUpAction = [!CommandMeasure "mPlayer" "PlayPause"] [!HideMeter #CURRENTSECTION#] [!ShowMeter sPlay] [!Redraw "#CURRENTCONFIG#"]
Hidden = ((([mPlayerState] * [mPlayerStatus]) + 1) % 2)
DynamicVariables = 1
UpdateDivider = -1

[sStop]
Meter = String
MeterStyle = yControl | yStop
LeftMouseUpAction = [!CommandMeasure "mPlayer" "Stop"] [!HideMeter "sPause"] [!ShowMeter "sPlay"] [!Redraw "#CURRENTCONFIG#"]
UpdateDivider = -1

[sNext]
Meter = String
MeterStyle = yControl | yNext
LeftMouseUpAction = [!CommandMeasure "mPlayer" "Next"]
UpdateDivider = -1