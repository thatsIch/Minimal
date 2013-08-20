
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
	FeedParser = dofile(SKIN:GetVariable('@').."Scripts\\libs\\FeedParser.lua")
	FileReader = dofile(SKIN:GetVariable('@').."Scripts\\libs\\FileReader.lua")
	
	-- SORTED_URL_LIST[category][id/url] = value
	SORTED_URL_LIST, CATEGORY_ORDER = sortFeedUrlList(feedUrlList)
	displayCategories(CATEGORY_ORDER)

	-- test
	local uri = 'H:\\Data\\Downloads\\cupcakequeen.xml'
	local rawFeed = FileReader(uri)
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
	local rawFeed = FileReader(filePath)
	local entryList = FeedParser(rawFeed, getEntryCount())

	-- entry = {title, link, cont, img}
	for index, entry in pairs(entryList) do
		if not Meters['sEntryTitle' .. index].isMeter() then break end

		Meters['sEntryTitle' .. index].Text = entry.title
		Meters['sEntryTitle' .. index].update()

		Meters['sEntryDesc' .. index].Text = entry.cont
		Meters['sEntryDesc' .. index].RightMouseUpAction = entry.link
		Meters['sEntryDesc' .. index].update()
		
		if Measures['mEntryImageReader' .. index].isMeasure() and entry.img then
			Measures['mEntryImageReader' .. index].Url = entry.img
			Measures['mEntryImageReader' .. index].Disabled = 0
			Measures['mEntryImageReader' .. index].forceUpdate()
		else
			Meters['iEntryImage' .. index].ImageName = ""
			Meters['iEntryImage' .. index].update()
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
