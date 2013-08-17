[MeasureTotalRAM]
Measure = PhysicalMemory
UpdateDivider = -1
Total = 1

[MeasureRAMCalc]
Measure = Calc
Formula = ceil(MeasureRAM/MeasureTotalRAM*100)