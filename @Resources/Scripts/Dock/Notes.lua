-- upon creaation
function Initialize()
	-- Opens up Rainmeter.ini and stores it in a global variable
	local __rm_dir = SKIN:GetVariable('SETTINGSPATH')
	RM_PATH = __rm_dir .. "Rainmeter.ini"

	updateConfig()

	-- Getting Names of Notes
	CFG = SKIN:GetVariable('CURRENTCONFIG')
end

-- on each update
function Update()

end

-- re-reads the config file cause maybe it has changed
function updateConfig()
	local __file = io.open(RM_PATH, "r")

	CONTENT = __file:read('*all')

	io.close(__file)
end

-- checks if config of note X is active
function isNoteActive(iterator)
	local gmatch_note = CFG .. '\\Note' .. iterator .. '.%cActive=(%d)'
	local result = string.match(CONTENT, gmatch_note) or 0

	return tonumber(result)
end

function isNoteEmpty(iterator)
	local note_path = SKIN:GetVariable('CURRENTPATH') .. "Note" .. iterator .. "\\note.txt"
	local note = io.open(note_path, "r")
	local content = note:read("*all")
	io.close(note)

	return string.len(content) == 3
end

function getNextInactiveNoteIndex()
	local iterator = 0
	local isActive = 0

	repeat
		iterator = iterator + 1
		isActive = isNoteActive(iterator)
	until isActive == 0

	return iterator
end

function getNextInactiveEmptyNoteIndex()
	local iterator = 0

	repeat
		iterator = iterator + 1
	until isNoteActive(iterator) == 0 and isNoteEmpty(iterator) or iterator == 10

	return iterator
end

-- function 

-- called by user
function Activate()
	updateConfig()

	local noteIndex = getNextInactiveNoteIndex()
	SKIN:Bang('!ActivateConfig ' .. CFG .. '\\Note' .. noteIndex)
end

function OpenNextEmptyNote()
	updateConfig()

	local index = getNextInactiveEmptyNoteIndex()
	SKIN:Bang('!ActivateConfig ' .. CFG .. '\\Note' .. index)
end