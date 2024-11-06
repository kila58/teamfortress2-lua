local ffi = require("ffi")

local this = {
	[ "name" ] = "interfaces",
	[ "functions" ] = {},
	[ "hooks" ] = {
		[ "Paint" ] = {}
	}
}

print("[lua-flex] Intializing interfaces...")

engineclient = GetInterface("engine.dll", "VEngineClient014")
if (engineclient) then
	engineclient = IEngineClient(engineclient)

	engineclient:ClientCmd("echo 'suh'")

	local test = engineclient:GetPlayerInfo(engineclient:GetLocalPlayer())
	if (test) then
		print(ffi.string(test.name))
	end

	print(memory.SigScan("A1 ? ? ? ? 8B 11 68", "engine.dll"))

	--local w, h = engineclient:GetScreenSize()
	--print(w, h)
else
	print("Failed to capture interface EngineClient.")
end

print("Vector:")
print(Vector(1, 2, 3))

print("Color:")
print(Color(255, 255, 255, 255))

features[ #features + 1 ] = { this[ "name" ], this }