local function generator ( buffer, env )
	local code, i = { 'return coroutine.wrap ( function ( ... )' }, 2
	local format = string.format
	local lines = buffer.lines
	for line in (lines and lines(buffer) or buffer:gmatch"[^\n]+") do
	local prepScript = line:match '^%s*#(.*)'
		if prepScript then
			code [ i ], code [ i + 1 ], i = prepScript, '\n', i + 2
		else
			local lastStart, lastEnd = 0, 0
	  for posStart, posEnd in line:gmatch '()$%b()()' do
		code [ i ], i = format ( 'coroutine.yield %q;coroutine.yield ( %s );', line:sub ( lastEnd, posStart - 1), line:sub ( posStart + 2, posEnd - 2 ) ), i + 1
		lastEnd = posEnd
	  end
	  code [ i ], i = format ( 'coroutine.yield ( %q )\ncoroutine.yield "\\n"\n', line:sub ( lastEnd ) ), i + 1
		end
	end
	code [ i ] = 'end )'
  code = table.concat ( code )
	local f = loadstring ( code )
	if env then
		setfenv ( f, env )
	end
	return f
end

--TODO: figure a way out for passing parameters to the generator
local function preProcess ( buffer, ... )
  local processed, i = {}, 1
	for bite in assert ( generator ( buffer ) ) ( ... ) do
		processed [ i ], i = bite, i + 1
	end
	return table.concat ( processed )
end

return {
  generator = generator,
  preProcess = preProcess,
  process = function ( str, ... )
    return (loadstring or load) (preProcess ( str, ... ))
  end,
}
