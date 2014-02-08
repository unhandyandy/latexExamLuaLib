
local fraction = {}
fraction.__index = fraction

local function checkFraction( fr )
   local check =  fr.denom ~= 0 and fr.numer == math.floor( fr.numer ) and fr.denom == math.floor( fr.denom )
   assert( check, 'Fraction check failed!' )
   return check
end

function fraction.one()
   return fraction.new( 1, 1 )
end

function fraction.isfraction( m )
   return getmetatable( m ) == fraction 
end

function fraction:__tostring()
   local sgn = ''
   if self.sign < 0 then sgn = '-' end
   if self.numer == 0 then 
      return '0' 
   elseif self.denom == 1 then
      return string.format( '%s%d', sgn, self.numer )
   else
      return string.format( '%s%d/%d', sgn, self.numer, self.denom )
   end
end

function fraction:clone()
   return fraction.new( self.sign * self.numer, self.denom )
end

function fraction.__unm( fr )
   local res = fr:clone()
   res.sign = -res.sign
   return res
end

local function addFractions( f1, f2 )
   local newdenom = f1.denom * f2.denom
   local newnumer = f1.sign * f1.numer * f2.denom + f2.sign * f2.numer * f1.denom
   return fraction.new( newnumer, newdenom )
end

function fraction.__add( f1, f2 )
   if fraction.isfraction( f1 ) then
      if fraction.isfraction( f2 ) then
	 return addFractions( f1, f2 )
      else
	 local newfr = fraction.new( f2, 1 )
	 return addFractions( f1, newfr )
      end
   else 
      return fraction.__add( f2, f1 )
   end
end

function fraction.__sub( f1, f2 )
   return fraction.__add( f1, -f2 )
end

local function multFractions( f1, f2 )
   return fraction.new( f1.sign * f1.numer * f2.sign * f2.numer,
			f1.denom * f2.denom )
end

function fraction.__mul( f1, f2 )
     if fraction.isfraction( f1 ) then
      if fraction.isfraction( f2 ) then
	 return multFractions( f1, f2 )
      else
	 local newfr = fraction.new( f2, 1 )
	 return multFractions( f1, newfr )
      end
   else 
      return fraction.__mul( f2, f1 )
   end
end

function fraction.invert( fr )
   if fraction.isfraction( fr ) then
      local res = fr:clone()
      assert( res.numer ~= 0, 'Not invertible!' )
      res.numer, res.denom = res.denom, res.numer
      return res
   else
      return fraction.new( 1, fr )
   end
end
 
function fraction.__div( f1, f2 )
   return fraction.__mul( f1, fraction.invert( f2 ) )
end

function fraction.__eq( f1, f2 )
   return f1.sign * f1.numer * f2.denom == f2.sign * f2.numer * f1.denom
end

function fraction.__pow( fr, p )
   local res = fr:clone()
   res.sign, res.numer, res.denom = res.sign ^ p, res.numer ^ p, res.denom ^ p
   return res
end

function fraction:tolatex()
   if self.numer ~= 0 and self.denom ~= 1 then
      local tmpl = [[\frac{%s}{%s}]]
      return string.format( tmpl, self.numer, self.denom )
   else
      return self:__tostring()
   end
end


function fraction.new( n, d )
   local sign = 1
   if n * d < 0 then sign = -1 end
   local res = {}
   local numer, denom = math.floor( math.abs( n ) ), math.floor( math.abs( d ) )
   local cf = gcf( denom, numer )
   res.numer, res.denom = numer / cf, denom / cf
   res.sign = sign
   return setmetatable( res, fraction )
end

return fraction
