function Initialize()
	volume = 0
end

function Update()
	volume = SKIN:GetMeasure("Volume"):GetValue()

	if volume < 0 then
		SKIN:Bang('!SetOption', 'Indicator', 'ImageName', 'mute.png')
	elseif volume < 26 then
		SKIN:Bang('!SetOption', 'Indicator', 'ImageName', 'silent.png')
	elseif volume < 51 then
		SKIN:Bang('!SetOption', 'Indicator', 'ImageName', 'low.png')
	elseif volume < 76 then
		SKIN:Bang('!SetOption', 'Indicator', 'ImageName', 'middle.png')
	elseif volume < 101 then
		SKIN:Bang('!SetOption', 'Indicator', 'ImageName', 'high.png')
	end

	SKIN:Bang('!UpdateMeter', 'Indicator', '#CURRENTCONFIG#')
	SKIN:Bang('!Redraw', '#CURRENTCONFIG#')
end