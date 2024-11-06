#pragma once

#define lua_pushglobaltable(L) lua_pushvalue(L, LUA_GLOBALSINDEX)

class Color
{
public:
	unsigned char r, g, b, a;

	Color(int _r, int _g, int _b, int _a = 255) { r = _r, g = _g, b = _b, a = _a; }
};

__declspec(dllimport) void __cdecl ConColorMsg(const Color&, const char*, ...);

inline const char* tostring(lua_State* L, int stk)
{
	lua_pushvalue(L, stk);
	lua_pushglobaltable(L);

	lua_getfield(L, -1, "tostring");
	lua_pushvalue(L, -3);

	lua_call(L, 1, 1);

	const char* ret = lua_tostring(L, -1);

	lua_pop(L, 3);

	return ret;
}

inline int L_GetAsyncKeyState(lua_State* L)
{
	if (lua_type(L, 1) == LUA_TNUMBER)
		lua_pushinteger(L, GetAsyncKeyState(lua_tonumber(L, 1)));
	else
		lua_pushinteger(L, GetAsyncKeyState(*lua_tostring(L, 1)));

	return 1;
}

inline int L_print(lua_State* L)
{
	for (int i = 1; i <= lua_gettop(L); i++)
		ConColorMsg(Color(255, 165, 0, 255), "%s\t", tostring(L, i));

	ConColorMsg(Color(255, 165, 0, 255), "\n");

	return 0;
}

inline int L_include(lua_State* L)
{
	return RunLuaFile(L, lua_tostring(L, 1), true);
}