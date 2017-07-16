local exports = {}

local libspath = SKIN:GetVariable('CURRENTPATH').."parser\\" 
local Meters, Measures, Variables = dofile(libspath .. "InterfaceOOPAccess.lua")(SKIN)
local DateTime = dofile(libspath .. "datetime.lua")

-- displays the percentage progression of the loading process
local function updateLoadProgression()
	Meters.mD1Date.Text = Meters.mD1Date.Text .. "."
	Meters.mD1Date.update()
end
exports.updateLoadProgression = updateLoadProgression

local function renderEvents(events)
	local dayIterator, elemIterator = 0, 1
	local sMeterDate, sMeterBar, sMeterInfo = "", "", ""

	local lastDate = 0

	-- used to differentiate the styles for near events
	local today = DateTime(DateTime(true):getdate())
	local tomorrow = today:copy()
	tomorrow:adddays(1)

	for id, entry in pairs(events) do

		-- check if a new day started
		if lastDate ~= entry.start then
			-- clear all MeterBar and MeterInfo after this one
			while Meters['mD'.. dayIterator ..'E' .. elemIterator .. 'Bar'].isMeter() do
				sMeterBar = Meters['mD'.. dayIterator ..'E' .. elemIterator .. 'Bar']
				sMeterInfo = Meters['mD'.. dayIterator ..'E' .. elemIterator .. 'Info']

				sMeterInfo.MeterStyle = "sEInfoDefault"
				sMeterInfo.Text = ""
				sMeterInfo.update()
				
				sMeterBar.SolidColor = "00000000"
				sMeterBar.update()

				elemIterator = elemIterator + 1
			end

			lastDate = entry.start
			dayIterator = dayIterator + 1
			elemIterator = 1

			sMeterDate = Meters['mD' .. dayIterator .. 'Date']

			if sMeterDate.isMeter() then
				-- check for today and tomorrow display
				if entry.start == today then
					sMeterDate.MeterStyle = "sDateToday"
				elseif entry.start == tomorrow then 
					sMeterDate.MeterStyle = "sDateTomorrow"
				else 
					sMeterDate.MeterStyle = "sDateDefault"
				end

				sMeterDate.Text = entry.header
				sMeterDate.update()
			else
				break
			end
		end

		sMeterBar = Meters['mD'.. dayIterator ..'E' .. elemIterator .. 'Bar']
		sMeterInfo = Meters['mD'.. dayIterator ..'E' .. elemIterator .. 'Info']

		if sMeterInfo.isMeter() and sMeterBar.isMeter() then

			sMeterInfo.MeterStyle = "sEInfoHighlight"
			sMeterInfo.Text = entry.displayText
			-- sMeterInfo.LeftMouseUpAction = entry.link
			sMeterInfo.ToolTipText = entry.tooltip or ""
			sMeterInfo.update()

			sMeterBar.SolidColor = entry.color
			sMeterBar.update()

			elemIterator = elemIterator + 1
		end
	end

	Meters.redraw()
end
exports.renderEvents = renderEvents

return exports