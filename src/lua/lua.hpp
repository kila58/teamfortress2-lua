#pragma once

#include <Windows.h>
#include <process.h>

#define LUA_USE_ASSERT //TURN OFF AND SWAP LIB FOR RELEASE
#include <luajit/include/lua.hpp>

class Lua
{
private:
	lua_State* state;

public:
	void Init(HMODULE module);
};