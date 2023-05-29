const sdl = @import("sdl.zig");

const Mix_SDL_MIXER_MAJOR_VERSION : c_int = 2;
const Mix_SDL_MIXER_MINOR_VERSION : c_int = 7;
const Mix_SDL_MIXER_PATCHLEVEL    : c_int = 0;


pub const Mix_InitFlags_MIX_INIT_FLAC   = 0x00000001;
pub const Mix_InitFlags_MIX_INIT_MOD    = 0x00000002;
pub const Mix_InitFlags_MIX_INIT_MP3    = 0x00000008;
pub const Mix_InitFlags_MIX_INIT_OGG    = 0x00000010;
pub const Mix_InitFlags_MIX_INIT_MID    = 0x00000020;
pub const Mix_InitFlags_MIX_INIT_OPUS   = 0x00000040;
pub const Mix_InitFlags_MIX_INIT_WAVPACK= 0x00000080;

pub extern fn Mix_SDL_MIXER_VERSION_ATLEAST(X: c_int, Y: c_int, Z: c_int) bool;
pub const Mix_Fading_MIX_NO_FADING  = 0;
pub const Mix_Fading_MIX_FADING_OUT = 1;
pub const Mix_Fading_MIX_FADING_IN  = 2;

pub const Mix_MusicType_MUS_NONE           = 0;
pub const Mix_MusicType_MUS_CMD            = 1;
pub const Mix_MusicType_MUS_WAV            = 2;
pub const Mix_MusicType_MUS_MOD            = 3;
pub const Mix_MusicType_MUS_MID            = 4;
pub const Mix_MusicType_MUS_OGG            = 5;
pub const Mix_MusicType_MUS_MP3            = 6;
pub const Mix_MusicType_MUS_MP3_MAD_UNUSED = 7;
pub const Mix_MusicType_MUS_FLAC           = 8;
pub const Mix_MusicType_MUS_MODPLUG_UNUSED = 9;
pub const Mix_MusicType_MUS_OPUS           = 10;
pub const Mix_MusicType_MUS_WAVPACK        = 11;
pub const Mix_MusicType_MUS_GME            = 12;


pub const Mix_MusicInterface = extern struct
{
    tag: [*c]const u8,
    api: c_int,
    type: c_int,
    loaded: sdl.SDL_bool,
    opened: sdl.SDL_bool,
};
pub const Mix_Music = extern struct {
    interface: *Mix_MusicInterface,
    context: *void,

    playing: sdl.SDL_bool,
    fading: c_int,
    fade_step: c_int,
    fade_steps: c_int,

    filename: [1024]u8,
};
// pub extern fn Mix_Linked_version(void) [*c]SDL_version;

pub extern fn Mix_Init(flags: c_int) c_int;
pub extern fn Mix_Quit(void) void;

pub extern fn Mix_OpenAudio(frequency: c_int, format: u16, channels: c_int, chunksize: c_int) c_int;
pub extern fn Mix_CloseAudio() void;
pub extern fn Mix_PauseAudio(pause_on: c_int) void;

pub extern fn Mix_LoadMUS(file: [*c]const u8) ?*Mix_Music;
pub extern fn Mix_LoadWAV(file: [*c]const u8) ?*Mix_Music;


pub extern fn Mix_Linked_Version() [*c]const sdl.SDL_version;
const struct_Mix_Chunk = extern struct {
    allocated: c_int,
    abuf: [*c]const u8,
    alen: u32,
    volume: u8,
};
pub const Mix_Chunk = struct_Mix_Chunk;
pub const Mix_Fading = c_uint;
pub const Mix_MusicType = c_uint;
pub extern fn Mix_OpenAudioDevice(frequency: c_int, format: u16, channels: c_int, chunksize: c_int, device: [*c]const u8, allowed_changes: c_int) c_int;
pub extern fn Mix_AllocateChannels(numchans: c_int) c_int;
pub extern fn Mix_QuerySpec(frequency: [*c]c_int, format: [*c]u16, channels: [*c]c_int) c_int;
pub extern fn Mix_LoadWAV_RW(src: [*c]sdl.SDL_RWops, freesrc: c_int) [*c]Mix_Chunk;
pub extern fn Mix_LoadMUS_RW(src: [*c]sdl.SDL_RWops, freesrc: c_int) ?*Mix_Music;
pub extern fn Mix_LoadMUSType_RW(src: [*c]sdl.SDL_RWops, @"type": Mix_MusicType, freesrc: c_int) ?*Mix_Music;
pub extern fn Mix_QuickLoad_WAV(mem: [*c]u8) [*c]Mix_Chunk;
pub extern fn Mix_QuickLoad_RAW(mem: [*c]u8, len: u32) [*c]Mix_Chunk;
pub extern fn Mix_FreeChunk(chunk: [*c]Mix_Chunk) void;
pub extern fn Mix_FreeMusic(music: ?*Mix_Music) void;
pub extern fn Mix_GetNumChunkDecoders() c_int;
pub extern fn Mix_GetChunkDecoder(index: c_int) [*c]const u8;
pub extern fn Mix_HasChunkDecoder(name: [*c]const u8) sdl.SDL_bool;
pub extern fn Mix_GetNumMusicDecoders() c_int;
pub extern fn Mix_GetMusicDecoder(index: c_int) [*c]const u8;
pub extern fn Mix_HasMusicDecoder(name: [*c]const u8) sdl.SDL_bool;
pub extern fn Mix_GetMusicType(music: ?*const Mix_Music) Mix_MusicType;
pub extern fn Mix_SetPostMix(mix_func: ?*const fn (?*anyopaque, [*c]u8, c_int) callconv(.C) void, arg: ?*anyopaque) void;
pub extern fn Mix_HookMusic(mix_func: ?*const fn (?*anyopaque, [*c]u8, c_int) callconv(.C) void, arg: ?*anyopaque) void;
pub extern fn Mix_HookMusicFinished(music_finished: ?*const fn () callconv(.C) void) void;
pub extern fn Mix_GetMusicHookData() ?*anyopaque;
pub extern fn Mix_ChannelFinished(channel_finished: ?*const fn (c_int) callconv(.C) void) void;
pub const Mix_EffectFunc_t = ?*const fn (c_int, ?*anyopaque, c_int, ?*anyopaque) callconv(.C) void;
pub const Mix_EffectDone_t = ?*const fn (c_int, ?*anyopaque) callconv(.C) void;
pub extern fn Mix_RegisterEffect(chan: c_int, f: Mix_EffectFunc_t, d: Mix_EffectDone_t, arg: ?*anyopaque) c_int;
pub extern fn Mix_UnregisterEffect(channel: c_int, f: Mix_EffectFunc_t) c_int;
pub extern fn Mix_UnregisterAllEffects(channel: c_int) c_int;
pub extern fn Mix_SetPanning(channel: c_int, left: u8, right: u8) c_int;
pub extern fn Mix_SetPosition(channel: c_int, angle: i16, distance: u8) c_int;
pub extern fn Mix_SetDistance(channel: c_int, distance: u8) c_int;
pub extern fn Mix_SetReverseStereo(channel: c_int, flip: c_int) c_int;
pub extern fn Mix_ReserveChannels(num: c_int) c_int;
pub extern fn Mix_GroupChannel(which: c_int, tag: c_int) c_int;
pub extern fn Mix_GroupChannels(from: c_int, to: c_int, tag: c_int) c_int;
pub extern fn Mix_GroupAvailable(tag: c_int) c_int;
pub extern fn Mix_GroupCount(tag: c_int) c_int;
pub extern fn Mix_GroupOldest(tag: c_int) c_int;
pub extern fn Mix_GroupNewer(tag: c_int) c_int;
pub extern fn Mix_PlayChannelTimed(channel: c_int, chunk: [*c]Mix_Chunk, loops: c_int, ticks: c_int) c_int;
pub extern fn Mix_PlayMusic(music: ?*Mix_Music, loops: c_int) c_int;
pub extern fn Mix_FadeInMusic(music: ?*Mix_Music, loops: c_int, ms: c_int) c_int;
pub extern fn Mix_FadeInMusicPos(music: ?*Mix_Music, loops: c_int, ms: c_int, position: f64) c_int;
pub extern fn Mix_FadeInChannelTimed(channel: c_int, chunk: [*c]Mix_Chunk, loops: c_int, ms: c_int, ticks: c_int) c_int;
pub extern fn Mix_Volume(channel: c_int, volume: c_int) c_int;
pub extern fn Mix_VolumeChunk(chunk: [*c]Mix_Chunk, volume: c_int) c_int;
pub extern fn Mix_VolumeMusic(volume: c_int) c_int;
pub extern fn Mix_HaltChannel(channel: c_int) c_int;
pub extern fn Mix_HaltGroup(tag: c_int) c_int;
pub extern fn Mix_HaltMusic() c_int;
pub extern fn Mix_ExpireChannel(channel: c_int, ticks: c_int) c_int;
pub extern fn Mix_FadeOutChannel(which: c_int, ms: c_int) c_int;
pub extern fn Mix_FadeOutGroup(tag: c_int, ms: c_int) c_int;
pub extern fn Mix_FadeOutMusic(ms: c_int) c_int;
pub extern fn Mix_FadingMusic() Mix_Fading;
pub extern fn Mix_FadingChannel(which: c_int) Mix_Fading;
pub extern fn Mix_Pause(channel: c_int) void;
pub extern fn Mix_Resume(channel: c_int) void;
pub extern fn Mix_Paused(channel: c_int) c_int;
pub extern fn Mix_PauseMusic() void;
pub extern fn Mix_ResumeMusic() void;
pub extern fn Mix_RewindMusic() void;
pub extern fn Mix_PausedMusic() c_int;
pub extern fn Mix_SetMusicPosition(position: f64) c_int;
pub extern fn Mix_Playing(channel: c_int) c_int;
pub extern fn Mix_PlayingMusic() c_int;
pub extern fn Mix_SetMusicCMD(command: [*c]const u8) c_int;
pub extern fn Mix_SetSynchroValue(value: c_int) c_int;
pub extern fn Mix_GetSynchroValue() c_int;
pub extern fn Mix_SetSoundFonts(paths: [*c]const u8) c_int;
pub extern fn Mix_GetSoundFonts() [*c]const u8;
pub extern fn Mix_EachSoundFont(function: ?*const fn ([*c]const u8, ?*anyopaque) callconv(.C) c_int, data: ?*anyopaque) c_int;
pub extern fn Mix_GetChunk(channel: c_int) [*c]Mix_Chunk;
pub inline fn Mix_PlayChannel(channel: anytype, chunk: anytype, loops: anytype) @TypeOf(Mix_PlayChannelTimed(channel, chunk, loops, -@as(c_int, 1))) {
    return Mix_PlayChannelTimed(channel, chunk, loops, -@as(c_int, 1));
}
pub inline fn Mix_FadeInChannel(channel: anytype, chunk: anytype, loops: anytype, ms: anytype) @TypeOf(Mix_FadeInChannelTimed(channel, chunk, loops, ms, -@as(c_int, 1))) {
    return Mix_FadeInChannelTimed(channel, chunk, loops, ms, -@as(c_int, 1));
}
pub const Mix_SetError = sdl.SDL_SetError;
pub const Mix_GetError = sdl.SDL_GetError;
pub const Mix_ClearError = sdl.SDL_ClearError;
