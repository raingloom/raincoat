--[[--
	A relational 2D transform library.
]]
local Transform = setmetatable ( {}, require"Raincoat.Mt.Class" )
local Objects = {}
--setmetatable ( Objects, require"Raincoat.Mt.Weak" )
Transform.__index = Transform

Transform.Objects = Objects--debug access


function Transform:__tostring ( )
	return string.format (
		"transform id(%d) offset({%f,%f},%f) global({%f,%f},%f) parentId(%d)",
		self.id,
		self.position.x, self.position.y,		 self.radian,
	self.globalPosition.x, self.globalPosition.y,		 self.globalRadian,
		self.parent and self.parent.id or 0
	)
end


function Transform.New ( position, radian, parent )
	local id = #Objects + 1
	local ret = setmetatable (
		{
			id = id,
			position = assert ( position, "No position given" ),
			radian = radian or 0,
			parent = false,
			children = {},
		},
		Transform
	)
	ret.globalPosition = ret.position
	ret.globalRadian = ret.radian
	Objects [id] = ret
	if parent then
		ret:SetParent ( parent )
	end
	return ret
end


--[[--
	Traverses all offsprings and calls a function on all
	Function paramaters: ( Transform self, Transform parent, ... )
		self: the child on which the function is called
		parent: the parent that propagated the function
	@param function func the function to be called
	@param ... optional arguments that `func` will take
	@see RecurseAncestors
]]
function Transform:RecurseOffsprings ( func, ... )
	local children = self.children
	if children then
		for child in pairs ( children ) do
			func ( child, self, ... )
			child:RecurseOffsprings ( func, ... )
		end
	end
end


--[[--
	Traverses all ancestors and calls a function on all of them
	Function parameters: ( Transform self, Transform child, ... )
		self: the parent
		child: the child that propagated the function
	@param function func the function to be called
	@param ... optional arguments that `func` will take
	@see RecurseOffsprings
]]
function Transform:RecurseAncestors ( func, ... )
	local parent = self.parent
	if parent then
		func ( parent, self, ... )
		parent:RecurseAncestors ( func, ... )
	end
end



function Transform:SetParent ( parent, norefresh )
	local prev = self.parent
	if prev then
		prev.children [ self ] = nil
	end
	self.parent = parent
	if parent then
		parent.children [ self ] = true
	end
	if not norefresh then
		self:Refresh ( )
	end
	return parent
end


function Transform:SetPosition ( position, norefresh )
	self.position = position
	if not norefresh then
		self:Refresh ( )
		self:RecurseOffsprings (
			function ( child )
				child:Refresh ( )
			end
		)
	end
end


function Transform:SetRadian ( radian, norefresh )
	self.radian = radian
	if not norefresh then
		self:Refresh ( )
		self:RecurseOffsprings (
			function ( child )
				child:Refresh ( )
			end
		)
	end
end


function Transform:Refresh ( )
	local parent = self.parent
	if parent then
		local parentRadian = parent.radian
		self.globalPosition = parent.globalPosition + self.position:rotate ( parentRadian )
		self.globalRadian = self.radian + parentRadian
	end
end


function Transform:RefreshChildren ( )
	self:RecurseOffsprings (
		function ( child )
			child:Refresh ( )
		end
	)
end


return Transform