-- -*-two-mode-*-

frc = require('fraction')
vec = require('vector')
st = require('sets')
line = require('line')()
max = require('maxima')
line.max = max.new()
line:initMaxima()

mat = require('matrix')

mp = require('mathProblem')
mp.chcFun = [[\chc]]
mp.numberChoices = 8
mp.mcP = false

ef = require('enumForm')
answers = ef.new()

one = frc.new( 1, 1 )


rrefPrb = mp:new(
   [[ Solve the following system of equations.
      \[\left\{\begin{array}{rcl}
      %d w + %d x + %d y &=& %d z + %d \\
      %d w + %d x + %d y &=& %d z + %d \\
      %d w + %d x + %d y &=& %d z + %d 
     \end{array}\right. \] ]],
   function( self )
      local v1 = vec.new({ 1,
			   0,
			   randSign() * math.random(1,19),
			   randSign() * math.random(1,19),
			   randSign() * math.random(1,19)
			 })
      local v2 = vec.new({ 0,
			   1,
			   randSign() * math.random(1,19),
			   randSign() * math.random(1,19),
			   randSign() * math.random(1,19)
			 })
      --v1[4], v2[4] = -v1[4], -v2[4]
      local e1 = math.random(1,5) * v1 + math.random(1,5) * v2
      local e2 = math.random(1,5) * v1 + math.random(1,5) * v2
      local e3 = math.random(1,5) * v1 + math.random(1,5) * v2
      v1[3], v2[3] = -v1[3], -v2[3]
      --local ans = mat.new( { v1, v2 } )
      local anslst = {}
      local ansfrm = [[ \(\left\{
        \begin{array}{rcl}
          %dw + %dx &=& %dy +%dz + %d \\
          %dw + %dx &=& %dy +%dz + %d \\
          y,z && {\rm are\ free}
        \end{array}\right.\) ]]
      local function mkans(v1,v2)
	 local res = ansfrm:format( table.unpack( listJoin(v1,v2) ) )
	 return polyToStr( res )
      end
      --print( '\n v1 = ' .. v1:__tostring() .. '\n' )
      for a,b,c in signIter(3) do
	 local ansv1, ansv2 = v1:clone(), v2:clone()
	 ansv1[3], ansv2[3] = a * ansv1[3], a * ansv2[3] 
	 ansv1[4], ansv2[4] = b * ansv1[4], b * ansv2[4] 
	 ansv1[5], ansv2[5] = c * ansv1[5], c * ansv2[5] 
	 table.insert( anslst, mkans( ansv1, ansv2 ) )
      end 
      return listJoin( e1, e2, e3 ), anslst
   end,
   [[\chcs]]
)
--rrefPrb.mcP = true

linComb = mp:new(
   [[ Evaluate the expression \( @ex \) given
   \[ A = @amat \qquad B = @bmat. \] ]],

   function( self )
      amat = mat.random( 2, 2, 6 )
      bmat = mat.random( 2, 2, 6 )
      local ca, cb = distinctRands( 2, 1, 4 )
      ex = polyToStr( ca .. 'A - ' .. cb .. 'B' )
      return ca * amat - cb * bmat
   end 
)

matMult = mp:new( 
   [[ Find the following matrix product.
   \[ %s %s \] ]],
   function( self )
      local m1 = mat.random( 2, 2, 5 )
      local m2 = mat.random( 2, 1, 3 ) + mat.new({{1},{1}})
      local m2a = m2:clone()
      m2a[2] = vec.new({0})
      local m2b = m2:clone()
      m2b[1] = vec.new({0})
      local ansa = m1 * m2a
      local ansb = m1 * m2b
      ans = mat.new( { { polyToStr( ansa[1][1] .. 'a + ' .. ansb[1][1] .. 'b' ) },
		       { polyToStr( ansa[2][1] .. 'a + ' .. ansb[2][1] .. 'b' ) } } )
      local m2ab = mat.new( { { monoToStr( m2[1][1], 'a' ) }, 
			      { monoToStr( m2[2][1], 'b' ) } } )
      return { m1:tolatex(), m2ab:tolatex() }, 
             { ans, 
	       mat.new( { { ansa[1][1] + ansb[1][1] .. 'a' },
		       { ansa[2][1] + ansb[2][1] .. 'b' } } ),
	       mat.new( { { ansa[1][1] .. 'a', ansb[1][1] .. 'b' },
		       { ansa[2][1] .. 'a', ansb[2][1] .. 'b' } } ),
	       mat.new( { { m2[1][1]*(m1[1][1] + m1[1][2]) .. 'a' },
			  { m2[2][1]*(m1[2][1] + m1[2][2]) .. 'b' } } ),
	       mat.new( { { ansa[1][1] + ansb[1][1] .. 'ab' },
		       { ansa[2][1] + ansb[2][1] .. 'ab' } } ),
	       mat.new( { { ansa[1][1] .. 'a + ' .. ansb[2][1] .. 'b' },
		       { ansa[2][1] .. 'a + ' .. ansb[1][1] .. 'b' } } ),
	       mat.new( { { ansa[1][1] .. 'a' },
		       { ansb[1][1] .. 'b' } } ),
	       mat.new( { { ansa[2][1] .. 'a' },
			  { ansb[2][1] .. 'b' } } ),
	       mat.new( { { ansa[1][1] + ansb[1][1]  },
		       { ansa[2][1] + ansb[2][1]  } } ) }
   end
)
--matMult.mcP = true


setupAugMat = mp:new(
   [[
   You are baking cake and cookies for an upcoming charity drive.
   Making one cake requires
   %d
   cups of flour,
   %d
   eggs, and 
   %d
   cups of milk; 
   making one dozen cookies requires
   %d 
   cups of flour,
   %d
   eggs, and 
   %d
   cups of milk;
   You have 
   %d 
   pounds of flour,
   %d
   dozen eggs, and
   %d 
   gallons of milk. 

   Assume that a pound of flour is equal to 4 cups,
   and that 16 cups are in a gallon.


   Set up an augmented matrix which would be used to
   determine how many cakes 
   and dozens of cookies
   to bake
   in order to use up
   all the available resources.  
   Express your answer in pounds of flour, dozens of eggs, and gallons
   of milk.

   You need {\bf\em not} row-reduce the matrix!
   ]],
   function()
      local a, b, c = 4, 12, 16
      local rndlst = {math.random( 3,7), math.random(2,4), math.random(2,4),
		      math.random( 3,7), math.random(2,4), math.random(2,4),
		      math.random( 2,3), math.random(1,3), math.random(2,4)}
      local ans1 = mat.new({{rndlst[1], rndlst[4], a * rndlst[7]},
			    {rndlst[2], rndlst[5], b * rndlst[8]},
			    {rndlst[3], rndlst[6], c * rndlst[9]}})
      local ans3 = mat.new({{rndlst[1], rndlst[4], rndlst[7]},
			    {rndlst[2], rndlst[5], rndlst[8]},
			    {rndlst[3], rndlst[6], rndlst[9]}})
      local fct = mat.newDiag( {one/a,one/b,one/c} )
      local ans2 = fct * ans1
      local ans4 = fct * ans3
      --local ansstr = [[\(]]..ans1:tolatex(true)..[[\)\\ or \\ \(]] .. ans2:tolatex(true) .. [[\)]]
      local anslst = { ans2, ans1,
	       ans2:transpose(), ans1: transpose(),
	       ans4, ans3,
	       ans4:transpose(), ans3: transpose() }
      anslst = map( anslst,
		    function (x)
		       return [[\(]].. x:tolatex(true) ..[[\)]]
		    end )
      return rndlst, anslst
             
   end,
   [[\chcs]]
)
--setupAugMat.mcP = true


uniqueSol = [[
\(\left\{\begin{array}{rcl}
    x&=&%d \\ 
    y &=& %d \\ 
    z &=& %d 
  \end{array}\right.\)]]

free2Sol = [[
\(\left\{\begin{array}{rcl}
    x &=& %dy + %dz + %d \\ 
    y,z&&{\rm are\ free}
  \end{array}\right.\) ]]

freexSol = [[
\(\left\{\begin{array}{rcl}
    y &=& %dx +%d\\
    z &=& %dx +%d \\ 
    x&&{\rm is\ free}
  \end{array}\right.\)]]

freeySol = [[
\(\left\{\begin{array}{rcl}
    x &=& %dy +%d\\
    z &=& %d \\ 
    y&&{\rm is\ free}
  \end{array}\right.\)]]

freezSol = [[
\(\left\{\begin{array}{rcl}
    x &=& %dz +%d\\
    y &=& %dz + %d\\ 
    z&&{\rm is\ free}
  \end{array}\right.\)]]

function solutionList( ans, a,b,c,d )
   return { ans,
	    'no solution',
	    uniqueSol:format( a, b, c ),
	    freeySol:format( a, b, c ),
	    freeySol:format( a, -b, c ),
	    freezSol:format( a, b, c, d ),
	    freezSol:format( -a, b, -c, d ),
	    free2Sol:format( a, b, c ),
	    free2Sol:format( -a, -b, c ) }
end 

freeyz = mp:new(
   [[ \( \begin{bmat}{rrr|r} 
    1 & %d & %d & %d \\
    \phm0 & \phm0 & \phm0 & \phm0 \\
    0 & 0 & 0 & 0
  \end{bmat} \) ]],
   function()
       local lst = vec.random( 3, 9 )
       local anstmpl = [[\(\left\{\begin{array}{rcl}x &=& %dy + %dz + %d \\ y,z&&{\rm are\ free}\end{array}\right.\)]]
       local wrong1 = [[\(\left\{\begin{array}{rcl}x&=&%d \\ y &=& %d \\ z &=& %d \end{array}\right.\)]]
       local wrong2 = [[\(\left\{\begin{array}{rcl}y &=& %d +%dx\\ z &=& %d +%dx \\ x&&{\rm is\ free}\end{array}\right.\)]]
       local lstans = {  -lst[1], -lst[2], lst[3] }
       local anslst = {  }
       for a,b in signIter(2) do
	  local l = copy( lstans )
	  l[1], l[2], l[3] = a * l[1], b * l[2], l[3]
	  table.insert( anslst, anstmpl:format( table.unpack( l ) ) )
       end 
       listConcat( anslst, { 'no solution',
			     wrong1:format( table.unpack(lst) ),
			     wrong1:format( table.unpack(lstans) ),
			     wrong2:format( -lst[1], lst[3], 
					       -lst[2], lst[3] ) } )
       --local ans = string.format( anstmpl, -lst[1], -lst[2], lst[3] )
       return lst, solutionList( anstmpl:format( table.unpack( lstans ) ),
				 lstans[1], lstans[2],
				 lstans[3], lstans[2] )
   end,
   [[\chcs]]
)
--freeyz.mcP = true


freey = mp:new(
   [[\(\begin{bmat}{rrr|r}
     1 & %d & 0 & %d \\
     0 & 0 & 1 & %d \\
     \phm0 & \phm0 & \phm0 & \phm0
   \end{bmat}\) ]],
   function()
      local lst = vec.random( 3, 9 )
      local anstmpl = [[\(\left\{\begin{array}{rcl}
          x &=& %dy + %d \\ 
          z &=& %d \\
        y && {\rm is\ free} 
      \end{array}\right.\)]]
      local wrong = [[\(\left\{\begin{array}{rcl}
          x &=& %dz + %d \\ 
          y &=& %dz + %d \\
        z && {\rm is\ free} 
      \end{array}\right.\)]]
      local wrong1 = [[\(\left\{\begin{array}{rcl}
          x&=&%d \\ 
          y &=& %d \\ 
          z &=& %d 
        \end{array}\right.\)]]      
      return lst, 
             solutionList( anstmpl:format( -lst[1], lst[2], lst[3] ),
				 -lst[1], lst[2],
				 lst[3], lst[2] )
   end,
   [[\chcs]]
)
--freey.mcP = true



freez = mp:new(
   [[\( \begin{bmat}{rrr|r}
     1 & 0 & %d & %d \\
     0 & 1 & %d & %d \\
     \phm0 & \phm0 & \phm0 & \phm0 
     \end{bmat} \)]],
   function()
      local lst = vec.random( 4, 9 )
      --local anstmpl = [[\(x = %dz + %d \\ y = %dz + %d\)]]
      local ans = freezSol:format( -lst[1], lst[2], -lst[3], lst[4] )
      return lst, 
             solutionList( ans, -lst[1], lst[2], -lst[3], lst[4] )
   end,
   [[\chcs]]
)
--freez.mcP = true


free = mp:new(
   [[\( \begin{bmat}{rrr|r}
     1 & 0 & 0 & %d \\
     0 & 1 & 0 & %d \\
     \phm0 & \phm0 & \phm1 & %d 
     \end{bmat}\)]],
   function()
      local lst = vec.random( 3, 9 )
      local anstmpl = [[\(x = %d \\ y = %d\\ z = %d\)]]
      local ans = uniqueSol:format( lst[1], lst[2], lst[3] )
      return lst, 
             solutionList( ans, lst[1], lst[2], lst[3], lst[2] )      
   end,
   [[\chcs]]
)
--free.mcP = true



nosol = mp:new(
   [[\( \begin{bmat}{rrr|r}
     1 & 0 & %d & 0 \\
     0 & 1 & %d & 0 \\
     \phm0 & \phm0 & \phm0 & 1 
     \end{bmat}\)]],
   function()
   local lst = vec.random( 2, 9 )
   local ans = 'no solution'
   return lst, solutionList( ans, lst[1], lst[2], lst[1], lst[2] )
   end,
   [[\chcs]]
)
--nosol.mcP = true

defined = mp:new(
   [[ Suppose that \(A\) is a  \( @d1 \times @d2 \) matrix, 
   \(B\) is a  \( @d2 \times @d1 \) matrix,  
   \(C\) is a  \( @d1 \times @d1 \) matrix,
   and \(D\) is a  \( @d2 \times @d2 \) matrix.
   Which of the following expressions are defined?

   (Note that \(0\) is the number zero, while \(\mathbf 0\) is the zero
   matrix; \(1\) is the number one while \(I\) is the idintity matrix.)

   \begin{enumerate}
   \item 
     \( @ex1 \)
   \item 
     \( @ex2 \)
   \item 
     \( @ex3 \)
   \item 
     \( @ex4 \)
   \item 
     \( @ex5 \)
   \item 
     \( @ex6 \)
   \item 
     \( @ex7 \)
   \item 
     \( @ex8 \)
   \end{enumerate}
   ]],
   function( self )
      d1, d2 = distinctRands( 2, 2, 5 )
      local mats = { { 'C', 'A' }, { 'B', 'D' } }
      local ans, exs = {}, {}
      for a,b,c,n in signIter( 'bbb' ) do
	 local op1, op2, m1, m2, m3
	 local correct = true
	 local i1, j1, i2, j2, i3, j3
	 op1 = ifset( a, ' + ', ' ' )
	 op2 = ifset( b, ' + ', ' ' )
	 m1 = ifset( c, math.random( -9, 9 ), 'mat' )
	 if m1 == 'mat' then
	    i1, j1 = math.random( 1, 2 ), math.random( 1, 2 )
	    m1 = mats[ i1 ][ j1 ]
	 end
	 j2 = math.random( 1, 2 )
	 local tm1n = ( type( m1 ) == 'number' )
	 if op1 == ' + ' then
	    if tm1n then
	       correct = false
	       i2 = math.random( 1, 2 )
	    else 
	       i2 = i1
	       correct = correct and ( i1 == i2 and j1 == j2 )
	    end 
	    m2 = mats[ i2 ][ j2 ]	       
	 else 
	    i2 = math.random( 1, 2 )
	    m2 = mats[ i2 ][ j2 ]
	    correct = correct and ( j1 == i2 or tm1n )
	    if not tm1n then i2 = i1 end
	 end
	 i3 = math.random( 1, 2 )
	 if op2 == ' + ' then
	    j3 = j2
	    correct = correct and ( i3 == i2 and j3 == j2 )
	 else 
	    j3 = math.random( 1, 2 )
	    correct = correct and ( j2 == i3 )
	 end
	 m3 = mats[ i3 ][ j3 ]
	 local t1 = m1 .. op1 .. m2
	 if op1 == ' + ' and op2 == ' ' then
	    t1 = '( ' .. t1 .. ' )'
	 end 
	 table.insert( exs, t1 .. op2 .. m3 )
	 if correct then 
	    table.insert( ans, numToLet( n + 1 ) )
	 end
      end 
      ex1,ex2,ex3,ex4,ex5,ex6,ex7,ex8 = table.unpack( exs )
      ans = table.concat( ans, ', ' )
      if ans == '' then ans = 'none' end
      return ans
   end 
)



inverseSolve = mp:new(
   [[ Solve the matrix equation
      \[ @amat X = @bmat \] 
      for \(X\) using an {\rm inverse matrix}. 
      If you use any other method you will not get full credit. ]],

   function( self, d )
      d = d or 1
      local det = 0
      while math.abs( det ) ~= d  do
	 amat = mat.random( 2, 2, 6 )
	 det = amat:determinant()
      end 
      local b1, b2 = distinctRands( 2, -3, 3 )
      bmat = det * mat.new( {{ b1 }, { b2 }} )
      local amatinv = amat:inverse()
      local wronginv1 = amatinv:transpose()
      local wronginv2 = amatinv:clone()
      wronginv2[1][2], wronginv2[2][1] = -wronginv2[1][2], -wronginv2[2][1]
      local wronginv3 = amatinv:clone()
      local wronginv4 = det * amatinv:clone()
      wronginv3[1], wronginv3[2] = wronginv3[2], wronginv3[1]
      return { amatinv * bmat,
	       wronginv1 * bmat, wronginv2 * bmat, wronginv3 * bmat }
   end 
)

inverseFind = mp:new(
   [[ Find the inverse of the following matrix. 
   \[ @amat \] ]],

   function( self, size, det, max )
      det = det or 1
      size = size or 2
      max = max or 6
      local d = 0
      while math.abs( d ) ~= det do
	 amat = mat.random( size, size, max )
	 d = amat:determinant()
      end 
      return amat:inverse()
   end 
)

linProd = mp:new(
   [[
Suppose a company makes three kinds of 
%s: 
%s, %s, and %s.
The ingredients in the 
drinks are
%s, %s, and %s.

\begin{displaymath}
 \begin{array}{rcl}
  x_1&= &\tx{\# bottles %s } \\
  x_2&= &\tx{\# bottles %s } \\
  x_3&= &\tx{\# bottles %s } \\
  r_1&= &\tx{\# g.\  %s } \\
r_2&= &\tx{\# g.\ %s } \\
r_3&= &\tx{\# g.\ %s } \\
 \end{array}
\end{displaymath}

(Recall that 1 g.\ = 1 gram = 1000 milligrams, and 1 kg.\ = 1 kilogram = 1000 grams.)

Suppose the production matrix is
\begin{displaymath}
 \begin{bmat}{ccc}
 %s & %s & %s \\
 %s & %s & %s \\
 %s & %s & %s 
 \end{bmat}.
\end{displaymath}

\begin{enumerate}
\item
How many kilograms of each ingredient is required to make
%s bottles of %s,
%s bottles of %s, and
%s bottles of %s?

\vsp{3}
 
\item
How many bottles of each drink should the company make in order to use
       up exactly 
%s kilograms of %s,
%s kilograms of %s, and
%s kilograms of %s?
\end{enumerate}

\vsp{3}
]],
   function( self, cat, p1, p2, p3, i1, i2, i3, ... )
      local prod = mat.splitVector( table.pack(...), 3 )
      
      local fct2  =mat.newDiag( {1000,1000,1000} )
      local fct1  =mat.newDiag( {.001,.001,.001} )
      local rndV1 = 1000 * vec.randomNonNeg( 3, 99 )
      local rndV2 = vec.randomNonNeg( 3, 99 )
      --print( '\n rndV2 = ' .. rndV2:__tostring() )
      local rndX1 = mat.splitVector( rndV1, 1 )
      local ans2 = 10000 * mat.splitVector( rndV2, 1 )
      --print( '\n ans2 = ' .. ans2:__tostring() )
      local ans1 = fct1 * prod * rndX1 
      local rndX2  = fct1 * prod * ans2 

      local ans1str = latexEncl( ans1 )
      --appendAns( ans1str )
      local ans2str = latexEncl( ans2 )
      --appendAns( ans2str )

      local sublst = listJoin( { cat, p1, p2, p3, i1, i2, i3 },
			       { p1, p2, p3, i1, i2, i3 },
			       table.unpack( prod ) )
      listConcat( sublst, { rndV1[1], p1, rndV1[2], p2, rndV1[3], p3,
			    rndX2[1][1], i1, rndX2[2][1], i2, 
			    rndX2[3][1], i3 } )
      return sublst, ans1str .. ';\\ ' .. ans2str
   end
)
--linProd.mcP = false


leontievTM = mp:new(
   [[ A small company produces @p1 (product 1) 
   and @p2 (product 2 ).  
   The production of 1 metric ton (1000 kilograms) 
   of @p1 requires the internal consumption of @a11
   kilograms of @p1 and @a21 kilograms of @p2; the production of 1
   metric ton of
   @p2 requires the internal consumption of @a12 kilograms of @p1 and
   @a22 kilograms  of  @p2.  Write out the technology matrix for this
   company with both products measured in units of metric tons.  ]],
   
   function( self, p1name, p2name )
      p1, p2 = p1name, p2name
      local ans0 = mat.random( 2, 2, 200, false )
      local ans = 0.001 * ans0
      a11, a12 = ans0[1][1], ans0[1][2]
      a21, a22 = ans0[2][1], ans0[2][2]
      local switch = mat.zero(2,2)
      switch[1][2], switch[2][1] = 1,1
      local anslst = {}
      for a,b,c in signIter('bbb') do
	 local m = ifset( a, ans, ans0 ):clone()
	 --print( '\n m = ' .. m:__tostring() .. '\n' )
	 if not b then m = switch * m end
	 if not c then m = m * switch end
	 table.insert( anslst, m )
      end 
      return anslst
   end 
)
--leontievTM.mcP = true
leontievTM.chcFun = [[\chcs]]

leontievXD = mp:new(
   [[ A company that produces two goods has the following technology
   matrix. 
   \[ A = @tm \] 
   Suppose that the company plans to produce @x1 units of the first
   product and @x2 units of the second.  What demand vector will the
   company be able to satisfy? ]],

   function( self )
      local d1, d2 = -1, -1
      local tm0, tmfrc, ps
      while d1 < 0 or d2 < 0 do
	 tm0 = mat.random( 2, 2, 4, false )
	 tm = 1/10 * tm0
	 tmfrc = one/10 * tm0
	 x1, x2 = distinctRands( 2, 1, 5 )
	 ps = mat.new({{x1},{x2}})
	 local dv = ps - tm * ps
	 d1, d2 = dv[1][1], dv[2][1]
      end 
      local ident = mat.identity(2)
      local inv = ( ident - tmfrc ):inverse()
      local invwr = tmfrc:inverse()
      local invw2 = ( ident + tmfrc ):inverse()
     return { ps - tm * ps,
	       tm * ps, ps,
	       
	       (-ps) + tm * ps,
	       (-tm) * ps,
	       
	       inv * ps, invwr * ps,
	       ps - tm * ps, tm * ps,
	       invw2 * ps }
   end 
)
leontievXD.chcFun = [[\chc]]


leontievDX = mp:new(
   [[ A company that produces two goods has the following technology
   matrix. 
   \[ A = @tm \] 
   Suppose that the company wants to meet demand for  @d1 units of the
   first  product and @d2 units of the second.  
   What production schedule should the company set? ]],

   function( self )
      local ident = mat.identity(2)
      local tm0 = mat.random( 2, 2, 5, false )
      tm = 1/10 * tm0
      local tmfrc = one/10 * tm0
      local d, dw1, dw2 = 0,0,0
      while d == 0 or dw1 == 0 or dw2 == 0 or d.numer > 2 do
	 tm0 = mat.random( 2, 2, 5, false )
	 tm = 1/10 * tm0
	 tmfrc = one/10 * tm0
	 d = ( ident - tmfrc ):determinant()
	 dw1 = tmfrc:determinant()
	 dw2 = ( ident + tmfrc ):determinant()
      end 
      local inv = ( ident - tmfrc ):inverse()
      d1, d2 = distinctRands( 2, 1, 5 )
      local dv = mat.new({{d1},{d2}})
      local invwr = tmfrc:inverse()
      local invw2 = ( ident + tmfrc ):inverse()
      --print( '\n submkfun about to return... \n' )
      --print( '\n ans: ' .. (tm):__tostring() .. '\n' )
      return { inv * dv, invwr * dv,
	       dv - tm * dv, tm * dv,
	       invw2 * dv, 
	       dv - tm * dv,
	       dv, dv - invwr * dv, dv - invw2 * dv }
   end 
)
--leontievDX.mcP = true
leontievDX.chcFun = [[\chc]]


function mkpopmat( x1,x2,x3,x4,x5,y1,y2,y3,y4 )
   local res = mat.zero(5,5)
   res[1] = vec.new({x1,x2,x3,x4,x5})
   res[2][1], res[3][2], res[4][3], res[5][4] = y1,y2,y3,y4
   return res
end 



leslieSetup = mp:new(
   [[ The @name lives to a maximum age of 4.  If we divide the females
   into five age cohorts, one for each year, then we have the
   following statistics.

   A female in the first (youngest) age cohort has an average of @f1
   offspring; 
   a female in the second  age cohort has an average of @f2 offspring;
   a female in the third  age cohort has an average of @f3 offspring;
   a female in the fourth  age cohort has an average of @f4 offspring;
   finally, a female in the fifth (oldest) age cohort has an average
   of @f5 offspring.
   
   @namepl in the  first age cohort have a @s1\percent chance of
   surviving for at least one additional year;
   those in the second age cohort have a @s2\percent chance of
   surviving for at least one additional year;
   those in the third age cohort have a @s3\percent chance of
   surviving for at least one additional year;
   finally, those in the fourth age cohort have a @s4\percent chance of
   surviving for at least one additional year.

   What is the transition matrix for the @name?
   ]],

   function( self, nm )
      name = nm
      namepl = nm..'s'
      local rvec = vec.random( 5, 100, false )
      rvec[4], rvec[5] = -rvec[4], -rvec[5]
      local function cum(n)
	 local res = 0
	 for i = 1,n do
	    res = res + rvec[i]
	 end 
	 return res
      end 
      f1, f2, f3, f4, f5 = cum(1), cum(2), cum(3), 
                           math.abs(cum(4)), math.abs(cum(5))
      rvec = vec.random( 4, 30, false )
      rvec[3], rvec[4] = -rvec[3], -rvec[4]
      s1, s2, s3, s4 = cum(1), cum(2), 
                       math.abs(cum(3)), math.abs(cum(4))
      p1, p2, p3, p4 = .01 * s1, .01 * s2, .01 * s3, .01 * s4
      local function mkmat( x1,x2,x3,x4,x5,y1,y2,y3,y4 )
	 local res = mat.zero(5,5)
	 res[1] = vec.new({x1,x2,x3,x4,x5})
	 res[2][1], res[3][2], res[4][3], res[5][4] = y1,y2,y3,y4
	 return res
      end 
      local function mkwrong( x1,x2,x3,x4,x5,y1,y2,y3,y4 )
	 local res = mat.zero(5,5)
	 res[1] = vec.new({x1,x2,x3,x4,x5})
	 res[2][2], res[3][3], res[4][4], res[5][5] = y1,y2,y3,y4
	 return res
      end 
      return { mkmat( f1, f2, f3, f4, f5, p1, p2, p3, p4 ),
	       mkmat( f1, f2, f3, f4, f5, s1, s2, s3, s4 ),
	       mkmat( p1, p2, p3, p4, f1, f2, f3, f4, f5 ),
	       mkmat( s1, s2, s3, s4, f1, f2, f3, f4, f5 ),
	       mkwrong( f1, f2, f3, f4, f5, p1, p2, p3, p4 ),
	       mkwrong( f1, f2, f3, f4, f5, s1, s2, s3, s4 ),
	       mkwrong( p1, p2, p3, p4, f1, f2, f3, f4, f5 ),
	       mkwrong( s1, s2, s3, s4, f1, f2, f3, f4, f5 ) }
   end,
   [[\chcs]]
)

leslieProject = mp:new(
   [[ Suppose that a certain @name population has the transition
   matrix \(A\).  Also suppose that the initial population level for
   the first (youngest) female age cohort is @x1, 
   for the second cohort is @x2, for the third cohort is @x3, 
   for the fourth cohort is @x4, 
   and for the fifth (oldest) cohort is @x5.
   Which expression represents the population levels in @y years from
   now?    ]],

   function( self, nm )
      name = nm
      local xvec = vec.random( 5, 100, false )
      x1,x2,x3,x4,x5 = table.unpack( xvec )
      y = math.random( 3, 9 )
      local anslst = {}
      for a,b,c in signIter('bbb') do
	 local tmpl, pow, xinit, xfac, afac
	 if a then
	    xinit = mat.splitVector( xvec, 1 )
	 else 
	    xinit = mat.splitVector( listReverse( xvec ), 1 )
	 end
	 if b then 
	    xfac = xinit:tolatex()
	    afac = [[A^]] .. y
	 else 
	    xfac = xinit:tolatex() .. [[^]] .. y
	    afac = 'A'
	 end 
	 if c then
	    tmpl = [[\(]] .. afac .. xfac .. [[\)]]
	 else 
	    tmpl = [[\(]] .. xfac .. afac .. [[\)]]
	 end 
	 table.insert( anslst, tmpl )
	 end 
      return anslst
   end 
)
