[MeasureDownload]
Measure = NetIn
MaxValue = 787500

[MeasureDownloadCalc]
Measure = Calc
Formula = ceil(MeasureDownload/787500*100)
UpdateDivider = 10

[MeterDownloadIcon]
Meter = Image
X = -20 + 0r
Y = 0r
W = 16
H = 16
ImageName = #@#Images\Taskbar\updn.ico
LeftMouseUpAction = ["D:\Data\Downloads"]
ImageTint = (0.25*[MeasureDownloadCalc]),(255-0.93*[MeasureDownloadCalc]),(2.22*[MeasureDownloadCalc])
ToolTipText = [MeasureDownloadCalc]% Download Auslastung
DynamicVariables = 1