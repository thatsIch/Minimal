-- upon creaation
function Initialize()
	-- Opens up Rainmeter.ini and stores it in a global variable
	local __rm_dir = SKIN:GetVariable('SETTINGSPATH')
	RM_PATH = __rm_dir .. "Rainmeter.ini"
	local __file = io.open(RM_PATH)

	CONTENT = __file:read('*all')

	io.close(__file)

	-- Getting Names of Notes
	CFG = SKIN:GetVariable('CURRENTCONFIG')
end

-- on each update
function Update()

end

-- re-reads the config file cause maybe it has changed
function updateConfig()
	local __file = io.open(RM_PATH)

	CONTENT = __file:read('*all')

	io.close(__file)
end

-- checks if config of note X is active
function isNoteActive(iterator)
	local gmatch_note = CFG .. '\\Note' .. iterator .. '.%cActive=(%d)'
	local result = string.match(CONTENT, gmatch_note) or 0

	return tonumber(result)
end

-- called by user
function Activate()
	updateConfig()

	local iterator = 0
	local isActive = 0

	repeat
		iterator = iterator + 1
		isActive = isNoteActive(iterator)
	until isActive == 0

	SKIN:Bang('!ActivateConfig ' .. CFG .. '\\Note' .. iterator)
end