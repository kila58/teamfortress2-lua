#include "lua.hpp"

int L_pcallerrenhance(lua_State* L)
{
	luaL_traceback(L, L, lua_tostring(L, -1), 2);

	return 1;
}

long ReadLuaFile(const char* relpath, char** output)
{
	char temp[MAX_PATH + 1];
	sprintf_s(temp, "%s%s", "C:\\aim-flex\\lua\\", relpath);

	FILE* file;
	errno_t code;
	if ((code = fopen_s(&file, temp, "rb")) != 0)
		return 0;

	fseek(file, 0, SEEK_END);
	long length = ftell(file);
	fseek(file, 0, SEEK_SET);

	*output = new char[length];

	fread(*output, 1, length, file);

	fclose(file);

	return length;
}

int LoadBuffer(lua_State* state, const char* contents, int content_length, const char* name)
{
	return luaL_loadbuffer(state, contents, content_length, name);
}

int RunLuaFile(lua_State* state, const char* relpath, bool safe)
{
	int top;
	char* contents;
	long length;
	int code;

	top = lua_gettop(state);

	if ((length = ReadLuaFile(relpath, &contents)) != 0)
	{
		code = LoadBuffer(state, contents, length, relpath);
		delete[] contents;
		if (code == 0)
		{
			if (safe)
			{
				int r = lua_pcall(state, 0, 0, 0);
				return r != 0 ? -1 : 0;
			}
			else
				lua_call(state, 0, LUA_MULTRET);

			return lua_gettop(state) - top;
		}

		lua_error(state);

		return -1;
	}

	return -1;
}

#include "binding/global.hpp"
#include "binding/memory.hpp"

luaL_Reg GlobalLibrary[] = {
	{ "print", L_print },
	{ "include", L_include },
	{ "GetAsyncKeyState", L_GetAsyncKeyState },
	{ 0, 0 }
};

luaL_Reg MemoryLibrary[] = {
	{ "SigScan", L_SigScan },
	{ 0, 0 }
};

void Lua::Init(HMODULE module)
{
	state = luaL_newstate();
	if (!state)
	{
		ConColorMsg(Color(255, 45, 0, 255), "[lua-flex] Failed to create Lua state!");
		return;
	}

	lua_pushcfunction(state, &L_pcallerrenhance);

	luaL_openlibs(state);

	lua_pushglobaltable(state);
	{
		luaL_setfuncs(state, GlobalLibrary, 0); //globals

		lua_newtable(state);
		{
			luaL_setfuncs(state, MemoryLibrary, 0);
		}
		lua_setfield(state, -2, "memory");
	}
	lua_pop(state, 1);

	ConColorMsg(Color(255, 255, 0, 255), "[lua-flex] Loading...\n");

	if (RunLuaFile(state, "init.lua", true) != 0)
	{
		ConColorMsg(Color(255, 255, 0, 255), lua_tostring(state, -1));
		lua_pop(state, 1);
	}
}