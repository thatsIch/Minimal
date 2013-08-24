-- {category, identifier, url [, pin]}
-- category: the category the feed is saved under, can be choosen later on from the drop down menu
-- identifier: displayed name of the link to the Feed
-- url: url to the feed to be parsed
-- pin (optional): if true it has higher priority and is as most top as possible
return {
	{'Nachrichten', 'Spiegel Online', 'http://www.spiegel.de/schlagzeilen/tops/index.rss', true},
	{'Videos', 'Youtube', 'http://gdata.youtube.com/feeds/base/users/badhardba/newsubscriptionvideos', true},
	{'Videos', 'Watchanimeon', 'http://www.watchanimeon.com/feed/atom/'},
	{'Musik', 'iTunes Top 25', 'http://ax.itunes.apple.com/WebObjects/MZStoreServices.woa/ws/RSS/topsongs/limit=25/xml'},
	{'Nachrichten', 'Die Welt', 'http://www.welt.de/?service=Rss'},
	{'Computer', 'Rainmeter', 'http://rainmeter.net/forum/feed.php', true},
	{'Computer', 'Golem.IT', 'http://golem.de.dynamic.feedsportal.com/pf/578068/http://rss.golem.de/rss.php?feed=RSS2.0'},
	{'Computer', 'Reddit FTB', 'www.reddit.com/r/feedthebeast/.rss', true},
}
