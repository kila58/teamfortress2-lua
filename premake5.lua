-- premake5.lua
workspace "teamfortress2"
   location "project"
   configurations { "Release" }

project "teamfortress2"
   location "project"
   kind "SharedLib"
   language "C++"
   architecture "x86"
   targetdir "bin/"
   systemversion "10.0"
   characterset "MBCS"
   cppdialect "C++20"
   rtti "Off"
      
   files { "src/**.hpp", "src/**.cpp" }

   includedirs { "3rd_party/", "$(DXSDK_DIR)Include" }
   libdirs { "3rd_party/", "$(DXSDK_DIR)Lib/x86" }

   -- lua
   links { "3rd_party/luajit/lib/lua51" }

      -- soruce console
   links { "3rd_party/tier0/lib/tier0" }

   filter "configurations:Release"
      optimize "On"
