; Background
; ==================================================
; Style Icon
[sIcon]
W = 32
H = 32
UpdateDivider = -1
SolidColor = 00000001
AntiAlias = 1

[sIconRSS]
ImageName = #@#Images\Dock\RSS.ico
LeftMouseUpAction = [!ActivateConfig "Minimal\Feedreader" "Feedreader.ini"]

[sIconNotes]
ImageName = #@#Images\Dock\Note.ico
LeftMouseUpAction = [!CommandMeasure "mAppNoteAdder" "Activate()"]

[sIconWork]
ImageName = #@#Images\Dock\Work.ico
LeftMouseUpAction = [%WORK_DIR%]

[sIconGames]
ImageName = #@#Images\Dock\Games.ico
LeftMouseUpAction = [%FUN_DIR%]

[sIconFoobar]
ImageName = #@#Images\Dock\Foobar.ico
LeftMouseUpAction = [!CommandMeasure "mPlayer" "OpenPlayer"]
RightMouseUpAction = [!CommandMeasure "mPlayer" "ClosePlayer"]

[sIconCPU]
ImageName = #@#Images\Dock\CPU.ico
ImageTint = (0.25*[MeasureCPU]),(255-0.93*[MeasureCPU]),(2.22*[MeasureCPU])
ToolTipText = [MeasureCPU]% CPU Auslastung
DynamicVariables = 1
MouseOverAction = [!UpdateMeasure "MeasureCPU"] [!UpdateMeter "mIcon"] [!Redraw]
UpdateDivider = 1

[sIconRAM]
ImageName = #@#Images\Dock\RAM.ico
ImageTint = (0.25*[MeasureRAMCalc]),(255-0.93*[MeasureRAMCalc]),(2.22*[MeasureRAMCalc])
ToolTipText = [MeasureRAMCalc]% RAM Auslastung
DynamicVariables = 1
MouseOverAction = [!UpdateMeasure "MeasureRAM"] [!UpdateMeasure "MeasureRAMCalc"] [!UpdateMeter "mIcon"] [!Redraw]
UpdateDivider = 1

[sIconTraffic]
ImageName = #@#Images\Dock\Traffic.ico
LeftMouseUpAction = ["H:\Data\Downloads"]
ImageTint = (0.25*[MeasureDownloadCalc]),(255-0.93*[MeasureDownloadCalc]),(2.22*[MeasureDownloadCalc])
ToolTipText = [MeasureDownloadCalc]% Download Auslastung
DynamicVariables = 1
MouseOverAction = [!UpdateMeasure "MeasureDownload"] [!UpdateMeasure "MeasureDownloadCalc"] [!UpdateMeter "mIcon"] [!Redraw]
UpdateDivider = 1

[sIconBin]
RightMouseDownAction = [!CommandMeasure "MeasureBin" "EmptyBinSilent"] [!Update]
LeftMouseUpAction = [::{645FF040-5081-101B-9F08-00AA002F954E}]
ToolTipText = [MeasureBin] Datei(en)
UpdateDivider = 1

[sIconVolume]
LeftMouseUpAction = [!CommandMeasure "measureVolume" "ToggleMute"] [!UpdateMeasure "measureVolume"] [!UpdateMeasure "measureVolumeScript"] [!UpdateMeasure "measureVolumePercentage"] [!UpdateMeter "mIcon"] [!Redraw]
MouseScrollDownAction = [!CommandMeasure "measureVolume" "ChangeVolume -10"] [!UpdateMeasure "measureVolume"] [!UpdateMeasure "measureVolumeScript"] [!UpdateMeasure "measureVolumePercentage"] [!UpdateMeter "mIcon"] [!Redraw]
MouseScrollUpAction = [!CommandMeasure "measureVolume" "ChangeVolume 10"] [!UpdateMeasure "measureVolume"] [!UpdateMeasure "measureVolumeScript"] [!UpdateMeasure "measureVolumePercentage"] [!UpdateMeter "mIcon"] [!Redraw]
ToolTipText = [measureVolumePercentage]%
UpdateDivider = 1