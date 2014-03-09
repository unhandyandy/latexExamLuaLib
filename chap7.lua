-- -*-two-mode-*-

frc = require('fraction')
vec = require('vector')
st = require('sets')
line = require('line')()
max = require('maxima')
line.max = max.new()
line:initMaxima()
--line.dir = '/home/dabrowsa/math/maxima/plots/'
--line.scale = .4

mat = require('matrix')

mp = require('mathProblem')
mp.chcFun = [[\chc]]
mp.numberChoices = 8
mp.mcP = true

ef = require('enumForm')
answers = ef.new()

one = frc.new( 1, 1 )


function lpForm( mxn, rel, ovec, mat, tots )
   local obj = ifset( mxn == 'max', 'maximize', 'minimize' )
   local rst = ifset( rel == '<', [[ \leq ]], [[ \geq ]] )
   local tmpl = obj .. [[ \( %sx + %sy + %sz \) \\ 
   subject to the constraints
   \[ \begin{array}{rcl}
     %sx + %sy + %sz &%s& %s \\
     %sx + %sy + %sz &%s& %s \\
     %sx + %sy + %sz &%s& %s 
     \end{array}\] ]]
   local res = tmpl:format( 
      ovec[1],  ovec[2],  ovec[3], 
      mat[1][1], mat[1][2], mat[1][3], rst, tots[1],
      mat[2][1], mat[2][2], mat[2][3], rst, tots[2],
      mat[3][1], mat[3][2], mat[3][3], rst, tots[3] )
   return [[\begin{minipage}{2.5in}\begin{framed}]] .. res .. [[\end{framed}\end{minipage}]]
end


lpSetup = mp:new(
   [[ Formulate the following word problem as a linear programming
   problem.  (Note that the natural constraints \(x
   \geq 0,      y \geq 0,     z \geq 0 \), have been omitted from the
   answers.)  Do {\em not} attempt to solve it! \\
   
   As a tobacco addict, you need at least @ex1 g (grams) of nicotine, 
   @ex2 g of tar, 
   and @ex3 g of CO (carbon monoxide) every day to
   keep yourself functioning smoothly.  
   A cigarette costs \$@ob1 and
   provides @in11 mg (milligrams) of nicotine, 
   @in12 mg of tar, and @in13 mg of CO.  
   A cigar costs \$@ob2 and provides 
   @in21 mg of nicotine, @in22 mg of tar, and @in23 mg of CO.  
   A bowl of pipe tobacco costs \$@ob3 and provides 
   @in31 mg  of nicotine, @in32 mg of tar, and @in33 mg of CO.  
   What's the cheapest
   way to get your fix of tobacco?  

   Use the variables
   \[ \begin{array}{rcl}
     x &=& \tx{\# cigarettes} \\
     y &=& \tx{\# cigars} \\
     z &=& \tx{\# bowls of pipe tobacco.}
     \end{array} \]
     
   (Note: 1 g. = 1000 mg.) ]],

   function( self )
      ex1,ex2,ex3 = distinctRands( 3, 1, 20 )
      ex1,ex2,ex3 = ex1/10,ex2/10,ex3/10
      local mpm = mat.random( 3, 3, 30, false )
      ob1,ob2,ob3 = distinctRands( 3, 1, 9 )
      ob1,ob3 = ob1/10,ob3/10
      in11,in12,in13 = table.unpack( mpm[1] )
      in21,in22,in23 = table.unpack( mpm[2] )
      in31,in32,in33 = table.unpack( mpm[3] )
      local anslst = {}
      for a,b,c in signIter( 'bbb' ) do
	 local o1,o2,o3,t1,t2,t3, obj, rel
	 if a then
	    rel = '>'
	 else 
	    rel = '<'
	 end 
	 if b then
	    obj = 'min'
	 else 
	    obj = 'max'
	 end 
	 if c then
	    o1,o2,o3,t1,t2,t3 = ob1,ob2,ob3,ex1*1000,ex2*1000,ex3*1000
	 else 
	    o1,o2,o3,t1,t2,t3 = ex1*1000,ex2*1000,ex3*1000,ob1,ob2,ob3
	 end 
	 table.insert( anslst, lpForm( obj, rel, 
				       {o1,o2,o3}, mpm, 
				       {t1,t2,t3} ) )
      end 
      return anslst
   end,
   [[\chcs]]
)



lpSetupSeuss = mp:new(
   { [[ Formulate the following word problem as a linear programming
   problem.  (Note that the natural constraints \(x
   \geq 0,      y \geq 0,     z \geq 0 \), have been omitted from the
   answers.)  Do {\em not} attempt to solve it! \\
   
   The @name is an animal that
   eats three foods: @fn1's, @fn2's, and @fn3's.
   A @fn1 costs \$@ob1 and
   provides @in11 mg (milligrams) of @nn1, 
   @in12 mg of @nn2, and @in13 mg of @nn3.  
   A @fn2 costs \$@ob2 and provides 
   @in21 mg of @nn1, @in22 mg of @nn2, and @in23 mg of @nn3.  
   A @fn3 costs \$@ob3 and provides 
   @in31 mg  of @nn1, @in32 mg of @nn2, and @in33 mg of @nn3.  
   The @name needs at least @ex1 g (grams) of @nn1, 
   @ex2 g of @nn2, 
   and @ex3 g of @nn3 every day to live.
   What's the cheapest
   way to feed your pet @name for one day?  

   Use the variables
   \[ \begin{array}{rcl}
     x &=& \tx{\# @fn1's} \\
     y &=& \tx{\# @fn2's} \\
     z &=& \tx{\# @fn3's.}
     \end{array} \]
     
   (Note: 1 g. = 1000 mg.) ]],

[[ Formulate the following word problem as a linear programming
   problem.  (Note that the natural constraints \(x
   \geq 0,      y \geq 0,     z \geq 0 \), have been omitted from the
   answers.)  Do {\em not} attempt to solve it! \\
   
   The @name is an animal that
   eats three foods: @fn1's, @fn2's, and @fn3's.
   One @fn1 makes the @name happy for @ob1 hours,
   a @fn2 makes it happy for @ob2 hours,
   and a @fn3 makes it happy for @ob3 hours.
   A @fn1 costs \$@in11 and
   provides 
   @in12 mg of @nn2 and @in13 mg of @nn3.  
   A @fn2 costs \$@in21 and provides 
   @in22 mg of @nn2 and @in23 mg of @nn3.  
   A @fn3 costs \$@in31 and provides 
   @in32 mg of @nn2 and @in33 mg of @nn3.  
   Unfortunately @nn2 and @nn3 are toxins and the @name cannot have
   more than @ex2 g (grams) of @nn2 or 
   more than @ex3 g of @nn3 per day. 
   How do you make your pet @name as happy as possible 
   while keeping it alive on a budget of \$@ex1 per day?

   Use the variables
   \[      x = \tx{\# @fn1's} \quad
     y = \tx{\# @fn2's} \quad
     z = \tx{\# @fn3's.}
      \]
     
   (Note: 1 g. = 1000 mg.) ]] },

   function( self, nameLst )
      local vn = self.vernum
      name = nameLst.name
      nn1, nn2, nn3 = nameLst.nn1,  nameLst.nn2,  nameLst.nn3
      fn1, fn2, fn3 = nameLst.fn1,  nameLst.fn2,  nameLst.fn3
      ex1,ex2,ex3 = distinctRands( 3, 1, 20 )
      ex1,ex2,ex3 = ex1/10,ex2/10,ex3/10
      ex1lst = { ex1*1000, ex1 }
      local mpm = mat.random( 3, 3, 30, false )
      ob1,ob2,ob3 = distinctRands( 3, 1, 9 )
      in11,in12,in13 = table.unpack( mpm[1] )
      in21,in22,in23 = table.unpack( mpm[2] )
      in31,in32,in33 = table.unpack( mpm[3] )
      local anslst = {}
      for a,b,c in signIter( 'bbb' ) do
	 local o1,o2,o3,t1,t2,t3, obj, rel
	 if a then
	    rel = ({'>','<'})[vn]
	 else 
	    rel = ({'<','>'})[vn]
	 end 
	 if b then
	    obj = ({'min','max'})[vn]
	 else 
	    obj = ({'max','min'})[vn]
	 end 
	 if c then
	    o1,o2,o3,t1,t2,t3 = ob1,ob2,ob3,ex1lst[vn],ex2*1000,ex3*1000
	 else 
	    o1,o2,o3,t1,t2,t3 = ex1lst[vn],ex2*1000,ex3*1000,ob1,ob2,ob3
	 end 
	 table.insert( anslst, lpForm( obj, rel, 
				       {o1,o2,o3}, mpm, 
				       {t1,t2,t3} ) )
      end 
      --print('\n length = ' .. #anslst .. '\n' )
      return anslst
   end,
   [[\chcs]]
)

function randPt()
   local x = math.random( line.extent[1] + 1, line.extent[3] - 1 )
   local y = math.random( line.extent[2] + 1, line.extent[4] - 1 )
   return { x,y }
end 

lpGraph = mp:new(
   [[ Which graph represents the given system of inequalities? \\

\qquad \( \begin{array}{rl}
{\rm I. }& @in1 \\
{\rm II. }& @in2 \\
{\rm III. }& @in3 \\
\end{array} \) ]],

   function( self )
      local p1, p2 = randPt(), randPt()
      while p1[1] == p2[1] and p1[2] == p2[2] do
	 p2 = randPt()
      end
      local l1 = line.newFromPoints( p1, p2 )
      local p3 = randPt()
      while l1:contains( p3 ) do p3 = randPt() end
      local l2 = line.newFromPoints( p2, p3 )
      local l3 = line.newFromPoints( p3, p1 )
      in1 = hp.new( l1, randSign() )
      in2 = hp.new( l2, randSign() )
      in3 = hp.new( l3, randSign() )
      if not hp.cons3( in1, in2, in3 ) then in3.sign = -in3.sign end
      in1.line.name = 'l1'
      in2.line.name = 'l2'
      in3.line.name = 'l3'

      --local xax, yax = line.new( 0, 1, 0 ), line.new( 1, 0, 0 )
      --xax.name, yax.name = '', ''
      --local xnat, ynat = hp.new( yax, 1), hp.new( xax, 1 )
      --hp.maxGraph( in1,in2,in3,xnat, ynat)
      local anslst = {}
      for a,b,c in signIter( 3 ) do
	 local i1, i2, i3 = in1:clone(), in2:clone(), in3:clone()
	 --local nx, ny = xnat:clone(), ynat:clone()
	 i1.sign, i2.sign, i3.sign = a*i1.sign, b*i2.sign, c*i3.sign
	 if hp.cons3( i1, i2, i3 ) then
	    --nx.sign, ny.sign = a*nx.sign, b*ny.sign
	    i1.line.name, i2.line.name, i3.line.name = 
	       'l1' .. a, 'l2' .. b, 'l3' .. c
	    --nx.line.name, ny.line.name = 'x' .. a, 'y' .. b
	    hp.saveGraph( i1, i2, i3 )
	    table.insert( anslst, hp.tolatexpic( i1, i2, i3 ) )
	 end 
      end
      local d1 = in1:clone()
      d1.sign = -d1.sign
      hp.saveGraph( d1, in2 )
      table.insert( anslst, hp.tolatexpic( d1, in2 ) )	 
      return anslst
   end,
   [[\chcs]]
)



lpCorner = mp:new(
   [[ Find the coordinates of corner point @pt of the feasible set in
   the diagram below.  The equations of the lines are as follows.
$$
\begin{array}{rl}
{\rm I:} & @l1 \\
{\rm II:} & @l2 \\
{\rm III:} & @l3 \\
\end{array}
$$
Be aware that I have {\em not} made the
diagram precisely accurate, so you must compute the
corner points algebraically!
 
\begin{figure}[!h]

\includegraphics[scale=.4]{/home/dabrowsa/teach/d117/fig/ex7-fs-corners-0}

\end{figure}

]],

    function( self, q )
	 pt = ({ 'A', 'B', 'C' })[ q ]
	 local x1,y1,x2,y2 = table.unpack( line.extent )
	 local c = math.random( 3, x2 - 1 )
	 local b = math.random( 1, y2 - 3 )
	 local a = { math.random( 1, c - 2 ), 
		     math.random( b + 1, y2 - 1 ) }
	 l1 = line.newFromPoints( a, { 0, b } )
	 local m1 = l1:slope()
	 local m2 = frc.random( one / 2, m1 )
	 l2 = line.newPtSlope( a, m2 )
	 local m3 = frc.random( one / 12, m2 )
	 l3 = line.newPtSlope( { c, 0 }, m3 )
	 local ansver = { a, {0, b}, {c, 0} }
	 local anslst = { ansver[ q ],
			  a, {0, b}, {c, 0},
			  randPt(), randPt(), randPt(), 
			  randPt(), randPt(), randPt(),
			  randPt(), randPt(), randPt(), 
			  randPt(), randPt(), randPt(),
			  randPt(), randPt(), randPt(), 
			  randPt(), randPt(), randPt(),
			  randPt(), randPt(), randPt(), 
			  randPt(), randPt(), randPt() }
	 anslst = map( anslst, 
		       function( p )
			  return [[\((\,]]..p[1]..', '..p[2]..[[\,)\)]]
		       end )
	 return anslst
    end 
)

function ptForm( p )
   --print( '\n p: ' .. type( p ) ..  '\n' )
   return [[(\,]]..p[1]..', '..p[2]..[[\,)]]
end

lpSolve = mp:new(
   [[ Shown in the diagram is a @type feasible set.  The corners of
   the feasible set are all points with integer coordinates. Find the
   {\em locations} of the max and min 
   of the objective function @obj on the feasible set. \\

   @diagram ]],

   function( self, q )
      type = ({ 'bounded', 'unbounded' })[ q ]
      local cx, cy = 2, 2
      local x1,y1,x2,y2 = table.unpack( line.extent )
      x1, y1 = x1 + 1, y1 + 1
      local a = { math.random( x1, cx - 1 ),
		  math.random( y1, cy - 1 ) }
      local b = { math.random( x1, cx - 1 ),
		  math.random( cy + 1, y2 ) }
      local c = { math.random( cx + 1, x2 ),
		  math.random( cy + 1, y2 ) }
      local d = { math.random( cx + 1, x2 ),
		  math.random( y1, cy - 1 ) }
      local lab = line.newFromPoints( a, b )
      local lbc = line.newFromPoints( b, c )
      local lcd = line.newFromPoints( c, d )
      local lda = line.newFromPoints( d, a )
      local hpab = hp.new( lab, 1 )
      if not hpab:contains( { cx, cy } ) then
	 hpab.sign = -1
      end 
      local hpbc = hp.new( lbc, 1 )
      if not hpbc:contains( { cx, cy } ) then
	 hpbc.sign = -1
      end 
      local hpcd = hp.new( lcd, 1 )
      if not hpcd:contains( { cx, cy } ) then
	 hpcd.sign = -1
      end 
      local hpda = hp.new( lda, 1 )
      if not hpda:contains( { cx, cy } ) then
	 hpda.sign = -1
      end 
      local ineqlst = { hpbc, hpda }
      local open = ''
      if q == 1 then
	 listConcat( ineqlst, { hpab, hpcd } )
      elseif lbc:slope() > lda:slope() then
	 table.insert( ineqlst, hpab )
	 open = 'r'
      else 
	 table.insert( ineqlst, hpcd )
	 open = 'l'
      end
      hp.saveGraph( table.unpack( ineqlst ) )
      diagram = hp.tolatexpic( table.unpack( ineqlst ) )
      local ox, oy = distinctRands( 2, -9, 9 )
      obj = [[\( ]] .. ox .. 'x + ' .. oy .. [[y \)]]
      obj = polyToStr( obj )
      local function val(p)
	 return ox * p[1] + oy * p[2]
      end
      local function ord( a, b )
	 return val( a ) < val( b )
      end 
      local ordpts = { a, b, c, d }
      table.sort( ordpts, ord )
      local anstmpl = [[ \(\begin{array}{rl}
        \tx{max: }& %s \\
        \tx{min: }& %s 
        \end{array}\) ]]
      local function ansfrm( n )
	 if q == 1 then
	    return ptForm(ordpts[ n ])
	 else 
	    if open == 'r' and ( ( ordpts[n][1] == c[1] and ordpts[n][2] == c[2] ) or ( ordpts[n][1] == d[1] and ordpts[n][2] == d[2] ) ) then
	       return [[\tx{none}]]
	    elseif  open == 'l' and ( ( ordpts[n][1] == a[1] and ordpts[n][2] == a[2] ) or ( ordpts[n][1] == b[1] and ordpts[n][2] == b[2] ) ) then
	       return [[\tx{none}]]
	    else 
	       return ptForm(ordpts[ n ])
	    end 
	 end 
      end 
      return { anstmpl:format( ansfrm(4), ansfrm(1) ),
	       anstmpl:format( ansfrm(4), ansfrm(2) ),
	       anstmpl:format( ansfrm(4), ansfrm(3) ),
	       anstmpl:format( ansfrm(3), ansfrm(1) ),
	       anstmpl:format( ansfrm(3), ansfrm(2) ),
	       anstmpl:format( ansfrm(3), ansfrm(4) ),
	       anstmpl:format( ansfrm(2), ansfrm(1) ),
	       anstmpl:format( ansfrm(2), ansfrm(3) ),
	       anstmpl:format( ansfrm(2), ansfrm(4) ),
	       anstmpl:format( ansfrm(1), ansfrm(2) ),
	       anstmpl:format( ansfrm(1), ansfrm(3) ),
	       anstmpl:format( ansfrm(1), ansfrm(4) ),
	       anstmpl:format( ptForm({0,0}), ptForm({6,6}),
	       anstmpl:format( ptForm({0,1}), ptForm({5,6}),
	       anstmpl:format( ptForm({1,0}), ptForm({6,5}),
	       anstmpl:format( ptForm({1,1}), ptForm({5,5}) ) }

   end 
)
