--TODO: add redirections to accomodate common repository paths
--[[--
  Returns a modified version of a pacakge path string
  @param table|nil opt a table with options
  options:
    path: package path to use, defaults to pacakge.path
    target: the new path component to use
    base: search for this in paths, interpreted as a string pattern, defaults to './'
    limit: limit number of substitutions to this number, defaults to 1
    mode: defaults to 'replace'
      append: mix the original and the rebased in place
      replace: replace base in place
      new: return only the modified paths
]]
return function ( opt )
  opt = opt or {}
  
  local function Escape ( str )
    return str:gsub (
      '%W',
      function ( c )
        return '%' .. c
      end
    )
  end
  
  local Path = opt.path or package.path
  local Base = opt.base or './'
  local Target = assert ( opt.target, 'No target given' )
  local Limit = opt.limit or 1
  local Separator = Path:sub ( 1, 1 )
  local BaseSafe = Escape ( Base )
  local SeparatorSafe = Escape ( Separator )
  local PathPattern = '[^' .. SeparatorSafe ..']+'
  
  local Rebaser
  local mode = opt.mode or 'replace'
  if mode == 'append' then
    function Rebaser ( path )
      return path:gsub ( BaseSafe, Target, Limit ) .. Separator .. path
    end
  elseif mode == 'replace' or mode == 'new' then
    function Rebaser ( path )
      return path:gsub ( BaseSafe, Target, Limit )
    end
  end
  
  if mode == 'new' then
    local newPaths, i = {}, 1
    for path in Path:gmatch ( PathPattern ) do
      newPaths [ i ], i = Rebaser ( path ), i + 1
    end
    return Separator .. table.concat ( newPaths, Separator )
  else
    return Path:gsub (
      PathPattern,
      Rebaser
    )
  end
end