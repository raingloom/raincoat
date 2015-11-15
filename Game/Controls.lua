local Controls = {}


local controlCounters = {
		--controlName = uint
	}
local controlStates = {
		--controlName = boolean
	}
local key2control = {
		--keyName = controlName--to save on memory
		--keyName = {controlName1, ..., controlNameN}--to allow binding single key to multiple controls
	}

local keyStates = {
		--keyName = boolean
	}


local function updateControl( controlName, keyState )
	local counter = controlCounters[ controlName ] + (keyState and 1 or -1)
	controlCounters[ controlName ] = counter
	controlStates[ controlName ] = counter > 0
end

function Controls.updateKey( keyName, keyState )
	local control = key2control[ keyName ]
	if control then
		if type( control ) == 'table' then
			for i = 1, #control do
				updateControl( control[ i ], keyState )
			end
		else
			updateControl( control, keyState )
		end
	end
	keyStates[ keyName ] = keyState
end


function Controls.addKeyToControl( controlName, ... )
	local keyNames = {...}
	for i = 1, #keyNames do
		local keyName = keyNames[ i ]
		local control = key2control[ keyName ]
		local typ = type( control )
		if typ == 'table' then
			insert( control, keyName )
		elseif typ == 'nil' then
			key2control[ keyName ] = controlName
		else
			key2control[ keyName ] = { key2control[ keyName ], controlName }
		end
	end
	controlCounters[ controlName ] = controlCounters[ controlName ] or 0
end


function Controls.removeKeyFromControl( controlName, ... )
	local keyNames = {...}
	for i = 1, #keyNames do
		local keyName = keyNames[ i ]
		local control = key2control[ keyName ]
		local typ = type( control )
		if typ == 'table' then
			local len = #control
			for i = 1, len do
				if control[ i ] == controlName then
					table.remove( control, i )
					break
				end
			end
			--free up memory by converting single element sequnce into its only element
			if len == 2 then
				key2control[ keyName ] = control[ 1 ]
			end
		else
			key2control[ keyName ] = nil
		end
	end
end


function Controls.getControlKeys( controlName )
	local ret, reti = {}, 1
	for key, control in pairs( key2control ) do
		if control == controlName then
			ret[ reti ], reti = key, reti + 1
		else--only other thing it can be is a sequence
			for i = 1, #control do
				if control == controlName then
					ret[ reti ], reti = key, reti + 1
					break
				end
			end
		end
	end
	return ret
end


function Controls.setControlKeys( controlName, ... )
	Controls.removeKeyFromControl( controlName, (unpack or table.unpack)( Controls.getControlKeys( controlName ) ) )
	Controls.addKeyToControl( controlName, ... )
end



Controls.controls = controlStates
Controls.keys = keyStates


return Controls