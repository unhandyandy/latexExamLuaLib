-- -*-Lua-*-

frc = require('fraction')
vec = require('vector')
st = require('sets')
venn = require('venn')
max = require('maxima')
venn.max = max.new()
venn.dir = '/home/dabrowsa/teach/img/'
venn.scale = .30
venn:initMaxima()
mp = require('mathProblem')
mp.chcFun = [[\qrowEight]]
-- mp.numberChoices = 8



syntax01 = mp:new( { [[ Suppose that in these Venn diagrams \(U\) represents 
     the universe of IU students, \(A\) is set of students 
     who like @Anm, \(B\) is set of students who like @Bnm, and \(C\) 
     is set of students who like @Cnm.  
     Which graph of the following graphs represents the students who @quest? ]],
      [[ Suppose that in the Venn diagram \(U\) represents 
     the universe of IU students, \(A\) is the set of students 
     who like @Anm, \(B\) is the set of students who like @Bnm, and \(C\) 
     is the set of students who like @Cnm.  
        Shade the region of the Venn diagram that represents those who @quest.
        {\bf Make sure you indicate clearly which is the final shaded region! }
        
     \begin{center}  @blankpic  \end{center} ]] },
	function( self, astr, bstr, cstr )
	   Anm = astr or "Astronomy"
	   Bnm = bstr or "Biology"
	   Cnm = cstr or "Chemistry"
	   local nouns = { Anm, Bnm, Cnm, }
	   local v1 = ifset( randBool(), "like", "do not like" )
	   local v2 = ifset( randBool(), "like", "do not like" )
	   local conj1 = ifset( randBool(), "and", "or" )
	   local conj2 = ifset( randBool(), "and", "or" )
	   local nind3, nind2 = distinctRands( 2, 1, 3 )
	   local nind1 = 6 - nind3 - nind2
	   local n1 = nouns[ nind1 ]
	   local n2 = nouns[ nind2 ] .." ".. conj2 .." ".. nouns[ nind3 ]
	   quest = v1 .." ".. n1 .." ".. conj1 .." ".. v2 .." ".. n2
	   
	   -- local universe = table.pack( distinctRands( 8, 1, 8 ) )
	   -- local U = st:new( universe )
	   -- local A = st:new( universe[5],  universe[6], universe[7],  universe[8] )
	   -- local B = st:new( universe[3],  universe[4], universe[7],  universe[8] )
	   -- local C = st:new( universe[2],  universe[4], universe[6],  universe[8] )
	   -- local sets = { A, B, C }
	   -- local clause1 = sets[ nind1 ]
	   -- if v1 == "do not like" then clause1 = U - clause1 end
	   -- local clause2 = sets[ nind2 ] * sets[ nind3 ]
	   -- if conj2 = "or" then
	   -- 	 clause2 = sets[ nind2 ] + sets[ nind3 ]
	   -- end
	   -- if v2 == "do not like" then clause2 = U - clause2 end
	   -- local sentence = clause1 * clause2
	   -- if conj1 = "or" then
	   -- 	 sentence = clause1 + clause2
	   -- end

 	   local C1= venn:newSimple(nind1)
	   local C2 = venn:newSimple(nind2)
	   local C3 = venn:newSimple(nind3)
	   local clause1 = C1
	   if ( v1 == "do not like" ) then clause1 = - clause1 end
	   local clause2 = C2 * C3
	   if ( conj2 == "or" ) then
	      clause2 = C2 + C3
	   end
	   if ( v2 == "do not like" ) then clause2 = - clause2 end
	   local sentence = clause1 * clause2
	   if ( conj1 == "or" ) then
	      sentence = clause1 + clause2
	   end
	   sentence:saveGraph()

           local blankvenn = vennEmpty
           blankvenn.scale = .60
           blankvenn:saveGraph()
	   blankpic = blankvenn:tolatexpic()

	   --print( '\n sentence = ' .. sentence:__tostring() .. '\n' )
	   local anslist = { sentence,
			    (C1 * ( C2 * C3)),
			       ((- C1) * ( C2 * C3)),
			       ((C1) * (- (C2 * C3))),
			       (( -C1) * (- (C2 * C3))),
			       (C1 + ( C2 * C3)),
			       ((- C1 ) + ( C2 * C3)),
			       ((C1 ) + (- (C2 * C3))),
			       (( -C1 ) * (- (C2 + C3))),
			       ((- C1 ) * ( C2 + C3)),
			       ((C1 ) * (- (C2 + C3))),
			       (( -C1 ) * (- (C2 + C3)))
           }
           if self.mcP then
              for i = 1, #anslist do
                 anslist[i]:saveGraph()
              end
           end

	   --print( '\n sentence = ' .. sentence:tolatexpic() .. '\n' )
	   return map( anslist, function(x) return x:tolatexpic() end )
	end,
	[[\qrowTwo]]
)




hilton = mp:new([[ @nameslist
       are going to attend a conference at a @hotel.  Each one
       will have a single room by herself or himself.  When they
       arrive at the hotel (they drove together in a company van),
       there are @na single rooms available on the first floor
       and  @nb single rooms available on the second floor.  Each
       person is assigned to one of these rooms. 

       In how many overall outcomes are Byron and Chloe on the same
       floor? ]],
		
    function( self, numnm, hname )
       local names = { "Anthony", "Byron", "Chloe", "Denise", "Edward",
		       "Francine", "Hannibal", "Nicole", "Patrick", "Sarah", 
		       "Ulrich", "Vera", "Wendy" }
       numnm = numnm or math.random( 5, 13 )
       hotel = hname or "Hilton Hotel"
       nameslist = table.concat( 
	  listTake( names, numnm - 1 ), ", " )  .. 
	  ", and " .. names[ numnm ] .. " "
       na, nb = distinctSummands( 2, numnm + math.random( 4 ) )
       na, nb = na + 2, nb + 3
       tot = na + nb
       return { ( perm( na,2) + perm( nb,2) ) * perm( tot - 2, numnm - 2 ),
		perm( na,2) * perm( tot - 2, numnm - 2 ),
		perm( nb,2) * perm( tot - 2, numnm - 2 ),
		perm( tot, numnm ),
		( comb( na,2) + comb( nb,2) ) * comb( tot - 2, numnm - 2 ),
		comb( na,2) * comb( tot - 2, numnm - 2 ),
		comb( nb,2) * comb( tot - 2, numnm - 2 ),
		comb( tot, numnm ),
		( na^2 + nb^2 ) * (tot - 2)^(numnm - 2),
		perm( tot - 2, numnm - 2 ),
		comb( tot - 2, numnm - 2 ) }
    end,
   [[\qrowFour]]
) 





parse01 = mp:new( [[ Suppose that of the members of Beta Eta Rho fraternity, 
 @Ab like @v1 but not @v2, @aB like @v2 but not
 @v1, @AB like both, and @ab like neither. How many
 members like @qv1 or do not like @qv2? ]],

    function( self, vn1, vn2 )
       v1, v2 = vn1, vn2
       AB, Ab, aB, ab = distinctRands( 4, 20, 30 )
       local A, B, U = AB + Ab, AB + aB, AB + Ab + aB + ab
       qv1, qv2 = v1, v2
       if randBool() then qv1, qv2 = qv2, qv1 end
       local ans1, ans2 = AB + Ab + ab, AB + aB + ab
       if qv1 == v2 then ans1, ans2 = ans2, ans1 end
       return { ans1, ans2,
		AB, Ab, aB, ab,
		A, B, U, U - ab, U - AB }
    end
)
parse02 = mp:new( [[ Suppose that of the members of the 
Sigma Gamma Rho sorority, 
 @Ab like @v1 but not @v2, @aB like @v2 but not
 @v1, @AB like both, and @ab like neither. How many
 members like at @comp one of @v1 and @v2? ]],

    function( self, vn1, vn2 )
       v1, v2 = vn1, vn2
       AB, Ab, aB, ab = distinctRands( 4, 20, 30 )
       comp = ifset( randBool(), "most", "least" )
       local A, B, U = AB + Ab, AB + aB, AB + Ab + aB + ab
       local ans1, ans2 = aB + Ab + ab, AB + aB + Ab
       if comp == "least" then ans1, ans2 = ans2, ans1 end
       return { ans1, ans2,
		AB, Ab, aB, ab,
		A, B, U, U - ab, U - AB }
    end
)



		      
