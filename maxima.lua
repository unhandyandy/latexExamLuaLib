

local maxima = {}
maxima.__index = maxima

function maxima:exec( cmd, ... )
   local args = {...}
   local argstr
   if #args > 0 then
      argstr = table.concat( args, ', ' )
      self.stream:write( cmd..'( '..argstr..' );\n' )
   else 
      self.stream:write( cmd..';\n' )
   end 
end

function maxima:close()
   self.stream:close()
end

function maxima.quote( str )
   return [["]] .. str .. [["]]
end 


function maxima.new()
   local res = {}
   --print( '\n popen = ' .. io.popen .. '\n' )
   res.stream = io.popen( 'maxima', 'w' )
   sleep( 1 )
   --print( '\n res.stream = ' .. res.stream .. '\n' )
   res.stream:setvbuf("line")
   return setmetatable( res, maxima )
end


function maxima:saveGraph( obj, t )
   --print( "\n saving \n" )
   t = t or 0.5
   obj:maxGraph( )
   local file = [["]] .. obj:filename() .. [["]]
   self:exec( 'draw_file', 'terminal = png', 
	   'file_name = ' .. file )
   sleep( t )
end 

function maxima:tolatexpic( obj, t )
   t = t or 0.5
   local frm = [[\includegraphics[scale=%s]{%s}]]
   local file = obj:filename() .. '.png'
   local scale = obj.scale
   return frm:format( scale, file )
end 


return maxima
