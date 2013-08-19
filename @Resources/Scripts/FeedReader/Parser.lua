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

	local categories = fetchCategories()
	displayCategories(categories)
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

	for k, v in pairs(merged) do
		print(v[2])
	end

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
		-- setMeterLeftClick('sFeed' .. index, '[!CommandMeasure "mParser" "displayCategory(\''.. category ..'\')" "#CURRENTCONFIG#"]')
		updateMeter('sFeed' .. index)
	end

	toggleMeterGroup('DropDown')
	redraw()
end

function fetchCategories()
	local categories = {}
	local usedCategories = {}
	local iterator = 1
	local category = ""
	
	-- fetch all categories
	for i, feed in pairs(FEED_URL_LIST) do
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

-- Parses the next feed
function parseNextFeed()

end

function displayCurrentFeed() 

end

function toggleMeterGroup(group)
	SKIN:Bang('!ToggleMeterGroup', group, getVar('CURRENTCONFIG'))
end

function getMeter(meter)
	return SKIN:GetMeter(meter)
end

function hideMeter(meter)
	SKIN:Bang('!HideMeter', meter, getVar('CURRENTCONFIG'))
end

function showMeter(meter)
	SKIN:Bang('!ShowMeter', meter, getVar('CURRENTCONFIG'))
end	

function setMeterText(meter, text)
	SKIN:Bang('!SetOption', meter, 'Text', text, getVar('CURRENTCONFIG'))
end

function updateMeter(meter)
	SKIN:Bang('!UpdateMeter', meter, getVar('CURRENTCONFIG'))
end

function isMeter(meter)
	return SKIN:GetMeter(meter) and true or false
end

function setMeterLeftClick(meter, action)
	SKIN:Bang('!SetOption', meter, 'LeftMouseUpAction', action, getVar('CURRENTCONFIG'))
end

function getVar(var)
	return SKIN:GetVariable(var)
end

function setMeterStyle(meter, style)
	SKIN:Bang('!SetOption', meter, 'MeterStyle', style, getVar('CURRENTCONFIG'))
end

function redraw()
	SKIN:Bang('!Redraw', getVar('CURRENTCONFIG'))
end

function printSet(set)
	for k,v in ipairs(set) do
		print(k .. ': ' .. v)
	end
end