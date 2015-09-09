error'not yet implemented'
--TODO: unfinished function!!!
--Creates a metatable that combines other metatables
return function ( ... )
  local ret = {}
  for i, mt in ipairs {...} do
    for key, method in pairs ( mt ) do
      if type ( method ) == 'function' or type ( getmetatable ( method ).__call ) == 'function' then
        local kt = ret [ key ]
        if not kt then
          kt = {}
          ret [ key ] = kt
        end
      end
    end
  end
end
