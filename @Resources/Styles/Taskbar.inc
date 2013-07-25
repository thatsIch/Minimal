[styleTaskbarBackground]
ImageName = #@#Images\Taskbar\Background.png
ImageAlpha = 100
W = #SCREENAREAWIDTH#
H = 45

[styleImageVolume]
AntiAlias = 1
X = 0r
Y = 4
W = 16
H = 16
LeftMouseUpAction = [!CommandMeasure "measureVolume" "ToggleMute"] [!UpdateMeasure "measureVolume"] [!UpdateMeasure "measureVolumeScript"] [!Update]
MouseScrollDownAction = [!CommandMeasure "measureVolume" "ChangeVolume -10"] [!CommandMeasure "measureVolumeScript" "Update()"] [!Update]
MouseScrollUpAction = [!CommandMeasure "measureVolume" "ChangeVolume 10"] [!CommandMeasure "measureVolumeScript" "Update()"] [!Update]