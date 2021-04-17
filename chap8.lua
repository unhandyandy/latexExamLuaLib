-- -*-lua-*-

frc = require('fraction')
vec = require('vector')
st = require('sets')
line = require('line')()
max = require('maxima')
line.max = max.new()
line:initMaxima()
line.dir = '/home/dabrowsa/math/maxima/plots/'
line.scale = .4

mat = require('matrix')

mp = require('mathProblem')
mp.chcFun = [[\qrowFour]]
-- mp.numberChoices = 8
mp.mcP = true

ef = require('enumForm')
answers = ef.new()

one = frc.new( 1, 1 )

function mkp( s1, s2, dt )
   return [[\( p_{]] .. s1 .. [[,]] .. s2 .. [[}(]] .. dt .. [[)\)]]
end 

function mkpdesc( s1, s2, dt )
   local pow = ifset( dt == 1, "", dt )
   return string.format( 
      [[ the \(( %d, %d )\) entry of \(P^{%s}\) ]], 
      s1, s2, pow ) 
end 

pMeaning = mp:new(
   [[ Suppose that a Markov chain with @numstates states and with transition matrix \(P\)
   is in state @stinit on the @t1ord
   observation.  Which of the following expressions represents the
   probability that it will be in state @stlast on the @t2ord
   observation?  ]],

   function ( self )
      local t1 = math.random( 1, 5 )
      stinit, stlast, tdel = distinctRands( 3, 1, 5 )
      numstates = math.max(stinit, stlast)
      local t2 = t1 + tdel
      t1ord, t2ord = getOrdinal( t1 ), getOrdinal( t2 )
      return { mkpdesc( stinit, stlast, tdel ),
	       mkpdesc( stinit, stlast, t2 ),
	       mkpdesc( stlast, stinit, tdel ),
	       mkpdesc( stlast, stinit, t2 ),
	       mkpdesc( t1, t2, stlast ),
	       mkpdesc( t1, t2, stinit ),
	       mkpdesc( t2, t1, stlast ),
	       mkpdesc( t2, t1, stinit ),
	       mkpdesc( stinit, t1, t2 ),
	       mkpdesc( stlast, t2, t1 ) }
   end,
   [[\qrowTwo]]
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
pValue.chcFun = [[\qrowEight]]

function randTrans( n, max )
   n = n or 3
   max = max or 10
   local rows = {}
   for i = 1,n do
      --m = math.random( 2, max )
      local rn = vec.new({ randSummands( n, max ) })
      table.insert( rows, one / max * rn )
   end 
   return mat.new( rows )
end 
      
mcSequence = mp:new( 
   [[ Suppose a Markov Chain has transition matrix
   \[ @tm. \]
   If the system starts in state @s1, what is the probability that it
   goes to state @s2 on the next observation, and then goes to state
   @s3 on the following observation?  ]],

   function( self )
      tm = randTrans( 4, 8 )
      s1, s2, s3 = distinctRands( 3, 1, 4 )
      return { tm[ s1 ][ s2 ] * tm[ s2 ][ s3 ],
	       tm[ s2 ][ s1 ] * tm[ s3 ][ s2 ],
	       tm[ s1 ][ s2 ] * tm[ s1 ][ s3 ],
	       tm[ s2 ][ s1 ] * tm[ s3 ][ s1 ],
	       tm[ s2 ][ s3 ] * tm[ s3 ][ s1 ],
	       tm[ s2 ][ s1 ] * tm[ s1 ][ s3 ],
	       tm[ s1 ][ s3 ] * tm[ s2 ][ s1 ],
	       tm[ s1 ][ s3 ], tm[ s1 ][ s2 ], tm[ s3 ][ s1 ], tm[ s2 ][ s1 ],
	       one * 0, one,
	       frc.random( one/12, one * 11/12 ),
	       frc.random( one/12, one * 11/12 ),
	       frc.random( one/12, one * 11/12 ),
	       frc.random( one/12, one * 11/12 ) }
   end
)

regular = mp:new(
   [[ Which of the following transition matrices is/are for a regular
   Markov Chain?  

   \[ X = @amat \qquad Y = @bmat \qquad Z = @cmat \] ]],
   
   function( self )
      amat = randTrans(3,2)
      bmat = randTrans(3,2)
      while amat == bmat do bmat = randTrans(3,2) end
      cmat = randTrans(3,2)
      while amat == cmat or bmat == cmat do cmat = randTrans(3,2) end
      local ans = { amat:isregular(), bmat:isregular(), cmat:isregular() }
      local anslst = {}
      for a,b,c in signIter( 'bbb' ) do
	 local curans = {}
	 if a == ans[1] then
	    table.insert( curans, [[\(X\)]] )
	 end
	 if b == ans[2] then
	    table.insert( curans, [[\(Y\)]] )
	 end
	 if c == ans[3] then
	    table.insert( curans, [[\(Z\)]] )
	 end
	 curans = table.concat( curans, ', ' )
	 if curans == '' then curans = 'none' end
	 table.insert( anslst, curans )
      end
      return anslst
   end,
   [[\qrowFour]]
)


stateVecWrite = mp:new(
   [[ A Markov Chain with 4 states is currently equally likely to be
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
   [[\qrowTwo]]
)

stateVecProject = mp:new(
   [[ A Markov Chain has the transition matrix
   \[  P = @trans, \]
   and currently has state vector \( @init \).
   What is the probability it will be in state @stend after @deltstr more
   stages (observations) of the process? ]],

   function( self )
      local size = 2
      trans = randTrans( size, 6 )
      while trans[1]==trans[2] do trans = randTrans( size ) end
      local delt = 2
      deltstr = getCardinal( delt )
      init = one / 6 * mat.new({{ randSummands( size, 6 ) }})
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
-- stateVecProject.chcFun = [[\chcSix]]


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
      return { stable( tm ), mkRandSeq( 40, randProbVec, size ) }
   end 
)


require("transitionDia.lua")

tdFill = mp:new(
   [[ What is the value of \( @unknown \) in the transition 
   diagram? \\

   @td ]],
   function( self )
      local missing = { math.random(3), math.random(3), math.random(3) }
      local unknownind = math.random(3)
      unknown = ({ 'x', 'y', 'z' })[ unknownind ]
      -- local function ansfrm( a,b,c )
      -- 	 local frm = [[ \( \begin{array}{rcl} 
      --      x &=& %s \\ y &=& %s \\ z &=& %s 
      --    \end{array} \) ]]
      -- 	 return frm:format(mathToStr(a),mathToStr(b),mathToStr(c))
      -- end 
      local tm = randTM( 3, 6 )
      --print( '\n tm = ' .. tm:__tostring() .. '\n' )
      p11, p12, p13 = table.unpack( tm[1] )
      p21, p22, p23 = table.unpack( tm[2] )
      p31, p32, p33 = table.unpack( tm[3] )
      anslst = { tm[ unknownind ][ missing[ unknownind ] ],
		 p11, p12, p13, p21, p22, p23, p31, p32, p33,
		 p11 + p12, p13 + p21, p22 + p23, p31 + p32, p32 + p33,
		 p12 + p13, p21 + p22, p23 + p31, p11 + p33,
		 0, 1, 
		 frc.random( 0, 1 ), frc.random( 0, 1 ), frc.random( 0, 1 ) }
      -- anslst = { ansfrm( tm[1][ missing[1] ],
      -- 			  tm[2][ missing[2] ],
      -- 			  tm[3][ missing[3] ] ),
      -- 		 mkRandSeq( 10, function()
      -- 			       return ansfrm( mkRandSeq( 3, function()
      -- 							    return math.random( 6 ) * one / 6
      -- 							    end ) )
      -- 				end ) }
      if missing[1] == 1 then
      	 tm[1][1] = 'x'
      elseif missing[1] == 2 then
      	 tm[1][2] = 'x'
      else 
      	 tm[1][3] = 'x'
      end
      if missing[2] == 1 then
      	 tm[2][1] = 'y'
      elseif missing[2] == 2 then
      	 tm[2][2] = 'y'
      else 
      	 tm[2][3] = 'y'
      end
      if missing[3] == 1 then
      	 tm[3][1] = 'z'
      elseif missing[3] == 2 then
      	 tm[3][2] = 'z'
      else 
      	 tm[3][3] = 'z'
      end
      td = conditionalTD( tm )
      --print( '\n anslst[2] = ' .. anslst[2] .. '\n' )
      return anslst
   end,
   [[\qrowEight]]
)




tdToTM = mp:new(
   [[ Which transition matrix corresponds to the given transition
   diagram? 

   @td ]],
   function( self )
      local tm = randTM( 3, 6 )
      td = conditionalTD( tm )
      --print( '\n td = ' .. td .. '\n' )
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
   end
)

function normalizeVec( v )
   local l = #v
   local v1 = vec.zero( l, 1 )
   local sum = v * v1
   return one / sum * v
end

tmFind = mp:new(
   { [[ Two roommates play a game together every night.  They own three
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
      [[ A Dinner Club goes out to eat once a week.  It visits three kinds of
   restaurants, Asian, Mediterranean, and Mexican, but they never visit the same
   type of restaurant two weeks in a row.
If they go to an Asian restaurant one week then they are @r123 likely to go to a
   Mediterranean as a Mexican the next week.
If they go to a Mediterranean restaurant one week then they are @r213 likely to
   to go to an Asian as a Mexican the next week.
If they go to a Mexican restaurant one week then they are @r312 likely to go to
   an Asian as a Mediterranean the next week.
If we think of this as a Markov Chain in which state 1 is Asian, state 2 is
   Mediterranean, and state 3 is Mexican, then what is the transition matrix?
]]
   },

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
   end
)



