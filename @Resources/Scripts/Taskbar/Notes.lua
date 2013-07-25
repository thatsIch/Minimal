function Initialize()

end

function Update()

end

function Activate()
	local iterator = 0
	local currentNote = ""

	repeat
		iterator = iterator + 1
		currentNote = SKIN:GetVariable("Minimal\\Notes\\Note"..iterator)
		-- SKIN:Bang('!Log', iterator..': ' .. currentNote)
	until currentNote == "inactive" or not currentNote
	-- SKIN:Bang('!Log', '!WriteKeyValue Variables Minimal\\Notes\\Note'..iterator..' active "#@#Meters\\Taskbar\\Apps.inc"')
	SKIN:Bang('!WriteKeyValue Variables Minimal\\Notes\\Note'..iterator..' active "#@#Meters\\Taskbar\\Apps.inc"')
	SKIN:Bang('!ActivateConfig Minimal\\Notes\\Note'..iterator..' note.ini')
end