local FeedParser do
	-- APPLIES A GIVEN CONVERTTABLE ONTO INPUTSTRING
	-- @input: String string
	-- @output: String string
	function StringReplaceByTable(string)
		-- USED GLOBAL FUNCTIONS
		local char = string.char
		local gsub = string.gsub

		-- CONVERT TABLE
		local generalConvertTable = {
			[char(226,128,153)] = char(39), -- '
			[char(226,128,147)] = char(150), -- thinkline
			[char(226,128,156)] = '', -- bottom "
			[char(226,128,142)] = '',
			[char(226,128,158)] = '', -- bot "
			[char(226,128,140)] = '', -- top "
		}
		
		-- ITERATE THROUGH ALL ENTRIES AND REPLACE
		for k,v in pairs(generalConvertTable) do
			string = gsub(string, k, v)
		end
		
		-- CONVERT TABLE
		generalConvertTable = {
			[char(195,164)] = char(228), -- auml
			[char(195,182)] = char(246), -- ouml
			[char(195,188)] = char(252), -- uuml
			[char(195,132)] = char(196), -- Auml
			[char(195,150)] = char(214), -- Ouml
			[char(195,156)] = char(220), -- Uuml
			[char(195,159)] = char(223), -- sz
			[char(195,32)] = char(32), -- space
			[char(195,169)] = char(233), -- e tegue
			[char(226,128)] = char(147), -- top "
			[char(195,168)] = char(232), -- e grave
			[char(194)] = '', -- space
			['&auml;'] = char(228), 
			['&ouml;'] = char(246), 
			['&uuml;'] = char(252), 
			['&Auml;'] = char(196), 
			['&Ouml;'] = char(228), 
			['&Uuml;'] = char(214), 
			['&szlig;'] = char(220), 
			['&amp;'] = char(38), 
			['&lt;'] = char(60), 
			['&gt;'] = char(62), 
			['&nbsp;'] = char(32), 
			['&(%w-);'] = '',
		}
		
		-- ITERATE THROUGH ALL ENTRIES AND REPLACE
		for k,v in pairs(generalConvertTable) do
			string = gsub(string, k, v)
		end

		-- SOLE FUNCTION TO REPLACE LUA REPRESENTATION
		string = gsub(string,"&#(%d+);", function(c) local num = tonumber(c) if 0 <= num and num <= 255 then return char(num) else return "" end end)

		-- RESULT
		return string
	end -- StringReplaceByTable

	-- RSS
	-- ==================================================
	-- @param entry string
	-- @return _ string
	function getRSSTitle(entry) 
		return string.match( entry, '<title.->(.-)</title>' ) or "(no title)"
	end

	-- @param entry string
	-- @return _ string
	function getRSSLink(entry)
		return string.match( entry, '<link.->(.-)</link>' ) or "(no link)"
	end

	-- @param entry string
	-- @return content string
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

	-- @param entry string
	-- @return image string
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
	-- @param entry string
	-- @return _ string
	function getAtomTitle(entry)
		return string.match( entry, '<title.->(.-)</title>' ) or "(no title)"
	end

	-- @param entry string
	-- @return _ string
	function getAtomLink(entry)
		return string.match(entry, "<link.-href=[\"'](.-)[\"']") or "(no link)"
	end

	-- @param entry string
	-- @return content string
	function getAtomContent(entry)
		local content = 
		string.match( entry, '<summary.->(.-)</summary>' ) or
		string.match( entry, '<content.->(.-)</content>' ) or
		"(no content)"

		-- REMOVE HTML TAGS, UTF OUT OF CONTENT AND SHORTEN IT
		content = string.gsub(content, '<.->', '')
		content = string.sub(content, 0, 425)

		return content
	end

	-- @param entry string
	-- @return _ string
	function getAtomImage(entry)
		return string.match(entry, "<img.-src=[\"'](.-)[\"']")
	end

	-- @param rawFeed String
	-- @return parsedEntries table of {title, link, cont, img}
	function FeedParser(rawFeed, maxEntryCount)
		local parsedEntries = {}

		-- RSS
		for entry in string.gmatch(rawFeed, '<item.->(.-)</item>') do
			entry = StringReplaceByTable(entry)
			table.insert(parsedEntries, {
				title = getRSSTitle(entry);
				link = getRSSLink(entry);
				cont = getRSSContent(entry);
				img = getRSSImage(entry);
			})
			if #parsedEntries > maxEntryCount then break end
		end

		-- ATOM
		for entry in string.gmatch(rawFeed, '<entry.->(.-)</entry>') do
			entry = StringReplaceByTable(entry)
			table.insert(parsedEntries, {
				title = getAtomTitle(entry);
				link = getAtomLink(entry);
				cont = getAtomContent(entry);
				img = getAtomImage(entry);
			})
			if #parsedEntries > maxEntryCount then break end
		end

		return parsedEntries
	end
end

return FeedParser