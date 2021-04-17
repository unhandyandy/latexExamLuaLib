#!/usr/bin/lua

require('save')
require('mylib')

uppers = "ABCDEFGH"

function letToNum( ltt )
   local pos, _ = uppers:find( ltt )
   return tostring(pos)
end

local numver = #arg

--local ver = arg[1]

local basename = table.concat(arg,"-").."_answers_table"

local filename = basename..".lua"

local tab, tablet = {}, {}

for _,v in ipairs(arg) do
   local fn = v.."_answers_table.lua"
   tabload = table.load( fn )
   tab[v] = map( tabload, letToNum )
   tablet[v] = tabload
end

local i
local resstring, resstringlet = "", ""
for i=0,9 do
   local k = i % numver
   --print(i)
   resstring = resstring..tostring(i).."\t"..table.concat( tab[arg[k+1]], "\t" ).."\n"
   resstringlet = resstringlet..tostring(i)..","..table.concat( tablet[arg[k+1]], "," ).."\n"
end

--print( resstring )

local savefile = io.open( basename .. ".txt", "w" )

io.output( savefile )

io.write( resstring )

io.close( savefile )

local savefilelet = io.open( basename .. ".csv", "w" )

io.output( savefilelet )

io.write( resstringlet )

io.close( savefilelet )


