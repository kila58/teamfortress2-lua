#pragma once

#include <Psapi.h>
#include <winternl.h>

#include <string>

typedef unsigned __int32	ptr;
typedef unsigned int		uint;
typedef unsigned char		uchar;
typedef unsigned long		ulong;

static std::string HexToBytes(std::string hex)
{
	std::string bytes;

	hex.erase(std::remove_if(hex.begin(), hex.end(), isspace), hex.end());

	for (uint i = 0; i < hex.length(); i += 2)
	{
		if ((uchar)hex[i] == '?')
		{
			bytes += '?';
			i -= 1;

			continue;
		}

		uchar byte = (uchar)std::strtol(hex.substr(i, 2).c_str(), nullptr, 16);
		bytes += byte;
	}

	return bytes;
}

static ptr SigScan(const char* pattern, const char* module)
{
	HMODULE mod = GetModuleHandleA(module);
	MODULEINFO info;
	GetModuleInformation(GetCurrentProcess(), mod, &info, sizeof(info));

	uchar* base = (uchar*)mod;

	std::string signature = HexToBytes(pattern);

	uchar first = (uchar)signature.at(0);
	uchar* end = (base + info.SizeOfImage) - signature.length();

	for (; base < end; ++base)
	{
		if (*base != first)
			continue;

		uchar* bytes = base;
		uchar* sig = (uchar*)signature.c_str();

		for (; *sig; ++sig, ++bytes)
		{
			if (*sig == '?')
				continue;

			if (*bytes != *sig)
				goto end;
		}

		return (ptr)base;

	end:;
	}

	return NULL;
}

inline int L_SigScan(lua_State* L)
{
	if (lua_type(L, 1) == LUA_TSTRING && lua_type(L, 2) == LUA_TSTRING)
		lua_pushstring(L, std::to_string(SigScan(lua_tostring(L, 1), lua_tostring(L, 2))).c_str()); //return string because 5.1 doesnt support unsigned and userdata requires a ptr
	else
		lua_pushnil(L);

	return 1;
}