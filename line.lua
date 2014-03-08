
frc = require('fraction')
one = frc.one()

local Line = {}
Line.__index = Line

Line.dir = '/home/dabrowsa/math/maxima/plots/'
Line.name = 'line'
Line.extent = { -1, -1, 6, 6 }
Line.scale = 0.3

function Line:__eq( l )
   return self.A * l.B == l.A * self.B and
          self.C * l.B == l.C * self.B and
          self.A * l.C == l.A * self.C
end

function Line.isline( l )
   return getmetatable( l ) == Line
end 

function Line:contains( p )
   return self.A * p[1] + self.B * p[2] == self.C
end 


function Line:slope()
   if self.B == 0 then
      return nil
   elseif self.A == 0 then
      return 0
   else 
      return - one * self.A / self.B
   end 
end
   
function Line:intersection( l )
   if self == l then
      return self
   elseif self:slope() == l:slope() then
      return nil
   elseif self:slope() == 0 then
      local y = one * self.C / self.B
      local x = one * ( l.C - l.B * y ) / l.A
      return { x, y }
   elseif l:slope() == 0 then
      return l:intersection( self )
   else 
      local hrz = Line.new( 0,
			    one * l.A * self.B - self.A * l.B,
			    one * l.A * self.C - self.A * l.C )
      --print( 'hrz: ' .. hrz:__tostring() )
      return hrz:intersection( l )
   end 
end 

function Line:perp( pt )
   return Line.new( self.B, -self.A, pt[1] * self.B - pt[2] * self.A )
end


function Line:__tostring()
   local frm = '%sx + %sy = %s'
   frm = frm:format( self.A, self.B, self.C )
   return polyToStr( frm )
end 

function Line:tolatex()
   return self:__tostring()
end 

function Line:tomaxima()
   local frm = '%s*x + %s*y + %s'
   return frm:format( self.A, self.B, - self.C )
end 

function Line:tomaximplicit( )
   x1, y1, x2, y2 = table.unpack( self.extent )
   local frm = 'implicit( %s, x, %s, %s, y, %s, %s )'
   return frm:format( self:tomaxima(),
		      x1,x2,y1,y2 )
end 

   

function Line:initMaxima( m )
   m = m or self.max
   m:exec( 'load', [["draw"]] )
   m:exec( 'load', [["stringproc"]] )
   m:exec( [[ set_draw_defaults(axis_bottom = false,axis_top = false,axis_left = false,axis_right = false,xtics_axis = true, ytics_axis = true,fill_color = green,xaxis = true, xaxis_type = solid, xaxis_color = blue,yaxis = true,   yaxis_type = solid, yaxis_color = blue,point_size=.5,point_type = 7,color = black, x_voxel = 60, y_voxel = 60) ]] )
   sleep( 2.0 )
end 

function Line:maxGraph( m )
   m = m or self.max
   str = self:tomaxima()
   m:exec( 'draw2d', self:tomaximplicit() )
end 

function Line:filename()
   return self.dir .. self.name
end 

function Line:saveGraph( m )
   --print( "\n saving \n" )
   m = m or self.max
   self:maxGraph( m )
   local file = [["]] .. self:filename() .. [["]]
   m:exec( 'draw_file', 'terminal = png', 
	   'file_name = ' .. file )
   sleep( 0.5 )
end 

function Line:cleanup()
   io.popen( 'rm ' ..  self:filename() .. '*' )
end 

function Line:setDir( dir )
   self.dir = dir 
end 

function Line:tolatexpic()
   local frm = [[\includegraphics[scale=%s]{%s}]]
   local file = self:filename() .. '.png'
   local scale = self.scale
   return frm:format( scale, file )
end 


function Line:tofunction()
   return function( x, y )
      return self.A * x + self.B * y - self.C
   end 
end 

function Line.lineFromFunc( f )
   local c = f( 0, 0 )
   local a = f( 1, 0 ) - c
   local b = f( 0, 1 ) - c
   return Line.new( a, b, - c )
end 

function Line.random( max )
   local a,b,c = table.unpack( vec.random( 3, max ) )
   return Line.new( a,b,c )
end

function Line:clone()
   return Line.new( self.A, self.B, self.C )
end

function Line.newFromPoints( p1, p2 )
   local a, b = p2[2] - p1[2], p1[1] - p2[1]
   local c = a * p1[1] + b * p1[2]
   return Line.new( a, b, c )
end 

function Line.newPtSlope( p, m )
   local x, y = p[1], p[2]
   local a, b
   if frc.isfraction( m ) then
      a, b = m.numer, m.denom
   else 
      a, b = -m, 1
   end 
   local c = a * x + b * y
   return Line.new( a, b, c )
end 



function Line.new( a, b, c )
   local res = {}
   res.A, res.B, res.C = a, b, c
   return setmetatable( res, Line )
end

local Halfplane = {}
Halfplane.__index = Halfplane

function Halfplane:__eq( hp )
   local sgntst = self.line.A * hp.line.A + self.line.B * hp.line.B
   return self.line == hp.line and self.sign * hp.sign * sgntst > 0
end

function Halfplane.ishalfplane( h )
   return getmetatable( h ) == Halfplane
end 

function Halfplane:contains( p )
   --print( '\n p[1]: ' .. type( p[1] ) .. '\n' )
   return self.sign * ( self.line.A * p[1] + 
			   self.line.B * p[2] - self.line.C ) >= 0
end 

function Halfplane:ineq()
   if self.sign > 0 then
      return '>'
   else 
      return '<'
   end
end 

function Halfplane:cons1( hp )
   local p = self.line:intersection( hp.line )
   if p then
      return true
   else 
      local perp = self.line:perp({0,0})
      local q1, q2 = self.line:intersection( perp ), hp.line:intersection( perp )
      return self:contains( q2 ) or hp:contains( q1 )
   end 
end 

function Halfplane.cons3( h1, h2, h3 )
   local p3 = h1.line:intersection( h2.line )
   local p2 = h1.line:intersection( h3.line )
   local p1 = h2.line:intersection( h3.line )
   if Line.isline( p1 ) then
      return h2:cons1( h1 )
   elseif Line.isline( p2 ) then
      return h3:cons1( h2 )
   elseif Line.isline( p3 ) then
      return h1:cons1( h3 )
   end 
   local function allin( p )
      return h1:contains( p ) and h2:contains( p ) and h3:contains( p )
   end 
   if p1 and p2 and p3 then
      return allin( p1 ) or allin( p2 ) or allin( p3 )
   else 
      return h1:cons1( h2 ) and h2:cons1( h3 ) and h3:cons1( h1 )
   end 
end

function Halfplane:__tostring()
   local frm = self.line:__tostring()
   return frm:gsub( '=', self:ineq() .. '=' )
end 

function Halfplane:tomaxima()
   local frm = '%s * x + %s * y %s %s'
   return frm:format( self.line.A, self.line.B, 
		      self:ineq(), self.line.C )
end 

function Halfplane:tolatex()
   local str = self:__tostring()
   str = str:gsub( '>=', [[\geq]] )
   str = str:gsub( '<=', [[\leq]] )
   return str 
end 

function Halfplane.tomaximaregion( ... )
   local hps = {...}
   ext = hps[1].line.extent
   hps = map( hps, function(x) return x:tomaxima() end )
   local str = table.concat( hps, ' and ' ) --.. [[ or x^2+y^2<.007 ]]
   local frm = [[ region( %s, x, %s, %s, y, %s, %s ) ]]
   local x1, y1, x2, y2 = table.unpack( ext )
   return frm:format( str, x1, x2, y1, y2 )
end 

function Halfplane.maxGraph( ... )
   local regstr = Halfplane.tomaximaregion(...)
   local hps = {...}
   local max = hps[1].line.max
   hps = map( hps, function(x) return x.line:tomaximplicit() end )
   max:exec( 'draw2d', regstr, table.unpack( hps ) )
end 


function Halfplane.filename(...)
   local hps = {...}
   local dir = hps[1].line.dir
   hps = map( hps, function(x) return x.line.name end )
   local name = table.concat( hps, '*' )
   return dir .. name
end 

function Halfplane.saveGraph( ... )
   local hps = {...}
   m = hps[1].line.max
   Halfplane.maxGraph( ... )
   local file = [["]] .. Halfplane.filename(...) .. [["]]
   m:exec( 'draw_file', 'terminal = png', 
	   'file_name = ' .. file )
   sleep( 3 )
end 


function Halfplane.tolatexpic(...)
   local hps = {...}
   local frm = [[\includegraphics[scale=%s]{%s}]]
   local file = Halfplane.filename(...) .. '.png'
   local scale = hps[1].line.scale
   return frm:format( scale, file )
end 

function Halfplane.random( max )
   local l = Line.random( max )
   local s = randSign()
   return Halfplane.new( l, s )
end

function Halfplane:clone()
   return Halfplane.new( self.line:clone(), self.sign )
end

function Halfplane.new( l, s )
   local res = {}
   res.line = l
   res.sign = s
   return setmetatable( res, Halfplane )
end 

return function() return Line, Halfplane end 

