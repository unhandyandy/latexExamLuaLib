
-- from Wouter Scherphof, https://github.com/wscherphof/lua-set


local Set = {}
Set.mt = {__index = Set}
function Set:new(values)
  local instance = {}
  local isSet if getmetatable(values) == Set.mt then isSet = true end
  if type(values) == "table" then
    if not isSet and #values > 0 then
      for _,v in ipairs(values) do
        instance[v] = true
      end
    else
      for k in pairs(values) do
        instance[k] = true
      end
    end
  elseif values ~= nil then
    instance = {[values] = true}
  end
  return setmetatable(instance, Set.mt)
end

function Set:add(e)
  if e ~= nil then self[e] = true end
  return self
end

function Set:remove(e)
  if e ~= nil then self[e] = nil end
  return self
end

function Set:anelement()
  for e in pairs(self) do
    return e
  end
end

-- Union
Set.mt.__add = function (a, b)
  local res, a, b = Set:new(), Set:new(a), Set:new(b)
  for k in pairs(a) do res[k] = true end
  for k in pairs(b) do res[k] = true end
  return res
end

-- Subtraction
Set.mt.__sub = function (a, b)
  local res, a, b = Set:new(), Set:new(a), Set:new(b)
  for k in pairs(a) do res[k] = true end
  for k in pairs(b) do res[k] = nil end
  return res
end

-- Intersection
Set.mt.__mul = function (a, b)
  local res, a, b = Set:new(), Set:new(a), Set:new(b)
  for k in pairs(a) do
    res[k] = b[k]
  end
  return res
end

-- String representation
Set.mt.__tostring = function (set)
   local lst = set:tolist()
   local str = table.concat( lst, ',' )
   return '{' .. str .. '}'
end

function Set:len()
  local num = 0
  for _ in pairs(self) do
    num = num + 1
  end
  return num
end

function Set:tolist()
  local res = {}
  for k in pairs(self) do
    table.insert(res, k)
  end
  table.sort( res )
  return res
end


-- ajd

function Set:tolatex()
   local res = [[\{\,%s\,\}]]
   local lst = self:tolist()
   return string.format( res, table.concat( lst, ',' ) )
end

function Set:random()
   local res = Set:new()
   for k in pairs(self) do
      if randBool() then res[ k ] = true end
   end
   return res
end

function Set:subset( a )
   for k in pairs( self ) do
      if not a[ k ] then return false end
   end
   return true
end
 
function Set.mt.__eq( a, b )
   return b:subset( a ) and a:subset( b )
end

return Set
