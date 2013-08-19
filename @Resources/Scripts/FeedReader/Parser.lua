function Initialize()

	-- whole feed url list
	-- {category, identifier, url}
	-- eg {'Nachrichten', 'Spiegel Online', 'http://www.spiegel.de/schlagzeilen/tops/index.rss'},
	
	-- category: the cateroy the feed is saved under, can be choosen later on from the drop down menu
	-- identifier: displayed name of the link to the Feed
	-- url: url to the feed to be parsed

	FEED_URL_LIST = {
		{'Nachrichten', 'Spiegel Online', 'http://www.spiegel.de/schlagzeilen/tops/index.rss'},
		{'Backen', 'Cupcake Queen', 'http://cupcakequeen.de/feed/'},	
		{'Nachrichten', 'Die Welt', 'http://www.welt.de/?service=Rss'},
	}

	displayCategories()
end

function displayCategories()

	local categories = fetchCategories()

	setMeterText('sCategorySelectorText', categories[1])
	for i, category in pairs(categories) do
		-- break loop if too many categories
		if not isMeter('sCategorySelectorDropdown' .. i) then break end

		setMeterText('sCategorySelectorDropdown' .. i, category)
		setMeterStyle('sCategorySelectorDropdown' .. i, 'yFeedReaderCategorySelectorDropdown')
	end

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

function getMeter(meter)
	return SKIN:GetMeter(meter)
end

function setMeterText(meter, text)
	SKIN:Bang('!SetOption', meter, 'Text', text)
end

function isMeter(meter)
	return SKIN:GetMeter(meter) and true or false
end

function getVar(var)
	return SKIN:GetVariable(var)
end

function setMeterStyle(meter, style)
	SKIN:Bang('!SetOption', meter, 'MeterStyle', style)
end

function redraw()
	SKIN:Bang('!Redraw', getVar('CURRENTCONFIG'))
end

function printSet(set)
	for k,v in ipairs(set) do
		print(k .. ': ' .. v)
	end
end