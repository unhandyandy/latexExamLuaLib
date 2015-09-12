frc = require('fraction')
vec = require('vector')
st = require('sets')
mat = require('matrix')

local mathProblem = {}
mathProblem.mt = {__index = mathProblem}

mathProblem.mcP = true
mathProblem.template = [[What time is it?]]
mathProblem.numberChoices = 6
mathProblem.chcFun = [[\chcSix]]
mathProblem.subFun = 'table'

-- strmt = getmetatable( "" )
-- function strmt:tolatex()
--    return self 
--end

-- debug.setmetatable( 0, { tolatex = function( self )
--    return ('%s'):format( self )
-- 				   end } )

function mathProblem:mkchc( lst ) 
   return randPerm( distinctElems( self.numberChoices, lst ) )
end

function mathProblem:submaker() 
   return {}, {1,2,3,4,5,6}
end

-- local function mathTypeQ( x )
--    return mat.ismatrix( x ) or frc.isfraction( x ) or
--       vec.isvector( x ) or st.isset
-- end

function mathProblem:selVer( lst )
   local t = type( lst )
   if t ~= 'table' or mathTypeQ( lst ) then
      return lst
   else 
      --print( '\n type = ' .. t .. '\n' )
      return lst[ self.vernum ]
   end
end

function mathProblem:gsub_interp( str, tab )
   return str:gsub( '(@[^%s%p@%%%}\\]*)', 
		    function(w) 
		       local arg = w:sub(2)
		       local val = tab[ arg ] or w
		       return self:selVer( val )
		    end )
end

function mathProblem:generate( ... ) 
   --local oldEnv = copy( _G )
   local latex, template
   if type( self.template ) == 'table' then 
      if self.vernum == 0 then
	 self.vernum = math.random( #self.template ) 
      end
      template = self.template[ self.vernum ]
   else 
      template = self.template
   end
   --local env = copy( _ENV )
   --env.self = self
   --env.submkargs = {...}
   --local locglobs = {}
   --local submkstr = 'return self:submaker( table.unpack( submkargs ) )'
   --print( '\n self.submaker() = ' .. #self:submaker() .. '\n' )
   local submkstr = string.dump( self.submaker )
   --print( '\n submkstr = ' .. submkstr .. '\n' )
   local env = setmetatable( {}, { __index = _ENV } )
   local submkfun = load( submkstr, submkstr, 'b', env )
   -- if type(submkfun)=='table' then 
   --    print( '\n submkfun: \n' )
   --    printTable( submkfun ) 
   -- end
   local subs, chcs = submkfun( self, ... )
   --print( '\n submkfun returned \n' )
   --local subs, chcs = self:submaker( ... )
   if chcs == nil then self.subFun = 'self' end
   chcs = chcs or subs
   --if chcs == subs and self.mcP then subs = {} end
   if subs[1] and self.subFun == 'table' then
      latex = string.format( template, table.unpack( subs ) )
   elseif self.subFun == 'table' then
      latex = self:gsub_interp( template, subs )
   elseif self.subFun == 'self' then
      latex = self:interp( template, env )
   end
   --print( '\n latex = ' .. latex .. '\n' )
   --_ENV = oldenv
   if self.mcP then
      local blanks = createBlankList( self.numberChoices, [[{%s}]] )
      blanks = table.concat( blanks )
      latex = latex .. [[ \\ \\ %s]] .. blanks
      chcltx = self.listToLatex( chcs )
      --print( "\n chcltx = " .. table.concat( chcltx, ", " ) .. "\n" )
      latex = string.format( latex, self.chcFun, 
			     table.unpack( self:mkchc( chcltx ))) 
   else
      --print('\n chcs = ' .. chcs .. '\n' )
      local ans = chcs
      if type( ans ) == 'table' and not mathTypeQ( ans ) then
	 ans = chcs[1]
      end 
      if mathTypeQ( ans ) then
	 appendAns( latexEncl( ans ) )
      else 
	 appendAns( ans )
      end
   end
   _G = oldEnv
   return latex
end

local function objToLatex( x, surround )
   --if type(x)=="function" then print("\n x: " .. x .. "\n" ) end
   if surround == nil then surround = true end
   local t = type( x )
   if t == 'number' or t == 'string' then
      return x
   elseif surround then
      return [[\(]] .. x:tolatex() .. [[\)]]
   else 
      return x:tolatex()
   end
end
   
   
function mathProblem.listToLatex( lst )
   return map( lst, objToLatex )
end


function mathProblem:interp( str, env )
   return str:gsub( '(@[^%s%p@%%%}\\]*)', 
		  function(w) 
		     --print( '\n w = '.. w .. '\n' )
		     local arg = w:sub(2)
		     --local ld = 'return ' .. arg
		     --local ld = string.dump( function() return arg end )
		     --local env = copy( _ENV )
		     --env.self = self
		     --local fun = load( ld, nil, 'b', env )
		     local res = self:selVer( env[ arg ] ) or w 
		     --print( '\n res = '.. res .. '\n' )
		     res = objToLatex( res, false )
		     return res
		  end )
end


function mathProblem:new( tmpl, mksubs, chcstr )
   chcstr = chcstr or mathProblem.chcFun
   tmpl = tmpl or mathProblem.template
   mksubs = mksubs or mathProblem.submaker
   local instance = {}
   instance.template = tmpl
   instance.submaker = mksubs
   instance.chcFun = chcstr
   instance.subFun = mathProblem.subFun
   instance.mcP = mathProblem.mcP
   return setmetatable( instance, mathProblem.mt )
end



return mathProblem
