[mWebParser]
Measure = Plugin
Plugin = WebParser
Url = #Cal1#
Download = 1
UpdateRate = #RefreshRate#
DynamicVariables = 1
FinishAction = [!CommandMeasure "mParser" "parseNextCalendar()" "#CURRENTCONFIG#"]

[mParser]
Measure = Script
ScriptFile = #@#Scripts\DCal\Parser.lua
Disabled = 1