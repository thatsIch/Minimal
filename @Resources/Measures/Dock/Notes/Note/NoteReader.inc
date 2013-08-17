[mNoteReader]
Measure = Plugin
Plugin = WebParser
URL = file://#CURRENTPATH#note.txt
RegExp = "(?si)(.*)"
StringIndex = 0
UpdateRate = -1
;UpdateDivider = -1
ForceReload = 1
FinishAction = [!UpdateMeter "sNote"] [!Redraw]