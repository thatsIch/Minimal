local Parser do

-- TODO link marker of current feed
function Initialize()
	-- Libs
	Meters, Measures, Variables = dofile(SKIN:GetVariable('@').."Scripts\\libs\\InterfaceOOPAccess.lua")(SKIN)
	FeedParser, ListParser = dofile(Variables['@'].."Scripts\\Libs\\FeedParser.lua")
	FileReader = dofile(Variables['@'].."Scripts\\Libs\\FileReader.lua")
	
	-- -- Database
	local feedList = dofile(Variables['@'].."Scripts\\FeedReader\\FeedList.lua")

	-- Debug
	PrettyPrint = dofile(Variables['@'].."Scripts\\Libs\\PrettyPrint.lua")
	
	-- run-once functions: prepare data and pre-render skin parts
	local sortedFeedList, categoryOrder = sortFeedList(feedList)
	prepareCategories(categoryOrder)
	prepareEntries()

	-- Prepare the Search Database
	prepareSearchDataBase(feedList)

	-- GLOBAL VARIABLES
	SORTED_URL_LIST = sortedFeedList
	SCROLL_OFFSET = 0
	LINK_MARKER = 0

	-- DATA_BASE = {{title, link, cont, img}}
	DATA_BASE = {}

	-- run-once function
	Initialize = nil
end

function searchInDatabase(search)
	-- prepare entry list
	local __entryList = {}
	local __meters = Meters
	local __search = string.lower(search)

	-- loop through whole database
	for _, entry in ipairs(DATA_BASE) do
		-- search within title and content
		if string.find(string.lower(entry.title), __search) 
		or string.find(string.lower(entry.cont), __search) then
			table.insert(__entryList, entry)
		end
	end

	__meters.sSearchField.Text = search .. ': ' .. #__entryList .. ' Hits in ' .. #DATA_BASE .. ' Entries'
	__meters.sSearchField.update()
	__meters.redraw()

	if #__entryList > 0 then renderEntryList(__entryList) end
end

function prepareSearchDataBase(feedList)

	-- set the max of mSearchDownloadProgress to the known length
	Measures.mSearchDownloadProgress.MaxValue = #feedList

	prepareSearchDataBase = function()
		local feedList = feedList

		-- stop when to be processed feed list is empty
		if #feedList <= 0 then return end

		-- pop first item {category, identifier, url, pinned}
		local feed = table.remove(feedList, 1)

		-- fetch url within
		local url = assert(feed[3], "No URL found, please check your URL for Feed " .. feed[2])

		-- setup SearchWebParser
		searchParserProcessUrl(url)
	end

	-- run once the new function yourself
	prepareSearchDataBase()
end

-- @param url string : url of to be processed feed
function searchParserProcessUrl(url)
	local mSearchFeedDownloader = Measures.mSearchFeedDownloader

	mSearchFeedDownloader.Disabled = 0
	mSearchFeedDownloader.Url = url
	mSearchFeedDownloader.forceUpdate()
end

function onFinishActionSearchFeedDownloader()
	
	-- processing data
	local filePath = Measures.mSearchFeedDownloader:GetStringValue()

	-- catch download errors
	if filePath ~= "" then 
		local rawFeed = FileReader(filePath)
		ListParser(DATA_BASE, rawFeed)
	end

	Measures.mSearchDownloadProgress.update()

	-- setting next feed
	prepareSearchDataBase()
end

-- Gives all entries the left and rightclick properties
function prepareEntries()
	local meters = Meters
	local maxEntryCount = getMaxEntryCount()
	local config = Variables.CURRENTCONFIG
	local desc = meters.sEntryDesc1
	local originX, originY = desc.X, desc.Y
	local entryW, entryH, entryP = Variables.EntryWidth, Variables.EntryHeight, Variables.EntryPadding
	local rows, cols = Variables.Rows, Variables.Cols
	local titleH = entryH * 0.382
	local titleDiff = entryH - titleH

	local hide = function(index) return 
		'[!HideMeter "sEntryTitle'.. index ..'" "'.. config ..'"]' ..
		'[!HideMeter "iEntryImage'.. index ..'" "'.. config ..'"]' ..
		'[!Redraw "'.. config ..'"]'
	end

	local show = function(index) return 
		'[!ShowMeter "sEntryTitle'.. index ..'" "'.. config ..'"]' ..
		'[!ShowMeter "iEntryImage'.. index ..'" "'.. config ..'"]' ..
		'[!Redraw "'.. config ..'"]'
	end

	-- only run-once function
	prepareEntries = nil
	
	-- Aligns each group
	for row = 1, rows, 1 do
		for col = 1, cols, 1 do
			local index = (row - 1) * cols + col
			if maxEntryCount < index then return end
			
			local sEntryDesc = meters['sEntryDesc' .. index]
			local iEntryImage = meters['iEntryImage' .. index]
			local sEntryTitle = meters['sEntryTitle' .. index]

			sEntryDesc.X = originX + (col - 1) * (entryW + entryP)
			iEntryImage.X = originX + (col - 1) * (entryW + entryP)
			sEntryTitle.X = originX + (col - 1) * (entryW + entryP)

			sEntryDesc.Y = originY + (row - 1) * (entryH + entryP)
			iEntryImage.Y = originY + (row - 1) * (entryH + entryP)
			sEntryTitle.Y = originY + (row - 1) * (entryH + entryP) + titleDiff
			sEntryTitle.H = titleH

			sEntryDesc.LeftMouseUpAction = show(index)
			iEntryImage.LeftMouseUpAction = hide(index)
			sEntryTitle.LeftMouseUpAction = hide(index)
		end
	end
end

-- get maximal count of the feeds
-- @return count number
function getMaxFeedCount()
	local meters = Meters
	local iScrollBarBotAnchor = meters.iScrollBarBotAnchor
	local count = 1

	-- check if meter is there and if they dont crash the window limit
	while meters['sFeed' .. count].isMeter() do
		local sFeed = meters['sFeed' .. count]
		sFeed.MeterStyle = 'yFeedItem'
		sFeed.update()

		if iScrollBarBotAnchor.Y > sFeed.Y then count = count + 1 else break end
	end

	-- hide all again 
	for i = 1, (count - 1), 1 do
		local sFeed = meters['sFeed' .. i]
		
		sFeed.hide()
		sFeed.update()
	end

	meters.redraw()

	-- value wont change anymore
	getMaxFeedCount = function()
		return count - 1
	end

	return count - 1
end

-- An Entry is a section/entry/item of a feed most times found by parsing <entry></entry> etc
-- @return count number
function getMaxEntryCount()
	local meters = Meters
	local variables = Variables
	local count = 1
	while meters['sEntryTitle' .. count].isMeter() do
		count = count + 1
	end
	count = math.min(count - 1, variables.Cols * variables.Rows)

	getMaxEntryCount = function()
		return count
	end

	return count
end


-- @param rawList string
-- @return sortedResult, categoryOrder = {category = {{id, url}}}, {string}
function sortFeedList(rawList)
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

	-- run-once function
	sortFeedList = nil

	return sortedResult, categoryOrder
end

-- @param categories {string}
function prepareCategories(categories)
	local meters = Meters
	local maxFeedCount = getMaxEntryCount()
	local parserName = SELF:GetName()

	for i, category in pairs(categories) do
		-- break loop if too many categories
		if i > maxFeedCount then break end

		local sCategorySelectorDropdown = meters['sCategorySelectorDropdown' .. i]
		sCategorySelectorDropdown.MeterStyle = 'yCategorySelectorDropdown'
		sCategorySelectorDropdown.Text = category
		sCategorySelectorDropdown.LeftMouseUpAction = '[!CommandMeasure "'..parserName..'" "displayCategory(\''.. category ..'\')" "#CURRENTCONFIG#"]'
		sCategorySelectorDropdown.update()
	end

	meters.redraw()

	-- run-once function
	prepareCategories = nil
end

-- @param category string
function displayCategory(category)
	local maxFeedCount = getMaxFeedCount()
	local meters = Meters
	local iScrollbarBarArea = meters.iScrollbarBarArea
	local iScrollBarTopAnchor = meters.iScrollBarTopAnchor
	local iScrollBarBotAnchor = meters.iScrollBarBotAnchor
	local sCategorySelectorText = meters.sCategorySelectorText
	local feedListOfCategory = SORTED_URL_LIST[category]
	local config = Variables.CURRENTCONFIG
	local parserName = SELF:GetName()

	-- reset offset
	SCROLL_OFFSET = 0

	-- change scrollbar size
	iScrollbarBarArea.Y = iScrollBarTopAnchor.Y
	iScrollbarBarArea.H = (iScrollBarBotAnchor.Y - iScrollBarTopAnchor.Y) * math.min(maxFeedCount / #feedListOfCategory, 1)
	iScrollbarBarArea.update()

	-- Display chosen category
	sCategorySelectorText.Text = category
	sCategorySelectorText.update()

	local stopPoint = 0
	for index, feed in pairs(feedListOfCategory) do
		-- not enough _meters to display
		if index > maxFeedCount then break end

		local meter = meters['sFeed' .. index]
		meter.show()
		meter.Text = feed.id
		meter.LeftMouseUpAction = 
			'[!SetOption "sFeed'..index..'" "FontColor" "#ColorLowDefault#" "'..config..'"] '..
			'[!UpdateMeter "sFeed' .. index..'" "'..config..'"] '..
			'[!Redraw "'..config..'"] '..
			'[!CommandMeasure "'..parserName..'" "onLeftMouseUpActionFeedLink(\''..feed.url..'\')" "'..config..'"]'
		meter.update()

		stopPoint = index
	end

	-- clear old feeds
	stopPoint = stopPoint + 1
	while meters['sFeed' .. stopPoint].isMeter() and stopPoint < maxFeedCount do
		meters['sFeed' .. stopPoint].hide()
		meters['sFeed' .. stopPoint].update()

		stopPoint = stopPoint + 1
	end

	meters.toggleGroup('DropDown')
	meters.redraw()
end

function shiftOnePageInCategory(direction)
	shiftCategory(direction * getMaxFeedCount())
end

-- @param offset number
-- @return void
function shiftCategory(offset)
	local meters = Meters
	local currentCategory = meters.sCategorySelectorText.Text
	local iScrollbarBarArea = meters.iScrollbarBarArea
	local iScrollBarTopAnchor = meters.iScrollBarTopAnchor
	local iScrollBarBotAnchor = meters.iScrollBarBotAnchor
	local maxFeedCount = getMaxFeedCount()
	local feedListOfCategory = SORTED_URL_LIST[currentCategory]
	local config = Variables.CURRENTCONFIG

	-- just ignore if no category is selected
	if not feedListOfCategory then return end
	local feedCount = #feedListOfCategory

	-- check if it can even offset more
	local newOffset = math.max(0, math.min(SCROLL_OFFSET + offset, feedCount - maxFeedCount))
	if SCROLL_OFFSET == newOffset then return end

	SCROLL_OFFSET = newOffset
		
	-- change scrollbar position
	iScrollbarBarArea.Y = iScrollBarTopAnchor.Y + SCROLL_OFFSET * (iScrollBarBotAnchor.Y - iScrollBarTopAnchor.Y) / feedCount
	iScrollbarBarArea.update()

	for index = SCROLL_OFFSET + 1, feedCount, 1 do 
		if (index - SCROLL_OFFSET) > maxFeedCount then break end
			local iString = 'sFeed' .. (index - SCROLL_OFFSET)
			local meter = meters[iString]

		meter.Text = feedListOfCategory[index].id
		meter.LeftMouseUpAction = 
			'[!SetOption "'..iString..'" "FontColor" "#ColorLowDefault#" "'..config..'"] '..
			'[!UpdateMeter "'..iString..'" "'..config..'"] '..
			'[!Redraw "'..config..'"] '..
			'[!SetOption "mCategoryFeedDownloader" "Disabled" "0"] '..
			'[!SetOption "mCategoryFeedDownloader" "Url" "'.. feedListOfCategory[index].url ..'" "'.. config ..'"] '..
			'[!CommandMeasure "mCategoryFeedDownloader" "Update" "'.. config ..'"]'
		meter.update()
	end

	meters.redraw()
end

-- renders an entry list
-- @param entryList {{title, link, cont, img}}
function renderEntryList(entryList)
	local meters = Meters
	local measures = Measures
	local stopPoint = 0
	local process = 0
	local maxEntryCount = getMaxEntryCount()

	for index, entry in pairs(entryList) do
		if index > maxEntryCount then break end

		local sEntryTitle = meters['sEntryTitle' .. index]
		local sEntryDesc = meters['sEntryDesc' .. index]
		local iEntryImage = meters['iEntryImage' .. index]

		sEntryTitle.Text = entry.title
		sEntryTitle.show()
		sEntryTitle.update()

		sEntryDesc.Text = entry.cont
		sEntryDesc.RightMouseUpAction = entry.link
		sEntryDesc.show()
		sEntryDesc.update()
		
		iEntryImage.show()

		if entry.img then
			local mEntryImageDownloader = measures['mEntryImageDownloader' .. index]

			process = process + 1

			iEntryImage.MeasureName = 'mEntryImageDownloader' .. index
			mEntryImageDownloader.Url = entry.img
			mEntryImageDownloader.Disabled = 0
			mEntryImageDownloader.forceUpdate()
		else
			iEntryImage.MeasureName = ""
			iEntryImage.update()
		end

		stopPoint = index
	end

	measures.mImageDownloadProgress.MaxValue = process

	-- clear everything which isnt used
	stopPoint = stopPoint + 1
	while meters['sEntryTitle' .. stopPoint].isMeter() do
		meters['sEntryTitle' .. stopPoint].hide()
		meters['sEntryDesc' .. stopPoint].hide()
		meters['iEntryImage' .. stopPoint].hide()

		stopPoint = stopPoint + 1
	end

	meters.redraw()
end


-- @param url string : url of to be processed feed
function webParserProcessUrl(url)
	local mCategoryFeedDownloader = Measures.mCategoryFeedDownloader

	mCategoryFeedDownloader.Disabled = 0
	mCategoryFeedDownloader.Url = url
	mCategoryFeedDownloader.forceUpdate()
end


-- I/O TO SCRIPT
-- ==================================================
function onFinishActionCategoryFeedDownloader()
	local filePath = Measures.mCategoryFeedDownloader:GetStringValue()
	local rawFeed = FileReader(filePath)
	local entryList = FeedParser(rawFeed, getMaxEntryCount())

	renderEntryList(entryList)
end

end -- local Parser

-- TODO add selected hook
-- @param url string : url of the clicked feed
function onLeftMouseUpActionFeedLink(url)
	Measures.mImageDownloadProgress.Formula = 0
	Measures.mImageDownloadProgress.update()

	webParserProcessUrl(url)
end

