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
  local Base = opt.Base or './'
  local Rebase = opt.Rebase or '../Libs/'
  local Separator = Path:sub ( 1, 1 )
  local BaseSafe = Escape ( Base )
  local RebaseSafe = Escape ( Rebase )
  local SeparatorSafe = Escape ( Separator )

  local Rebaser
  if opt.Append or opt.Append == nil then
    function Rebaser ( path )
      return path:gsub ( BaseSafe, Rebase ) .. Separator .. path
    end
  else
    function Rebaser ( path )
      return path:gsub ( BaseSafe, Rebase )
    end
  end

  return Path:gsub (
    '[^' .. SeparatorSafe ..']+',
    Rebaser
end