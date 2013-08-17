-- once at startup
function Initialize()
	local totalWidth = SKIN:GetVariable("SCREENAREAWIDTH")
	local onePercent = totalWidth / 100

	local iterator = 1
	local element = SKIN:GetMeter("iBarMouseInteraction" .. iterator)
	local startPos = element:GetX() 
	local currPos = startPos
	local nextPos = startPos + round(iterator * onePercent)
	local currWidth = nextPos - currPos

	while element do
		-- modify current element
		element:SetX(currPos)
		element:SetW(currWidth)

		-- inc pc and get next element
		iterator = iterator + 1
		element = SKIN:GetMeter("iBarMouseInteraction" .. iterator)

		-- calculates new values
		currPos = currPos + currWidth
		nextPos = startPos + round(iterator * onePercent)
		currWidth = nextPos - currPos
	end
end

-- basic round function
function round(num)
	return math.ceil(num - 0.5)
end