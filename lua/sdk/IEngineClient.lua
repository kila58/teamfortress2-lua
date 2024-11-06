local ffi = require('ffi')

ffi.cdef[[
typedef struct { 
	char			name[32];
	int				userid;
	char			guid[32 + 1];
	unsigned int	friendsid;
	char			friendsname[32];
	bool			fakeplayer;
	bool			ishltv;
	unsigned int	customfiles[4];
	unsigned char	filesdownloaded;
} player_info_t; ]]

IEngineClient = {
	__call = function(_, ptr)
		return setmetatable({ this = ptr }, IEngineClient)
	end,

	__index = {
		GetScreenSize = function(instance)
			ffi.cdef[[ typedef void(__thiscall* GetScreenSize)(void*, int, int); ]]
			local func = ffi.cast("GetScreenSize", GetVirtual(instance.this, 5))

			local size = ffi.new("int[2]", 0, 0)
			func(instance.this, size[0], size[1])

			return size[0], size[1]
		end,

		ClientCmd = function(instance, command)
			ffi.cdef[[ typedef void (__thiscall* ClientCmd)(void*, const char*); ]]
			local func = ffi.cast("ClientCmd", GetVirtual(instance.this, 7))

			func(instance.this, command)
		end,

		GetPlayerInfo = function(instance, index)
			ffi.cdef[[ typedef bool(__thiscall* GetPlayerInfo)(void*, int, player_info_t*); ]]
			local func = ffi.cast("GetPlayerInfo", GetVirtual(instance.this, 8))

			local player_info = ffi.new("player_info_t[1]", ffi.new("player_info_t")) --needed a pointer and need the struct filled out, player_info_t[1] will not initalize
			
			if (func(instance.this, index, player_info)) then
				return player_info[0] --dereference
			end

			return nil
		end,

		GetLocalPlayer = function(instance)
			ffi.cdef[[ typedef int(__thiscall* GetLocalPlayer)(void*); ]]
			local func = ffi.cast("GetLocalPlayer", GetVirtual(instance.this, 12))

			return func(instance.this)
		end
	}
}

ffi.cdef [[ typedef struct { void* this; } IEngineClient; ]]
IEngineClient = ffi.metatype("IEngineClient", IEngineClient)