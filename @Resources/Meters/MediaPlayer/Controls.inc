[sPrev]
Meter = String
MeterStyle = yControl | yPrev
LeftMouseUpAction = [!CommandMeasure "mPlayer" "Previous"] [!UpdateMeterGroup "UpdateMeterGroupPlayer"] [!Redraw]

[sPlay]
Meter = String
MeterStyle = yControl | yPlay
Group = UpdateMeterGroupPlayer
LeftMouseUpAction = [!CommandMeasure "mPlayer" "PlayPause"] [!HideMeter #CURRENTSECTION#] [!ShowMeter sPause] [!UpdateMeterGroup "UpdateMeterGroupPlayer"] [!Redraw]
Hidden = (([mPlayerState] * [mPlayerStatus]) % 2)
DynamicVariables = 1

[sPause]
Meter = String
MeterStyle = yControl | yPause
Group = UpdateMeterGroupPlayer
LeftMouseUpAction = [!CommandMeasure "mPlayer" "Pause"] [!HideMeter #CURRENTSECTION#] [!ShowMeter sPlay] [!UpdateMeterGroup "UpdateMeterGroupPlayer"] [!Redraw]
Hidden = ((([mPlayerState] * [mPlayerStatus]) + 1) % 2)
DynamicVariables = 1

[sStop]
Meter = String
MeterStyle = yControl | yStop
LeftMouseUpAction = [!CommandMeasure "mPlayer" "Stop"] [!HideMeter "sPause"] [!ShowMeter "sPlay"] [!UpdateMeterGroup "UpdateMeterGroupPlayer"] [!Redraw]

[sNext]
Meter = String
MeterStyle = yControl | yNext
LeftMouseUpAction = [!CommandMeasure "mPlayer" "Next"] [!UpdateMeterGroup "UpdateMeterGroupPlayer"] [!Redraw]