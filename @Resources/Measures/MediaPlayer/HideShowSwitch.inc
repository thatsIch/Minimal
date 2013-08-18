; Hides whole player if MusicPlayer is not active
[mPlayerStatus]
Measure = Plugin
Plugin = NowPlaying
PlayerName = [mPlayer]
PlayerType = Status
IfEqualValue = 0
IfEqualAction = [!HideFade]
IfAboveValue = 0
IfAboveAction = [!ShowFade]
OnChangeAction = [!UpdateMeterGroup "StatusSubscriber" "#CURRENTCONFIG#"] [!Redraw "#CURRENTCONFIG#"]

[mPlayerState]
Measure = Plugin
Plugin = NowPlaying
PlayerName = [mPlayer]
PlayerType = State
Group = UpdateMeasureGroupPlayer
UpdateRate = -1
OnChangeAction = [!UpdateMeterGroup "StateSubscriber" "#CURRENTCONFIG#"] [!Redraw "#CURRENTCONFIG#"] [!Log [mPlayerState]]