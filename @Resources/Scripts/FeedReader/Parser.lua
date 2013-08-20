
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
	PrettyPrint = dofile(SKIN:GetVariable('@').."Scripts\\libs\\PrettyPrint.lua")
	
	-- SORTED_URL_LIST[category][id/url] = value
	SORTED_URL_LIST, CATEGORY_ORDER = sortFeedUrlList(feedUrlList)

	displayCategories(CATEGORY_ORDER)
	print(PrettyPrint(SORTED_URL_LIST))
	
	-- test
	local uri = 'H:\\Data\\Downloads\\cupcakequeen.xml'
	local rawFeed = getFileContent(uri)
end

-- @param rawList string
-- @return sortedResult, categoryOrder = {category = {{id, url}}}, {string}
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

-- @param categories {string}
function displayCategories(categories)
	for i, category in pairs(categories) do
		-- break loop if too many categories
		if not Meters['sCategorySelectorDropdown' .. i].isMeter() then break end

		Meters['sCategorySelectorDropdown' .. i].MeterStyle = 'yCategorySelectorDropdown'
		Meters['sCategorySelectorDropdown' .. i].Text = category
		Meters['sCategorySelectorDropdown' .. i].LeftMouseUpAction = '[!CommandMeasure "mParser" "displayCategory(\''.. category ..'\')" "#CURRENTCONFIG#"]'
		Meters['sCategorySelectorDropdown' .. i].update()
	end

	Meters.redraw()
end

-- @param category string
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

	Meters.toggleGroup('DropDown')
	Meters.redraw()
end

function displayFeed()
	local filePath = Measures.mWebParser:GetStringValue()
	local rawFeed = getFileContent(filePath)
	local entryList = parseRawFeed(rawFeed)


end

-- @param rawFeed String
-- @return parsedEntries table of {title, link, cont, img}
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
-- @param entry string
-- @return _ string
function getRSSTitle(entry) 
	return string.match( entry, '<title.->(.-)</title>' ) or "(no title)"
end

-- @param entry string
-- @return _ string
function getRSSLink(entry)
	return string.match( entry, '<link.->(.-)</link>' ) or "(no link)"
end

-- @param entry string
-- @return content string
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

-- @param entry string
-- @return image string
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
-- @param entry string
-- @return _ string
function getAtomTitle(entry)
	return string.match( entry, '<title.->(.-)</title>' ) or "(no title)"
end

-- @param entry string
-- @return _ string
function getAtomLink(entry)
	return string.match(entry, "<link.-href=[\"'](.-)[\"']") or "(no link)"
end

-- @param entry string
-- @return content string
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

-- @param entry string
-- @return _ string
function getAtomImage(entry)
	return string.match(entry, "<img.-src=[\"'](.-)[\"']")
end

-- IO
-- ==================================================
-- @param fileName string
-- @return content string
function getFileContent(fileName)
	if not fileName then return end

	local handle = io.open(fileName)
	local content = handle:read('*all')
	io.close(handle)

	return content
end

-- BASIC
-- ==================================================
-- @return _ number
function getEntryCount() return Variables.FeedReaderColCount * Variables.FeedReaderRowCount end
