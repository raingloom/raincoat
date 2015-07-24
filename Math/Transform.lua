--- A 2D relational transform library
local Transform = setmetatable ( {}, require"Mt.Class" )
local Objects = setmetatable ( {}, require"Mt.Weak" )
Transform.__index = Transform


function Transform:__tostring ()
  return string.format ( "Transform#%s: (%s:%s) %s°", self.id, self.position.x, self.position.y, self.angle )
end


function Transform.New ( position, angle, parent )
  local id = #Objects + 1
  local ret = setmetatable (
    {
      id = id,
      position = assert ( position, "No position given" ),
      angle = angle or 0,
      parent = parent or false,
      children = false,
    },
    Transform
  )
  Objects [id] = ret
  return ret
end


---Traverses all offsprings and calls a function on all
-- Function paramaters: ( Transform self, Transform parent, ... )
--    self: the child on which the function is called
--    parent: the parent that propagated the function
-- @param function func the function to be called
-- @param ... optional arguments that `func` will take
-- @see RecurseAncestors
function Transform:RecurseOffsprings ( func, ... )
  local children = self.children
  if children then
    for child in pairs ( children ) do
      func ( child, self, ... )
      child:RecurseOffsprings ( func, ... )
    end
  end
end


---Traverses all ancestors and calls a function on all of them
-- Function parameters: ( Transform self, Transform child, ... )
--    self: the parent
--    child: the child that propagated the function
-- @param function func the function to be called
-- @param ... optional arguments that `func` will take
-- @see RecurseOffsprings
function Transform:RecurseAncestors ( func, ... )
  local parent = self.parent
  if parent then
    func ( parent, self, ... )
    parent:RecurseAncestors ( func, ... )
  end
end


return Transform