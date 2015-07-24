local nl={
  '\n' = '\\n',
  '\v' = '\\v',
  '\t' = '\\t',
}

---Formats a string so that it can be represented on a single line, with all non-printable characters escaped
-- @param string s the string to be escaped
-- @return string the escaped string
local function escape ( s )
  return ("%q"):format(s:gmatch("[\n\v\t]",nl))
end

return escape