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

	CATEGORY_ORDER = {}

	-- SORTED_URL_LIST[category][id/url] = value
	SORTED_URL_LIST = sortFeedUrlList(feedUrlList)

	displayCategories(CATEGORY_ORDER)
	
	-- test
	local uri = 'H:\\Data\\Downloads\\cupcakequeen.xml'
	local feed = getFileContent(uri)
end

function sortFeedUrlList(rawList)
	local sortedResult = {}
	local tempAlphaSorted = {}

	-- pre-arrange the list
	for _, feed in pairs(rawList) do

		local category, identifier, url, pinned = feed[1], feed[2], feed[3], feed[4]

		if not sortedResult[category] then 
			sortedResult[category] = {}
			tempAlphaSorted[category] = {}

			-- remember order of categories
			table.insert(CATEGORY_ORDER, category)
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

	return sortedResult
end

function displayCategories(categories)

	for i, category in pairs(categories) do
		-- break loop if too many categories
		if not isMeter('sCategorySelectorDropdown' .. i) then break end

		setMeterStyle('sCategorySelectorDropdown' .. i, 'yCategorySelectorDropdown')
		setMeterText('sCategorySelectorDropdown' .. i, category)
		setMeterLeftClick('sCategorySelectorDropdown' .. i, '[!CommandMeasure "mParser" "displayCategory(\''.. category ..'\')" "#CURRENTCONFIG#"]')
		updateMeter('sCategorySelectorDropdown' .. i)
	end

	redraw()
end

-- string: category (eg 'News')
function displayCategory(category)

	-- clear old feeds
	local iterator = 1
	while isMeter('sFeed' .. iterator) do
		hideMeter('sFeed' .. iterator)
		iterator = iterator + 1
	end

	-- write onto meter
	setMeterText('sCategorySelectorText', category)
	updateMeter('sCategorySelectorText')

	for index, feed in pairs(SORTED_URL_LIST[category]) do
		-- not enough meters to display
		if not isMeter('sFeed' .. index) then break end

		showMeter('sFeed' .. index)
		setMeterText('sFeed' .. index, feed.id)
		setMeterLeftClick('sFeed' .. index, '[!SetOption "mWebParser" "Disabled" "0"] [!SetOption "mWebParser" "Url" "'.. feed.url ..'" "'.. getCurrentConfig() ..'"] [!CommandMeasure "mWebParser" "Update" "'.. getCurrentConfig() ..'"]')
		updateMeter('sFeed' .. index)
	end

	toggleMeterGroup('DropDown')
	redraw()
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
function redraw() SKIN:Bang('!Redraw', getCurrentConfig()) end
function getEntryCount() return getVar('FeedReaderColCount') * getVar('FeedReaderRowCount') end

-- VARIABLES
-- ==================================================
function getVar(var) return SKIN:GetVariable(var) end
function getCurrentConfig() return getVar('CURRENTCONFIG') end

-- METERS
-- ==================================================
function getMeter(meter) return SKIN:GetMeter(meter) end
function setMeterOption(meter, option, value) SKIN:Bang('!SetOption', meter, option, value, getCurrentConfig()) end
function setMeterText(meter, text) setMeterOption(meter, 'Text', text) end
function hideMeter(meter) SKIN:Bang('!HideMeter', meter, getCurrentConfig()) end
function showMeter(meter) SKIN:Bang('!ShowMeter', meter, getCurrentConfig()) end	
function updateMeter(meter) SKIN:Bang('!UpdateMeter', meter, getCurrentConfig()) end
function isMeter(meter) return getMeter(meter) and true or false end
function setMeterLeftClick(meter, action) setMeterOption(meter, 'LeftMouseUpAction', action) end
function setMeterStyle(meter, style) setMeterOption(meter, 'MeterStyle', style) end
function toggleMeterGroup(group) SKIN:Bang('!ToggleMeterGroup', group, getCurrentConfig()) end

-- MEASURES
-- ==================================================
function getMeasure(measure) return SKIN:GetMeasure(measure) end
function setMeasureOption(measure, option, value) SKIN:Bang('!SetOption', measure, option, value, getCurrentConfig()) end
function enableMeasure(measure)	setMeasureOption(measure, 'Disabled', 0) end
function disableMeasure(measure) setMeasureOption(measure, 'Disabled', 1) end
