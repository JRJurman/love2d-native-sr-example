local sral_lib
local sral_initialized = false
local ffi

ffi = require("ffi")

local os_name = love.system.getOS()
local base = love.filesystem.getSourceBaseDirectory()
local libname = ({
		["OS X"]  = base .. "/lib/libSRAL.dylib",
		Windows   = base .. "\\lib\\SRAL.dll",
		Linux     = base .. "/lib/libSRAL.so",
})[os_name]
sral_lib = ffi.load(libname or "SRAL")

ffi.cdef[[
	bool SRAL_Initialize(int engines_exclude);
	void SRAL_Uninitialize(void);
	bool SRAL_Speak(const char* text, bool interrupt);
	bool SRAL_StopSpeech(void);
	bool SRAL_IsSpeaking(void);
	const char* SRAL_GetEngineName(int engine);
	int SRAL_GetCurrentEngine(void);
]]

local ok, err = pcall(function()
	sral_lib = ffi.load("SRAL")
end)

if not ok then
	-- fallback: use ffi.C for iOS where SRAL is statically linked
	ok, err = pcall(function()
		local _ = ffi.C.SRAL_Initialize
		sral_lib = ffi.C
	end)
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
