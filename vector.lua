
local vector = {}
vector.__index = vector


function vector.zero( len )
   local v = {}
   for i = 1, len do
      v[i] = 0
   end
   return vector.new( v )
end

function vector.isvector( v )
   return getmetatable( v ) == vector
end

function vector:__tostring( parensQ )
   parensQ = parensQ or true   
   local res = ''
   if parensQ then res = '( ' end
   res = res .. table.concat( self, ', ' )
   if parensQ then res = res .. ')' end
   return res
end

function vector:clone()
   local tmp = table.pack( table.unpack( self ) )
   return vector.new( tmp )
end

function vector.__unm(a)
   for i = 1, #a do
      a[i] = -a[i]
   end
end

function vector.__add(a,b)
   assert(vector.isvector(a) and vector.isvector(b), "Add: wrong argument types (<vector> expected)")
   assert( #a == #b, "Add: wrong argument lengths (same dim expected)")
   local sum = {}
   for i = 1, #a do
      sum[i] = a[i] + b[i]
   end
   return vector.new( sum )
end

function vector.__sub(a,b)
   assert( vector.isvector(a) and vector.isvector(b), "Add: wrong argument types (<vector> expected)")
   assert( #a == #b, "Add: wrong argument lengths (same dim expected)")
   local dif = {}
   for i = 1, #a do
      dif[i] = a[i] - b[i]
   end
   return vector.new( dif )
end

local function scalarMult( s, v )
   local res = {}
   for i = 1, #v do
      table.insert( res, s * v[i] )
   end
   return vector.new( res )
end

local function dotProd( v1, v2 )
   assert( #v1 == #v2, "Add: wrong argument lengths (same dim expected)")
   local res = 0
   for i = 1, #v1 do
      res = res + v1[i] * v2[i]
   end
   return res
end



function vector.__mul(a,b)
   if type(a) == "number" and vector.isvector(b) then
      return scalarMult( a, b )
   elseif type(b) == "number" and vector.isvector(a) then
      return scalarMult( b, a )
   else
      assert(vector.isvector(a) and vector.isvector(b), "Mul: wrong argument types (<vector> or <number> expected)")
      return dotProd( a, b )
   end
end

function vector.__div(a,b)
        assert(vector.isvector(a) and type(b) == "number", "wrong argument types (expected <vector> / <number>)")
        return scalarMult( 1 / b , a )
end

function vector.__eq(a,b)
   if #a ~= #b then return false end
   local res = true
   for i = 1, #a do
      res = res and ( a[i] == b[i] )
   end
   return res
end

function vector:len()
   local sqs = 0
   for _, x in ipairs( self ) do
      sqs = sqs + x * x
   end
   return math.sqrt( sqs )
end

function vector.random( l, max )
   local lst = {}
   for i = 1, l do
      table.insert( lst, randSign() * math.random( max ) )
   end
   return vector.new( lst )
end

function vector.randomNonNeg( l, max )
   local lst = {}
   for i = 1, l do
      table.insert( lst, math.random( max ) )
   end
   return vector.new( lst )
end

function vector:tolatex()
   return [[ (\,]] .. self:__tostring() .. [[\,)]]
end


-- return setmetatable({new = new, isvector = isvector, zero = zero,
-- 		     random = random, randomNonNeg = randomNonNeg },
-- {__call = function(_, ...) return new(...) end})

function vector.new( lst )
   return setmetatable( lst, vector)
end

return vector
