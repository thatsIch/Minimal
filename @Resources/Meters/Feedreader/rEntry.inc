; ==================================================
; Entry
;
; Displays all Entries of selected feed
; ==================================================
; Entry 1
[sEntryDesc1]
Meter = String
MeterStyle = yEntryDescription | yEntry

[iEntryImage1]
Meter = Image
MeasureName = mEntryImageDownloader1
MeterStyle = yEntryImage | yEntry

[sEntryTitle1]
Meter = String
MeterStyle = yEntryTitle | yEntry

[mEntryImageDownloader1]
Measure = Plugin
Plugin = WebParser
Disabled = 1
UpdateRate = -1
Download = 1
FinishAction = [!UpdateMeasure "mImageDownloadProgress" "#CURRENTCONFIG#"] [!UpdateMeter "iEntryImage1" "#CURRENTCONFIG#"] [!Redraw "#CURRENTCONFIG#"]


; Entry 2
[sEntryDesc2]
Meter = String
MeterStyle = yEntryDescription | yEntry

[iEntryImage2]
Meter = Image
MeasureName = mEntryImageDownloader2
MeterStyle = yEntryImage | yEntry

[sEntryTitle2]
Meter = String
MeterStyle = yEntryTitle | yEntry

[mEntryImageDownloader2]
Measure = Plugin
Plugin = WebParser
Disabled = 1
UpdateRate = -1
Download = 1
FinishAction = [!UpdateMeasure "mImageDownloadProgress" "#CURRENTCONFIG#"] [!UpdateMeter "iEntryImage2" "#CURRENTCONFIG#"] [!Redraw "#CURRENTCONFIG#"]


; Entry 3
[sEntryDesc3]
Meter = String
MeterStyle = yEntryDescription | yEntry

[iEntryImage3]
Meter = Image
MeasureName = mEntryImageDownloader3
MeterStyle = yEntryImage | yEntry

[sEntryTitle3]
Meter = String
MeterStyle = yEntryTitle | yEntry

[mEntryImageDownloader3]
Measure = Plugin
Plugin = WebParser
Disabled = 1
UpdateRate = -1
Download = 1
FinishAction = [!UpdateMeasure "mImageDownloadProgress" "#CURRENTCONFIG#"] [!UpdateMeter "iEntryImage3" "#CURRENTCONFIG#"] [!Redraw "#CURRENTCONFIG#"]


; Entry 4
[sEntryDesc4]
Meter = String
MeterStyle = yEntryDescription | yEntry

[iEntryImage4]
Meter = Image
MeasureName = mEntryImageDownloader4
MeterStyle = yEntryImage | yEntry

[sEntryTitle4]
Meter = String
MeterStyle = yEntryTitle | yEntry

[mEntryImageDownloader4]
Measure = Plugin
Plugin = WebParser
Disabled = 1
UpdateRate = -1
Download = 1
FinishAction = [!UpdateMeasure "mImageDownloadProgress" "#CURRENTCONFIG#"] [!UpdateMeter "iEntryImage4" "#CURRENTCONFIG#"] [!Redraw "#CURRENTCONFIG#"]


; Entry 5
[sEntryDesc5]
Meter = String
MeterStyle = yEntryDescription | yEntry

[iEntryImage5]
Meter = Image
MeasureName = mEntryImageDownloader5
MeterStyle = yEntryImage | yEntry

[sEntryTitle5]
Meter = String
MeterStyle = yEntryTitle | yEntry

[mEntryImageDownloader5]
Measure = Plugin
Plugin = WebParser
Disabled = 1
UpdateRate = -1
Download = 1
FinishAction = [!UpdateMeasure "mImageDownloadProgress" "#CURRENTCONFIG#"] [!UpdateMeter "iEntryImage5" "#CURRENTCONFIG#"] [!Redraw "#CURRENTCONFIG#"]


; Entry 6
[sEntryDesc6]
Meter = String
MeterStyle = yEntryDescription | yEntry

[iEntryImage6]
Meter = Image
MeasureName = mEntryImageDownloader6
MeterStyle = yEntryImage | yEntry

[sEntryTitle6]
Meter = String
MeterStyle = yEntryTitle | yEntry

[mEntryImageDownloader6]
Measure = Plugin
Plugin = WebParser
Disabled = 1
UpdateRate = -1
Download = 1
FinishAction = [!UpdateMeasure "mImageDownloadProgress" "#CURRENTCONFIG#"] [!UpdateMeter "iEntryImage6" "#CURRENTCONFIG#"] [!Redraw "#CURRENTCONFIG#"]


; Entry 7
[sEntryDesc7]
Meter = String
MeterStyle = yEntryDescription | yEntry

[iEntryImage7]
Meter = Image
MeasureName = mEntryImageDownloader7
MeterStyle = yEntryImage | yEntry

[sEntryTitle7]
Meter = String
MeterStyle = yEntryTitle | yEntry

[mEntryImageDownloader7]
Measure = Plugin
Plugin = WebParser
Disabled = 1
UpdateRate = -1
Download = 1
FinishAction = [!UpdateMeasure "mImageDownloadProgress" "#CURRENTCONFIG#"] [!UpdateMeter "iEntryImage7" "#CURRENTCONFIG#"] [!Redraw "#CURRENTCONFIG#"]


; Entry 8
[sEntryDesc8]
Meter = String
MeterStyle = yEntryDescription | yEntry

[iEntryImage8]
Meter = Image
MeasureName = mEntryImageDownloader8
MeterStyle = yEntryImage | yEntry

[sEntryTitle8]
Meter = String
MeterStyle = yEntryTitle | yEntry

[mEntryImageDownloader8]
Measure = Plugin
Plugin = WebParser
Disabled = 1
UpdateRate = -1
Download = 1
FinishAction = [!UpdateMeasure "mImageDownloadProgress" "#CURRENTCONFIG#"] [!UpdateMeter "iEntryImage8" "#CURRENTCONFIG#"] [!Redraw "#CURRENTCONFIG#"]


; Entry 9
[sEntryDesc9]
Meter = String
MeterStyle = yEntryDescription | yEntry

[iEntryImage9]
Meter = Image
MeasureName = mEntryImageDownloader9
MeterStyle = yEntryImage | yEntry

[sEntryTitle9]
Meter = String
MeterStyle = yEntryTitle | yEntry

[mEntryImageDownloader9]
Measure = Plugin
Plugin = WebParser
Disabled = 1
UpdateRate = -1
Download = 1
FinishAction = [!UpdateMeasure "mImageDownloadProgress" "#CURRENTCONFIG#"] [!UpdateMeter "iEntryImage9" "#CURRENTCONFIG#"] [!Redraw "#CURRENTCONFIG#"]


; Entry 10
[sEntryDesc10]
Meter = String
MeterStyle = yEntryDescription | yEntry

[iEntryImage10]
Meter = Image
MeasureName = mEntryImageDownloader10
MeterStyle = yEntryImage | yEntry

[sEntryTitle10]
Meter = String
MeterStyle = yEntryTitle | yEntry

[mEntryImageDownloader10]
Measure = Plugin
Plugin = WebParser
Disabled = 1
UpdateRate = -1
Download = 1
FinishAction = [!UpdateMeasure "mImageDownloadProgress" "#CURRENTCONFIG#"] [!UpdateMeter "iEntryImage10" "#CURRENTCONFIG#"] [!Redraw "#CURRENTCONFIG#"]


; Entry 11
[sEntryDesc11]
Meter = String
MeterStyle = yEntryDescription | yEntry

[iEntryImage11]
Meter = Image
MeasureName = mEntryImageDownloader11
MeterStyle = yEntryImage | yEntry

[sEntryTitle11]
Meter = String
MeterStyle = yEntryTitle | yEntry

[mEntryImageDownloader11]
Measure = Plugin
Plugin = WebParser
Disabled = 1
UpdateRate = -1
Download = 1
FinishAction = [!UpdateMeasure "mImageDownloadProgress" "#CURRENTCONFIG#"] [!UpdateMeter "iEntryImage11" "#CURRENTCONFIG#"] [!Redraw "#CURRENTCONFIG#"]


; Entry 12
[sEntryDesc12]
Meter = String
MeterStyle = yEntryDescription | yEntry

[iEntryImage12]
Meter = Image
MeasureName = mEntryImageDownloader12
MeterStyle = yEntryImage | yEntry

[sEntryTitle12]
Meter = String
MeterStyle = yEntryTitle | yEntry

[mEntryImageDownloader12]
Measure = Plugin
Plugin = WebParser
Disabled = 1
UpdateRate = -1
Download = 1
FinishAction = [!UpdateMeasure "mImageDownloadProgress" "#CURRENTCONFIG#"] [!UpdateMeter "iEntryImage12" "#CURRENTCONFIG#"] [!Redraw "#CURRENTCONFIG#"]


; Entry 13
[sEntryDesc13]
Meter = String
MeterStyle = yEntryDescription | yEntry

[iEntryImage13]
Meter = Image
MeasureName = mEntryImageDownloader13
MeterStyle = yEntryImage | yEntry

[sEntryTitle13]
Meter = String
MeterStyle = yEntryTitle | yEntry

[mEntryImageDownloader13]
Measure = Plugin
Plugin = WebParser
Disabled = 1
UpdateRate = -1
Download = 1
FinishAction = [!UpdateMeasure "mImageDownloadProgress" "#CURRENTCONFIG#"] [!UpdateMeter "iEntryImage13" "#CURRENTCONFIG#"] [!Redraw "#CURRENTCONFIG#"]


; Entry 14
[sEntryDesc14]
Meter = String
MeterStyle = yEntryDescription | yEntry

[iEntryImage14]
Meter = Image
MeasureName = mEntryImageDownloader14
MeterStyle = yEntryImage | yEntry

[sEntryTitle14]
Meter = String
MeterStyle = yEntryTitle | yEntry

[mEntryImageDownloader14]
Measure = Plugin
Plugin = WebParser
Disabled = 1
UpdateRate = -1
Download = 1
FinishAction = [!UpdateMeasure "mImageDownloadProgress" "#CURRENTCONFIG#"] [!UpdateMeter "iEntryImage14" "#CURRENTCONFIG#"] [!Redraw "#CURRENTCONFIG#"]


; Entry 15
[sEntryDesc15]
Meter = String
MeterStyle = yEntryDescription | yEntry

[iEntryImage15]
Meter = Image
MeasureName = mEntryImageDownloader15
MeterStyle = yEntryImage | yEntry

[sEntryTitle15]
Meter = String
MeterStyle = yEntryTitle | yEntry

[mEntryImageDownloader15]
Measure = Plugin
Plugin = WebParser
Disabled = 1
UpdateRate = -1
Download = 1
FinishAction = [!UpdateMeasure "mImageDownloadProgress" "#CURRENTCONFIG#"] [!UpdateMeter "iEntryImage15" "#CURRENTCONFIG#"] [!Redraw "#CURRENTCONFIG#"]


; Entry 16
[sEntryDesc16]
Meter = String
MeterStyle = yEntryDescription | yEntry

[iEntryImage16]
Meter = Image
MeasureName = mEntryImageDownloader16
MeterStyle = yEntryImage | yEntry

[sEntryTitle16]
Meter = String
MeterStyle = yEntryTitle | yEntry

[mEntryImageDownloader16]
Measure = Plugin
Plugin = WebParser
Disabled = 1
UpdateRate = -1
Download = 1
FinishAction = [!UpdateMeasure "mImageDownloadProgress" "#CURRENTCONFIG#"] [!UpdateMeter "iEntryImage16" "#CURRENTCONFIG#"] [!Redraw "#CURRENTCONFIG#"]


; Entry 17
[sEntryDesc17]
Meter = String
MeterStyle = yEntryDescription | yEntry

[iEntryImage17]
Meter = Image
MeasureName = mEntryImageDownloader17
MeterStyle = yEntryImage | yEntry

[sEntryTitle17]
Meter = String
MeterStyle = yEntryTitle | yEntry

[mEntryImageDownloader17]
Measure = Plugin
Plugin = WebParser
Disabled = 1
UpdateRate = -1
Download = 1
FinishAction = [!UpdateMeasure "mImageDownloadProgress" "#CURRENTCONFIG#"] [!UpdateMeter "iEntryImage17" "#CURRENTCONFIG#"] [!Redraw "#CURRENTCONFIG#"]


; Entry 18
[sEntryDesc18]
Meter = String
MeterStyle = yEntryDescription | yEntry

[iEntryImage18]
Meter = Image
MeasureName = mEntryImageDownloader18
MeterStyle = yEntryImage | yEntry

[sEntryTitle18]
Meter = String
MeterStyle = yEntryTitle | yEntry

[mEntryImageDownloader18]
Measure = Plugin
Plugin = WebParser
Disabled = 1
UpdateRate = -1
Download = 1
FinishAction = [!UpdateMeasure "mImageDownloadProgress" "#CURRENTCONFIG#"] [!UpdateMeter "iEntryImage18" "#CURRENTCONFIG#"] [!Redraw "#CURRENTCONFIG#"]


; Entry 19
[sEntryDesc19]
Meter = String
MeterStyle = yEntryDescription | yEntry

[iEntryImage19]
Meter = Image
MeasureName = mEntryImageDownloader19
MeterStyle = yEntryImage | yEntry

[sEntryTitle19]
Meter = String
MeterStyle = yEntryTitle | yEntry

[mEntryImageDownloader19]
Measure = Plugin
Plugin = WebParser
Disabled = 1
UpdateRate = -1
Download = 1
FinishAction = [!UpdateMeasure "mImageDownloadProgress" "#CURRENTCONFIG#"] [!UpdateMeter "iEntryImage19" "#CURRENTCONFIG#"] [!Redraw "#CURRENTCONFIG#"]


; Entry 20
[sEntryDesc20]
Meter = String
MeterStyle = yEntryDescription | yEntry

[iEntryImage20]
Meter = Image
MeasureName = mEntryImageDownloader20
MeterStyle = yEntryImage | yEntry

[sEntryTitle20]
Meter = String
MeterStyle = yEntryTitle | yEntry

[mEntryImageDownloader20]
Measure = Plugin
Plugin = WebParser
Disabled = 1
UpdateRate = -1
Download = 1
FinishAction = [!UpdateMeasure "mImageDownloadProgress" "#CURRENTCONFIG#"] [!UpdateMeter "iEntryImage20" "#CURRENTCONFIG#"] [!Redraw "#CURRENTCONFIG#"]


; Entry 21
[sEntryDesc21]
Meter = String
MeterStyle = yEntryDescription | yEntry

[iEntryImage21]
Meter = Image
MeasureName = mEntryImageDownloader21
MeterStyle = yEntryImage | yEntry

[sEntryTitle21]
Meter = String
MeterStyle = yEntryTitle | yEntry

[mEntryImageDownloader21]
Measure = Plugin
Plugin = WebParser
Disabled = 1
UpdateRate = -1
Download = 1
FinishAction = [!UpdateMeasure "mImageDownloadProgress" "#CURRENTCONFIG#"] [!UpdateMeter "iEntryImage21" "#CURRENTCONFIG#"] [!Redraw "#CURRENTCONFIG#"]


; Entry 22
[sEntryDesc22]
Meter = String
MeterStyle = yEntryDescription | yEntry

[iEntryImage22]
Meter = Image
MeasureName = mEntryImageDownloader22
MeterStyle = yEntryImage | yEntry

[sEntryTitle22]
Meter = String
MeterStyle = yEntryTitle | yEntry

[mEntryImageDownloader22]
Measure = Plugin
Plugin = WebParser
Disabled = 1
UpdateRate = -1
Download = 1
FinishAction = [!UpdateMeasure "mImageDownloadProgress" "#CURRENTCONFIG#"] [!UpdateMeter "iEntryImage22" "#CURRENTCONFIG#"] [!Redraw "#CURRENTCONFIG#"]


; Entry 23
[sEntryDesc23]
Meter = String
MeterStyle = yEntryDescription | yEntry

[iEntryImage23]
Meter = Image
MeasureName = mEntryImageDownloader23
MeterStyle = yEntryImage | yEntry

[sEntryTitle23]
Meter = String
MeterStyle = yEntryTitle | yEntry

[mEntryImageDownloader23]
Measure = Plugin
Plugin = WebParser
Disabled = 1
UpdateRate = -1
Download = 1
FinishAction = [!UpdateMeasure "mImageDownloadProgress" "#CURRENTCONFIG#"] [!UpdateMeter "iEntryImage23" "#CURRENTCONFIG#"] [!Redraw "#CURRENTCONFIG#"]


; Entry 24
[sEntryDesc24]
Meter = String
MeterStyle = yEntryDescription | yEntry

[iEntryImage24]
Meter = Image
MeasureName = mEntryImageDownloader24
MeterStyle = yEntryImage | yEntry

[sEntryTitle24]
Meter = String
MeterStyle = yEntryTitle | yEntry

[mEntryImageDownloader24]
Measure = Plugin
Plugin = WebParser
Disabled = 1
UpdateRate = -1
Download = 1
FinishAction = [!UpdateMeasure "mImageDownloadProgress" "#CURRENTCONFIG#"] [!UpdateMeter "iEntryImage24" "#CURRENTCONFIG#"] [!Redraw "#CURRENTCONFIG#"]


; Entry 25
[sEntryDesc25]
Meter = String
MeterStyle = yEntryDescription | yEntry

[iEntryImage25]
Meter = Image
MeasureName = mEntryImageDownloader25
MeterStyle = yEntryImage | yEntry

[sEntryTitle25]
Meter = String
MeterStyle = yEntryTitle | yEntry

[mEntryImageDownloader25]
Measure = Plugin
Plugin = WebParser
Disabled = 1
UpdateRate = -1
Download = 1
FinishAction = [!UpdateMeasure "mImageDownloadProgress" "#CURRENTCONFIG#"] [!UpdateMeter "iEntryImage25" "#CURRENTCONFIG#"] [!Redraw "#CURRENTCONFIG#"]

