#!/bin/bash

# The input file name to the SDL2 main header
INFILE="/home/felix/projects/SDL/include/SDL.h"

# The output file name of this script.
# this should not be changed
OUTFILE="src/binding/sdl.zig"

set -e #setopt -e
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
  "${INFILE}" > "${OUTFILE}"

function patch_file()
{
  sed -i "$@" "${OUTFILE}"
}

# Remove comptime assertions
patch_file '/SDL_compile_time_assert_/d' 

# Delete all C _t types, but not SDL _t types, and also not types that go past the end of the line, because we would need to remove more than just their first line.
patch_file '/SDL_/b;/{ *$/b;/_t = /d' 

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
patch_file -r '/SDL_/b;/pub const .*(_MAX) =/d'
patch_file -r  '/SDL_/b;/pub const .*(_MIN) =/d'

# Remove all generated comments
patch_file 's|//.*||'

# Delete original wchar_t definition
patch_file '/wchar_t = /d'

# and replace it with our own semi-correct wchar_t definition
echo "const wchar_t = if(@import(\"builtin\").os.tag == .windows) u16 else u32; $(cat ${OUTFILE})" > "${OUTFILE}"

# Delete all lines that declare C attributes
patch_file '/ = __attribute__/d'
patch_file '/SDL_INLINE/d'

patch_file '/alloca = /d'
patch_file '/SDL_FUNCTION = /d'
patch_file '/SDL_FILE = /d'
patch_file '/SDL_LINE = /d'
patch_file '/SDL_COMPILEDVERSION = /d'
patch_file '/SDL_BYTEORDER = /d'

patch_file '/fn SDL_OutOfMemory/,+2d'
patch_file '/fn SDL_Unsupported/,+2d'
patch_file '/fn SDL_InvalidParamError/,+2d'
patch_file '/fn SDL_TriggerBreakpoint/,+2d'

patch_file -r 's/usize - ([0-9]+)/@bitCast(usize, @as(isize, -\1))/g'
patch_file -r 's/u(8|16|32|64) - ([0-9]+)/@bitCast(u\1, @as(i\1, -\2))/g'
patch_file -r 's/i(8|16|32|64) - ([0-9]+)/@as(i\1, -\2)/g'

# replace NULL as function call argument with null
patch_file 's/(NULL/(null/g'

# replace __builtin_bswap with @byteSwap builtin
patch_file 's/__builtin_bswap16(\([^)]*\))/@byteSwap(@TypeOf(\1), \1)/g'
patch_file 's/__builtin_bswap32(\([^)]*\))/@byteSwap(@TypeOf(\1), \1)/g'
patch_file 's/__builtin_bswap64(\([^)]*\))/@byteSwap(@TypeOf(\1), \1)/g'
patch_file 's/__builtin_bswap128(\([^)]*\))/@byteSwap(@TypeOf(\1), \1)/g'

# Verify we didn't fuck up
zig fmt "${OUTFILE}"

patch_file '/usingnamespace/d'

echo "test \"all decls\" { @import(\"std\").testing.refAllDecls(@import(\"${OUTFILE}\")); }" > test.zig

# known issues:
# - SDL_MemoryBarrierRelease and SDL_MemoryBarrierAcquire use a non-defined SDL_CompilerBarrier() function
# - the dependency loop of struct_SDL_AudioCVT.filters is a false positive (see https://github.com/ziglang/zig/issues/4476 )
zig test test.zig 2>&1 | sed '/note: /,+2d'

rm test.zig

# Print out generated LOC
wc -l "${OUTFILE}"
