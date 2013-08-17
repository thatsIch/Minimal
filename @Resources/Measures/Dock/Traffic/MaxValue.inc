[MeasureDownload]
Measure = NetIn
MaxValue = #MaxValue#

[MeasureDownloadCalc]
Measure = Calc
Formula = ceil(MeasureDownload/#MaxValue#*100)