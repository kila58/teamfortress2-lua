-- todo: remove globals from antiaim.lau and rage.lau
--       cleanup subtraction math in menu (in functions and overall)
--       make sure SetFont isn't being called in loops when unnecessary
--       remove 1st argument from settings

features = {}

include( "modules/util.lua" )
include( "modules/interfaces.lua" )

local function HandleHooks( tab )
	for k, v in pairs( tab ) do
		for l, b in pairs( v ) do
			hook.Add( k, tostring( l ), b )
		end
	end
end

local function HandleFunctions( name, tab )
	if not ( _G[ name ] ) then
		_G[ name ] = {}
	end
	
	for k, v in pairs( tab ) do
		_G[ name ][ k ] = v
	end
end

local post = {}

local function HandlePostFunctions( func )
	post[ #post + 1 ] = func
end

local function HandleModule( name, tab )
	local count = 0
	
	for l, b in pairs( tab ) do
		count = count + 1
		
		if ( l == "hooks" ) then
			HandleHooks( b )
		end
		
		if ( l == "functions" ) then
			HandleFunctions( name, b )
		end
		
		if ( l == "post" ) then
			HandlePostFunctions( b )
		end
	end
	
	if ( count > 1 ) then
		print( '[lua-flex] Module "' .. name .. '" loaded (' .. count .. ' indices)' )
	else
		print( '[lua-flex] Module "' .. name .. '" loaded (' .. count .. ' index)' )
	end
end

local modcount = 0

for k, v in pairs( features ) do
	modcount = modcount + 1
	
	HandleModule( v[ 1 ], v[ 2 ] )
end

for k, v in pairs( post ) do
	v()
end

print( "[lua-flex] All modules loaded successfully, total modules loaded: " .. modcount )