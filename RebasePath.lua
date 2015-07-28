--TODO: add redirections to accomodate common repository paths
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
  local Target = opt.target or '../Libs/'
  local Separator = Path:sub ( 1, 1 )
  local BaseSafe = Escape ( Base )
  local SeparatorSafe = Escape ( Separator )
  local PathPattern = '[^' .. SeparatorSafe ..']+'
  
  local Rebaser
  local mode = opt.mode
  if mode == 'append' then
    function Rebaser ( path )
      return path:gsub ( BaseSafe, Target ) .. Separator .. path
    end
  elseif mode == 'replace' or mode == 'new' then
    function Rebaser ( path )
      return path:gsub ( BaseSafe, Target )
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