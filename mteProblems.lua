-- -*-two-mode-*-

frc = require('fraction')
vec = require('vector')
st = require('sets')
-- mcp = require('mcProblem')
-- mcp.chcFun = [[\chcSix]]
mp = require('mathProblem')
mp.chcFun = [[\qrowFour]]
mp.numberChoices = 8

ef = require('enumForm')
answers = ef.new()

one = frc.one()

--ansBlanks = createBlankList( 25 )

-- needed only with mcProblem
function mkchc( lst ) 
   return randPerm( distinctElems( 6, lst ) )
end


easyTwoSets = mp:new(
   { [[ Suppose that \(A\) and \(B\) are two sets such
     that \(\crd{A}=@A \), \(\crd{B}=@B \), and \(\crd{A\cup B}=@AuB \). 
     If \(\crd{U}=@U \), then what is \(\crd{ @Q }\)? ]],
     
     [[ Suppose that set \(A\) has @A elements, set \(B\) has @B elements, and
     their union has @AuB elements.  If the universe \(U\) has @U elements
     what is the size of \( @Q \)? ]] },
   function( self, q )
      local AB, Ab, aB, ab = distinctRands( 4, 1, 9 )
      local A, B, AuB, U = AB + Ab, AB + aB, Ab + AB + aB, AB + Ab + aB + ab
      local anslst = { AB, Ab, aB, ab }
      local dict = { [[A\cap B]], [[A\cap B']], [[A'\cap B]], [[A'\cap B']] }
      q = q or math.random( 4 )
      return { A = A, B=B, AuB=AuB, U=U, Q=dict[q] },
             listJoin( { anslst[ q ] }, anslst, 
		       { A, B, A + B, 0, U - A, U - B, U } )
   end
)





easyCondProb = mp:new(
   [[ Suppose that \(E\) and \(F\) are two events such
   that \(\pr{E}=%s\), \(\pr{F}=%s\), and \(\pr{E\cap F}=%s\). 
   What is \(%s\)?]],
   function( self )
      local XY, Xy, xY, xy = distinctRands( 4, 1, 9 )
      local total = XY + Xy + xY + xy
      AB, Ab, aB, ab = frc.new(XY,total), frc.new(Xy,total), frc.new(xY,total), frc.new(xy,total)
      local A, B, AuB, U = AB + Ab, AB + aB, Ab + AB + aB, AB + Ab + aB + ab
      local dict = { [[\cpr{E}{F}]], [[\cpr{F}{E}]], [[\cpr{E}{F'}]], [[\cpr{F}{E'}]] }
      local anslst = { frc.new(XY,XY+xY), frc.new(XY,XY+Xy), 
		       frc.new(Xy,Xy+xy), frc.new(xY,xY+xy) }
      local q = math.random( 3, 4 )
      local ans = table.remove( anslst, q )
      return { A, B, AB, dict[q] }, 
             listJoin( { ans }, anslst, { 0 * one, one },
		       { frc.new(XY,total), frc.new(xy,total), 
			 frc.new(Xy,total), frc.new(xY,total) })
   end
)


notSoEasyCondProb = mp:new(
   [[ Suppose that \(E\) and \(F\) are two events such
      that \(\pr{E}= @pe \), \(\pr{F}= @pf \), and \(\pr{E\cup F}= @peuf \). 
   What is \( @Q \)?]],
   function( self, q )
      pe, pf = frc.random(0,frc.new(1,2)), frc.random(frc.new(1,2),1);
      local pfe = (pe + pf)/2;
      peuf = pf + pe*(1 - pfe);
      local quests = { [[\pr(E'\cap F)]], [[\cpr{F}{E'}]] };
      local q = q or math.random(1,2);
      Q = quests[q];
      local ans = pf - pe*pfe;
      local wrong = ans / (1 - pe);
      if q == 2 then
         ans, wrong = wrong, ans;
      end
      return { ans, wrong,
               1 - ans, 1 - wrong,
               pe*pfe, pf*pfe,
               1 -  pe*pfe, 1 - pf*pfe,
               (1 - pe)*pfe, (1 - pe)*(1 - pfe),
               pe*(1 - pfe ), 1 - pe, 1 - pf, 1 - pfe,
               (1 - pf)*pfe }
      end
)


easyTwoIndepEvs = mp:new(
   { [[ Suppose that \(E\) and \(F\) are two
     independent events such
     that \(\pr{E}=@A\) and \(\pr{F}=@B\).
     What is \(\pr{@Q}\)? ]],

     [[ Suppose the probability of snow tomorrow is @A while the
     probability of IU winning the basketball game tomorrow is @B.
     Assuming these events are independent, what is the probability
     that @Q? ]],

     [[ Suppose the probability of winning the Powerball lottery is @A,
     while the probability of being abducted by aliens is @B.  If
     these two events are independent, what is the probability of @Q?  ]] },

   function( self, q )
      A = math.random( 4 )
      B = math.random( 6, 9 )
      while B == 10 - A do B = math.random( 6, 9 ) end
      A, B = A/10, B/10
      local AB, ab = A * B, ( 1 - A ) * ( 1 - B )
      local Ab, aB = A * ( 1 - B ), ( 1 - A ) * B
      local AuB, U = Ab + AB + aB, AB + Ab + aB + ab
      local anslst = { AB, Ab, aB, ab }
      local dict = { { [[E\cap F]], 
		       'it snows and IU wins', 
		       "winning Powerball and being abducted"   },
		     { [[E\cap F']], 
		       'it snows and IU loses', 
		       "winning Powerball but not being abducted" },
		     { [[E'\cap F]], 
		       'it does not snow and IU wins',
		       "losing Powerball but being abducted" },
		     { [[E'\cap F']], 
		       'it does not not snow and IU loses', 
		       "losing Powerball and not being abducted" }
      }
      local q = q or math.random( 2, 3 )
      local ans = table.remove( anslst, q )
      --s.A, s.B, s.Q = A, B, dict[q]
      Q = dict[q]
      return listJoin( { ans }, anslst, 
		       { A, B, 1, 0,
			 1-AB, 1-Ab, 1-aB, 1-ab } )
   end
)

storyTwoIndep = mp:new(
   [[Suppose there is a 
   %d\percent 
   chance of snow tomorrow, and  a 
   %d\percent 
   chance that IU wins the basketball game tomorrow.
   Assuming that those two events are independent,
   what is the probability that tomorrow there is %s 
   snow and IU %s? ]],
   function()
      local snow, win = distinctRands( 2, 1, 4 )
      local snowqlst = { '', 'no' }
      local gameqlst = { 'wins', 'loses' }
      local qs = math.random( 2 )
      local qg = 3 - qs
      local anslst = { snow * win,
		       snow * ( 10 - win ),
		       ( 10 - snow ) * win,
		       ( 10 - snow ) * ( 10 - win ) }
      local wrong = { snow + win,
		      snow + ( 10 - win ),
		      ( 10 - snow ) + win,
		      ( 10 - snow ) + ( 10 - win ) }
      local q = 2 * qs + qg - 2
      return { snow * 10, win * 10, snowqlst[qs], gameqlst[qg] }, 
             listJoin( { anslst[q] }, anslst, wrong )
   end 
)

sockMatchOld = mp:new(
   [[You have a draw that contains %d socks in three different colors:
   %d %s, %d %s, and %d %s.
   You take take out two socks at random and put them on.  You then
   notice that both socks are the same color.  What's the probability
   that both socks are %s?]],
   function ( self )
      local cols = { 'black', 'white', 'blue' }
      local n1, n2, n3 = distinctRands( 3, 2, 6 )
      local nums = { n1, n2, n3 }
      local tot = n1 + n2 + n3
      local q = math.random( 3 )
      local qsubs = { tot, 
		      n1, cols[1], n2, cols[2], n3, cols[3], 
		      cols[ q ] }
      local c1, c2, c3 = comb( n1, 2 ), comb( n2, 2 ), comb( n3, 2 )
      local cc = comb( nums[ q ], 2 )
      local ss = comb( tot, 2 )
      local denom = c1 + c2 + c3
      local anslst = { frc.new( cc, denom ),
		       frc.new( c1, denom ), 
		       frc.new( c2, denom ), 
		       frc.new( c3, denom ),
		       frc.new( n1, tot ),
		       frc.new( n2, tot ),
		       frc.new( n3, tot ),
		       frc.new( n1, tot * 2 ),
		       frc.new( n2, tot * 2 ),
		       frc.new( n3, tot * 2 ),
		       frc.new( 1, c1 ),
		       frc.new( 1, c2 ),
		       frc.new( 1, c3 ) }
      anslst = mp.listToLatex( anslst )
      return qsubs, anslst
   end
)

sockMatch = mp:new(
   [[A clothing store has @tot loose socks in the discount bin,
   @n1 in @col1, @n2 in @col2, and @n3 in @col3.
   You are colorblind and ask the salesperson to randomly pick out two of the same color.
   What's the probability that the socks chosen are @colq?]],
   function ( self )
      col1,col2,col3 = 'red', 'green', 'orange'
      n1, n2, n3 = distinctRands( 3, 2, 6 )
      local nums = { n1, n2, n3 }
      tot = n1 + n2 + n3
      local q = math.random( 3 )
      colq = ({col1,col2,col3})[q]
      local c1, c2, c3 = comb( n1, 2 ), comb( n2, 2 ), comb( n3, 2 )
      local cc = comb( nums[ q ], 2 )
      local ss = comb( tot, 2 )
      local denom = c1 + c2 + c3
      local anslst = { frc.new( cc, denom ),
		       frc.new( c1, denom ), 
		       frc.new( c2, denom ), 
		       frc.new( c3, denom ),
		       frc.new( n1, tot ),
		       frc.new( n2, tot ),
		       frc.new( n3, tot ),
		       frc.new( n1, tot * 2 ),
		       frc.new( n2, tot * 2 ),
		       frc.new( n3, tot * 2 ),
		       frc.new( 1, c1 ),
		       frc.new( 1, c2 ),
		       frc.new( 1, c3 ) }
      anslst = mp.listToLatex( anslst )
      return anslst
   end
)


tree22 = mp:new(
   { [[ Every morning a math instructor picks out two socks
     completely at random from his closet; there's only a @match\percent
     chance they match.  If they don't match there is a
     @laughdont\percent 
     chance his students will laugh at him, while if his socks do match
     there is only a @laughmatch\percent
     chance of his students laughing at him.
     
     On a given day, what is the probability that his students laugh
     at him?  ]],

     [[ If you get an A in Finite there is a @laughdont\percent chance
     that you will get into medical school, but if you get less than
     an A in Finite then your chance of getting into medical school is
     only @laughmatch\percent.  Suppose the probability that you get
     an A in Finite is @A\percent.  What's the probability that
     you will get into medical school? ]] },
   
   function( self )
      match = math.random( 1, 4 ) * 10
      laughdont = math.random( 6, 10 ) * 10
      laughmatch = math.random( 1, 5 ) * 10
      local anslst = { ( match/100 * laughmatch + ( 1 - match/100 ) * laughdont ) / 100,
		       (match * laughmatch)/10000,
		       ( 1 - match/100 ) * laughdont/100,
		       (laughmatch + laughdont) / 100,
		       1 - match/100,
		       laughmatch/100,
		       ( match/100 * laughmatch + laughdont/100 ),
		       laughdont/100,
		       match/100,
		       math.random( 1, 100 ) / 100,
		       math.random( 1, 100 ) / 100 }
      return { match=match, laughdont=laughdont,
	       laughmatch=laughmatch, A = 100 - match },
             anslst
   end
)



partitionSize = mp:new(
   [[
   A universal set $U$ with %d elements has been partitioned into three
   subsets, $A$, $B$, and $C$.  If $B$ is %d times the size of $A$ and
   $C$ is %d times the size of $B$, then how many elements are in
   $B$? ]],
   function( self, a, ab, bc )
      a = a or math.random( 1, 9 )
      ab = ab or math.random( 2, 5)
      bc = bc or math.random( 2, 5)
      while ab == bc do bc = math.random( 2, 5) end
      local total = ( 1 + ab + ab * bc ) * a
      return { total, ab, bc }, 
             { a * ab, a, ab, total, a + a * ab, a + 1,
	       a * ab * bc, a * bc, ab * bc,
	       bc, (a-1) * ab,
 ab + bc, a + ab, a + bc };
   end,
   [[\qrowFour]]
)






--(which %s's thinking about throwing out).

threeCircle = mp:new(
   [[ A math instructor has %d 
   calculators in %s office.
   Of them, %d 
   have dead batteries, %d 
   have cracked displays,
   and %d 
   have missing buttons.
   Of those with dead batteries,
   % d 
   have cracked displays
   and %d 
   have missing buttons.
   Of those with cracked displays, %d
   have missing buttons.
   There are %d 
   with dead batteries, cracked displays, and missing buttons.

   How many calculators does %s 
   have with %s?]],
   function( self, maxsize )
      maxsize = maxsize or 9
      local pieces = { 'abc', 'Abc', 'aBc', 'abC', 'ABc', 'AbC', 'aBC', 'ABC' }
      local sizes = {}
      local total = 0
      for _, p in ipairs( pieces ) do
	 sizes[ p ] = math.random( 2, maxsize )
	 total = total + sizes[ p ]
      end
      local pronounlst = { { 'she', 'her' }, { 'he', 'his' } }
      local pronoun = pronounlst[ math.random( 2 ) ]
      local qlst = { 'nothing wrong with them',
		     'dead batteries as the only defect',
		     'cracked displays as the only defect',
		     'missing buttons as the only defect' }
      local anslst = { sizes.abc, sizes.Abc, sizes.aBc, sizes.abC }
      local wrong = table.pack( distinctRands( 9, 1, 9 ) )
      local q = math.random( 4 )
      return { total, pronoun[2],
	       sizes.Abc + sizes.ABc + sizes.AbC + sizes.ABC,
	       sizes.aBc + sizes.aBC + sizes.ABC + sizes.ABc,
	       sizes.abC + sizes.aBC + sizes.AbC + sizes.ABC,
	       sizes.ABc + sizes.ABC,
	       sizes.ABC + sizes.AbC,
	       sizes.ABC + sizes.aBC,
	       sizes.ABC,
	       pronoun[1], 
	       qlst[q] },
             listJoin( { anslst[q] }, anslst, wrong )
   end,
   [[\qrowEight]]
)



menu = mp:new(
   {[[You are ordering a new laptop.  
   The company you are ordering from gives you the choice of @cpus
   different CPUs, of which you must choose one.  You also have the
   choice of @colors
   different colors, of which you must choose one,
   and @extras
   different extras (e.g.\ more RAM, video card, mouse, etc.) 
   of which you must choose exactly @numex.
   How many ways are there for you to order the new laptop? ]],
         [[You are planning a vacation to Patagonia.  You have a
   choice of @cpus hotels at which to stay, and a choice of @colors
   different car rental companies to use.  Patagonia offers @extras
   different day trips you can take.
A vacation to Patagonia consists in selecting one hotel, one car rental company and @numex different day trips (the order  doesn't matter).
   How many ways are there to plan your vacation? ]],
   [[At a restaurant the dinner menu has @cpus entrees, @colors beverages,
and @extras different side dishes.  You will order an entree, a beverage, and @numex side dishes.  How many different ways could you order dinner?
]]},
   function( self, maxnum )
      maxnum = maxnum or 6
      cpus, colors, extras  = distinctRands( 3, 3, maxnum )
      numex = math.random( 2, extras - 1 )
      local anslst = { cpus * colors * comb( extras, numex ),
		       cpus * colors * extras,
		       cpus * colors * numex,
		       cpus * colors * numex * extras,
		       cpus * colors * perm( extras, numex ),
		       math.floor( cpus * colors * numex / extras ),
		       comb( cpus + colors + extras, numex + 2 ),
		       colors * comb( extras, numex ),
		       cpus * comb( extras, numex ),
		       perm( cpus + colors + extras, numex + 2 ),
		       colors * perm( extras, numex ),
		       cpus * perm( extras, numex ) }
      return anslst
   end
)






unfairCoin = mp:new(
   { [[An unfair coin has probability \(@p\)
     of coming up Heads.
     This coin is flipped @n times.
     What is the probability that @Q
     come up at least @r times? ]],

     [[ A basketball player can make a certain shot on average @num
     out of every @den attempts.  What's the probability that she 
     @Q on at least @r of her next @n (independent) attempts? ]] },
   
   function( self )
      local pdnm = math.random( 3, 4 )
      local ph = frc.new( pdnm - 1, pdnm )
      local num  = 7 - pdnm
      local min = math.random( 2, num - 1 )
      local qlst = { { 'Heads', 'succeeds' },
		      { 'Tails', 'fails' } }
      local q = math.random( 2 )
      local probs = { ph, 1 - ph }
      local pq, pqc = probs[ q ], probs[ 3 - q ]
      -- print( '\n Q = ' .. qlst[q] .. '\n' )
      -- print( '\n num = ' .. ph.numer .. '\n' )
      -- print( '\n den = ' .. ph.denom .. '\n' )
      return { p=ph:tolatex(), n=num, Q=qlst[q], r=min,
	       num = ph.numer, den = ph.denom },
             { bernCum( num, pq, min, num ),
	       bernCum( num, pqc, min, num ),
	       1 - bernCum( num, pq, min, num ),
	       1 - bernCum( num, pqc, min, num ),
	       bernoulli( num, pq, min ),
	       bernoulli( num, pqc, min ),
	       1 - bernoulli( num, pq, min ),
	       1 - bernoulli( num, pqc, min ),
               bernCum( num, pq, min-1, num ),
	       bernCum( num, pqc, min-1, num ),
	       1 - bernCum( num, pq, min-1, num ),
	       1 - bernCum( num, pqc, min-1, num ),
	       bernCum( num, pq, min+1, num ),
	       bernCum( num, pqc, min+1, num ),
	       1 - bernCum( num, pq, min+1, num ),
	       1 - bernCum( num, pqc, min+1, num )
                }
   end
)

condBern = mp:new(
   [[ You challenge your friend to an arm wrestling match consisting of
   a series of four rounds.  From
   past experience you know that your friend wins on average
   @lose out of @tot of the rounds you play against each other, 
   and you win the rest.
   What is the probability that the match ends tied 2--2,
   given that each of you wins at least one round?
Assume that each of the four rounds is independent of the
   others. ]],

   function( self, den )
      tot = den or math.random( 3, 5 )
      lose = math.random( 1, tot - 1 )
      while lose == tot / 2 do lose = math.random( 1, tot - 1 ) end
      local q = frc.new( lose, tot )
      local p = 1 - q
      local p2, q2 = p * p, q * q
      return { 6 * p2 * q2 / ( 1 - p2 * p2 - q2 * q2 ),
               6 * p2 * q2 ,
	       1 - p2 * p2 - q2 * q2,
	       6 * p2 * q2 / ( p2 * p2 + q2 * q2 ),
	       p2 * p2 + q2 * q2,
	       6 * p * q / ( 1 - p2  - q2  ),
               6 * p2 * q2 / ( 1 - p2 * p2 + q2 * q2 ),
	       6 * p2 * q2 / ( 1 + p2 * p2 - q2 * q2 ),
	       4 * p2 * p * q / ( 1 - p2 * p2 - q2 * q2 ),
	       4 * q2 * p * q / ( 1 - p2 * p2 + q2 * q2 ),
	       4 * q2 * p * q / ( 1 + p2 * p2 - q2 * q2 ) }
   end,
   [[\qrowFour]]
)

breakfast = mp:new(
   {[[You have @qn1
   boxes of regular cereal and @qn2
   boxes of low calorie cereal in your cupboard.
   Every morning you fill your cereal bowl from one box of the @total
   completely at random, and then replace the box in your cupboard.
   What is the probability that in the course of a week (7 days)
   you have @qq 
   cereal exactly @nsucc times? (Assume no box runs out of cereal this week.)]],
      [[You have @qn1 Rolls Royces and @qn2 Lamborginis in your
(rather large) garage. 
Every morning, because variety is the spice of life,
 you choose one completely at random to drive around that day.
  What is the probability that in the course of a week (7 days)
you choose @qq exactly @nsucc times?]]},
   function( self )
      local qlst = { {'regular','Rolls Royces'},
                      {'low-cal','Lamborginis'} }
      qn1, qn2 = distinctRands( 2, 2, 8 )
      local qnums = {qn1,qn2}
      total = qnums[1] + qnums[2]
      local q = math.random( 2 )
      local qp = frc.new( qnums[ q ], total )
      qq = qlst[q]
      local qpc = 1 - qp
      local anstmpl = [[\(%d(%s)^%d(%s)^%d\)]]
      nsucc = math.random( 2, 5 )
      local nfail = 7 - nsucc
      local function mkan( ... )
	 return string.format( anstmpl, ... )
      end
      return { mkan( comb( 7, nsucc ), qp, nsucc, qpc, nfail ),
	       mkan( comb( 7, nsucc ), qpc, nsucc, qp, nfail ),
               mkan( comb( total, nsucc ), qp, nsucc, qpc, nfail ),
	       mkan( comb( total, nsucc ), qpc, nsucc, qp, nfail ),
	       mkan( nsucc, qp, nsucc, qpc, nfail ),
	       mkan( nfail, qpc, nsucc, qp, nfail ),
	       mkan( nsucc, qpc, nsucc, qp, nfail ),
	       mkan( nfail, qp, nsucc, qpc, nfail ),
	       mkan( comb( 7, nsucc + 1 ), qp, nsucc, qpc, nfail ),
	       mkan( comb( 7, nsucc - 1 ), qpc, nsucc, qp, nfail ),
	       mkan( 1, qpc, nsucc, qp, nfail ) }
   end,
   [[\qrowTwo]]
)
--breakfast.chcFun = [[\qrowTwo]]



expectationHard = mp:new(
   [[There are 
   @cashstr and @piststr in a bag.  
   You take one nut out at random and eat it, 
   and repeat this until you get a @qname.
   Let \(X\) be the number of nuts you had to take in order to get
   a @qname. For example, if you took out a @oname, another
   @oname, and then a @qname, \(X\) would be 3.
   Find the expected value of \(X\). ]],
   function( self )
      local cashpl, pistpl = mkPlural( 'cashew' ), mkPlural( 'pistachio' )
      cash, pist = distinctRands( 2, 1, 3 )
      cashstr,piststr = cashpl:ch(cash),pistpl:ch(pist)
      local total = cash + pist
      local names = { 'cashew', 'pistachio' }
      local nums = { cash, pist }
      local q = math.random( 2 )
      qname, oname = names[ q ], names[ 3 - q ]
      local qnum, onum = nums[ q ], nums[ 3 - q ]
      local ans = 0
      for i = 0, onum do
	 ans = ans + ( i + 1 ) * frc.new( perm( onum, i ) * qnum, perm( total, i + 1 ) )
      end
      return { ans,
	       ans + 1, ans - 1,
	       ans / 2, ans * 2,
	       ans / 3,
	       one, one * 2, 
	       one * onum, one * onum + 1,
	       one * cash, one * pist, one / 2 * ( cash + pist ),
               one/cash, one/pist,
               one*total/cash, one*total/pist,
               one*cash/total, one*pist/total }
   end,
   [[\qrowEight]]
)

expectationEasy = mp:new(
   { [[ A random variable \(X\) has the p.d.f.\ shown
     below (with one probability missing). 

     \begin{ctab}{rl}
       \(X\) & \(\pr{X}\) \\
       \midrule 
       @x1 & @ps1 \\
       @x2 & @ps2 \\
       @x3 & @ps3 \\
     \end{ctab}

     What is \(\ex(X)\)? ]],

     [[ A random variable \(X\) can take only the values @x1, @x2, and
     @x3.  It is known that \({\pr{X=@kv1 }= @pkv1 }\) and 
     \({\pr{X=@kv2 }= @pkv2 }\).  What is the expected value of \(X\)?]] },

   function( self )
      local x1, x2, x3 = distinctRands( 3, -5, 5 )
      local xvec = vec.new( { x1, x2, x3 } )
      local p1, p2 = distinctRands( 2, 1, 3 )
      p1, p2 = p1/10, p2/10
      local p3 = 1 - p1 - p2 
      local probs = vec.new( { p1, p2, p3 } )
      local missing = math.random( 3 )
      k1 = missing + 1
      if k1 == 4 then k1 = 1 end
      k2 = 6 - missing - k1
      local probstrs = map( probs, function (x) 
			       return string.format( '%.1f', x ) 
				   end )
      probstrs[ missing ] = '?'
      return { x1=x1, ps1=probstrs[1], 
	       x2=x2, ps2=probstrs[2], 
	       x3=x3, ps3=probstrs[3],
	       kv1 = xvec[ k1 ], pkv1 = probstrs[ k1 ],
	       kv2 = xvec[ k2 ], pkv2 = probstrs[ k2 ] },
             { probs * xvec,
	       1, 0,
	       probs * vec.new( { math.abs( x1 ),
				  math.abs( x2 ),
				  math.abs( x3 ) } ),
	       vec.new( { p1, p2, - p3 } ) * xvec,
	       vec.new( { p1, p2, 0 } ) * xvec,
	       vec.new( { p1, 0, p3 } ) * xvec,
	       vec.new( { 0, p2, p3 } ) * xvec,
	       vec.new( { p1, 0, 0 } ) * xvec,
	       vec.new( { 0, 0, p3 } ) * xvec,
	       vec.new( { 0, p2, 0 } ) * xvec,
	       x1, x2, x3, (x1+x2+x3)/4,
	       vec.new( { 1/2, 1/2, 1/4 } ) * xvec,
	       vec.new( { 1/2, 1/4, 1/2 } ) * xvec,
	       vec.new( { 1/4, 1/2, 1/2 } ) * xvec,
               (x1+x2)/2,(x1+x3)/2,(x2+x3)/2 }
   end
)


bayesStory = mp:new(
{ [[A grocery store gets turnips from two different
  suppliers, Acme and US Produce.  Turnip shipments from Acme are
  late @p2\percent
  of the time, while turnip shipments from US Produce are late
  @p3\percent
  of the time.  The store orders @p1\percent
  of its shipments from Acme and the rest
  of its shipments from US Produce.
  Suppose that the current shipment of turnips @Q2.
  What is the probability that it was ordered from @Q1? ]],

  [[ The math department gets @p1\percent of its donuts from Kroger 
  and the rest of its donuts from Marsh.
  Donuts from Kroger give you
  indigestion @p2\percent of the time,
  while those from Marsh give you indigestion @p3\percent of the time.
  You eat a donut during a coffee break and later in
  the afternoon you feel @Q2.  What is the
  probability the donut you ate came from @Q1? ]] },
   function( self )
      local p1, p2, p3 = distinctRands( 3, 1, 4 )
      if randBool() then p1 = 10 - p1 end 
      if randBool() then p2 = 10 - p2 end 
      if randBool() then p3 = 10 - p3 end 

      
      local oneqlst = { { 'Acme', "Kroger's" },
			{ 'US Produce', "Marsh" } }
      local twoqlst = { { 'is late', 'indigestion coming on' },
			{ [[is {\em not} late]], 'just fine' } }
      local anslst = { frc.new( p1 * p2, p1 * p2 + (10 - p1) * p3 ),
		       frc.new( p1 * (10 - p2), p1 * (10 - p2) + (10 - p1) * (10 - p3) ),
		       frc.new( (10 - p1) * p3, p1 * p2 + (10 - p1) * p3 ),
		       frc.new( (10 - p1) * (10 - p3), p1 * (10 - p2) + (10 - p1) * (10 - p3) ) }
      local wrong = { frc.new( p1 * p2, 100 ),
		      frc.new( p1 * (10 - p2), 100 ),
		      frc.new( (10 - p1) * p3, 100 ),
		      frc.new( (10 - p1) * (10 - p3), 100 ),
                      1 - frc.new( p1 * p2, 100 ),
		      1 - frc.new( p1 * (10 - p2), 100 ),
		      1 - frc.new( (10 - p1) * p3, 100 ),
		      1 - frc.new( (10 - p1) * (10 - p3), 100 ) }
      local qone, qtwo = math.random( 2 ), math.random( 2 )
      local q = 2 * qone + qtwo - 2
      return { p2=p2 * 10, p3=p3 * 10, p1=p1 * 10, 
	       Q2=twoqlst[ qtwo ], Q1=oneqlst[ qone ] },
             listJoin( { anslst[ q ] }, anslst, wrong )
   end
)

screeningTest = mp:new(
   [[ Approximately @b\percent of IU students suffer from @d.
IU Health offers a free screening test for @d that is accurate
@a\percent of the time,
which means that someone who has @d will test positive with
   probability 0.@a, and someone who does not have @d
   will test negative with probability 0.@a.
You take the screening test and the result is
@r.  What is the probability that you in fact really @rt?
  ]],
      function(self,name,baserate,accuracy)
         d = name or "Math Anxiety"
         b = baserate or math.random(1,9)*10
         a = accuracy or math.random(5,9)*10
         while
            a == b or a == 100 - b
            or (100-b)*(100-a) == a*b
            or b*(100-a) == a*(100-b)
            or b*a + (100-b)*(100-a) ==  b*(100-a) + a*(100-b)
         do a = math.random(5,9)*10 end
         local qr = math.random(2)
         r = ({"positive","negative"})[qr]
         rt = ({"have "..d,"do not have "..d})[qr]
         -- true pos, false pos,
         -- true neg, false neg
         local ss = { {b*a,(100-b)*(100-a)},
            {(100-b)*a,b*(100-a)} }
         --test = qr
         return { one*ss[qr][1]/(ss[qr][1]+ss[qr][2]),
                  one*ss[qr][2]/(ss[qr][1]+ss[qr][2]),
                  one*ss[3-qr][1]/(ss[3-qr][1]+ss[3-qr][2]),
                  one*ss[3-qr][2]/(ss[3-qr][1]+ss[3-qr][2]),
                  ss[qr][1]/10000,
                  ss[qr][2]/10000,
                  ss[3-qr][1]/10000,
                  ss[3-qr][2]/10000,
                  (ss[qr][1]+ss[qr][2])/10000,
                  a/100,(100-a)/100,
                  b/100,(100-b)/100,
                  (ss[3-qr][1]+ss[3-qr][2])/10000 }
      end,
   [[\qrowFour]]
)
 

expectationLinearity = mp:new(
   { [[A kissed frog has a @fps\percent
     chance of turning into a prince, while a kissed toad has only a
     @tps\percent 
     chance of turning into a prince.  If @fn frogs and @tn toads are
     kissed, what is the expected number of princes produced? ]],

     [[ A gray mouse has a @fps\percent chance of stealing cheese from
     a mousetrap without getting caught, while a white mouse has a 
     @tps\percent chance of succeeding at that.  If @fn gray mice and 
     @tn white mice try to steal cheese from  
     different traps, how many
     pieces of cheese would you expect them to get away with? ]] },
   
   function( self )
      local fps = math.random( 2, 9 ) * 10
      local tps = math.random( (fps - 10)/10 ) * 10
      local fp, tp = fps/100, tps/100
      local fn, tn = distinctRands( 2, 10, 20 )
      return { fps=fps, tps=tps, fn=fn, tn=tn, total = fn + tn },
             { fp * fn + tp * tn,
	       (fn + tn) * ( fp + tp )/2,
	       (fn + tn) * ( fp + tp ),
	       (fn + tn) * fp,
	       (fn + tn) * tp,
	       fn * fp,
	       tn * tp,
	       fp * fn * tp * tn }
   end
)

expectationLinearity2 = mp:new(
   [[ At the June carnival there is a game in which you try to throw a roll
   of toilet paper into a toilet (really).  The entrance fee is \$1,
   but if you win, you get a \textdollar@win prize.   
   Suppose that the probability
   that you succeed in hitting the toilet bowl is \(@prob\).  What are
   your expected net winnings (in dollars) if you enter the game
   \(@trials\) times? ]], 

   function( self )
      prob = frc.one() * math.random( 1, 9 ) / 10
      trials = frc.one() * math.random( 5, 9 )
      win = frc.one() * math.random( 2, 5 )
      local nw, nl = prob * trials, ( 1 - prob ) * trials
      return { nw * win - trials,
		    nw * win - nl,
		    nw * win, nw, - nl,
		    nl * win - nw, - nw,
		    nw, nw - nl, win - nl,
		    win - trials, win - frc.one() }
   end
)





--too hard?
uglyTree = mp:new(
   {[[You have a bag of poker chips, containing 
   @nw white, @nr red, and @nb blue chips.
   White chips are worth
   \$@vw, red chips are worth \$@vr
   and blue chips are worth \$@vb.
   You need \$@raisev worth of chips in order to see someone's raise,
   so you take chips out of the bag one at a time, noting the color of
   each one as it's removed, and stop when the total value of the
   chips removed is at least \$@raisev.
   How many sequences of chip colors are possible when you do this?
]],
      [[You are using cash to pay a \$@raisev parking ticket. In your
wallet you have @nwstr \$5-dollar bills, @nrstr \$10-dollar bills, and @nbstr
\$20-dollar bills, and you draw out one bill at a time at random until
you have at least \$@raisev.  If you keep track of the denomination of each bill
as you draw it out of the wallet, how many different ways are there
for you to get at least \$@raisev? ]]},
   function( self, raise, valw, valr, valb )
      vn = self.vernum;
      -- set numbers of chips
      nw, nr, nb = distinctRands( 3, 1, 3)
      -- strings for these numbers
      nwstr,nrstr,nbstr = getCardinal(nw),getCardinal(nr),getCardinal(nb)
      --local vr, vb = math.random( 2, 3), math.random( 1 ) * 5
      vw, vr, vb = valw or 1, valr or 3, valb or 5
      -- if this is the parking ticket problem,
      -- adjust the numbers
      if vn==2 then
         vw, vr, vb = 5,10,20
      end
      local vals = { vw, vr, vb }
      raisev = raise or math.random( 6, 9 ) - nw
      raisev = raisev * vw
      local ans = treeSize( raisev, { nw, nr, nb }, vals )
      return { ans,
               ans - 1, ans - 2, ans + 1,
	       treeSize( raisev - 1, { nw, nr, nb }, vals ),
	       treeSize( raisev + 1, { nw, nr, nb }, vals ),
	       treeSize( raisev, { nw, nr, nb }, {1,1,1} ),
	       treeSize( raisev, { nw - 1, nr, nb }, vals ),
	       treeSize( raisev, { nw, nr - 1, nb }, vals ),
	       treeSize( raisev, { nw, nr, nb - 1 }, vals ),
	       treeSize( raisev, { nw + 1, nr, nb }, vals ),
	       treeSize( raisev, { nw, nr + 1, nb }, vals ),
	       treeSize( raisev, { nw, nr, nb + 1 }, vals ),
 math.random(1,20), math.random(1,20), math.random(1,20) }
   end
)

colorsCond = mp:new(
   { [[A jar contains @red
   red and @green
   green jelly beans.
   Two jelly beans are taken simultaneously and completely at random
   from the jar.
Suppose that both are the same color.
   What is the probability that
   @quest? ]],

   [[An elementary school class contains @red
   boys and @green
   girls.
   Two students are selected at random to erase the blackboard.
Suppose that both are the same gender.
   What is the probability that
   @quest? ]] },

   function ( self, q )
      red, green = distinctRands( 2, 2, 5 )
      local total = red + green
      local ns, ng, nr = comb( total, 2 ), comb( green, 2 ), comb( red, 2 )
      local same = ng + nr
      local qlst = { { [[both are red]],
		       "both students chosen are boys" },
		     { [[both are green]],
                        "both students chosen are girls" } }
      local anslst = { frc.new( nr, same ),
		       frc.new( ng, same ) }
      local wrong = { frc.new( same, ns ),
                      frc.new( nr, ns ),
		       frc.new( ng, ns ),
                       frc.new( red^2, ns ),
		      frc.new( green^2, ns ),
		      frc.new( green, total ),
		      frc.new( red, total ),
		      frc.new( 1, total ),
		      frc.new( 1, ns ),
		      one, one * 0 }
      local q = q or math.random(2)
      quest = qlst[ q ]
      local ans = table.remove( anslst, q )
      return listJoin( { ans }, anslst, wrong )
   end,
   [[\qrowFour]]
)


fussyTree = mp:new(
   [[ A box contains @red red and @yel yellow marbles. An experiment
   consists of randomly drawing two marbles one at a time.
    If the first marble drawn is
   yellow, it is replaced and another marble is drawn. If it is red, it
   is set aside and another is drawn. If the second marble drawn is
   @second, what is the probability that the first one was @first?  ]],
   
   function( self )
      red, yel = distinctRands( 2, 1, 3 )
      local colors = { "red", "yellow" };
      local a, b = math.random(1,2), math.random(1,2);
      first, second = colors[a], colors[b];
      local total = red + yel;
      local probs = { { one*red/total * (red - 1)/(total - 1),
                        one*red/total * yel/(total - 1) },
         { one*yel/total * red/total,
           one*yel/total * yel/total } }
      return { probs[a][b]/(probs[a][b]+probs[3-a][b]),
               probs[b][a]/(probs[b][a]+probs[3-b][b]),
               probs[a][b], probs[b][a],
               probs[a][a], probs[b][b],
               probs[a][b]+probs[b][b],
               probs[b][a]+probs[b][b],
               probs[a][a]+probs[a][b],
               probs[a][a]+probs[b][a] }
   end,
  [[\qrowFour]]
)



conditionalGiven = mp:new( 
   [[\(E\) and \(F\) are events such that 
   \[\begin{array}{rcl}
     \pr{E} &=& %.1f \\
     \cpr{F}{E} &=& %.1f \\
     \cpr{F}{E'} &=& %.1f
   \end{array}\]
   Find \(\pr{F}\).]],

   function ( self )
      local nums = { 1,2,3,4,6,7,8,9 }
      local prE = randElem( nums ) / 10
      local cprFE, cprFe = randElem( nums ) / 10, randElem( nums ) / 10
      while cprFE == cprFe or cprFE == 1 - cprFe do cprFe = randElem( nums ) / 10 end
      local qlst = { prE, cprFE, cprFe }
      local anslst = { prE * cprFE + ( 1 - prE ) * cprFe,
		       prE * cprFe + ( 1 - prE ) * cprFE,
		       prE * cprFE, prE * cprFe,
		       (1 - prE) * cprFE, (1 - prE) * cprFe,
		       cprFE + cprFe,
		       cprFE, cprFe }
      return qlst, anslst
   end
 );


-- Too easy to get the right answer by mistake!
colorsThree = mp:new(
   [[In a pet shop there are six snakes of different colors:
   @n1 @c1, @n2 @c2, and @n3 @c3.
   One of the snakes is sold on Monday, and another is sold on
   Tuesday. If the snake sold on Tuesday was @qc1,
   what is the probability that the snake sold on Monday was @qc2?]],
      function( self )
         local colors = { 'red', 'green', 'yellow' }
         c1,c2,c3 = colors[1],colors[2],colors[3]
         n1, n2, n3 = distinctRands( 3, 1, 3 )
         local q1, q2 = distinctRands( 2, 1, 3 )
         local q3 = 6 - q1 - q2
         qc1,qc2 = colors[ q1 ], colors[ q2 ]
         local tree = { { frc.new( n1, 6 ), { frc.new( n1 - 1, 5 ),
                                              frc.new( n2, 5 ),
                                              frc.new( n3, 5 ) } },
            { frc.new( n2, 6 ), { frc.new( n1, 5 ),
                                  frc.new( n2 - 1, 5 ),
                                  frc.new( n3, 5 ) } },
            { frc.new( n3, 6 ), { frc.new( n1, 5 ),
                                  frc.new( n2, 5 ),
                                  frc.new( n3 - 1, 5 ) } } }
         local denom = tree[ q2 ][1] * tree[ q2 ][2][ q1 ] + tree[ q1 ][1] * tree[ q1 ][2][ q1 ] + tree[ q3 ][1] * tree[ q3 ][2][ q1 ]
         local wd1 = tree[ q2 ][1] * tree[ q2 ][2][ q2 ] + tree[ q1 ][1] * tree[ q1 ][2][ q2 ] + tree[ q3 ][1] * tree[ q3 ][2][ q2 ]
         local wd2 = tree[ q2 ][1] * tree[ q2 ][2][ q3 ] + tree[ q1 ][1] * tree[ q1 ][2][ q3 ] + tree[ q3 ][1] * tree[ q3 ][2][ q3 ]

         local numer = tree[ q2 ][1] * tree[ q2 ][2][ q1 ]
         local wn1 = tree[ q1 ][1] * tree[ q1 ][2][ q1 ]
         local wn2 = tree[ q3 ][1] * tree[ q3 ][2][ q1 ]
         local anslst = { numer / denom,
                          numer,
                          tree[ q2 ][1],
                          1 - ( numer / denom ),
                          wn1 / wd1,
                          wn2 / wd2,
                          wn1/wd2, wn2/wd1,
                          denom,
                          wd1, wd2, wn1, wn2 }
         anslst = mp.listToLatex( anslst )
         return anslst
      end,
   [[\qrowFour]]
)
