[mSearchFeedDownloader]
Measure = Plugin
Plugin = WebParser
Download = 1
Disabled = 1
UpdateRate = -1
OnChangeAction = [!CommandMeasure "mParseScript" "onChangeActionSearchFeedDownloader()" "#CURRENTCONFIG#"]
FinishAction = [!CommandMeasure "mParseScript" "onFinishActionSearchFeedDownloader()" "#CURRENTCONFIG#"]