-- upon creaation
-- called even disabled
function Initialize()
	local workareawidth = SKIN:GetVariable("WORKAREAWIDTH")
	local DayWidth = SKIN:GetVariable("DayWidth")
	local DaySpacing = SKIN:GetVariable("DaySpacing")

	local count = getTotalCount()
	local RealSpacing = ((workareawidth - count * (DayWidth + DaySpacing)) / 2)

	SKIN:GetMeter("mDummy"):SetX(RealSpacing)
end

-- on each update
-- shouldnt be called
function Update()

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