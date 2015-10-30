local assert={}
--TODO: Fix returns
--TODO: Clean up code
function assert.assert(value,message,level)
	if not value then
		error(value,message or "Assertion failed",(level or 0)+1)
	end
	return value
end

function assert.type(value,typ,message,level)
	if type(value)~=typ then
		error(message or "Assertion failed",(level or 0)+1)
	end
	return value
end

function assert.many_m(...)
	local message,i="Assertion failed at arg #%d",1
	if #arg%2~=0 then
		i,message=2,arg[1]
	end
	for j=i,#arg do
		if not arg[j] then
			error(message:format(j),2)
		end
	end
	return select(i,...)
end

function assert.many_l(...)
	local level,i=1,1
	if #arg%2~=0 then
		i,level=2,arg[1]
	end
	for j=i,#arg do
		if not arg[j] then
			error("Assertion failed at arg #"..j,level+1)
		end
	end
	return select(i,...)
end

function assert.types_l(...)
	local level,i,ret=1,1,{}
	if #arg%2~=0 then
		i,level=2,arg[1]
	end
	for j=i,#arg,2 do
		if type(arg[j])~=arg[j+1] then
			error("Assertion failed at arg #"..j,level+1)
		end
		ret[j-i+1]=arg[j]
	end
	return unpack(ret)
end

function assert.types_m(...)
	local level,i,ret=1,1,{}
	if #arg%2~=0 then
		i,level=2,arg[1]
	end
	for j=i,#arg,2 do
		if type(arg[j])~=arg[j+1] then
			error("Assertion failed at arg #"..j,level+1)
		end
		ret[j-i+1]=arg[j]
	end
	return unpack(ret)
end

return assert