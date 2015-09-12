-- -*-two-mode-*-

frc = require('fraction')
vec = require('vector')
st = require('sets')
line = require('line')()
max = require('maxima')
line.max = max.new()
line:initMaxima()

mp = require('mathProblem')
mp.chcFun = [[\qrowFour]]
--mp.numberChoices = 8

ef = require('enumForm')
answers = ef.new()

one = frc.new( 1, 1 )


findSlope = mp:new(
   [[Find the slope of the line $@xco x @op @yco y = @con $.]],
   function( self )
      op = '+'
      if randBool() then op = '-' end
      xco, yco = distinctRands( 2, 2, 15 )
      xco = randSign() * xco
      con = math.random( -9, 9 )
      -- record answer
      local ans = frc.new( - xco, yco )
      if op == '-' then ans = - ans end
      return { ans, 'undefined', one * 0,
		  -ans, 1 / ans, -1 / ans,
	       one * con, - one * con, one / con, - one / con,
	       one / xco, one / yco,
		  - one / xco, - one / yco, 
	       one * xco / con, one * yco / con,
	       - one * xco / con, - one * yco / con}
   end,
   [[\qrowFour]]
)


findSlopeHV = mp:new(
   [[Find the slope of the line $ @costr @var = @cons $.]],
   function()
      var = 'x'
      ans = 'undefined'
      if randBool() then 
	 var = 'y' 
	 ans = one * 0
      end
      local coef = randSign() * math.random( 15 )
      costr = coeffToStr( coef )
      cons = math.random( -15, 15 )
      return  { ans, 'undefined', one * 0,
		one, one * coef, one * cons, 
		   - one * coef, - one * cons, 
		one / coef, one / cons,
		- one / coef, - one / cons }
   end
)
findSlopeHV.chcFun = [[\qrowFour]]


--[[Express the answer in the form \(Ax+By=C\).]]

writeLinEq = mp:new(
   [[Write the equation of the line through the point
   $( @x0, @y0 )$ with slope of $ @m $.  
   ]],
   function( self )
      x0, y0 = distinctRands( 2, 1, 9 )
      x0, y0 = randSign() * x0, randSign() * y0
      m = 0
      while m == 0 or m == 1 or m == -1 do
	 local fn, fd = math.random( -9, 9 ), math.random( 15 )
	 m = frc.new( fn, fd )
      end 
      --print( '\n m = ' .. m:__tostring() .. '\n' )
      local ans  = [[\(%sx + %sy = %d\)]]
      local xco = - m.sign * m.numer
      local cons = x0 * xco + y0 * m.denom
      local consw1 = - x0 * xco + y0 * m.denom
      local consw2 = y0 * xco + x0 * m.denom
      local consw3 = - y0 * xco + x0 * m.denom
      local yint = frc.new( cons, m.denom )
      --ans = string.format( ans, xco, m.denom, cons )
      return map( { ans:format( xco, m.denom, cons ),  
		    ans:format( xco, m.denom, consw2 ),  
		    ans:format( xco, m.denom, consw3 ),
		    ans:format( xco, m.denom, - cons ),
		    ans:format( - xco, m.denom, consw1 ),
		    ans:format( - xco, m.denom,  - consw1 ),
		    ans:format( - xco, m.denom,  consw2 ),
		    ans:format( m.denom, m.numer, consw2 ),
		    ans:format( m.denom, m.numer, cons ),
		    ans:format( - m.denom, m.numer, consw3 ),
		    ans:format( - m.denom, m.numer, - consw3 ),
		    ans:format( m.denom, m.numer, - consw2 ) },
		  polyToStr )
   end,
   [[\qrowTwo]]
)

system = {}
system.answers = { 'no solution',
		   'unique solution',
		   'infinitely many solutions with 1 arbitrary (free) parameter',
		   'infinitely many solutions with 2 arbitrary (free) parameters',
		   'infinitely many solutions with 3 arbitrary (free) parameters',
		   'infinitely many solutions with 4 arbitrary (free) parameters',
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
   end
)
rowreduce3.chcFun = [[\qrowOne]]

rowreduce2 = mp:new(
   [[Assume that the following augmented matrix represents a system of 
   linear equations. \\
   \\
   \[@probstr\] 
   \\ \\ What kind of solution does this system have? ]],
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
      return listJoin( { 'infinitely many solutions with 1 arbitrary (free) parameter' }, system.answers )
   end
)
rowreduce2.chcFun = [[\qrowOne]]

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
   { [[ The math department has just completed a study correlating how
   many minutes early students leave their Finite class with their
   starting salaries after graduation.   
      A typical Finite student leaves class
   @x1 minutes early at every class, and these students typically get a
   \$@y1 thousand starting salary; 
   about 20\percent of students leave @x2 minutes early, and they
   typically get a \$@y2 thousand starting salary.
      Assuming the
      relationship is linear,
      what would be the starting salary for a student who left every
   class @x3 minutes early? ]],
   [[ The math department chairman is now contemplating adding a new
   section of Finite that assigns twice as much webwork as any current
   section.  She\'s encouraged by data indicating that the more webwork
   assigned, the greater the average final score of the students.  In
   a typical Finite class, @x2 
   problems are assigned every week, and the class scores an
   average of @y2\percent on the final; 
   in some sections only @x1 problems are assigned, and the class averages
   only @y1\percent on the final.  Assuming the
   relationship is linear, what would be the average score on the final
   for a class in which @x3 webwork problems were assigned every week?
   ]] },
   function( self, sgn, scale )
      sgn = sgn or 1
      scale = scale or 1
      local m, b = frc.new( sgn * math.random( 6 ), math.random( 9 )
      ), math.random( 4, 9 ) * 4
      local m, b = scale * m, scale * b
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
   end
)


linearToGraph = mp:new(
   {[[Which of the following is the graph of the equation 
   \( @eq \)? ]],
      [[ Graph the equation \( @eq \).
Indicate the $x$- and $y$-intercepts. ]] },
   function( self )
      local x0, y0 = distinctRands( 2, 1, 9 )
      local ext = math.max( x0, y0 ) + 2
      x0, y0 = randSign() * x0, randSign() * y0
      line.extent = {-ext,-ext,ext,ext}
      local anslst = {}
      if self.mcP then
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
      else
            local m = frc.new( - y0, x0 )
            local xco, yco = m.numer, - m.sign * m.denom
            local cons = xco * x0
             local l = line.new( xco, yco, cons )
            l.name = 'LtG'
            --l:cleanup()
            l:saveGraph()
            anslst = { l }
      end

      eq = anslst[1]:tolatex()
      --local ans = string.format( [[(%d,0), (0,%d), 
      --                              \(m=%s\)]], x0, y0, m )
      return map( anslst, function(x) return x:tolatexpic() end )
   end
)
linearToGraph.chcFun = [[\qrowTwo]]


system2unique = mp:new(
   [[ Solve the following system of linear equations using any method you like.
         \begin{eqnarray*}
      @lin1 &=& @c1 \\
      @lin2 &=& @c2
      \end{eqnarray*} ]],
      function( self )
         local solx, soly = distinctRands( 2, -6, 6 )
         local a1,a2,b1,b2 = math.random(-6,6), math.random(-6,6), math.random(-6,6), math.random(-6,6)
         c1 = a1 * solx + b1 * soly
         c2 = a2 * solx + b2 * soly
         lin1 = [[ ]]..a1..[[x + ]]..b1..[[y ]];
         lin2 = [[ ]]..a2..[[x + ]]..b2..[[y ]];
         lin1 = polyToStr( lin1 )
         lin2 = polyToStr( lin2 )
         local ans = [[ \( x = ]]..solx..[[, y = ]]..soly..[[\)]];
         return ans
      end
)
system2unique.mcP = false
