
function Initialize()
	-- {category, identifier, url [, pin]}
	-- category: the category the feed is saved under, can be choosen later on from the drop down menu
	-- identifier: displayed name of the link to the Feed
	-- url: url to the feed to be parsed
	-- pin (optional): if true it has higher priority and is as most top as possible
	local feedUrlList = {
		{'Nachrichten', 'Spiegel Online', 'http://www.spiegel.de/schlagzeilen/tops/index.rss', true},
		{'Backen', 'Cupcake Queen', 'http://cupcakequeen.de/feed/'},	
		{'Nachrichten', 'Die Welt', 'http://www.welt.de/?service=Rss', true},
	}

	Meters, Measures, Variables = dofile(SKIN:GetVariable('@').."Scripts\\libs\\InterfaceOOPAccess.lua")(SKIN)
	local i = 1
	-- print(Meters['meterFeedReaderEntryDummy' .. i].isMeter())

	-- SORTED_URL_LIST[category][id/url] = value
	SORTED_URL_LIST, CATEGORY_ORDER = sortFeedUrlList(feedUrlList)

	displayCategories(CATEGORY_ORDER)
	
	-- test
	local uri = 'H:\\Data\\Downloads\\cupcakequeen.xml'
	local feed = getFileContent(uri)
end

function sortFeedUrlList(rawList)
	local sortedResult = {}
	local tempAlphaSorted = {}
	local categoryOrder = {}

	-- pre-arrange the list
	for _, feed in pairs(rawList) do

		local category, identifier, url, pinned = feed[1], feed[2], feed[3], feed[4]

		if not sortedResult[category] then 
			sortedResult[category] = {}
			tempAlphaSorted[category] = {}

			-- remember order of categories
			table.insert(categoryOrder, category)
		end

		if pinned then
			table.insert(sortedResult[category], { id = identifier; url = url })
		else 
			table.insert(tempAlphaSorted[category], { id = identifier; url = url })
		end
	end

	-- merge both lists
	for category, feeds in pairs(tempAlphaSorted) do
		-- sort alphabetically
		table.sort(feeds, function(curr,next) return string.lower(curr.id) < string.lower(next.id) end)

		for index, feed in pairs(feeds) do
			table.insert(sortedResult[category], feed)
		end
	end

	return sortedResult, categoryOrder
end

function displayCategories(categories)
	for i, category in pairs(categories) do
		-- break loop if too many categories
		if not Meters['sCategorySelectorDropdown' .. i].isMeter() then break end

		Meters['sCategorySelectorDropdown' .. i].MeterStyle = 'yCategorySelectorDropdown'
		Meters['sCategorySelectorDropdown' .. i].Text = category
		Meters['sCategorySelectorDropdown' .. i].LeftMouseUpAction = '[!CommandMeasure "mParser" "displayCategory(\''.. category ..'\')" "#CURRENTCONFIG#"]'
		Meters['sCategorySelectorDropdown' .. i].update()
	end

	Meters:Redraw()
end

-- string: category (eg 'News')
function displayCategory(category)

	-- clear old feeds
	local iterator = 1
	while Meters['sFeed' .. iterator].isMeter() do
		Meters['sFeed' .. iterator].hide()

		iterator = iterator + 1
	end

	-- write onto meter
	Meters.sCategorySelectorText.Text = category
	Meters.sCategorySelectorText.update()
	
	for index, feed in pairs(SORTED_URL_LIST[category]) do
		-- not enough _meters to display
		if not Meters['sFeed' .. index].isMeter() then break end

		Meters['sFeed' .. index].show()
		Meters['sFeed' .. index].Text = feed.id
		Meters['sFeed' .. index].LeftMouseUpAction = '[!SetOption "mWebParser" "Disabled" "0"] [!SetOption "mWebParser" "Url" "'.. feed.url ..'" "'.. Variables.CURRENTCONFIG ..'"] [!CommandMeasure "mWebParser" "Update" "'.. Variables.CURRENTCONFIG ..'"]'
		Meters['sFeed' .. index].update()
	end

	toggleMeterGroup('DropDown')
	Meters:Redraw()
end

function displayFeed()
	local filePath = getMeasure('mWebParser'):GetStringValue()
	local rawFeed = getFileContent(filePath)
	local entryList = parseRawFeed(rawFeed)


end

function parseRawFeed(rawFeed)
	local parsedEntries = {}

	-- RSS
	for entry in string.gmatch(rawFeed, '<item.->(.-)</item>') do
		table.insert(parsedEntries, {
			title = getRSSTitle(entry);
			link = getRSSLink(entry);
			cont = getRSSContent(entry);
			img = getRSSImage(entry);
		})
		if #parsedEntries > getEntryCount() then break end
	end

	-- ATOM
	for entry in string.gmatch(rawFeed, '<entry.->(.-)</entry>') do
		table.insert(parsedEntries, {
			title = getAtomTitle(entry);
			link = getAtomLink(entry);
			cont = getAtomContent(entry);
			img = getAtomImage(entry);
		})
		if #parsedEntries > getEntryCount() then break end
	end

	return parsedEntries
end

-- RSS
-- ==================================================
function getRSSTitle(entry) 
	return string.match( entry, '<title.->(.-)</title>' ) or "(no title)"
end

function getRSSLink(entry)
	return string.match( entry, '<link.->(.-)</link>' ) or "(no link)"
end

function getRSSContent(entry)
	local content = 
	string.match( entry, '<description.-><%!%[CDATA%[(.-)%]%]></description>' ) or
	string.match( entry, '<description.->(.-)</description>' ) or
	"(no content)"

	-- REMOVE HTML TAGS OUT OF CONTENT AND SHORTEN IT
	content = string.gsub(content, '<.->', '')
	content = string.sub(content, 0, 425)

	return content
end

function getRSSImage(entry)
	local image = 
	string.match( entry, "<media:thumbnail.-url=[\"'](.-)[\"']" ) or
	string.match( entry, '<media:thumbnail.->(.-)</media.->' ) or
	string.match( entry, '<enclosure.->(.-)</enclosure>' ) or
	string.match( entry, "<img.-src=[\"'](.-)[\"']" ) or
	string.match( entry, "<.-image.-url=[\"'](.-)[\"']" )	
	
	return image
end

-- ATOM
-- ==================================================
function getAtomTitle(entry)
	return string.match( entry, '<title.->(.-)</title>' ) or "(no title)"
end

function getAtomLink(entry)
	return string.match(entry, "<link.-href=[\"'](.-)[\"']") or "(no link)"
end

function getAtomContent(entry)
	local content = 
	string.match( entry, '<summary.->(.-)</summary>' ) or
	string.match( entry, '<content.->(.-)</content>' ) or
	"(no content)"

	-- REMOVE HTML TAGS OUT OF CONTENT AND SHORTEN IT
	content = string.gsub(content, '<.->', '')
	content = string.sub(content, 0, 425)

	return content
end

function getAtomImage(entry)
	return string.match(entry, "<img.-src=[\"'](.-)[\"']")
end

-- IO
-- ==================================================
function getFileContent(file)
	if not file then return end

	local handle = io.open(file)
	local content = handle:read('*all')
	io.close(handle)

	return content
end

-- RAINMETER INTERFACE
-- ==================================================
-- BASIC
-- ==================================================
function getEntryCount() return Variables.FeedReaderColCount * Variables.FeedReaderRowCount end

-- VARIABLES
-- ==================================================
function getVar(var) return SKIN:GetVariable(var) end

-- _meters
-- ==================================================
function toggleMeterGroup(group) SKIN:Bang('!ToggleMeterGroup', group, Variables.CURRENTCONFIG) end

-- MEASURES
-- ==================================================
function getMeasure(measure) return SKIN:GetMeasure(measure) end
