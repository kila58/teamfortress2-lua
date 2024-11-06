#include "lua/lua.hpp"

#pragma warning(disable : 4244)

void Init(HMODULE module)
{
	Lua lua;
	lua.Init(module);
}

DWORD WINAPI DllMain(HMODULE module, DWORD reason, LPVOID reserved)
{
	if (reason == DLL_PROCESS_ATTACH)
	{
		//DisableThreadLibraryCalls(module);
		//CloseHandle((HANDLE)_beginthreadex(0, 0, (_beginthreadex_proc_type)Init, (LPVOID)module, 0, 0));

		Init(module);

		return 1;
	}

	return 1;
}