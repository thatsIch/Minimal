[MeasureCPU]
Measure = CPU
Processor = 0

[MeterCPUIcon]
Meter = Image
X = -20 + 0r
Y = 0r
W = 16
H = 16
ImageName = #@#Images\Taskbar\CPU.ico
;ImageTint = ([MeasureCPU]*2.55),(255-[MeasureCPU]*2.55),0
ImageTint = (0.25*[MeasureCPU]),(255-0.93*[MeasureCPU]),(2.22*[MeasureCPU])
ToolTipText = [MeasureCPU]% CPU Auslastung
DynamicVariables = 1
