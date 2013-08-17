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

[mPlayerState]
Measure = Plugin
Plugin = NowPlaying
PlayerName = [mPlayer]
PlayerType = State
UpdateRate = -1