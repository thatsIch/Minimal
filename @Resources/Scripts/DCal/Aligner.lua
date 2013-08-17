-- upon creaation
-- called even disabled
function Initialize()
	local workareawidth = SKIN:GetVariable("WORKAREAWIDTH")
	local DayWidth = SKIN:GetVariable("DayWidth")
	local DaySpacing = SKIN:GetVariable("DaySpacing")

	local dummy = SKIN:GetMeter("mDummy")

	local RealSpacing = ((workareawidth % (DayWidth + DaySpacing)) / 2)

	dummy:SetX(RealSpacing)
end

-- on each update
-- shouldnt be called
function Update()

end
