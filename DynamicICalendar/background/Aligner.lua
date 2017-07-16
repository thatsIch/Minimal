-- upon creaation
-- called even disabled
function Initialize()
	local workareawidth = SKIN:GetVariable("SCREENAREAWIDTH")
	local DayWidth = SKIN:GetVariable("DayWidth")
	local DaySpacing = SKIN:GetVariable("DaySpacing")

	local count = getTotalCount()
	local RealSpacing = ((workareawidth - count * (DayWidth + DaySpacing) - DaySpacing) / 2)

	SKIN:GetMeter("AlignmentDummyImageMeter"):SetX(RealSpacing)
	SKIN:Bang('!UpdateMeter', '*', SKIN:GetVariable('CURRENTCONFIG'))
end

function getTotalCount()
	local count = 0
	local elem = ""

	repeat
		count = count + 1
		elem = SKIN:GetMeter('mD'.. count ..'Date')
	until not elem

	return (count - 1)
end