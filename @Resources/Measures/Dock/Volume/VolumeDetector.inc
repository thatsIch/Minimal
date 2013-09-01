[measureVolume]
Measure = Plugin
Plugin = Win7AudioPlugin

[measureVolumePercentage]
Measure = Calc
Formula = measureVolume
OnChangeAction = [!UpdateMeasure "measureVolumeScript" "#CURRENTCONFIG#"] [!UpdateMeter "mIcon" "#CURRENTCONFIG#"] [!Redraw "#CURRENTCONFIG#"]