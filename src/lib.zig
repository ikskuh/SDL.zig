const c = @import("c.zig");
const std = @import("std");

pub const InitFlags = struct {
    pub const everything = InitFlags{
        .video = true,
        .audio = true,
        .timer = true,
        .joystick = true,
        .haptic = true,
        .gameController = true,
        .events = true,
    };
    video: bool = false,
    audio: bool = false,
    timer: bool = false,
    joystick: bool = false,
    haptic: bool = false,
    gameController: bool = false,
    events: bool = false,
};

pub fn init(flags: InitFlags) !void {
    var cflags: c_uint = 0;
    if (flags.video) cflags |= c.SDL_INIT_VIDEO;
    if (flags.audio) cflags |= c.SDL_INIT_AUDIO;
    if (flags.timer) cflags |= c.SDL_INIT_TIMER;
    if (flags.joystick) cflags |= c.SDL_INIT_JOYSTICK;
    if (flags.haptic) cflags |= c.SDL_INIT_HAPTIC;
    if (flags.gameController) cflags |= c.SDL_INIT_GAMECONTROLLER;
    if (flags.events) cflags |= c.SDL_INIT_EVENTS;
    if (c.SDL_Init(cflags) < 0)
        return error.SdlError;
}

pub fn quit() void {
    c.SDL_Quit();
}

pub fn getError() ?[]const u8 {
    if (c.SDL_GetError()) |err| {
        return std.mem.toSliceConst(u8, err);
    } else {
        return null;
    }
}

pub const Window = struct {
    ptr: *c.SDL_Window,

    pub fn destroy(w: Window) void {
        c.SDL_DestroyWindow(w.ptr);
    }
};

pub const WindowPosition = union(enum) {
    default: void,
    centered: void,
    absolute: c_int,
};

pub const WindowFlags = struct {
    /// fullscreen window
    fullscreen: bool = false, // SDL_WINDOW_FULLSCREEN,

    /// fullscreen window at the current desktop resolution,
    fullscreenDesktop: bool = false, // SDL_WINDOW_FULLSCREEN_DESKTOP

    /// window usable with OpenGL context
    openGL: bool = false, //  SDL_WINDOW_OPENGL,

    /// window is visible,
    shown: bool = false, //  SDL_WINDOW_SHOWN,

    /// window is not visible
    hidden: bool = false, //  SDL_WINDOW_HIDDEN,

    /// no window decoration
    borderless: bool = false, // SDL_WINDOW_BORDERLESS,

    /// window can be resized
    resizable: bool = false, // SDL_WINDOW_RESIZABLE,

    /// window is minimized
    minimized: bool = false, // SDL_WINDOW_MINIMIZED,

    /// window is maximized
    maximized: bool = false, // SDL_WINDOW_MAXIMIZED,

    ///  window has grabbed input focus
    inputGrabbed: bool = false, // SDL_WINDOW_INPUT_GRABBED,

    /// window has input focus
    inputFocus: bool = false, //SDL_WINDOW_INPUT_FOCUS,

    ///  window has mouse focus
    mouseFocus: bool = false, //SDL_WINDOW_MOUSE_FOCUS,

    /// window not created by SDL
    foreign: bool = false, //SDL_WINDOW_FOREIGN,

    /// window should be created in high-DPI mode if supported (>= SDL 2.0.1)
    allowHighDPI: bool = false, //SDL_WINDOW_ALLOW_HIGHDPI,

    /// window has mouse captured (unrelated to INPUT_GRABBED, >= SDL 2.0.4)
    mouseCapture: bool = false, //SDL_WINDOW_MOUSE_CAPTURE,

    /// window should always be above others (X11 only, >= SDL 2.0.5)
    alwaysOnTop: bool = false, //SDL_WINDOW_ALWAYS_ON_TOP,

    /// window should not be added to the taskbar (X11 only, >= SDL 2.0.5)
    skipTaskbar: bool = false, //SDL_WINDOW_SKIP_TASKBAR,

    /// window should be treated as a utility window (X11 only, >= SDL 2.0.5)
    utility: bool = false, //SDL_WINDOW_UTILITY,

    /// window should be treated as a tooltip (X11 only, >= SDL 2.0.5)
    tooltip: bool = false, //SDL_WINDOW_TOOLTIP,

    /// window should be treated as a popup menu (X11 only, >= SDL 2.0.5)
    popupMenu: bool = false, //SDL_WINDOW_POPUP_MENU,

    // fn fromInteger(val: c_uint) WindowFlags {
    //     // TODO: Implement
    //     @panic("niy");
    // }

    fn toInteger(wf: WindowFlags) c_uint {
        var val: c_uint = 0;
        if (wf.fullscreen) val |= c.SDL_WINDOW_FULLSCREEN;
        if (wf.fullscreenDesktop) val |= c.SDL_WINDOW_FULLSCREEN_DESKTOP;
        if (wf.openGL) val |= c.SDL_WINDOW_OPENGL;
        if (wf.shown) val |= c.SDL_WINDOW_SHOWN;
        if (wf.hidden) val |= c.SDL_WINDOW_HIDDEN;
        if (wf.borderless) val |= c.SDL_WINDOW_BORDERLESS;
        if (wf.resizable) val |= c.SDL_WINDOW_RESIZABLE;
        if (wf.minimized) val |= c.SDL_WINDOW_MINIMIZED;
        if (wf.maximized) val |= c.SDL_WINDOW_MAXIMIZED;
        if (wf.inputGrabbed) val |= c.SDL_WINDOW_INPUT_GRABBED;
        if (wf.inputFocus) val |= c.SDL_WINDOW_INPUT_FOCUS;
        if (wf.mouseFocus) val |= c.SDL_WINDOW_MOUSE_FOCUS;
        if (wf.foreign) val |= c.SDL_WINDOW_FOREIGN;
        if (wf.allowHighDPI) val |= c.SDL_WINDOW_ALLOW_HIGHDPI;
        if (wf.mouseCapture) val |= c.SDL_WINDOW_MOUSE_CAPTURE;
        if (wf.alwaysOnTop) val |= c.SDL_WINDOW_ALWAYS_ON_TOP;
        if (wf.skipTaskbar) val |= c.SDL_WINDOW_SKIP_TASKBAR;
        if (wf.utility) val |= c.SDL_WINDOW_UTILITY;
        if (wf.tooltip) val |= c.SDL_WINDOW_TOOLTIP;
        if (wf.popupMenu) val |= c.SDL_WINDOW_POPUP_MENU;
        return val;
    }
};

pub fn createWindow(
    title: [:0]const u8,
    x: WindowPosition,
    y: WindowPosition,
    width: c_int,
    height: c_int,
    flags: WindowFlags,
) !Window {
    return Window{
        .ptr = c.SDL_CreateWindow(
            title,
            switch (x) {
                .default => c.SDL_WINDOWPOS_UNDEFINED_MASK,
                .centered => c.SDL_WINDOWPOS_CENTERED_MASK,
                .absolute => |v| v,
            },
            switch (y) {
                .default => c.SDL_WINDOWPOS_UNDEFINED_MASK,
                .centered => c.SDL_WINDOWPOS_CENTERED_MASK,
                .absolute => |v| v,
            },
            width,
            height,
            flags.toInteger(),
        ) orelse return error.SdlError,
    };
}

pub const Renderer = struct {
    ptr: *c.SDL_Renderer,

    pub fn destroy(ren: Renderer) void {
        c.SDL_DestroyRenderer(ren.ptr);
    }

    pub fn clear(ren: Renderer) !void {
        if (c.SDL_RenderClear(ren.ptr) != 0)
            return error.SdlError;
    }

    pub fn present(ren: Renderer) void {
        c.SDL_RenderPresent(ren.ptr);
    }
};

pub const RendererFlags = struct {
    software: bool = false,
    accelerated: bool = false,
    presentVSync: bool = false,
    targetTexture: bool = false,

    fn toInteger(rf: RendererFlags) c_uint {
        var val: c_uint = 0;
        if (rf.software) val |= c.SDL_RENDERER_SOFTWARE;
        if (rf.accelerated) val |= c.SDL_RENDERER_ACCELERATED;
        if (rf.presentVSync) val |= c.SDL_RENDERER_PRESENTVSYNC;
        if (rf.targetTexture) val |= c.SDL_RENDERER_TARGETTEXTURE;
        return val;
    }
};

pub fn createRenderer(window: Window, index: ?u31, flags: RendererFlags) !Renderer {
    return Renderer{
        .ptr = c.SDL_CreateRenderer(
            window.ptr,
            if (index) |idx| @intCast(c_int, idx) else -1,
            flags.toInteger(),
        ) orelse return error.SdlError,
    };
}

pub const Event = union(enum) {
    pub const CommonEvent = c.SDL_CommonEvent;
    pub const DisplayEvent = c.SDL_DisplayEvent;
    pub const WindowEvent = c.SDL_WindowEvent;
    pub const KeyboardEvent = c.SDL_KeyboardEvent;
    pub const TextEditingEvent = c.SDL_TextEditingEvent;
    pub const TextInputEvent = c.SDL_TextInputEvent;
    pub const MouseMotionEvent = c.SDL_MouseMotionEvent;
    pub const MouseButtonEvent = c.SDL_MouseButtonEvent;
    pub const MouseWheelEvent = c.SDL_MouseWheelEvent;
    pub const JoyAxisEvent = c.SDL_JoyAxisEvent;
    pub const JoyBallEvent = c.SDL_JoyBallEvent;
    pub const JoyHatEvent = c.SDL_JoyHatEvent;
    pub const JoyButtonEvent = c.SDL_JoyButtonEvent;
    pub const JoyDeviceEvent = c.SDL_JoyDeviceEvent;
    pub const ControllerAxisEvent = c.SDL_ControllerAxisEvent;
    pub const ControllerButtonEvent = c.SDL_ControllerButtonEvent;
    pub const ControllerDeviceEvent = c.SDL_ControllerDeviceEvent;
    pub const AudioDeviceEvent = c.SDL_AudioDeviceEvent;
    pub const SensorEvent = c.SDL_SensorEvent;
    pub const QuitEvent = c.SDL_QuitEvent;
    pub const UserEvent = c.SDL_UserEvent;
    pub const SysWMEvent = c.SDL_SysWMEvent;
    pub const TouchFingerEvent = c.SDL_TouchFingerEvent;
    pub const MultiGestureEvent = c.SDL_MultiGestureEvent;
    pub const DollarGestureEvent = c.SDL_DollarGestureEvent;
    pub const DropEvent = c.SDL_DropEvent;

    clipBoardUpdate: CommonEvent,
    appDidEnterBackground: CommonEvent,
    appDidEnterForeground: CommonEvent,
    appWillEnterForeground: CommonEvent,
    appWillEnterBackground: CommonEvent,
    appLowMemory: CommonEvent,
    appTerminating: CommonEvent,
    renderTargetsReset: CommonEvent,
    renderDeviceReset: CommonEvent,
    keyMapChanged: CommonEvent,
    display: DisplayEvent,
    window: WindowEvent,
    keyDown: KeyboardEvent,
    keyUp: KeyboardEvent,
    textEditing: TextEditingEvent,
    textInput: TextInputEvent,
    mouseMotion: MouseMotionEvent,
    mouseButtonDown: MouseButtonEvent,
    mouseButtonUp: MouseButtonEvent,
    mouseWheel: MouseWheelEvent,
    joyAxisMotion: JoyAxisEvent,
    joyBallMotion: JoyBallEvent,
    joyHatMotion: JoyHatEvent,
    joyButtonDown: JoyButtonEvent,
    joyButtonUp: JoyButtonEvent,
    joyDeviceAdded: JoyDeviceEvent,
    joyDeviceRemoved: JoyDeviceEvent,
    controllerAxisMotion: ControllerAxisEvent,
    controllerButtonDown: ControllerButtonEvent,
    controllerButtonUp: ControllerButtonEvent,
    controllerDeviceAdded: ControllerDeviceEvent,
    controllerDeviceRemoved: ControllerDeviceEvent,
    controllerDeviceRemapped: ControllerDeviceEvent,
    audioDeviceAdded: AudioDeviceEvent,
    audioDeviceRemoved: AudioDeviceEvent,
    sensorUpdate: SensorEvent,
    quit: QuitEvent,
    sysWM: SysWMEvent,
    fingerDown: TouchFingerEvent,
    fingerUp: TouchFingerEvent,
    fingerMotion: TouchFingerEvent,
    multiGesture: MultiGestureEvent,
    dollarGesture: DollarGestureEvent,
    dollarRecord: DollarGestureEvent,
    dropFile: DropEvent,
    dropText: DropEvent,
    dropBegin: DropEvent,
    dropComplete: DropEvent,
    // user: UserEvent,

    fn from(raw: c.SDL_Event) Event {
        return switch (raw.type) {
            c.SDL_QUIT => Event{ .quit = raw.quit },
            c.SDL_APP_TERMINATING => Event{ .appTerminating = raw.common },
            c.SDL_APP_LOWMEMORY => Event{ .appLowMemory = raw.common },
            c.SDL_APP_WILLENTERBACKGROUND => Event{ .appWillEnterBackground = raw.common },
            c.SDL_APP_DIDENTERBACKGROUND => Event{ .appDidEnterBackground = raw.common },
            c.SDL_APP_WILLENTERFOREGROUND => Event{ .appWillEnterForeground = raw.common },
            c.SDL_APP_DIDENTERFOREGROUND => Event{ .appDidEnterForeground = raw.common },
            c.SDL_DISPLAYEVENT => Event{ .display = raw.display },
            c.SDL_WINDOWEVENT => Event{ .window = raw.window },
            c.SDL_SYSWMEVENT => Event{ .sysWM = raw.syswm },
            c.SDL_KEYDOWN => Event{ .keyDown = raw.key },
            c.SDL_KEYUP => Event{ .keyUp = raw.key },
            c.SDL_TEXTEDITING => Event{ .textEditing = raw.edit },
            c.SDL_TEXTINPUT => Event{ .textInput = raw.text },
            c.SDL_KEYMAPCHANGED => Event{ .keyMapChanged = raw.common },
            c.SDL_MOUSEMOTION => Event{ .mouseMotion = raw.motion },
            c.SDL_MOUSEBUTTONDOWN => Event{ .mouseButtonDown = raw.button },
            c.SDL_MOUSEBUTTONUP => Event{ .mouseButtonUp = raw.button },
            c.SDL_MOUSEWHEEL => Event{ .mouseWheel = raw.wheel },
            c.SDL_JOYAXISMOTION => Event{ .joyAxisMotion = raw.jaxis },
            c.SDL_JOYBALLMOTION => Event{ .joyBallMotion = raw.jball },
            c.SDL_JOYHATMOTION => Event{ .joyHatMotion = raw.jhat },
            c.SDL_JOYBUTTONDOWN => Event{ .joyButtonDown = raw.jbutton },
            c.SDL_JOYBUTTONUP => Event{ .joyButtonUp = raw.jbutton },
            c.SDL_JOYDEVICEADDED => Event{ .joyDeviceAdded = raw.jdevice },
            c.SDL_JOYDEVICEREMOVED => Event{ .joyDeviceRemoved = raw.jdevice },
            c.SDL_CONTROLLERAXISMOTION => Event{ .controllerAxisMotion = raw.caxis },
            c.SDL_CONTROLLERBUTTONDOWN => Event{ .controllerButtonDown = raw.cbutton },
            c.SDL_CONTROLLERBUTTONUP => Event{ .controllerButtonUp = raw.cbutton },
            c.SDL_CONTROLLERDEVICEADDED => Event{ .controllerDeviceAdded = raw.cdevice },
            c.SDL_CONTROLLERDEVICEREMOVED => Event{ .controllerDeviceRemoved = raw.cdevice },
            c.SDL_CONTROLLERDEVICEREMAPPED => Event{ .controllerDeviceRemapped = raw.cdevice },
            c.SDL_FINGERDOWN => Event{ .fingerDown = raw.tfinger },
            c.SDL_FINGERUP => Event{ .fingerUp = raw.tfinger },
            c.SDL_FINGERMOTION => Event{ .fingerMotion = raw.tfinger },
            c.SDL_DOLLARGESTURE => Event{ .dollarGesture = raw.dgesture },
            c.SDL_DOLLARRECORD => Event{ .dollarRecord = raw.dgesture },
            c.SDL_MULTIGESTURE => Event{ .multiGesture = raw.mgesture },
            c.SDL_CLIPBOARDUPDATE => Event{ .clipBoardUpdate = raw.common },
            c.SDL_DROPFILE => Event{ .dropFile = raw.drop },
            c.SDL_DROPTEXT => Event{ .dropText = raw.drop },
            c.SDL_DROPBEGIN => Event{ .dropBegin = raw.drop },
            c.SDL_DROPCOMPLETE => Event{ .dropComplete = raw.drop },
            c.SDL_AUDIODEVICEADDED => Event{ .audioDeviceAdded = raw.adevice },
            c.SDL_AUDIODEVICEREMOVED => Event{ .audioDeviceRemoved = raw.adevice },
            c.SDL_SENSORUPDATE => Event{ .sensorUpdate = raw.sensor },
            c.SDL_RENDER_TARGETS_RESET => Event{ .renderTargetsReset = raw.common },
            c.SDL_RENDER_DEVICE_RESET => Event{ .renderDeviceReset = raw.common },
            else => @panic("Unsupported event type detected!"),
        };
    }
};

pub fn pollEvent() ?Event {
    var ev: c.SDL_Event = undefined;
    if (c.SDL_PollEvent(&ev) != 0)
        return Event.from(ev);
    return null;
}
