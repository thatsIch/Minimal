[MeasureBin]
Measure = Plugin
Plugin = RecycleManager
RecycleType = Count

[MeasureBinAction]
Measure = Calc
Formula = MeasureBin
IfAboveValue = 0
IfAboveAction = [!SetOption "mIcon" "ImageName" "#@#Images\Dock\binfull.ico"]
IfEqualValue = 0
IfEqualAction = [!SetOption "mIcon" "ImageName" "#@#Images\Dock\binempty.ico"]
