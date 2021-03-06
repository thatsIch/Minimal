-- upon creation
function Initialize()
	-- Opens up Rainmeter.ini and stores it in a global variable
	local __rm_dir = SKIN:GetVariable('SETTINGSPATH')
	print("settings path: " .. __rm_dir)

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
	-- file reading is probably broken due to UTF16
	local __file = io.open(RM_PATH, "r")

	CONTENT = __file:read('*all')

	io.close(__file)
end

function fileExists(fileName)
	local f = io.open(fileName, "r")
	if f~=nil then io.close(f) return true else return false end
end

-- checks if config of note X is active
function isNoteInactive(iterator)
	print("note active: " .. iterator)

	local gmatch_note = CFG .. '\\Note' .. iterator .. '.%cActive=(%d)'
	print("content: " .. CONTENT)
	local result = tonumber(string.match(CONTENT, gmatch_note)) or 0
	print("result: " .. result)
	local inactive = result == 0

	print("inactive: " .. tostring(inactive))

	return inactive
end

function isNoteEmpty(iterator)
	local note_path = SKIN:GetVariable('CURRENTPATH') .. "Note" .. iterator .. "\\note.txt"
	print("note path: " .. note_path)
	if fileExists(note_path) then
		local note = io.open(note_path, "r")
		local content = note:read("*all")
		io.close(note)

		print("content length: " .. string.len(content))

		return string.len(content) == 3
	else
		print("creating note " .. iterator)
		local template = SKIN:GetVariable('CURRENTPATH') .. "Template"
		local new_note = SKIN:GetVariable('CURRENTPATH') .. "Note" .. iterator

		os.execute(string.format('robocopy "%s" "%s" note.ini note.txt', template, new_note))
		print("copied files")

		SKIN:Bang('!RefreshApp')

		return true
	end
end

function getNextInactiveNoteIndex()
	local iterator = 0
	local isInactive = false

	repeat
		iterator = iterator + 1
		isInactive = isNoteInactive(iterator)
	until isInactive

	return iterator
end

function getNextInactiveEmptyNoteIndex()
	local iterator = 0
	local isInactive = false
	local isEmpty = false

	repeat
		iterator = iterator + 1
		isInactive = isNoteInactive(iterator)
		isEmpty = isNoteEmpty(iterator)
	until isInactive and isEmpty

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