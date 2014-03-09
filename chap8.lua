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

function mkp( s1, s2, dt )
   return [[\( p_{]] .. s1 .. [[,]] .. s2 .. [[}(]] .. dt .. [[)\)]]
end 

pMeaning = mp:new(
   [[ Suppose that a Markov chain is in state @stinit on the @t1ord
   observation.  Which of the following expressions represents the
   probability that it will be in state @stlast on the @t2ord
   observation?  ]],

   function ( self )
      local t1 = math.random( 1, 5 )
      stinit, stlast, tdel = distinctRands( 3, 1, 5 )
      local t2 = t1 + tdel
      t1ord, t2ord = getOrdinal( t1 ), getOrdinal( t2 )
      return { mkp( stinit, stlast, tdel ),
	       mkp( stinit, stlast, t2 ),
	       mkp( stlast, stinit, tdel ),
	       mkp( stlast, stinit, t2 ),
	       mkp( t1, t2, stlast ),
	       mkp( t1, t2, stinit ),
	       mkp( t2, t1, stlast ),
	       mkp( t2, t1, stinit ),
	       mkp( stinit, t1, t2 ),
	       mkp( stlast, t2, t1 ) }
   end 
)

pValue = mp:new(
   [[ Suppose that a Markov chain has transition matrix
   \[ P = @pmat. \] 
   What is the value of @pltx?  You may find the following helpful.
\[ P^2 = @p2mat \qquad P^3 = @p3mat\] ]],

   function( self )
      local stinit, stlast, tdel = distinctRands( 3, 1, 3 )
      pltx = mkp( stinit, stlast, tdel )
      local v1 = 1 / 10 * vec.new( { distinctSummands( 3, 10 ) } )
      local v2 = 1 / 10 * vec.new( { distinctSummands( 3, 10 ) } )
      local v3 = 1 / 10 * vec.new( { distinctSummands( 3, 10 ) } )
      pmat = mat.new({v1,v2,v3})
      p2mat = pmat * pmat
      p3mat = p2mat * pmat
      local mats = { pmat, p2mat, p3mat }
      local wrongdel = tdel - 1
      if wrongdel == 0 then wrongdel = 3 end
      return { mats[ tdel ][ stinit ][ stlast ],
	       mats[ tdel ][ stlast ][ stinit ],
	       mats[ stinit ][ tdel ][ stlast ],
	       mats[ stlast ][ tdel ][ stinit ],
	       mats[ wrongdel ][ stinit ][ stlast ],
	       mats[ wrongdel ][ stlast ][ stinit ],
	       mats[ stinit ][ stlast ][ tdel ],
	       mats[ stlast ][ stinit ][ tdel ],
	       mats[ tdel ][ stinit ][ wrongdel ],
	       mats[ tdel ][ stlast ][ wrongdel ],
	       mats[ tdel ][ wrongdel ][ stinit ],
	       mats[ tdel ][ wrongdel ][ stlast ],
	       mkSeqFrFun( 27, 
			   function( n, b, d ) 
			      i,j,k = integerInBase( n, b, d )
			      i,j,k = i+1,j+1,k+1
			      return mats[k][i][j]
			   end, 
			   3, 3 ) }
   end 
)

function randTrans( n, max )
   n = n or 3
   max = max or 10
   local rows = {}
   for i = 1,n do
      local rn = vec.new({ randSummands( n, max ) })
      table.insert( rows, 1/max * rn )
   end 
   return mat.new( rows )
end 
      

regular = mp:new(
   [[ Which of the following transition matrices is/are regular?

   \[ A = @amat \qquad B = @bmat \qquad C = @cmat \] ]],
   
   function( self )
      amat = randTrans(3,2)
      bmat = randTrans(3,2)
      cmat = randTrans(3,2)
      local ans = { amat:isregular(), bmat:isregular(), cmat:isregular() }
      local anslst = {}
      for a,b,c in signIter( 'bbb' ) do
	 local curans = {}
	 if a == ans[1] then
	    table.insert( curans, 'A' )
	 end
	 if b == ans[2] then
	    table.insert( curans, 'B' )
	 end
	 if c == ans[3] then
	    table.insert( curans, 'C' )
	 end
	 curans = table.concat( curans, ', ' )
	 if curans == '' then curans = 'none' end
	 table.insert( anslst, curans )
      end
      return anslst
   end 
)

stateVecWrite = mp:new(
   [[ A markov chain with 4 states is currently equally likely to be
   in states @s1 and @s2, but is @r31 times as likely to be in state
   @s3 as in @s1, and is @r43 times as likely to be in @s4 as in @s3.
   What is the state vector that describes this situation? ]],

   function( self )
      s1,s2,s3,s4 = distinctRands( 4, 1, 4 )
      r31, r43 = distinctRands( 2, 2, 5 )
      local total = one * ( 2 + r31 + r43 * r31 )
      local totalw1 = one * ( 2 + r31 + r43 )
      local ans = vec.zero( 4 )
      ans[s1] = 1 / total
      ans[s2] = 1 / total
      ans[s3] = r31 / total
      ans[s4] = r43 * r31 / total
      local answ1 = vec.zero( 4 )
      answ1[s1] = 1 / totalw1
      answ1[s2] = 1 / totalw1
      answ1[s3] = r31 / totalw1
      answ1[s4] = r43 / totalw1
      local anslst = {}
      for a,b,c in signIter( 'bbb' ) do
	 local cur
	 if a then
	    cur = ans:clone()
	 else 
	    cur = answ1:clone()
	 end
	 if not b then 
	    if a then
	       cur = total * cur
	    else 
	       cur = totalw1 * cur
	    end 
	 end
	 --print( '\n cur = ' .. cur:__tostring() .. '\n' )
	 if not c then
	    cur = one / 2 * cur
	 end 
	 table.insert( anslst, cur )
      end 
      return anslst
   end,
   [[\chcs]]
)

stateVecProject = mp:new(
   [[ A Markov chain has the transition matrix
   \[  P = @trans, \]
   and currently has state vector \( @init \).
   What is the probability it will be in state @stend after @deltstr more
   stages of the process? ]],

   function( self )
      local size = 2
      trans = randTrans( size )
      local delt = 2
      deltstr = getCardinal( delt )
      init = 0.1 * mat.new({{ randSummands( size, 10 ) }})
      stend = math.random( size )
      local right = init * (trans ^ delt)
      local wrong = init * (trans ^ ( delt - 1 ))
      return { right[1][ stend ],
	       1 - right[1][ stend ],
	       wrong[1][ stend ],
	       ( trans * trans )[1][ stend ],
	       ( trans * trans )[2][ stend ],
	       right[1][1],
	       right[1][2],
	       wrong[1][1],
	       wrong[1][2],
	       ( trans * trans )[1][1],
	       ( trans * trans )[2][2],
	       ( trans * trans )[1][2],
	       ( trans * trans )[2][1],
	       0.01 * math.random(100),
	       0.01 * math.random(100),
	       0.01 * math.random(100),
	       0.01 * math.random(100),
	       0.01 * math.random(100),
	       0.01 * math.random(100),
	       0.01 * math.random(100),
	       0.01 * math.random(100) }
   end 
)

function stable( tm )
   local r = tm:getDim()
   local v1 = vec.zero( r, 1 )
   local tmt = mat.transpose( tm - mat.identity( r ) )
   table.remove( tmt )
   local sqmat = mat.new( { v1, table.unpack( tmt ) } )
   --print( '\n sqmat = \n' .. sqmat:__tostring() .. '\n' )
   --print( '\n sqmat^-1 = \n' .. sqmat:inverse():__tostring() .. '\n' )
   local v2 = vec.zero( r )
   v2[1] = 1
   local mv2 = mat.transpose( mat.new( { v2 } ) )
   --print( '\n mv2 = \n' .. mv2:__tostring() .. '\n' )
   local stmat = sqmat:inverse() * mv2
   return mat.transpose( stmat )[1]
end

function randProbVec( l, sum )
   sum = sum or math.random( 2, 9 )
   return one/sum * vec.new({ randSummands( l, sum ) })
end

function randTM( l, max )
   local rows = {}
   for i = 1, l do
      table.insert( rows, randProbVec( l, 
				       math.random( 2, max ) ) )
   end 
   return mat.new( rows )
end 

stableFind = mp:new(
   [[ Find the vector of stable probabilities for the Markov chain
   with this transition matrix.
\[ P = @tm \] ]],

   function( self, size )
      size = size or 2
      local test = true
      while test do
	 tm = randTM( size, 4 )
	 test = not tm:isregular() or tm[1] == tm[2]
      end 
      return { stable( tm ), mkRandSeq( 30, randProbVec, size ) }
   end 
)

tdFill = mp:new(
   [[ What are values of \(x\), \(y\), and \(z\) in the transition 
   diagram? \\

   \transitionDiaCFull{@p11}{@p12}{@p13}{@p21}{@p22}{@p23}{@p31}{@p32}{@p33} ]],
   function( self )
      local missing = { math.random(3), math.random(3), math.random(3) }
      local function ansfrm( a,b,c )
	 local frm = [[ \( \begin{array}{rcl} 
           x &=& %s \\ y &=& %s \\ z &=& %s 
         \end{array} \) ]]
	 return frm:format(mathToStr(a),mathToStr(b),mathToStr(c))
      end 
      local tm = randTM( 3, 6 )
      --print( '\n tm = ' .. tm:__tostring() .. '\n' )
      p11, p12, p13 = table.unpack( tm[1] )
      p21, p22, p23 = table.unpack( tm[2] )
      p31, p32, p33 = table.unpack( tm[3] )
      anslst = { ansfrm( tm[1][ missing[1] ],
			  tm[2][ missing[2] ],
			  tm[3][ missing[3] ] ),
		 mkRandSeq( 10, function()
			       return ansfrm( mkRandSeq( 3, function()
							    return math.random( 6 ) * one / 6
							    end ) )
				end ) }
      if missing[1] == 1 then
      	 p11 = 'x'
      elseif missing[1] == 2 then
      	 p12 = 'x'
      else 
      	 p13 = 'x'
      end
      if missing[2] == 1 then
      	 p21 = 'y'
      elseif missing[2] == 2 then
      	 p22 = 'y'
      else 
      	 p23 = 'y'
      end
      if missing[3] == 1 then
      	 p31 = 'z'
      elseif missing[3] == 2 then
      	 p32 = 'z'
      else 
      	 p33 = 'z'
      end
      --print( '\n anslst[2] = ' .. anslst[2] .. '\n' )
      return anslst
   end 
)

function conditionalTD( tm )
   local form = [[ \begin{figure}[h]\centering
     \begin{tikzpicture}[>=triangle 45,shorten >=1pt,node distance=3cm,on grid,auto,bend angle=15] 
       \node[state] at (0,-1.7) (3)   {1}; 
         \node[state] at (2,2) (2) {2}; 
           \node[state] at (-2,2) (1) {3};
             \path[->] 
             (1) %s
             (2) %s
             (3) %s;
           \end{tikzpicture}
         \end{figure} ]]
   local edges = { { [[ edge [loop left] node {\(%s\)} (1) ]],
		     [[ edge [bend left] node {\(%s\)} (2) ]],
		     [[ edge [bend left] node {\(%s\)} (3) ]] },
		   { [[ edge [bend left] node {\(%s\)} (1) ]],
		     [[ edge [loop right] node {\(%s\)} (2) ]], 
		     [[ edge [bend left] node {\(%s\)} (3) ]] },
		   { [[ edge [bend left] node {\(%s\)} (1) ]],
		     [[ edge [bend left] node {\(%s\)} (2) ]],
		     [[ edge [loop below] node {\(%s\)} (3) ]] } }
   local subs = {}
   for i = 1,3 do
      local lst = {}
      for j = 1,3 do
	 p = tm[ i ][ j ]
	 if p > 0 then
	    table.insert( lst, edges[ i ][ j ]:format( p ) )
	 end 
      end 
      table.insert( subs, table.concat( lst, ' ' ) )
   end 
   return form:format( table.unpack( subs ) )
end 

function conditionalTD2( tm )
   local form = [[ \begin{figure}[h]\centering
     \begin{tikzpicture}[>=triangle 45,shorten >=1pt,node distance=3cm,on grid,auto,bend angle=15] 
         \node[state] at (2,2) (2) {2}; 
           \node[state] at (-2,2) (1) {1};
             \path[->] 
             (1) %s
             (2) %s
           \end{tikzpicture}
         \end{figure} ]]
   local edges = { { [[ edge [loop left] node {\(%s\)} (1) ]],
		     [[ edge [bend left] node {\(%s\)} (2) ]] },
		   { [[ edge [bend left] node {\(%s\)} (1) ]],
		     [[ edge [loop right] node {\(%s\)} (2) ]] } }
   local subs = {}
   for i = 1,2 do
      local lst = {}
      for j = 1,2 do
	 p = tm[ i ][ j ]
	 if p > 0 then
	    table.insert( lst, edges[ i ][ j ]:format( p ) )
	 end 
      end 
      table.insert( subs, table.concat( lst, ' ' ) )
   end 
   return form:format( table.unpack( subs ) )
end 


tdToTM = mp:new(
   [[ Which transition matrix corresponds to the given transition
   diagram? 

   @td ]],
   function( self )
      local tm = randTM( 3, 6 )
      td = conditionalTD( tm )
      print( '\n td = ' .. td .. '\n' )
      tmw1 = tm:clone()
      tmw1[1], tmw1[2] = tmw1[2], tmw1[1]
      tmw2 = tm:clone()
      tmw2[3], tmw2[2] = tmw2[2], tmw2[3]
      tmw3 = tm:clone()
      tmw3[3], tmw3[1] = tmw3[1], tmw3[3]
      return { tm, mat.transpose(tm),
	       tmw1, mat.transpose(tmw1),
	       tmw2, mat.transpose(tmw2),
	       tmw3, mat.transpose(tmw3) }
   end,
   [[\chcs]]
)

function normalizeVec( v )
   local l = #v
   local v1 = vec.zero( l, 1 )
   local sum = v * v1
   return one / sum * v
end

tmFind = mp:new(
   [[ Two roommates play a game together every night.  They own three
   games, Monopoly, Blokus, and Chess, and they never play the same
   game two nights in a row.  If they play Monopoly one night they are
   @r123    likely to play Blokus as to play Chess the following
   night.  If they play Blokus one night they are @r213 likely to
   play Monopoly as to play Chess the following night.  If they play
   Chess one night they are @r312   likely to play Monopoly as
   to play Blokus the following night.  If we think of this as a
   Markov chain, with the first state being Monopoly, the second state
   being Blokus, and the third state being Chess, what is the
   transition matrix \(P\)? ]] ,

   function( self )
      local rats = { distinctRands( 3, 1, 3 ) }
      local function mkComp( n )
	 if n == 1 then
	    return 'equally'
	 else 
	    return getCardinal( n ) .. ' times as' 
	 end 
      end
      local ratstrs = map( rats, mkComp )
      r123, r213, r312 = table.unpack( ratstrs )
      local ans = mat.zero( 3, 3 )
      ans[1][2], ans[1][3] = rats[1], 1
      ans[2][1], ans[2][3] = rats[2], 1
      ans[3][1], ans[3][2] = rats[3], 1
      ans = mat.new( map( ans, normalizeVec ) )
      local answ1 = ans:clone()
      answ1[1][2], answ1[1][3] =  answ1[1][3], answ1[1][2]
      answ1[2][1], answ1[2][3] =  answ1[2][3], answ1[2][1]
      answ1[3][1], answ1[3][2] =  answ1[3][2], answ1[3][1]
      local anslst = {}
      for a,b,c in signIter( 'bbb' ) do
	 local cur
	 if a then
	    cur = ans:clone()
	 else 
	    cur = answ1:clone()
	 end 
	 if not b then 
	    cur = mat.transpose( cur )
	 end
	 if not c then
	    cur = cur + mat.identity( 3 )
	 end
	 table.insert( anslst, cur )
      end 
      return anslst
   end,
   [[\chcs]]
)



--[[
\item 
A Markov chain has the transition matrix 
$P = \left[\begin{array}{ccc} 
0.7 & 0.1 & 0.2 \\ 
0.3 & 0.7 & 0 \\ 
1 & 0 & 0 
\end{array}\right]$. 
For this matrix, 
\newline 
$P(2) = \left[\begin{array}{ccc} 
0.72 & 0.14 & 0.14 \\ 
0.42 & 0.52 & 0.06 \\ 
0.70 & 0.10 & 0.20 
\end{array}\right]$ 
and $P(3) = 
\left[\begin{array}{ccc} 
0.686 & 0.17 & 0.144 \\ 
0.51 & 0.406 & 0.084 \\ 
0.72 & 0.14 & 0.14 
\end{array}\right]$.
\\

{\bf Be sure to circle your final answer for each part below.}
\\

a) [2pts] What is $p_{32}(2)$?
\vspace{0.6in}

b) [2pts] If the system is observed to be in state 1 on the first observation, what's the probability it will be in state 3 on the fourth observation?
\vspace{0.6in}

c) [1pt] Is this Markov chain regular?
\vspace{0.6in}

d) [5pts] If the state vector on observation 1 is $\left[\begin{array}{ccc} \frac{1}{2} & \frac{1}{2} & 0 \end{array}\right]$, what's the state vector for observation 3?




\item 
A Markov chain has the transition matrix\quad
$$P=\begin{bmatrix}0.6 &0.4\\
0.2 &0.8
\end{bmatrix}.$$
If the chain is observed to be in state 2 now, what is the
probability that two observations later it will be
in state 1?
$$\begin{array}{lll}
(a) \quad 0.44  &(b) \quad 0.24  &(c) \quad 0.28  \\
\\
(d) \quad 0.56 &(e) \quad 0.40 & (f) \quad 0.72 \\
\\
\multicolumn{3}{l}{(g)\quad \mbox{None of the above.}} \end{array}$$




\item  
Find the vector of stable probabilities for the transition matrix
below:
$
\begin{bmatrix} 
\frac{1}{2} & \frac{1}{2} \\
 1& 0
\end{bmatrix}$

$$\begin{array}{lll}
(a) \quad \ds{\begin{bmatrix} \frac{1}{3} &\frac{2}{3} \end{bmatrix}}
&
(b)\quad \ds{\begin{bmatrix} \frac{1}{2} &\frac{1}{2}\end{bmatrix}}
&
(c) \quad  \ds{\begin{bmatrix} -\frac{2}{3}& \frac{1}{3} \end{bmatrix}}\\
\\
(d) \quad \ds{\begin{bmatrix} -\frac{2}{3} &\frac{4}{3} \end{bmatrix}}
&
(e) \quad \ds{\begin{bmatrix} \frac{2}{3}& \frac{1}{3} \end{bmatrix}}
&
(f) \quad \ds{\begin{bmatrix} \frac{3}{2}& \frac{1}{2}\end{bmatrix}}\\
\\
\multicolumn{3}{l}{(g)\quad \mbox{None of the above.}}\end{array}$$



\item   
Suppose that $P=\begin{bmatrix}
{\frac{1}{3}} & {\frac{2}{3}} & 0 \\[0.3em]
{\frac{1}{6}} & {\frac{1}{3}} & {\frac{1}{2}} \\[0.3em]
{\frac{1}{4}} & {\frac{1}{4}} & {\frac{1}{2}} \end{bmatrix}$ 
is the transition matrix for a Markov chain.
If the system starts in 
\smallskip

state 1, what state is it most likely to be in
on the next observation?
$$\begin{array}{lll}
(a) \quad 0  &(b) \quad 1 &(c) \quad 2 \\
\\
(d) \quad 3  &(e) \quad 4 &(f) \quad 5 \\
\\
\multicolumn{3}{l}{(g)\quad \mbox{None of the above.}} \end{array}$$



\item 
What are the values of $x$, $y$, and $z$ in the given
transition diagram?

\transitionDia3{0.4}{0.4}{x}{0.2}{0.3}{z}{0.5}{y}{0.5}




\item 
Which of the following gives the probability that a Markov
chain which is in state 1 on the first observation will be in state 2
on the fourth observation? 
 $$\begin{array}{lll}
 (a) \quad p_{21}(3) & (b) \quad p_{12}(3) & (c) \quad p_{12}(4) \\
 \\
 (d) \quad p_{21}(4) & (e) \quad p_{13}(2) & (f) \quad p_{13}(4) \\
 \\
 \multicolumn{3}{l}{(g)\quad \mbox{None of the above.}} \end{array}
 $$


\item 
A Markov chain has the transition matrix 
$P = \left[\begin{array}{ccc} 
0.7 & 0.1 & 0.2 \\ 
0.3 & 0.7 & 0 \\ 
1 & 0 & 0 
\end{array}\right]$. 
For this matrix, 
\newline $P(2) = \left[\begin{array}{ccc} 
0.72 & 0.14 & 0.14 \\ 
0.42 & 0.52 & 0.06 \\ 
0.70 & 0.10 & 0.20 
\end{array}\right]$ 
and $P(3) = \left[\begin{array}{ccc} 
0.686 & 0.17 & 0.144 \\ 
0.51 & 0.406 & 0.084 \\ 
0.72 & 0.14 & 0.14 
\end{array}\right]$.
\\

{\bf Be sure to circle your final answer for each part below.}
\\

a) [2pts] What is $p_{32}(2)$?
\vspace{0.6in}

b) [2pts] If the system is observed to be in state 1 on the first observation, what's the probability it will be in state 3 on the fourth observation?
\vspace{0.6in}

c) [1pt] Is this Markov chain regular?
\vspace{0.6in}

d) [5pts] If the state vector on observation 1 is $\left[\begin{array}{ccc} \frac{1}{2} & \frac{1}{2} & 0 \end{array}\right]$, what's the state vector for observation 3?


\item
Two roommates play a game together every night.  They own three games,
Monopoly, Blokus, and Chess, and they never play the same game two
nights in a row.  If they play Monopoly one night they are three times as
likely to play Blokus as to play Chess the following night.  If they
play Blokus one night they are equally likely to play Monopoly as to
play Chess the following night.  If they play Chess one night they are
five times as likely to play Monopoly as to play Blokus the following
night.  If we think of this as a Markov chain, with the first state
being Monopoly, the second state being Blokus, and the third state
being Chess, what is the transition matrix $P$?



\item Which of the following is the transition matrix that
corresponds to the given transition diagram?

\transitionDia3{0.1}{0}{0.9}{0.3}{0.2}{0.5}{0}{1}{0}



\item 
A Markov chain has the transition matrix\quad
$$P=\begin{bmatrix}0.6 &0.4\\
0.2 &0.8
\end{bmatrix}.$$
If the chain is observed to be in state 2 now, what is the
probability that two observations later it will be
in state 1?
$$\begin{array}{lll}
(a) \quad 0.44  &(b) \quad 0.24  &(c) \quad 0.28  \\
\\
(d) \quad 0.56 &(e) \quad 0.40 & (f) \quad 0.72 \\
\\
\multicolumn{3}{l}{(g)\quad \mbox{None of the above.}} \end{array}$$
--]]
