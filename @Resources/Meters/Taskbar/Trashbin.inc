[MeasureBin]
Measure = Plugin
Plugin = RecycleManager
RecycleType = Count
;UpdateDivider = 10

[MeasureBinAction]
Measure = Calc
Formula = MeasureBin
IfAboveValue = 0
IfAboveAction = [!SetOption "MeterBinIcon" "ImageName" "#@#Images\Taskbar\binfull.ico"]
IfEqualValue = 0
IfEqualAction = [!SetOption "MeterBinIcon" "ImageName" "#@#Images\Taskbar\binempty.ico"]

[MeterBinIcon]
Meter = Image
RightMouseDownAction = [!CommandMeasure "MeasureBin" "EmptyBin"] [!UpdateMeasure "MeasureBinAction"]
LeftMouseUpAction = [::{645FF040-5081-101B-9F08-00AA002F954E}]
X = -20 + 0r
Y = 0r
W = 16
H = 16