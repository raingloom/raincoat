local limits = {}

do--find largest integer
  local a, p = 1, 0
  local n = 0
  while p < a do
    p = a
    a = a << 1
    n = n + 1
  end
  limits.maxint = p
end

return limits
