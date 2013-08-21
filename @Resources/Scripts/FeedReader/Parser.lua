
function Initialize()
	-- {category, identifier, url [, pin]}
	-- category: the category the feed is saved under, can be choosen later on from the drop down menu
	-- identifier: displayed name of the link to the Feed
	-- url: url to the feed to be parsed
	-- pin (optional): if true it has higher priority and is as most top as possible
	local feedUrlList = {
		{'Nachrichten', 'Spiegel Online', 'http://www.spiegel.de/schlagzeilen/tops/index.rss'},
		{'Backen', 'Cupcake Queen', 'http://cupcakequeen.de/feed/'},	
		{'Nachrichten', 'Die Welt', 'http://www.welt.de/?service=Rss', true},
		{'Nachrichten', 'Die Welt', 'http://www.welt.de/?service=Rss', true},
		{'Nachrichten', 'Die Welt', 'http://www.welt.de/?service=Rss', true},
		{'Nachrichten', 'Die Welt', 'http://www.welt.de/?service=Rss', true},
		{'Nachrichten', 'Die Welt', 'http://www.welt.de/?service=Rss', true},
		{'Nachrichten', 'Die Welt', 'http://www.welt.de/?service=Rss', true},
		{'Nachrichten', 'Die Welt', 'http://www.welt.de/?service=Rss', true},
		{'Nachrichten', 'Die Welt', 'http://www.welt.de/?service=Rss', true},
		{'Nachrichten', 'Die Welt', 'http://www.welt.de/?service=Rss', true},
		{'Nachrichten', 'Die Welt', 'http://www.welt.de/?service=Rss', true},
		{'Nachrichten', 'Die Welt', 'http://www.welt.de/?service=Rss', true},
		{'Nachrichten', 'Die Welt', 'http://www.welt.de/?service=Rss', true},
		{'Nachrichten', 'Die Welt', 'http://www.welt.de/?service=Rss', true},
		{'Nachrichten', 'Die Welt', 'http://www.welt.de/?service=Rss', true},
		{'Nachrichten', 'Die Welt', 'http://www.welt.de/?service=Rss', true},
		{'Nachrichten', 'Die Welt', 'http://www.welt.de/?service=Rss', true},
		{'Nachrichten', 'Spiegel Online', 'http://www.spiegel.de/schlagzeilen/tops/index.rss', true},
		{'Nachrichten', 'Die Welt', 'http://www.welt.de/?service=Rss', true},
		{'Nachrichten', 'Die Welt', 'http://www.welt.de/?service=Rss', true},
		{'Nachrichten', 'Die Welt', 'http://www.welt.de/?service=Rss', true},
		{'Nachrichten', 'Die Welt', 'http://www.welt.de/?service=Rss', true},
		{'Nachrichten', 'Die Welt', 'http://www.welt.de/?service=Rss', true},
		{'Nachrichten', 'Die Welt', 'http://www.welt.de/?service=Rss', true},
		{'Nachrichten', 'Die Welt', 'http://www.welt.de/?service=Rss', true},
		{'Nachrichten', 'Die Welt', 'http://www.welt.de/?service=Rss', true},
		{'Nachrichten', 'Die Welt', 'http://www.welt.de/?service=Rss', true},
		{'Nachrichten', 'Die Welt', 'http://www.welt.de/?service=Rss', true},
		{'Nachrichten', 'Die Welt', 'http://www.welt.de/?service=Rss', true},
		{'Nachrichten', 'Die Welt', 'http://www.welt.de/?service=Rss', true},
		{'Nachrichten', 'Die Welt', 'http://www.welt.de/?service=Rss', true},
		{'Nachrichten', 'Die Welt', 'http://www.welt.de/?service=Rss', true},
		{'Nachrichten', 'Die Welt', 'http://www.welt.de/?service=Rss', true},
		{'Nachrichten', 'Die Welt LAST', 'http://www.welt.de/?service=Rss', true},
	}

	Meters, Measures, Variables = dofile(SKIN:GetVariable('@').."Scripts\\libs\\InterfaceOOPAccess.lua")(SKIN)
	PrettyPrint = dofile(SKIN:GetVariable('@').."Scripts\\libs\\PrettyPrint.lua")
	FeedParser = dofile(SKIN:GetVariable('@').."Scripts\\libs\\FeedParser.lua")
	FileReader = dofile(SKIN:GetVariable('@').."Scripts\\libs\\FileReader.lua")
	
	-- SORTED_URL_LIST[category][id/url] = value
	SORTED_URL_LIST, CATEGORY_ORDER = sortFeedUrlList(feedUrlList)
	displayCategories(CATEGORY_ORDER)

	SCROLL_OFFSET = 0
	-- test
	-- local uri = 'H:\\Data\\Downloads\\cupcakequeen.xml'
	-- local rawFeed = FileReader(uri)
	-- local entryList = FeedParser(rawFeed, getEntryCount())

	-- displayFeed(entryList)
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
	local index = 1
	while Meters['sFeed' .. index].isMeter() do
		Meters['sFeed' .. index].hide()

		index = index + 1
	end

	-- change scrollbar size
	Meters.iScrollbarBarArea.H = 717 * math.min(30 / #SORTED_URL_LIST[category], 1)
	Meters.iScrollbarBarArea.update()

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

function shiftCategory(offset)
	local currentCategory = Meters.sCategorySelectorText.Text
	local feedCount = #SORTED_URL_LIST[currentCategory]

	-- check if it can even offset more
	SCROLL_OFFSET = math.max(0, math.min(SCROLL_OFFSET + offset, feedCount - 30))
		
	-- change scrollbar position
	Meters.iScrollbarBarArea.Y = 83 + SCROLL_OFFSET * math.ceil(717 / #SORTED_URL_LIST[currentCategory])
	Meters.iScrollbarBarArea.update()

	---[[
	for index = SCROLL_OFFSET + 1, #SORTED_URL_LIST[currentCategory], 1 do 
		if not Meters['sFeed' .. index - SCROLL_OFFSET].isMeter() then break end

		Meters['sFeed' .. index - SCROLL_OFFSET].show()
		Meters['sFeed' .. index - SCROLL_OFFSET].Text = SORTED_URL_LIST[currentCategory][index].id
		Meters['sFeed' .. index - SCROLL_OFFSET].LeftMouseUpAction = '[!SetOption "mWebParser" "Disabled" "0"] [!SetOption "mWebParser" "Url" "'.. SORTED_URL_LIST[currentCategory][index].url ..'" "'.. Variables.CURRENTCONFIG ..'"] [!CommandMeasure "mWebParser" "Update" "'.. Variables.CURRENTCONFIG ..'"]'
		Meters['sFeed' .. index - SCROLL_OFFSET].update()
	end
	--]]

	Meters.redraw()
end

function onFinishActionWebParser()
	local filePath = Measures.mWebParser:GetStringValue()
	local rawFeed = FileReader(filePath)
	local entryList = FeedParser(rawFeed, getEntryCount())

	displayFeed(entryList)
end

function displayFeed(entryList)

	-- clear everything
	local index = 1
	while Meters['sEntryTitle' .. index].isMeter() do
		Meters['sEntryTitle' .. index].hide()
		Meters['sEntryDesc' .. index].hide()
		Meters['iEntryImage' .. index].hide()

		index = index + 1
	end

	-- entry = {title, link, cont, img}
	for index, entry in pairs(entryList) do
		if not Meters['sEntryTitle' .. index].isMeter() then break end

		Meters['sEntryTitle' .. index].Text = entry.title
		Meters['sEntryTitle' .. index].show()
		Meters['sEntryTitle' .. index].update()

		Meters['sEntryDesc' .. index].Text = entry.cont
		Meters['sEntryDesc' .. index].RightMouseUpAction = entry.link
		Meters['sEntryDesc' .. index].show()
		Meters['sEntryDesc' .. index].update()
		
		if Measures['mEntryImageReader' .. index].isMeasure() and entry.img then
			Meters['iEntryImage' .. index].show()
			Measures['mEntryImageReader' .. index].Url = entry.img
			Measures['mEntryImageReader' .. index].Disabled = 0
			Measures['mEntryImageReader' .. index].forceUpdate()
		end
	end

	Meters.redraw()
end

-- IO
-- ==================================================


-- BASIC
-- ==================================================
-- @return _ number
function getEntryCount() return Variables.FeedReaderColCount * Variables.FeedReaderRowCount end
