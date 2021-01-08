#!/bin/bash
setopt -e
clear
zig translate-c \
  -target x86_64-linux-gnu \
  -I stubs \
  -D SDL_DISABLE_MMINTRIN_H=0 \
  -D SDL_DISABLE_XMMINTRIN_H=0 \
  -D SDL_DISABLE_EMMINTRIN_H=0 \
  -D SDL_DISABLE_PMMINTRIN_H=0 \
  -D SDL_DISABLE_IMMINTRIN_H=0 \
  -D SDL_DISABLE_MM3DNOW_H=0 \
  /home/felix/projects/SDL/include/SDL.h > sdl.zig

function patch_file()
{
  sed -i "$@" sdl.zig
}

# Remove comptime assertions
patch_file '/SDL_compile_time_assert_/d' 

# Delete all C _t types, but not SDL _t types
#patch_file '/SDL_/n;/_t = /d' 

# Remove all reserved definitions (prefixed with _)
patch_file '/pub const _/d'

# Remove min/max/print elements
patch_file '/pub const SDL_MAX_/d'
patch_file '/pub const SDL_MIN/d'
patch_file '/pub const SDL_PRI/d'

# Replace SDL types with native zig ones
patch_file 's/\bSint8\b/i8/g' 
patch_file 's/\bUint8\b/u8/g' 
patch_file 's/\bSint16\b/i16/g' 
patch_file 's/\bUint16\b/u16/g' 
patch_file 's/\bSint32\b/i32/g' 
patch_file 's/\bUint32\b/u32/g' 
patch_file 's/\bSint64\b/i64/g' 
patch_file 's/\bUint64\b/u64/g' 

# Remove identity definitions
patch_file -r '/pub const [ui](8|16|32|64) =/d' 

# Remove use of varargs stuff
# sed -i '/struct___va_list_tag =/,+5d' sdl.zig
# sed -i '/struct___va_list_tag/d' sdl.zig
patch_file '/va_list =/d' 
patch_file '/va_list =/d' 

# Remove all lines with @compileError
patch_file '/@compileError/d'

# Remove some stuff from list
for pattern in \
  "pub const unix " \
  "pub const linux " \
  "pub const NULL ="; \
do
  patch_file "/${pattern}/d"
done

# Remove these HAVE definitions
patch_file "/pub const HAVE_/d"

# Remove some min/max translations
patch_file '/SDL_/n;/pub const .*(_MAX) =/d'
patch_file '/SDL_/n;/pub const .*(_MIN) =/d'

# Remove all generated comments
patch_file 's|//.*||'

# Insert semi-correct wchar_t definition
# echo "const wchar_t = if(@import(\"builtin\").os.tag == .windows) u16 else u32; $(cat sdl.zig)" > sdl.zig


# Verify we didn't fuck up
zig fmt sdl.zig

zig test decls.zig 2> log.txt

# Print out generated LOC
wc -l sdl.zig
