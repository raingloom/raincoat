local map = {}



debug.sethook (
	function ( t, ln )
		if t == "line" then
			map [ ln ] = ( map [ ln ] or 0 ) + 1
		end
	end,
	"l"
)

do
	require"Benchmark.scimark"
end

debug.sethook ()
print"////HEATMAP/////"
local revmap = {}
for k,v in pairs(map) do
	print ( k, v )
	revmap[v] = k
end
