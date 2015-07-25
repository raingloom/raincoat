--- A 2D relational transform library
local Transform = setmetatable ( {}, require"Raincoat.Mt.Class" )
local Objects = setmetatable ( {}, require"Raincoat.Mt.Weak" )
Transform.__index = Transform

Transform.Objects = Objects--debug access


function Transform:__tostring ()
  return string.format ( "Transform(%s): position:{%f,%f} angle:%f parent.id:%s", self.id, self.position.x, self.position.y, self.angle, self.parent and self.parent.id or "none" )
end


function Transform.New ( position, angle, parent )
  local id = #Objects + 1
  local ret = setmetatable (
    {
      id = id,
      position = assert ( position, "No position given" ),
      angle = angle or 0,
      parent = parent or false,
      children = {},
    },
    Transform
  )
  ret.globalPosition = ret.position
  ret.globalAngle = ret.angle
  Objects [id] = ret
  if parent then
    parent.children [ ret ] = true
    ret:Refresh()
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



function Transform:SetParent ( parent )
  local prev = self.parent
  if prev then
    prev.children [ self ] = nil
  end
  self.parent = parent
  if parent then
    parent.children [ self ] = true
  end
  return parent
end


function Transform:SetPosition ( position )
  self.position = position
  self:Refresh ( )
  self:RecurseOffsprings (
    function ( child )
      child:Refresh ( )
    end
  )
end


function Transform:SetAngle ( angle )
  self.angle = angle
  self:Refresh ( )
  self:RecurseOffsprings (
    function ( child )
      child:Refresh ( )
    end
  )
end


function Transform:Refresh ( )
  local parent = self.parent
  local angle = parent.angle
  self.globalPosition = parent.position + self.position:rotate ( angle )
  self.globalAngle = self.angle + angle
end




return Transform