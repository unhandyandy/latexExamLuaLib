
local enumForm = {}
enumForm.mt = {__index = enumForm}

enumForm.form = { }
enumForm.stack = { }

function enumForm:down()
   if #self.stack > 0 then
      local new = {}
      table.insert( self.stack[ #self.stack ], new )
      table.insert( self.stack, new )
   else 
      table.insert( self.stack, self.form )
   end 
end

function enumForm:up()
   table.remove( self.stack )
end

function enumForm:add( txt )
   if txt ~= '' then
      table.insert( self.stack[ #self.stack ], txt )
   end
end

function enumForm.blankList( tab )
   local function count( x )
      local t = type( x )
      if t == 'table' then
	 local flat = flatten( x )
	 return #flat
      else 
	 if #x == 1 then
	    return 1 
	 else 
	    return 0
	 end
      end
   end
   return map( tab, count )
end


function enumForm.new()
   local res = {}
   res.form = copy( enumForm.form )
   res.stack = copy( enumForm.stack )
   return setmetatable( res, enumForm.mt )
end

local function tabToLatex( tab, blank )
   blank = blank or false
   local t = type( tab )
   local function TtL( t )
      return tabToLatex( t, blank )
   end
   if t == 'table' then
      local middle = map( tab, TtL )
      middle =  [[ \item ]] .. table.concat( middle, [[
 \item ]] )
      local latex = [[\begin{enumerate}
]] .. middle .. [[
\end{enumerate}]]
      return latex
   elseif blank ~= false  then
      --print( 'blank = ' .. blank )
      return blank 
   else 
      return tab 
   end
end 

function enumForm:tolatex()
   return tabToLatex( self.form )
end

function enumForm.drawBlanks( tab )
   --print( '\n drawBlanks...\n' )
   local enum = tabToLatex( tab, [[\underline{\hsp{4}}]] )
   return [[\begin{multicols}{2} ]] .. enum .. [[ \end{multicols} ]]
end


return enumForm
