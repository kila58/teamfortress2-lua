local ffi = require('ffi')

Color = {
	__call = function(_, r, g, b, a)
		return setmetatable({ r = r or 255, g = g or 255, b = b or 255, a = a or 255 }, Color)
	end,

	__tostring = function(c)
		return string.format('(%f, %f, %f, %f)', c.r, c.g, c.b, c.a)
	end
}

ffi.cdef [[ typedef struct { unsigned char r, g, b, a; } Color; ]]
Color = ffi.metatype("Color", Color)