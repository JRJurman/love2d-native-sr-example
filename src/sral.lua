local sral_lib
local sral_initialized = false
local ffi

ffi = require("ffi")

ffi.cdef[[
	bool SRAL_Initialize(int engines_exclude);
	void SRAL_Uninitialize(void);
	bool SRAL_Speak(const char* text, bool interrupt);
	bool SRAL_StopSpeech(void);
	bool SRAL_IsSpeaking(void);
	const char* SRAL_GetEngineName(int engine);
	int SRAL_GetCurrentEngine(void);
]]

local os_name = love.system.getOS()
local base = love.filesystem.getSourceBaseDirectory()

-- How SRAL is linked differs per platform:
--   * Desktop ships it as a shared library next to the executable.
--   * Android loads libSRAL.so by name (already loaded via System.loadLibrary).
--   * iOS statically links it into the app binary, so symbols resolve from the
--     main program (ffi.C) rather than a separate library.
local libname = ({
	["OS X"]  = base .. "/lib/libSRAL.dylib",
	Windows   = base .. "\\lib\\SRAL.dll",
	Linux     = base .. "/lib/libSRAL.so",
	Android   = "SRAL",
})[os_name]

local ok, lib_or_err = pcall(function()
	if libname then
		return ffi.load(libname)
	end
	-- iOS: confirm the statically-linked symbol resolves, then use ffi.C.
	local _ = ffi.C.SRAL_Initialize
	return ffi.C
end)

if ok then
	sral_lib = lib_or_err
else
	print("SRAL load failed: " .. tostring(lib_or_err))
end

if sral_lib then
	local EXCLUDE_NOTHING = 0
	sral_initialized = sral_lib.SRAL_Initialize(EXCLUDE_NOTHING)
	print("SRAL engine: " .. ffi.string(sral_lib.SRAL_GetEngineName(sral_lib.SRAL_GetCurrentEngine())))
end

function speak(text)
	-- interact with screen reader
	if sral_lib and sral_initialized then
		sral_lib.SRAL_Speak(text, true)
	else
		print("SRAL NOT INITIALIZED")
	end

	print("[speak] " .. text)
end
