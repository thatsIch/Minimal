local Parser do

-- TODO database on update
-- TODO loading bar for database
-- TODO mouse over scrollbar
-- TODO link marker of current feed
function Initialize()
	-- Libs
	Meters, Measures, Variables = dofile(SKIN:GetVariable('@').."Scripts\\libs\\InterfaceOOPAccess.lua")(SKIN)
	FeedParser = dofile(Variables['@'].."Scripts\\Libs\\FeedParser.lua")
	FileReader = dofile(Variables['@'].."Scripts\\Libs\\FileReader.lua")
	
	-- -- Database
	local feedList = dofile(Variables['@'].."Scripts\\FeedReader\\FeedList.lua")

	-- Debug
	-- PrettyPrint = dofile(Variables['@'].."Scripts\\Libs\\PrettyPrint.lua")

	-- run-once functions: prepare data and pre-render skin parts
	local sortedFeedList, categoryOrder = sortFeedList(feedList)
	prepareCategories(categoryOrder)
	prepareEntries()

	-- GLOBAL VARIABLES
	SORTED_URL_LIST = sortedFeedList
	SCROLL_OFFSET = 0
	LOAD_PROCESS = 0
	MAX_PROCESS = 0

	-- test
	-- local uri = 'H:\\Data\\Downloads\\cupcakequeen.xml'
	-- local rawFeed = FileReader(uri)
	-- local entryList = FeedParser(rawFeed, getEntryCount())
	-- renderEntryList(entryList)

	-- run-once function
	Initialize = nil
end

-- Gives all entries the left and rightclick properties
-- TODO algin elements in future
-- TODO dont forget to realign the bar
function prepareEntries()
	local meters = Meters
	local maxEntryCount = getMaxEntryCount()
	local config = Variables.CURRENTCONFIG


	local desc = meters.sEntryDesc1
	
	local originX, originY = desc.X, desc.Y
	local entryW, entryH, entryP = Variables.EntryWidth, Variables.EntryHeight, Variables.EntryPadding


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

	for index = 1, maxEntryCount, 1 do
		meters['sEntryTitle' .. index].LeftMouseUpAction = hide(index)
		meters['iEntryImage' .. index].LeftMouseUpAction = hide(index)
		meters['sEntryDesc' .. index].LeftMouseUpAction = show(index)
	end

	-- only run-once function
	prepareEntries = nil
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
	for i = 1, count - 1, 1 do
		local sFeed = meters['sFeed' .. count]
		
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
	local count = 1
	while meters['sEntryTitle' .. count].isMeter() do
		count = count + 1
	end
	count = math.min(count - 1, Variables.Cols * Variables.Rows)

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


	for i, category in pairs(categories) do
		-- break loop if too many categories
		if i > maxFeedCount then break end

		local sCategorySelectorDropdown = meters['sCategorySelectorDropdown' .. i]
		sCategorySelectorDropdown.MeterStyle = 'yCategorySelectorDropdown'
		sCategorySelectorDropdown.Text = category
		sCategorySelectorDropdown.LeftMouseUpAction = '[!CommandMeasure "mParser" "displayCategory(\''.. category ..'\')" "#CURRENTCONFIG#"]'
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

	-- reset offset
	SCROLL_OFFSET = 0

	-- change scrollbar size
	iScrollbarBarArea.Y = iScrollBarTopAnchor.Y
	iScrollbarBarArea.H = (iScrollBarBotAnchor.Y - iScrollBarTopAnchor.Y) * math.min(maxFeedCount / #feedListOfCategory, 1)
	iScrollbarBarArea.update()

	-- write onto meter
	sCategorySelectorText.Text = category
	sCategorySelectorText.update()

	local stopPoint = 0
	for index, feed in pairs(feedListOfCategory) do

		-- not enough _meters to display
		if index > maxFeedCount then break end

		local meter = meters['sFeed' .. index]
		meter.show()
		meter.Text = feed.id
		meter.LeftMouseUpAction = '[!SetOption "sFeed' .. index..'" "FontColor" "#ColorLowDefault#" "'..Variables.CURRENTCONFIG..'"] [!UpdateMeter "sFeed' .. index..'" "'..Variables.CURRENTCONFIG..'"] [!Redraw "'..Variables.CURRENTCONFIG..'"] [!SetOption "mWebParser" "Disabled" "0"] [!SetOption "mWebParser" "Url" "'.. feed.url ..'" "'.. Variables.CURRENTCONFIG ..'"] [!CommandMeasure "mWebParser" "Update" "'.. Variables.CURRENTCONFIG ..'"]'
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
			'[!SetOption "mWebParser" "Disabled" "0"] '..
			'[!SetOption "mWebParser" "Url" "'.. feedListOfCategory[index].url ..'" "'.. config ..'"] '..
			'[!CommandMeasure "mWebParser" "Update" "'.. config ..'"]'
		meter.update()
	end

	meters.redraw()
end



function renderDownloadProgress(progress)
	local mLoadBar = Measures.mLoadBar
	mLoadBar.Formula = progress
	mLoadBar.update()
end

-- renders an entry list
-- @param entryList {{title, link, cont, img}}
function renderEntryList(entryList)
	local meters = Meters
	local measures = Measures
	local stopPoint = 0
	local process = 0
	local maxEntryCount = getMaxEntryCount()
	MAX_PROCESS = 0
	LOAD_PROCESS = 0

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
			local mEntryImageReader = measures['mEntryImageReader' .. index]

			process = process + 1
			LOAD_PROCESS = LOAD_PROCESS + 1

			iEntryImage.MeasureName = 'mEntryImageReader' .. index
			mEntryImageReader.Url = entry.img
			mEntryImageReader.Disabled = 0
			mEntryImageReader.forceUpdate()
		else
			iEntryImage.MeasureName = ""
			iEntryImage.update()
		end

		stopPoint = index
	end

	MAX_PROCESS = process

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
function onFinishActionWebParser()
	local filePath = Measures.mWebParser:GetStringValue()
	local rawFeed = FileReader(filePath)
	local entryList = FeedParser(rawFeed, getMaxEntryCount())

	renderEntryList(entryList)
end

function onFinishActionImageParser()
	LOAD_PROCESS = LOAD_PROCESS - 1

	renderDownloadProgress(1 - LOAD_PROCESS / MAX_PROCESS )
end

end -- local Parser