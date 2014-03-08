local Venn = {}
Venn.__index = Venn
Venn.sets = { "A", "B", "C" }

local function parens( t, op, expr )
   local res
   if t == op or t == '' or t == 'c' then
      res = expr
   else 
      res = '( ' .. expr .. ' )'
   end
   return res
end 


function Venn:__add( vn )
   local res = {}
   local ts, to = self.top, vn.top
   local this = self
   function res:__tostring()
      local left = parens( ts, 'u', this:__tostring() )
      local right = parens( to, 'u', vn:__tostring() )
      return  left .. [[ u ]] .. right
   end 
   function res:tolatex()
      local left = parens( ts, 'u', this:tolatex() )
      local right = parens( to, 'u', vn:tolatex() )
      return  left .. [[\cup ]] .. right
   end 
   function res:tomaximaregion()
      return '( ' .. this:tomaximaregion() .. ' )' .. [[ or ]] .. '( ' .. vn:tomaximaregion() .. ' )'
   end 
   res.top = 'u'
   return setmetatable( res, Venn )
end 

function Venn:__unm(  )
   local res = {}
   local this = self
   function res:__tostring()
      return parens( this.top, '', this:__tostring() ) .. [[']]
   end 
   function res:tolatex()
      return parens( this.top, '', this:tolatex() ) .. [[']]
   end 
   function res:tomaximaregion()
      return ' not ( ' .. this:tomaximaregion() .. ' )' 
   end 
   res.top = 'c'
   return setmetatable( res, Venn )
end 


function Venn:__mul( vn )
   local res = {}
   local ts, to = self.top, vn.top
   local this = self
   function res:__tostring()
      local left = parens( ts, 'n', this:__tostring() )
      local right = parens( to, 'n', vn:__tostring() )
      return  left .. [[ n ]] .. right
   end 
   function res:tolatex()
      local left = parens( ts, 'n', this:tolatex() )
      local right = parens( to, 'n', vn:tolatex() )
      return  left .. [[\cap ]] .. right
   end 
   function res:tomaximaregion()
      return '( ' .. this:tomaximaregion() .. ' )' .. [[ and ]] .. '( ' .. vn:tomaximaregion() .. ' )'
   end 
   res.top = 'n'
   return setmetatable( res, Venn )
end 

function Venn:filename()
   return self.dir .. self.name
end 


function Venn:initMaxima()
   local m = self.max
   m:exec( [[ load("draw") ]] )
   m:exec( [[ circle(c,r):=ellipse(c[1],c[2],r,r,0,360) ]] )
   m:exec( [[ lbl(txt,c):=label([txt,c[1],c[2] ]) ]] )
   m:exec( [[ r:2.2 ]] )
   m:exec( [[ rco:.6 ]] )
   m:exec( [[ clb: 3 ]] )
   m:exec( [[ vxs:60 ]] )
   m:exec( [[ rect:[ [-4,-4.5],[4,4] ] ]] )
   m:exec( [[ c1c:[-sqrt(3)*r/2*rco,r/2*rco] ]] )
   m:exec( [[ c2c:[sqrt(3)*r/2*rco,r/2*rco] ]] )
   m:exec( [[ c3c:[0,-r*rco] ]] )
   m:exec( [[ c1(x,y):=(x-c1c[1])^2+(y-c1c[2])^2  ]] )
   m:exec( [[ c2(x,y):=(x-c2c[1])^2+(y-c2c[2])^2  ]] )
   m:exec( [[ c3(x,y):=(x-c3c[1])^2+(y-c3c[2])^2  ]] )
   m:exec( [[ drawVenn(atxt,btxt,ctxt,setexpr):=draw2d(
fill_color = "gray",
x_voxel = vxs, y_voxel = vxs,
region(setexpr,x,rect[1][1],rect[2][1],y,rect[1][2],rect[2][2]),
xrange = [-6,6],
yrange = [-6,6], 
axis_top = false,axis_bottom = false,
axis_left = false,axis_right = false,
xtics = false,ytics = false,
transparent = true, 
rectangle(rect[1],rect[2]),
circle(c1c,r),circle(c2c,r),circle(c3c,r),
color = black,font="jsMath-cmmi",font_size=72,
lbl(atxt,clb*c1c),lbl(btxt,clb*c2c),lbl(ctxt,clb*c3c)) ]] )
   sleep(2)
end

function Venn:maxGraph( vn )
   local m = self.max
   m:exec( 'drawVenn', 
	   m.quote(self.sets[1]), 
	   m.quote(self.sets[2]), 
	   m.quote(self.sets[3]), 
	   vn:tomaximaregion() )
   sleep(1)
end 
   
function Venn:saveGraph()
   self.max:saveGraph( self )
end 

function Venn:tolatexpic()
   self.max:tolatexpic( self )

function Venn:newSimple( n )
   local res = {}
   function res:__tostring()
      return Venn.sets[ n ]
   end 
   function res:tolatex()
      return Venn.sets[ n ]
   end 
   function res:tomaximaregion()
      return 'c' .. n .. '(x,y)<r^2'
   end 
   res.top = ''
   return setmetatable( res, Venn )
end 

-- function Venn:new( code )
--    local res = {}
   
--    return setmetatable( res, Venn )
-- end



return Venn
