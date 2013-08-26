local FeedSorter do

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
end

return sortFeedList