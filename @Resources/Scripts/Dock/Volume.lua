function Initialize()
	volume = 0
end

function Update()
	volume = SKIN:GetMeasure("measureVolume"):GetValue()

	if volume < 0 then
		SKIN:Bang('!SetOption', 'mIcon', 'ImageName', '#@#Images\\Dock\\VolMute.png')
	elseif volume < 26 then
		SKIN:Bang('!SetOption', 'mIcon', 'ImageName', '#@#Images\\Dock\\Vol0.png')
	elseif volume < 51 then
		SKIN:Bang('!SetOption', 'mIcon', 'ImageName', '#@#Images\\Dock\\Vol1.png')
	elseif volume < 76 then
		SKIN:Bang('!SetOption', 'mIcon', 'ImageName', '#@#Images\\Dock\\Vol2.png')
	elseif volume < 101 then
		SKIN:Bang('!SetOption', 'mIcon', 'ImageName', '#@#Images\\Dock\\Vol3.png')
	end

	SKIN:Bang('!UpdateMeter', 'mIcon', '#CURRENTCONFIG#')
	SKIN:Bang('!Redraw', '#CURRENTCONFIG#')
end