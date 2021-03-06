-- -*-two-mode-*-

frc = require('fraction')
vec = require('vector')
st = require('sets')
line = require('line')()
max = require('maxima')
line.max = max.new()
line:initMaxima()

mp = require('mathProblem')
mp.chcFun = [[\chcl]]
mp.numberChoices = 8

ef = require('enumForm')
answers = ef.new()

one = frc.new( 1, 1 )


findSlope = mp:new(
   [[Find the slope of the line $@xco x @op @yco y = @con $.]],
   function()
      op = '+'
      if randBool() then op = '-' end
      xco, yco = distinctRands( 2, 2, 15 )
      xco = randSign() * xco
      con = math.random( -9, 9 )
      -- record answer
      local ans = frc.new( - xco, yco )
      if op == '-' then ans = - ans end
      return { ans, 
		  -ans, 1 / ans, -1 / ans,
	       one * con, - one * con, one / con, - one / con,
	       one / xco, one / yco,
		  - one / xco, - one / yco, 
	       one * xco / con, one * yco / con,
	       - one * xco / con, - one * yco / con}
   end
)


findSlopeHV = mp:new(
   [[Find the slope of the line $ @costr @var = @cons $.]],
   function()
      var = 'x'
      ans = 'no slope'
      if randBool() then 
	 var = 'y' 
	 ans = one * 0
      end
      local coef = randSign() * math.random( 15 )
      costr = coeffToStr( coef )
      cons = math.random( -15, 15 )
      return  { ans, 'no slope', one * 0,
		one, one * coef, one * cons, 
		   - one * coef, - one * cons, 
		one / coef, one / cons,
		- one / coef, - one / cons }
   end,
   [[\chc]]
)



writeLinEq = mp:new(
   [[Write the equation of the line through the point
   $( @x0, @y0 )$ with slope of $ @m $. 
   Express the answer in the form \(Ax+By=C\). 
   ]],
   function()
      x0, y0 = distinctRands( 2, -9, 9 )
      local fn, fd = math.random( -9, 9 ), math.random( 15 )
      m = frc.new( fn, fd )
      --print( '\n m = ' .. m:__tostring() .. '\n' )
      local ans  = [[\(%sx + %sy = %d\)]]
      local xco = - m.sign * m.numer
      local cons = x0 * xco + y0 * m.denom
      local consw1 = - x0 * xco + y0 * m.denom
      local consw2 = y0 * xco + x0 * m.denom
      local consw3 = - y0 * xco + x0 * m.denom
      local yint = frc.new( cons, m.denom )
      --ans = string.format( ans, xco, m.denom, cons )
      return { ans:format( coeffToStr(xco), coeffToStr(m.denom), cons ),  
	       ans:format( coeffToStr(xco), coeffToStr(m.denom), - cons ),
	       ans:format( coeffToStr(- xco), coeffToStr(m.denom), consw1 ),
	       ans:format( coeffToStr(- xco), coeffToStr(m.denom),  - consw1 ),
	       ans:format( coeffToStr(m.denom), coeffToStr(m.numer), consw2 ),
	       ans:format( coeffToStr(- m.denom), coeffToStr(m.numer), consw3 ),
	       ans:format( coeffToStr(- m.denom), coeffToStr(m.numer), - consw3 ),
	       ans:format( coeffToStr(m.denom), coeffToStr(m.numer), - consw2 ) }
   end,
   [[\chc]]
)

system = {}
system.answers = { 'no solution',
		   '1 solution',
		   'infinitely many solutions with 1 free parameter',
		   'infinitely many solutions with 2 free parameters',
		   'infinitely many solutions with 3 free parameters',
		   'infinitely many solutions with 4 free parameters',
		   '2 solutions',
		   '3 solutions' }

rowreduce3 = mp:new(
   [[Assume that the following augmented matrix represents a system of 
   linear equations. \\
   \\
   \[@probstr\] 
   \\ \\ Which of the following statements is true about the
   solution(s) of that system? ]],
   function()
      local sol = {}
      for i = 1, 3 do
	 local row = vec.zero( 4 )
	 row[i], row[4] = 1, randSign() * math.random( 3 )
	 table.insert( sol, row )
      end
      sol = mat.new( sol )
      local prob = rowreduceAux( sol )
      probstr = prob:tolatex( true )
      --return { prob:tolatex() }, latexEncl(sol)
      return listJoin( { '1 solution' }, system.answers )
   end,
   [[\chcss]]
)


rowreduce2 = mp:new(
   [[Assume that the following augmented matrix represents a system of 
   linear equations. \\
   \\
   \[@probstr\] 
   \\ \\ Which of the following statements is true about the
   solution(s) of that system? ]],
   function()
      local sol = {}
      local free = math.random( 2, 3 )
      local bnd  = 5 - free
      local row
      row = vec.zero( 4 )
      row[1], row[free], row[bnd], row[4] = 1, math.random(-9,9), 0, math.random(-9,9)
      table.insert( sol, row )
      row = vec.zero( 4 )
      row[1], row[free], row[bnd], row[4] = 0, 0, 1, math.random(-9,9)
      if free > bnd then row[free] = math.random(-9,9) end
      table.insert( sol, row )
      row = vec.zero( 4 )
      table.insert( sol, row )
      sol = mat.new( sol )
      local prob = rowreduceAux( sol )
      probstr = prob:tolatex( true )
      --return { prob:tolatex() }, latexEncl(sol)
      return listJoin( { 'infinitely many solutions with 1 free parameter' }, system.answers )
   end,
   [[\chcss]]
)

function rowreduceAux( sol )
--   local res = mat.new( sol )
--   appendAns( csvElem( res:tolatex() ) )
   local trnsf = mat.random( 3, 3, 2 )
   while trnsf:determinant() == 0 do
      trnsf = mat.random( 3, 3, 2 )
   end
   local prob = trnsf * sol
   return prob
end



linearStory = mp:new(
   [[The math department chairman is now contemplating adding a new
   section of Finite that assigns twice as much webwork as any current
   section.  He's encouraged by data indicating that the more webwork
   assigned, the greater the average final score of the students.  In
   a typical Finite class, @x2 
   problems are assigned every week, and the class scores an
   average of @y2\percent on the final; 
   in some sections only @x1 problems are assigned, and the class averages
   only @y1\percent on the final.  Assuming the
   relationship is linear, what would be the average score on the final
   for a class in which @x3 webwork problems were assigned every week? ]],
   function( self, sgn )
      sgn = sgn or 1
      local m, b = frc.new( sgn * math.random( 9 ), math.random( 9 ) ), math.random( 9 )
      x1 = m.denom * math.random( 3 )
      y1 = m * x1 + b
      x2 = x1 * math.random( 2, 3 )
      y2 = m * x2 + b
      x3 = x2 * math.random( 2, 3 )
      --local ans = m * x3 + b
      return { m * x3 + b,
	       one / m * x3 + b,
	       m * x3 - b,
	       one / m * x3 - b,
	       m * x3,
	       one / m * x3,
	       one * y1 / x1 * x3,
	       one * y2 / x2 * x3,
	       - m * x3 - b,
	       - one / m * x3 + b,
	       - m * x3 + b,
		  - one / m * x3 - b }
   end,
   [[\chc]]
)


linearToGraph = mp:new(
   [[Which of the following is the graph of the equation 
   \( @eq \)?]],
   function()
      local x0, y0 = distinctRands( 2, 1, 9 )
      local ext = math.max( x0, y0 ) + 2
      x0, y0 = randSign() * x0, randSign() * y0
      line.extent = {-ext,-ext,ext,ext}
      local anslst = {}
      for i,j,k in signIter(3) do
	 --print( '\n sgns = ' .. table.concat( sgns, ',') .. '\n' )
	 local x,y = i * x0, j * y0
	 if k < 0 then x,y = y,x end
	 local m = frc.new( - y, x )
	 local xco, yco = m.numer, - m.sign * m.denom
	 local cons = xco * x
	 local l = line.new( xco, yco, cons )
	 l.name = 'LtG' .. signsToStr( i,j,k )
	 --l:cleanup()
	 l:saveGraph()
	 table.insert( anslst, l )
      end

      eq = anslst[1]:tolatex()
      --local ans = string.format( [[(%d,0), (0,%d), 
      --                              \(m=%s\)]], x0, y0, m )
      return map( anslst, function(x) return x:tolatexpic() end )
   end,
   [[\chcs]]
)

