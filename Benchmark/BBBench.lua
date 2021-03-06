--Basic Benchmarking Boilerplate
local T,D,t,i,OverheadSpeed,OverheadCost=os.time,(arg or {...})[1] or D or 60, {}
local Results = {}
local CurrentTestName, CurrentSubtestName, CurrentTestResults

print("Cycle length:",D)

print"Dry run (overhead)"
-- **Calc benchmark overhead**
i=0
t=T()+D
while T()<t do
	i=i+1
end
OverheadSpeed=D/i
OverheadCost=i/D
print("\tSpeed:",OverheadSpeed)
print("\tCost:",OverheadCost)

local function Test (name)
	if CurrentTestName then
		print("FINISHED:", CurrentTestName)
	end
	CurrentTestName=name
	Results[name]={}
	CurrentTestResults=Results[name]
	print("TESTING:", name)
end

local function SubTest (name)
	print("\tsubtest:",name)
	CurrentSubtestName=name
end

local function Result()
	CurrentTestResults[CurrentSubtestName]={Speed=i/D-OverheadSpeed,Cost=D/i-OverheadCost}
	print("\tSpeed:",i/D-OverheadSpeed)
	print("\tCost:",D/i-OverheadCost)
end

-- **START BENCHMARKS**
Test"LUA_MATH"


SubTest"sin"
local f=math.sin
i=0
t=T()+D
while T()<t do
	i=i+1
	f(123.456)
end
Result()


SubTest"sin"
local f=math.cos
i=0
t=T()+D
while T()<t do
	i=i+1
	f(123.456)
end
Result()


SubTest"unitrandom"
local f=math.random
i=0
t=T()+D
while T()<t do
	i=i+1
	f()
end
Result()
