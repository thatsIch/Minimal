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

function fileExists(fileName)
	local f = io.open(fileName, "r")
	if f~=nil then io.close(f) return true else return false end
end

-- checks if config of note X is active
function isNoteActive(iterator)
	local gmatch_note = CFG .. '\\Note' .. iterator .. '.%cActive=(%d)'
	local result = string.match(CONTENT, gmatch_note) or 0

	return tonumber(result)
end

function isNoteEmpty(iterator)
	local note_path = SKIN:GetVariable('CURRENTPATH') .. "Note" .. iterator .. "\\note.txt"
	if fileExists(note_path) then
		local note = io.open(note_path, "r")
		local content = note:read("*all")
		io.close(note)

		return string.len(content) == 3
	else
		print("creating note " .. iterator)
		local template = SKIN:GetVariable('CURRENTPATH') .. "Template"
		local new_note = SKIN:GetVariable('CURRENTPATH') .. "Note" .. iterator

		os.execute(string.format('robocopy "%s" "%s"', template, new_note))
		print("copied files")

		SKIN:Bang('!RefreshApp')

		return true
	end
end

-- function copy_file(src_file_path, dest_file_path)
-- 	local source = io.open(src_file_path, "r")
-- 	local content = source:read("*all")
-- 	io.close(source)

-- 	local dest = io.open(dest_file_path,"w")
-- 	dest:write(content)
-- 	io.close(dest)
-- end

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
	until isNoteActive(iterator) == 0 and isNoteEmpty(iterator)

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