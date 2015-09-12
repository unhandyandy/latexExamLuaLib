
-- frc = require('/home/dabrowsa/.lib/lua/5.2/fraction.lua')
-- vec = require('/home/dabrowsa/.lib/lua/5.2/vector.lua')
mac = require('/home/dabrowsa/.lib/lua/5.2/matrix.lua')

function conditionalTD( tm, n1, n2, n3 )
   n1 = n1 or 1
   n2 = n2 or 2
   n3 = n3 or 3
   local form = [[ \begin{figure}[h]\centering
     \begin{tikzpicture}[>=triangle 45,shorten >=1pt,node distance=3cm,on grid,auto,bend angle=15] 
       \node[state] at (0,-1.7) (3)   {%s}; 
         \node[state] at (2,2) (2) {%s}; 
           \node[state] at (-2,2) (1) {%s};
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
	 if type( p ) == "string" or p > 0 then
	    local ltx = p
	    if type( p ) ~= "string" then ltx = p:tolatex() end
	    table.insert( lst, edges[ i ][ j ]:format( ltx ) )
	 end 
      end 
      table.insert( subs, table.concat( lst, ' ' ) )
   end 
   return form:format( n3, n2, n1, table.unpack( subs ) )
end 

function conditionalTD2( tm, n1, n2 )
   n1 = n1 or 1
   n2 = n2 or 2
   local form = [[ \begin{figure}[h]\centering
     \begin{tikzpicture}[>=triangle 45,shorten >=1pt,node distance=3cm,on grid,auto,bend angle=15] 
         \node[state] at (2,2) (2) {%s}; 
           \node[state] at (-2,2) (1) {%s};
             \path[->] 
             (1) %s
             (2) %s;
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
   return form:format( n1, n2, table.unpack( subs ) )
end 
