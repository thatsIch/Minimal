-- once at startup
function Initialize()
	LEFT_DOWN = false
	RIGHT_DOWN = false
end

function LeftDownAction()
	LEFT_DOWN = true
end

function LeftUpAction(currentSection)
	LEFT_DOWN = false
	SetPos(currentSection)
end

function OverAction(currentSection)

	-- check for drag n drop for progression 
	if LEFT_DOWN then
		SetPos(currentSection)

	-- check for drag n drop for volume
	elseif RIGHT_DOWN then
		SetVol(currentSection)
	end

end

function RightDownAction()
	RIGHT_DOWN = true
end

function RightUpAction(currentSection)
	RIGHT_DOWN = false
	SetVol(currentSection)
end

function SetPos(currentSection)
	local index = string.match(currentSection, "(%d+)") or 0
	SKIN:Bang('!CommandMeasure "mPlayer" "SetPosition ' .. index .. '" "#CURRENTCONFIG#"')
	SKIN:Bang('!UpdateMeasure "mPlayer" "#CURRENTCONFIG#"')
	SKIN:Bang('!UpdateMeasure "mPosition" "#CURRENTCONFIG#"')
end

function SetVol(currentSection)
	local index = string.match(currentSection, "(%d+)") or 0
	SKIN:Bang('!CommandMeasure "mPlayer" "SetVolume ' .. index .. '" "#CURRENTCONFIG#"')
end