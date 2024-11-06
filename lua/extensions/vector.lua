local ffi = require('ffi')

Vector = {
	__call = function(_, x, y, z)
		return setmetatable({ x = x or 0, y = y or 0, z = z or 0 }, Vector)
	end,

	 __tostring = function(v)
		return string.format('(%f, %f, %f)', v.x, v.y, v.z)
	end,

	__add = function(v, u) return v:Add(u, Vector()) end,
	__sub = function(v, u) return v:Sub(u, Vector()) end,

	__mul = function(v, u)
		if Vector.IsVec3(u) then 
			return v:Mul(u, Vector())
		else if type(u) == 'number' then
			return v:Scale(u, Vector())
		else
			error('Vectors can only be multiplied by Vectors and numbers') 
		end
	end
	end,

	__div = function(v, u)
		if Vector.IsVec3(u) then
			return v:Div(u, Vector())
		elseif type(u) == 'number' then
			return v:Scale(1 / u, Vector())
		else
			error('Vectors can only be divided by Vectors and numbers')
		end
	end,

	__unm = function(v) return v:Scale(-1) end,
	__len = function(v) return v:Length() end,

	__index = {
		IsVec3 = function(x)
			return ffi.istype('Vector', x)
		end,

		Clone = function(v)
			return Vector(v.x, v.y, v.z)
		end,

		Unpack = function(v)
			return v.x, v.y, v.z
		end,

		Set = function(v, x, y, z)
			if Vector.IsVec3(x) then x, y, z = x.x, x.y, x.z end
			v.x = x
			v.y = y
			v.z = z
			return v
		end,

		Add = function(v, u, out)
			out = out or v
			out.x = v.x + u.x
			out.y = v.y + u.y
			out.z = v.z + u.z
			return out
		end,

		Sub = function(v, u, out)
			out = out or v
			out.x = v.x - u.x
			out.y = v.y - u.y
			out.z = v.z - u.z
			return out
		end,

		Mul = function(v, u, out)
			out = out or v
			out.x = v.x * u.x
			out.y = v.y * u.y
			out.z = v.z * u.z
			return out
		end,

		Div = function(v, u, out)
			out = out or v
			out.x = v.x / u.x
			out.y = v.y / u.y
			out.z = v.z / u.z
			return out
		end,

		Scale = function(v, s, out)
			out = out or v
			out.x = v.x * s
			out.y = v.y * s
			out.z = v.z * s
			return out
		end,

		Length = function(v)
			return math.sqrt(v.x * v.x + v.y * v.y + v.z * v.z)
		end,

		Normalize = function(v, out)
			out = out or v
			local len = v:Length()
			return len == 0 and v or v:Scale(1 / len, out)
		end,

		Distance = function(v, u)
			return Vector.Sub(v, u, vtmp1):Length()
		end,

		Angle = function(v, u)
			return math.acos(v:Dot(u) / (v:Length() + u:Length()))
		end,

		Dot = function(v, u)
			return v.x * u.x + v.y * u.y + v.z * u.z
		end,

		Cross = function(v, u, out)
			out = out or v
			local a, b, c = v.x, v.y, v.z
			out.x = b * u.z - c * u.y
			out.y = c * u.x - a * u.z
			out.z = a * u.y - b * u.x
			return out
		end,

		Lerp = function(v, u, t, out)
			out = out or v
			out.x = v.x + (u.x - v.x) * t
			out.y = v.y + (u.y - v.y) * t
			out.z = v.z + (u.z - v.z) * t
			return out
		end
	}
}

ffi.cdef [[ typedef struct { double x, y, z; } Vector; ]]
Vector = ffi.metatype("Vector", Vector)