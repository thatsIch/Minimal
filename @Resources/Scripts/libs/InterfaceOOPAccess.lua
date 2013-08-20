return function(SKIN)
	local ms = {
		__index = function(table,key) 
			-- catch recursive call		
			if key == '__section' and #table < 2 then
				return

			elseif key == '__sectionname' and #table < 2 then
				return

			-- catch update()
			elseif key == 'update' and SKIN:GetMeasure(table.__sectionname) then 
				return function() SKIN:Bang('!UpdateMeasure',table.__sectionname, SKIN:GetVariable('CURRENTCONFIG')) end 

			-- catch forceUpdate()
			elseif key == 'forceUpdate' and SKIN:GetMeasure(table.__sectionname) then 
				return function() SKIN:Bang('!CommandMeasure',table.__sectionname, 'Update', SKIN:GetVariable('CURRENTCONFIG')) end 

			-- catch update()	
			elseif key == 'update' and SKIN:GetMeter(table.__sectionname) then 
				return function() SKIN:Bang('!UpdateMeter',table.__sectionname, SKIN:GetVariable('CURRENTCONFIG')) end 

			-- catch isMeter()
			elseif key == 'isMeter' then
				return function() return SKIN:GetMeter(table.__sectionname) and true or false end

			-- catch isMeter()
			elseif key == 'isMeasure' then
				return function() return SKIN:GetMeasure(table.__sectionname) and true or false end

			-- catch hide()
			elseif key == 'hide' and SKIN:GetMeter(table.__sectionname) then
				return function() SKIN:Bang('!HideMeter',table.__sectionname, SKIN:GetVariable('CURRENTCONFIG')) end

			-- catch show()
			elseif key == 'show' and SKIN:GetMeter(table.__sectionname) then
				return function() SKIN:Bang('!ShowMeter',table.__sectionname, SKIN:GetVariable('CURRENTCONFIG')) end

			-- catch Rainmeter Native Build-In functions
			-- Show, Hide, SetXYWH, GetXYWH, GetName, GetOption (though special case), Enable, Disable, GetValueRange, GetRelativeValue, GetMaxValue, 
			elseif table.__section[key] then 
				return function(...) return table.__section[key](table.__section,...) end 
			
			-- catch meter options
			elseif table.__section.GetOption then
				return table.__section:GetOption(key)

			-- catch measure options
			elseif table.__section.GetNumberOption then
				return (table.__section.GetNumberOption and table.__section:GetNumberOption(key,nil))
			
			-- unknown case
			else
				print('Unkown Section Case: ' .. key) 
				return
			end 
		end, 
		__newindex = function(table,key,value) SKIN:Bang('!SetOption',table.__sectionname,key,value,SKIN:GetVariable('CURRENTCONFIG')) end
	}
	local sections = {
		__index = function(table,key) 
			if key == 'redraw' then
				return function() SKIN:Bang('!Redraw', SKIN:GetVariable('CURRENTCONFIG')) end
			else
				sections[key] = {}

				-- store meter/measure
				sections[key].__section = SKIN:GetMeasure(key) or SKIN:GetMeter(key)
				
				-- store meter/measurename
				sections[key].__sectionname = key 
				setmetatable(sections[key],ms) 

				return sections[key]
			end
		end,
		isMeter = function(meter)
			return SKIN:GetMeter(meter) and true or false
		end,
		isMeasure = function(measure)
			return SKIN:GetMeasure(measure) and true or false
		end,
		toggleGroup = function(meterGroup)
			SKIN:Bang('!ToggleMeterGroup', meterGroup,SKIN:GetVariable('CURRENTCONFIG'))
		end
	}
	local variables = {
		__index = function(table,key) 

			-- catch variables.ReplaceVariables()
			if key == 'ReplaceVariables' then
				return function(param) return SKIN:ReplaceVariables(param) end

			-- catch variable			
			elseif SKIN:GetVariable(key) then
				return SKIN:GetVariable(key) 

			-- unknown case
			else 
				print('Unkown Variable Case: ' .. key)
				return
			end
		end, 
		__newindex = function(table,key,value) SKIN:Bang('!SetVariable',key,value, SKIN:GetVariable('CURRENTCONFIG')) end
	}
	setmetatable(variables,variables)
	setmetatable(sections,sections)

	return sections, sections, variables
end