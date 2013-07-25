[MeasureRAM]
Measure = PhysicalMemory
UpdateDivider = 10

[MeasureTotalRAM]
Measure = PhysicalMemory
UpdateDivider = -1
Total = 1

[MeasureRAMCalc]
Measure = Calc
Formula = ceil(MeasureRAM/MeasureTotalRAM*100)
UpdateDivider = 10

[MeterRAMIcon]
Meter = Image
X = -20 + 0r
Y = 0r
W = 16
H = 16
ImageName = #@#Images\Taskbar\RAM.ico
ImageTint = (0.25*[MeasureRAMCalc]),(255-0.93*[MeasureRAMCalc]),(2.22*[MeasureRAMCalc])
ToolTipText = [MeasureRAMCalc]% RAM Auslastung
DynamicVariables = 1
