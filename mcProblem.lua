
local mcProblem = {}
mcProblem.mt = {__index = mcProblem}

mcProblem.template = [[What time is it?]]
mcProblem.numberChoices = 6
mcProblem.chcFun = [[\chcSix]]

function mcProblem:mkchc( lst ) 
   return randPerm( distinctElems( self.numberChoices, lst ) )
end

function mcProblem:submaker() 
   return {}, {1,2,3,4,5,6}
end

function mcProblem:generate( ... ) 
   local subs, chcs = self:submaker( ... )
   local latex = string.format( self.template, table.unpack( subs ) )
   latex = latex .. [[ \\
\\
%s{%s}{%s}{%s}{%s}{%s}{%s}]]
   latex = string.format( latex, self.chcFun, 
			  table.unpack( mcProblem:mkchc(chcs) ) ) 
   return latex
end
   
function mcProblem.listToLatex( lst )
   return map( lst,
	       function (x)
		  return [[\(]] .. x:tolatex() .. [[\)]]
	       end )
end

function mcProblem:new( tmpl, mksubs, chcstr )
   chcstr = chcstr or mcProblem.chcFun
   tmpl = tmpl or mcProblem.template
   mksubs = mksubs or mcProblem.submaker
   local instance = {}
   instance.template = tmpl
   instance.submaker = mksubs
   instance.chcFun = chcstr
   return setmetatable( instance, mcProblem.mt )
end



return mcProblem
