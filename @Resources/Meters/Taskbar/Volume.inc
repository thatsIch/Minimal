[measureVolume]
Measure = Plugin
Plugin = Win7AudioPlugin

[measureVolumePercentage]
Measure = Calc
Formula = measureVolume

[measureVolumeScript]
Measure = Script
ScriptFile = #@#Scripts\Taskbar\Volume.lua
UpdateDivider = -1

[meterImageVolume]
Meter = Image
MeterStyle = styleImageVolume
X = -120 + 0R
ToolTipText = [measureVolumePercentage]%
