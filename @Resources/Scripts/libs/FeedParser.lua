local FeedParser do
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

		-- REMOVE HTML TAGS OUT OF CONTENT AND SHORTEN IT
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
			table.insert(parsedEntries, {
				-- title = StringReplaceByTable(getRSSTitle(entry));
				title = getRSSTitle(entry);
				link = getRSSLink(entry);
				-- cont = StringReplaceByTable(getRSSContent(entry));
				cont = getRSSContent(entry);
				img = getRSSImage(entry);
			})
			if #parsedEntries > maxEntryCount then break end
		end

		-- ATOM
		for entry in string.gmatch(rawFeed, '<entry.->(.-)</entry>') do
			table.insert(parsedEntries, {
				-- title = StringReplaceByTable(getAtomTitle(entry));
				title = getAtomTitle(entry);
				link = getAtomLink(entry);
				-- cont = StringReplaceByTable(getAtomContent(entry));
				cont = getAtomContent(entry);
				img = getAtomImage(entry);
			})
			if #parsedEntries > maxEntryCount then break end
		end

		return parsedEntries
	end
end

return FeedParser