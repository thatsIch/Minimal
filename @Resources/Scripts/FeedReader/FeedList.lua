-- {category, identifier, url [, pin]}
-- category: the category the feed is saved under, can be choosen later on from the drop down menu
-- identifier: displayed name of the link to the Feed
-- url: url to the feed to be parsed
-- pin (optional): if true it has higher priority and is as most top as possible
return {
	{"Nachrichten", "Spiegel Online", "http://www.spiegel.de/schlagzeilen/tops/index.rss", true},
	{"Videos", "Watchanimeon", "http://www.watchanimeon.com/feed/atom/"},
	{"Musik", "iTunes Top 25", "http://ax.itunes.apple.com/WebObjects/MZStoreServices.woa/ws/RSS/topsongs/limit=25/xml"},
	{"Nachrichten", "Die Welt", "http://www.welt.de/?service=Rss"},
	{"Computer", "Golem.IT", "http://golem.de.dynamic.feedsportal.com/pf/578068/http://rss.golem.de/rss.php?feed=RSS2.0"},
	{"Computer", "Reddit FTB", "http://www.reddit.com/r/feedthebeast/.rss", true},
	{"Nachrichten", "Wetter", "http://www.wetter-vista.de/wettervorhersage/wetter-ratingen-2126.xml", true},
	{"Nachrichten", "Rheinische Post", "http://feeds.rp-online.de/rp-online/rss/topnews", true},
	{"Computer", "Customize - Rainmeter", "http://customize.org/feeds/category/rainmeter"},
	{"Computer", "DeviantArt - Rainmeter", "http://backend.deviantart.com/rss.xml?type=deviation&q=in%3Acustomization%2Fskins%2Fsysmonitor%2Frainmeter+sort%3Atime"},
	{'Nachrichten', "MSN Wetter - Göttingen", 'http://weather.msn.com/RSS.aspx?wealocations=wc:12418&weadegreetype=C', },
}
