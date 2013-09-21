; whole player information through NowPlaying Plugin
[mPlayer]
Measure = Plugin
Plugin = NowPlaying
PlayerName = #MediaPlayer#
PlayerType = Title
TrackChangeAction = [!UpdateMeasureGroup "UpdateMeasureGroupPlayer" "#CURRENTCONFIG#"]

[mArtistTitle]
Measure = Plugin
Plugin = NowPlaying
PlayerName = [mPlayer]
PlayerType = Artist
Group = UpdateMeasureGroupPlayer
DynamicVariables = 1
Substitute = "":"[mFileName]","[mArtistTitle]":"[mArtistTitle] - [mTitle]"
OnChangeAction = [!UpdateMeterGroup "ArtistSubscriber" "#CURRENTCONFIG#"]
Disabled = 1

[mTitle]
Measure = Plugin
Plugin = NowPlaying
PlayerName = [mPlayer]
PlayerType = Title
Group = UpdateMeasureGroupPlayer
Disabled = 1

; parse the filename out of path \filename.mp3
[mFileName]
Measure = Plugin
Plugin = NowPlaying
PlayerName = [mPlayer]
PlayerType = File
Group = UpdateMeasureGroupPlayer
Substitute = ".*\\(.*)\..*":"\1"
RegExpSubstitute = 1
Disabled = 1

; Calculate progress on own, since NowPlaying results in integer
[mDuration]
Measure = Plugin
Plugin = NowPlaying
Group = UpdateMeasureGroupPlayer
PlayerName = [mPlayer]
PlayerType = Duration
UpdateDivider = -1
OnChangeAction = [!UpdateMeasure "mProgress" "#CURRENTCONFIG#"]

[mPosition]
Measure = Plugin
Plugin = NowPlaying
Group = UpdateMeasureGroupPlayer
PlayerName = [mPlayer]
PlayerType = Position
OnChangeAction = [!UpdateMeasure "mProgress" "#CURRENTCONFIG#"]

[mProgress]
Measure = Calc
Formula = [mPosition:] / [mDuration:]
DynamicVariables = 1
UpdateDivider = -1
OnChangeAction = [!UpdateMeter "bBar" "#CURRENTCONFIG#"] [!Redraw "#CURRENTCONFIG#"]
