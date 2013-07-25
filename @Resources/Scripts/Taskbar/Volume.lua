function Initialize()
	volume = 0
end

function Update()
	volume = SKIN:GetMeasure("measureVolume")
	volume = volume:GetValue()

	if volume < 0 then
		SKIN:Bang('!SetOption', 'meterImageVolume', 'ImageName', '#@#Images\\Taskbar\\VolMute.png')
	elseif volume < 26 then
		SKIN:Bang('!SetOption', 'meterImageVolume', 'ImageName', '#@#Images\\Taskbar\\Vol0.png')
	elseif volume < 51 then
		SKIN:Bang('!SetOption', 'meterImageVolume', 'ImageName', '#@#Images\\Taskbar\\Vol1.png')
	elseif volume < 76 then
		SKIN:Bang('!SetOption', 'meterImageVolume', 'ImageName', '#@#Images\\Taskbar\\Vol2.png')
	elseif volume < 101 then
		SKIN:Bang('!SetOption', 'meterImageVolume', 'ImageName', '#@#Images\\Taskbar\\Vol3.png')
	end
end