function Initialize()
	T_PAT_CUSTOM = {
		ftb = "H:\\Games\\MultiMC\\MultiMC.exe";
		yt = "http://www.youtube.com/feed/subscriptions";
		lol = "H:\\Games\\League of Legends\\lol.launcher.admin.exe";
		palemoon = "H:\\Programme\\PaleMoon\\palemoon.exe";
		commit = "C:\\Users\\Minh\\Documents\\Rainmeter\\Skins\\gitMinimalCommit.bat";
		push = "C:\\Users\\Minh\\Documents\\Rainmeter\\Skins\\gitMinimalPush.bat";
		tag = "C:\\Users\\Minh\\Documents\\Rainmeter\\Skins\\gitMinimalTag.bat";
		version = "C:\\Users\\Minh\\Documents\\Rainmeter\\Skins\\gitMinimalVersionBumb.bat";
	}

	T_PAT_SEARCH = {
		g = "http://google.com/search?q=%$";
		w = "http://google.com/search?q=wiki %$";
		i = "https://www.google.com/search?num=10&site=imghp&tbm=isch&q=%$";
	}
	
	PAT_IS_CUSTOM = '^%a+ *'
	PAT_IS_SEARCH = '^%?'
	PAT_IS_ONLINE_1 = '^www'
	PAT_IS_ONLINE_2 = '^http'

	PAT_CUSTOM = '^(%a+) *'
	PAT_SEARCH = '^%?(%a+) *(.*)$'
end

function Run(input)
	-- catch invalid input
	if not input then return end

	-- is custom input
	if isCustom(input) then
		local keyword = string.match(input, PAT_CUSTOM)
		local value = T_PAT_CUSTOM[keyword]

		print(value)
		if value then SKIN:Bang(value) end

	-- is a search
	elseif isSearch(input) then
		local keyword, params = string.match(input, PAT_SEARCH)
		local value = T_PAT_SEARCH[keyword] or ""
		
		-- replace all whitespace with %20
		value = string.gsub(value, '%%%$', params)
		value = string.gsub(value, ' ', '%%20')

		if value ~= "" then SKIN:Bang(value) end

	-- is a webpage
	elseif isOnline(input) then
		SKIN:Bang(input)

	-- is a direct command
	elseif isDirect(input) then
		SKIN:Bang(input)
	end
end

-- ==================================================
-- is the input a custom command?
function isCustom(input)
	local keyword = string.match(input, PAT_IS_CUSTOM)
	local value = T_PAT_CUSTOM[keyword]

	return value and true or false
end

-- is the input a search?
function isSearch(input)
	local keyword = string.match(input, PAT_IS_SEARCH)
	
	return keyword and true or false
end

-- is the input a webpage?
function isOnline(input)
	local keyword1 = string.match(input, PAT_IS_ONLINE_1)
	local keyword2 = string.match(input, PAT_IS_ONLINE_2)

	return (keyword1 or keyword2) and true or false
end

-- is a direct command?
function isDirect(input)
	return true
end