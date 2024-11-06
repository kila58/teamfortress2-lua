include "hook/hook.lua";

include "extensions/enums.lua";
include "extensions/timer.lua";
include "extensions/color.lua";
include "extensions/vector.lua";
include "extensions/interface.lua";

--sdk
include "sdk/IEngineClient.lua";

include "api/loader.lua"

hook.Call("Initialize") --called after everything is loaded so you can setup things

print"[lua-flex] loaded!"