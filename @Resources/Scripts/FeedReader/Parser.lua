function Initialize()

	-- whole feed url list
	-- {category, identifier, url [, pin]}
	-- eg {'Nachrichten', 'Spiegel Online', 'http://www.spiegel.de/schlagzeilen/tops/index.rss'},
	
	-- category: the category the feed is saved under, can be choosen later on from the drop down menu
	-- identifier: displayed name of the link to the Feed
	-- url: url to the feed to be parsed
	-- pin (optionlal): if true it has higher priority and is as most top as possible

	FEED_URL_LIST = {
		{'Nachrichten', 'Spiegel Online', 'http://www.spiegel.de/schlagzeilen/tops/index.rss', true},
		{'Backen', 'Cupcake Queen', 'http://cupcakequeen.de/feed/'},	
		{'Nachrichten', 'Die Welt', 'http://www.welt.de/?service=Rss', true},
	}

	local sorted = sortFeedUrlList(FEED_URL_LIST)

	for category, feeds in pairs(sorted) do
		print("Kategorie: "..category)
		for index, feed in pairs(feeds) do
			print("Index: ".. index)
			for id, url in pairs(feed) do
				print(id .. ':' .. url)
			end
		end
	end
	-- print(sorted['Nachrichten'][1]['id'])

	-- local categories = fetchCategories()
	-- displayCategories(categories)
	local uri = 'H:\\Data\\Downloads\\cupcakequeen.xml'
	local feed = getFileContent(uri)
	-- print(parseRawFeed(feed)[2].title)
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
		end

		if pinned then
			table.insert(sortedResult[category], { id = identifier; url = url })
		else 
			table.insert(tempAlphaSorted[category], { id = identifier; url = url })
		end
	end

	-- sort all sorted lists


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

	setMeterText('sCategorySelectorText', categories[1])
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

function displayCategory(category)
	local pinned = {}
	local sorted = {}
	local merged = {}

	-- write category on top
	setMeterText('sCategorySelectorText', category)
	updateMeter('sCategorySelectorText')

	-- seperate pinned and sorted
	for index, feed in pairs(FEED_URL_LIST) do
		if #feed >= 3 and feed[1] == category then

			-- is pinned
			if #feed == 4 then
				table.insert(pinned, feed)
			else
				table.insert(sorted, feed)
			end
		end
	end

	-- sort alphabetically the sorted list
	table.sort(sorted, function(curr, next) return string.lower(curr[2]) < string.lower(next[2]) end)
	
	-- merge both tables again
	for _, feed in pairs(pinned) do table.insert(merged, feed) end
	for _, feed in pairs(sorted) do table.insert(merged, feed) end

	-- clear old feeds
	local iterator = 1
	while isMeter('sFeed' .. iterator) do
		hideMeter('sFeed' .. iterator)
		iterator = iterator + 1
	end

	-- write onto meter
	for index, feed in pairs(merged) do
		-- not enough meters to display
		if not isMeter('sFeed' .. index) then break end

		showMeter('sFeed' .. index)
		setMeterText('sFeed' .. index, feed[2])
		setMeterLeftClick('sFeed' .. index, '[!SetOption "mWebParser" "Disabled" "0"] [!SetOption "mWebParser" "Url" "'.. feed[3] ..'" "'.. getCurrentConfig() ..'"] [!CommandMeasure "mWebParser" "Update" "'.. getCurrentConfig() ..'"]')

		-- print('[!SetOption "mWebParser" "Url" "'.. feed[3] ..'" "#CURRENTCONFIG#"] [!UpdateMeasure "mParser" "#CURRENTCONFIG#"]')

		updateMeter('sFeed' .. index)
	end

	toggleMeterGroup('DropDown')
	redraw()
end

function displayFeed()
	local filePath = getMeasure('mWebParser'):GetStringValue()
	local rawFeed = getFileContent(filePath)

	-- print(content)
end

function parseRawFeed(rawFeed)
	if string.find(rawFeed, '<item') then
		return parseRSS(rawFeed)
	elseif string.find(rawFeed, '<entry') then
		return parseAtom(rawFeed)
	end
end

function getEntryCount()
	local x, y = getVar('FeedReaderColCount'), getVar('FeedReaderRowCount')
	x, y = tonumber(x), tonumber(y)

	return x * y
end

function parseRSS(rawFeed)
	local parsedEntries = {}
	local parsedEntry = {}

	-- INPUT DATA
	local i = 0
	for entry in string.gmatch(rawFeed, '<item.->(.-)</item>') do
		i = i + 1

		if i > getEntryCount() then break end

		parsedEntry = {
			title = getRSSTitle(entry);
			link = getRSSLink(entry);
			cont = getRSSContent(entry);
			img = getRSSImage(entry);
		}
		table.insert(parsedEntries, parsedEntry)
	end

	return parsedEntries
end


function parseAtom(rawFeed)
	local parsedEntries = {}
	local parsedEntry = {}

	-- INPUT DATA
	local i = 0
	for entry in string.gmatch(rawFeed, '<entry.->(.-)</entry>') do
		i = i + 1

		if i > getEntryCount() then break end

		parsedEntry = {
			title = getAtomTitle(entry);
			link = getAtomLink(entry);
			cont = getAtomContent(entry);
			img = getAtomImage(entry);
		}
		table.insert(parsedEntries, parsedEntry)
	end

	return parsedEntries				
end

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

function getFileContent(file)
	if not file then return end

	local handle = io.open(file)
	local content = handle:read('*all')
	io.close(handle)

	return content
end

function fetchCategories()
	local categories = {}
	local usedCategories = {}
	local category = ""
	
	-- fetch all categories
	for _, feed in pairs(FEED_URL_LIST) do
		-- check if correct feed
		if #feed >= 3 then
			category = feed[1]

			-- if not already inserted
			if not usedCategories[category] then
				usedCategories[category] = true
				table.insert(categories, category)
			end
		end
	end

	return categories
end


-- BASIC
-- ==================================================
function redraw() SKIN:Bang('!Redraw', getCurrentConfig()) end

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
