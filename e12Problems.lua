-- -*-two-mode-*-

mp = require('mathProblem')
mp.chcFun = [[\chc]]
mp.numberChoices = 8

ef = require('enumForm')
answers = ef.new()

ansBlanks = createBlankList( 15 )
ansBlanks[1] = 3
ansBlanks[2] = 2



etc = {}
etc.u =  2 * math.random( 6, 11 )
etc.a, etc.b, etc.c = distinctRands( 3, etc.u / 2 - 5, etc.u / 2 )
while math.max( etc.a + etc.c - etc.u, 1 ) > math.min( etc.a, etc.c ) - 1 do
   etc.a, etc.b, etc.c = distinctRands( 3, etc.u / 2 - 5, etc.u / 2 )
end
etc.ac = math.random( math.max( etc.a + etc.c - etc.u, 1 ),
		      math.min( etc.a, etc.c ) - 1 )

easyThreeCircle = mp:new(
   [[Suppose $\crd{U}=%d$, and let $A$, $B$, and $C$ be sets, and suppose that $\crd{A}=%d$, $\crd{B}=%d$, $\crd{C}=%d$; also suppose that $A$ and $B$ are disjoint, and that $\crd{A\cap C}=%d$.  Find the sizes of the following sets. ]],
   function( )
      return { etc.u, etc.a, etc.b, etc.c, etc.ac }, ''
   end
)
easyThreeCircle.mcP = false

etc1 = mp:new(
   [[\((A\cup C)'\)]],
   function()
      local u, a, b, c, ac = etc.u, etc.a, etc.b, etc.c, etc.ac
      local anslst = { u - ( a + c - ac ), 
		       a + c, math.abs(a - c),  math.abs(c - a), 
		       u - a + c, u + a - c, a + c - ac, u - (a + c),
		       distinctRands( 4, etc.u / 2 - 5, etc.u / 2 + 5 ) }
      return {}, anslst
   end
)

etc2 = mp:new(
   [[\(C'\cap A\)]],
      function()
	 local u, a, b, c, ac = etc.u, etc.a, etc.b, etc.c, etc.ac
	 local anslst = { a - ac, 
			  ac, c - ac, (u - c) * a, (u - c) + a, 
			  0, 7, 12,
			  distinctRands( 4, etc.u / 2 - 7, etc.u / 2 + 7 ) }
	 return {}, anslst
      end
)

etc3 = mp:new(
   [[\((A\cap C')\cup B\)]],
      function()
	 local u, a, b, c, ac = etc.u, etc.a, etc.b, etc.c, etc.ac
	 local ii = a - ac
	 local iii = ii + b
	 local anslst = { ii, 
			  0, math.abs(u - ii), iii, 
			  math.abs(ii - b), ii * b, 13, 14,
			  distinctRands( 4, etc.u / 2 - 7, etc.u / 2 + 7 )}
	 return {}, anslst
      end
)

etc4 = mp:new(
   [[\(A \times B\)]],
      function()
	 local u, a, b, c, ac = etc.u, etc.a, etc.b, etc.c, etc.ac
	 local iv = a * b
	 local anslst = { iv, 
			  0, 2 * iv, 13, 5 * iv, a * c, b * c, -2,
			  distinctRands( 4, etc.u / 2 - 7, etc.u / 2 + 7 )}
	 return {}, anslst
      end
)



coinsDrawFlip = mp:new(
   [[ 
   A box contains %d 
   different coins.
   An experiment consists of drawing two coins in succession without
   replacement from the box, noting the type of each coin as it
   is drawn, and then 
   flipping the last coin drawn %d 
   times and noting the number of Heads.  
   An outcome is a list of the coins drawn, in the order they were drawn, 
   and the number of Heads that came up on the %d 
   flips. How large is the sample space? ]],
   function( self, numCoins, numFlips )
      numCoins = numCoins or math.random( 2, 4 )
      numFlips = numFlips or math.random( 2, 4 )
      c, f = numCoins, numFlips
      local qsubs = { numCoins, numFlips, numFlips }
      local anslst = { perm( c, 2 ) * ( f + 1 ),
		       perm( c, 2 ) * ( f ),
		       c * c * ( f + 1 ),
		       c * c * f,
		       comb( c, 2 ) * ( f + 1 ),
		       comb( c, 2 ) * ( f ),
		       c * ( f + 1 ),
		       c * f,
		       distinctRands( 10, 4, 99 ) }
      return qsubs, anslst
   end
)





setExpr1 = mp:new(
   [[ All women who oppose gay marriage are Republicans. ]],
   function( self )
      dummy = 3
      return { [[$\female\cap A \subset R$]],
   		   [[$G\subset \female\cap R$]],
   		   [[$\female \cap R\subset A$]],
   		   [[$A\subset \female \cap R'$]],
   		   [[$G\cap \female \subset R$]],
   		   [[$\female\cup A = R$]],
   		   [[$G\cap R = \female$]],
   		   [[$A\cup R \subset \female$]] }
   end
)

setExpr2 = mp:new(
   [[All Democrats support gay marriage.]],
   function( self )
      dummy = 3
      return { [[$D\cap A = \emp$]],
		 [[$D\cap A \not= \emp$]],
		 [[$D'\cup A' \not= \emp$]],
		 [[$D'\cap A' \not= \emp$]],
		 [[$D\cup A = \emp$]],
		 [[$D\cup A \not= \emp$]],
		 [[$D'\cup A' = \emp$]],
		 [[$D'\cap A' = \emp$]] }
   end
)


engToAlg = mp:new(
   [[Define the following sets
   \[\begin{array}{lcr}
     X &=& \mbox{ @defX } \\
     Y &=& \mbox{ @defY }\\
     Z &=& \mbox{ @defZ }
   \end{array}\]
   in a universe \(U\) of things.
   Which set theoretic expression has the meaning "@statement"? ]],
   function ( self, xdef, ydef, zdef )
      defX = xdef or 'Xyzzies ';
      defY = ydef or 'Yowlies ';
      defZ = zdef or 'Zilpish ';
      local nouns = { defX, defY, defZ }
      --local elems = { 'a', 'b', 'c', 'd', 'e' };
      --local U = st:new( elems );
      --local X, Y, Z = U:random(true), U:random(true), U:random(true);
      --local compl = math.random( 2 ) + 1;
      --local cmplst = { '', '', '' };
      --cmplst[ compl ] = [[']]
      local sets = { 'X', 'Y', 'Z' };
      --local a, b, c = distinctRands( 1, 3, 3 )
      --sets[1], sets[2], sets[3] = sets[a], sets[b], sets[3]
      local negs = { false, false, false }
      local b
      for b = 2,3 do
         if randBool() then
            negs[ b ] = true
            sets[ b ] = sets[ b ] .. "'";
            nouns[ b ] = 'non-'..nouns[ b ]
         end
      end

      local rels = { [[ = ]], [[ \subset ]] }
      local ops = { [[ \cap ]], [[ \cup ]] };
      local q1, q2 = math.random( 2 ), math.random( 2 );
      local verbs = { "are defined to be things which are", "are" };
      local conjs = { "and", "or" };
      if ( negs[2] and not negs[3] ) or ( not negs[2] and negs[3] ) then
         conjs[1] = "but"
      end
      statement = defX..verbs[q1]..' '..nouns[2]..conjs[q2]..' '..nouns[3]
      local q = 2 * q1 + q2 - 2
      local anslst = { [[ \( ]]..sets[1]..rels[1]..sets[2]..ops[1]..sets[3]..[[ \) ]],
        	       [[ \( ]]..sets[1]..rels[1]..sets[2]..ops[2]..sets[3]..[[ \) ]],
        	       [[ \( ]]..sets[1]..rels[2]..sets[2]..ops[1]..sets[3]..[[ \) ]],
        	       [[ \( ]]..sets[1]..rels[2]..sets[2]..ops[2]..sets[3]..[[ \) ]] };
      local wrong = {
         [[ \( X \subset Y \cap Z \) ]],
         [[ \( X \subset Y' \cap Z \) ]],
         [[ \( X \subset Y' \cap Z' \) ]],
         [[ \( X \subset Y \cap Z' \) ]],
         [[ \( X \subset Y \cup Z \) ]],
         [[ \( X \subset Y' \cup Z \) ]],
         [[ \( X \subset Y' \cup Z' \) ]],
         [[ \( X \subset Y \cup Z' \) ]],
         [[ \( X = Y \cap Z \) ]],
         [[ \( X = Y' \cap Z \) ]],
         [[ \( X = Y' \cap Z' \) ]],
         [[ \( X = Y \cap Z' \) ]],
         [[ \( X = Y \cup Z \) ]],
         [[ \( X = Y' \cup Z \) ]],
         [[ \( X = Y' \cup Z' \) ]],
         [[ \( X = Y \cup Z' \) ]]  }
      return listJoin( { anslst[ q ] }, anslst, wrong )
   end,
   [[\qrowFour]]
)


hardThreeCircle = mp:new(
   [[
   A math instructor has @tot short sleeve pocket T-shirts in his closet.   
   Of them, @abc are in perfect condition,
   @A have coffee stains,
   @B have moth holes,
   and @C are covered in chalk dust.
   Of those with coffee stains,
   @AC are also covered in chalk dust
   and @AB also have moth holes.
   He has @ABC coffee-stained moth-eaten chalk-covered shirts, 
   which he's thinking about throwing out.

Make a Venn diagram which represents this situation.
   You must {\em completely} fill in the Venn diagram, i.e.\ all 8 pieces, for full credit.
   ]] ,
   function()
      local pieces = { 'abc', 'Abc', 'aBc', 'abC', 'ABc', 'AbC', 'aBC', 'ABC' }
      local sizes = {}
      local total = 0
      for _, p in ipairs( pieces ) do
	 sizes[ p ] = math.random( 1, 9 )
	 total = total + sizes[ p ]
      end
      local sizeA = sizes.Abc + sizes.ABc + sizes.AbC + sizes.ABC
      local sizeB = sizes.aBc + sizes.aBC + sizes.ABC + sizes.ABc
      local sizeC = sizes.abC + sizes.aBC + sizes.AbC + sizes.ABC
      tot,abc,A,B,C,AC,AB,ABC = total, 
		sizes.abc, 
		sizeA,
		sizeB,
		sizeC,
		sizes.ABC + sizes.AbC,
		sizes.ABC + sizes.ABc,
		sizes.ABC
      local ansstr = [[\( \crd{A\cap B\cap C'} = ]] .. sizes.ABc .. [[\\ \crd{A'\cap B\cap C} = ]] .. sizes.aBC .. [[\\ \crd{A\cap B'\cap C} = ]] .. sizes.AbC .. [[\\ \crd{A\cap B'\cap C'} = ]] .. sizes.Abc .. [[\\ \crd{A'\cap B\cap C'} = ]] .. sizes.aBc .. [[\\ \crd{A'\cap B'\cap C} = ]] .. sizes.abC .. [[\\ \crd{A\cap B\cap C} = ]] .. sizes.ABC .. [[\\ \crd{A'\cap B'\cap C'} = \)]] .. sizes.abc
      return ansstr
   end
)
hardThreeCircle.mcP = false




partitionProb = mp:new(
   [[  A universal set $U$ with %d elements has been partitioned into three
       subsets, $A$, $B$, and $C$.  If $B$ is %d times the size of $A$ and
       $C$ is %d times the size of $B$, then how many elements are in
	     $B$? ]],
function( self, a, ab, bc )
   a = a or math.random( 1, 9 )
   ab = ab or math.random( 2, 5)
   bc = bc or math.random( 2, 5)
   while ab == bc do
      bc = math.random( 2, 5)
   end
   local total = ( 1 + ab + ab * bc ) * a
   local qsubs = { total, ab, bc }
   local anslst = { a * ab,
		    a, ab,
		    total,
		    a + a * ab,
		    a + 1,
		    a * ab + 1,
		    a * ab * bc,
                    a * (ab - 1),
                    a * ab * (bc - 1),
                    a * (ab - 1) * bc,
                    total + a,
                    total - a,
		    distinctRands( 4, 1, total ) }
   return qsubs, anslst
end
)



digiPets = mp:new(
   [[
       DigiPets is a company that makes electronic cyber-pets.  Pet names are
       formed from the consonants $B=\stt{%s}$, $C=\stt{%s}$
	  and the vowels 
       $V=\stt{A,E,I,O,U}$ in the following way.  First a consonant is chosen
       from $B$, then a vowel is
	  chosen from $V$, then another consonant is chosen from $C$.
	     For example, ``Bil'' and ``Fad'' are both possible DigiPet names.
	     
	     How many possible DigiPet names are there?  ]],
function()
   local setB, setC
   setB = { 'B', 'F', 'G', 'K', 'M', 'R', 'S', 'T', 'Z' }
   setC = { 'C', 'D', 'L', 'N', 'P', 'Y' }
   local lenB = math.random( 3, #setB )
   local lenC = math.random( 3, #setC )
   while lenB == lenC do
      lenC = math.random( 3, #setC )
   end
   local chB = table.concat( setB, ',' ):sub( 1, 2 * lenB - 1 )
   local chC = table.concat( setC, ',' ):sub( 1, 2 * lenC - 1 )
   local qsubs = { chB, chC }
   local anslst = { lenB * 5 * lenC,
		    lenB * 5 * lenB,
		    lenC * 5 * lenC,
		    lenB * lenC,
		    lenB * lenB,
		    lenC * lenC,
		    lenB + 5 + lenC,
		    lenB + 5 + lenB,
		    lenC + 5 + lenC,
		    lenB + lenC,
		    lenB + lenB,
		    lenC + lenC,
		    26, 52 }
   return qsubs, anslst
end
)



dessertProb = mp:new(
   [[
       Three friends, Bugsy, Baby Face, and Big Sal, are eating dinner
       together at a restaurant.  When it is time for dessert,
       the server tells them that the restaurant has  @pie flavors of pie,  
       @cake flavors of cake,
	  and  @pudding flavors of pudding.
       The restaurant has an ample supply of each of these,
       so each person can select a dessert without 
       concern for what the others may order.
       Each person orders a dessert from the menu.
       In how many outcomes would exactly 2 people order @order1 and
	  1 person order @order2?]],
   function(self)
      local types = { 'pie', 'cake', 'pudding' }
      local numch = {}
      local rands = {distinctRands(3,2,5)}
      for i, d in ipairs( types ) do
	 numch[ d ] = rands[i]
      end
      local two = math.random( #types )
      local one = two + 1
      if one > #types then one = one - #types end
      local t = numch[ types[ two ] ]
      local o = numch[ types[ one ] ]
      pie,cake,pudding,order1,order2 = numch.pie, numch.cake, numch.pudding, types[ two ], types [ one ]
      local anslst = { 3 * t * t * o,
		       t * t * o,
		       3 * t * (t - 1) * o,
		       t * (t - 1) * o,
		       3 * t * t,
		       t * t * t,
		       3 * t * (t - 1) * (t - 2),
		       t * (t - 1) * (o - 1),
		       3 * t + t + o,
		       t + t + o,
		       3 * t + (t - 1) + o,
		       t + (t - 1) + o,
		       3 * t + t,
		       t + t + t,
		       3 * t + (t - 1) + (t - 2),
		       t + (t - 1) + (o - 1) }
      return anslst
   end
)



wius = mp:new(
   {[[
       As programming director at WIUS you stack a pile of @len CDs in the
       order in which they should be played.  One student disk jockey
       accidentally knocks the stack of CDs on the floor, and picks them up
	  and stacks them in a random order.  What is the probability that the
       first @num CDs in the new stack are the same ones in the same order as originally? ]],
   [[You own @len souvenirs from vacation trips, and you  arrange then in order from left to right on the mantel over your fireplace.  Your partner accidentally knocks all the souvenirs off the mantel, and rearranges them in a random order.  What is the probability that the first @num souvenirs on the left side of the mantel are exactly the same and in the same order as before?
]]},
   function(self,nmin,nmax)
      local nmn = nmin or 5
      local nmx = nmax or 9
      len = math.random( nmn, nmx )
      num = math.random( 2, len - 2 )
      -- local anslst = { string.format( [[\(\frac{%d}{%d}\)]], 1, perm( len, num ) ),
      --   string.format( [[\(\frac{%d}{%d}\)]], 1, perm( len, len ) ),
      --   string.format( [[\(\frac{%d}{%d}\)]], 1, len ^ num ),
      --   string.format( [[\(\frac{%d}{%d}\)]], num, len ),
      --   string.format( [[\(\frac{%d}{%d}\)]], 1, perm( num, num ) ),
      --   string.format( [[\(\frac{%d}{%d}\)]], 1, comb( len, num ) ),
      --   string.format( [[\(\frac{%d}{%d}\)]], 1, num ),
      --   string.format( [[\(\frac{%d}{%d}\)]], 1, len ),
      --   string.format( [[\(\frac{%d}{%d}\)]], num, perm( len, len ) ),
      --   string.format( [[\(\frac{%d}{%d}\)]], num, perm( len, num ) ),
      --   string.format( [[\(\frac{%d}{%d}\)]], num, comb( len, num ) ),
      --   string.format( [[\(\frac{%d}{%d}\)]], len, perm( len, num )
      --   ) }
      local anslst = { one / perm( len, num ),
                        one / perm( len, len ),
                        one * num / len,
                        one / perm(num,num),
                        one / comb( len, num ),
                        one / num,
                        one / len,
                        one * num / perm( len, len ),
                        one * num / perm( len, num ),
                        one * num / comb( len, num ),
                        one * len / perm( len, num ),
                        one * len / comb( len, num ),
                        one / ( num*len),
                        one / (len*len) }
      return anslst
   end
)







coffeeTea = mp:new(
   {[[
   A coffee shop stocks @ncof flavors of coffee and
   @ntea flavors of tea.
   Assuming all the @ntot flavors are equally popular, what is the probability
   that 3 consecutive orders include both coffee and tea?
   Assume that each customer orders exactly one drink; of course different customers may order the same thing. ]],
[[
     A Chinese restaurant offers 
     @ncof chicken dishes and @ntea tofu dishes.  
     You and two friends go there and each of you orders one dish  completely at
     random.  What is the probability that both chicken and tofu dishes are
     included in the order?
   ]]
   },
   function(self)
      local c, t = distinctRands( 2, 3, 9 )
      local a = c + t
      ncof,ntea = c, t
      ntot = ncof + ntea;
      local anslst = { string.format([[\(\frac{%d^3 - %d^3 - %d^3}{%d^3}\)]],a,c,t,a ),
    string.format([[$\frac{\cmb(%d,3)\cmb(%d,3)}{\cmb(%d,3)}$]],c,t,a),
    string.format([[ $\frac{\cmb(%d,3)+\cmb(%d,3)}{\cmb(%d,3)}$ ]], c,t,a),
    string.format([[ $\frac{\cmb(%d,3)-\cmb(%d,3)-\cmb(%d,3)}{\cmb(%d,3)}$ ]], a,c,t,a),
    string.format([[ $\frac{\prm(%d,3)\prm(%d,3)}{\prm(%d,3)}$ ]],c,t,a ),
    string.format([[ $\frac{\prm(%d,3)+\prm(%d,3)}{\prm(%d,3)}$ ]], c,t,a),
    string.format([[ $\frac{\prm(%d,3)-\prm(%d,3)-\prm(%d,3)}{\prm(%d,3)}$ ]], a,c,t,a),
    string.format([[ $\frac{%d^3 + %d^3}{%d^3}$ ]], c,t,a) };
      return anslst
   end,
   [[\qrowTwo]] 
)



yen = mp:new(
   [[
   Suppose you have %d %s (1\cent), %d %s (5\cent), and %d
   %s (10\cent) in your pocket.  You grab three coins at random.
   What is the probability that the value of the three coins is less
   than 10\cent?]],
   function(self)
      local types = { 'pennies', 'nickels', 'dimes' }
      local numbs = {}
      numbs[ types[1] ], numbs[ types[2] ], numbs[ types[3] ] = distinctRands( 3, 3, 9 )
      local a = numbs[ types[ 1 ] ]
      local b = numbs[ types[ 2 ] ]
      if a == b then b = a + 1 end
      local c = numbs[ types[ 3 ] ]
      local s = a + b + c
      local qsubs = { a, types[ 1 ], b, types[ 2 ], c, types[ 3 ] }
      local anslst = { string.format([[\(\frac{\cmb(%d,2)\cmb(%d,1)+\cmb(%d,3)}{\cmb(%d,3)}\)]],a,b,a,s),
		       string.format([[\(\frac{\cmb(%d,2)\cmb(%d,1)}{\cmb(%d,3)}\)]],a,b,s),
		       string.format([[\(\frac{\cmb(%d,1)\cmb(%d,2)+\cmb(%d,2)\cmb(%d,1)+\cmb(%d,3)}{\cmb(%d,3)}\)]],c,a+b,a,b,a,s),
		       string.format([[\(\frac{\cmb(%d,2)\cmb(%d,1)+\cmb(%d,1)\cmb(%d,2)+\cmb(%d,2)\cmb(%d,1)+\cmb(%d,3)}{\cmb(%d,3)}\)]],c,a+b,c,a+b,a,b,a,s),
		       string.format([[\(\frac{\cmb(%d,3)-\cmb(%d,2)\cmb(%d,1)}{\cmb(%d,3)}\)]],s,a,b,s),
		       string.format([[\(\frac{\cmb(%d,3)-\cmb(%d,1)\cmb(%d,2)}{\cmb(%d,3)}\)]],s,a,b,s),
		       string.format([[\(\frac{\cmb(%d,3)-\cmb(%d,3)}{\cmb(%d,3)}\)]],s,b,s),
		       string.format([[\(\frac{\cmb(%d,3)-\cmb(%d,1)\cmb(%d,2)-\cmb(%d,3)}{\cmb(%d,3)}\)]],s,a,b,b,s) }
      return qsubs, anslst
   end
)
yen.chcFun = [[\chcs]]

function mcChoices( f1, f2, f3, f4, f5 )
   return { [[$\cmb(]]..f4..","..f2..[[) \cdot \cmb(]]..f3..","..f1..[[)$]],
      [[$\cmb(]]..f4..","..f2..[[) + \cmb(]]..f3..","..f1..[[)$]],
      [[$\cmb(]]..f5..","..f3..[[)$]],
      "$"..f1..[[^{]]..f5..[[}$]],
      [[$\prm(]]..f4..","..f2..[[) \cdot \prm(]]..f3..","..f1..[[)$]],
      [[ $\prm(]]..f4..","..f2..[[) + \prm(]]..f3..","..f1..[[)$ ]],
      [[ $\prm(]]..f5..","..f3..[[)$ ]],
      "$"..f1..[[^{]]..f4..[[}$ ]] };
end

mcPP = mp:new(
   { [[ For a psychology experiment investigating the relationship between
hair color and personal interaction, @f5 subjects are used: @f4 women and @f3
men.  Each subject is assigned a unique ID number.  Suppose that
@f2 women and
@f1 men are chosen to have their hair bleached and dyed.
Of the women chosen, 
@women
Of the selected  men,
@men
The other @rest people have their hair color unchanged (as a control).
   How many
ways are there for the psychologists to choose which subject ID number
goes with which dye color?
]],
      [[ You have one pile of @f4 building blocks, each one a different color, and you
also have another pile of @f3 blocks, again each one a different color.
How many ways are there to build a tower @f2 blocks high from the first pile
and another tower @f1 blocks high from the second pile?
Assume that the colors at each level of a tower matter.
        ]]},  
   function( self, fa, fb )
      f1 = fa or math.random( 2, 3 );
      f2 = fb or math.random( f1+1, 5 );
      local colors = { "vermilion", "mauve", "puce", "fuchsia",
                       "cyan", "Pepto-Bismal pink", "teal", "indigo" };
      f3 = f1 + f2;
      f4 = f2 + f3;
      f5 = f3 + f4;
      rest = f5 - f1 - f2;
      local i;
      women = "one has her hair dyed ";
      for i = 1,f2 do
 onestr = ", one ";
if i == f2 - 1 then
onestr = ", and one "
elseif i == f2 then
onestr = "."
end
        women = women .. colors[i] .. onestr;
      end
      men = "one has his hair dyed ";
      for i = f2+1,f3 do
onestr = ", one ";
if i == f3 - 1 then
onestr = ", and one "
elseif i == f3 then
onestr = "."
end
         men = men .. colors[i] .. onestr;
      end
      local anslist = mcChoices( f1, f2, f3, f4, f5 );
      local ans = anslist[5];
      return { ans, table.unpack( anslist ) };
   end,
   [[\qrowTwo]]
);


mcCC = mp:new(
   { [[ In a psychology experiment investigating the relation
of color to smell, a group of @f4 different women's  and @f3 different
men's fragrances is used.  
A total of @f3 of the fragrances are chosen at random and dyed salmon pink.
How many ways are there to dye the fragrances if @f2 women's and @f1 men's
are chosen for dyeing?
]],
[[ You have one pile of @f4 building blocks, all of different colors, and you
also have another pile of @f3 blocks, again all of different colors.
How many ways are there to select @f2 blocks from the first pile and
 @f1 blocks from the second pile? ]] },
   function( self, fa, fb )
      f1 = fa or math.random( 2, 4 );
      f2 = fb or math.random( f1+1, 6 );
      f3 = f1 + f2;
      f4 = f2 + f3;
      f5 = f3 + f4;
      -- rest = f5 - f1 - f2;
      local anslist = mcChoices( f1, f2, f3, f4, f5 );
      local ans = anslist[1];
      return { ans, table.unpack( anslist ) };
   end,
   [[\qrowTwo]]
);


mcPerm = mp:new(
   {[[ 
There are @f5 members on the IU Finite Team, @f4 combinators 
and @f3 vennistas.  
For an upcoming meet 
against Purdue, a @f3 player line-up is chosen from each school to compete
head to head in Finite math problems.  The Purdue coach has already
announced his line-up of @f3 players.  Now the IU coach must choose
his line-up, with each of the @f3 chosen IU
players being matched against one of the Purdue competitors.  
How many ways are there for the IU coach to select his line-up?
]],
   [[A flutterball team has @f3 men and @f4 women on its roster. For the next game, the manager must decide on the lineup, which consists of @f3 players in the order in which they will appear in the program.  How many different lineups are possible?
]]},
   function( self, fa, fb )
      f1 = fa or math.random( 3, 5 );
      f2 = fb or math.random( f1+1, 8 );
      f3 = f1 + f2;
      f4 = f2 + f3;
      f5 = f3 + f4;
      -- rest = f5 - f1 - f2;
      local anslist = mcChoices( f1, f2, f3, f4, f5 );
      local ans = anslist[7];
      return { ans, table.unpack( anslist ) };
   end,
   [[\qrowTwo]]
);


mcCpC = mp:new(
   { [[
You have won a math department raffle, and for your prize can choose
either @f1 geeky T-shirt from a group of @f3, or instead you
may choose any @f2 full color posters of geometric shapes from
among a group of @f4.  How many ways are there for you to claim
your prize?
]], [[
You are purchasing a pizza for a party, and the store offers 
a vegetarian pizza, for which you can choose any @f2 vegetable toppings
     from a total of @f4, and a meat pizza, for which you can choose any @f1
     meat  toppings  from a total of @f3.
     How many ways are there to order a pizza?  Assume all toppings you
     order must be distinct.
]] },
   function( self, fa, fb )
      f1 = fa or math.random( 3, 5 );
      f2 = fb or math.random( f1+1, 8 );
      f3 = f1 + f2;
      f4 = f2 + f3;
      f5 = f3 + f4;
      -- rest = f5 - f1 - f2;
      local anslist = mcChoices( f1, f2, f3, f4, f5 );
      local ans = anslist[2];
      return { ans, table.unpack( anslist ) };
   end,
   [[\qrowTwo]]
);


mcPpP = mp:new(
  { [[
As Tyrant of Donia (a small state in the Carpathian mountains), you
must establish a judicial branch of government.  You have the choice 
either of
appointing two of your six personal lackeys as Chief Hanging Judge
and Chief Hanging Juror, or
of making a tepid gesture toward democracy by appointing,
from among the 10 person Committee to Free Donia, a judicial
chief, vice-chief, assistant-vice-chief, and deputy-assistant-vice-chief.  
How many possible appointments could you make?
]],
[[ You have one pile of @f4 building blocks, all of different colors, and you
also have another pile of @f3 blocks, again all of different colors.
How many ways are there to build one tower of blocks
 consisting either of @f2 blocks from the first pile or
 @f1 blocks from the second pile?
(The colors of the levels matter.) ]] },
   function( self )
      f1 = 2
      f2 = 4
      f3 = f1 + f2;
      f4 = f2 + f3;
      f5 = f3 + f4;
      -- rest = f5 - f1 - f2
      local anslist = mcChoices( f1, f2, f3, f4, f5 );
      local ans = anslist[6];
      return { ans, table.unpack( anslist ) };
   end,
   [[\qrowTwo]]
);


mcTwoPow = mp:new(
   { [[
You have a box of @f5 taffies, all of different flavors.  Of them @f3
are in red wrapping and the other @f4 are in green wrapping.
Your roommate, who is color blind,
was left  alone with the box for an hour.  You then check the box to
see which flavors, if any, were eaten.  How many possible results
could there be? 
]],
[[ For a Bio lab  you must grow @f5 bacterial cultures. Of them @f3 are
labeled  ``Control-1'' through ``Control-@f3'', and the other @f4 are labeled
``Treated-1'' through ``Treated-@f4''.  The Treated cultures are each treated with a
different antibiotic.  
Three weeks later you check the {\em treated} cultures to see 
which ones have died.  
How many possible outcomes are there?
]] },
   function( self, fb )
      f1 = 2;
      f2 = fb or math.random( f1+1, 5 );
      f3 = f1 + f2;
      f4 = f2 + f3;
      f5 = f3 + f4;
      -- rest = f5 - f1 - f2;
      local anslist = mcChoices( f1, f2, f3, f4, f5 );
      local ans = anslist[4];
      if ( self.vernum == 2 ) then
          ans = anslist[8];
      end;
      return { ans, table.unpack( anslist ) };
   end,
   [[\qrowTwo]]
)


mcComb = mp:new(
   [[
You have @f4 math textbooks and @f3 English lit anthologies in your
closet.  To raise money for a pizza party you make the difficult
decision to sell back @f3 of the precious volumes to the IU bookstore.
How many ways are there to choose which books to sell?
]], 
   function( self, fa, fb )
      f1 = fa or math.random( 2, 4 );
      f2 = fb or math.random( f1+1, 6 );
      f3 = f1 + f2;
      f4 = f2 + f3;
      f5 = f3 + f4;
      -- rest = f5 - f1 - f2;
      local anslist = mcChoices( f1, f2, f3, f4, f5 );
      local ans = anslist[3];
      return { ans, table.unpack( anslist ) };
   end,
   [[\qrowTwo]]
)



mcPower = mp:new(
   { [[
You own @f6 pipes, including @f5 expensive briars and @f4 cheap corncobs.
Of the briars, only @f2 are usable; of the corncobs, only @f3 are usable.
If you smoke one pipe a day for @f5 days, how many ways are there to choose
a corncob pipe for each day?  You may use the same pipe on multiple days
as long as it is {\em usable}. 
]],
   [[
A dorm has a volleyball team and an Ultimate Frisbee team.  There are @f2 men and @f1
women on the volleyball team, and @f3 men and @f4 women on the Ultimate team.
Each team plays @f5 games over the season.
Also, each team picks a captain at random at every game that they play.
How many ways are there for the volleyball team to pick captains for all their games?
]] },
   function( self, fa, fb )
      f1 = fa or math.random( 3, 5 );
      f2 = fb or math.random( f1+1, 8 );
      f3 = f1 + f2;
      f4 = f2 + f3;
      f5 = f3 + f4;
      f6 = f4 + f5;
      -- rest = f5 - f1 - f2;
      local anslist = mcChoices( f3, f4, f5, f5, f4 + f5 );
      local ans = anslist[8];
      return { ans, table.unpack( anslist ) };
   end,
   [[\qrowTwo]]
);



productCode = mp:new(
   {[[ Apple constructs the names for its digital voices
   from the consonants 
   \[C=\stt{ @chC }\]
     and the vowels 
     \[V=\stt{A,E,I,O,U}\]
     in the following way.  First a consonant is chosen
     from \(C\), then a vowel is
     chosen from $V$, then a {\em different} consonant is chosen from $C$,
     and then a vowel (possibly the same) from $V$.
     For example, ``Siri'' and ``Zasu'' are both possible names, but
     ``Rori'' is {\em not} possible.

     How many possible digital voice names are there? ]],
      [[A birthday cake is to have two layers of cake separated by a
      layer of icing, with another layer of icing on top.  There are
      5 kinds of cake the chef knows how to make, and she may use
      either two different kinds or the same one twice for the two
      cake layers.  The chef knows recipes for @lenC different icings,
      and she will use two different recipes, one for each icing
      layer, in this cake.  How many
      different cakes could the chef make?  Note that the order of
      the layers matters, e.g.\ chocolate over strawberry is different
      from strawberry over chocolate.]],
      [[ You are making a mixtape.  You have 5 short songs to choose from, and @lenC long songs.  The playlist will have 4 songs, alternating short and long songs, starting with a long one.  The long songs cannot be repeated, but the short songs can.  How many mixtapes are possible?]]
   },
   function( self, maxlen )
      --local setC
      setC = { 'B', 'D', 'G', 'K', 'M', 'P', 'T', 'R', 'S', 'Z' }
      -- setC = { 'B', 'D', 'F', 'G', 'K', 'M', 'P', 'S', 'T', 'Z' }
      lenC = maxlen or math.random( 3, #setC )
      -- local lenC = math.random( 3, #setC )
      chC = table.concat( setC, ',' ):sub( -(2 * lenC - 1) )
      -- local chC = table.concat( setC, ',' ):sub( 2 * lenC - 1 )
      return { lenC * 5 * (lenC - 1) * 5,
	       lenC * 5 * (lenC - 1) * 4,
	       lenC * 5 * lenC * 5,
	       lenC * 5 * lenC * 4,
	       lenC * (lenC - 1),
	       lenC * lenC,
	       5 * 5, 5 * 4, lenC * 5, lenC * 5 * lenC,
	       lenC * 5 * 5,
	       perm( lenC + 5, lenC + 5 ),
	       perm( lenC + 5, 4) }
   end
)

birthdayCake = mp:new(
   {  [[A birthday cake is to have two layers of cake separated by a
      layer of icing, with another layer of icing on top.  There are
      @nc kinds of cake the chef knows how to make, and she may use
      either two different kinds or the same one twice for the two
      cake layers.  The chef knows recipes for @ni different icings,
      and she will use two different recipes, one for each icing
      layer, in this cake.  How many
      different cakes could the chef make?  Note that the order of
      the layers matters, e.g.\ chocolate over strawberry is different
      from strawberry over chocolate.]],
      [[ You are making a mixtape.  You have @nc short songs to choose from, and @ni long songs.  The playlist will have 4 songs, alternating short and long songs, starting with a long one.  The long songs cannot be repeated, but the short songs can.  How many mixtapes are possible?]]
   },
   function( self, ncmax, nimax )
      nc = math.random(3,ncmax)
      ni = math.random( 3, nimax )
      return { ni * nc * (ni - 1) * nc,
	       ni * nc * (ni - 1) * (nc - 1),
	       ni * nc * ni * nc,
	       ni * nc * ni * (nc - 1),
	       ni * (ni - 1),
	       ni * ni,
	       nc * nc, nc * (nc - 1), ni * nc, ni * nc * ni,
	       ni * nc * nc,
	       perm( ni + nc, ni + nc ),
	       perm( ni + nc, (nc - 1)) }
   end
)


colors = mp:new(
   { [[A jar contains @red
   red and @green
   green jelly beans.
   Two jelly beans are taken simultaneously and completely at random
   from the jar.  
   What is the probability that
   @quest? ]],

      [[An elementary school class contains @red
   boys and @green
   girls.
   Two students are selected at random to erase the blackboard.
   What is the probability that
   @quest? ]],
      [[Your sock drawer has @red red socks and @green green socks
   scattered in it.  In a hurry to get to Finite, you grab two
   socks at random.  What is the probability that
   @quest? ]]},
   function ( self, q )
      red, green = distinctRands( 2, 2, 5 )
      local total = red + green
      local ns, ng, nr = comb( total, 2 ), comb( green, 2 ), comb( red, 2 )
      local same, diff = ng + nr, red * green
      local qlst = { { [[both are the same color]], 
      "both are the same gender",
      [[both are the same color]] },
   { [[each is a different color]],
      "one girl and one boy is chosen",
      [[each is a different color]] },
   { [[both are red]],
      "both students chosen are boys",
      [[both are red]] },
   { [[both are green]],
      "both students chosen are girls",
      [[both are green]]} }
      local anslst = { frc.new( same, ns ),
		       frc.new( diff, ns ),
		       frc.new( nr, ns ),
		       frc.new( ng, ns ) }
      local wrong = { frc.new( red^2, ns ),
		      frc.new( green^2, ns ),
		      frc.new( green, total ),
		      frc.new( red, total ),
		      frc.new( 1, total ),
		      frc.new( 1, ns ),
		      one, one * 0 }
      local q = q or math.random(4)
      quest = qlst[ q ]
      local ans = table.remove( anslst, q )
      return listJoin( { ans }, anslst, wrong )
   end,
   [[\qrowSix]]
)



horserace = mp:new(
   {[[ There are @crdstr horses running in a race, one of which is named @hname.
   At the end of the race the complete order in which the first @top
   horses finished is recorded.  In how many outcomes does @hname
   finish among the top @top horses? ]],
         [[There are @crdstr tic-tac-toe players competing in a
   tournament, one of whom is @hname.  At the end of the tournament
   the top @top players each win different prizes.  How many
   ways are there of awarding the prizes in which @hname is one of the
   prize winners? ]]},
      function( self, name, minnum, maxnum )
         hname = name or 'Permutation'
         local cards = { 'three', 'four', 'five', 'six', 'seven',
                         'eight', 'nine', 'ten' }
         local numa = maxnum or 4
         local numb = maxnum or 10
         num = math.random( numa, numb )
         crdstr = cards[ num - 2 ]
         top = math.random( 2, num - 2 )
         local anslst = { top * perm( num - 1, top - 1 ),
                          top * perm( num - 1, num - 1 ),
                          top * perm( num, num ),
                          math.abs(perm(num,top) - top * perm( num - 1, top - 1 )),
                          math.abs(perm(num,top) - top * perm( num - 1, num - 1 )),
                          math.abs(perm(num,top) - top * perm( num, num )),
                          perm( num - 1, num - 1 ),
                          perm( top, top ),
                          top * num,
                          top * (num - 1),
                          top + num,
                          top + num -1,
                          perm( top, top ),
                          perm( top, top ) * perm( num - top, num - top )
         }
         return anslst
      end
)


weights = mp:new(
   { [[There are @numall
   candidates for one party's presidential nomination, including 
   @nwom women and @nmen men.
   Suppose that all the men are equally likely to win the nomination,
   and all the women are are equally likely to win the nomination,
   but that each @favestr is @fact
   times as likely as each @understr to win the nomination.
   What is the probability that a @qstr wins the nomination? ]],
      [[You have @numall M\&Ms in your pocket, of which @nmen have
   peanuts and @nwom are regular (without peanuts).  Because the peanut M\&Ms are bigger each
   one is @fact times more likely to be chosen than each regular M\&M.
   What is the probability the next time you reach into your
   pocket for an M\&M that you get a @qstr?
]] },
   function( self )    
      local qlst = {{ 'woman', 'regular' },{'man','peanut'}}
      nmen, nwom = distinctRands( 2, 3, 6 )
      numall = nmen + nwom
      local nums = { nwom, nmen }
      fact = math.random( 2, 5 )
      local fcts = { }
      local fave = math.random( 2 )
      if self.vernum == 2 then fave = 2 end
      local under = 3 - fave
      fcts[ fave ], fcts[ under ] = fact, 1
      local nund, nfav  = nums[ under ], nums[ fave ]
      local total = nund + nfav * fact
      local anslst = { frc.new( nwom * fcts[1], total ),
		       frc.new( nmen * fcts[2], total ) }
      local wrong = { frc.new( nund, nund + nfav ),
		      frc.new( nfav, nund + nfav ),
		      frc.new( 1, fact + 1 ),
		      frc.new( fact, fact + 1 ),
		      frc.new( 1, 2 ),
		      frc.new( 1, nmen ),
		      frc.new( 1, nwom ),
		      frc.new( math.min( nmen, nwom ), math.max( nmen, nwom ) ),
		      frc.new( 1, total ),
		      frc.new( fact, total ),
		      frc.new( 1, nfav * fact ),
		      frc.new( 1, nund )}
      local q = math.random( 2 )
      favestr,understr,qstr =  qlst[ fave ], qlst[under], qlst[q] 
      -- return { nmen + nwom, nwom, nmen, 
      --          qlst[ fave ], fact, qlst[under], qlst[q] },
      return listJoin( { anslst[q] }, anslst, wrong )
   end
)


twodice = mp:new(
   [[Two fair six-sided dice are rolled.
   What is the probability that the sum of the two dice is either
   %d or %d? ]],
      function( self )
         local s1, s2 = distinctRands( 2, 2, 12 )
         local function size( x )
            return 6 - math.abs( x - 7 )
         end
         return { s1, s2 },
         { frc.new( size( s1 ) + size ( s2 ), 36 ),
           frc.new( 2, 36 ),
           frc.new( s1 + s2, 36 ),
           frc.new( size( s1 ), 36 ),
           frc.new( size( s2 ), 36 ),
           frc.new( s1, 36 ),
           frc.new( s2, 36 ),
           frc.new( 2, 12 ),
           frc.new( 2, 6 ),
           frc.new( 1, 6 ),
           frc.new( math.random(36), 36 ),
           frc.new( math.random(36), 36 ),
           frc.new( math.random(36), 36 ),
           frc.new( math.random(36), 36 ),
           frc.new( math.random(36), 36 ) }
      end
)

twodiceIneq = mp:new(
   [[Two fair six-sided dice are rolled.
   What is the probability that the sum of the two dice is @rel
   @bound? ]],
      function( self )
         bound = math.random(2,12);
         local function size( x )
            return 6 - math.abs( x - 7 )
         end
         local rels = {"greater than","less than"};
         local q;
         if bound==2 then
            q=1;
         elseif bound==12 then
            q=2;
         else
            q=math.random(2)
         end
         rel=rels[q];
         local ans = 0;
         if q==1 then
            for sum = bound+1,12 do
               ans = ans + size(sum);
            end
         else
            for sum = 2,bound-1 do
               ans = ans + size(sum);
            end
         end
         ans = frc.new(ans,36);
         local fraclist = {};
         for i=1,36 do
            table.insert(fraclist,frc.new(i,36))
         end
         return { ans,
                  frc.new(size(bound),36),
                  frc.new(size(bound+1),36),
                  frc.new(size(bound-1),36),
                  unpack(fraclist) }
      end
)


coinCombo = mp:new(
   [[You have @pens
   pennies (1\cent\ each) and @ncks
   nickels (5\cent\ each) in your pocket.
   You reach in and blindly grab three coins at random.
   What is the probability that
   the total value of the selected coins is @Q? ]],
   function( self, q, mn, mx )
      mn = mn or 3
      mx = mx or 6
      pens, ncks = distinctRands( 2, mn, mx )
      local tot = pens + ncks
      local ss = comb( tot, 3 )
      local prob11 = frc.new( comb( ncks, 2) * pens + comb( ncks, 3 ),
			      ss )
      local allncks = frc.new( comb( ncks, 3 ), ss )
      local allpens = frc.new( comb( pens, 3 ), ss )
      local qlst = { [[{\em at least} 5\cent]],
         [[{\em less than} 5\cent]],
         [[{\em exactly} 7\cent]],
         [[{\em exactly} 11\cent]],
         [[{\em at least} 11\cent]],
         [[{\em less than} 11\cent]] }
      local anslst = { 1 - frc.new( comb( pens, 3 ), ss ),
		       frc.new( comb( pens, 3 ), ss ),
		       frc.new( comb( pens, 2 ) * ncks, ss ),
		       frc.new( comb( ncks, 2 ) * pens, ss ),
		       prob11,
		       1 - prob11 }
      local wrong = { 1 - frc.new( comb( ncks, 3 ), ss ),
		      frc.new( comb( ncks, 3 ), ss ),
		      frc.new( pens, tot ),
		      frc.new( ncks, tot ),
		      1 - frc.new( pens, tot ),
		      1 - frc.new( ncks, tot ),
		      allncks, 1 - allncks,
		      allpens, 1 - allpens }
      local q = q or math.random( 6 )
      Q = qlst[q]
      return listJoin( { anslst[q] }, anslst, wrong )
   end,
   [[\qrowSix]]
)


gumballs = mp:new(
   { [[A gumball machine contains @c1
     red gumballs, @c2
     blue gumballs, and @c3
     yellow gumballs.  
     You put a coin in the machine, 
     and two gumballs come out, one after the other.
     What's the probability that the first gumball that comes out is
     @first and the second gumball is @second? ]],

      [[A car rental agency has @c1 Fords, @c2 Toyotas, and @c3
     Metros.  You and a friend go there to rent and each of you is
     given a car chosen at random.  What's the probability that you
     get a @first and your friend gets a @second? ]],
      [[ The IMU food court offers @c1 different beef entrees, @c2
   different chicken entrees, and @c3 different vegetarian entrees.
   You and a friend buy lunch there, and choose your entrees
   completely at random.  You find that each of you ordered
   a different entree.  What's the probability that you ordered
   @first and your friend ordered @second? ]],
      [[ At the airport snack bar there are only @total sandwiches
     remaining: @c1 chicken,
     @c2 egg salad, and @c3 vegetarian. 
     You and a friend are in a hurry and each grab a sandwich
     completely at random.  What is the probability that you get
     @first and your friend gets @second?   ]] }, 
   function( self )
      local red, blue, yellow = distinctRands( 3, 2, 6 )
      local total = red + blue + yellow
      local ss = perm( total, 2 )
      -- local colors = ({ { 'red', 'blue', 'yellow' },
      -- 			{ 'Ford', 'Toyota', 'Metro' } })
      local colors = { { 'red', 'Ford', "beef", "chicken" },
         { 'blue', 'Toyota', "chicken", "egg salad" },
         { 'yellow', 'Metro', "vegetarian", "vegetarian" } }
      local numbers = { red, blue, yellow }
      local q1, q2 = distinctRands( 2, 1, 3 )
      local q3 = 6 - q1 - q2
      local n1, n2, n3 = numbers[ q1 ], numbers[ q2 ],  numbers[ q3 ]
      return { c1=red, c2=blue, c3=yellow, 
	       first=colors[q1], second=colors[q2], total=total },
      { frc.new( n1 * n2, ss ),
	frc.new( n1 * n3, ss ),
	frc.new( n2 * n3, ss ),
        frc.new( 2*n1 * n2, ss ),
	frc.new( n1, ss ),
	frc.new( n2, ss ),
	frc.new( n3, ss ),
	frc.new( n1 + n2, total ),
	frc.new( n3, total ),
	frc.new( n1*(n1-1), ss ),
	frc.new( n2*(n2-1), ss ),
	frc.new( n3*(n3-1), ss )}
   end,
   [[\qrowSix]]
)



committeeOr = mp:new(
   {[[The Senate committee on Education has @size
   members, including Abner and Barbara.
   A subcommittee of three is to be formed to investigate the growing
   scandal in Finite Mathematics.  How many such subcommittees are
   possible which would include @Q1 Abner @Q2 Barbara? ]],
      [[You are on trial for financial fraud, and there are @size
   prospective judges, including Donald and Hillary, both of whom you have
   bribed. A three judge panel will be selected from the @size to decide the
   verdict.  How many such possible panels include @Q1 Donald @Q2 Hillary?]]},
   function( self, q, a )
      local bnda = a or 6
      local size = math.random( bnda, 2*bnda )
      local total = comb( size, 3 )
      local cmpl = comb( size - 2, 3 )
      local qlst = { { 'exactly one of', 'and', 2 * comb( size - 2, 2 ) },
         { '', 'or', total - cmpl } }
      q = q or math.random(2)
      return { size=size, Q1=qlst[ q ][1], Q2=qlst[ q ][2] },
      { qlst[ q ][3],
        2*size*size,
        size*size,
        2*(size - 2),
        total - cmpl, 2 * comb( size - 2, 2 ),
        comb( size - 2, 2 ), 2 * comb( size - 1, 2 ),
        total, cmpl, size, comb( size, 2 ), 
        size + comb( size - 1, 2) * 2,
        comb( size - 2, 2) * 2,
        comb( size - 1, 2 ),
        size + comb( size - 2, 2),
        total - comb( size - 3, 3 ),
        total - comb( size - 3, 2 ) }
   end
)




paradigms = mp:new(
   [[There are %d 
   cubic plastic blocks, each one a different color from the
   others.  How many ways are there 
   %s? Assume that the color of each block matters.]],
   function ( self, q, numblocks )
      local tot = numblocks or math.random( 5, 10 ) * 2
      local sub = math.random( 3, 9 )
      local qlst = { string.format( 'to build a tower %d blocks high', sub ),
		     string.format( 'to choose %d blocks to give to a friend', sub ),
		     string.format( 'for %d friends to each name his/her favorite color', sub ),
		     [[to split them up into two {\em equally sized} jumbled heaps, one on your left and one on your right]],
		     'to choose some of the blocks (any number, including none) to sell' }
      local anslst = { string.format( [[\(\prm( %d, %d )\)]], tot, sub ),
		       string.format( [[\(\cmb( %d, %d )\)]], tot, sub ),
		       string.format( [[\(%d^{%d}\)]], tot, sub ),
		       string.format( [[\(\cmb( %d, %d )\)]], tot, tot/2 ),
		       string.format( [[\(2^{%d}\)]], tot ) }
      local wrong = { string.format( [[\(2^{%d}\)]], sub ),
		      string.format( [[\(\prm( %d, %d )\)]], tot, tot ),
		      string.format( [[\(\cmb( %d, %d )\)]], tot, tot ),
		      string.format( [[\(\prm( %d, %d )\)]], sub, sub ),
		      string.format( [[\(\cmb( %d, %d )\)]], sub, sub ) }
      q = q or math.random( 5 )
      return { tot, qlst[ q ] }, 
      listJoin( { anslst[ q ] }, anslst, wrong )
   end
)

randomParadigmsN = function( n )
   local typelist = table.pack( distinctRands( n, 1, 5 ) )
   local latex = [[]]
   for i = 1,n do
      latex = latex .. [[\item \genMP{ paradigms }{ ]]
      latex = latex .. typelist[i]
      latex = latex .. [[ } \vsp{1} ]]
   end 
   return latex
end 


houseSubcom = mp:new(
   [[A House committee has @tot members, consisting of @rep Republicans and
   @dem Democrats.
   A budget group is going to be formed consisting of 
   @grrep Republicans and @demnoun.
   How many ways are there to choose the members on the budget group?
   ]],
      function( self, total, sub, dems, gd )
	 total = total or math.random( 20, 30 )
	 sub = sub or math.random( 4, 8 )
	 local dempl = mkPlural( 'Democrat' )
	 dems = dems or math.random( 2, math.floor( total / 2 ) )
	 local reps = total - dems
	 gd = gd or math.random( 2, math.floor( sub / 2 ) )
	 local gr = sub - gd
         tot,rep,dem,grrep,grdem,demnoun=total, reps, dems, gr,gd,dempl:ch( gd )
	 return { comb( reps, gr ) * comb( dems, gd ),
           perm( reps, gr ) * perm( dems, gd ),
           comb( reps, gr ), comb( dems, gd ),
           perm( reps, gr ), perm( dems, gd ),
           gr * gd, reps * dems,
           comb( reps, gr ) + comb( dems, gd ),
           perm( reps, gr ) + perm( dems, gd ),
           gr + gd, reps + dems }
      end
)


houseSubcomMin = mp:new(
   [[A House committee has @total members, consisting of @reps Republicans and
   @dems Democrats.
   An education group of @subs members is going to be formed, and
   this group must have at least @reppl.
   How many ways are there to choose the members on the education group?
   ]],
      function( self, tot, sub, dem )
	 total = tot or math.random( 20, 30 )
	 dems = dem or math.random( 2, math.floor( total / 2 ) )
	 reps = total - dems
	 subs = sub or math.random( 4, 8 )
	 min =  math.random( math.floor( subs / 2 ), math.min(subs - 2,
                                                             reps - 1) )
         reppl = mkPlural( 'Republican' ):ch(min)
	 local answer = 0
	 for i = min,subs do
	    answer = answer +  comb( reps, i ) * comb( dems, subs - i )
	 end
         local wrong1 = 0
         for i = 0,min do
	    wrong1 = wrong1 +  comb( reps, i ) * comb( dems, subs - i )
         end
         local wrong2 = 0            
         for i = 0,(min - 1) do
            wrong2 = wrong2 +  comb( reps, i ) * comb( dems, subs - i )
         end
         return { answer,
                  wrong1,wrong2,
                  comb( reps, min ) * comb( dems, subs - min ),
                  answer - comb( reps, min ) * comb( dems, subs - min ),
                  comb( total, min ) * comb( total - min, subs - min ),
                  perm( reps, min ) * perm( dems, subs - min ),
                  comb( reps, min ) + comb( dems, subs - min ),
                  comb( total, subs ),
                  comb( total, subs ) - answer,
                  perm( total, min ) * perm( total - min, subs - min ),
                  perm( reps, min ) + perm( dems, subs - min ),
                  perm( total, subs ),
                  math.floor( answer/2 ),
                  math.floor( answer/3 ),
                  math.floor( answer/4 ),
                  math.floor( answer/5 ),
                  math.floor( answer/6 ),
                  math.floor( answer/7 ),
                  math.floor( answer/8 ),
                  math.floor( answer/9 ),
                  math.floor( answer/10 ) }
      end
)


weightsInEvents = mp:new(
   {[[A sample space consists of just three outcomes,
   denoted \(\mathcal{O}_1\), \(\mathcal{O}_2\), and
   \(\mathcal{O}_3\).  Events \(E\), \(F\), and \(G\) are defined as 
   \[ E = \{\,\mathcal{O}_1,\mathcal{O}_2\,\} \qquad 
   F =\{\,\mathcal{O}_2,\mathcal{O}_3\,\} \qquad
   G = \{\,\mathcal{O}_1,\mathcal{O}_3\,\}\]
   If \(\pr{E}= @pre \) and \(\pr{F}= @prf \), 
   what is \(\pr{G}\)?]],
      [[In baseball a turn at bat can have one of three distinct
    outcomes: a hit, a walk, or
   an out.  Alex Umbuggio has a @pre probability of either getting a hit or a
   walk, and a @prf probability of not getting a hit.  What is the
   probability that he either gets a hit or makes an out? ]]},
   function ( self )
      local p1, p2 = distinctRands( 2, 20, 49 )
      while 2*p1+p2 == 100 or p1+2*p2 == 100 do p1, p2 = distinctRands( 2, 20, 50 ) end
      p1, p2 = p1/100, p2/100
      local p3 = 1 - p1 - p2
      pre, prf = p1 + p2, p2 + p3
      return { p1 + p3,
               p1, p2, p3,
               p1+p2, p2+p3,
               (pre+prf)/2, 1-(pre+prf)/2,
               0, 1,
               pre, prf,
               0.25, 0.75 }
   end
)


subsetCount = mp:new(
   [[A set \(S\) has @ns elements.
   How many subsets of \(S\) are there with 
   @qstr @lim elements?  
   ]],
      function ( self, ns, lim )
         local s = self
         ns = ns or math.random( 6, 10 )
         lim = lim or 2
         _ENV.ns, _ENV.lim = ns, lim
         local mostQ = randBool()
         qstr = [[{\em at most}]]
         -- if randBool() then 
         -- 	 qstr = 'at least'
         -- 	 lim = ns - lim
         -- end
         --local subs = { ns, qstr, lim }
         local ans = 0 
         local minlim = math.min( lim, ns - lim )
         for i = 0, minlim do
            ans = ans + comb( ns, i )
         end
         local wrong1 = ans + comb( ns, minlim + 1 )
         local wrong2 = ans - comb( ns, minlim )
         local anslst = { ans, wrong1, wrong2,
                          comb( ns, lim ), ns, lim,
                          ans - 1, wrong1 - 1, wrong2 - 1 }
         return anslst
      end,
   [[\qrowSix]]
)
--subsetCount.subFun = 'self'



-- numbers too big?
permCompl = mp:new(
   { [[A Senate committee has @nd Democrats and @nr Republicans.
   A secretary, treasurer, and sergeant-at-arms must be named from the
   committee members in such a way that each party gets at least one
   of the three offices.  If each office must be occupied by a distinct
   member, how many ways are there to name people to the three
   offices?  ]],
      [[You have @nd shades of blue paint and @nr shades of red paint. You are painting
a room, and wish to use three different colors to paint the walls one color, the
moldings another color, and the ceiling a third color. (Using two different shades
of blue, for instance, is using two different colors.) How many ways are there to
paint your room if at least one shade of blue and one shade of red are used?]] },
   function ( self, tot )
      tot = tot or 7
      nr = nr or math.random( 2, math.floor( tot/2 ) + 1 )
      _ENV.tot, _ENV.nr = tot, nr
      nd = tot - nr
      local tot = nd + nr
      local ss = perm( tot, 3 )
      local ar, ad = perm( nr, 3 ), perm( nd, 3 )
      return { ss - ar - ad,
	       ss - ar, ss - ad,
	       ss, ar, ad, ar + ad,
	       ss - ar - ad - 6 * comb( nd, 2 ) * nr,
	       ss - ar - ad - 6 * comb( nr, 2 ) * nd,
               perm(nr,1)*perm(nd,2),
               perm(nr,2)*perm(nd,1),
               perm(nr,2)*perm(nd,1)+perm(nr,1)*perm(nd,2) }
   end
)
--permCompl.subFun = 'self'

anarchists = mp:new( {
   [[ An Anarchists' Club meets @trials times per year.  The club 
      has @mems members including @nf women and @nm men.  
      At each meeting one person is selected to preside, 
      but no one can preside at more than one meeting in the 
      course of a year. 
      
      If a record is kept of who presided at each meeting 
      during one year, in how many possible overall outcomes  
      would women preside exactly @nsuc times? ]],
   [[ A fraternity holds @trials parties on different nights 
      during the semester, and at
      each party they hire a different band to play.  There are @nf
      rock bands and @nm polka bands that they can afford.  In how
      many outcomes are rock bands hired exactly @nsuc times?
   ]] },

   function( self, nmems, ntrials )
      trials = ntrials or math.random( 8, 12 )
      mems = nmems or math.random( trials + 1, 2 * trials )
      nf = math.random( 3, mems - 3 )
      while nf == mems / 2 do nf = math.random( 4, mems - 4 ) end
      nm = mems - nf
      nsuc = math.random( 2, nf - 2 )
      while nsuc == trials / 2 do nsuc = math.random( 2, nf - 2 ) end
      local nfail = trials - nsuc
      return { comb( trials, nsuc ) * perm( nf, nsuc ) * perm( nm, nfail ),
	       comb( trials, nsuc ) * comb( nf, nsuc ) * comb( nm, nfail ),
	       perm( nf, nsuc ) * perm( nm, nfail ),
	       comb( nf, nsuc ) * comb( nm, nfail ),
	       comb( trials, nsuc ) * comb( nf, nsuc ),
	       comb( trials, nsuc ) * comb( nm, nfail ),
	       perm( trials, nsuc ) * perm( nf, nsuc ) * perm( nm, nfail ),
	       nsuc * perm( nf, nsuc ) * perm( nm, nfail ),
	       comb( trials, nsuc ) * nsuc * nfail,
	       comb( trials, nsuc ) * nf * nm,
	       nf * nm * trials
      }
   end,
   [[\qrowFour]]
)


langClass = mp:new( 
   [[ A foreign language class meets @trials days a week.  The class  
      has @studs students including @student.  Each day the instructor 
      calls on one person to read aloud and translate an excerpt 
      from that day's reading assignment.  (Note:  Sometimes the instructor
      calls on the same person more than once in a week, indeed, even 
      on every day.)

      In how many possible overall outcomes would @student be called
      on exactly @nsuc times next week? ]],

   function( self, ntrials, studentn )
      student = studentn or ({"Skyler","Trudy"})[math.random(2)]
      trials = ntrials or math.random( 3, 5 )
      studs = math.random( 10, 19 )
      nsuc = math.random( 2, trials - 1 )
      local nfail = trials - nsuc
      return { comb( trials, nsuc ) * (studs - 1)^nfail,
	       perm( trials, nsuc ) * (studs - 1)^nfail,
	       comb( trials, nsuc ) * ( studs ^ nfail ),
	       perm( trials, nsuc ) * ( studs ^ nfail ),
	       (studs - 1)^nfail, ( studs ^ nfail ),
	       nsuc * (studs - 1)^nfail,
	       trials * (studs - 1)^nfail,
	       perm( nsuc, nsuc ), perm( nsuc, nsuc ) * ( studs - 1 )^nfail,
	       perm( nsuc, nsuc ) * studs^nfail }
   end,
  [[\qrowFour]] 
)


setAlgebra = mp:new(
   [[Given the following sets
   \[\begin{array}{lcr}
     X &=& %s \\
     Y &=& %s \\
     Z &=& %s 
   \end{array}\]
   in the universe \(U=%s\), what is \((X%s%s Y%s)%s Z%s\)? ]],
   function ( self, q1, q2 )
      local elems = { 'a', 'b', 'c', 'd', 'e' }
      local U = st:new( elems )
      local X, Y, Z = U:random(true), U:random(true), U:random(true)
      local compl = math.random( 3 )
      local cmplst = { '', '', '' }
      cmplst[ compl ] = [[']]
      local sets = { X, Y, Z }
      sets[ compl ] = U - sets[ compl ]

      local ops = { [[\cap]], [[\cup]] }
      local q1, q2 = q1 or math.random( 2 ), q2 or math.random( 2 )
      local q = 2 * q1 + q2 - 2
      local anslst = { (( sets[1] * sets[2] ) * sets[3]),
		       (( sets[1] * sets[2] ) + sets[3]),
		       (( sets[1] + sets[2] ) * sets[3]),
		       (( sets[1] + sets[2] ) + sets[3]) }
      local wrong = { (( X * Y ) * Z),
		      (( X * Y ) + Z),
		      (( X + Y ) + Z),
		      (( X + Y ) * Z),
		      U:random(), U:random(), U:random(),
		      U:random(), U:random(), U:random(),
		      U:random(), U:random(), U:random() }
      return { X:tolatex(), Y:tolatex(), Z:tolatex(), U:tolatex(),
	       cmplst[1], ops[ q1 ], cmplst[2], 
	       ops[ q2 ], cmplst[3] },
               mp.listToLatex( listJoin( { anslst[ q ] }, 
					 anslst, wrong ) )
   end,
   [[\qrowFour]]
)

