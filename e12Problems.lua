-- -*-two-mode-*-

mp = require('mathProblem')
mp.chcFun = [[\chc]]
mp.numberChoices = 8

ef = require('enumForm')
answers = ef.new()

ansBlanks = createBlankList( 15 )
ansBlanks[1] = 3
ansBlanks[2] = 2


-- function easyThreeCircle(u,a,b,c,ac)
--    local i = u - ( a + c - ac )
--    local ii = a - ac
--    local iii = ii + b
--    local iv = a * b
--    local choices = randPerm{a + c, math.abs(a - c),  math.abs(c - a), u - a + c, u + a - c, i, a + c -ac, u - (a + c)}
--    listConcat( choices,
-- 	       randPerm{ac, c - ac, ii, (u - c) * a, (u - c) + a, 0, 7, 12},
-- 	       randPerm{0, ii, math.abs(u - ii), iii, math.abs(ii - b), ii * b, 13, 14},
-- 	       randPerm{0, iv, 2 * iv, 13, 5 * iv, a * c, b * c, -2})

--    return string.format([[ 

-- [3 points each] 
-- Suppose $\crd{U}=%d$, and let $A$, $B$, and $C$ be sets, and suppose that $\crd{A}=%d$, $\crd{B}=%d$, $\crd{C}=%d$; also suppose that $A$ and $B$ are disjoint, and that $\crd{A\cap C}=%d$.  Find the sizes of the following sets. 
 
-- \begin{enumerate} 
-- \item[i.] $(A\cup C)'$\\ 
-- \chc{%d}{%d}{%d}{%d}{%d}{%d}{%d}{%d} \vsp{.2} 
-- \item[ii.] $C'\cap A$ \\ 
-- \chc{%d}{%d}{%d}{%d}{%d}{%d}{%d}{%d} \vsp{.2} 
-- \item[iii.] $(A\cap C')\cup B$ \\ 
-- \chc{%d}{%d}{%d}{%d}{%d}{%d}{%d}{%d} \vsp{.2} 
-- \item[iv.] $A \times B$ \\ 
-- \chc{%d}{%d}{%d}{%d}{%d}{%d}{%d}{%d} \vsp{.2} 
-- \end{enumerate}]],
-- u,a,b,c,ac,
-- table.unpack( choices )
-- 			    )
-- end

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



-- function coinsDrawFlip( numCoins, numFlips )
--    local c = numCoins
--    local f = numFlips
--    return string.format([[ 
-- A box contains %d 
-- different coins.
-- An experiment consists of drawing two coins in succession without
-- replacement from the box, noting the type of each coin as it
-- is drawn, and then 
-- flipping the last coin drawn %d 
-- times and noting the number of Heads.  
-- An outcome is a list of the coins drawn, in the order they were drawn, 
-- and the number of Heads that came up on the %d 
-- flips. How large is the sample space?

-- \chc{%d}{%d}{%d}{%d}{%d}{%d}{%d}{%d}
-- ]],
-- numCoins, numFlips, numFlips,
-- table.unpack( randPerm{ 
--    perm( c, 2 ) * ( f + 1 ),
--    perm( c, 2 ) * ( f ),
--    c * c * ( f + 1 ),
--    c * c * f,
--    comb( c, 2 ) * ( f + 1 ),
--    comb( c, 2 ) * ( f ),
--    c * ( f + 1 ),
--    c * f  
-- 		      }))
-- end

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



-- function setExpr()
--    local choices = {}
--    listConcat( choices, randPerm({
-- 	         [[$\female\cap A \subset R$]],
-- 		 [[$G\subset \female\cap R$]],
-- 		 [[$\female \cap R\subset A$]],
-- 		 [[$A\subset \female \cap R'$]],
-- 		 [[$G\cap \female \subset R$]],
-- 		 [[$\female\cup A = R$]],
-- 		 [[$G\cap R = \female$]],
-- 		 [[$A\cup R \subset \female$]]}),
-- 			  randPerm({
-- 		 [[$D\cap A = \emp$]],
-- 		 [[$D\cap A \not= \emp$]],
-- 		 [[$D'\cup A' \not= \emp$]],
-- 		 [[$D'\cap A' \not= \emp$]],
-- 		 [[$D\cup A = \emp$]],
-- 		 [[$D\cup A \not= \emp$]],
-- 		 [[$D'\cup A' = \emp$]],
-- 		 [[$D'\cap A' = \emp$]]})
-- 			)
--    res = string.format([[

-- [3 points each]
-- Let the universe $U$ be the set of all Indiana residents. Let 
-- $R$ be the set of Republicans, let $D$ be the set of Democrats, let
-- $G$ be the set of gay marriage supporters, let $A$ be set of 
-- gay marriage opponents, 
-- and let $\female$ be the set of female voters.

-- Translate the following English sentences into set theory. 
-- If there is more than one correct answer you need select only one of
-- them. 


-- \begin{enumerate}

-- \item[i.]
-- All women who oppose gay marriage are Republicans.\\
-- \chc{%s}{%s}{%s}{%s}{%s}{%s}{%s}{%s}


-- \item[ii.]
-- All Democrats support gay marriage.\\
-- \chc{%s}{%s}{%s}{%s}{%s}{%s}{%s}{%s}

-- \end{enumerate}
-- ]],
-- 		       table.unpack( choices ))
--    return res
-- end


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

      local rels = { [[ = ]], [[ \subset ]] };
      local ops = { [[ \cap ]], [[ \cup ]] };
      local q1, q2 = math.random( 2 ), math.random( 2 );
      local verbs = { "are defined to be things which are", "are" };
      local conjs = { "and", "or" };
      if ( negs[2] and not negs[3] ) or ( not negs[2] and negs[3] ) then
         conjs[1] = "but"
      end
      statement = defX..verbs[q1]..' '..nouns[2]..conjs[q2]..' '..nouns[3]
      local q = 2 * q1 + q2 - 2
      local anslst = { [[\(]]..sets[1]..rels[1]..sets[2]..ops[1]..sets[3]..[[\)]],
        	       [[\(]]..sets[1]..rels[1]..sets[2]..ops[2]..sets[3]..[[\)]],
        	       [[\(]]..sets[1]..rels[2]..sets[2]..ops[1]..sets[3]..[[\)]],
        	       [[\(]]..sets[1]..rels[2]..sets[2]..ops[2]..sets[3]..[[\)]] };
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



-- function hardThreeCircle()
--    local pieces = { 'abc', 'Abc', 'aBc', 'abC', 'ABc', 'AbC', 'aBC', 'ABC' }
--    local sizes = {}
--    for _, p in ipairs( pieces ) do
--       sizes[ p ] = math.random( 1, 9 )
--    end
--    local total = 0
--    for _, p in ipairs( pieces ) do
--       total = total + sizes[ p ]
--    end
   
--    res = string.format(
-- [[
-- A math instructor has %d short sleeve pocket T-shirts in his closet.   
-- Of them, %d are in perfect condition,
-- %d have coffee stains,
-- %d have moth holes,
-- and %d are covered in chalk dust.
-- Of those with coffee stains,
-- %d are also covered in chalk dust
-- and %d also have moth holes.
-- He has %d coffee-stained moth-eaten chalk-covered shirts,
-- which he's thinking about throwing out.

-- You must {\em completely} fill in the Venn diagram for
-- full credit.
-- ]],
-- total, 
-- sizes.abc, 
-- sizes.Abc + sizes.ABc + sizes.AbC + sizes.ABC,
-- sizes.aBc + sizes.aBC + sizes.ABC + sizes.ABc,
-- sizes.abC + sizes.aBC + sizes.AbC + sizes.ABC,
-- sizes.ABC + sizes.AbC,
-- sizes.ABC + sizes.ABc,
-- sizes.ABC
-- )

-- return res
-- end


hardThreeCircle = mp:new(
   [[
   A math instructor has %d short sleeve pocket T-shirts in his closet.   
   Of them, %d are in perfect condition,
   % d have coffee stains,
   % d have moth holes,
   and %d are covered in chalk dust.
   Of those with coffee stains,
   % d are also covered in chalk dust
   and %d also have moth holes.
   He has %d coffee-stained moth-eaten chalk-covered shirts,
   which he's thinking about throwing out.
   
   You must {\em completely} fill in the Venn diagram for
   full credit.
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
      qsubs = { total, 
		sizes.abc, 
		sizeA,
		sizeB,
		sizeC,
		sizes.ABC + sizes.AbC,
		sizes.ABC + sizes.ABc,
		sizes.ABC }
      local ansstr = [[\( \crd{A\cap B'\cap C'} = ]] .. sizes.Abc .. [[\\ \crd{A'\cap B\cap C'} = ]] .. sizes.aBc .. [[\\ \crd{A'\cap B'\cap C} = ]] .. sizes.abC .. [[\\ \crd{A\cap B\cap C} = ]] .. sizes.ABC .. [[\\ \crd{A'\cap B'\cap C'} = \)]] .. sizes.abc;
      return qsubs, ansstr
   end
)
hardThreeCircle.mcP = false


-- function partitionProb( a, ab, bc )
--    -- local a, ab, bc
--    a = a or math.random( 1, 9 )
--    ab = ab or math.random( 2, 5)
--    bc = bc or math.random( 2, 5)
--    local total = ( 1 + ab + ab * bc ) * a

--    res = string.format(
-- [[
-- A universal set $U$ with %d elements has been partitioned into three
-- subsets, $A$, $B$, and $C$.  If $B$ is %d times the size of $A$ and
-- $C$ is %d times the size of $B$, then how many elements are in
-- $B$? \\

-- \chc{%d}{%d}{%d}{%d}{%d}{%d}{%d}{%d}
-- ]],
-- total, ab, bc,
-- table.unpack( randPerm{
-- 		 a * ab,
-- 		 a,
-- 		 ab,
-- 		 total,
-- 		 a + a * ab,
-- 		 a + 1,
-- 		 a * ab + 1,
-- 		 a * ab * bc
-- 		      })
-- )

--    return res
-- end

partitionProb = mp:new(
   [[
       A universal set $U$ with %d elements has been partitioned into three
       subsets, $A$, $B$, and $C$.  If $B$ is %d times the size of $A$ and
       $C$ is %d times the size of $B$, then how many elements are in
	     $B$? ]],
function( self, a, ab, bc )
   a = a or math.random( 1, 9 )
   ab = ab or math.random( 2, 5)
   bc = bc or math.random( 2, 5)
   local total = ( 1 + ab + ab * bc ) * a
   local qsubs = { total, ab, bc }
   local anslst = { a * ab,
		    a, ab,
		    total,
		    a + a * ab,
		    a + 1,
		    a * ab + 1,
		    a * ab * bc,
		    distinctRands( 4, 1, total ) }
   return qsubs, anslst
end
)



-- function digiPets()
--    local setB, setC
--    setB = { 'B', 'F', 'G', 'K', 'M', 'R', 'S', 'T', 'Z' }
--    setC = { 'C', 'D', 'L', 'N', 'P', 'Y' }
--    local lenB = math.random( 3, #setB )
--    local lenC = math.random( 3, #setC )
--    local chB = table.concat( setB, ',' ):sub( 1, 2 * lenB - 1 )
--    local chC = table.concat( setC, ',' ):sub( 1, 2 * lenC - 1 )

--    res = string.format(
-- [[
-- DigiPets is a company that makes electronic cyber-pets.  Pet names are
-- formed from the consonants $B=\stt{%s}$, $C=\stt{%s}$
-- and the vowels 
-- $V=\stt{A,E,I,O,U}$ in the following way.  First a consonant is chosen
--  from $B$, then a vowel is
-- chosen from $V$, then another consonant is chosen from $C$.
-- For example, ``Bil'' and ``Fad'' are both possible DigiPet names.

-- How many possible DigiPet names are there? \\

-- \chc{%d}{%d}{%d}{%d}{%d}{%d}{%d}{%d}
-- ]],
-- chB, chC,
-- table.unpack( randPerm{
-- 		 lenB * 5 * lenC,
-- 		 lenB * 5 * lenB,
-- 		 lenC * 5 * lenC,
-- 		 lenB * lenC,
-- 		 lenB * lenB,
-- 		 lenC * lenC,
-- 		 26,
-- 		 52
-- 		      })
--    )

-- return res
-- end

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



-- function dessertProb()
--    local types = { 'pie', 'cake', 'icecream' }
--    local numch = {}
--    for _, d in ipairs( types ) do
--       numch[ d ] = math.random( 2, 5 )
--    end
--    local two = math.random( #types )
--    local one = two + 1
--    if one > #types then one = one - #types end
--    local t = numch[ types[ two ] ]
--    local o = numch[ types[ one ] ]

--    res = string.format(
-- [[
--  Three friends, Bugsy, Baby Face, and Big Sal, are eating dinner together
-- at a restaurant.  When it is time for dessert,
-- the server tells them that the restaurant has  %d flavors of pie,  
-- %d flavors of cake,
--  and  %d flavors of ice cream.
-- The restaurant has an ample supply of each of these,
-- so each person can select a dessert without 
-- concern for what the others may order.
-- Each person orders a dessert from the menu.
-- In how many outcomes would exactly 2 people order %s and
-- 1 person order %s?

-- \chc{%d}{%d}{%d}{%d}{%d}{%d}{%d}{%d}
-- ]],
-- numch.pie, numch.cake, numch.icecream,
-- types[ two ], types [ one ],
-- table.unpack( randPerm{
-- 		 3 * t * t * o,
-- 		 t * t * o,
-- 		 3 * t * (t - 1) * o,
-- 		 t * (t - 1) * o,
-- 		 3 * t * t,
-- 		 t * t * t,
-- 		 3 * t * (t - 1) * (t - 2),
-- 		 t * (t - 1) * (o - 1)		 
-- 		      })
--    )

-- return res
-- end


dessertProb = mp:new(
   [[
       Three friends, Bugsy, Baby Face, and Big Sal, are eating dinner
       together at a restaurant.  When it is time for dessert,
       the server tells them that the restaurant has  %d flavors of pie,  
       %d flavors of cake,
	  and  %d flavors of ice cream.
       The restaurant has an ample supply of each of these,
       so each person can select a dessert without 
       concern for what the others may order.
       Each person orders a dessert from the menu.
       In how many outcomes would exactly 2 people order %s and
	  1 person order %s?]],
   function()
      local types = { 'pie', 'cake', 'icecream' }
      local numch = {}
      for _, d in ipairs( types ) do
	 numch[ d ] = math.random( 2, 5 )
      end
      local two = math.random( #types )
      local one = two + 1
      if one > #types then one = one - #types end
      local t = numch[ types[ two ] ]
      local o = numch[ types[ one ] ]
      local qsubs = { numch.pie, numch.cake, numch.icecream,
		      types[ two ], types [ one ] }
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
      return qsubs, anslst
   end
)


-- function wius()
--    local len = math.random( 4, 7 )
--    local num = math.random( 2, len - 1 )


--    res = string.format([[
-- As programming director at WIUS you stack a pile of %d CDs in the
-- order in which they should be played.  One student disk jockey
-- accidentally knocks the stack of CDs on the floor, and picks them up
-- and stacks them in a random order.  What is the probability that the
-- first %d CDs are the same ones in the same order as originally?


-- \chc{\(%s\)}{\(%s\)}{\(%s\)}{\(%s\)}{\(%s\)}{\(%s\)}{\(%s\)}{\(%s\)}
-- ]],
-- len, num,
-- table.unpack( randPerm{
-- 	string.format( [[\frac{%d}{%d}]], 1, perm( len, num ) ),
-- 	string.format( [[\frac{%d}{%d}]], 1, perm( len, len ) ),
-- 	string.format( [[\frac{%d}{%d}]], 1, len ^ num ),
-- 	string.format( [[\frac{%d}{%d}]], num, len ),
-- 	string.format( [[\frac{%d}{%d}]], 1, perm( num, num ) ),
-- 	string.format( [[\frac{%d}{%d}]], 1, comb( len, num ) ),
-- 	string.format( [[\frac{%d}{%d}]], 1, num ),
-- 	string.format( [[\frac{%d}{%d}]], 1, len )	 
-- 		      })
--    )

--    return res
-- end


wius = mp:new(
   [[
       As programming director at WIUS you stack a pile of %d CDs in the
       order in which they should be played.  One student disk jockey
       accidentally knocks the stack of CDs on the floor, and picks them up
	  and stacks them in a random order.  What is the probability that the
       first %d CDs are the same ones in the same order as originally? ]],
   function()
      local len = math.random( 4, 9 )
      local num = math.random( 2, len - 1 )
      local qsubs = { len, num }
      local anslst = { string.format( [[\(\frac{%d}{%d}\)]], 1, perm( len, num ) ),
	string.format( [[\(\frac{%d}{%d}\)]], 1, perm( len, len ) ),
	string.format( [[\(\frac{%d}{%d}\)]], 1, len ^ num ),
	string.format( [[\(\frac{%d}{%d}\)]], num, len ),
	string.format( [[\(\frac{%d}{%d}\)]], 1, perm( num, num ) ),
	string.format( [[\(\frac{%d}{%d}\)]], 1, comb( len, num ) ),
	string.format( [[\(\frac{%d}{%d}\)]], 1, num ),
	string.format( [[\(\frac{%d}{%d}\)]], 1, len ),
	string.format( [[\(\frac{%d}{%d}\)]], num, perm( len, len ) ),
	string.format( [[\(\frac{%d}{%d}\)]], num, perm( len, num ) ),
	string.format( [[\(\frac{%d}{%d}\)]], num, comb( len, num ) ),
	string.format( [[\(\frac{%d}{%d}\)]], len, perm( len, num ) ) }
      return qsubs, anslst
   end
)








-- function coffeeTea()
--    local c = math.random( 3, 9)
--    local t = math.random( 3, 9)
--    if c == t then t = t - 1 end
--    local a = c + t

--    local res = string.format([[
-- A coffee shop stocks %d flavors of coffee and
-- %d flavors of tea.
-- Assuming all the %d flavors are equally popular, what is the probability
-- that 3 consecutive orders include both coffee and tea?
-- (Of course different customers may order the same thing.)
-- \ignore{
-- A Chinese restaurant offers 14 different dishes, 
-- 9 chicken dishes and 5 tofu dishes.  
-- You and some friends go there and order three different dishes that
-- you will all share.  If you order the three dishes completely at
-- random, what is the probability that both chicken and tofu dishes are
-- included in the order?
-- }
-- \chc{%s}{%s}{%s}{%s}{%s}{%s}{%s}{%s}
-- ]],
-- c, t, a,
-- 		table.unpack( randPerm{
--     string.format([[\(\frac{%d^3 - %d^3 - %d^3}{%d^3}\)]],a,c,t,a ),
--     string.format([[$\frac{\cmb(%d,3)\cmb(%d,3)}{\cmb(%d,3)}$]],c,t,a),
--     string.format([[ $\frac{\cmb(%d,3)+\cmb(%d,3)}{\cmb(%d,3)}$ ]], c,t,a),
--     string.format([[ $\frac{\cmb(%d,3)-\cmb(%d,3)-\cmb(%d,3)}{\cmb(%d,3)}$ ]], a,c,t,a),
--     string.format([[ $\frac{\prm(%d,3)\prm(%d,3)}{\prm(%d,3)}$ ]],c,t,a ),
--     string.format([[ $\frac{\prm(%d,3)+\prm(%d,3)}{\prm(%d,3)}$ ]], c,t,a),
--     string.format([[ $\frac{\prm(%d,3)-\prm(%d,3)-\prm(%d,3)}{\prm(%d,3)}$ ]], a,c,t,a),
--     string.format([[ $\frac{%d^3 + %d^3}{%d^3}$ ]], c,t,a)
-- 				      })
--    )

--    return res 
-- end


coffeeTea = mp:new(
   [[
   A coffee shop stocks %d flavors of coffee and
   % d flavors of tea.
   Assuming all the %d flavors are equally popular, what is the probability
   that 3 consecutive orders include both coffee and tea?
   (Of course different customers may order the same thing.)
   \ignore{
     A Chinese restaurant offers 14 different dishes, 
     9 chicken dishes and 5 tofu dishes.  
     You and some friends go there and order three different dishes that
     you will all share.  If you order the three dishes completely at
     random, what is the probability that both chicken and tofu dishes are
     included in the order?
   }]],
   function()
      local c, t = distinctRands( 2, 3, 9 )
      local a = c + t
      local qsubs = { c, t, a }
      local anslst = { string.format([[\(\frac{%d^3 - %d^3 - %d^3}{%d^3}\)]],a,c,t,a ),
    string.format([[$\frac{\cmb(%d,3)\cmb(%d,3)}{\cmb(%d,3)}$]],c,t,a),
    string.format([[ $\frac{\cmb(%d,3)+\cmb(%d,3)}{\cmb(%d,3)}$ ]], c,t,a),
    string.format([[ $\frac{\cmb(%d,3)-\cmb(%d,3)-\cmb(%d,3)}{\cmb(%d,3)}$ ]], a,c,t,a),
    string.format([[ $\frac{\prm(%d,3)\prm(%d,3)}{\prm(%d,3)}$ ]],c,t,a ),
    string.format([[ $\frac{\prm(%d,3)+\prm(%d,3)}{\prm(%d,3)}$ ]], c,t,a),
    string.format([[ $\frac{\prm(%d,3)-\prm(%d,3)-\prm(%d,3)}{\prm(%d,3)}$ ]], a,c,t,a),
    string.format([[ $\frac{%d^3 + %d^3}{%d^3}$ ]], c,t,a) };
      return qsubs, anslst
   end
)


-- function yen()
--    local types = { 'pennies', 'nickels', 'dimes' }
--    local numbs = {}
--    for _, t in ipairs( types ) do
--       numbs[ t ] = math.random( 2, 9 )
--    end
--    local a = numbs[ types[ 1 ] ]
--    local b = numbs[ types[ 2 ] ]
--    if a == b then b = a + 1 end
--    local c = numbs[ types[ 3 ] ]
--    local s = a + b + c

--    local res = string.format([[
-- Suppose you have %d %s (1\textcent), %d %s (5\textcent), and %d
--      %s (10\textcent) in your pocket.  You grab three coins at random.
--      What is the probability that the value of the three coins is less
--      than 10\textcent?  \\

-- \chcs{\(%s\)}{\(%s\)}{\(%s\)}{\(%s\)}{\(%s\)}{\(%s\)}{\(%s\)}{\(%s\)}
-- ]],
-- a, types[ 1 ], b, types[ 2 ], c, types[ 3 ],
-- table.unpack( randPerm{
--     string.format([[\frac{\cmb(%d,2)\cmb(%d,1)+\cmb(%d,3)}{\cmb(%d,3)}]],a,b,a,s),
--     string.format([[\frac{\cmb(%d,2)\cmb(%d,1)}{\cmb(%d,3)}]],a,b,s),
--     string.format([[\frac{\cmb(%d,1)\cmb(%d,2)+\cmb(%d,2)\cmb(%d,1)+\cmb(%d,3)}{\cmb(%d,3)}]],c,a+b,a,b,a,s),
--     string.format([[\frac{\cmb(%d,2)\cmb(%d,1)+\cmb(%d,1)\cmb(%d,2)+\cmb(%d,2)\cmb(%d,1)+\cmb(%d,3)}{\cmb(%d,3)}]],c,a+b,c,a+b,a,b,a,s),
--     string.format([[\frac{\cmb(%d,3)-\cmb(%d,2)\cmb(%d,1)}{\cmb(%d,3)}]],s,a,b,s),
--     string.format([[\frac{\cmb(%d,3)-\cmb(%d,1)\cmb(%d,2)}{\cmb(%d,3)}]],s,a,b,s),
--     string.format([[\frac{\cmb(%d,3)-\cmb(%d,3)}{\cmb(%d,3)}]],s,b,s),
--     string.format([[\frac{\cmb(%d,3)-\cmb(%d,1)\cmb(%d,2)-\cmb(%d,3)}{\cmb(%d,3)}]],s,a,b,b,s)
-- 		      })
-- )

--    return res
-- end


yen = mp:new(
   [[
   Suppose you have %d %s (1\textcent), %d %s (5\textcent), and %d
   %s (10\textcent) in your pocket.  You grab three coins at random.
   What is the probability that the value of the three coins is less
   than 10\textcent?]],
   function()
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
