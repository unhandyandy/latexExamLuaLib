
local mathProblem = {}
mathProblem.mt = {__index = mathProblem}

mathProblem.mcP = true
mathProblem.template = [[What time is it?]]
mathProblem.numberChoices = 6
mathProblem.chcFun = [[\chcSix]]

function mathProblem:mkchc( lst ) 
   return randPerm( distinctElems( self.numberChoices, lst ) )
end

function mathProblem:submaker() 
   return {}, {1,2,3,4,5,6}
end

function mathProblem:generate( ... ) 
   local subs, chcs = self:submaker( ... )
   local latex = string.format( self.template, table.unpack( subs ) )
   if self.mcP then
      local blanks = createBlankList( self.numberChoices, [[{%s}]] )
      blanks = table.concat( blanks )
      latex = latex .. [[ \\
\\
%s]] .. blanks
      latex = string.format( latex, self.chcFun, 
			     table.unpack( mathProblem:mkchc(chcs) ) ) 
      return latex
   else
      appendAns( chcs )
      return latex
   end
end
   
function mathProblem.listToLatex( lst )
   return map( lst,
	       function (x)
		  return [[\(]] .. x:tolatex() .. [[\)]]
	       end )
end

function mathProblem:new( tmpl, mksubs, chcstr )
   chcstr = chcstr or mathProblem.chcFun
   tmpl = tmpl or mathProblem.template
   mksubs = mksubs or mathProblem.submaker
   local instance = {}
   instance.template = tmpl
   instance.submaker = mksubs
   instance.chcFun = chcstr
   return setmetatable( instance, mathProblem.mt )
end



return mathProblem
