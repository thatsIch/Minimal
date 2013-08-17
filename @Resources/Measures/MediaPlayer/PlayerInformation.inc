; whole player information through NowPlaying Plugin
[mPlayer]
Measure = Plugin
Plugin = NowPlaying
PlayerName = CAD
PlayerType = Title
TrackChangeAction = [!UpdateMeasureGroup "UpdateMeasureGroupPlayer"]
OnChangeAction = [!UpdateMeasureGroup "UpdateMeasureGroupPlayer"]

[mArtistTitle]
Measure = Plugin
Plugin = NowPlaying
Group = UpdateMeasureGroupPlayer
PlayerName = [mPlayer]
PlayerType = Artist
Substitute = "":"[mFileName]","[mArtistTitle]":"[mArtistTitle] - [mTitle]"
DynamicVariables = 1
Disabled = 1

[mTitle]
Measure = Plugin
Plugin = NowPlaying
Group = UpdateMeasureGroupPlayer
PlayerName = [mPlayer]
PlayerType = Title
Disabled = 1

; parse the filename out of path \filename.mp3
[mFileName]
Measure = Plugin
Plugin = NowPlaying
Group = UpdateMeasureGroupPlayer
PlayerName = [mPlayer]
PlayerType = File
RegExpSubstitute = 1
Substitute = ".*\\(.*)\..*":"\1"
Disabled = 1

[mProgress]
Measure = Plugin
Plugin = NowPlaying
PlayerName = [mPlayer]
PlayerType = Progress