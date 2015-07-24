local nl={
  '\n' = '\\n',
  '\v' = '\\v',
  '\t' = '\\t',
}
return function ( s )
  return ("%q"):format(s:gmatch("[\n\v\t]",nl))
end