local ffi = require("ffi")
local kernel32 = ffi.load("kernel32")

ffi.cdef[[
typedef void* (*CreateInterface)(const char* name, int* return_code);

void* GetProcAddress(void* module, const char* proc_name);
void* GetModuleHandleA(const char* module_name); ]]

function GetInterface(module, interface_ver)
	local CreateInterface = ffi.cast("CreateInterface", ffi.C.GetProcAddress(kernel32.GetModuleHandleA(module), "CreateInterface"))
	return CreateInterface(interface_ver, nil)
end

function GetVirtual(ptr, index)
	local ptr = ffi.cast("void***", ptr)
	local vtable = ptr[0]

	return vtable[index]
end