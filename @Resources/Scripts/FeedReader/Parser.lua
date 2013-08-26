local Parser do

-- =====================================================================================
-- RUN-ONCE-ONLY-FUNCTIONS
-- =====================================================================================
function Initialize()
	-- Libs
	Meters, Measures, Variables = dofile(SKIN:GetVariable('@').."Scripts\\libs\\InterfaceOOPAccess.lua")(SKIN)
	FeedParser, ListParser = dofile(Variables['@'].."Scripts\\Libs\\FeedParser.lua")
	FileReader = dofile(Variables['@'].."Scripts\\Libs\\FileReader.lua")
	PrettyPrint = dofile(Variables['@'].."Scripts\\Libs\\PrettyPrint.lua")

	-- -- Database
	local feedList = dofile(Variables['@'].."Scripts\\FeedReader\\FeedList.lua")

		-- run-once functions: prepare data and pre-render skin parts
	local sortedFeedList, categoryOrder = sortFeedList(feedList)
	prepareCategories(categoryOrder)
	prepareEntries()

	-- Prepare the Search Database
	prepareSearchDataBase(feedList)

	-- GLOBAL VARIABLES
	SORTED_URL_LIST = sortedFeedList
	SCROLL_OFFSET = 0

	-- DATA_BASE = {{title, link, cont, img}}
	DATA_BASE = {}

	-- run-once function
	Initialize = nil
end

-- @param feedList {{category, id, url, pin}} : list of whole database
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
		local mSearchFeedDownloader = Measures.mSearchFeedDownloader

		print(#feedList, url)
		mSearchFeedDownloader.Disabled = 0
		mSearchFeedDownloader.Url = url
		mSearchFeedDownloader.forceUpdate()
	end

	-- run once the new function yourself
	prepareSearchDataBase()
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
		sCategorySelectorDropdown.LeftMouseUpAction = '[!CommandMeasure "'..parserName..'" "renderCategory(\''.. category ..'\')" "#CURRENTCONFIG#"]'
		sCategorySelectorDropdown.update()
	end

	meters.redraw()

	-- run-once function
	prepareCategories = nil
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


-- ====================================================================================================
-- GETTER
-- ====================================================================================================
-- @return maxFeedList {meter} : get the list of the maximum amount of displayable feed meters
function getMaxFeedMeterList()
	local meters = Meters
	local iScrollBarBotAnchor = meters.iScrollBarBotAnchor
	local maxFeedList = {}
	local meterName = 'sFeed'
	local meterStyle = 'yFeedItem'

	-- check if meter is there and if they dont crash the window limit
	local count = 1
	while meters[meterName .. count].isMeter() do
		local 	sFeed = meters[meterName .. count]
				sFeed.MeterStyle = meterStyle
				sFeed.update()

		if sFeed.Y < iScrollBarBotAnchor.Y then
			table.insert(maxFeedList, sFeed)
			
			count = count + 1 
		else 
			break 
		end
	end

	-- hide all again 
	for index = 1, (count - 1), 1 do
		local sFeed = meters[meterName .. index]
		
		sFeed.hide()
		sFeed.update()
	end

	meters.redraw()

	getMaxFeedMeterList = function() return maxFeedList end

	return maxFeedList
end

-- An Entry is a section/entry/item of a feed most times found by parsing <entry></entry> etc
-- @return count number
function getMaxEntryCount()
	local meters = Meters
	local variables = Variables
	local count = 1
	while meters['sEntryTitle' .. count].isMeter() do count = count + 1 end
	count = math.min(count - 1, variables.Cols * variables.Rows)

	getMaxEntryCount = function() return count end

	return count
end


-- ====================================================================================================
-- LOGIC
-- ====================================================================================================
-- @param index number : -1 reset all, 0 update, > 0 new link marker
function setLinkMarker(index)
	local linkMarkerIndex = -1

	setLinkMarker = function(_index_)
		-- only mdify the link marker if wanted
		if _index_ > 0 then linkMarkerIndex = _index_ end

		-- reset all others back to transparent
		for i, feedMeter in pairs(getMaxFeedMeterList()) do
			if linkMarkerIndex - SCROLL_OFFSET == i and _index_ ~= -1 then
				feedMeter.SolidColor = '#ColorHighHover#'
			else
				feedMeter.SolidColor = '#Transparent#'
			end

			feedMeter.update()
		end

		Meters.redraw()
	end
	
	setLinkMarker(index)
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

function shiftOnePageInCategory(direction)
	shiftCategory(direction * #getMaxFeedMeterList())
end

-- @param offset number
-- @return void
function shiftCategory(offset)
	local meters = Meters
	local currentCategory = meters.sCategorySelectorText.Text
	local iScrollbarBarArea = meters.iScrollbarBarArea
	local iScrollBarTopAnchor = meters.iScrollBarTopAnchor
	local iScrollBarBotAnchor = meters.iScrollBarBotAnchor
	local maxFeedCount = #getMaxFeedMeterList()
	local feedListOfCategory = SORTED_URL_LIST[currentCategory]
	local config = Variables.CURRENTCONFIG
	local parserName = SELF:GetName()

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

	local lowBound = SCROLL_OFFSET + 1
	local highBound = math.min(maxFeedCount + SCROLL_OFFSET, feedCount)
	for index = lowBound, highBound, 1 do
		local sFeed = 'sFeed' .. (index - SCROLL_OFFSET)
		local meter = meters[sFeed]

		meter.Text = feedListOfCategory[index].id
		meter.LeftMouseUpAction = 
			'[!SetOption "'..sFeed..'" "FontColor" "#ColorLowDefault#" "#CURRENTCONFIG#"] '..
			'[!UpdateMeter "'..sFeed..'" "#CURRENTCONFIG#"] '..
			'[!Redraw "#CURRENTCONFIG#"] '..
			'[!CommandMeasure "'..parserName..'" "onLeftMouseUpActionFeedLink(\''..feedListOfCategory[index].url..'\', '..index..')" "#CURRENTCONFIG#"]'
		meter.update()
	end

	setLinkMarker(0)

	meters.redraw()
end

-- ====================================================================================================
-- RENDERING
-- ====================================================================================================
-- @param category string
function renderCategory(category)
	local maxFeedCount = #getMaxFeedMeterList()
	local meters = Meters
	local iScrollbarBarArea = meters.iScrollbarBarArea
	local iScrollBarTopAnchor = meters.iScrollBarTopAnchor
	local iScrollBarBotAnchor = meters.iScrollBarBotAnchor
	local sCategorySelectorText = meters.sCategorySelectorText
	local feedListOfCategory = SORTED_URL_LIST[category]
	local config = Variables.CURRENTCONFIG
	local parserName = SELF:GetName()

	-- reset offset and linkmarker
	SCROLL_OFFSET = 0
	setLinkMarker(-1)

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
			'[!CommandMeasure "'..parserName..'" "onLeftMouseUpActionFeedLink(\''..feed.url..'\', '..index..')" "'..config..'"]'
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

-- renders an entry list
-- @param entryList {{title, link, cont, img}}
function renderEntryList(entryList)
	local meters, measures = Meters, Measures
	local maxEntryCount = getMaxEntryCount()
	local stopPoint = 0
	local imageCount = 0
	
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

			imageCount = imageCount + 1

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

	measures.mImageDownloadProgress.MaxValue = imageCount

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

-- I/O TO SCRIPT
-- ==================================================
function onChangeActionSearchFeedDownloader()
	local filePath = Measures.mSearchFeedDownloader:GetStringValue()

	-- resume work if no file was created
	if filePath == "" then onFinishActionSearchFeedDownloader() end
end

function onFinishActionCategoryFeedDownloader()
	local filePath = Measures.mCategoryFeedDownloader:GetStringValue()
	local rawFeed = FileReader(filePath)
	local entryList = FeedParser(rawFeed, getMaxEntryCount())

	renderEntryList(entryList)
end

-- @param url string : url of the clicked feed
-- @param index number : the index of the link clicked to idenftify  on which Feed you currently are
function onLeftMouseUpActionFeedLink(url, index)
	local measures = Measures
	local meters = Meters
	local mImageDownloadProgress = measures.mImageDownloadProgress
	local mCategoryFeedDownloader = measures.mCategoryFeedDownloader
	local sFeed = meters['sFeed' .. (index - SCROLL_OFFSET)]

	-- render link marker
	setLinkMarker(index)

	sFeed.update()
	meters.redraw()
	
	mImageDownloadProgress.Formula = 0
	mImageDownloadProgress.update()

	mCategoryFeedDownloader.Disabled = 0
	mCategoryFeedDownloader.Url = url
	mCategoryFeedDownloader.forceUpdate()
end

function onFinishActionSearchFeedDownloader()
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

end -- local Parser