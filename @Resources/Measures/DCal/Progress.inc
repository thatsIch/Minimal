[mDownloadProgress]
Measure = Calc
Formula = 0
MinValue = 0
MaxValue = 1
UpdateDivider = -1
OnUpdateAction = [!SetOption "#CURRENTSECTION#" "Formula" "[#CURRENTSECTION#] - 1]" "#CURRENTCONFIG#"]
OnChangeAction = [!UpdateMeterGroup "gDownloadProgress" "#CURRENTCONFIG#"] [!Redraw "#CURRENTCONFIG#"]