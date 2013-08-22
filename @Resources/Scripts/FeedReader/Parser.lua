-- TODO database on update
function Initialize()
	-- Libs
	Meters, Measures, Variables = dofile(SKIN:GetVariable('@').."Scripts\\libs\\InterfaceOOPAccess.lua")(SKIN)
	PrettyPrint = dofile(Variables['@'].."Scripts\\Libs\\PrettyPrint.lua")
	FeedParser = dofile(Variables['@'].."Scripts\\Libs\\FeedParser.lua")
	FileReader = dofile(Variables['@'].."Scripts\\Libs\\FileReader.lua")
	
	-- -- Database
	local feedList = dofile(Variables['@'].."Scripts\\FeedReader\\FeedList.lua")

	-- SORTED_URL_LIST[category][id/url] = value
	local sortedFeedList, categoryOrder = sortFeedList(feedList)
	SORTED_URL_LIST = sortedFeedList
	
	prepareCategories(categoryOrder)
	prepareEntries()

	SCROLL_OFFSET = 0
	LOAD_PROCESS = 0
	MAX_PROCESS = 0

	-- test
	-- local uri = 'H:\\Data\\Downloads\\cupcakequeen.xml'
	-- local rawFeed = FileReader(uri)
	-- local entryList = FeedParser(rawFeed, getEntryCount())

	-- displayFeed(entryList)
end

-- Gives all entries the left and rightclick properties
-- TODO algin elements in future
function prepareEntries()
	local maxEntryCount = getMaxEntryCount()
	local config = Variables.CURRENTCONFIG
	local hide = function(index)
		return 
			'[!HideMeter "sEntryTitle'.. index ..'" "'.. config ..'"]' ..
			'[!HideMeter "iEntryImage'.. index ..'" "'.. config ..'"]' ..
			'[!Redraw "'.. config ..'"]'
	end

	local show = function(index)
		return 
			'[!ShowMeter "sEntryTitle'.. index ..'" "'.. config ..'"]' ..
			'[!ShowMeter "iEntryImage'.. index ..'" "'.. config ..'"]' ..
			'[!Redraw "'.. config ..'"]'
	end

	for index = 1, maxEntryCount, 1 do
		Meters['sEntryTitle' .. index].LeftMouseUpAction = hide(index)
		Meters['iEntryImage' .. index].LeftMouseUpAction = hide(index)
		Meters['sEntryDesc' .. index].LeftMouseUpAction = show(index)
	end
end

-- get maximal count of the feeds
-- @return count number
function getMaxFeedCount()
	local count = 1

	while Meters['sFeed' .. count].isMeter() do

		Meters['sFeed' .. count].MeterStyle = 'yFeedItem'
		Meters['sFeed' .. count].update()

		if Meters.iScrollBarBotAnchor.Y > Meters['sFeed' .. count].Y then count = count + 1 else break end
	end

	for i = 1, count - 1, 1 do
		Meters['sFeed' .. count].hide()
		Meters['sFeed' .. count].update()
	end

	Meters.redraw()

	getMaxFeedCount = function()
		return count - 1
	end

	return count - 1
end

-- An Entry is a section/entry/item of a feed most times found by parsing <entry></entry> etc
-- @return count number
function getMaxEntryCount()
	local count = 1
	while Meters['sEntryTitle' .. count].isMeter() do
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

	return sortedResult, categoryOrder
end

-- @param categories {string}
function prepareCategories(categories)

	for i, category in pairs(categories) do
		-- break loop if too many categories
		if i > getMaxFeedCount() then break end
		
		Meters['sCategorySelectorDropdown' .. i].MeterStyle = 'yCategorySelectorDropdown'
		Meters['sCategorySelectorDropdown' .. i].Text = category
		Meters['sCategorySelectorDropdown' .. i].LeftMouseUpAction = '[!CommandMeasure "mParser" "displayCategory(\''.. category ..'\')" "#CURRENTCONFIG#"]'
		Meters['sCategorySelectorDropdown' .. i].update()
	end

	Meters.redraw()
end

-- @param category string
function displayCategory(category)
	-- reset offset
	SCROLL_OFFSET = 0

	-- change scrollbar size
	Meters.iScrollbarBarArea.Y = Meters.iScrollBarTopAnchor.Y
	Meters.iScrollbarBarArea.H = (Meters.iScrollBarBotAnchor.Y - Meters.iScrollBarTopAnchor.Y) * math.min(getMaxFeedCount() / #SORTED_URL_LIST[category], 1)
	Meters.iScrollbarBarArea.update()

	-- write onto meter
	Meters.sCategorySelectorText.Text = category
	Meters.sCategorySelectorText.update()

	local stopPoint = 0
	for index, feed in pairs(SORTED_URL_LIST[category]) do

		-- not enough _meters to display
		if index > getMaxFeedCount() then break end

		Meters['sFeed' .. index].show()
		Meters['sFeed' .. index].Text = feed.id
		Meters['sFeed' .. index].LeftMouseUpAction = '[!SetOption "sFeed' .. index..'" "FontColor" "#ColorLowDefault#" "'..Variables.CURRENTCONFIG..'"] [!UpdateMeter "sFeed' .. index..'" "'..Variables.CURRENTCONFIG..'"] [!Redraw "'..Variables.CURRENTCONFIG..'"] [!SetOption "mWebParser" "Disabled" "0"] [!SetOption "mWebParser" "Url" "'.. feed.url ..'" "'.. Variables.CURRENTCONFIG ..'"] [!CommandMeasure "mWebParser" "Update" "'.. Variables.CURRENTCONFIG ..'"]'
		Meters['sFeed' .. index].update()

		stopPoint = index
	end

	-- clear old feeds
	stopPoint = stopPoint + 1
	while Meters['sFeed' .. stopPoint].isMeter() and stopPoint < getMaxFeedCount() do
		Meters['sFeed' .. stopPoint].hide()
		Meters['sFeed' .. stopPoint].update()

		stopPoint = stopPoint + 1
	end

	Meters.toggleGroup('DropDown')
	Meters.redraw()
end

function shiftOnePageInCategory(direction)
	shiftCategory(direction * getMaxFeedCount())
end

-- @param offset number
-- @return void
function shiftCategory(offset)
	local currentCategory = Meters.sCategorySelectorText.Text

	-- just ignore if no category is selected
	if not SORTED_URL_LIST[currentCategory] then return end
	
	local feedCount = #SORTED_URL_LIST[currentCategory]

	-- check if it can even offset more
	local newOffset = math.max(0, math.min(SCROLL_OFFSET + offset, feedCount - getMaxFeedCount()))
	if SCROLL_OFFSET == newOffset then return end

	SCROLL_OFFSET = newOffset
		
	-- change scrollbar position
	Meters.iScrollbarBarArea.Y = Meters.iScrollBarTopAnchor.Y + SCROLL_OFFSET * (Meters.iScrollBarBotAnchor.Y - Meters.iScrollBarTopAnchor.Y) / feedCount
	Meters.iScrollbarBarArea.update()

	---[[
	for index = SCROLL_OFFSET + 1, feedCount, 1 do 
		local iString = 'sFeed' .. (index - SCROLL_OFFSET)

		if (index - SCROLL_OFFSET) > getMaxFeedCount() then break end

		Meters[iString].show()
		Meters[iString].Text = SORTED_URL_LIST[currentCategory][index].id
		Meters[iString].LeftMouseUpAction = '[!SetOption "'..iString..'" "FontColor" "#ColorLowDefault#" "'..Variables.CURRENTCONFIG..'"] [!UpdateMeter "'..iString..'" "'..Variables.CURRENTCONFIG..'"] [!Redraw "'..Variables.CURRENTCONFIG..'"] [!SetOption "mWebParser" "Disabled" "0"] [!SetOption "mWebParser" "Url" "'.. SORTED_URL_LIST[currentCategory][index].url ..'" "'.. Variables.CURRENTCONFIG ..'"] [!CommandMeasure "mWebParser" "Update" "'.. Variables.CURRENTCONFIG ..'"]'
		Meters[iString].update()
	end
	--]]

	Meters.redraw()
end

function onFinishActionWebParser()
	local filePath = Measures.mWebParser:GetStringValue()

	local rawFeed = FileReader(filePath)
	local entryList = FeedParser(rawFeed, getMaxEntryCount())

	displayFeed(entryList)
end

function onFinishActionImageParser()
	displayDownloadProgress()
end

function displayDownloadProgress()
	LOAD_PROCESS = LOAD_PROCESS - 1

	local left = Meters.iLoadBarLeftAnchor.X
	local right = Meters.iLoadBarRightAnchor.X
	local maxWidth = right - left

	Meters.iLoadBar.W = maxWidth - LOAD_PROCESS / MAX_PROCESS * maxWidth
	Meters.iLoadBar.update()
	Meters.redraw()
end

-- @param entryList {{title, link, cont, img}}
function displayFeed(entryList)

	local stopPoint = 0
	local process = 0
	local maxEntryCount = getMaxEntryCount()
	MAX_PROCESS = 0
	LOAD_PROCESS = 0
	Meters.iLoadBar.W = 0
	Meters.iLoadBar.update()
	Meters.redraw()

	for index, entry in pairs(entryList) do
		if index > maxEntryCount then break end

		Meters['sEntryTitle' .. index].Text = entry.title
		Meters['sEntryTitle' .. index].show()
		Meters['sEntryTitle' .. index].update()

		Meters['sEntryDesc' .. index].Text = entry.cont
		Meters['sEntryDesc' .. index].RightMouseUpAction = entry.link
		Meters['sEntryDesc' .. index].show()
		Meters['sEntryDesc' .. index].update()
		
		Meters['iEntryImage' .. index].show()

		if Measures['mEntryImageReader' .. index].isMeasure() and entry.img then
			process = process + 1
			LOAD_PROCESS = LOAD_PROCESS + 1
			Meters['iEntryImage' .. index].MeasureName = 'mEntryImageReader' .. index
			Measures['mEntryImageReader' .. index].Url = entry.img
			Measures['mEntryImageReader' .. index].Disabled = 0
			Measures['mEntryImageReader' .. index].forceUpdate()
		else
			Meters['iEntryImage' .. index].MeasureName = ""
			Meters['iEntryImage' .. index].update()
		end

		stopPoint = index
	end

	MAX_PROCESS = process

	-- clear everything which isnt used
	stopPoint = stopPoint + 1
	while Meters['sEntryTitle' .. stopPoint].isMeter() do
		Meters['sEntryTitle' .. stopPoint].hide()
		Meters['sEntryDesc' .. stopPoint].hide()
		Meters['iEntryImage' .. stopPoint].hide()

		stopPoint = stopPoint + 1
	end

	Meters.redraw()
end