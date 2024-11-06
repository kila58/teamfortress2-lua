-- util.lau

local this = {
	[ "name" ] = "util",
	[ "functions" ] = {},
	[ "hooks" ] = {
		[ "Paint" ] = {}
	}
}

function this.functions.Clamp( val, min, max )
	if ( val < min ) then
		val = min
	elseif ( val > max ) then
		val = max
	end
	
	return val
end

function this.functions.HSVtoRGB( hue, saturation, value )
end

function this.functions.CursorInBox( x, y, w, h )
	x = ( dx and dx + x ) or x
	y = ( dy and dy + y ) or y
	
	if ( mx >= x ) and ( mx <= x + w ) and ( my >= y ) and ( my <= y + h ) then
		return true
	end
	
	return false
end

function this.functions.ReadFile( f )
    local f = io.open( f, "rb" )
	
	if not ( f ) then
		return false
	end
	
    local txt = f:read( "*all" )
	f:close()
	
    return txt
end

function this.functions.WriteFile( f, txt )
	local f = io.open( f, "wb" )
	
	if not ( f ) then
		return false
	end
	
	f:write( txt )
	f:close()
	
	return true
end

function this.functions.Explode( str, typ )
	local tab = {}
	
	for v in string.gmatch( str, "([^" .. typ .. "]+)" ) do
		tab[ #tab + 1 ] = v
	end
	
	return tab
end

function this.functions.FindIndexByValue( tab, str, idx )
	for k, v in next, tab do
		if ( v[ idx ] == str ) then
			return k
		end
	end
end

function this.functions.GetKeyFromValue( tab, val )
	for k, v in next, tab do
		if ( val == v ) then
			return k
		end
	end
end

local function NormalizeAxis( a )
	return ( a + 180 ) % 360 - 180
end

this.functions[ "NormalizeAxis" ] = NormalizeAxis

function this.functions.AxisDifference( a, b )
	local diff = NormalizeAxis( a - b )
	
	if ( diff < 180 ) then
		return diff
	end
	
	return diff - 360
end

features[ #features + 1 ] = { this[ "name" ], this }