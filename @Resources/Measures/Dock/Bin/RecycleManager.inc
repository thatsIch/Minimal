[MeasureBin]
Measure = Plugin
Plugin = RecycleManager
RecycleType = Count
OnChangeAction = [!UpdateMeter "mIcon" "#CURRENTCONFIG#"] [!Redraw "#CURRENTCONFIG#"]

[MeasureBinAction]
Measure = Calc
Formula = MeasureBin
IfAboveValue = 0
IfAboveAction = [!SetOption "mIcon" "ImageName" "#@#Images\Dock\binfull.ico"] [!UpdateMeter "mIcon" "#CURRENTCONFIG#"] [!Redraw "#CURRENTCONFIG#"]
IfEqualValue = 0
IfEqualAction = [!SetOption "mIcon" "ImageName" "#@#Images\Dock\binempty.ico"] [!UpdateMeter "mIcon" "#CURRENTCONFIG#"] [!Redraw "#CURRENTCONFIG#"]
