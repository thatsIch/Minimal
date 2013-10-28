[MeasureBin]
Measure = Plugin
Plugin = RecycleManager
RecycleType = Count
OnChangeAction = [!UpdateMeter "mIcon" "#CURRENTCONFIG#"] [!Redraw "#CURRENTCONFIG#"]

[mBinSize]
Measure = Plugin
Plugin = RecycleManager
RecycleType = Size
OnChangeAction = [!UpdateMeasure "mBinSizeMB" "#CURRENTCONFIG#"]

[mBinSizeMB]
Measure = Calc
Formula = round([mBinSize:] / 1024 / 1024)
DynamicVariables = 1
OnChangeAction = [!UpdateMeter "mIcon" "#CURRENTCONFIG#"] [!Redraw "#CURRENTCONFIG#"]

[MeasureBinAction]
Measure = Calc
Formula = MeasureBin
IfAboveValue = 0
IfAboveAction = [!SetOption "mIcon" "ImageName" "#@#Images\Dock\binfull.ico"] [!UpdateMeter "mIcon" "#CURRENTCONFIG#"] [!Redraw "#CURRENTCONFIG#"]
IfEqualValue = 0
IfEqualAction = [!SetOption "mIcon" "ImageName" "#@#Images\Dock\binempty.ico"] [!UpdateMeter "mIcon" "#CURRENTCONFIG#"] [!Redraw "#CURRENTCONFIG#"]
