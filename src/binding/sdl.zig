const std = @import("std");

/// 
/// Get the window which currently has mouse focus.
/// 
/// \returns the window with mouse focus.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const GetMouseFocus = SDL_GetMouseFocus;
extern fn SDL_GetMouseFocus() ?*SDL_Window;

/// 
/// Retrieve the current state of the mouse.
/// 
/// The current button state is returned as a button bitmask, which can be
/// tested using the `SDL_BUTTON(X)` macros (where `X` is generally 1 for the
/// left, 2 for middle, 3 for the right button), and `x` and `y` are set to the
/// mouse cursor position relative to the focus window. You can pass NULL for
/// either `x` or `y`.
/// 
/// \param x the x coordinate of the mouse cursor position relative to the
///          focus window
/// \param y the y coordinate of the mouse cursor position relative to the
///          focus window
/// \returns a 32-bit button bitmask of the current button state.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_GetGlobalMouseState
/// \sa SDL_GetRelativeMouseState
/// \sa SDL_PumpEvents
/// 
/// 
pub const GetMouseState = SDL_GetMouseState;
extern fn SDL_GetMouseState(
    x: *f32,
    y: *f32,
) u32;

/// 
/// Get the current state of the mouse in relation to the desktop.
/// 
/// This works similarly to SDL_GetMouseState(), but the coordinates will be
/// reported relative to the top-left of the desktop. This can be useful if you
/// need to track the mouse outside of a specific window and SDL_CaptureMouse()
/// doesn't fit your needs. For example, it could be useful if you need to
/// track the mouse while dragging a window, where coordinates relative to a
/// window might not be in sync at all times.
/// 
/// Note: SDL_GetMouseState() returns the mouse position as SDL understands it
/// from the last pump of the event queue. This function, however, queries the
/// OS for the current mouse position, and as such, might be a slightly less
/// efficient function. Unless you know what you're doing and have a good
/// reason to use this function, you probably want SDL_GetMouseState() instead.
/// 
/// \param x filled in with the current X coord relative to the desktop; can be
///          NULL
/// \param y filled in with the current Y coord relative to the desktop; can be
///          NULL
/// \returns the current button state as a bitmask which can be tested using
///          the SDL_BUTTON(X) macros.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_CaptureMouse
/// 
/// 
pub const GetGlobalMouseState = SDL_GetGlobalMouseState;
extern fn SDL_GetGlobalMouseState(
    x: *f32,
    y: *f32,
) u32;

/// 
/// Retrieve the relative state of the mouse.
/// 
/// The current button state is returned as a button bitmask, which can be
/// tested using the `SDL_BUTTON(X)` macros (where `X` is generally 1 for the
/// left, 2 for middle, 3 for the right button), and `x` and `y` are set to the
/// mouse deltas since the last call to SDL_GetRelativeMouseState() or since
/// event initialization. You can pass NULL for either `x` or `y`.
/// 
/// \param x a pointer filled with the last recorded x coordinate of the mouse
/// \param y a pointer filled with the last recorded y coordinate of the mouse
/// \returns a 32-bit button bitmask of the relative button state.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_GetMouseState
/// 
/// 
pub const GetRelativeMouseState = SDL_GetRelativeMouseState;
extern fn SDL_GetRelativeMouseState(
    x: *f32,
    y: *f32,
) u32;

/// 
/// Move the mouse cursor to the given position within the window.
/// 
/// This function generates a mouse motion event if relative mode is not
/// enabled. If relative mode is enabled, you can force mouse events for the
/// warp by setting the SDL_HINT_MOUSE_RELATIVE_WARP_MOTION hint.
/// 
/// Note that this function will appear to succeed, but not actually move the
/// mouse when used over Microsoft Remote Desktop.
/// 
/// \param window the window to move the mouse into, or NULL for the current
///               mouse focus
/// \param x the x coordinate within the window
/// \param y the y coordinate within the window
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_WarpMouseGlobal
/// 
/// 
pub const WarpMouseInWindow = SDL_WarpMouseInWindow;
extern fn SDL_WarpMouseInWindow(
    window: ?*SDL_Window,
    x: f32,
    y: f32,
) void;

/// 
/// Move the mouse to the given position in global screen space.
/// 
/// This function generates a mouse motion event.
/// 
/// A failure of this function usually means that it is unsupported by a
/// platform.
/// 
/// Note that this function will appear to succeed, but not actually move the
/// mouse when used over Microsoft Remote Desktop.
/// 
/// \param x the x coordinate
/// \param y the y coordinate
/// \returns 0 on success or a negative error code on failure; call
///          SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_WarpMouseInWindow
/// 
/// 
pub const WarpMouseGlobal = SDL_WarpMouseGlobal;
extern fn SDL_WarpMouseGlobal(
    x: f32,
    y: f32,
) c_int;

/// 
/// Set relative mouse mode.
/// 
/// While the mouse is in relative mode, the cursor is hidden, and the driver
/// will try to report continuous motion in the current window. Only relative
/// motion events will be delivered, the mouse position will not change.
/// 
/// Note that this function will not be able to provide continuous relative
/// motion when used over Microsoft Remote Desktop, instead motion is limited
/// to the bounds of the screen.
/// 
/// This function will flush any pending mouse motion.
/// 
/// \param enabled SDL_TRUE to enable relative mode, SDL_FALSE to disable.
/// \returns 0 on success or a negative error code on failure; call
///          SDL_GetError() for more information.
/// 
///          If relative mode is not supported, this returns -1.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_GetRelativeMouseMode
/// 
/// 
pub const SetRelativeMouseMode = SDL_SetRelativeMouseMode;
extern fn SDL_SetRelativeMouseMode(
    enabled: bool,
) c_int;

/// 
/// Capture the mouse and to track input outside an SDL window.
/// 
/// Capturing enables your app to obtain mouse events globally, instead of just
/// within your window. Not all video targets support this function. When
/// capturing is enabled, the current window will get all mouse events, but
/// unlike relative mode, no change is made to the cursor and it is not
/// restrained to your window.
/// 
/// This function may also deny mouse input to other windows--both those in
/// your application and others on the system--so you should use this function
/// sparingly, and in small bursts. For example, you might want to track the
/// mouse while the user is dragging something, until the user releases a mouse
/// button. It is not recommended that you capture the mouse for long periods
/// of time, such as the entire time your app is running. For that, you should
/// probably use SDL_SetRelativeMouseMode() or SDL_SetWindowGrab(), depending
/// on your goals.
/// 
/// While captured, mouse events still report coordinates relative to the
/// current (foreground) window, but those coordinates may be outside the
/// bounds of the window (including negative values). Capturing is only allowed
/// for the foreground window. If the window loses focus while capturing, the
/// capture will be disabled automatically.
/// 
/// While capturing is enabled, the current window will have the
/// `SDL_WINDOW_MOUSE_CAPTURE` flag set.
/// 
/// Please note that as of SDL 2.0.22, SDL will attempt to "auto capture" the
/// mouse while the user is pressing a button; this is to try and make mouse
/// behavior more consistent between platforms, and deal with the common case
/// of a user dragging the mouse outside of the window. This means that if you
/// are calling SDL_CaptureMouse() only to deal with this situation, you no
/// longer have to (although it is safe to do so). If this causes problems for
/// your app, you can disable auto capture by setting the
/// `SDL_HINT_MOUSE_AUTO_CAPTURE` hint to zero.
/// 
/// \param enabled SDL_TRUE to enable capturing, SDL_FALSE to disable.
/// \returns 0 on success or -1 if not supported; call SDL_GetError() for more
///          information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_GetGlobalMouseState
/// 
/// 
pub const CaptureMouse = SDL_CaptureMouse;
extern fn SDL_CaptureMouse(
    enabled: bool,
) c_int;

/// 
/// Query whether relative mouse mode is enabled.
/// 
/// \returns SDL_TRUE if relative mode is enabled or SDL_FALSE otherwise.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_SetRelativeMouseMode
/// 
/// 
pub const GetRelativeMouseMode = SDL_GetRelativeMouseMode;
extern fn SDL_GetRelativeMouseMode() bool;

/// 
/// Create a cursor using the specified bitmap data and mask (in MSB format).
/// 
/// `mask` has to be in MSB (Most Significant Bit) format.
/// 
/// The cursor width (`w`) must be a multiple of 8 bits.
/// 
/// The cursor is created in black and white according to the following:
/// 
/// - data=0, mask=1: white
/// - data=1, mask=1: black
/// - data=0, mask=0: transparent
/// - data=1, mask=0: inverted color if possible, black if not.
/// 
/// Cursors created with this function must be freed with SDL_DestroyCursor().
/// 
/// If you want to have a color cursor, or create your cursor from an
/// SDL_Surface, you should use SDL_CreateColorCursor(). Alternately, you can
/// hide the cursor and draw your own as part of your game's rendering, but it
/// will be bound to the framerate.
/// 
/// Also, since SDL 2.0.0, SDL_CreateSystemCursor() is available, which
/// provides twelve readily available system cursors to pick from.
/// 
/// \param data the color value for each pixel of the cursor
/// \param mask the mask value for each pixel of the cursor
/// \param w the width of the cursor
/// \param h the height of the cursor
/// \param hot_x the X-axis location of the upper left corner of the cursor
///              relative to the actual mouse position
/// \param hot_y the Y-axis location of the upper left corner of the cursor
///              relative to the actual mouse position
/// \returns a new cursor with the specified parameters on success or NULL on
///          failure; call SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_DestroyCursor
/// \sa SDL_SetCursor
/// 
/// 
pub const CreateCursor = SDL_CreateCursor;
extern fn SDL_CreateCursor(
    data: ?[*]const u8,
    mask: ?[*]const u8,
    w: c_int,
    h: c_int,
    hot_x: c_int,
    hot_y: c_int,
) ?*SDL_Cursor;

/// 
/// Create a color cursor.
/// 
/// \param surface an SDL_Surface structure representing the cursor image
/// \param hot_x the x position of the cursor hot spot
/// \param hot_y the y position of the cursor hot spot
/// \returns the new cursor on success or NULL on failure; call SDL_GetError()
///          for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_CreateCursor
/// \sa SDL_DestroyCursor
/// 
/// 
pub const CreateColorCursor = SDL_CreateColorCursor;
extern fn SDL_CreateColorCursor(
    surface: ?*SDL_Surface,
    hot_x: c_int,
    hot_y: c_int,
) ?*SDL_Cursor;

/// 
/// Create a system cursor.
/// 
/// \param id an SDL_SystemCursor enum value
/// \returns a cursor on success or NULL on failure; call SDL_GetError() for
///          more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_DestroyCursor
/// 
/// 
pub const CreateSystemCursor = SDL_CreateSystemCursor;
extern fn SDL_CreateSystemCursor(
    id: SDL_SystemCursor,
) ?*SDL_Cursor;

/// 
/// Set the active cursor.
/// 
/// This function sets the currently active cursor to the specified one. If the
/// cursor is currently visible, the change will be immediately represented on
/// the display. SDL_SetCursor(NULL) can be used to force cursor redraw, if
/// this is desired for any reason.
/// 
/// \param cursor a cursor to make active
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_CreateCursor
/// \sa SDL_GetCursor
/// 
/// 
pub const SetCursor = SDL_SetCursor;
extern fn SDL_SetCursor(
    cursor: ?*SDL_Cursor,
) void;

/// 
/// Get the active cursor.
/// 
/// This function returns a pointer to the current cursor which is owned by the
/// library. It is not necessary to free the cursor with SDL_DestroyCursor().
/// 
/// \returns the active cursor or NULL if there is no mouse.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_SetCursor
/// 
/// 
pub const GetCursor = SDL_GetCursor;
extern fn SDL_GetCursor() ?*SDL_Cursor;

/// 
/// Get the default cursor.
/// 
/// You do not have to call SDL_DestroyCursor() on the return value,
/// but it is safe to do so.
/// 
/// \returns the default cursor on success or NULL on failure.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_CreateSystemCursor
/// 
/// 
pub const GetDefaultCursor = SDL_GetDefaultCursor;
extern fn SDL_GetDefaultCursor() ?*SDL_Cursor;

/// 
/// Free a previously-created cursor.
/// 
/// Use this function to free cursor resources created with SDL_CreateCursor(),
/// SDL_CreateColorCursor() or SDL_CreateSystemCursor().
/// 
/// \param cursor the cursor to free
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_CreateColorCursor
/// \sa SDL_CreateCursor
/// \sa SDL_CreateSystemCursor
/// 
/// 
pub const DestroyCursor = SDL_DestroyCursor;
extern fn SDL_DestroyCursor(
    cursor: ?*SDL_Cursor,
) void;

/// 
/// Show the cursor.
/// 
/// \returns 0 on success or a negative error code on failure; call
///          SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_CursorVisible
/// \sa SDL_HideCursor
/// 
/// 
pub const ShowCursor = SDL_ShowCursor;
extern fn SDL_ShowCursor() c_int;

/// 
/// Hide the cursor.
/// 
/// \returns 0 on success or a negative error code on failure; call
///          SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_CursorVisible
/// \sa SDL_ShowCursor
/// 
/// 
pub const HideCursor = SDL_HideCursor;
extern fn SDL_HideCursor() c_int;

/// 
/// Return whether the cursor is currently being shown.
/// 
/// \returns `SDL_TRUE` if the cursor is being shown, or `SDL_FALSE` if the
///          cursor is hidden.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_HideCursor
/// \sa SDL_ShowCursor
/// 
/// 
pub const CursorVisible = SDL_CursorVisible;
extern fn SDL_CursorVisible() bool;

/// 
/// Get the directory where the application was run from.
/// 
/// This is not necessarily a fast call, so you should call this once near
/// startup and save the string if you need it.
/// 
/// **macOS and iOS Specific Functionality**: If the application is in a ".app"
/// bundle, this function returns the Resource directory (e.g.
/// MyApp.app/Contents/Resources/). This behaviour can be overridden by adding
/// a property to the Info.plist file. Adding a string key with the name
/// SDL_FILESYSTEM_BASE_DIR_TYPE with a supported value will change the
/// behaviour.
/// 
/// Supported values for the SDL_FILESYSTEM_BASE_DIR_TYPE property (Given an
/// application in /Applications/SDLApp/MyApp.app):
/// 
/// - `resource`: bundle resource directory (the default). For example:
///   `/Applications/SDLApp/MyApp.app/Contents/Resources`
/// - `bundle`: the Bundle directory. For example:
///   `/Applications/SDLApp/MyApp.app/`
/// - `parent`: the containing directory of the bundle. For example:
///   `/Applications/SDLApp/`
/// 
/// **Nintendo 3DS Specific Functionality**: This function returns "romfs"
/// directory of the application as it is uncommon to store resources outside
/// the executable. As such it is not a writable directory.
/// 
/// The returned path is guaranteed to end with a path separator ('\' on
/// Windows, '/' on most other platforms).
/// 
/// The pointer returned is owned by the caller. Please call SDL_free() on the
/// pointer when done with it.
/// 
/// \returns an absolute path in UTF-8 encoding to the application data
///          directory. NULL will be returned on error or when the platform
///          doesn't implement this functionality, call SDL_GetError() for more
///          information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_GetPrefPath
/// 
/// 
pub const GetBasePath = SDL_GetBasePath;
extern fn SDL_GetBasePath() ?[*:0]u8;

/// 
/// Get the user-and-app-specific path where files can be written.
/// 
/// Get the "pref dir". This is meant to be where users can write personal
/// files (preferences and save games, etc) that are specific to your
/// application. This directory is unique per user, per application.
/// 
/// This function will decide the appropriate location in the native
/// filesystem, create the directory if necessary, and return a string of the
/// absolute path to the directory in UTF-8 encoding.
/// 
/// On Windows, the string might look like:
/// 
/// `C:\\Users\\bob\\AppData\\Roaming\\My Company\\My Program Name\\`
/// 
/// On Linux, the string might look like:
/// 
/// `/home/bob/.local/share/My Program Name/`
/// 
/// On macOS, the string might look like:
/// 
/// `/Users/bob/Library/Application Support/My Program Name/`
/// 
/// You should assume the path returned by this function is the only safe place
/// to write files (and that SDL_GetBasePath(), while it might be writable, or
/// even the parent of the returned path, isn't where you should be writing
/// things).
/// 
/// Both the org and app strings may become part of a directory name, so please
/// follow these rules:
/// 
/// - Try to use the same org string (_including case-sensitivity_) for all
///   your applications that use this function.
/// - Always use a unique app string for each one, and make sure it never
///   changes for an app once you've decided on it.
/// - Unicode characters are legal, as long as it's UTF-8 encoded, but...
/// - ...only use letters, numbers, and spaces. Avoid punctuation like "Game
///   Name 2: Bad Guy's Revenge!" ... "Game Name 2" is sufficient.
/// 
/// The returned path is guaranteed to end with a path separator ('\' on
/// Windows, '/' on most other platforms).
/// 
/// The pointer returned is owned by the caller. Please call SDL_free() on the
/// pointer when done with it.
/// 
/// \param org the name of your organization
/// \param app the name of your application
/// \returns a UTF-8 string of the user directory in platform-dependent
///          notation. NULL if there's a problem (creating directory failed,
///          etc.).
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_GetBasePath
/// 
/// 
pub const GetPrefPath = SDL_GetPrefPath;
extern fn SDL_GetPrefPath(
    org: ?[*:0]const u8,
    app: ?[*:0]const u8,
) ?[*:0]u8;

/// 
/// Determine whether two rectangles intersect.
/// 
/// If either pointer is NULL the function will return SDL_FALSE.
/// 
/// \param A an SDL_Rect structure representing the first rectangle
/// \param B an SDL_Rect structure representing the second rectangle
/// \returns SDL_TRUE if there is an intersection, SDL_FALSE otherwise.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_GetRectIntersection
/// 
/// 
pub const HasRectIntersection = SDL_HasRectIntersection;
extern fn SDL_HasRectIntersection(
    A: ?*const SDL_Rect,
    B: ?*const SDL_Rect,
) bool;

/// 
/// Calculate the intersection of two rectangles.
/// 
/// If `result` is NULL then this function will return SDL_FALSE.
/// 
/// \param A an SDL_Rect structure representing the first rectangle
/// \param B an SDL_Rect structure representing the second rectangle
/// \param result an SDL_Rect structure filled in with the intersection of
///               rectangles `A` and `B`
/// \returns SDL_TRUE if there is an intersection, SDL_FALSE otherwise.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_HasRectIntersection
/// 
/// 
pub const GetRectIntersection = SDL_GetRectIntersection;
extern fn SDL_GetRectIntersection(
    A: ?*const SDL_Rect,
    B: ?*const SDL_Rect,
    result: ?*SDL_Rect,
) bool;

/// 
/// Calculate the union of two rectangles.
/// 
/// \param A an SDL_Rect structure representing the first rectangle
/// \param B an SDL_Rect structure representing the second rectangle
/// \param result an SDL_Rect structure filled in with the union of rectangles
///               `A` and `B`
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const GetRectUnion = SDL_GetRectUnion;
extern fn SDL_GetRectUnion(
    A: ?*const SDL_Rect,
    B: ?*const SDL_Rect,
    result: ?*SDL_Rect,
) void;

/// 
/// Calculate a minimal rectangle enclosing a set of points.
/// 
/// If `clip` is not NULL then only points inside of the clipping rectangle are
/// considered.
/// 
/// \param points an array of SDL_Point structures representing points to be
///               enclosed
/// \param count the number of structures in the `points` array
/// \param clip an SDL_Rect used for clipping or NULL to enclose all points
/// \param result an SDL_Rect structure filled in with the minimal enclosing
///               rectangle
/// \returns SDL_TRUE if any points were enclosed or SDL_FALSE if all the
///          points were outside of the clipping rectangle.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const GetRectEnclosingPoints = SDL_GetRectEnclosingPoints;
extern fn SDL_GetRectEnclosingPoints(
    points: ?*const SDL_Point,
    count: c_int,
    clip: ?*const SDL_Rect,
    result: ?*SDL_Rect,
) bool;

/// 
/// Calculate the intersection of a rectangle and line segment.
/// 
/// This function is used to clip a line segment to a rectangle. A line segment
/// contained entirely within the rectangle or that does not intersect will
/// remain unchanged. A line segment that crosses the rectangle at either or
/// both ends will be clipped to the boundary of the rectangle and the new
/// coordinates saved in `X1`, `Y1`, `X2`, and/or `Y2` as necessary.
/// 
/// \param rect an SDL_Rect structure representing the rectangle to intersect
/// \param X1 a pointer to the starting X-coordinate of the line
/// \param Y1 a pointer to the starting Y-coordinate of the line
/// \param X2 a pointer to the ending X-coordinate of the line
/// \param Y2 a pointer to the ending Y-coordinate of the line
/// \returns SDL_TRUE if there is an intersection, SDL_FALSE otherwise.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const GetRectAndLineIntersection = SDL_GetRectAndLineIntersection;
extern fn SDL_GetRectAndLineIntersection(
    rect: ?*const SDL_Rect,
    X1: *c_int,
    Y1: *c_int,
    X2: *c_int,
    Y2: *c_int,
) bool;

/// 
/// Determine whether two rectangles intersect with float precision.
/// 
/// If either pointer is NULL the function will return SDL_FALSE.
/// 
/// \param A an SDL_FRect structure representing the first rectangle
/// \param B an SDL_FRect structure representing the second rectangle
/// \returns SDL_TRUE if there is an intersection, SDL_FALSE otherwise.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_GetRectIntersection
/// 
/// 
pub const HasRectIntersectionFloat = SDL_HasRectIntersectionFloat;
extern fn SDL_HasRectIntersectionFloat(
    A: ?*const SDL_FRect,
    B: ?*const SDL_FRect,
) bool;

/// 
/// Calculate the intersection of two rectangles with float precision.
/// 
/// If `result` is NULL then this function will return SDL_FALSE.
/// 
/// \param A an SDL_FRect structure representing the first rectangle
/// \param B an SDL_FRect structure representing the second rectangle
/// \param result an SDL_FRect structure filled in with the intersection of
///               rectangles `A` and `B`
/// \returns SDL_TRUE if there is an intersection, SDL_FALSE otherwise.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_HasRectIntersectionFloat
/// 
/// 
pub const GetRectIntersectionFloat = SDL_GetRectIntersectionFloat;
extern fn SDL_GetRectIntersectionFloat(
    A: ?*const SDL_FRect,
    B: ?*const SDL_FRect,
    result: ?*SDL_FRect,
) bool;

/// 
/// Calculate the union of two rectangles with float precision.
/// 
/// \param A an SDL_FRect structure representing the first rectangle
/// \param B an SDL_FRect structure representing the second rectangle
/// \param result an SDL_FRect structure filled in with the union of rectangles
///               `A` and `B`
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const GetRectUnionFloat = SDL_GetRectUnionFloat;
extern fn SDL_GetRectUnionFloat(
    A: ?*const SDL_FRect,
    B: ?*const SDL_FRect,
    result: ?*SDL_FRect,
) void;

/// 
/// Calculate a minimal rectangle enclosing a set of points with float
/// precision.
/// 
/// If `clip` is not NULL then only points inside of the clipping rectangle are
/// considered.
/// 
/// \param points an array of SDL_FPoint structures representing points to be
///               enclosed
/// \param count the number of structures in the `points` array
/// \param clip an SDL_FRect used for clipping or NULL to enclose all points
/// \param result an SDL_FRect structure filled in with the minimal enclosing
///               rectangle
/// \returns SDL_TRUE if any points were enclosed or SDL_FALSE if all the
///          points were outside of the clipping rectangle.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const GetRectEnclosingPointsFloat = SDL_GetRectEnclosingPointsFloat;
extern fn SDL_GetRectEnclosingPointsFloat(
    points: ?*const SDL_FPoint,
    count: c_int,
    clip: ?*const SDL_FRect,
    result: ?*SDL_FRect,
) bool;

/// 
/// Calculate the intersection of a rectangle and line segment with float
/// precision.
/// 
/// This function is used to clip a line segment to a rectangle. A line segment
/// contained entirely within the rectangle or that does not intersect will
/// remain unchanged. A line segment that crosses the rectangle at either or
/// both ends will be clipped to the boundary of the rectangle and the new
/// coordinates saved in `X1`, `Y1`, `X2`, and/or `Y2` as necessary.
/// 
/// \param rect an SDL_FRect structure representing the rectangle to intersect
/// \param X1 a pointer to the starting X-coordinate of the line
/// \param Y1 a pointer to the starting Y-coordinate of the line
/// \param X2 a pointer to the ending X-coordinate of the line
/// \param Y2 a pointer to the ending Y-coordinate of the line
/// \returns SDL_TRUE if there is an intersection, SDL_FALSE otherwise.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const GetRectAndLineIntersectionFloat = SDL_GetRectAndLineIntersectionFloat;
extern fn SDL_GetRectAndLineIntersectionFloat(
    rect: ?*const SDL_FRect,
    X1: *f32,
    Y1: *f32,
    X2: *f32,
    Y2: *f32,
) bool;

/// 
/// Query the window which currently has keyboard focus.
/// 
/// \returns the window with keyboard focus.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const GetKeyboardFocus = SDL_GetKeyboardFocus;
extern fn SDL_GetKeyboardFocus() ?*SDL_Window;

/// 
/// Get a snapshot of the current state of the keyboard.
/// 
/// The pointer returned is a pointer to an internal SDL array. It will be
/// valid for the whole lifetime of the application and should not be freed by
/// the caller.
/// 
/// A array element with a value of 1 means that the key is pressed and a value
/// of 0 means that it is not. Indexes into this array are obtained by using
/// SDL_Scancode values.
/// 
/// Use SDL_PumpEvents() to update the state array.
/// 
/// This function gives you the current state after all events have been
/// processed, so if a key or button has been pressed and released before you
/// process events, then the pressed state will never show up in the
/// SDL_GetKeyboardState() calls.
/// 
/// Note: This function doesn't take into account whether shift has been
/// pressed or not.
/// 
/// \param numkeys if non-NULL, receives the length of the returned array
/// \returns a pointer to an array of key states.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_PumpEvents
/// \sa SDL_ResetKeyboard
/// 
/// 
pub const GetKeyboardState = SDL_GetKeyboardState;
extern fn SDL_GetKeyboardState(
    numkeys: *c_int,
) ?[*]const u8;

/// 
/// Clear the state of the keyboard
/// 
/// This function will generate key up events for all pressed keys.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_GetKeyboardState
/// 
/// 
pub const ResetKeyboard = SDL_ResetKeyboard;
extern fn SDL_ResetKeyboard() void;

/// 
/// Get the current key modifier state for the keyboard.
/// 
/// \returns an OR'd combination of the modifier keys for the keyboard. See
///          SDL_Keymod for details.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_GetKeyboardState
/// \sa SDL_SetModState
/// 
/// 
pub const GetModState = SDL_GetModState;
extern fn SDL_GetModState() SDL_Keymod;

/// 
/// Set the current key modifier state for the keyboard.
/// 
/// The inverse of SDL_GetModState(), SDL_SetModState() allows you to impose
/// modifier key states on your application. Simply pass your desired modifier
/// states into `modstate`. This value may be a bitwise, OR'd combination of
/// SDL_Keymod values.
/// 
/// This does not change the keyboard state, only the key modifier flags that
/// SDL reports.
/// 
/// \param modstate the desired SDL_Keymod for the keyboard
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_GetModState
/// 
/// 
pub const SetModState = SDL_SetModState;
extern fn SDL_SetModState(
    modstate: SDL_Keymod,
) void;

/// 
/// Get the key code corresponding to the given scancode according to the
/// current keyboard layout.
/// 
/// See SDL_Keycode for details.
/// 
/// \param scancode the desired SDL_Scancode to query
/// \returns the SDL_Keycode that corresponds to the given SDL_Scancode.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_GetKeyName
/// \sa SDL_GetScancodeFromKey
/// 
/// 
pub const GetKeyFromScancode = SDL_GetKeyFromScancode;
extern fn SDL_GetKeyFromScancode(
    scancode: SDL_Scancode,
) SDL_Keycode;

/// 
/// Get the scancode corresponding to the given key code according to the
/// current keyboard layout.
/// 
/// See SDL_Scancode for details.
/// 
/// \param key the desired SDL_Keycode to query
/// \returns the SDL_Scancode that corresponds to the given SDL_Keycode.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_GetKeyFromScancode
/// \sa SDL_GetScancodeName
/// 
/// 
pub const GetScancodeFromKey = SDL_GetScancodeFromKey;
extern fn SDL_GetScancodeFromKey(
    key: SDL_Keycode,
) SDL_Scancode;

/// 
/// Get a human-readable name for a scancode.
/// 
/// See SDL_Scancode for details.
/// 
/// **Warning**: The returned name is by design not stable across platforms,
/// e.g. the name for `SDL_SCANCODE_LGUI` is "Left GUI" under Linux but "Left
/// Windows" under Microsoft Windows, and some scancodes like
/// `SDL_SCANCODE_NONUSBACKSLASH` don't have any name at all. There are even
/// scancodes that share names, e.g. `SDL_SCANCODE_RETURN` and
/// `SDL_SCANCODE_RETURN2` (both called "Return"). This function is therefore
/// unsuitable for creating a stable cross-platform two-way mapping between
/// strings and scancodes.
/// 
/// \param scancode the desired SDL_Scancode to query
/// \returns a pointer to the name for the scancode. If the scancode doesn't
///          have a name this function returns an empty string ("").
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_GetScancodeFromKey
/// \sa SDL_GetScancodeFromName
/// 
/// 
pub const GetScancodeName = SDL_GetScancodeName;
extern fn SDL_GetScancodeName(
    scancode: SDL_Scancode,
) ?[*:0]const u8;

/// 
/// Get a scancode from a human-readable name.
/// 
/// \param name the human-readable scancode name
/// \returns the SDL_Scancode, or `SDL_SCANCODE_UNKNOWN` if the name wasn't
///          recognized; call SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_GetKeyFromName
/// \sa SDL_GetScancodeFromKey
/// \sa SDL_GetScancodeName
/// 
/// 
pub const GetScancodeFromName = SDL_GetScancodeFromName;
extern fn SDL_GetScancodeFromName(
    name: ?[*:0]const u8,
) SDL_Scancode;

/// 
/// Get a human-readable name for a key.
/// 
/// See SDL_Scancode and SDL_Keycode for details.
/// 
/// \param key the desired SDL_Keycode to query
/// \returns a pointer to a UTF-8 string that stays valid at least until the
///          next call to this function. If you need it around any longer, you
///          must copy it. If the key doesn't have a name, this function
///          returns an empty string ("").
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_GetKeyFromName
/// \sa SDL_GetKeyFromScancode
/// \sa SDL_GetScancodeFromKey
/// 
/// 
pub const GetKeyName = SDL_GetKeyName;
extern fn SDL_GetKeyName(
    key: SDL_Keycode,
) ?[*:0]const u8;

/// 
/// Get a key code from a human-readable name.
/// 
/// \param name the human-readable key name
/// \returns key code, or `SDLK_UNKNOWN` if the name wasn't recognized; call
///          SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_GetKeyFromScancode
/// \sa SDL_GetKeyName
/// \sa SDL_GetScancodeFromName
/// 
/// 
pub const GetKeyFromName = SDL_GetKeyFromName;
extern fn SDL_GetKeyFromName(
    name: ?[*:0]const u8,
) SDL_Keycode;

/// 
/// Start accepting Unicode text input events.
/// 
/// This function will start accepting Unicode text input events in the focused
/// SDL window, and start emitting SDL_TextInputEvent (SDL_TEXTINPUT) and
/// SDL_TextEditingEvent (SDL_TEXTEDITING) events. Please use this function in
/// pair with SDL_StopTextInput().
/// 
/// On some platforms using this function activates the screen keyboard.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_SetTextInputRect
/// \sa SDL_StopTextInput
/// 
/// 
pub const StartTextInput = SDL_StartTextInput;
extern fn SDL_StartTextInput() void;

/// 
/// Check whether or not Unicode text input events are enabled.
/// 
/// \returns SDL_TRUE if text input events are enabled else SDL_FALSE.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_StartTextInput
/// 
/// 
pub const TextInputActive = SDL_TextInputActive;
extern fn SDL_TextInputActive() bool;

/// 
/// Stop receiving any text input events.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_StartTextInput
/// 
/// 
pub const StopTextInput = SDL_StopTextInput;
extern fn SDL_StopTextInput() void;

/// 
/// Dismiss the composition window/IME without disabling the subsystem.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_StartTextInput
/// \sa SDL_StopTextInput
/// 
/// 
pub const ClearComposition = SDL_ClearComposition;
extern fn SDL_ClearComposition() void;

/// 
/// Returns if an IME Composite or Candidate window is currently shown.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const TextInputShown = SDL_TextInputShown;
extern fn SDL_TextInputShown() bool;

/// 
/// Set the rectangle used to type Unicode text inputs.
/// 
/// To start text input in a given location, this function is intended to be
/// called before SDL_StartTextInput, although some platforms support moving
/// the rectangle even while text input (and a composition) is active.
/// 
/// Note: If you want to use the system native IME window, try setting hint
/// **SDL_HINT_IME_SHOW_UI** to **1**, otherwise this function won't give you
/// any feedback.
/// 
/// \param rect the SDL_Rect structure representing the rectangle to receive
///             text (ignored if NULL)
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_StartTextInput
/// 
/// 
pub const SetTextInputRect = SDL_SetTextInputRect;
extern fn SDL_SetTextInputRect(
    rect: ?*const SDL_Rect,
) void;

/// 
/// Check whether the platform has screen keyboard support.
/// 
/// \returns SDL_TRUE if the platform has some screen keyboard support or
///          SDL_FALSE if not.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_StartTextInput
/// \sa SDL_ScreenKeyboardShown
/// 
/// 
pub const HasScreenKeyboardSupport = SDL_HasScreenKeyboardSupport;
extern fn SDL_HasScreenKeyboardSupport() bool;

/// 
/// Check whether the screen keyboard is shown for given window.
/// 
/// \param window the window for which screen keyboard should be queried
/// \returns SDL_TRUE if screen keyboard is shown or SDL_FALSE if not.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_HasScreenKeyboardSupport
/// 
/// 
pub const ScreenKeyboardShown = SDL_ScreenKeyboardShown;
extern fn SDL_ScreenKeyboardShown(
    window: ?*SDL_Window,
) bool;

/// 
/// Set the priority of all log categories.
/// 
/// \param priority the SDL_LogPriority to assign
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_LogSetPriority
/// 
/// 
pub const LogSetAllPriority = SDL_LogSetAllPriority;
extern fn SDL_LogSetAllPriority(
    priority: SDL_LogPriority,
) void;

/// 
/// Set the priority of a particular log category.
/// 
/// \param category the category to assign a priority to
/// \param priority the SDL_LogPriority to assign
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_LogGetPriority
/// \sa SDL_LogSetAllPriority
/// 
/// 
pub const LogSetPriority = SDL_LogSetPriority;
extern fn SDL_LogSetPriority(
    category: c_int,
    priority: SDL_LogPriority,
) void;

/// 
/// Get the priority of a particular log category.
/// 
/// \param category the category to query
/// \returns the SDL_LogPriority for the requested category
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_LogSetPriority
/// 
/// 
pub const LogGetPriority = SDL_LogGetPriority;
extern fn SDL_LogGetPriority(
    category: c_int,
) SDL_LogPriority;

/// 
/// Reset all priorities to default.
/// 
/// This is called by SDL_Quit().
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_LogSetAllPriority
/// \sa SDL_LogSetPriority
/// 
/// 
pub const LogResetPriorities = SDL_LogResetPriorities;
extern fn SDL_LogResetPriorities() void;

/// 
/// Log a message with SDL_LOG_CATEGORY_APPLICATION and SDL_LOG_PRIORITY_INFO.
/// 
/// = * \param fmt a printf() style message format string
/// 
/// \param ... additional parameters matching % tokens in the `fmt` string, if
///            any
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_LogCritical
/// \sa SDL_LogDebug
/// \sa SDL_LogError
/// \sa SDL_LogInfo
/// \sa SDL_LogMessage
/// \sa SDL_LogMessageV
/// \sa SDL_LogVerbose
/// \sa SDL_LogWarn
/// 
/// 
pub const Log = SDL_Log;
extern fn SDL_Log(
    fmt: [*:0]const u8,
    ...,
) void;

/// 
/// Log a message with SDL_LOG_PRIORITY_VERBOSE.
/// 
/// \param category the category of the message
/// \param fmt a printf() style message format string
/// \param ... additional parameters matching % tokens in the **fmt** string,
///            if any
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_Log
/// \sa SDL_LogCritical
/// \sa SDL_LogDebug
/// \sa SDL_LogError
/// \sa SDL_LogInfo
/// \sa SDL_LogMessage
/// \sa SDL_LogMessageV
/// \sa SDL_LogWarn
/// 
/// 
pub const LogVerbose = SDL_LogVerbose;
extern fn SDL_LogVerbose(
    category: c_int,
    fmt: [*:0]const u8,
    ...,
) void;

/// 
/// Log a message with SDL_LOG_PRIORITY_DEBUG.
/// 
/// \param category the category of the message
/// \param fmt a printf() style message format string
/// \param ... additional parameters matching % tokens in the **fmt** string,
///            if any
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_Log
/// \sa SDL_LogCritical
/// \sa SDL_LogError
/// \sa SDL_LogInfo
/// \sa SDL_LogMessage
/// \sa SDL_LogMessageV
/// \sa SDL_LogVerbose
/// \sa SDL_LogWarn
/// 
/// 
pub const LogDebug = SDL_LogDebug;
extern fn SDL_LogDebug(
    category: c_int,
    fmt: [*:0]const u8,
    ...,
) void;

/// 
/// Log a message with SDL_LOG_PRIORITY_INFO.
/// 
/// \param category the category of the message
/// \param fmt a printf() style message format string
/// \param ... additional parameters matching % tokens in the **fmt** string,
///            if any
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_Log
/// \sa SDL_LogCritical
/// \sa SDL_LogDebug
/// \sa SDL_LogError
/// \sa SDL_LogMessage
/// \sa SDL_LogMessageV
/// \sa SDL_LogVerbose
/// \sa SDL_LogWarn
/// 
/// 
pub const LogInfo = SDL_LogInfo;
extern fn SDL_LogInfo(
    category: c_int,
    fmt: [*:0]const u8,
    ...,
) void;

/// 
/// Log a message with SDL_LOG_PRIORITY_WARN.
/// 
/// \param category the category of the message
/// \param fmt a printf() style message format string
/// \param ... additional parameters matching % tokens in the **fmt** string,
///            if any
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_Log
/// \sa SDL_LogCritical
/// \sa SDL_LogDebug
/// \sa SDL_LogError
/// \sa SDL_LogInfo
/// \sa SDL_LogMessage
/// \sa SDL_LogMessageV
/// \sa SDL_LogVerbose
/// 
/// 
pub const LogWarn = SDL_LogWarn;
extern fn SDL_LogWarn(
    category: c_int,
    fmt: [*:0]const u8,
    ...,
) void;

/// 
/// Log a message with SDL_LOG_PRIORITY_ERROR.
/// 
/// \param category the category of the message
/// \param fmt a printf() style message format string
/// \param ... additional parameters matching % tokens in the **fmt** string,
///            if any
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_Log
/// \sa SDL_LogCritical
/// \sa SDL_LogDebug
/// \sa SDL_LogInfo
/// \sa SDL_LogMessage
/// \sa SDL_LogMessageV
/// \sa SDL_LogVerbose
/// \sa SDL_LogWarn
/// 
/// 
pub const LogError = SDL_LogError;
extern fn SDL_LogError(
    category: c_int,
    fmt: [*:0]const u8,
    ...,
) void;

/// 
/// Log a message with SDL_LOG_PRIORITY_CRITICAL.
/// 
/// \param category the category of the message
/// \param fmt a printf() style message format string
/// \param ... additional parameters matching % tokens in the **fmt** string,
///            if any
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_Log
/// \sa SDL_LogDebug
/// \sa SDL_LogError
/// \sa SDL_LogInfo
/// \sa SDL_LogMessage
/// \sa SDL_LogMessageV
/// \sa SDL_LogVerbose
/// \sa SDL_LogWarn
/// 
/// 
pub const LogCritical = SDL_LogCritical;
extern fn SDL_LogCritical(
    category: c_int,
    fmt: [*:0]const u8,
    ...,
) void;

/// 
/// Log a message with the specified category and priority.
/// 
/// \param category the category of the message
/// \param priority the priority of the message
/// \param fmt a printf() style message format string
/// \param ... additional parameters matching % tokens in the **fmt** string,
///            if any
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_Log
/// \sa SDL_LogCritical
/// \sa SDL_LogDebug
/// \sa SDL_LogError
/// \sa SDL_LogInfo
/// \sa SDL_LogMessageV
/// \sa SDL_LogVerbose
/// \sa SDL_LogWarn
/// 
/// 
pub const LogMessage = SDL_LogMessage;
extern fn SDL_LogMessage(
    category: c_int,
    priority: SDL_LogPriority,
    fmt: [*:0]const u8,
    ...,
) void;

/// 
/// Log a message with the specified category and priority.
/// 
/// \param category the category of the message
/// \param priority the priority of the message
/// \param fmt a printf() style message format string
/// \param ap a variable argument list
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_Log
/// \sa SDL_LogCritical
/// \sa SDL_LogDebug
/// \sa SDL_LogError
/// \sa SDL_LogInfo
/// \sa SDL_LogMessage
/// \sa SDL_LogVerbose
/// \sa SDL_LogWarn
/// 
/// 
pub const LogMessageV = SDL_LogMessageV;
extern fn SDL_LogMessageV(
    category: c_int,
    priority: SDL_LogPriority,
    fmt: ?[*:0]const u8,
    ap: va_list,
) void;

/// 
/// Get the current log output function.
/// 
/// \param callback an SDL_LogOutputFunction filled in with the current log
///                 callback
/// \param userdata a pointer filled in with the pointer that is passed to
///                 `callback`
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_LogSetOutputFunction
/// 
/// 
pub const LogGetOutputFunction = SDL_LogGetOutputFunction;
extern fn SDL_LogGetOutputFunction(
    callback: ?*SDL_LogOutputFunction,
    userdata: [*c][*c]anyopaque,
) void;

/// 
/// Replace the default log output function with one of your own.
/// 
/// \param callback an SDL_LogOutputFunction to call instead of the default
/// \param userdata a pointer that is passed to `callback`
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_LogGetOutputFunction
/// 
/// 
pub const LogSetOutputFunction = SDL_LogSetOutputFunction;
extern fn SDL_LogSetOutputFunction(
    callback: SDL_LogOutputFunction,
    userdata: ?*anyopaque,
) void;

/// 
/// Put UTF-8 text into the clipboard.
/// 
/// \param text the text to store in the clipboard
/// \returns 0 on success or a negative error code on failure; call
///          SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_GetClipboardText
/// \sa SDL_HasClipboardText
/// 
/// 
pub const SetClipboardText = SDL_SetClipboardText;
extern fn SDL_SetClipboardText(
    text: ?[*:0]const u8,
) c_int;

/// 
/// Get UTF-8 text from the clipboard, which must be freed with SDL_free().
/// 
/// This functions returns empty string if there was not enough memory left for
/// a copy of the clipboard's content.
/// 
/// \returns the clipboard text on success or an empty string on failure; call
///          SDL_GetError() for more information. Caller must call SDL_free()
///          on the returned pointer when done with it (even if there was an
///          error).
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_HasClipboardText
/// \sa SDL_SetClipboardText
/// 
/// 
pub const GetClipboardText = SDL_GetClipboardText;
extern fn SDL_GetClipboardText() ?[*:0]u8;

/// 
/// Query whether the clipboard exists and contains a non-empty text string.
/// 
/// \returns SDL_TRUE if the clipboard has text, or SDL_FALSE if it does not.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_GetClipboardText
/// \sa SDL_SetClipboardText
/// 
/// 
pub const HasClipboardText = SDL_HasClipboardText;
extern fn SDL_HasClipboardText() bool;

/// 
/// Put UTF-8 text into the primary selection.
/// 
/// \param text the text to store in the primary selection
/// \returns 0 on success or a negative error code on failure; call
///          SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_GetPrimarySelectionText
/// \sa SDL_HasPrimarySelectionText
/// 
/// 
pub const SetPrimarySelectionText = SDL_SetPrimarySelectionText;
extern fn SDL_SetPrimarySelectionText(
    text: ?[*:0]const u8,
) c_int;

/// 
/// Get UTF-8 text from the primary selection, which must be freed with
/// SDL_free().
/// 
/// This functions returns empty string if there was not enough memory left for
/// a copy of the primary selection's content.
/// 
/// \returns the primary selection text on success or an empty string on
///          failure; call SDL_GetError() for more information. Caller must
///          call SDL_free() on the returned pointer when done with it (even if
///          there was an error).
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_HasPrimarySelectionText
/// \sa SDL_SetPrimarySelectionText
/// 
/// 
pub const GetPrimarySelectionText = SDL_GetPrimarySelectionText;
extern fn SDL_GetPrimarySelectionText() ?[*:0]u8;

/// 
/// Query whether the primary selection exists and contains a non-empty text
/// string.
/// 
/// \returns SDL_TRUE if the primary selection has text, or SDL_FALSE if it
///          does not.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_GetPrimarySelectionText
/// \sa SDL_SetPrimarySelectionText
/// 
/// 
pub const HasPrimarySelectionText = SDL_HasPrimarySelectionText;
extern fn SDL_HasPrimarySelectionText() bool;

/// 
/// Get the number of registered touch devices.
/// 
/// On some platforms SDL first sees the touch device if it was actually used.
/// Therefore SDL_GetNumTouchDevices() may return 0 although devices are
/// available. After using all devices at least once the number will be
/// correct.
/// 
/// This was fixed for Android in SDL 2.0.1.
/// 
/// \returns the number of registered touch devices.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_GetTouchDevice
/// 
/// 
pub const GetNumTouchDevices = SDL_GetNumTouchDevices;
extern fn SDL_GetNumTouchDevices() c_int;

/// 
/// Get the touch ID with the given index.
/// 
/// \param index the touch device index
/// \returns the touch ID with the given index on success or 0 if the index is
///          invalid; call SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_GetNumTouchDevices
/// 
/// 
pub const GetTouchDevice = SDL_GetTouchDevice;
extern fn SDL_GetTouchDevice(
    index: c_int,
) SDL_TouchID;

/// 
/// Get the touch device name as reported from the driver or NULL if the index
/// is invalid.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const GetTouchName = SDL_GetTouchName;
extern fn SDL_GetTouchName(
    index: c_int,
) ?[*:0]const u8;

/// 
/// Get the type of the given touch device.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const GetTouchDeviceType = SDL_GetTouchDeviceType;
extern fn SDL_GetTouchDeviceType(
    touchID: SDL_TouchID,
) SDL_TouchDeviceType;

/// 
/// Get the number of active fingers for a given touch device.
/// 
/// \param touchID the ID of a touch device
/// \returns the number of active fingers for a given touch device on success
///          or 0 on failure; call SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_GetTouchFinger
/// 
/// 
pub const GetNumTouchFingers = SDL_GetNumTouchFingers;
extern fn SDL_GetNumTouchFingers(
    touchID: SDL_TouchID,
) c_int;

/// 
/// Get the finger object for specified touch device ID and finger index.
/// 
/// The returned resource is owned by SDL and should not be deallocated.
/// 
/// \param touchID the ID of the requested touch device
/// \param index the index of the requested finger
/// \returns a pointer to the SDL_Finger object or NULL if no object at the
///          given ID and index could be found.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const GetTouchFinger = SDL_GetTouchFinger;
extern fn SDL_GetTouchFinger(
    touchID: SDL_TouchID,
    index: c_int,
) ?*SDL_Finger;

/// 
/// Try to lock a spin lock by setting it to a non-zero value.
/// 
/// ***Please note that spinlocks are dangerous if you don't know what you're
/// doing. Please be careful using any sort of spinlock!***
/// 
/// \param lock a pointer to a lock variable
/// \returns SDL_TRUE if the lock succeeded, SDL_FALSE if the lock is already
///          held.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_AtomicLock
/// \sa SDL_AtomicUnlock
/// 
/// 
pub const AtomicTryLock = SDL_AtomicTryLock;
extern fn SDL_AtomicTryLock(
    lock: ?*SDL_SpinLock,
) bool;

/// 
/// Lock a spin lock by setting it to a non-zero value.
/// 
/// ***Please note that spinlocks are dangerous if you don't know what you're
/// doing. Please be careful using any sort of spinlock!***
/// 
/// \param lock a pointer to a lock variable
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_AtomicTryLock
/// \sa SDL_AtomicUnlock
/// 
/// 
pub const AtomicLock = SDL_AtomicLock;
extern fn SDL_AtomicLock(
    lock: ?*SDL_SpinLock,
) void;

/// 
/// Unlock a spin lock by setting it to 0.
/// 
/// Always returns immediately.
/// 
/// ***Please note that spinlocks are dangerous if you don't know what you're
/// doing. Please be careful using any sort of spinlock!***
/// 
/// \param lock a pointer to a lock variable
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_AtomicLock
/// \sa SDL_AtomicTryLock
/// 
/// 
pub const AtomicUnlock = SDL_AtomicUnlock;
extern fn SDL_AtomicUnlock(
    lock: ?*SDL_SpinLock,
) void;

/// 
/// Memory barriers are designed to prevent reads and writes from being
/// reordered by the compiler and being seen out of order on multi-core CPUs.
/// 
/// A typical pattern would be for thread A to write some data and a flag, and
/// for thread B to read the flag and get the data. In this case you would
/// insert a release barrier between writing the data and the flag,
/// guaranteeing that the data write completes no later than the flag is
/// written, and you would insert an acquire barrier between reading the flag
/// and reading the data, to ensure that all the reads associated with the flag
/// have completed.
/// 
/// In this pattern you should always see a release barrier paired with an
/// acquire barrier and you should gate the data reads/writes with a single
/// flag variable.
/// 
/// For more information on these semantics, take a look at the blog post:
/// http://preshing.com/20120913/acquire-and-release-semantics
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const MemoryBarrierReleaseFunction = SDL_MemoryBarrierReleaseFunction;
extern fn SDL_MemoryBarrierReleaseFunction() void;

/// 
pub const MemoryBarrierAcquireFunction = SDL_MemoryBarrierAcquireFunction;
extern fn SDL_MemoryBarrierAcquireFunction() void;

/// 
/// Set an atomic variable to a new value if it is currently an old value.
/// 
/// ***Note: If you don't know what this function is for, you shouldn't use
/// it!***
/// 
/// \param a a pointer to an SDL_atomic_t variable to be modified
/// \param oldval the old value
/// \param newval the new value
/// \returns SDL_TRUE if the atomic variable was set, SDL_FALSE otherwise.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_AtomicCASPtr
/// \sa SDL_AtomicGet
/// \sa SDL_AtomicSet
/// 
/// 
pub const AtomicCAS = SDL_AtomicCAS;
extern fn SDL_AtomicCAS(
    a: ?*SDL_atomic_t,
    oldval: c_int,
    newval: c_int,
) bool;

/// 
/// Set an atomic variable to a value.
/// 
/// This function also acts as a full memory barrier.
/// 
/// ***Note: If you don't know what this function is for, you shouldn't use
/// it!***
/// 
/// \param a a pointer to an SDL_atomic_t variable to be modified
/// \param v the desired value
/// \returns the previous value of the atomic variable.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_AtomicGet
/// 
/// 
pub const AtomicSet = SDL_AtomicSet;
extern fn SDL_AtomicSet(
    a: ?*SDL_atomic_t,
    v: c_int,
) c_int;

/// 
/// Get the value of an atomic variable.
/// 
/// ***Note: If you don't know what this function is for, you shouldn't use
/// it!***
/// 
/// \param a a pointer to an SDL_atomic_t variable
/// \returns the current value of an atomic variable.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_AtomicSet
/// 
/// 
pub const AtomicGet = SDL_AtomicGet;
extern fn SDL_AtomicGet(
    a: ?*SDL_atomic_t,
) c_int;

/// 
/// Add to an atomic variable.
/// 
/// This function also acts as a full memory barrier.
/// 
/// ***Note: If you don't know what this function is for, you shouldn't use
/// it!***
/// 
/// \param a a pointer to an SDL_atomic_t variable to be modified
/// \param v the desired value to add
/// \returns the previous value of the atomic variable.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_AtomicDecRef
/// \sa SDL_AtomicIncRef
/// 
/// 
pub const AtomicAdd = SDL_AtomicAdd;
extern fn SDL_AtomicAdd(
    a: ?*SDL_atomic_t,
    v: c_int,
) c_int;

/// 
/// Set a pointer to a new value if it is currently an old value.
/// 
/// ***Note: If you don't know what this function is for, you shouldn't use
/// it!***
/// 
/// \param a a pointer to a pointer
/// \param oldval the old pointer value
/// \param newval the new pointer value
/// \returns SDL_TRUE if the pointer was set, SDL_FALSE otherwise.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_AtomicCAS
/// \sa SDL_AtomicGetPtr
/// \sa SDL_AtomicSetPtr
/// 
/// 
pub const AtomicCASPtr = SDL_AtomicCASPtr;
extern fn SDL_AtomicCASPtr(
    a: [*c][*c]anyopaque,
    oldval: ?*anyopaque,
    newval: ?*anyopaque,
) bool;

/// 
/// Set a pointer to a value atomically.
/// 
/// ***Note: If you don't know what this function is for, you shouldn't use
/// it!***
/// 
/// \param a a pointer to a pointer
/// \param v the desired pointer value
/// \returns the previous value of the pointer.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_AtomicCASPtr
/// \sa SDL_AtomicGetPtr
/// 
/// 
pub const AtomicSetPtr = SDL_AtomicSetPtr;
extern fn SDL_AtomicSetPtr(
    a: [*c][*c]anyopaque,
    v: ?*anyopaque,
) ?*anyopaque;

/// 
/// Get the value of a pointer atomically.
/// 
/// ***Note: If you don't know what this function is for, you shouldn't use
/// it!***
/// 
/// \param a a pointer to a pointer
/// \returns the current value of a pointer.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_AtomicCASPtr
/// \sa SDL_AtomicSetPtr
/// 
/// 
pub const AtomicGetPtr = SDL_AtomicGetPtr;
extern fn SDL_AtomicGetPtr(
    a: [*c][*c]anyopaque,
) ?*anyopaque;

/// 
/// Pump the event loop, gathering events from the input devices.
/// 
/// This function updates the event queue and internal input device state.
/// 
/// **WARNING**: This should only be run in the thread that initialized the
/// video subsystem, and for extra safety, you should consider only doing those
/// things on the main thread in any case.
/// 
/// SDL_PumpEvents() gathers all the pending input information from devices and
/// places it in the event queue. Without calls to SDL_PumpEvents() no events
/// would ever be placed on the queue. Often the need for calls to
/// SDL_PumpEvents() is hidden from the user since SDL_PollEvent() and
/// SDL_WaitEvent() implicitly call SDL_PumpEvents(). However, if you are not
/// polling or waiting for events (e.g. you are filtering them), then you must
/// call SDL_PumpEvents() to force an event queue update.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_PollEvent
/// \sa SDL_WaitEvent
/// 
/// 
pub const PumpEvents = SDL_PumpEvents;
extern fn SDL_PumpEvents() void;

/// 
/// Check the event queue for messages and optionally return them.
/// 
/// `action` may be any of the following:
/// 
/// - `SDL_ADDEVENT`: up to `numevents` events will be added to the back of the
///   event queue.
/// - `SDL_PEEKEVENT`: `numevents` events at the front of the event queue,
///   within the specified minimum and maximum type, will be returned to the
///   caller and will _not_ be removed from the queue.
/// - `SDL_GETEVENT`: up to `numevents` events at the front of the event queue,
///   within the specified minimum and maximum type, will be returned to the
///   caller and will be removed from the queue.
/// 
/// You may have to call SDL_PumpEvents() before calling this function.
/// Otherwise, the events may not be ready to be filtered when you call
/// SDL_PeepEvents().
/// 
/// This function is thread-safe.
/// 
/// \param events destination buffer for the retrieved events
/// \param numevents if action is SDL_ADDEVENT, the number of events to add
///                  back to the event queue; if action is SDL_PEEKEVENT or
///                  SDL_GETEVENT, the maximum number of events to retrieve
/// \param action action to take; see [[#action|Remarks]] for details
/// \param minType minimum value of the event type to be considered;
///                SDL_FIRSTEVENT is a safe choice
/// \param maxType maximum value of the event type to be considered;
///                SDL_LASTEVENT is a safe choice
/// \returns the number of events actually stored or a negative error code on
///          failure; call SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_PollEvent
/// \sa SDL_PumpEvents
/// \sa SDL_PushEvent
/// 
/// 
pub const PeepEvents = SDL_PeepEvents;
extern fn SDL_PeepEvents(
    events: ?*SDL_Event,
    numevents: c_int,
    action: SDL_eventaction,
    minType: u32,
    maxType: u32,
) c_int;

/// 
/// Check for the existence of a certain event type in the event queue.
/// 
/// If you need to check for a range of event types, use SDL_HasEvents()
/// instead.
/// 
/// \param type the type of event to be queried; see SDL_EventType for details
/// \returns SDL_TRUE if events matching `type` are present, or SDL_FALSE if
///          events matching `type` are not present.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_HasEvents
/// 
/// 
pub const HasEvent = SDL_HasEvent;
extern fn SDL_HasEvent(
    type: u32,
) bool;

/// 
/// Check for the existence of certain event types in the event queue.
/// 
/// If you need to check for a single event type, use SDL_HasEvent() instead.
/// 
/// \param minType the low end of event type to be queried, inclusive; see
///                SDL_EventType for details
/// \param maxType the high end of event type to be queried, inclusive; see
///                SDL_EventType for details
/// \returns SDL_TRUE if events with type >= `minType` and <= `maxType` are
///          present, or SDL_FALSE if not.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_HasEvents
/// 
/// 
pub const HasEvents = SDL_HasEvents;
extern fn SDL_HasEvents(
    minType: u32,
    maxType: u32,
) bool;

/// 
/// Clear events of a specific type from the event queue.
/// 
/// This will unconditionally remove any events from the queue that match
/// `type`. If you need to remove a range of event types, use SDL_FlushEvents()
/// instead.
/// 
/// It's also normal to just ignore events you don't care about in your event
/// loop without calling this function.
/// 
/// This function only affects currently queued events. If you want to make
/// sure that all pending OS events are flushed, you can call SDL_PumpEvents()
/// on the main thread immediately before the flush call.
/// 
/// \param type the type of event to be cleared; see SDL_EventType for details
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_FlushEvents
/// 
/// 
pub const FlushEvent = SDL_FlushEvent;
extern fn SDL_FlushEvent(
    type: u32,
) void;

/// 
/// Clear events of a range of types from the event queue.
/// 
/// This will unconditionally remove any events from the queue that are in the
/// range of `minType` to `maxType`, inclusive. If you need to remove a single
/// event type, use SDL_FlushEvent() instead.
/// 
/// It's also normal to just ignore events you don't care about in your event
/// loop without calling this function.
/// 
/// This function only affects currently queued events. If you want to make
/// sure that all pending OS events are flushed, you can call SDL_PumpEvents()
/// on the main thread immediately before the flush call.
/// 
/// \param minType the low end of event type to be cleared, inclusive; see
///                SDL_EventType for details
/// \param maxType the high end of event type to be cleared, inclusive; see
///                SDL_EventType for details
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_FlushEvent
/// 
/// 
pub const FlushEvents = SDL_FlushEvents;
extern fn SDL_FlushEvents(
    minType: u32,
    maxType: u32,
) void;

/// 
/// Poll for currently pending events.
/// 
/// If `event` is not NULL, the next event is removed from the queue and stored
/// in the SDL_Event structure pointed to by `event`. The 1 returned refers to
/// this event, immediately stored in the SDL Event structure -- not an event
/// to follow.
/// 
/// If `event` is NULL, it simply returns 1 if there is an event in the queue,
/// but will not remove it from the queue.
/// 
/// As this function may implicitly call SDL_PumpEvents(), you can only call
/// this function in the thread that set the video mode.
/// 
/// SDL_PollEvent() is the favored way of receiving system events since it can
/// be done from the main loop and does not suspend the main loop while waiting
/// on an event to be posted.
/// 
/// The common practice is to fully process the event queue once every frame,
/// usually as a first step before updating the game's state:
/// 
/// ```c
/// while (game_is_still_running) {
///     SDL_Event event;
///     while (SDL_PollEvent(&event)) {  // poll until all events are handled!
///         // decide what to do with this event.
///     }
/// 
///     // update game state, draw the current frame
/// }
/// ```
/// 
/// \param event the SDL_Event structure to be filled with the next event from
///              the queue, or NULL
/// \returns 1 if there is a pending event or 0 if there are none available.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_GetEventFilter
/// \sa SDL_PeepEvents
/// \sa SDL_PushEvent
/// \sa SDL_SetEventFilter
/// \sa SDL_WaitEvent
/// \sa SDL_WaitEventTimeout
/// 
/// 
pub const PollEvent = SDL_PollEvent;
extern fn SDL_PollEvent(
    event: ?*SDL_Event,
) c_int;

/// 
/// Wait indefinitely for the next available event.
/// 
/// If `event` is not NULL, the next event is removed from the queue and stored
/// in the SDL_Event structure pointed to by `event`.
/// 
/// As this function may implicitly call SDL_PumpEvents(), you can only call
/// this function in the thread that initialized the video subsystem.
/// 
/// \param event the SDL_Event structure to be filled in with the next event
///              from the queue, or NULL
/// \returns 1 on success or 0 if there was an error while waiting for events;
///          call SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_PollEvent
/// \sa SDL_PumpEvents
/// \sa SDL_WaitEventTimeout
/// 
/// 
pub const WaitEvent = SDL_WaitEvent;
extern fn SDL_WaitEvent(
    event: ?*SDL_Event,
) c_int;

/// 
/// Wait until the specified timeout (in milliseconds) for the next available
/// event.
/// 
/// If `event` is not NULL, the next event is removed from the queue and stored
/// in the SDL_Event structure pointed to by `event`.
/// 
/// As this function may implicitly call SDL_PumpEvents(), you can only call
/// this function in the thread that initialized the video subsystem.
/// 
/// The timeout is not guaranteed, the actual wait time could be longer
/// due to system scheduling.
/// 
/// \param event the SDL_Event structure to be filled in with the next event
///              from the queue, or NULL
/// \param timeoutMS the maximum number of milliseconds to wait for the next
///                  available event
/// \returns 1 on success or 0 if there was an error while waiting for events;
///          call SDL_GetError() for more information. This also returns 0 if
///          the timeout elapsed without an event arriving.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_PollEvent
/// \sa SDL_PumpEvents
/// \sa SDL_WaitEvent
/// 
/// 
pub const WaitEventTimeout = SDL_WaitEventTimeout;
extern fn SDL_WaitEventTimeout(
    event: ?*SDL_Event,
    timeoutMS: i32,
) c_int;

/// 
/// Add an event to the event queue.
/// 
/// The event queue can actually be used as a two way communication channel.
/// Not only can events be read from the queue, but the user can also push
/// their own events onto it. `event` is a pointer to the event structure you
/// wish to push onto the queue. The event is copied into the queue, and the
/// caller may dispose of the memory pointed to after SDL_PushEvent() returns.
/// 
/// Note: Pushing device input events onto the queue doesn't modify the state
/// of the device within SDL.
/// 
/// This function is thread-safe, and can be called from other threads safely.
/// 
/// Note: Events pushed onto the queue with SDL_PushEvent() get passed through
/// the event filter but events added with SDL_PeepEvents() do not.
/// 
/// For pushing application-specific events, please use SDL_RegisterEvents() to
/// get an event type that does not conflict with other code that also wants
/// its own custom event types.
/// 
/// \param event the SDL_Event to be added to the queue
/// \returns 1 on success, 0 if the event was filtered, or a negative error
///          code on failure; call SDL_GetError() for more information. A
///          common reason for error is the event queue being full.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_PeepEvents
/// \sa SDL_PollEvent
/// \sa SDL_RegisterEvents
/// 
/// 
pub const PushEvent = SDL_PushEvent;
extern fn SDL_PushEvent(
    event: ?*SDL_Event,
) c_int;

/// 
/// Set up a filter to process all events before they change internal state and
/// are posted to the internal event queue.
/// 
/// If the filter function returns 1 when called, then the event will be added
/// to the internal queue. If it returns 0, then the event will be dropped from
/// the queue, but the internal state will still be updated. This allows
/// selective filtering of dynamically arriving events.
/// 
/// **WARNING**: Be very careful of what you do in the event filter function,
/// as it may run in a different thread!
/// 
/// On platforms that support it, if the quit event is generated by an
/// interrupt signal (e.g. pressing Ctrl-C), it will be delivered to the
/// application at the next event poll.
/// 
/// There is one caveat when dealing with the ::SDL_QuitEvent event type. The
/// event filter is only called when the window manager desires to close the
/// application window. If the event filter returns 1, then the window will be
/// closed, otherwise the window will remain open if possible.
/// 
/// Note: Disabled events never make it to the event filter function; see
/// SDL_SetEventEnabled().
/// 
/// Note: If you just want to inspect events without filtering, you should use
/// SDL_AddEventWatch() instead.
/// 
/// Note: Events pushed onto the queue with SDL_PushEvent() get passed through
/// the event filter, but events pushed onto the queue with SDL_PeepEvents() do
/// not.
/// 
/// \param filter An SDL_EventFilter function to call when an event happens
/// \param userdata a pointer that is passed to `filter`
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_AddEventWatch
/// \sa SDL_SetEventEnabled
/// \sa SDL_GetEventFilter
/// \sa SDL_PeepEvents
/// \sa SDL_PushEvent
/// 
/// 
pub const SetEventFilter = SDL_SetEventFilter;
extern fn SDL_SetEventFilter(
    filter: SDL_EventFilter,
    userdata: ?*anyopaque,
) void;

/// 
/// Query the current event filter.
/// 
/// This function can be used to "chain" filters, by saving the existing filter
/// before replacing it with a function that will call that saved filter.
/// 
/// \param filter the current callback function will be stored here
/// \param userdata the pointer that is passed to the current event filter will
///                 be stored here
/// \returns SDL_TRUE on success or SDL_FALSE if there is no event filter set.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_SetEventFilter
/// 
/// 
pub const GetEventFilter = SDL_GetEventFilter;
extern fn SDL_GetEventFilter(
    filter: ?*SDL_EventFilter,
    userdata: [*c][*c]anyopaque,
) bool;

/// 
/// Add a callback to be triggered when an event is added to the event queue.
/// 
/// `filter` will be called when an event happens, and its return value is
/// ignored.
/// 
/// **WARNING**: Be very careful of what you do in the event filter function,
/// as it may run in a different thread!
/// 
/// If the quit event is generated by a signal (e.g. SIGINT), it will bypass
/// the internal queue and be delivered to the watch callback immediately, and
/// arrive at the next event poll.
/// 
/// Note: the callback is called for events posted by the user through
/// SDL_PushEvent(), but not for disabled events, nor for events by a filter
/// callback set with SDL_SetEventFilter(), nor for events posted by the user
/// through SDL_PeepEvents().
/// 
/// \param filter an SDL_EventFilter function to call when an event happens.
/// \param userdata a pointer that is passed to `filter`
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_DelEventWatch
/// \sa SDL_SetEventFilter
/// 
/// 
pub const AddEventWatch = SDL_AddEventWatch;
extern fn SDL_AddEventWatch(
    filter: SDL_EventFilter,
    userdata: ?*anyopaque,
) void;

/// 
/// Remove an event watch callback added with SDL_AddEventWatch().
/// 
/// This function takes the same input as SDL_AddEventWatch() to identify and
/// delete the corresponding callback.
/// 
/// \param filter the function originally passed to SDL_AddEventWatch()
/// \param userdata the pointer originally passed to SDL_AddEventWatch()
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_AddEventWatch
/// 
/// 
pub const DelEventWatch = SDL_DelEventWatch;
extern fn SDL_DelEventWatch(
    filter: SDL_EventFilter,
    userdata: ?*anyopaque,
) void;

/// 
/// Run a specific filter function on the current event queue, removing any
/// events for which the filter returns 0.
/// 
/// See SDL_SetEventFilter() for more information. Unlike SDL_SetEventFilter(),
/// this function does not change the filter permanently, it only uses the
/// supplied filter until this function returns.
/// 
/// \param filter the SDL_EventFilter function to call when an event happens
/// \param userdata a pointer that is passed to `filter`
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_GetEventFilter
/// \sa SDL_SetEventFilter
/// 
/// 
pub const FilterEvents = SDL_FilterEvents;
extern fn SDL_FilterEvents(
    filter: SDL_EventFilter,
    userdata: ?*anyopaque,
) void;

/// 
/// Set the state of processing events by type.
/// 
/// \param type the type of event; see SDL_EventType for details
/// \param enabled whether to process the event or not
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_IsEventEnabled
/// 
/// 
pub const SetEventEnabled = SDL_SetEventEnabled;
extern fn SDL_SetEventEnabled(
    type: u32,
    enabled: bool,
) void;

/// 
/// Query the state of processing events by type.
/// 
/// \param type the type of event; see SDL_EventType for details
/// \returns SDL_TRUE if the event is being processed, SDL_FALSE otherwise.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_SetEventEnabled
/// 
/// 
pub const EventEnabled = SDL_EventEnabled;
extern fn SDL_EventEnabled(
    type: u32,
) bool;

/// 
/// Allocate a set of user-defined events, and return the beginning event
/// number for that set of events.
/// 
/// Calling this function with `numevents` <= 0 is an error and will return
/// (Uint32)-1.
/// 
/// Note, (Uint32)-1 means the maximum unsigned 32-bit integer value (or
/// 0xFFFFFFFF), but is clearer to write.
/// 
/// \param numevents the number of events to be allocated
/// \returns the beginning event number, or (Uint32)-1 if there are not enough
///          user-defined events left.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_PushEvent
/// 
/// 
pub const RegisterEvents = SDL_RegisterEvents;
extern fn SDL_RegisterEvents(
    numevents: c_int,
) u32;

/// 
/// Locking for atomic access to the joystick API
/// 
/// The SDL joystick functions are thread-safe, however you can lock the joysticks
/// while processing to guarantee that the joystick list won't change and joystick
/// and gamepad events will not be delivered.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const LockJoysticks = SDL_LockJoysticks;
extern fn SDL_LockJoysticks() void;

/// 
/// Unlocking for atomic access to the joystick API
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const UnlockJoysticks = SDL_UnlockJoysticks;
extern fn SDL_UnlockJoysticks() void;

/// 
/// Get a list of currently connected joysticks.
/// 
/// \param count a pointer filled in with the number of joysticks returned
/// \returns a 0 terminated array of joystick instance IDs which should be freed with SDL_free(), or NULL on error; call SDL_GetError() for more details.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_OpenJoystick
/// 
/// 
pub const GetJoysticks = SDL_GetJoysticks;
extern fn SDL_GetJoysticks(
    count: *c_int,
) ?*SDL_JoystickID;

/// 
/// Get the implementation dependent name of a joystick.
/// 
/// This can be called before any joysticks are opened.
/// 
/// \param instance_id the joystick instance ID
/// \returns the name of the selected joystick. If no name can be found, this
///          function returns NULL; call SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_GetJoystickName
/// \sa SDL_OpenJoystick
/// 
/// 
pub const GetJoystickInstanceName = SDL_GetJoystickInstanceName;
extern fn SDL_GetJoystickInstanceName(
    instance_id: SDL_JoystickID,
) ?[*:0]const u8;

/// 
/// Get the implementation dependent path of a joystick.
/// 
/// This can be called before any joysticks are opened.
/// 
/// \param instance_id the joystick instance ID
/// \returns the path of the selected joystick. If no path can be found, this
///          function returns NULL; call SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_GetJoystickPath
/// \sa SDL_OpenJoystick
/// 
/// 
pub const GetJoystickInstancePath = SDL_GetJoystickInstancePath;
extern fn SDL_GetJoystickInstancePath(
    instance_id: SDL_JoystickID,
) ?[*:0]const u8;

/// 
/// Get the player index of a joystick.
/// 
/// This can be called before any joysticks are opened.
/// 
/// \param instance_id the joystick instance ID
/// \returns the player index of a joystick, or -1 if it's not available
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_GetJoystickPlayerIndex
/// \sa SDL_OpenJoystick
/// 
/// 
pub const GetJoystickInstancePlayerIndex = SDL_GetJoystickInstancePlayerIndex;
extern fn SDL_GetJoystickInstancePlayerIndex(
    instance_id: SDL_JoystickID,
) c_int;

/// 
/// Get the implementation-dependent GUID of a joystick.
/// 
/// This can be called before any joysticks are opened.
/// 
/// \param instance_id the joystick instance ID
/// \returns the GUID of the selected joystick. If called on an invalid index,
///          this function returns a zero GUID
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_GetJoystickGUID
/// \sa SDL_GetJoystickGUIDString
/// 
/// 
pub const GetJoystickInstanceGUID = SDL_GetJoystickInstanceGUID;
extern fn SDL_GetJoystickInstanceGUID(
    instance_id: SDL_JoystickID,
) SDL_JoystickGUID;

/// 
/// Get the USB vendor ID of a joystick, if available.
/// 
/// This can be called before any joysticks are opened. If the vendor ID isn't
/// available this function returns 0.
/// 
/// \param instance_id the joystick instance ID
/// \returns the USB vendor ID of the selected joystick. If called on an
///          invalid index, this function returns zero
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const GetJoystickInstanceVendor = SDL_GetJoystickInstanceVendor;
extern fn SDL_GetJoystickInstanceVendor(
    instance_id: SDL_JoystickID,
) u16;

/// 
/// Get the USB product ID of a joystick, if available.
/// 
/// This can be called before any joysticks are opened. If the product ID isn't
/// available this function returns 0.
/// 
/// \param instance_id the joystick instance ID
/// \returns the USB product ID of the selected joystick. If called on an
///          invalid index, this function returns zero
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const GetJoystickInstanceProduct = SDL_GetJoystickInstanceProduct;
extern fn SDL_GetJoystickInstanceProduct(
    instance_id: SDL_JoystickID,
) u16;

/// 
/// Get the product version of a joystick, if available.
/// 
/// This can be called before any joysticks are opened. If the product version
/// isn't available this function returns 0.
/// 
/// \param instance_id the joystick instance ID
/// \returns the product version of the selected joystick. If called on an
///          invalid index, this function returns zero
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const GetJoystickInstanceProductVersion = SDL_GetJoystickInstanceProductVersion;
extern fn SDL_GetJoystickInstanceProductVersion(
    instance_id: SDL_JoystickID,
) u16;

/// 
/// Get the type of a joystick, if available.
/// 
/// This can be called before any joysticks are opened.
/// 
/// \param instance_id the joystick instance ID
/// \returns the SDL_JoystickType of the selected joystick. If called on an
///          invalid index, this function returns `SDL_JOYSTICK_TYPE_UNKNOWN`
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const GetJoystickInstanceType = SDL_GetJoystickInstanceType;
extern fn SDL_GetJoystickInstanceType(
    instance_id: SDL_JoystickID,
) SDL_JoystickType;

/// 
/// Open a joystick for use.
/// 
/// The joystick subsystem must be initialized before a joystick can be opened
/// for use.
/// 
/// \param instance_id the joystick instance ID
/// \returns a joystick identifier or NULL if an error occurred; call
///          SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_CloseJoystick
/// 
/// 
pub const OpenJoystick = SDL_OpenJoystick;
extern fn SDL_OpenJoystick(
    instance_id: SDL_JoystickID,
) ?*SDL_Joystick;

/// 
/// Get the SDL_Joystick associated with an instance ID.
/// 
/// \param instance_id the instance ID to get the SDL_Joystick for
/// \returns an SDL_Joystick on success or NULL on failure; call SDL_GetError()
///          for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const GetJoystickFromInstanceID = SDL_GetJoystickFromInstanceID;
extern fn SDL_GetJoystickFromInstanceID(
    instance_id: SDL_JoystickID,
) ?*SDL_Joystick;

/// 
/// Get the SDL_Joystick associated with a player index.
/// 
/// \param player_index the player index to get the SDL_Joystick for
/// \returns an SDL_Joystick on success or NULL on failure; call SDL_GetError()
///          for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const GetJoystickFromPlayerIndex = SDL_GetJoystickFromPlayerIndex;
extern fn SDL_GetJoystickFromPlayerIndex(
    player_index: c_int,
) ?*SDL_Joystick;

/// 
/// Attach a new virtual joystick.
/// 
/// \returns the joystick instance ID, or 0 if an error occurred; call SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const AttachVirtualJoystick = SDL_AttachVirtualJoystick;
extern fn SDL_AttachVirtualJoystick(
    type: SDL_JoystickType,
    naxes: c_int,
    nbuttons: c_int,
    nhats: c_int,
) SDL_JoystickID;

/// 
/// Attach a new virtual joystick with extended properties.
/// 
/// \returns the joystick instance ID, or 0 if an error occurred; call SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const AttachVirtualJoystickEx = SDL_AttachVirtualJoystickEx;
extern fn SDL_AttachVirtualJoystickEx(
    desc: ?*const SDL_VirtualJoystickDesc,
) SDL_JoystickID;

/// 
/// Detach a virtual joystick.
/// 
/// \param instance_id the joystick instance ID, previously returned from SDL_AttachVirtualJoystick()
/// \returns 0 on success, or -1 if an error occurred.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const DetachVirtualJoystick = SDL_DetachVirtualJoystick;
extern fn SDL_DetachVirtualJoystick(
    instance_id: SDL_JoystickID,
) c_int;

/// 
/// Query whether or not a joystick is virtual.
/// 
/// \param instance_id the joystick instance ID
/// \returns SDL_TRUE if the joystick is virtual, SDL_FALSE otherwise.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const IsJoystickVirtual = SDL_IsJoystickVirtual;
extern fn SDL_IsJoystickVirtual(
    instance_id: SDL_JoystickID,
) bool;

/// 
/// Set values on an opened, virtual-joystick's axis.
/// 
/// Please note that values set here will not be applied until the next call to
/// SDL_UpdateJoysticks, which can either be called directly, or can be called
/// indirectly through various other SDL APIs, including, but not limited to
/// the following: SDL_PollEvent, SDL_PumpEvents, SDL_WaitEventTimeout,
/// SDL_WaitEvent.
/// 
/// Note that when sending trigger axes, you should scale the value to the full
/// range of Sint16. For example, a trigger at rest would have the value of
/// `SDL_JOYSTICK_AXIS_MIN`.
/// 
/// \param joystick the virtual joystick on which to set state.
/// \param axis the specific axis on the virtual joystick to set.
/// \param value the new value for the specified axis.
/// \returns 0 on success, -1 on error.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const SetJoystickVirtualAxis = SDL_SetJoystickVirtualAxis;
extern fn SDL_SetJoystickVirtualAxis(
    joystick: ?*SDL_Joystick,
    axis: c_int,
    value: i16,
) c_int;

/// 
/// Set values on an opened, virtual-joystick's button.
/// 
/// Please note that values set here will not be applied until the next call to
/// SDL_UpdateJoysticks, which can either be called directly, or can be called
/// indirectly through various other SDL APIs, including, but not limited to
/// the following: SDL_PollEvent, SDL_PumpEvents, SDL_WaitEventTimeout,
/// SDL_WaitEvent.
/// 
/// \param joystick the virtual joystick on which to set state.
/// \param button the specific button on the virtual joystick to set.
/// \param value the new value for the specified button.
/// \returns 0 on success, -1 on error.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const SetJoystickVirtualButton = SDL_SetJoystickVirtualButton;
extern fn SDL_SetJoystickVirtualButton(
    joystick: ?*SDL_Joystick,
    button: c_int,
    value: u8,
) c_int;

/// 
/// Set values on an opened, virtual-joystick's hat.
/// 
/// Please note that values set here will not be applied until the next call to
/// SDL_UpdateJoysticks, which can either be called directly, or can be called
/// indirectly through various other SDL APIs, including, but not limited to
/// the following: SDL_PollEvent, SDL_PumpEvents, SDL_WaitEventTimeout,
/// SDL_WaitEvent.
/// 
/// \param joystick the virtual joystick on which to set state.
/// \param hat the specific hat on the virtual joystick to set.
/// \param value the new value for the specified hat.
/// \returns 0 on success, -1 on error.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const SetJoystickVirtualHat = SDL_SetJoystickVirtualHat;
extern fn SDL_SetJoystickVirtualHat(
    joystick: ?*SDL_Joystick,
    hat: c_int,
    value: u8,
) c_int;

/// 
/// Get the implementation dependent name of a joystick.
/// 
/// \param joystick the SDL_Joystick obtained from SDL_OpenJoystick()
/// \returns the name of the selected joystick. If no name can be found, this
///          function returns NULL; call SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_GetJoystickInstanceName
/// \sa SDL_OpenJoystick
/// 
/// 
pub const GetJoystickName = SDL_GetJoystickName;
extern fn SDL_GetJoystickName(
    joystick: ?*SDL_Joystick,
) ?[*:0]const u8;

/// 
/// Get the implementation dependent path of a joystick.
/// 
/// \param joystick the SDL_Joystick obtained from SDL_OpenJoystick()
/// \returns the path of the selected joystick. If no path can be found, this
///          function returns NULL; call SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_GetJoystickInstancePath
/// 
/// 
pub const GetJoystickPath = SDL_GetJoystickPath;
extern fn SDL_GetJoystickPath(
    joystick: ?*SDL_Joystick,
) ?[*:0]const u8;

/// 
/// Get the player index of an opened joystick.
/// 
/// For XInput controllers this returns the XInput user index. Many joysticks
/// will not be able to supply this information.
/// 
/// \param joystick the SDL_Joystick obtained from SDL_OpenJoystick()
/// \returns the player index, or -1 if it's not available.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const GetJoystickPlayerIndex = SDL_GetJoystickPlayerIndex;
extern fn SDL_GetJoystickPlayerIndex(
    joystick: ?*SDL_Joystick,
) c_int;

/// 
/// Set the player index of an opened joystick.
/// 
/// \param joystick the SDL_Joystick obtained from SDL_OpenJoystick()
/// \param player_index Player index to assign to this joystick, or -1 to clear
///                     the player index and turn off player LEDs.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const SetJoystickPlayerIndex = SDL_SetJoystickPlayerIndex;
extern fn SDL_SetJoystickPlayerIndex(
    joystick: ?*SDL_Joystick,
    player_index: c_int,
) void;

/// 
/// Get the implementation-dependent GUID for the joystick.
/// 
/// This function requires an open joystick.
/// 
/// \param joystick the SDL_Joystick obtained from SDL_OpenJoystick()
/// \returns the GUID of the given joystick. If called on an invalid index,
///          this function returns a zero GUID; call SDL_GetError() for more
///          information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_GetJoystickInstanceGUID
/// \sa SDL_GetJoystickGUIDString
/// 
/// 
pub const GetJoystickGUID = SDL_GetJoystickGUID;
extern fn SDL_GetJoystickGUID(
    joystick: ?*SDL_Joystick,
) SDL_JoystickGUID;

/// 
/// Get the USB vendor ID of an opened joystick, if available.
/// 
/// If the vendor ID isn't available this function returns 0.
/// 
/// \param joystick the SDL_Joystick obtained from SDL_OpenJoystick()
/// \returns the USB vendor ID of the selected joystick, or 0 if unavailable.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const GetJoystickVendor = SDL_GetJoystickVendor;
extern fn SDL_GetJoystickVendor(
    joystick: ?*SDL_Joystick,
) u16;

/// 
/// Get the USB product ID of an opened joystick, if available.
/// 
/// If the product ID isn't available this function returns 0.
/// 
/// \param joystick the SDL_Joystick obtained from SDL_OpenJoystick()
/// \returns the USB product ID of the selected joystick, or 0 if unavailable.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const GetJoystickProduct = SDL_GetJoystickProduct;
extern fn SDL_GetJoystickProduct(
    joystick: ?*SDL_Joystick,
) u16;

/// 
/// Get the product version of an opened joystick, if available.
/// 
/// If the product version isn't available this function returns 0.
/// 
/// \param joystick the SDL_Joystick obtained from SDL_OpenJoystick()
/// \returns the product version of the selected joystick, or 0 if unavailable.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const GetJoystickProductVersion = SDL_GetJoystickProductVersion;
extern fn SDL_GetJoystickProductVersion(
    joystick: ?*SDL_Joystick,
) u16;

/// 
/// Get the firmware version of an opened joystick, if available.
/// 
/// If the firmware version isn't available this function returns 0.
/// 
/// \param joystick the SDL_Joystick obtained from SDL_OpenJoystick()
/// \returns the firmware version of the selected joystick, or 0 if
///          unavailable.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const GetJoystickFirmwareVersion = SDL_GetJoystickFirmwareVersion;
extern fn SDL_GetJoystickFirmwareVersion(
    joystick: ?*SDL_Joystick,
) u16;

/// 
/// Get the serial number of an opened joystick, if available.
/// 
/// Returns the serial number of the joystick, or NULL if it is not available.
/// 
/// \param joystick the SDL_Joystick obtained from SDL_OpenJoystick()
/// \returns the serial number of the selected joystick, or NULL if
///          unavailable.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const GetJoystickSerial = SDL_GetJoystickSerial;
extern fn SDL_GetJoystickSerial(
    joystick: ?*SDL_Joystick,
) ?[*:0]const u8;

/// 
/// Get the type of an opened joystick.
/// 
/// \param joystick the SDL_Joystick obtained from SDL_OpenJoystick()
/// \returns the SDL_JoystickType of the selected joystick.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const GetJoystickType = SDL_GetJoystickType;
extern fn SDL_GetJoystickType(
    joystick: ?*SDL_Joystick,
) SDL_JoystickType;

/// 
/// Get an ASCII string representation for a given SDL_JoystickGUID.
/// 
/// You should supply at least 33 bytes for pszGUID.
/// 
/// \param guid the SDL_JoystickGUID you wish to convert to string
/// \param pszGUID buffer in which to write the ASCII string
/// \param cbGUID the size of pszGUID
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_GetJoystickInstanceGUID
/// \sa SDL_GetJoystickGUID
/// \sa SDL_GetJoystickGUIDFromString
/// 
/// 
pub const GetJoystickGUIDString = SDL_GetJoystickGUIDString;
extern fn SDL_GetJoystickGUIDString(
    guid: SDL_JoystickGUID,
    pszGUID: ?[*:0]u8,
    cbGUID: c_int,
) void;

/// 
/// Convert a GUID string into a SDL_JoystickGUID structure.
/// 
/// Performs no error checking. If this function is given a string containing
/// an invalid GUID, the function will silently succeed, but the GUID generated
/// will not be useful.
/// 
/// \param pchGUID string containing an ASCII representation of a GUID
/// \returns a SDL_JoystickGUID structure.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_GetJoystickGUIDString
/// 
/// 
pub const GetJoystickGUIDFromString = SDL_GetJoystickGUIDFromString;
extern fn SDL_GetJoystickGUIDFromString(
    pchGUID: ?[*:0]const u8,
) SDL_JoystickGUID;

/// 
/// Get the device information encoded in a SDL_JoystickGUID structure
/// 
/// \param guid the SDL_JoystickGUID you wish to get info about
/// \param vendor A pointer filled in with the device VID, or 0 if not
///               available
/// \param product A pointer filled in with the device PID, or 0 if not
///                available
/// \param version A pointer filled in with the device version, or 0 if not
///                available
/// \param crc16 A pointer filled in with a CRC used to distinguish different
///              products with the same VID/PID, or 0 if not available
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_GetJoystickInstanceGUID
/// 
/// 
pub const GetJoystickGUIDInfo = SDL_GetJoystickGUIDInfo;
extern fn SDL_GetJoystickGUIDInfo(
    guid: SDL_JoystickGUID,
    vendor: ?[*c]u16,
    product: ?[*c]u16,
    version: ?[*c]u16,
    crc16: ?[*c]u16,
) void;

/// 
/// Get the status of a specified joystick.
/// 
/// \param joystick the joystick to query
/// \returns SDL_TRUE if the joystick has been opened, SDL_FALSE if it has not;
///          call SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_CloseJoystick
/// \sa SDL_OpenJoystick
/// 
/// 
pub const JoystickConnected = SDL_JoystickConnected;
extern fn SDL_JoystickConnected(
    joystick: ?*SDL_Joystick,
) bool;

/// 
/// Get the instance ID of an opened joystick.
/// 
/// \param joystick an SDL_Joystick structure containing joystick information
/// \returns the instance ID of the specified joystick on success or a negative
///          error code on failure; call SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_OpenJoystick
/// 
/// 
pub const GetJoystickInstanceID = SDL_GetJoystickInstanceID;
extern fn SDL_GetJoystickInstanceID(
    joystick: ?*SDL_Joystick,
) SDL_JoystickID;

/// 
/// Get the number of general axis controls on a joystick.
/// 
/// Often, the directional pad on a game controller will either look like 4
/// separate buttons or a POV hat, and not axes, but all of this is up to the
/// device and platform.
/// 
/// \param joystick an SDL_Joystick structure containing joystick information
/// \returns the number of axis controls/number of axes on success or a
///          negative error code on failure; call SDL_GetError() for more
///          information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_GetJoystickAxis
/// \sa SDL_OpenJoystick
/// 
/// 
pub const GetNumJoystickAxes = SDL_GetNumJoystickAxes;
extern fn SDL_GetNumJoystickAxes(
    joystick: ?*SDL_Joystick,
) c_int;

/// 
/// Get the number of POV hats on a joystick.
/// 
/// \param joystick an SDL_Joystick structure containing joystick information
/// \returns the number of POV hats on success or a negative error code on
///          failure; call SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_GetJoystickHat
/// \sa SDL_OpenJoystick
/// 
/// 
pub const GetNumJoystickHats = SDL_GetNumJoystickHats;
extern fn SDL_GetNumJoystickHats(
    joystick: ?*SDL_Joystick,
) c_int;

/// 
/// Get the number of buttons on a joystick.
/// 
/// \param joystick an SDL_Joystick structure containing joystick information
/// \returns the number of buttons on success or a negative error code on
///          failure; call SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_GetJoystickButton
/// \sa SDL_OpenJoystick
/// 
/// 
pub const GetNumJoystickButtons = SDL_GetNumJoystickButtons;
extern fn SDL_GetNumJoystickButtons(
    joystick: ?*SDL_Joystick,
) c_int;

/// 
/// Set the state of joystick event processing.
/// 
/// If joystick events are disabled, you must call SDL_UpdateJoysticks()
/// yourself and check the state of the joystick when you want joystick
/// information.
/// 
/// \param enabled whether to process joystick events or not
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_JoystickEventsEnabled
/// 
/// 
pub const SetJoystickEventsEnabled = SDL_SetJoystickEventsEnabled;
extern fn SDL_SetJoystickEventsEnabled(
    enabled: bool,
) void;

/// 
/// Query the state of joystick event processing.
/// 
/// If joystick events are disabled, you must call SDL_UpdateJoysticks()
/// yourself and check the state of the joystick when you want joystick
/// information.
/// 
/// \returns SDL_TRUE if joystick events are being processed, SDL_FALSE otherwise.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_SetJoystickEventsEnabled
/// 
/// 
pub const JoystickEventsEnabled = SDL_JoystickEventsEnabled;
extern fn SDL_JoystickEventsEnabled() bool;

/// 
/// Update the current state of the open joysticks.
/// 
/// This is called automatically by the event loop if any joystick events are
/// enabled.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const UpdateJoysticks = SDL_UpdateJoysticks;
extern fn SDL_UpdateJoysticks() void;

/// 
/// Get the current state of an axis control on a joystick.
/// 
/// SDL makes no promises about what part of the joystick any given axis refers
/// to. Your game should have some sort of configuration UI to let users
/// specify what each axis should be bound to. Alternately, SDL's higher-level
/// Game Controller API makes a great effort to apply order to this lower-level
/// interface, so you know that a specific axis is the "left thumb stick," etc.
/// 
/// The value returned by SDL_GetJoystickAxis() is a signed integer (-32768 to
/// 32767) representing the current position of the axis. It may be necessary
/// to impose certain tolerances on these values to account for jitter.
/// 
/// \param joystick an SDL_Joystick structure containing joystick information
/// \param axis the axis to query; the axis indices start at index 0
/// \returns a 16-bit signed integer representing the current position of the
///          axis or 0 on failure; call SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_GetNumJoystickAxes
/// 
/// 
pub const GetJoystickAxis = SDL_GetJoystickAxis;
extern fn SDL_GetJoystickAxis(
    joystick: ?*SDL_Joystick,
    axis: c_int,
) i16;

/// 
/// Get the initial state of an axis control on a joystick.
/// 
/// The state is a value ranging from -32768 to 32767.
/// 
/// The axis indices start at index 0.
/// 
/// \param joystick an SDL_Joystick structure containing joystick information
/// \param axis the axis to query; the axis indices start at index 0
/// \param state Upon return, the initial value is supplied here.
/// \return SDL_TRUE if this axis has any initial value, or SDL_FALSE if not.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const GetJoystickAxisInitialState = SDL_GetJoystickAxisInitialState;
extern fn SDL_GetJoystickAxisInitialState(
    joystick: ?*SDL_Joystick,
    axis: c_int,
    state: ?[*c]i16,
) bool;

/// 
/// Get the current state of a POV hat on a joystick.
/// 
/// The returned value will be one of the following positions:
/// 
/// - `SDL_HAT_CENTERED`
/// - `SDL_HAT_UP`
/// - `SDL_HAT_RIGHT`
/// - `SDL_HAT_DOWN`
/// - `SDL_HAT_LEFT`
/// - `SDL_HAT_RIGHTUP`
/// - `SDL_HAT_RIGHTDOWN`
/// - `SDL_HAT_LEFTUP`
/// - `SDL_HAT_LEFTDOWN`
/// 
/// \param joystick an SDL_Joystick structure containing joystick information
/// \param hat the hat index to get the state from; indices start at index 0
/// \returns the current hat position.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_GetNumJoystickHats
/// 
/// 
pub const GetJoystickHat = SDL_GetJoystickHat;
extern fn SDL_GetJoystickHat(
    joystick: ?*SDL_Joystick,
    hat: c_int,
) u8;

/// 
/// Get the current state of a button on a joystick.
/// 
/// \param joystick an SDL_Joystick structure containing joystick information
/// \param button the button index to get the state from; indices start at
///               index 0
/// \returns 1 if the specified button is pressed, 0 otherwise.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_GetNumJoystickButtons
/// 
/// 
pub const GetJoystickButton = SDL_GetJoystickButton;
extern fn SDL_GetJoystickButton(
    joystick: ?*SDL_Joystick,
    button: c_int,
) u8;

/// 
/// Start a rumble effect.
/// 
/// Each call to this function cancels any previous rumble effect, and calling
/// it with 0 intensity stops any rumbling.
/// 
/// \param joystick The joystick to vibrate
/// \param low_frequency_rumble The intensity of the low frequency (left)
///                             rumble motor, from 0 to 0xFFFF
/// \param high_frequency_rumble The intensity of the high frequency (right)
///                              rumble motor, from 0 to 0xFFFF
/// \param duration_ms The duration of the rumble effect, in milliseconds
/// \returns 0, or -1 if rumble isn't supported on this joystick
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_JoystickHasRumble
/// 
/// 
pub const RumbleJoystick = SDL_RumbleJoystick;
extern fn SDL_RumbleJoystick(
    joystick: ?*SDL_Joystick,
    low_frequency_rumble: u16,
    high_frequency_rumble: u16,
    duration_ms: u32,
) c_int;

/// 
/// Start a rumble effect in the joystick's triggers
/// 
/// Each call to this function cancels any previous trigger rumble effect, and
/// calling it with 0 intensity stops any rumbling.
/// 
/// Note that this is rumbling of the _triggers_ and not the game controller as
/// a whole. This is currently only supported on Xbox One controllers. If you
/// want the (more common) whole-controller rumble, use SDL_RumbleJoystick()
/// instead.
/// 
/// \param joystick The joystick to vibrate
/// \param left_rumble The intensity of the left trigger rumble motor, from 0
///                    to 0xFFFF
/// \param right_rumble The intensity of the right trigger rumble motor, from 0
///                     to 0xFFFF
/// \param duration_ms The duration of the rumble effect, in milliseconds
/// \returns 0, or -1 if trigger rumble isn't supported on this joystick
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_JoystickHasRumbleTriggers
/// 
/// 
pub const RumbleJoystickTriggers = SDL_RumbleJoystickTriggers;
extern fn SDL_RumbleJoystickTriggers(
    joystick: ?*SDL_Joystick,
    left_rumble: u16,
    right_rumble: u16,
    duration_ms: u32,
) c_int;

/// 
/// Query whether a joystick has an LED.
/// 
/// An example of a joystick LED is the light on the back of a PlayStation 4's
/// DualShock 4 controller.
/// 
/// \param joystick The joystick to query
/// \return SDL_TRUE if the joystick has a modifiable LED, SDL_FALSE otherwise.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const JoystickHasLED = SDL_JoystickHasLED;
extern fn SDL_JoystickHasLED(
    joystick: ?*SDL_Joystick,
) bool;

/// 
/// Query whether a joystick has rumble support.
/// 
/// \param joystick The joystick to query
/// \return SDL_TRUE if the joystick has rumble, SDL_FALSE otherwise.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_RumbleJoystick
/// 
/// 
pub const JoystickHasRumble = SDL_JoystickHasRumble;
extern fn SDL_JoystickHasRumble(
    joystick: ?*SDL_Joystick,
) bool;

/// 
/// Query whether a joystick has rumble support on triggers.
/// 
/// \param joystick The joystick to query
/// \return SDL_TRUE if the joystick has trigger rumble, SDL_FALSE otherwise.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_RumbleJoystickTriggers
/// 
/// 
pub const JoystickHasRumbleTriggers = SDL_JoystickHasRumbleTriggers;
extern fn SDL_JoystickHasRumbleTriggers(
    joystick: ?*SDL_Joystick,
) bool;

/// 
/// Update a joystick's LED color.
/// 
/// An example of a joystick LED is the light on the back of a PlayStation 4's
/// DualShock 4 controller.
/// 
/// \param joystick The joystick to update
/// \param red The intensity of the red LED
/// \param green The intensity of the green LED
/// \param blue The intensity of the blue LED
/// \returns 0 on success, -1 if this joystick does not have a modifiable LED
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const SetJoystickLED = SDL_SetJoystickLED;
extern fn SDL_SetJoystickLED(
    joystick: ?*SDL_Joystick,
    red: u8,
    green: u8,
    blue: u8,
) c_int;

/// 
/// Send a joystick specific effect packet
/// 
/// \param joystick The joystick to affect
/// \param data The data to send to the joystick
/// \param size The size of the data to send to the joystick
/// \returns 0, or -1 if this joystick or driver doesn't support effect packets
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const SendJoystickEffect = SDL_SendJoystickEffect;
extern fn SDL_SendJoystickEffect(
    joystick: ?*SDL_Joystick,
    data: ?*const anyopaque,
    size: c_int,
) c_int;

/// 
/// Close a joystick previously opened with SDL_OpenJoystick().
/// 
/// \param joystick The joystick device to close
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_OpenJoystick
/// 
/// 
pub const CloseJoystick = SDL_CloseJoystick;
extern fn SDL_CloseJoystick(
    joystick: ?*SDL_Joystick,
) void;

/// 
/// Get the battery level of a joystick as SDL_JoystickPowerLevel.
/// 
/// \param joystick the SDL_Joystick to query
/// \returns the current battery level as SDL_JoystickPowerLevel on success or
///          `SDL_JOYSTICK_POWER_UNKNOWN` if it is unknown
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const GetJoystickPowerLevel = SDL_GetJoystickPowerLevel;
extern fn SDL_GetJoystickPowerLevel(
    joystick: ?*SDL_Joystick,
) SDL_JoystickPowerLevel;

/// /* Check to make sure enums are the size of ints, for structure packing.
///    For both Watcom C/C++ and Borland C/C++ the compiler option that makes
///    enums having the size of an int must be enabled.
///    This is "-b" for Borland C/C++ and "-ei" for Watcom C/C++ (v11).
/// */
/// 
pub const malloc = SDL_malloc;
extern fn SDL_malloc(
    size: usize,
) ?*anyopaque;

/// 
pub const calloc = SDL_calloc;
extern fn SDL_calloc(
    nmemb: usize,
    size: usize,
) ?*anyopaque;

/// 
pub const realloc = SDL_realloc;
extern fn SDL_realloc(
    mem: ?*anyopaque,
    size: usize,
) ?*anyopaque;

/// 
pub const free = SDL_free;
extern fn SDL_free(
    mem: ?*anyopaque,
) void;

/// 
/// Get the original set of SDL memory functions
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const GetOriginalMemoryFunctions = SDL_GetOriginalMemoryFunctions;
extern fn SDL_GetOriginalMemoryFunctions(
    malloc_func: ?*SDL_malloc_func,
    calloc_func: ?*SDL_calloc_func,
    realloc_func: ?*SDL_realloc_func,
    free_func: ?*SDL_free_func,
) void;

/// 
/// Get the current set of SDL memory functions
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const GetMemoryFunctions = SDL_GetMemoryFunctions;
extern fn SDL_GetMemoryFunctions(
    malloc_func: ?*SDL_malloc_func,
    calloc_func: ?*SDL_calloc_func,
    realloc_func: ?*SDL_realloc_func,
    free_func: ?*SDL_free_func,
) void;

/// 
/// Replace SDL's memory allocation functions with a custom set
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const SetMemoryFunctions = SDL_SetMemoryFunctions;
extern fn SDL_SetMemoryFunctions(
    malloc_func: SDL_malloc_func,
    calloc_func: SDL_calloc_func,
    realloc_func: SDL_realloc_func,
    free_func: SDL_free_func,
) c_int;

/// 
/// Allocate memory aligned to a specific value
/// 
/// If `alignment` is less than the size of `void *`, then it will be increased to match that.
/// 
/// The returned memory address will be a multiple of the alignment value, and the amount of memory allocated will be a multiple of the alignment value.
/// 
/// The memory returned by this function must be freed with SDL_aligned_free()
/// 
/// \param alignment the alignment requested
/// \param size the size to allocate
/// \returns a pointer to the aligned memory
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_aligned_free
/// 
/// 
pub const aligned_alloc = SDL_aligned_alloc;
extern fn SDL_aligned_alloc(
    alignment: usize,
    size: usize,
) ?*anyopaque;

/// 
/// Free memory allocated by SDL_aligned_alloc()
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_aligned_alloc
/// 
/// 
pub const aligned_free = SDL_aligned_free;
extern fn SDL_aligned_free(
    mem: ?*anyopaque,
) void;

/// 
/// Get the number of outstanding (unfreed) allocations
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const GetNumAllocations = SDL_GetNumAllocations;
extern fn SDL_GetNumAllocations() c_int;

/// 
pub const getenv = SDL_getenv;
extern fn SDL_getenv(
    name: ?[*:0]const u8,
) ?[*:0]u8;

/// 
pub const setenv = SDL_setenv;
extern fn SDL_setenv(
    name: ?[*:0]const u8,
    value: ?[*:0]const u8,
    overwrite: c_int,
) c_int;

/// 
pub const qsort = SDL_qsort;
extern fn SDL_qsort(
    base: ?*anyopaque,
    nmemb: usize,
    size: usize,
    compare: *const fn(?*const anyopaque, ?*const anyopaque) c_int,
) void;

/// 
pub const bsearch = SDL_bsearch;
extern fn SDL_bsearch(
    key: ?*const anyopaque,
    base: ?*const anyopaque,
    nmemb: usize,
    size: usize,
    compare: *const fn(?*const anyopaque, ?*const anyopaque) c_int,
) ?*anyopaque;

/// 
pub const abs = SDL_abs;
extern fn SDL_abs(
    x: c_int,
) c_int;

/// 
pub const isalpha = SDL_isalpha;
extern fn SDL_isalpha(
    x: c_int,
) c_int;

/// 
pub const isalnum = SDL_isalnum;
extern fn SDL_isalnum(
    x: c_int,
) c_int;

/// 
pub const isblank = SDL_isblank;
extern fn SDL_isblank(
    x: c_int,
) c_int;

/// 
pub const iscntrl = SDL_iscntrl;
extern fn SDL_iscntrl(
    x: c_int,
) c_int;

/// 
pub const isdigit = SDL_isdigit;
extern fn SDL_isdigit(
    x: c_int,
) c_int;

/// 
pub const isxdigit = SDL_isxdigit;
extern fn SDL_isxdigit(
    x: c_int,
) c_int;

/// 
pub const ispunct = SDL_ispunct;
extern fn SDL_ispunct(
    x: c_int,
) c_int;

/// 
pub const isspace = SDL_isspace;
extern fn SDL_isspace(
    x: c_int,
) c_int;

/// 
pub const isupper = SDL_isupper;
extern fn SDL_isupper(
    x: c_int,
) c_int;

/// 
pub const islower = SDL_islower;
extern fn SDL_islower(
    x: c_int,
) c_int;

/// 
pub const isprint = SDL_isprint;
extern fn SDL_isprint(
    x: c_int,
) c_int;

/// 
pub const isgraph = SDL_isgraph;
extern fn SDL_isgraph(
    x: c_int,
) c_int;

/// 
pub const toupper = SDL_toupper;
extern fn SDL_toupper(
    x: c_int,
) c_int;

/// 
pub const tolower = SDL_tolower;
extern fn SDL_tolower(
    x: c_int,
) c_int;

/// 
pub const crc16 = SDL_crc16;
extern fn SDL_crc16(
    crc: u16,
    data: ?*const anyopaque,
    len: usize,
) u16;

/// 
pub const crc32 = SDL_crc32;
extern fn SDL_crc32(
    crc: u32,
    data: ?*const anyopaque,
    len: usize,
) u32;

/// 
pub const memset = SDL_memset;
extern fn SDL_memset(
    param_name_not_specified: @panic("cannot translate SDL_OUT_BYTECAP ( SDL_OUT_BYTECAP ( len ) void * dst * ) void * dst"),
    c: c_int,
    len: usize,
) ?*anyopaque;

/// 
pub const memset4 = SDL_memset4;
extern fn SDL_memset4(
    dst: ?*anyopaque,
    val: u32,
    dwords: usize,
) ?*anyopaque;

/// 
pub const memcpy = SDL_memcpy;
extern fn SDL_memcpy(
    param_name_not_specified: @panic("cannot translate SDL_OUT_BYTECAP ( SDL_OUT_BYTECAP ( len ) void * dst * ) void * dst"),
    param_name_not_specified: @panic("cannot translate SDL_IN_BYTECAP ( SDL_IN_BYTECAP ( len ) const void * src * ) const void * src"),
    len: usize,
) ?*anyopaque;

/// 
pub const memmove = SDL_memmove;
extern fn SDL_memmove(
    param_name_not_specified: @panic("cannot translate SDL_OUT_BYTECAP ( SDL_OUT_BYTECAP ( len ) void * dst * ) void * dst"),
    param_name_not_specified: @panic("cannot translate SDL_IN_BYTECAP ( SDL_IN_BYTECAP ( len ) const void * src * ) const void * src"),
    len: usize,
) ?*anyopaque;

/// 
pub const memcmp = SDL_memcmp;
extern fn SDL_memcmp(
    s1: ?*const anyopaque,
    s2: ?*const anyopaque,
    len: usize,
) c_int;

/// 
pub const wcslen = SDL_wcslen;
extern fn SDL_wcslen(
    wstr: ?[*:0]const c_wchar,
) usize;

/// 
pub const wcslcpy = SDL_wcslcpy;
extern fn SDL_wcslcpy(
    param_name_not_specified: @panic("cannot translate SDL_OUT_Z_CAP ( SDL_OUT_Z_CAP ( maxlen ) wchar_t * dst * ) wchar_t * dst"),
    src: ?[*:0]const c_wchar,
    maxlen: usize,
) usize;

/// 
pub const wcslcat = SDL_wcslcat;
extern fn SDL_wcslcat(
    param_name_not_specified: @panic("cannot translate SDL_INOUT_Z_CAP ( SDL_INOUT_Z_CAP ( maxlen ) wchar_t * dst * ) wchar_t * dst"),
    src: ?[*:0]const c_wchar,
    maxlen: usize,
) usize;

/// 
pub const wcsdup = SDL_wcsdup;
extern fn SDL_wcsdup(
    wstr: ?[*:0]const c_wchar,
) ?[*:0]c_wchar;

/// 
pub const wcsstr = SDL_wcsstr;
extern fn SDL_wcsstr(
    haystack: ?[*:0]const c_wchar,
    needle: ?[*:0]const c_wchar,
) ?[*:0]c_wchar;

/// 
pub const wcscmp = SDL_wcscmp;
extern fn SDL_wcscmp(
    str1: ?[*:0]const c_wchar,
    str2: ?[*:0]const c_wchar,
) c_int;

/// 
pub const wcsncmp = SDL_wcsncmp;
extern fn SDL_wcsncmp(
    str1: ?[*:0]const c_wchar,
    str2: ?[*:0]const c_wchar,
    maxlen: usize,
) c_int;

/// 
pub const wcscasecmp = SDL_wcscasecmp;
extern fn SDL_wcscasecmp(
    str1: ?[*:0]const c_wchar,
    str2: ?[*:0]const c_wchar,
) c_int;

/// 
pub const wcsncasecmp = SDL_wcsncasecmp;
extern fn SDL_wcsncasecmp(
    str1: ?[*:0]const c_wchar,
    str2: ?[*:0]const c_wchar,
    len: usize,
) c_int;

/// 
pub const strlen = SDL_strlen;
extern fn SDL_strlen(
    str: ?[*:0]const u8,
) usize;

/// 
pub const strlcpy = SDL_strlcpy;
extern fn SDL_strlcpy(
    param_name_not_specified: @panic("cannot translate SDL_OUT_Z_CAP ( SDL_OUT_Z_CAP ( maxlen ) char * dst * ) char * dst"),
    src: ?[*:0]const u8,
    maxlen: usize,
) usize;

/// 
pub const utf8strlcpy = SDL_utf8strlcpy;
extern fn SDL_utf8strlcpy(
    param_name_not_specified: @panic("cannot translate SDL_OUT_Z_CAP ( SDL_OUT_Z_CAP ( dst_bytes ) char * dst * ) char * dst"),
    src: ?[*:0]const u8,
    dst_bytes: usize,
) usize;

/// 
pub const strlcat = SDL_strlcat;
extern fn SDL_strlcat(
    param_name_not_specified: @panic("cannot translate SDL_INOUT_Z_CAP ( SDL_INOUT_Z_CAP ( maxlen ) char * dst * ) char * dst"),
    src: ?[*:0]const u8,
    maxlen: usize,
) usize;

/// 
pub const strdup = SDL_strdup;
extern fn SDL_strdup(
    str: ?[*:0]const u8,
) ?[*:0]u8;

/// 
pub const strrev = SDL_strrev;
extern fn SDL_strrev(
    str: ?[*:0]u8,
) ?[*:0]u8;

/// 
pub const strupr = SDL_strupr;
extern fn SDL_strupr(
    str: ?[*:0]u8,
) ?[*:0]u8;

/// 
pub const strlwr = SDL_strlwr;
extern fn SDL_strlwr(
    str: ?[*:0]u8,
) ?[*:0]u8;

/// 
pub const strchr = SDL_strchr;
extern fn SDL_strchr(
    str: ?[*:0]const u8,
    c: c_int,
) ?[*:0]u8;

/// 
pub const strrchr = SDL_strrchr;
extern fn SDL_strrchr(
    str: ?[*:0]const u8,
    c: c_int,
) ?[*:0]u8;

/// 
pub const strstr = SDL_strstr;
extern fn SDL_strstr(
    haystack: ?[*:0]const u8,
    needle: ?[*:0]const u8,
) ?[*:0]u8;

/// 
pub const strcasestr = SDL_strcasestr;
extern fn SDL_strcasestr(
    haystack: ?[*:0]const u8,
    needle: ?[*:0]const u8,
) ?[*:0]u8;

/// 
pub const strtokr = SDL_strtokr;
extern fn SDL_strtokr(
    s1: ?[*:0]u8,
    s2: ?[*:0]const u8,
    saveptr: ?[*c][*c]u8,
) ?[*:0]u8;

/// 
pub const utf8strlen = SDL_utf8strlen;
extern fn SDL_utf8strlen(
    str: ?[*:0]const u8,
) usize;

/// 
pub const utf8strnlen = SDL_utf8strnlen;
extern fn SDL_utf8strnlen(
    str: ?[*:0]const u8,
    bytes: usize,
) usize;

/// 
pub const itoa = SDL_itoa;
extern fn SDL_itoa(
    value: c_int,
    str: ?[*:0]u8,
    radix: c_int,
) ?[*:0]u8;

/// 
pub const uitoa = SDL_uitoa;
extern fn SDL_uitoa(
    value: c_uint,
    str: ?[*:0]u8,
    radix: c_int,
) ?[*:0]u8;

/// 
pub const ltoa = SDL_ltoa;
extern fn SDL_ltoa(
    value: c_long,
    str: ?[*:0]u8,
    radix: c_int,
) ?[*:0]u8;

/// 
pub const ultoa = SDL_ultoa;
extern fn SDL_ultoa(
    value: c_ulong,
    str: ?[*:0]u8,
    radix: c_int,
) ?[*:0]u8;

/// 
pub const lltoa = SDL_lltoa;
extern fn SDL_lltoa(
    value: i64,
    str: ?[*:0]u8,
    radix: c_int,
) ?[*:0]u8;

/// 
pub const ulltoa = SDL_ulltoa;
extern fn SDL_ulltoa(
    value: u64,
    str: ?[*:0]u8,
    radix: c_int,
) ?[*:0]u8;

/// 
pub const atoi = SDL_atoi;
extern fn SDL_atoi(
    str: ?[*:0]const u8,
) c_int;

/// 
pub const atof = SDL_atof;
extern fn SDL_atof(
    str: ?[*:0]const u8,
) f64;

/// 
pub const strtol = SDL_strtol;
extern fn SDL_strtol(
    str: ?[*:0]const u8,
    endp: ?[*c][*c]u8,
    base: c_int,
) c_long;

/// 
pub const strtoul = SDL_strtoul;
extern fn SDL_strtoul(
    str: ?[*:0]const u8,
    endp: ?[*c][*c]u8,
    base: c_int,
) c_ulong;

/// 
pub const strtoll = SDL_strtoll;
extern fn SDL_strtoll(
    str: ?[*:0]const u8,
    endp: ?[*c][*c]u8,
    base: c_int,
) i64;

/// 
pub const strtoull = SDL_strtoull;
extern fn SDL_strtoull(
    str: ?[*:0]const u8,
    endp: ?[*c][*c]u8,
    base: c_int,
) u64;

/// 
pub const strtod = SDL_strtod;
extern fn SDL_strtod(
    str: ?[*:0]const u8,
    endp: ?[*c][*c]u8,
) f64;

/// 
pub const strcmp = SDL_strcmp;
extern fn SDL_strcmp(
    str1: ?[*:0]const u8,
    str2: ?[*:0]const u8,
) c_int;

/// 
pub const strncmp = SDL_strncmp;
extern fn SDL_strncmp(
    str1: ?[*:0]const u8,
    str2: ?[*:0]const u8,
    maxlen: usize,
) c_int;

/// 
pub const strcasecmp = SDL_strcasecmp;
extern fn SDL_strcasecmp(
    str1: ?[*:0]const u8,
    str2: ?[*:0]const u8,
) c_int;

/// 
pub const strncasecmp = SDL_strncasecmp;
extern fn SDL_strncasecmp(
    str1: ?[*:0]const u8,
    str2: ?[*:0]const u8,
    len: usize,
) c_int;

/// 
pub const sscanf = SDL_sscanf;
extern fn SDL_sscanf(
    text: ?[*:0]const u8,
    fmt: [*:0]const u8,
    ...,
) c_int;

/// 
pub const vsscanf = SDL_vsscanf;
extern fn SDL_vsscanf(
    text: ?[*:0]const u8,
    fmt: ?[*:0]const u8,
    ap: va_list,
) c_int;

/// 
pub const snprintf = SDL_snprintf;
extern fn SDL_snprintf(
    param_name_not_specified: @panic("cannot translate SDL_OUT_Z_CAP ( SDL_OUT_Z_CAP ( maxlen ) char * text * ) char * text"),
    maxlen: usize,
    fmt: [*:0]const u8,
    ...,
) c_int;

/// 
pub const vsnprintf = SDL_vsnprintf;
extern fn SDL_vsnprintf(
    param_name_not_specified: @panic("cannot translate SDL_OUT_Z_CAP ( SDL_OUT_Z_CAP ( maxlen ) char * text * ) char * text"),
    maxlen: usize,
    fmt: ?[*:0]const u8,
    ap: va_list,
) c_int;

/// 
pub const asprintf = SDL_asprintf;
extern fn SDL_asprintf(
    strp: ?[*c][*c]u8,
    fmt: [*:0]const u8,
    ...,
) c_int;

/// 
pub const vasprintf = SDL_vasprintf;
extern fn SDL_vasprintf(
    strp: ?[*c][*c]u8,
    fmt: ?[*:0]const u8,
    ap: va_list,
) c_int;

/// 
/// Use this function to compute arc cosine of `x`.
/// 
/// The definition of `y = acos(x)` is `x = cos(y)`.
/// 
/// Domain: `-1 <= x <= 1`
/// 
/// Range: `0 <= y <= Pi`
/// 
/// \param x floating point value, in radians.
/// \returns arc cosine of `x`.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const acos = SDL_acos;
extern fn SDL_acos(
    x: f64,
) f64;

/// 
pub const acosf = SDL_acosf;
extern fn SDL_acosf(
    x: f32,
) f32;

/// 
pub const asin = SDL_asin;
extern fn SDL_asin(
    x: f64,
) f64;

/// 
pub const asinf = SDL_asinf;
extern fn SDL_asinf(
    x: f32,
) f32;

/// 
pub const atan = SDL_atan;
extern fn SDL_atan(
    x: f64,
) f64;

/// 
pub const atanf = SDL_atanf;
extern fn SDL_atanf(
    x: f32,
) f32;

/// 
pub const atan2 = SDL_atan2;
extern fn SDL_atan2(
    y: f64,
    x: f64,
) f64;

/// 
pub const atan2f = SDL_atan2f;
extern fn SDL_atan2f(
    y: f32,
    x: f32,
) f32;

/// 
pub const ceil = SDL_ceil;
extern fn SDL_ceil(
    x: f64,
) f64;

/// 
pub const ceilf = SDL_ceilf;
extern fn SDL_ceilf(
    x: f32,
) f32;

/// 
pub const copysign = SDL_copysign;
extern fn SDL_copysign(
    x: f64,
    y: f64,
) f64;

/// 
pub const copysignf = SDL_copysignf;
extern fn SDL_copysignf(
    x: f32,
    y: f32,
) f32;

/// 
pub const cos = SDL_cos;
extern fn SDL_cos(
    x: f64,
) f64;

/// 
pub const cosf = SDL_cosf;
extern fn SDL_cosf(
    x: f32,
) f32;

/// 
pub const exp = SDL_exp;
extern fn SDL_exp(
    x: f64,
) f64;

/// 
pub const expf = SDL_expf;
extern fn SDL_expf(
    x: f32,
) f32;

/// 
pub const fabs = SDL_fabs;
extern fn SDL_fabs(
    x: f64,
) f64;

/// 
pub const fabsf = SDL_fabsf;
extern fn SDL_fabsf(
    x: f32,
) f32;

/// 
pub const floor = SDL_floor;
extern fn SDL_floor(
    x: f64,
) f64;

/// 
pub const floorf = SDL_floorf;
extern fn SDL_floorf(
    x: f32,
) f32;

/// 
pub const trunc = SDL_trunc;
extern fn SDL_trunc(
    x: f64,
) f64;

/// 
pub const truncf = SDL_truncf;
extern fn SDL_truncf(
    x: f32,
) f32;

/// 
pub const fmod = SDL_fmod;
extern fn SDL_fmod(
    x: f64,
    y: f64,
) f64;

/// 
pub const fmodf = SDL_fmodf;
extern fn SDL_fmodf(
    x: f32,
    y: f32,
) f32;

/// 
pub const log = SDL_log;
extern fn SDL_log(
    x: f64,
) f64;

/// 
pub const logf = SDL_logf;
extern fn SDL_logf(
    x: f32,
) f32;

/// 
pub const log10 = SDL_log10;
extern fn SDL_log10(
    x: f64,
) f64;

/// 
pub const log10f = SDL_log10f;
extern fn SDL_log10f(
    x: f32,
) f32;

/// 
pub const modf = SDL_modf;
extern fn SDL_modf(
    x: f64,
    y: *f64,
) f64;

/// 
pub const modff = SDL_modff;
extern fn SDL_modff(
    x: f32,
    y: *f32,
) f32;

/// 
pub const pow = SDL_pow;
extern fn SDL_pow(
    x: f64,
    y: f64,
) f64;

/// 
pub const powf = SDL_powf;
extern fn SDL_powf(
    x: f32,
    y: f32,
) f32;

/// 
pub const round = SDL_round;
extern fn SDL_round(
    x: f64,
) f64;

/// 
pub const roundf = SDL_roundf;
extern fn SDL_roundf(
    x: f32,
) f32;

/// 
pub const lround = SDL_lround;
extern fn SDL_lround(
    x: f64,
) c_long;

/// 
pub const lroundf = SDL_lroundf;
extern fn SDL_lroundf(
    x: f32,
) c_long;

/// 
pub const scalbn = SDL_scalbn;
extern fn SDL_scalbn(
    x: f64,
    n: c_int,
) f64;

/// 
pub const scalbnf = SDL_scalbnf;
extern fn SDL_scalbnf(
    x: f32,
    n: c_int,
) f32;

/// 
pub const sin = SDL_sin;
extern fn SDL_sin(
    x: f64,
) f64;

/// 
pub const sinf = SDL_sinf;
extern fn SDL_sinf(
    x: f32,
) f32;

/// 
pub const sqrt = SDL_sqrt;
extern fn SDL_sqrt(
    x: f64,
) f64;

/// 
pub const sqrtf = SDL_sqrtf;
extern fn SDL_sqrtf(
    x: f32,
) f32;

/// 
pub const tan = SDL_tan;
extern fn SDL_tan(
    x: f64,
) f64;

/// 
pub const tanf = SDL_tanf;
extern fn SDL_tanf(
    x: f32,
) f32;

/// 
pub const iconv_open = SDL_iconv_open;
extern fn SDL_iconv_open(
    tocode: ?[*:0]const u8,
    fromcode: ?[*:0]const u8,
) SDL_iconv_t;

/// 
pub const iconv_close = SDL_iconv_close;
extern fn SDL_iconv_close(
    cd: SDL_iconv_t,
) c_int;

/// 
pub const iconv = SDL_iconv;
extern fn SDL_iconv(
    cd: SDL_iconv_t,
    inbuf: ?[*c]const [*c]u8,
    inbytesleft: *usize,
    outbuf: ?[*c][*c]u8,
    outbytesleft: *usize,
) usize;

/// 
/// This function converts a string between encodings in one pass, returning a
/// string that must be freed with SDL_free() or NULL on error.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const iconv_string = SDL_iconv_string;
extern fn SDL_iconv_string(
    tocode: ?[*:0]const u8,
    fromcode: ?[*:0]const u8,
    inbuf: ?[*:0]const u8,
    inbytesleft: usize,
) ?[*:0]u8;

/// 
/// Circumvent failure of SDL_Init() when not using SDL_main() as an entry
/// point.
/// 
/// This function is defined in SDL_main.h, along with the preprocessor rule to
/// redefine main() as SDL_main(). Thus to ensure that your main() function
/// will not be changed it is necessary to define SDL_MAIN_HANDLED before
/// including SDL.h.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_Init
/// 
/// 
pub const SetMainReady = SDL_SetMainReady;
extern fn SDL_SetMainReady() void;

/// 
/// Initializes and launches an SDL application, by doing platform-specific
/// initialization before calling your mainFunction and cleanups after it returns,
/// if that is needed for a specific platform, otherwise it just calls mainFunction.
/// You can use this if you want to use your own main() implementation
/// without using SDL_main (like when using SDL_MAIN_HANDLED).
/// When using this, you do *not* need SDL_SetMainReady().
/// 
/// \param argc The argc parameter from the application's main() function,
///             or 0 if the platform's main-equivalent has no argc
/// \param argv The argv parameter from the application's main() function,
///             or NULL  if the platform's main-equivalent has no argv
/// \param mainFunction Your SDL app's C-style main(), an SDL_main_func.
///                     NOT the function you're calling this from!
///                     Its name doesn't matter, but its signature must be
///                     like int my_main(int argc, char* argv[])
/// \param reserved should be NULL (reserved for future use, will probably
///                 be platform-specific then)
/// \return the return value from mainFunction: 0 on success, -1 on failure;
///         SDL_GetError() might have more information on the failure
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const RunApp = SDL_RunApp;
extern fn SDL_RunApp(
    argc: c_int,
    argv: ?[*c][*c]u8,
    mainFunction: SDL_main_func,
    reserved: ?*anyopaque,
) c_int;

/// 
/// Register a win32 window class for SDL's use.
/// 
/// This can be called to set the application window class at startup. It is
/// safe to call this multiple times, as long as every call is eventually
/// paired with a call to SDL_UnregisterApp, but a second registration attempt
/// while a previous registration is still active will be ignored, other than
/// to increment a counter.
/// 
/// Most applications do not need to, and should not, call this directly; SDL
/// will call it when initializing the video subsystem.
/// 
/// \param name the window class name, in UTF-8 encoding. If NULL, SDL
///             currently uses "SDL_app" but this isn't guaranteed.
/// \param style the value to use in WNDCLASSEX::style. If `name` is NULL, SDL
///              currently uses `(CS_BYTEALIGNCLIENT | CS_OWNDC)` regardless of
///              what is specified here.
/// \param hInst the HINSTANCE to use in WNDCLASSEX::hInstance. If zero, SDL
///              will use `GetModuleHandle(NULL)` instead.
/// \returns 0 on success, -1 on error. SDL_GetError() may have details.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const RegisterApp = SDL_RegisterApp;
extern fn SDL_RegisterApp(
    name: ?[*:0]const u8,
    style: u32,
    hInst: ?*anyopaque,
) c_int;

/// 
/// Deregister the win32 window class from an SDL_RegisterApp call.
/// 
/// This can be called to undo the effects of SDL_RegisterApp.
/// 
/// Most applications do not need to, and should not, call this directly; SDL
/// will call it when deinitializing the video subsystem.
/// 
/// It is safe to call this multiple times, as long as every call is eventually
/// paired with a prior call to SDL_RegisterApp. The window class will only be
/// deregistered when the registration counter in SDL_RegisterApp decrements to
/// zero through calls to this function.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const UnregisterApp = SDL_UnregisterApp;
extern fn SDL_UnregisterApp() void;

/// 
/// Callback from the application to let the suspend continue.
/// 
/// \since This function is available since SDL 2.28.0.
/// 
/// 
pub const GDKSuspendComplete = SDL_GDKSuspendComplete;
extern fn SDL_GDKSuspendComplete() void;

/// 
/// Get a list of currently connected sensors.
/// 
/// \param count a pointer filled in with the number of sensors returned
/// \returns a 0 terminated array of sensor instance IDs which should be freed with SDL_free(), or NULL on error; call SDL_GetError() for more details.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const GetSensors = SDL_GetSensors;
extern fn SDL_GetSensors(
    count: *c_int,
) ?*SDL_SensorID;

/// 
/// Get the implementation dependent name of a sensor.
/// 
/// \param instance_id the sensor instance ID
/// \returns the sensor name, or NULL if `instance_id` is not valid
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const GetSensorInstanceName = SDL_GetSensorInstanceName;
extern fn SDL_GetSensorInstanceName(
    instance_id: SDL_SensorID,
) ?[*:0]const u8;

/// 
/// Get the type of a sensor.
/// 
/// \param instance_id the sensor instance ID
/// \returns the SDL_SensorType, or `SDL_SENSOR_INVALID` if `instance_id` is not valid
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const GetSensorInstanceType = SDL_GetSensorInstanceType;
extern fn SDL_GetSensorInstanceType(
    instance_id: SDL_SensorID,
) SDL_SensorType;

/// 
/// Get the platform dependent type of a sensor.
/// 
/// \param instance_id the sensor instance ID
/// \returns the sensor platform dependent type, or -1 if `instance_id` is not valid
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const GetSensorInstanceNonPortableType = SDL_GetSensorInstanceNonPortableType;
extern fn SDL_GetSensorInstanceNonPortableType(
    instance_id: SDL_SensorID,
) c_int;

/// 
/// Open a sensor for use.
/// 
/// \param instance_id the sensor instance ID
/// \returns an SDL_Sensor sensor object, or NULL if an error occurred.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const OpenSensor = SDL_OpenSensor;
extern fn SDL_OpenSensor(
    instance_id: SDL_SensorID,
) ?*SDL_Sensor;

/// 
/// Return the SDL_Sensor associated with an instance ID.
/// 
/// \param instance_id the sensor instance ID
/// \returns an SDL_Sensor object.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const GetSensorFromInstanceID = SDL_GetSensorFromInstanceID;
extern fn SDL_GetSensorFromInstanceID(
    instance_id: SDL_SensorID,
) ?*SDL_Sensor;

/// 
/// Get the implementation dependent name of a sensor
/// 
/// \param sensor The SDL_Sensor object
/// \returns the sensor name, or NULL if `sensor` is NULL.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const GetSensorName = SDL_GetSensorName;
extern fn SDL_GetSensorName(
    sensor: ?*SDL_Sensor,
) ?[*:0]const u8;

/// 
/// Get the type of a sensor.
/// 
/// \param sensor The SDL_Sensor object to inspect
/// \returns the SDL_SensorType type, or `SDL_SENSOR_INVALID` if `sensor` is
///          NULL.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const GetSensorType = SDL_GetSensorType;
extern fn SDL_GetSensorType(
    sensor: ?*SDL_Sensor,
) SDL_SensorType;

/// 
/// Get the platform dependent type of a sensor.
/// 
/// \param sensor The SDL_Sensor object to inspect
/// \returns the sensor platform dependent type, or -1 if `sensor` is NULL.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const GetSensorNonPortableType = SDL_GetSensorNonPortableType;
extern fn SDL_GetSensorNonPortableType(
    sensor: ?*SDL_Sensor,
) c_int;

/// 
/// Get the instance ID of a sensor.
/// 
/// \param sensor The SDL_Sensor object to inspect
/// \returns the sensor instance ID, or -1 if `sensor` is NULL.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const GetSensorInstanceID = SDL_GetSensorInstanceID;
extern fn SDL_GetSensorInstanceID(
    sensor: ?*SDL_Sensor,
) SDL_SensorID;

/// 
/// Get the current state of an opened sensor.
/// 
/// The number of values and interpretation of the data is sensor dependent.
/// 
/// \param sensor The SDL_Sensor object to query
/// \param data A pointer filled with the current sensor state
/// \param num_values The number of values to write to data
/// \returns 0 or -1 if an error occurred.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const GetSensorData = SDL_GetSensorData;
extern fn SDL_GetSensorData(
    sensor: ?*SDL_Sensor,
    data: *f32,
    num_values: c_int,
) c_int;

/// 
/// Close a sensor previously opened with SDL_OpenSensor().
/// 
/// \param sensor The SDL_Sensor object to close
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const CloseSensor = SDL_CloseSensor;
extern fn SDL_CloseSensor(
    sensor: ?*SDL_Sensor,
) void;

/// 
/// Update the current state of the open sensors.
/// 
/// This is called automatically by the event loop if sensor events are
/// enabled.
/// 
/// This needs to be called from the thread that initialized the sensor
/// subsystem.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const UpdateSensors = SDL_UpdateSensors;
extern fn SDL_UpdateSensors() void;

/// 
/// Report the user's preferred locale.
/// 
/// This returns an array of SDL_Locale structs, the final item zeroed out.
/// When the caller is done with this array, it should call SDL_free() on the
/// returned value; all the memory involved is allocated in a single block, so
/// a single SDL_free() will suffice.
/// 
/// Returned language strings are in the format xx, where 'xx' is an ISO-639
/// language specifier (such as "en" for English, "de" for German, etc).
/// Country strings are in the format YY, where "YY" is an ISO-3166 country
/// code (such as "US" for the United States, "CA" for Canada, etc). Country
/// might be NULL if there's no specific guidance on them (so you might get {
/// "en", "US" } for American English, but { "en", NULL } means "English
/// language, generically"). Language strings are never NULL, except to
/// terminate the array.
/// 
/// Please note that not all of these strings are 2 characters; some are three
/// or more.
/// 
/// The returned list of locales are in the order of the user's preference. For
/// example, a German citizen that is fluent in US English and knows enough
/// Japanese to navigate around Tokyo might have a list like: { "de", "en_US",
/// "jp", NULL }. Someone from England might prefer British English (where
/// "color" is spelled "colour", etc), but will settle for anything like it: {
/// "en_GB", "en", NULL }.
/// 
/// This function returns NULL on error, including when the platform does not
/// supply this information at all.
/// 
/// This might be a "slow" call that has to query the operating system. It's
/// best to ask for this once and save the results. However, this list can
/// change, usually because the user has changed a system preference outside of
/// your program; SDL will send an SDL_LOCALECHANGED event in this case, if
/// possible, and you can call this function again to get an updated copy of
/// preferred locales.
/// 
/// \return array of locales, terminated with a locale with a NULL language
///         field. Will return NULL on error.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const GetPreferredLocales = SDL_GetPreferredLocales;
extern fn SDL_GetPreferredLocales() ?*SDL_Locale;

/// 
/// Create a modal message box.
/// 
/// If your needs aren't complex, it might be easier to use
/// SDL_ShowSimpleMessageBox.
/// 
/// This function should be called on the thread that created the parent
/// window, or on the main thread if the messagebox has no parent. It will
/// block execution of that thread until the user clicks a button or closes the
/// messagebox.
/// 
/// This function may be called at any time, even before SDL_Init(). This makes
/// it useful for reporting errors like a failure to create a renderer or
/// OpenGL context.
/// 
/// On X11, SDL rolls its own dialog box with X11 primitives instead of a
/// formal toolkit like GTK+ or Qt.
/// 
/// Note that if SDL_Init() would fail because there isn't any available video
/// target, this function is likely to fail for the same reasons. If this is a
/// concern, check the return value from this function and fall back to writing
/// to stderr if you can.
/// 
/// \param messageboxdata the SDL_MessageBoxData structure with title, text and
///                       other options
/// \param buttonid the pointer to which user id of hit button should be copied
/// \returns 0 on success or a negative error code on failure; call
///          SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_ShowSimpleMessageBox
/// 
/// 
pub const ShowMessageBox = SDL_ShowMessageBox;
extern fn SDL_ShowMessageBox(
    messageboxdata: ?* const SDL_MessageBoxData,
    buttonid: *c_int,
) c_int;

/// 
/// Display a simple modal message box.
/// 
/// If your needs aren't complex, this function is preferred over
/// SDL_ShowMessageBox.
/// 
/// `flags` may be any of the following:
/// 
/// - `SDL_MESSAGEBOX_ERROR`: error dialog
/// - `SDL_MESSAGEBOX_WARNING`: warning dialog
/// - `SDL_MESSAGEBOX_INFORMATION`: informational dialog
/// 
/// This function should be called on the thread that created the parent
/// window, or on the main thread if the messagebox has no parent. It will
/// block execution of that thread until the user clicks a button or closes the
/// messagebox.
/// 
/// This function may be called at any time, even before SDL_Init(). This makes
/// it useful for reporting errors like a failure to create a renderer or
/// OpenGL context.
/// 
/// On X11, SDL rolls its own dialog box with X11 primitives instead of a
/// formal toolkit like GTK+ or Qt.
/// 
/// Note that if SDL_Init() would fail because there isn't any available video
/// target, this function is likely to fail for the same reasons. If this is a
/// concern, check the return value from this function and fall back to writing
/// to stderr if you can.
/// 
/// \param flags an SDL_MessageBoxFlags value
/// \param title UTF-8 title text
/// \param message UTF-8 message text
/// \param window the parent window, or NULL for no parent
/// \returns 0 on success or a negative error code on failure; call
///          SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_ShowMessageBox
/// 
/// 
pub const ShowSimpleMessageBox = SDL_ShowSimpleMessageBox;
extern fn SDL_ShowSimpleMessageBox(
    flags: u32,
    title: ?[*:0]const u8,
    message: ?[*:0]const u8,
    window: ?*SDL_Window,
) c_int;

/// 
/// Initialize the SDL library.
/// 
/// SDL_Init() simply forwards to calling SDL_InitSubSystem(). Therefore, the
/// two may be used interchangeably. Though for readability of your code
/// SDL_InitSubSystem() might be preferred.
/// 
/// The file I/O (for example: SDL_RWFromFile) and threading (SDL_CreateThread)
/// subsystems are initialized by default. Message boxes
/// (SDL_ShowSimpleMessageBox) also attempt to work without initializing the
/// video subsystem, in hopes of being useful in showing an error dialog when
/// SDL_Init fails. You must specifically initialize other subsystems if you
/// use them in your application.
/// 
/// Logging (such as SDL_Log) works without initialization, too.
/// 
/// `flags` may be any of the following OR'd together:
/// 
/// - `SDL_INIT_TIMER`: timer subsystem
/// - `SDL_INIT_AUDIO`: audio subsystem
/// - `SDL_INIT_VIDEO`: video subsystem; automatically initializes the events
///   subsystem
/// - `SDL_INIT_JOYSTICK`: joystick subsystem; automatically initializes the
///   events subsystem
/// - `SDL_INIT_HAPTIC`: haptic (force feedback) subsystem
/// - `SDL_INIT_GAMEPAD`: gamepad subsystem; automatically
///   initializes the joystick subsystem
/// - `SDL_INIT_EVENTS`: events subsystem
/// - `SDL_INIT_EVERYTHING`: all of the above subsystems
/// - `SDL_INIT_NOPARACHUTE`: compatibility; this flag is ignored
/// 
/// Subsystem initialization is ref-counted, you must call SDL_QuitSubSystem()
/// for each SDL_InitSubSystem() to correctly shutdown a subsystem manually (or
/// call SDL_Quit() to force shutdown). If a subsystem is already loaded then
/// this call will increase the ref-count and return.
/// 
/// \param flags subsystem initialization flags
/// \returns 0 on success or a negative error code on failure; call
///          SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_InitSubSystem
/// \sa SDL_Quit
/// \sa SDL_SetMainReady
/// \sa SDL_WasInit
/// 
/// 
pub const Init = SDL_Init;
extern fn SDL_Init(
    flags: u32,
) c_int;

/// 
/// Compatibility function to initialize the SDL library.
/// 
/// This function and SDL_Init() are interchangeable.
/// 
/// \param flags any of the flags used by SDL_Init(); see SDL_Init for details.
/// \returns 0 on success or a negative error code on failure; call
///          SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_Init
/// \sa SDL_Quit
/// \sa SDL_QuitSubSystem
/// 
/// 
pub const InitSubSystem = SDL_InitSubSystem;
extern fn SDL_InitSubSystem(
    flags: u32,
) c_int;

/// 
/// Shut down specific SDL subsystems.
/// 
/// You still need to call SDL_Quit() even if you close all open subsystems
/// with SDL_QuitSubSystem().
/// 
/// \param flags any of the flags used by SDL_Init(); see SDL_Init for details.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_InitSubSystem
/// \sa SDL_Quit
/// 
/// 
pub const QuitSubSystem = SDL_QuitSubSystem;
extern fn SDL_QuitSubSystem(
    flags: u32,
) void;

/// 
/// Get a mask of the specified subsystems which are currently initialized.
/// 
/// \param flags any of the flags used by SDL_Init(); see SDL_Init for details.
/// \returns a mask of all initialized subsystems if `flags` is 0, otherwise it
///          returns the initialization status of the specified subsystems.
/// 
///          The return value does not include SDL_INIT_NOPARACHUTE.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_Init
/// \sa SDL_InitSubSystem
/// 
/// 
pub const WasInit = SDL_WasInit;
extern fn SDL_WasInit(
    flags: u32,
) u32;

/// 
/// Clean up all initialized subsystems.
/// 
/// You should call this function even if you have already shutdown each
/// initialized subsystem with SDL_QuitSubSystem(). It is safe to call this
/// function even in the case of errors in initialization.
/// 
/// You can use this function with atexit() to ensure that it is run when your
/// application is shutdown, but it is not wise to do this from a library or
/// other dynamically loaded code.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_Init
/// \sa SDL_QuitSubSystem
/// 
/// 
pub const Quit = SDL_Quit;
extern fn SDL_Quit() void;

/// 
/// Dynamically load a shared object.
/// 
/// \param sofile a system-dependent name of the object file
/// \returns an opaque pointer to the object handle or NULL if there was an
///          error; call SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_LoadFunction
/// \sa SDL_UnloadObject
/// 
/// 
pub const LoadObject = SDL_LoadObject;
extern fn SDL_LoadObject(
    sofile: ?[*:0]const u8,
) ?*anyopaque;

/// 
/// Unload a shared object from memory.
/// 
/// \param handle a valid shared object handle returned by SDL_LoadObject()
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_LoadFunction
/// \sa SDL_LoadObject
/// 
/// 
pub const UnloadObject = SDL_UnloadObject;
extern fn SDL_UnloadObject(
    handle: ?*anyopaque,
) void;

/// 
/// Set a hint with a specific priority.
/// 
/// The priority controls the behavior when setting a hint that already has a
/// value. Hints will replace existing hints of their priority and lower.
/// Environment variables are considered to have override priority.
/// 
/// \param name the hint to set
/// \param value the value of the hint variable
/// \param priority the SDL_HintPriority level for the hint
/// \returns SDL_TRUE if the hint was set, SDL_FALSE otherwise.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_GetHint
/// \sa SDL_SetHint
/// 
/// 
pub const SetHintWithPriority = SDL_SetHintWithPriority;
extern fn SDL_SetHintWithPriority(
    name: ?[*:0]const u8,
    value: ?[*:0]const u8,
    priority: SDL_HintPriority,
) bool;

/// 
/// Set a hint with normal priority.
/// 
/// Hints will not be set if there is an existing override hint or environment
/// variable that takes precedence. You can use SDL_SetHintWithPriority() to
/// set the hint with override priority instead.
/// 
/// \param name the hint to set
/// \param value the value of the hint variable
/// \returns SDL_TRUE if the hint was set, SDL_FALSE otherwise.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_GetHint
/// \sa SDL_SetHintWithPriority
/// 
/// 
pub const SetHint = SDL_SetHint;
extern fn SDL_SetHint(
    name: ?[*:0]const u8,
    value: ?[*:0]const u8,
) bool;

/// 
/// Reset a hint to the default value.
/// 
/// This will reset a hint to the value of the environment variable, or NULL if
/// the environment isn't set. Callbacks will be called normally with this
/// change.
/// 
/// \param name the hint to set
/// \returns SDL_TRUE if the hint was set, SDL_FALSE otherwise.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_GetHint
/// \sa SDL_SetHint
/// 
/// 
pub const ResetHint = SDL_ResetHint;
extern fn SDL_ResetHint(
    name: ?[*:0]const u8,
) bool;

/// 
/// Reset all hints to the default values.
/// 
/// This will reset all hints to the value of the associated environment
/// variable, or NULL if the environment isn't set. Callbacks will be called
/// normally with this change.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_GetHint
/// \sa SDL_SetHint
/// \sa SDL_ResetHint
/// 
/// 
pub const ResetHints = SDL_ResetHints;
extern fn SDL_ResetHints() void;

/// 
/// Get the value of a hint.
/// 
/// \param name the hint to query
/// \returns the string value of a hint or NULL if the hint isn't set.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_SetHint
/// \sa SDL_SetHintWithPriority
/// 
/// 
pub const GetHint = SDL_GetHint;
extern fn SDL_GetHint(
    name: ?[*:0]const u8,
) ?[*:0]const u8;

/// 
/// Get the boolean value of a hint variable.
/// 
/// \param name the name of the hint to get the boolean value from
/// \param default_value the value to return if the hint does not exist
/// \returns the boolean value of a hint or the provided default value if the
///          hint does not exist.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_GetHint
/// \sa SDL_SetHint
/// 
/// 
pub const GetHintBoolean = SDL_GetHintBoolean;
extern fn SDL_GetHintBoolean(
    name: ?[*:0]const u8,
    default_value: bool,
) bool;

/// 
/// Add a function to watch a particular hint.
/// 
/// \param name the hint to watch
/// \param callback An SDL_HintCallback function that will be called when the
///                 hint value changes
/// \param userdata a pointer to pass to the callback function
/// \returns 0 on success or a negative error code on failure; call
///          SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_DelHintCallback
/// 
/// 
pub const AddHintCallback = SDL_AddHintCallback;
extern fn SDL_AddHintCallback(
    name: ?[*:0]const u8,
    callback: SDL_HintCallback,
    userdata: ?*anyopaque,
) c_int;

/// 
/// Remove a function watching a particular hint.
/// 
/// \param name the hint being watched
/// \param callback An SDL_HintCallback function that will be called when the
///                 hint value changes
/// \param userdata a pointer being passed to the callback function
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_AddHintCallback
/// 
/// 
pub const DelHintCallback = SDL_DelHintCallback;
extern fn SDL_DelHintCallback(
    name: ?[*:0]const u8,
    callback: SDL_HintCallback,
    userdata: ?*anyopaque,
) void;

/// 
/// Clear all hints.
/// 
/// This function is automatically called during SDL_Quit(), and deletes all
/// callbacks without calling them and frees all memory associated with hints.
/// If you're calling this from application code you probably want to call
/// SDL_ResetHints() instead.
/// 
/// This function will be removed from the API the next time we rev the ABI.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_ResetHints
/// 
/// 
pub const ClearHints = SDL_ClearHints;
extern fn SDL_ClearHints() void;

/// 
/// Dynamically load the Vulkan loader library.
/// 
/// This should be called after initializing the video driver, but before
/// creating any Vulkan windows. If no Vulkan loader library is loaded, the
/// default library will be loaded upon creation of the first Vulkan window.
/// 
/// It is fairly common for Vulkan applications to link with libvulkan instead
/// of explicitly loading it at run time. This will work with SDL provided the
/// application links to a dynamic library and both it and SDL use the same
/// search path.
/// 
/// If you specify a non-NULL `path`, an application should retrieve all of the
/// Vulkan functions it uses from the dynamic library using
/// SDL_Vulkan_GetVkGetInstanceProcAddr unless you can guarantee `path` points
/// to the same vulkan loader library the application linked to.
/// 
/// On Apple devices, if `path` is NULL, SDL will attempt to find the
/// `vkGetInstanceProcAddr` address within all the Mach-O images of the current
/// process. This is because it is fairly common for Vulkan applications to
/// link with libvulkan (and historically MoltenVK was provided as a static
/// library). If it is not found, on macOS, SDL will attempt to load
/// `vulkan.framework/vulkan`, `libvulkan.1.dylib`,
/// `MoltenVK.framework/MoltenVK`, and `libMoltenVK.dylib`, in that order. On
/// iOS, SDL will attempt to load `libMoltenVK.dylib`. Applications using a
/// dynamic framework or .dylib must ensure it is included in its application
/// bundle.
/// 
/// On non-Apple devices, application linking with a static libvulkan is not
/// supported. Either do not link to the Vulkan loader or link to a dynamic
/// library version.
/// 
/// \param path The platform dependent Vulkan loader library name or NULL
/// \returns 0 on success or -1 if the library couldn't be loaded; call
///          SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_Vulkan_GetVkInstanceProcAddr
/// \sa SDL_Vulkan_UnloadLibrary
/// 
/// 
pub const Vulkan_LoadLibrary = SDL_Vulkan_LoadLibrary;
extern fn SDL_Vulkan_LoadLibrary(
    path: ?[*:0]const u8,
) c_int;

/// 
/// Get the address of the `vkGetInstanceProcAddr` function.
/// 
/// This should be called after either calling SDL_Vulkan_LoadLibrary() or
/// creating an SDL_Window with the `SDL_WINDOW_VULKAN` flag.
/// 
/// The actual type of the returned function pointer is PFN_vkGetInstanceProcAddr,
/// but that isn't available because the Vulkan headers are not included here. You
/// should cast the return value of this function to that type, e.g.
/// 
///  `vkGetInstanceProcAddr = (PFN_vkGetInstanceProcAddr)SDL_Vulkan_GetVkGetInstanceProcAddr();`
/// 
/// \returns the function pointer for `vkGetInstanceProcAddr` or NULL on error.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const Vulkan_GetVkGetInstanceProcAddr = SDL_Vulkan_GetVkGetInstanceProcAddr;
extern fn SDL_Vulkan_GetVkGetInstanceProcAddr() SDL_FunctionPointer;

/// 
/// Unload the Vulkan library previously loaded by SDL_Vulkan_LoadLibrary()
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_Vulkan_LoadLibrary
/// 
/// 
pub const Vulkan_UnloadLibrary = SDL_Vulkan_UnloadLibrary;
extern fn SDL_Vulkan_UnloadLibrary() void;

/// 
/// Get the names of the Vulkan instance extensions needed to create a surface
/// with SDL_Vulkan_CreateSurface.
/// 
/// This should be called after either calling SDL_Vulkan_LoadLibrary() or
/// creating an SDL_Window with the `SDL_WINDOW_VULKAN` flag.
/// 
/// If `pNames` is NULL, then the number of required Vulkan instance extensions
/// is returned in `pCount`. Otherwise, `pCount` must point to a variable set
/// to the number of elements in the `pNames` array, and on return the variable
/// is overwritten with the number of names actually written to `pNames`. If
/// `pCount` is less than the number of required extensions, at most `pCount`
/// structures will be written. If `pCount` is smaller than the number of
/// required extensions, SDL_FALSE will be returned instead of SDL_TRUE, to
/// indicate that not all the required extensions were returned.
/// 
/// \param pCount A pointer to an unsigned int corresponding to the number of
///               extensions to be returned
/// \param pNames NULL or a pointer to an array to be filled with required
///               Vulkan instance extensions
/// \returns SDL_TRUE on success, SDL_FALSE on error.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_Vulkan_CreateSurface
/// 
/// 
pub const Vulkan_GetInstanceExtensions = SDL_Vulkan_GetInstanceExtensions;
extern fn SDL_Vulkan_GetInstanceExtensions(
    pCount: ?*c_uint,
    pNames: ?[*c]const [*c]u8,
) bool;

/// 
/// Create a Vulkan rendering surface for a window.
/// 
/// The `window` must have been created with the `SDL_WINDOW_VULKAN` flag and
/// `instance` must have been created with extensions returned by
/// SDL_Vulkan_GetInstanceExtensions() enabled.
/// 
/// \param window The window to which to attach the Vulkan surface
/// \param instance The Vulkan instance handle
/// \param surface A pointer to a VkSurfaceKHR handle to output the newly
///                created surface
/// \returns SDL_TRUE on success, SDL_FALSE on error.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_Vulkan_GetInstanceExtensions
/// \sa SDL_Vulkan_GetDrawableSize
/// 
/// 
pub const Vulkan_CreateSurface = SDL_Vulkan_CreateSurface;
extern fn SDL_Vulkan_CreateSurface(
    window: ?*SDL_Window,
    instance: VkInstance,
    surface: ?*VkSurfaceKHR,
) bool;

/// 
/// Get the size of the window's underlying drawable dimensions in pixels.
/// 
/// This may differ from SDL_GetWindowSize() if we're rendering to a high-DPI
/// drawable, i.e. the window was created with `SDL_WINDOW_ALLOW_HIGHDPI` on a
/// platform with high-DPI support (Apple calls this "Retina"), and not
/// disabled by the `SDL_HINT_VIDEO_HIGHDPI_DISABLED` hint.
/// 
/// \param window an SDL_Window for which the size is to be queried
/// \param w Pointer to the variable to write the width to or NULL
/// \param h Pointer to the variable to write the height to or NULL
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_GetWindowSize
/// \sa SDL_CreateWindow
/// \sa SDL_Vulkan_CreateSurface
/// 
/// 
pub const Vulkan_GetDrawableSize = SDL_Vulkan_GetDrawableSize;
extern fn SDL_Vulkan_GetDrawableSize(
    window: ?*SDL_Window,
    w: *c_int,
    h: *c_int,
) void;

/// 
/// Add support for gamepads that SDL is unaware of or change the binding of an
/// existing gamepad.
/// 
/// The mapping string has the format "GUID,name,mapping", where GUID is the
/// string value from SDL_GetJoystickGUIDString(), name is the human readable
/// string for the device and mappings are gamepad mappings to joystick
/// ones. Under Windows there is a reserved GUID of "xinput" that covers all
/// XInput devices. The mapping format for joystick is: {| |bX |a joystick
/// button, index X |- |hX.Y |hat X with value Y |- |aX |axis X of the joystick
/// |} Buttons can be used as a gamepad axes and vice versa.
/// 
/// This string shows an example of a valid mapping for a gamepad:
/// 
/// ```c
/// "341a3608000000000000504944564944,Afterglow PS3 Controller,a:b1,b:b2,y:b3,x:b0,start:b9,guide:b12,back:b8,dpup:h0.1,dpleft:h0.8,dpdown:h0.4,dpright:h0.2,leftshoulder:b4,rightshoulder:b5,leftstick:b10,rightstick:b11,leftx:a0,lefty:a1,rightx:a2,righty:a3,lefttrigger:b6,righttrigger:b7"
/// ```
/// 
/// \param mappingString the mapping string
/// \returns 1 if a new mapping is added, 0 if an existing mapping is updated,
///          -1 on error; call SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_GetGamepadMapping
/// \sa SDL_GetGamepadMappingForGUID
/// 
/// 
pub const AddGamepadMapping = SDL_AddGamepadMapping;
extern fn SDL_AddGamepadMapping(
    mappingString: ?[*:0]const u8,
) c_int;

/// 
/// Load a set of gamepad mappings from a seekable SDL data stream.
/// 
/// You can call this function several times, if needed, to load different
/// database files.
/// 
/// If a new mapping is loaded for an already known gamepad GUID, the later
/// version will overwrite the one currently loaded.
/// 
/// Mappings not belonging to the current platform or with no platform field
/// specified will be ignored (i.e. mappings for Linux will be ignored in
/// Windows, etc).
/// 
/// This function will load the text database entirely in memory before
/// processing it, so take this into consideration if you are in a memory
/// constrained environment.
/// 
/// \param rw the data stream for the mappings to be added
/// \param freerw non-zero to close the stream after being read
/// \returns the number of mappings added or -1 on error; call SDL_GetError()
///          for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_AddGamepadMapping
/// \sa SDL_AddGamepadMappingsFromFile
/// \sa SDL_GetGamepadMappingForGUID
/// 
/// 
pub const AddGamepadMappingsFromRW = SDL_AddGamepadMappingsFromRW;
extern fn SDL_AddGamepadMappingsFromRW(
    rw: ?*SDL_RWops,
    freerw: c_int,
) c_int;

/// 
/// Get the number of mappings installed.
/// 
/// \returns the number of mappings.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const GetNumGamepadMappings = SDL_GetNumGamepadMappings;
extern fn SDL_GetNumGamepadMappings() c_int;

/// 
/// Get the mapping at a particular index.
/// 
/// \returns the mapping string. Must be freed with SDL_free(). Returns NULL if
///          the index is out of range.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const GetGamepadMappingForIndex = SDL_GetGamepadMappingForIndex;
extern fn SDL_GetGamepadMappingForIndex(
    mapping_index: c_int,
) ?[*:0]u8;

/// 
/// Get the gamepad mapping string for a given GUID.
/// 
/// The returned string must be freed with SDL_free().
/// 
/// \param guid a structure containing the GUID for which a mapping is desired
/// \returns a mapping string or NULL on error; call SDL_GetError() for more
///          information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_GetJoystickInstanceGUID
/// \sa SDL_GetJoystickGUID
/// 
/// 
pub const GetGamepadMappingForGUID = SDL_GetGamepadMappingForGUID;
extern fn SDL_GetGamepadMappingForGUID(
    guid: SDL_JoystickGUID,
) ?[*:0]u8;

/// 
/// Get the current mapping of a gamepad.
/// 
/// The returned string must be freed with SDL_free().
/// 
/// Details about mappings are discussed with SDL_AddGamepadMapping().
/// 
/// \param gamepad the gamepad you want to get the current
///                       mapping for
/// \returns a string that has the gamepad's mapping or NULL if no mapping
///          is available; call SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_AddGamepadMapping
/// \sa SDL_GetGamepadMappingForGUID
/// 
/// 
pub const GetGamepadMapping = SDL_GetGamepadMapping;
extern fn SDL_GetGamepadMapping(
    gamepad: ?*SDL_Gamepad,
) ?[*:0]u8;

/// 
/// Get a list of currently connected gamepads.
/// 
/// \param count a pointer filled in with the number of gamepads returned
/// \returns a 0 terminated array of joystick instance IDs which should be freed with SDL_free(), or NULL on error; call SDL_GetError() for more details.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_OpenGamepad
/// 
/// 
pub const GetGamepads = SDL_GetGamepads;
extern fn SDL_GetGamepads(
    count: *c_int,
) ?*SDL_JoystickID;

/// 
/// Check if the given joystick is supported by the gamepad interface.
/// 
/// \param instance_id the joystick instance ID
/// \returns SDL_TRUE if the given joystick is supported by the gamepad
///          interface, SDL_FALSE if it isn't or it's an invalid index.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_GetGamepadNameForIndex
/// \sa SDL_OpenGamepad
/// 
/// 
pub const IsGamepad = SDL_IsGamepad;
extern fn SDL_IsGamepad(
    instance_id: SDL_JoystickID,
) bool;

/// 
/// Get the implementation dependent name of a gamepad.
/// 
/// This can be called before any gamepads are opened.
/// 
/// \param instance_id the joystick instance ID
/// \returns the name of the selected gamepad. If no name can be found, this
///          function returns NULL; call SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_GetGamepadName
/// \sa SDL_OpenGamepad
/// 
/// 
pub const GetGamepadInstanceName = SDL_GetGamepadInstanceName;
extern fn SDL_GetGamepadInstanceName(
    instance_id: SDL_JoystickID,
) ?[*:0]const u8;

/// 
/// Get the implementation dependent path of a gamepad.
/// 
/// This can be called before any gamepads are opened.
/// 
/// \param instance_id the joystick instance ID
/// \returns the path of the selected gamepad. If no path can be found, this
///          function returns NULL; call SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_GetGamepadPath
/// \sa SDL_OpenGamepad
/// 
/// 
pub const GetGamepadInstancePath = SDL_GetGamepadInstancePath;
extern fn SDL_GetGamepadInstancePath(
    instance_id: SDL_JoystickID,
) ?[*:0]const u8;

/// 
/// Get the player index of a gamepad.
/// 
/// This can be called before any gamepads are opened.
/// 
/// \param instance_id the joystick instance ID
/// \returns the player index of a gamepad, or -1 if it's not available
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_GetGamepadPlayerIndex
/// \sa SDL_OpenGamepad
/// 
/// 
pub const GetGamepadInstancePlayerIndex = SDL_GetGamepadInstancePlayerIndex;
extern fn SDL_GetGamepadInstancePlayerIndex(
    instance_id: SDL_JoystickID,
) c_int;

/// 
/// Get the implementation-dependent GUID of a gamepad.
/// 
/// This can be called before any gamepads are opened.
/// 
/// \param instance_id the joystick instance ID
/// \returns the GUID of the selected gamepad. If called on an invalid index,
///          this function returns a zero GUID
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_GetGamepadGUID
/// \sa SDL_GetGamepadGUIDString
/// 
/// 
pub const GetGamepadInstanceGUID = SDL_GetGamepadInstanceGUID;
extern fn SDL_GetGamepadInstanceGUID(
    instance_id: SDL_JoystickID,
) SDL_JoystickGUID;

/// 
/// Get the USB vendor ID of a gamepad, if available.
/// 
/// This can be called before any gamepads are opened. If the vendor ID isn't
/// available this function returns 0.
/// 
/// \param instance_id the joystick instance ID
/// \returns the USB vendor ID of the selected gamepad. If called on an
///          invalid index, this function returns zero
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const GetGamepadInstanceVendor = SDL_GetGamepadInstanceVendor;
extern fn SDL_GetGamepadInstanceVendor(
    instance_id: SDL_JoystickID,
) u16;

/// 
/// Get the USB product ID of a gamepad, if available.
/// 
/// This can be called before any gamepads are opened. If the product ID isn't
/// available this function returns 0.
/// 
/// \param instance_id the joystick instance ID
/// \returns the USB product ID of the selected gamepad. If called on an
///          invalid index, this function returns zero
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const GetGamepadInstanceProduct = SDL_GetGamepadInstanceProduct;
extern fn SDL_GetGamepadInstanceProduct(
    instance_id: SDL_JoystickID,
) u16;

/// 
/// Get the product version of a gamepad, if available.
/// 
/// This can be called before any gamepads are opened. If the product version
/// isn't available this function returns 0.
/// 
/// \param instance_id the joystick instance ID
/// \returns the product version of the selected gamepad. If called on an
///          invalid index, this function returns zero
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const GetGamepadInstanceProductVersion = SDL_GetGamepadInstanceProductVersion;
extern fn SDL_GetGamepadInstanceProductVersion(
    instance_id: SDL_JoystickID,
) u16;

/// 
/// Get the type of a gamepad.
/// 
/// This can be called before any gamepads are opened.
/// 
/// \param instance_id the joystick instance ID
/// \returns the gamepad type.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const GetGamepadInstanceType = SDL_GetGamepadInstanceType;
extern fn SDL_GetGamepadInstanceType(
    instance_id: SDL_JoystickID,
) SDL_GamepadType;

/// 
/// Get the mapping of a gamepad.
/// 
/// This can be called before any gamepads are opened.
/// 
/// \param instance_id the joystick instance ID
/// \returns the mapping string. Must be freed with SDL_free(). Returns NULL if
///          no mapping is available.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const GetGamepadInstanceMapping = SDL_GetGamepadInstanceMapping;
extern fn SDL_GetGamepadInstanceMapping(
    instance_id: SDL_JoystickID,
) ?[*:0]u8;

/// 
/// Open a gamepad for use.
/// 
/// \param instance_id the joystick instance ID
/// \returns a gamepad identifier or NULL if an error occurred; call
///          SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_CloseGamepad
/// \sa SDL_GetGamepadNameForIndex
/// \sa SDL_IsGamepad
/// 
/// 
pub const OpenGamepad = SDL_OpenGamepad;
extern fn SDL_OpenGamepad(
    instance_id: SDL_JoystickID,
) ?*SDL_Gamepad;

/// 
/// Get the SDL_Gamepad associated with a joystick instance ID.
/// 
/// \param instance_id the joystick instance ID of the gamepad
/// \returns an SDL_Gamepad on success or NULL on failure; call
///          SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const GetGamepadFromInstanceID = SDL_GetGamepadFromInstanceID;
extern fn SDL_GetGamepadFromInstanceID(
    instance_id: SDL_JoystickID,
) ?*SDL_Gamepad;

/// 
/// Get the SDL_Gamepad associated with a player index.
/// 
/// \param player_index the player index, which different from the instance ID
/// \returns the SDL_Gamepad associated with a player index.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_GetGamepadPlayerIndex
/// \sa SDL_SetGamepadPlayerIndex
/// 
/// 
pub const GetGamepadFromPlayerIndex = SDL_GetGamepadFromPlayerIndex;
extern fn SDL_GetGamepadFromPlayerIndex(
    player_index: c_int,
) ?*SDL_Gamepad;

/// 
/// Get the implementation-dependent name for an opened gamepad.
/// 
/// This is the same name as returned by SDL_GetGamepadNameForIndex(), but
/// it takes a gamepad identifier instead of the (unstable) device index.
/// 
/// \param gamepad a gamepad identifier previously returned by
///                       SDL_OpenGamepad()
/// \returns the implementation dependent name for the gamepad, or NULL
///          if there is no name or the identifier passed is invalid.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_GetGamepadNameForIndex
/// \sa SDL_OpenGamepad
/// 
/// 
pub const GetGamepadName = SDL_GetGamepadName;
extern fn SDL_GetGamepadName(
    gamepad: ?*SDL_Gamepad,
) ?[*:0]const u8;

/// 
/// Get the implementation-dependent path for an opened gamepad.
/// 
/// This is the same path as returned by SDL_GetGamepadNameForIndex(), but
/// it takes a gamepad identifier instead of the (unstable) device index.
/// 
/// \param gamepad a gamepad identifier previously returned by
///                       SDL_OpenGamepad()
/// \returns the implementation dependent path for the gamepad, or NULL
///          if there is no path or the identifier passed is invalid.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_GetGamepadInstancePath
/// 
/// 
pub const GetGamepadPath = SDL_GetGamepadPath;
extern fn SDL_GetGamepadPath(
    gamepad: ?*SDL_Gamepad,
) ?[*:0]const u8;

/// 
/// Get the type of this currently opened gamepad
/// 
/// This is the same name as returned by SDL_GetGamepadInstanceType(), but
/// it takes a gamepad identifier instead of the (unstable) device index.
/// 
/// \param gamepad the gamepad object to query.
/// \returns the gamepad type.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const GetGamepadType = SDL_GetGamepadType;
extern fn SDL_GetGamepadType(
    gamepad: ?*SDL_Gamepad,
) SDL_GamepadType;

/// 
/// Get the player index of an opened gamepad.
/// 
/// For XInput gamepads this returns the XInput user index.
/// 
/// \param gamepad the gamepad object to query.
/// \returns the player index for gamepad, or -1 if it's not available.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const GetGamepadPlayerIndex = SDL_GetGamepadPlayerIndex;
extern fn SDL_GetGamepadPlayerIndex(
    gamepad: ?*SDL_Gamepad,
) c_int;

/// 
/// Set the player index of an opened gamepad.
/// 
/// \param gamepad the gamepad object to adjust.
/// \param player_index Player index to assign to this gamepad, or -1 to
///                     clear the player index and turn off player LEDs.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const SetGamepadPlayerIndex = SDL_SetGamepadPlayerIndex;
extern fn SDL_SetGamepadPlayerIndex(
    gamepad: ?*SDL_Gamepad,
    player_index: c_int,
) void;

/// 
/// Get the USB vendor ID of an opened gamepad, if available.
/// 
/// If the vendor ID isn't available this function returns 0.
/// 
/// \param gamepad the gamepad object to query.
/// \return the USB vendor ID, or zero if unavailable.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const GetGamepadVendor = SDL_GetGamepadVendor;
extern fn SDL_GetGamepadVendor(
    gamepad: ?*SDL_Gamepad,
) u16;

/// 
/// Get the USB product ID of an opened gamepad, if available.
/// 
/// If the product ID isn't available this function returns 0.
/// 
/// \param gamepad the gamepad object to query.
/// \return the USB product ID, or zero if unavailable.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const GetGamepadProduct = SDL_GetGamepadProduct;
extern fn SDL_GetGamepadProduct(
    gamepad: ?*SDL_Gamepad,
) u16;

/// 
/// Get the product version of an opened gamepad, if available.
/// 
/// If the product version isn't available this function returns 0.
/// 
/// \param gamepad the gamepad object to query.
/// \return the USB product version, or zero if unavailable.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const GetGamepadProductVersion = SDL_GetGamepadProductVersion;
extern fn SDL_GetGamepadProductVersion(
    gamepad: ?*SDL_Gamepad,
) u16;

/// 
/// Get the firmware version of an opened gamepad, if available.
/// 
/// If the firmware version isn't available this function returns 0.
/// 
/// \param gamepad the gamepad object to query.
/// \return the gamepad firmware version, or zero if unavailable.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const GetGamepadFirmwareVersion = SDL_GetGamepadFirmwareVersion;
extern fn SDL_GetGamepadFirmwareVersion(
    gamepad: ?*SDL_Gamepad,
) u16;

/// 
/// Get the serial number of an opened gamepad, if available.
/// 
/// Returns the serial number of the gamepad, or NULL if it is not
/// available.
/// 
/// \param gamepad the gamepad object to query.
/// \return the serial number, or NULL if unavailable.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const GetGamepadSerial = SDL_GetGamepadSerial;
extern fn SDL_GetGamepadSerial(
    gamepad: ?*SDL_Gamepad,
) ?[*:0]const u8;

/// 
/// Check if a gamepad has been opened and is currently connected.
/// 
/// \param gamepad a gamepad identifier previously returned by
///                       SDL_OpenGamepad()
/// \returns SDL_TRUE if the gamepad has been opened and is currently
///          connected, or SDL_FALSE if not.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_CloseGamepad
/// \sa SDL_OpenGamepad
/// 
/// 
pub const GamepadConnected = SDL_GamepadConnected;
extern fn SDL_GamepadConnected(
    gamepad: ?*SDL_Gamepad,
) bool;

/// 
/// Get the underlying joystick from a gamepad
/// 
/// This function will give you a SDL_Joystick object, which allows you to use
/// the SDL_Joystick functions with a SDL_Gamepad object. This would be
/// useful for getting a joystick's position at any given time, even if it
/// hasn't moved (moving it would produce an event, which would have the axis'
/// value).
/// 
/// The pointer returned is owned by the SDL_Gamepad. You should not
/// call SDL_CloseJoystick() on it, for example, since doing so will likely
/// cause SDL to crash.
/// 
/// \param gamepad the gamepad object that you want to get a
///                       joystick from
/// \returns an SDL_Joystick object; call SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const GetGamepadJoystick = SDL_GetGamepadJoystick;
extern fn SDL_GetGamepadJoystick(
    gamepad: ?*SDL_Gamepad,
) ?*SDL_Joystick;

/// 
/// Set the state of gamepad event processing.
/// 
/// If gamepad events are disabled, you must call SDL_UpdateGamepads()
/// yourself and check the state of the gamepad when you want gamepad
/// information.
/// 
/// \param enabled whether to process gamepad events or not
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_GamepadEventsEnabled
/// 
/// 
pub const SetGamepadEventsEnabled = SDL_SetGamepadEventsEnabled;
extern fn SDL_SetGamepadEventsEnabled(
    enabled: bool,
) void;

/// 
/// Query the state of gamepad event processing.
/// 
/// If gamepad events are disabled, you must call SDL_UpdateGamepads()
/// yourself and check the state of the gamepad when you want gamepad
/// information.
/// 
/// \returns SDL_TRUE if gamepad events are being processed, SDL_FALSE otherwise.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_SetGamepadEventsEnabled
/// 
/// 
pub const GamepadEventsEnabled = SDL_GamepadEventsEnabled;
extern fn SDL_GamepadEventsEnabled() bool;

/// 
/// Manually pump gamepad updates if not using the loop.
/// 
/// This function is called automatically by the event loop if events are
/// enabled. Under such circumstances, it will not be necessary to call this
/// function.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const UpdateGamepads = SDL_UpdateGamepads;
extern fn SDL_UpdateGamepads() void;

/// 
/// Convert a string into SDL_GamepadAxis enum.
/// 
/// This function is called internally to translate SDL_Gamepad mapping
/// strings for the underlying joystick device into the consistent
/// SDL_Gamepad mapping. You do not normally need to call this function
/// unless you are parsing SDL_Gamepad mappings in your own code.
/// 
/// Note specially that "righttrigger" and "lefttrigger" map to
/// `SDL_GAMEPAD_AXIS_RIGHT_TRIGGER` and `SDL_GAMEPAD_AXIS_LEFT_TRIGGER`,
/// respectively.
/// 
/// \param str string representing a SDL_Gamepad axis
/// \returns the SDL_GamepadAxis enum corresponding to the input string,
///          or `SDL_GAMEPAD_AXIS_INVALID` if no match was found.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_GetGamepadStringForAxis
/// 
/// 
pub const GetGamepadAxisFromString = SDL_GetGamepadAxisFromString;
extern fn SDL_GetGamepadAxisFromString(
    str: ?[*:0]const u8,
) SDL_GamepadAxis;

/// 
/// Convert from an SDL_GamepadAxis enum to a string.
/// 
/// The caller should not SDL_free() the returned string.
/// 
/// \param axis an enum value for a given SDL_GamepadAxis
/// \returns a string for the given axis, or NULL if an invalid axis is
///          specified. The string returned is of the format used by
///          SDL_Gamepad mapping strings.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_GetGamepadAxisFromString
/// 
/// 
pub const GetGamepadStringForAxis = SDL_GetGamepadStringForAxis;
extern fn SDL_GetGamepadStringForAxis(
    axis: SDL_GamepadAxis,
) ?[*:0]const u8;

/// 
/// Get the SDL joystick layer binding for a gamepad axis mapping.
/// 
/// \param gamepad a gamepad
/// \param axis an axis enum value (one of the SDL_GamepadAxis values)
/// \returns a SDL_GamepadBinding describing the bind. On failure
///          (like the given Controller axis doesn't exist on the device), its
///          `.bindType` will be `SDL_GAMEPAD_BINDTYPE_NONE`.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_GetGamepadBindForButton
/// 
/// 
pub const GetGamepadBindForAxis = SDL_GetGamepadBindForAxis;
extern fn SDL_GetGamepadBindForAxis(
    gamepad: ?*SDL_Gamepad,
    axis: SDL_GamepadAxis,
) SDL_GamepadBinding;

/// 
/// Query whether a gamepad has a given axis.
/// 
/// This merely reports whether the gamepad's mapping defined this axis, as
/// that is all the information SDL has about the physical device.
/// 
/// \param gamepad a gamepad
/// \param axis an axis enum value (an SDL_GamepadAxis value)
/// \returns SDL_TRUE if the gamepad has this axis, SDL_FALSE otherwise.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const GamepadHasAxis = SDL_GamepadHasAxis;
extern fn SDL_GamepadHasAxis(
    gamepad: ?*SDL_Gamepad,
    axis: SDL_GamepadAxis,
) bool;

/// 
/// Get the current state of an axis control on a gamepad.
/// 
/// The axis indices start at index 0.
/// 
/// The state is a value ranging from -32768 to 32767. Triggers, however, range
/// from 0 to 32767 (they never return a negative value).
/// 
/// \param gamepad a gamepad
/// \param axis an axis index (one of the SDL_GamepadAxis values)
/// \returns axis state (including 0) on success or 0 (also) on failure; call
///          SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_GetGamepadButton
/// 
/// 
pub const GetGamepadAxis = SDL_GetGamepadAxis;
extern fn SDL_GetGamepadAxis(
    gamepad: ?*SDL_Gamepad,
    axis: SDL_GamepadAxis,
) i16;

/// 
/// Convert a string into an SDL_GamepadButton enum.
/// 
/// This function is called internally to translate SDL_Gamepad mapping
/// strings for the underlying joystick device into the consistent
/// SDL_Gamepad mapping. You do not normally need to call this function
/// unless you are parsing SDL_Gamepad mappings in your own code.
/// 
/// \param str string representing a SDL_Gamepad axis
/// \returns the SDL_GamepadButton enum corresponding to the input
///          string, or `SDL_GAMEPAD_AXIS_INVALID` if no match was found.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const GetGamepadButtonFromString = SDL_GetGamepadButtonFromString;
extern fn SDL_GetGamepadButtonFromString(
    str: ?[*:0]const u8,
) SDL_GamepadButton;

/// 
/// Convert from an SDL_GamepadButton enum to a string.
/// 
/// The caller should not SDL_free() the returned string.
/// 
/// \param button an enum value for a given SDL_GamepadButton
/// \returns a string for the given button, or NULL if an invalid button is
///          specified. The string returned is of the format used by
///          SDL_Gamepad mapping strings.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_GetGamepadButtonFromString
/// 
/// 
pub const GetGamepadStringForButton = SDL_GetGamepadStringForButton;
extern fn SDL_GetGamepadStringForButton(
    button: SDL_GamepadButton,
) ?[*:0]const u8;

/// 
/// Get the SDL joystick layer binding for a gamepad button mapping.
/// 
/// \param gamepad a gamepad
/// \param button an button enum value (an SDL_GamepadButton value)
/// \returns a SDL_GamepadBinding describing the bind. On failure
///          (like the given Controller button doesn't exist on the device),
///          its `.bindType` will be `SDL_GAMEPAD_BINDTYPE_NONE`.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_GetGamepadBindForAxis
/// 
/// 
pub const GetGamepadBindForButton = SDL_GetGamepadBindForButton;
extern fn SDL_GetGamepadBindForButton(
    gamepad: ?*SDL_Gamepad,
    button: SDL_GamepadButton,
) SDL_GamepadBinding;

/// 
/// Query whether a gamepad has a given button.
/// 
/// This merely reports whether the gamepad's mapping defined this button,
/// as that is all the information SDL has about the physical device.
/// 
/// \param gamepad a gamepad
/// \param button a button enum value (an SDL_GamepadButton value)
/// \returns SDL_TRUE if the gamepad has this button, SDL_FALSE otherwise.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const GamepadHasButton = SDL_GamepadHasButton;
extern fn SDL_GamepadHasButton(
    gamepad: ?*SDL_Gamepad,
    button: SDL_GamepadButton,
) bool;

/// 
/// Get the current state of a button on a gamepad.
/// 
/// \param gamepad a gamepad
/// \param button a button index (one of the SDL_GamepadButton values)
/// \returns 1 for pressed state or 0 for not pressed state or error; call
///          SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_GetGamepadAxis
/// 
/// 
pub const GetGamepadButton = SDL_GetGamepadButton;
extern fn SDL_GetGamepadButton(
    gamepad: ?*SDL_Gamepad,
    button: SDL_GamepadButton,
) u8;

/// 
/// Get the number of touchpads on a gamepad.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const GetGamepadNumTouchpads = SDL_GetGamepadNumTouchpads;
extern fn SDL_GetGamepadNumTouchpads(
    gamepad: ?*SDL_Gamepad,
) c_int;

/// 
/// Get the number of supported simultaneous fingers on a touchpad on a game
/// gamepad.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const GetGamepadNumTouchpadFingers = SDL_GetGamepadNumTouchpadFingers;
extern fn SDL_GetGamepadNumTouchpadFingers(
    gamepad: ?*SDL_Gamepad,
    touchpad: c_int,
) c_int;

/// 
/// Get the current state of a finger on a touchpad on a gamepad.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const GetGamepadTouchpadFinger = SDL_GetGamepadTouchpadFinger;
extern fn SDL_GetGamepadTouchpadFinger(
    gamepad: ?*SDL_Gamepad,
    touchpad: c_int,
    finger: c_int,
    state: ?*u8,
    x: *f32,
    y: *f32,
    pressure: *f32,
) c_int;

/// 
/// Return whether a gamepad has a particular sensor.
/// 
/// \param gamepad The gamepad to query
/// \param type The type of sensor to query
/// \returns SDL_TRUE if the sensor exists, SDL_FALSE otherwise.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const GamepadHasSensor = SDL_GamepadHasSensor;
extern fn SDL_GamepadHasSensor(
    gamepad: ?*SDL_Gamepad,
    type: SDL_SensorType,
) bool;

/// 
/// Set whether data reporting for a gamepad sensor is enabled.
/// 
/// \param gamepad The gamepad to update
/// \param type The type of sensor to enable/disable
/// \param enabled Whether data reporting should be enabled
/// \returns 0 or -1 if an error occurred.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const SetGamepadSensorEnabled = SDL_SetGamepadSensorEnabled;
extern fn SDL_SetGamepadSensorEnabled(
    gamepad: ?*SDL_Gamepad,
    type: SDL_SensorType,
    enabled: bool,
) c_int;

/// 
/// Query whether sensor data reporting is enabled for a gamepad.
/// 
/// \param gamepad The gamepad to query
/// \param type The type of sensor to query
/// \returns SDL_TRUE if the sensor is enabled, SDL_FALSE otherwise.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const GamepadSensorEnabled = SDL_GamepadSensorEnabled;
extern fn SDL_GamepadSensorEnabled(
    gamepad: ?*SDL_Gamepad,
    type: SDL_SensorType,
) bool;

/// 
/// Get the data rate (number of events per second) of a gamepad
/// sensor.
/// 
/// \param gamepad The gamepad to query
/// \param type The type of sensor to query
/// \return the data rate, or 0.0f if the data rate is not available.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const GetGamepadSensorDataRate = SDL_GetGamepadSensorDataRate;
extern fn SDL_GetGamepadSensorDataRate(
    gamepad: ?*SDL_Gamepad,
    type: SDL_SensorType,
) f32;

/// 
/// Get the current state of a gamepad sensor.
/// 
/// The number of values and interpretation of the data is sensor dependent.
/// See SDL_sensor.h for the details for each type of sensor.
/// 
/// \param gamepad The gamepad to query
/// \param type The type of sensor to query
/// \param data A pointer filled with the current sensor state
/// \param num_values The number of values to write to data
/// \return 0 or -1 if an error occurred.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const GetGamepadSensorData = SDL_GetGamepadSensorData;
extern fn SDL_GetGamepadSensorData(
    gamepad: ?*SDL_Gamepad,
    type: SDL_SensorType,
    data: *f32,
    num_values: c_int,
) c_int;

/// 
/// Start a rumble effect on a gamepad.
/// 
/// Each call to this function cancels any previous rumble effect, and calling
/// it with 0 intensity stops any rumbling.
/// 
/// \param gamepad The gamepad to vibrate
/// \param low_frequency_rumble The intensity of the low frequency (left)
///                             rumble motor, from 0 to 0xFFFF
/// \param high_frequency_rumble The intensity of the high frequency (right)
///                              rumble motor, from 0 to 0xFFFF
/// \param duration_ms The duration of the rumble effect, in milliseconds
/// \returns 0, or -1 if rumble isn't supported on this gamepad
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_GamepadHasRumble
/// 
/// 
pub const RumbleGamepad = SDL_RumbleGamepad;
extern fn SDL_RumbleGamepad(
    gamepad: ?*SDL_Gamepad,
    low_frequency_rumble: u16,
    high_frequency_rumble: u16,
    duration_ms: u32,
) c_int;

/// 
/// Start a rumble effect in the gamepad's triggers.
/// 
/// Each call to this function cancels any previous trigger rumble effect, and
/// calling it with 0 intensity stops any rumbling.
/// 
/// Note that this is rumbling of the _triggers_ and not the gamepad as
/// a whole. This is currently only supported on Xbox One gamepads. If you
/// want the (more common) whole-gamepad rumble, use
/// SDL_RumbleGamepad() instead.
/// 
/// \param gamepad The gamepad to vibrate
/// \param left_rumble The intensity of the left trigger rumble motor, from 0
///                    to 0xFFFF
/// \param right_rumble The intensity of the right trigger rumble motor, from 0
///                     to 0xFFFF
/// \param duration_ms The duration of the rumble effect, in milliseconds
/// \returns 0, or -1 if trigger rumble isn't supported on this gamepad
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_GamepadHasRumbleTriggers
/// 
/// 
pub const RumbleGamepadTriggers = SDL_RumbleGamepadTriggers;
extern fn SDL_RumbleGamepadTriggers(
    gamepad: ?*SDL_Gamepad,
    left_rumble: u16,
    right_rumble: u16,
    duration_ms: u32,
) c_int;

/// 
/// Query whether a gamepad has an LED.
/// 
/// \param gamepad The gamepad to query
/// \returns SDL_TRUE, or SDL_FALSE if this gamepad does not have a
///          modifiable LED
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const GamepadHasLED = SDL_GamepadHasLED;
extern fn SDL_GamepadHasLED(
    gamepad: ?*SDL_Gamepad,
) bool;

/// 
/// Query whether a gamepad has rumble support.
/// 
/// \param gamepad The gamepad to query
/// \returns SDL_TRUE, or SDL_FALSE if this gamepad does not have rumble
///          support
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_RumbleGamepad
/// 
/// 
pub const GamepadHasRumble = SDL_GamepadHasRumble;
extern fn SDL_GamepadHasRumble(
    gamepad: ?*SDL_Gamepad,
) bool;

/// 
/// Query whether a gamepad has rumble support on triggers.
/// 
/// \param gamepad The gamepad to query
/// \returns SDL_TRUE, or SDL_FALSE if this gamepad does not have trigger
///          rumble support
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_RumbleGamepadTriggers
/// 
/// 
pub const GamepadHasRumbleTriggers = SDL_GamepadHasRumbleTriggers;
extern fn SDL_GamepadHasRumbleTriggers(
    gamepad: ?*SDL_Gamepad,
) bool;

/// 
/// Update a gamepad's LED color.
/// 
/// \param gamepad The gamepad to update
/// \param red The intensity of the red LED
/// \param green The intensity of the green LED
/// \param blue The intensity of the blue LED
/// \returns 0, or -1 if this gamepad does not have a modifiable LED
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const SetGamepadLED = SDL_SetGamepadLED;
extern fn SDL_SetGamepadLED(
    gamepad: ?*SDL_Gamepad,
    red: u8,
    green: u8,
    blue: u8,
) c_int;

/// 
/// Send a gamepad specific effect packet
/// 
/// \param gamepad The gamepad to affect
/// \param data The data to send to the gamepad
/// \param size The size of the data to send to the gamepad
/// \returns 0, or -1 if this gamepad or driver doesn't support effect
///          packets
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const SendGamepadEffect = SDL_SendGamepadEffect;
extern fn SDL_SendGamepadEffect(
    gamepad: ?*SDL_Gamepad,
    data: ?*const anyopaque,
    size: c_int,
) c_int;

/// 
/// Close a gamepad previously opened with SDL_OpenGamepad().
/// 
/// \param gamepad a gamepad identifier previously returned by SDL_OpenGamepad()
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_OpenGamepad
/// 
/// 
pub const CloseGamepad = SDL_CloseGamepad;
extern fn SDL_CloseGamepad(
    gamepad: ?*SDL_Gamepad,
) void;

/// 
/// Return the sfSymbolsName for a given button on a gamepad on Apple
/// platforms.
/// 
/// \param gamepad the gamepad to query
/// \param button a button on the gamepad
/// \returns the sfSymbolsName or NULL if the name can't be found
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_GetGamepadAppleSFSymbolsNameForAxis
/// 
/// 
pub const GetGamepadAppleSFSymbolsNameForButton = SDL_GetGamepadAppleSFSymbolsNameForButton;
extern fn SDL_GetGamepadAppleSFSymbolsNameForButton(
    gamepad: ?*SDL_Gamepad,
    button: SDL_GamepadButton,
) ?[*:0]const u8;

/// 
/// Return the sfSymbolsName for a given axis on a gamepad on Apple
/// platforms.
/// 
/// \param gamepad the gamepad to query
/// \param axis an axis on the gamepad
/// \returns the sfSymbolsName or NULL if the name can't be found
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_GetGamepadAppleSFSymbolsNameForButton
/// 
/// 
pub const GetGamepadAppleSFSymbolsNameForAxis = SDL_GetGamepadAppleSFSymbolsNameForAxis;
extern fn SDL_GetGamepadAppleSFSymbolsNameForAxis(
    gamepad: ?*SDL_Gamepad,
    axis: SDL_GamepadAxis,
) ?[*:0]const u8;

/// 
/// Get the number of 2D rendering drivers available for the current display.
/// 
/// A render driver is a set of code that handles rendering and texture
/// management on a particular display. Normally there is only one, but some
/// drivers may have several available with different capabilities.
/// 
/// There may be none if SDL was compiled without render support.
/// 
/// \returns a number >= 0 on success or a negative error code on failure; call
///          SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_CreateRenderer
/// \sa SDL_GetRenderDriver
/// 
/// 
pub const GetNumRenderDrivers = SDL_GetNumRenderDrivers;
extern fn SDL_GetNumRenderDrivers() c_int;

/// 
/// Use this function to get the name of a built in 2D rendering driver.
/// 
/// The list of rendering drivers is given in the order that they are normally
/// initialized by default; the drivers that seem more reasonable to choose
/// first (as far as the SDL developers believe) are earlier in the list.
/// 
/// The names of drivers are all simple, low-ASCII identifiers, like "opengl",
/// "direct3d12" or "metal". These never have Unicode characters, and are not
/// meant to be proper names.
/// 
/// The returned value points to a static, read-only string; do not modify or
/// free it!
/// 
/// \param index the index of the rendering driver; the value ranges from 0 to
///              SDL_GetNumRenderDrivers() - 1
/// \returns the name of the rendering driver at the requested index, or NULL
///          if an invalid index was specified.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_GetNumRenderDrivers
/// 
/// 
pub const GetRenderDriver = SDL_GetRenderDriver;
extern fn SDL_GetRenderDriver(
    index: c_int,
) ?[*:0]const u8;

/// 
/// Create a window and default renderer.
/// 
/// \param width the width of the window
/// \param height the height of the window
/// \param window_flags the flags used to create the window (see
///                     SDL_CreateWindow())
/// \param window a pointer filled with the window, or NULL on error
/// \param renderer a pointer filled with the renderer, or NULL on error
/// \returns 0 on success, or -1 on error; call SDL_GetError() for more
///          information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_CreateRenderer
/// \sa SDL_CreateWindow
/// 
/// 
pub const CreateWindowAndRenderer = SDL_CreateWindowAndRenderer;
extern fn SDL_CreateWindowAndRenderer(
    width: c_int,
    height: c_int,
    window_flags: u32,
    window: ?[*c]*SDL_Window,
    renderer: ?[*c]*SDL_Renderer,
) c_int;

/// 
/// Create a 2D rendering context for a window.
/// 
/// If you want a specific renderer, you can specify its name here. A list
/// of available renderers can be obtained by calling SDL_GetRenderDriver
/// multiple times, with indices from 0 to SDL_GetNumRenderDrivers()-1. If
/// you don't need a specific renderer, specify NULL and SDL will attempt
/// to chooes the best option for you, based on what is available on the
/// user's system.
/// 
/// \param window the window where rendering is displayed
/// \param name the name of the rendering driver to initialize, or NULL to
///             initialize the first one supporting the requested flags
/// \param flags 0, or one or more SDL_RendererFlags OR'd together
/// \returns a valid rendering context or NULL if there was an error; call
///          SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_CreateSoftwareRenderer
/// \sa SDL_DestroyRenderer
/// \sa SDL_GetNumRenderDrivers
/// \sa SDL_GetRenderDriver
/// \sa SDL_GetRendererInfo
/// 
/// 
pub const CreateRenderer = SDL_CreateRenderer;
extern fn SDL_CreateRenderer(
    window: ?*SDL_Window,
    name: ?[*:0]const u8,
    flags: u32,
) ?*SDL_Renderer;

/// 
/// Create a 2D software rendering context for a surface.
/// 
/// Two other API which can be used to create SDL_Renderer:
/// SDL_CreateRenderer() and SDL_CreateWindowAndRenderer(). These can _also_
/// create a software renderer, but they are intended to be used with an
/// SDL_Window as the final destination and not an SDL_Surface.
/// 
/// \param surface the SDL_Surface structure representing the surface where
///                rendering is done
/// \returns a valid rendering context or NULL if there was an error; call
///          SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_CreateRenderer
/// \sa SDL_CreateWindowRenderer
/// \sa SDL_DestroyRenderer
/// 
/// 
pub const CreateSoftwareRenderer = SDL_CreateSoftwareRenderer;
extern fn SDL_CreateSoftwareRenderer(
    surface: ?*SDL_Surface,
) ?*SDL_Renderer;

/// 
/// Get the renderer associated with a window.
/// 
/// \param window the window to query
/// \returns the rendering context on success or NULL on failure; call
///          SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_CreateRenderer
/// 
/// 
pub const GetRenderer = SDL_GetRenderer;
extern fn SDL_GetRenderer(
    window: ?*SDL_Window,
) ?*SDL_Renderer;

/// 
/// Get the window associated with a renderer.
/// 
/// \param renderer the renderer to query
/// \returns the window on success or NULL on failure; call SDL_GetError() for
///          more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const GetRenderWindow = SDL_GetRenderWindow;
extern fn SDL_GetRenderWindow(
    renderer: ?*SDL_Renderer,
) ?*SDL_Window;

/// 
/// Get information about a rendering context.
/// 
/// \param renderer the rendering context
/// \param info an SDL_RendererInfo structure filled with information about the
///             current renderer
/// \returns 0 on success or a negative error code on failure; call
///          SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_CreateRenderer
/// 
/// 
pub const GetRendererInfo = SDL_GetRendererInfo;
extern fn SDL_GetRendererInfo(
    renderer: ?*SDL_Renderer,
    info: ?*SDL_RendererInfo,
) c_int;

/// 
/// Get the output size in pixels of a rendering context.
/// 
/// Due to high-dpi displays, you might end up with a rendering context that
/// has more pixels than the window that contains it, so use this instead of
/// SDL_GetWindowSize() to decide how much drawing area you have.
/// 
/// \param renderer the rendering context
/// \param w an int filled with the width
/// \param h an int filled with the height
/// \returns 0 on success or a negative error code on failure; call
///          SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_GetRenderer
/// 
/// 
pub const GetRendererOutputSize = SDL_GetRendererOutputSize;
extern fn SDL_GetRendererOutputSize(
    renderer: ?*SDL_Renderer,
    w: *c_int,
    h: *c_int,
) c_int;

/// 
/// Create a texture for a rendering context.
/// 
/// You can set the texture scaling method by setting
/// `SDL_HINT_RENDER_SCALE_QUALITY` before creating the texture.
/// 
/// \param renderer the rendering context
/// \param format one of the enumerated values in SDL_PixelFormatEnum
/// \param access one of the enumerated values in SDL_TextureAccess
/// \param w the width of the texture in pixels
/// \param h the height of the texture in pixels
/// \returns a pointer to the created texture or NULL if no rendering context
///          was active, the format was unsupported, or the width or height
///          were out of range; call SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_CreateTextureFromSurface
/// \sa SDL_DestroyTexture
/// \sa SDL_QueryTexture
/// \sa SDL_UpdateTexture
/// 
/// 
pub const CreateTexture = SDL_CreateTexture;
extern fn SDL_CreateTexture(
    renderer: ?*SDL_Renderer,
    format: u32,
    access: c_int,
    w: c_int,
    h: c_int,
) ?*SDL_Texture;

/// 
/// Create a texture from an existing surface.
/// 
/// The surface is not modified or freed by this function.
/// 
/// The SDL_TextureAccess hint for the created texture is
/// `SDL_TEXTUREACCESS_STATIC`.
/// 
/// The pixel format of the created texture may be different from the pixel
/// format of the surface. Use SDL_QueryTexture() to query the pixel format of
/// the texture.
/// 
/// \param renderer the rendering context
/// \param surface the SDL_Surface structure containing pixel data used to fill
///                the texture
/// \returns the created texture or NULL on failure; call SDL_GetError() for
///          more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_CreateTexture
/// \sa SDL_DestroyTexture
/// \sa SDL_QueryTexture
/// 
/// 
pub const CreateTextureFromSurface = SDL_CreateTextureFromSurface;
extern fn SDL_CreateTextureFromSurface(
    renderer: ?*SDL_Renderer,
    surface: ?*SDL_Surface,
) ?*SDL_Texture;

/// 
/// Query the attributes of a texture.
/// 
/// \param texture the texture to query
/// \param format a pointer filled in with the raw format of the texture; the
///               actual format may differ, but pixel transfers will use this
///               format (one of the SDL_PixelFormatEnum values). This argument
///               can be NULL if you don't need this information.
/// \param access a pointer filled in with the actual access to the texture
///               (one of the SDL_TextureAccess values). This argument can be
///               NULL if you don't need this information.
/// \param w a pointer filled in with the width of the texture in pixels. This
///          argument can be NULL if you don't need this information.
/// \param h a pointer filled in with the height of the texture in pixels. This
///          argument can be NULL if you don't need this information.
/// \returns 0 on success or a negative error code on failure; call
///          SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_CreateTexture
/// 
/// 
pub const QueryTexture = SDL_QueryTexture;
extern fn SDL_QueryTexture(
    texture: ?*SDL_Texture,
    format: ?*u32,
    access: *c_int,
    w: *c_int,
    h: *c_int,
) c_int;

/// 
/// Set an additional color value multiplied into render copy operations.
/// 
/// When this texture is rendered, during the copy operation each source color
/// channel is modulated by the appropriate color value according to the
/// following formula:
/// 
/// `srcC = srcC * (color / 255)`
/// 
/// Color modulation is not always supported by the renderer; it will return -1
/// if color modulation is not supported.
/// 
/// \param texture the texture to update
/// \param r the red color value multiplied into copy operations
/// \param g the green color value multiplied into copy operations
/// \param b the blue color value multiplied into copy operations
/// \returns 0 on success or a negative error code on failure; call
///          SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_GetTextureColorMod
/// \sa SDL_SetTextureAlphaMod
/// 
/// 
pub const SetTextureColorMod = SDL_SetTextureColorMod;
extern fn SDL_SetTextureColorMod(
    texture: ?*SDL_Texture,
    r: u8,
    g: u8,
    b: u8,
) c_int;

/// 
/// Get the additional color value multiplied into render copy operations.
/// 
/// \param texture the texture to query
/// \param r a pointer filled in with the current red color value
/// \param g a pointer filled in with the current green color value
/// \param b a pointer filled in with the current blue color value
/// \returns 0 on success or a negative error code on failure; call
///          SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_GetTextureAlphaMod
/// \sa SDL_SetTextureColorMod
/// 
/// 
pub const GetTextureColorMod = SDL_GetTextureColorMod;
extern fn SDL_GetTextureColorMod(
    texture: ?*SDL_Texture,
    r: ?*u8,
    g: ?*u8,
    b: ?*u8,
) c_int;

/// 
/// Set an additional alpha value multiplied into render copy operations.
/// 
/// When this texture is rendered, during the copy operation the source alpha
/// value is modulated by this alpha value according to the following formula:
/// 
/// `srcA = srcA * (alpha / 255)`
/// 
/// Alpha modulation is not always supported by the renderer; it will return -1
/// if alpha modulation is not supported.
/// 
/// \param texture the texture to update
/// \param alpha the source alpha value multiplied into copy operations
/// \returns 0 on success or a negative error code on failure; call
///          SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_GetTextureAlphaMod
/// \sa SDL_SetTextureColorMod
/// 
/// 
pub const SetTextureAlphaMod = SDL_SetTextureAlphaMod;
extern fn SDL_SetTextureAlphaMod(
    texture: ?*SDL_Texture,
    alpha: u8,
) c_int;

/// 
/// Get the additional alpha value multiplied into render copy operations.
/// 
/// \param texture the texture to query
/// \param alpha a pointer filled in with the current alpha value
/// \returns 0 on success or a negative error code on failure; call
///          SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_GetTextureColorMod
/// \sa SDL_SetTextureAlphaMod
/// 
/// 
pub const GetTextureAlphaMod = SDL_GetTextureAlphaMod;
extern fn SDL_GetTextureAlphaMod(
    texture: ?*SDL_Texture,
    alpha: ?*u8,
) c_int;

/// 
/// Set the blend mode for a texture, used by SDL_RenderTexture().
/// 
/// If the blend mode is not supported, the closest supported mode is chosen
/// and this function returns -1.
/// 
/// \param texture the texture to update
/// \param blendMode the SDL_BlendMode to use for texture blending
/// \returns 0 on success or a negative error code on failure; call
///          SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_GetTextureBlendMode
/// \sa SDL_RenderTexture
/// 
/// 
pub const SetTextureBlendMode = SDL_SetTextureBlendMode;
extern fn SDL_SetTextureBlendMode(
    texture: ?*SDL_Texture,
    blendMode: SDL_BlendMode,
) c_int;

/// 
/// Get the blend mode used for texture copy operations.
/// 
/// \param texture the texture to query
/// \param blendMode a pointer filled in with the current SDL_BlendMode
/// \returns 0 on success or a negative error code on failure; call
///          SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_SetTextureBlendMode
/// 
/// 
pub const GetTextureBlendMode = SDL_GetTextureBlendMode;
extern fn SDL_GetTextureBlendMode(
    texture: ?*SDL_Texture,
    blendMode: ?*SDL_BlendMode,
) c_int;

/// 
/// Set the scale mode used for texture scale operations.
/// 
/// If the scale mode is not supported, the closest supported mode is chosen.
/// 
/// \param texture The texture to update.
/// \param scaleMode the SDL_ScaleMode to use for texture scaling.
/// \returns 0 on success, or -1 if the texture is not valid.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_GetTextureScaleMode
/// 
/// 
pub const SetTextureScaleMode = SDL_SetTextureScaleMode;
extern fn SDL_SetTextureScaleMode(
    texture: ?*SDL_Texture,
    scaleMode: SDL_ScaleMode,
) c_int;

/// 
/// Get the scale mode used for texture scale operations.
/// 
/// \param texture the texture to query.
/// \param scaleMode a pointer filled in with the current scale mode.
/// \return 0 on success, or -1 if the texture is not valid.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_SetTextureScaleMode
/// 
/// 
pub const GetTextureScaleMode = SDL_GetTextureScaleMode;
extern fn SDL_GetTextureScaleMode(
    texture: ?*SDL_Texture,
    scaleMode: ?*SDL_ScaleMode,
) c_int;

/// 
/// Associate a user-specified pointer with a texture.
/// 
/// \param texture the texture to update.
/// \param userdata the pointer to associate with the texture.
/// \returns 0 on success, or -1 if the texture is not valid.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_GetTextureUserData
/// 
/// 
pub const SetTextureUserData = SDL_SetTextureUserData;
extern fn SDL_SetTextureUserData(
    texture: ?*SDL_Texture,
    userdata: ?*anyopaque,
) c_int;

/// 
/// Get the user-specified pointer associated with a texture
/// 
/// \param texture the texture to query.
/// \return the pointer associated with the texture, or NULL if the texture is
///         not valid.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_SetTextureUserData
/// 
/// 
pub const GetTextureUserData = SDL_GetTextureUserData;
extern fn SDL_GetTextureUserData(
    texture: ?*SDL_Texture,
) ?*anyopaque;

/// 
/// Update the given texture rectangle with new pixel data.
/// 
/// The pixel data must be in the pixel format of the texture. Use
/// SDL_QueryTexture() to query the pixel format of the texture.
/// 
/// This is a fairly slow function, intended for use with static textures that
/// do not change often.
/// 
/// If the texture is intended to be updated often, it is preferred to create
/// the texture as streaming and use the locking functions referenced below.
/// While this function will work with streaming textures, for optimization
/// reasons you may not get the pixels back if you lock the texture afterward.
/// 
/// \param texture the texture to update
/// \param rect an SDL_Rect structure representing the area to update, or NULL
///             to update the entire texture
/// \param pixels the raw pixel data in the format of the texture
/// \param pitch the number of bytes in a row of pixel data, including padding
///              between lines
/// \returns 0 on success or a negative error code on failure; call
///          SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_CreateTexture
/// \sa SDL_LockTexture
/// \sa SDL_UnlockTexture
/// 
/// 
pub const UpdateTexture = SDL_UpdateTexture;
extern fn SDL_UpdateTexture(
    texture: ?*SDL_Texture,
    rect: ?*const SDL_Rect,
    pixels: ?*const anyopaque,
    pitch: c_int,
) c_int;

/// 
/// Update a rectangle within a planar YV12 or IYUV texture with new pixel
/// data.
/// 
/// You can use SDL_UpdateTexture() as long as your pixel data is a contiguous
/// block of Y and U/V planes in the proper order, but this function is
/// available if your pixel data is not contiguous.
/// 
/// \param texture the texture to update
/// \param rect a pointer to the rectangle of pixels to update, or NULL to
///             update the entire texture
/// \param Yplane the raw pixel data for the Y plane
/// \param Ypitch the number of bytes between rows of pixel data for the Y
///               plane
/// \param Uplane the raw pixel data for the U plane
/// \param Upitch the number of bytes between rows of pixel data for the U
///               plane
/// \param Vplane the raw pixel data for the V plane
/// \param Vpitch the number of bytes between rows of pixel data for the V
///               plane
/// \returns 0 on success or -1 if the texture is not valid; call
///          SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_UpdateTexture
/// 
/// 
pub const UpdateYUVTexture = SDL_UpdateYUVTexture;
extern fn SDL_UpdateYUVTexture(
    texture: ?*SDL_Texture,
    rect: ?*const SDL_Rect,
    Yplane: ?[*]const u8,
    Ypitch: c_int,
    Uplane: ?[*]const u8,
    Upitch: c_int,
    Vplane: ?[*]const u8,
    Vpitch: c_int,
) c_int;

/// 
/// Update a rectangle within a planar NV12 or NV21 texture with new pixels.
/// 
/// You can use SDL_UpdateTexture() as long as your pixel data is a contiguous
/// block of NV12/21 planes in the proper order, but this function is available
/// if your pixel data is not contiguous.
/// 
/// \param texture the texture to update
/// \param rect a pointer to the rectangle of pixels to update, or NULL to
///             update the entire texture.
/// \param Yplane the raw pixel data for the Y plane.
/// \param Ypitch the number of bytes between rows of pixel data for the Y
///               plane.
/// \param UVplane the raw pixel data for the UV plane.
/// \param UVpitch the number of bytes between rows of pixel data for the UV
///                plane.
/// \return 0 on success, or -1 if the texture is not valid.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const UpdateNVTexture = SDL_UpdateNVTexture;
extern fn SDL_UpdateNVTexture(
    texture: ?*SDL_Texture,
    rect: ?*const SDL_Rect,
    Yplane: ?[*]const u8,
    Ypitch: c_int,
    UVplane: ?[*]const u8,
    UVpitch: c_int,
) c_int;

/// 
/// Lock a portion of the texture for **write-only** pixel access.
/// 
/// As an optimization, the pixels made available for editing don't necessarily
/// contain the old texture data. This is a write-only operation, and if you
/// need to keep a copy of the texture data you should do that at the
/// application level.
/// 
/// You must use SDL_UnlockTexture() to unlock the pixels and apply any
/// changes.
/// 
/// \param texture the texture to lock for access, which was created with
///                `SDL_TEXTUREACCESS_STREAMING`
/// \param rect an SDL_Rect structure representing the area to lock for access;
///             NULL to lock the entire texture
/// \param pixels this is filled in with a pointer to the locked pixels,
///               appropriately offset by the locked area
/// \param pitch this is filled in with the pitch of the locked pixels; the
///              pitch is the length of one row in bytes
/// \returns 0 on success or a negative error code if the texture is not valid
///          or was not created with `SDL_TEXTUREACCESS_STREAMING`; call
///          SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_UnlockTexture
/// 
/// 
pub const LockTexture = SDL_LockTexture;
extern fn SDL_LockTexture(
    texture: ?*SDL_Texture,
    rect: ?*const SDL_Rect,
    pixels: [*c][*c]anyopaque,
    pitch: *c_int,
) c_int;

/// 
/// Lock a portion of the texture for **write-only** pixel access, and expose
/// it as a SDL surface.
/// 
/// Besides providing an SDL_Surface instead of raw pixel data, this function
/// operates like SDL_LockTexture.
/// 
/// As an optimization, the pixels made available for editing don't necessarily
/// contain the old texture data. This is a write-only operation, and if you
/// need to keep a copy of the texture data you should do that at the
/// application level.
/// 
/// You must use SDL_UnlockTexture() to unlock the pixels and apply any
/// changes.
/// 
/// The returned surface is freed internally after calling SDL_UnlockTexture()
/// or SDL_DestroyTexture(). The caller should not free it.
/// 
/// \param texture the texture to lock for access, which was created with
///                `SDL_TEXTUREACCESS_STREAMING`
/// \param rect a pointer to the rectangle to lock for access. If the rect is
///             NULL, the entire texture will be locked
/// \param surface this is filled in with an SDL surface representing the
///                locked area
/// \returns 0 on success, or -1 if the texture is not valid or was not created
///          with `SDL_TEXTUREACCESS_STREAMING`
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_LockTexture
/// \sa SDL_UnlockTexture
/// 
/// 
pub const LockTextureToSurface = SDL_LockTextureToSurface;
extern fn SDL_LockTextureToSurface(
    texture: ?*SDL_Texture,
    rect: ?*const SDL_Rect,
    surface: ?[*c]*SDL_Surface,
) c_int;

/// 
/// Unlock a texture, uploading the changes to video memory, if needed.
/// 
/// **Warning**: Please note that SDL_LockTexture() is intended to be
/// write-only; it will not guarantee the previous contents of the texture will
/// be provided. You must fully initialize any area of a texture that you lock
/// before unlocking it, as the pixels might otherwise be uninitialized memory.
/// 
/// Which is to say: locking and immediately unlocking a texture can result in
/// corrupted textures, depending on the renderer in use.
/// 
/// \param texture a texture locked by SDL_LockTexture()
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_LockTexture
/// 
/// 
pub const UnlockTexture = SDL_UnlockTexture;
extern fn SDL_UnlockTexture(
    texture: ?*SDL_Texture,
) void;

/// 
/// Determine whether a renderer supports the use of render targets.
/// 
/// \param renderer the renderer that will be checked
/// \returns SDL_TRUE if supported or SDL_FALSE if not.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_SetRenderTarget
/// 
/// 
pub const RenderTargetSupported = SDL_RenderTargetSupported;
extern fn SDL_RenderTargetSupported(
    renderer: ?*SDL_Renderer,
) bool;

/// 
/// Set a texture as the current rendering target.
/// 
/// Before using this function, you should check the
/// `SDL_RENDERER_TARGETTEXTURE` bit in the flags of SDL_RendererInfo to see if
/// render targets are supported.
/// 
/// The default render target is the window for which the renderer was created.
/// To stop rendering to a texture and render to the window again, call this
/// function with a NULL `texture`.
/// 
/// \param renderer the rendering context
/// \param texture the targeted texture, which must be created with the
///                `SDL_TEXTUREACCESS_TARGET` flag, or NULL to render to the
///                window instead of a texture.
/// \returns 0 on success or a negative error code on failure; call
///          SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_GetRenderTarget
/// 
/// 
pub const SetRenderTarget = SDL_SetRenderTarget;
extern fn SDL_SetRenderTarget(
    renderer: ?*SDL_Renderer,
    texture: ?*SDL_Texture,
) c_int;

/// 
/// Get the current render target.
/// 
/// The default render target is the window for which the renderer was created,
/// and is reported a NULL here.
/// 
/// \param renderer the rendering context
/// \returns the current render target or NULL for the default render target.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_SetRenderTarget
/// 
/// 
pub const GetRenderTarget = SDL_GetRenderTarget;
extern fn SDL_GetRenderTarget(
    renderer: ?*SDL_Renderer,
) ?*SDL_Texture;

/// 
/// Set a device independent resolution for rendering.
/// 
/// This function uses the viewport and scaling functionality to allow a fixed
/// logical resolution for rendering, regardless of the actual output
/// resolution. If the actual output resolution doesn't have the same aspect
/// ratio the output rendering will be centered within the output display.
/// 
/// If the output display is a window, mouse and touch events in the window
/// will be filtered and scaled so they seem to arrive within the logical
/// resolution. The SDL_HINT_MOUSE_RELATIVE_SCALING hint controls whether
/// relative motion events are also scaled.
/// 
/// If this function results in scaling or subpixel drawing by the rendering
/// backend, it will be handled using the appropriate quality hints.
/// 
/// \param renderer the renderer for which resolution should be set
/// \param w the width of the logical resolution
/// \param h the height of the logical resolution
/// \returns 0 on success or a negative error code on failure; call
///          SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_GetRenderLogicalSize
/// 
/// 
pub const SetRenderLogicalSize = SDL_SetRenderLogicalSize;
extern fn SDL_SetRenderLogicalSize(
    renderer: ?*SDL_Renderer,
    w: c_int,
    h: c_int,
) c_int;

/// 
/// Get device independent resolution for rendering.
/// 
/// When using the main rendering target (eg no target texture is set): this
/// may return 0 for `w` and `h` if the SDL_Renderer has never had its logical
/// size set by SDL_SetRenderLogicalSize(). Otherwise it returns the logical
/// width and height.
/// 
/// When using a target texture: Never return 0 for `w` and `h` at first. Then
/// it returns the logical width and height that are set.
/// 
/// \param renderer a rendering context
/// \param w an int to be filled with the width
/// \param h an int to be filled with the height
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_SetRenderLogicalSize
/// 
/// 
pub const GetRenderLogicalSize = SDL_GetRenderLogicalSize;
extern fn SDL_GetRenderLogicalSize(
    renderer: ?*SDL_Renderer,
    w: *c_int,
    h: *c_int,
) void;

/// 
/// Set whether to force integer scales for resolution-independent rendering.
/// 
/// This function restricts the logical viewport to integer values - that is,
/// when a resolution is between two multiples of a logical size, the viewport
/// size is rounded down to the lower multiple.
/// 
/// \param renderer the renderer for which integer scaling should be set
/// \param enable enable or disable the integer scaling for rendering
/// \returns 0 on success or a negative error code on failure; call
///          SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_GetRenderIntegerScale
/// \sa SDL_SetRenderLogicalSize
/// 
/// 
pub const SetRenderIntegerScale = SDL_SetRenderIntegerScale;
extern fn SDL_SetRenderIntegerScale(
    renderer: ?*SDL_Renderer,
    enable: bool,
) c_int;

/// 
/// Get whether integer scales are forced for resolution-independent rendering.
/// 
/// \param renderer the renderer from which integer scaling should be queried
/// \returns SDL_TRUE if integer scales are forced or SDL_FALSE if not and on
///          failure; call SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_SetRenderIntegerScale
/// 
/// 
pub const GetRenderIntegerScale = SDL_GetRenderIntegerScale;
extern fn SDL_GetRenderIntegerScale(
    renderer: ?*SDL_Renderer,
) bool;

/// 
/// Set the drawing area for rendering on the current target.
/// 
/// When the window is resized, the viewport is reset to fill the entire new
/// window size.
/// 
/// \param renderer the rendering context
/// \param rect the SDL_Rect structure representing the drawing area, or NULL
///             to set the viewport to the entire target
/// \returns 0 on success or a negative error code on failure; call
///          SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_GetRenderViewport
/// 
/// 
pub const SetRenderViewport = SDL_SetRenderViewport;
extern fn SDL_SetRenderViewport(
    renderer: ?*SDL_Renderer,
    rect: ?*const SDL_Rect,
) c_int;

/// 
/// Get the drawing area for the current target.
/// 
/// \param renderer the rendering context
/// \param rect an SDL_Rect structure filled in with the current drawing area
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_SetRenderViewport
/// 
/// 
pub const GetRenderViewport = SDL_GetRenderViewport;
extern fn SDL_GetRenderViewport(
    renderer: ?*SDL_Renderer,
    rect: ?*SDL_Rect,
) void;

/// 
/// Set the clip rectangle for rendering on the specified target.
/// 
/// \param renderer the rendering context for which clip rectangle should be
///                 set
/// \param rect an SDL_Rect structure representing the clip area, relative to
///             the viewport, or NULL to disable clipping
/// \returns 0 on success or a negative error code on failure; call
///          SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_GetRenderClipRect
/// \sa SDL_RenderClipEnabled
/// 
/// 
pub const SetRenderClipRect = SDL_SetRenderClipRect;
extern fn SDL_SetRenderClipRect(
    renderer: ?*SDL_Renderer,
    rect: ?*const SDL_Rect,
) c_int;

/// 
/// Get the clip rectangle for the current target.
/// 
/// \param renderer the rendering context from which clip rectangle should be
///                 queried
/// \param rect an SDL_Rect structure filled in with the current clipping area
///             or an empty rectangle if clipping is disabled
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_RenderClipEnabled
/// \sa SDL_SetRenderClipRect
/// 
/// 
pub const GetRenderClipRect = SDL_GetRenderClipRect;
extern fn SDL_GetRenderClipRect(
    renderer: ?*SDL_Renderer,
    rect: ?*SDL_Rect,
) void;

/// 
/// Get whether clipping is enabled on the given renderer.
/// 
/// \param renderer the renderer from which clip state should be queried
/// \returns SDL_TRUE if clipping is enabled or SDL_FALSE if not; call
///          SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_GetRenderClipRect
/// \sa SDL_SetRenderClipRect
/// 
/// 
pub const RenderClipEnabled = SDL_RenderClipEnabled;
extern fn SDL_RenderClipEnabled(
    renderer: ?*SDL_Renderer,
) bool;

/// 
/// Set the drawing scale for rendering on the current target.
/// 
/// The drawing coordinates are scaled by the x/y scaling factors before they
/// are used by the renderer. This allows resolution independent drawing with a
/// single coordinate system.
/// 
/// If this results in scaling or subpixel drawing by the rendering backend, it
/// will be handled using the appropriate quality hints. For best results use
/// integer scaling factors.
/// 
/// \param renderer a rendering context
/// \param scaleX the horizontal scaling factor
/// \param scaleY the vertical scaling factor
/// \returns 0 on success or a negative error code on failure; call
///          SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_GetRenderScale
/// \sa SDL_SetRenderLogicalSize
/// 
/// 
pub const SetRenderScale = SDL_SetRenderScale;
extern fn SDL_SetRenderScale(
    renderer: ?*SDL_Renderer,
    scaleX: f32,
    scaleY: f32,
) c_int;

/// 
/// Get the drawing scale for the current target.
/// 
/// \param renderer the renderer from which drawing scale should be queried
/// \param scaleX a pointer filled in with the horizontal scaling factor
/// \param scaleY a pointer filled in with the vertical scaling factor
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_SetRenderScale
/// 
/// 
pub const GetRenderScale = SDL_GetRenderScale;
extern fn SDL_GetRenderScale(
    renderer: ?*SDL_Renderer,
    scaleX: *f32,
    scaleY: *f32,
) void;

/// 
/// Get logical coordinates of point in renderer when given real coordinates of
/// point in window.
/// 
/// Logical coordinates will differ from real coordinates when render is scaled
/// and logical renderer size set
/// 
/// \param renderer the renderer from which the logical coordinates should be
///                 calculated
/// \param windowX the real X coordinate in the window
/// \param windowY the real Y coordinate in the window
/// \param logicalX the pointer filled with the logical x coordinate
/// \param logicalY the pointer filled with the logical y coordinate
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_GetRenderScale
/// \sa SDL_SetRenderScale
/// \sa SDL_GetRenderLogicalSize
/// \sa SDL_SetRenderLogicalSize
/// 
/// 
pub const RenderWindowToLogical = SDL_RenderWindowToLogical;
extern fn SDL_RenderWindowToLogical(
    renderer: ?*SDL_Renderer,
    windowX: f32,
    windowY: f32,
    logicalX: *f32,
    logicalY: *f32,
) void;

/// 
/// Get real coordinates of point in window when given logical coordinates of
/// point in renderer.
/// 
/// Logical coordinates will differ from real coordinates when render is scaled
/// and logical renderer size set
/// 
/// \param renderer the renderer from which the window coordinates should be
///                 calculated
/// \param logicalX the logical x coordinate
/// \param logicalY the logical y coordinate
/// \param windowX the pointer filled with the real X coordinate in the window
/// \param windowY the pointer filled with the real Y coordinate in the window
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_GetRenderScale
/// \sa SDL_SetRenderScale
/// \sa SDL_GetRenderLogicalSize
/// \sa SDL_SetRenderLogicalSize
/// 
/// 
pub const RenderLogicalToWindow = SDL_RenderLogicalToWindow;
extern fn SDL_RenderLogicalToWindow(
    renderer: ?*SDL_Renderer,
    logicalX: f32,
    logicalY: f32,
    windowX: *f32,
    windowY: *f32,
) void;

/// 
/// Set the color used for drawing operations (Rect, Line and Clear).
/// 
/// Set the color for drawing or filling rectangles, lines, and points, and for
/// SDL_RenderClear().
/// 
/// \param renderer the rendering context
/// \param r the red value used to draw on the rendering target
/// \param g the green value used to draw on the rendering target
/// \param b the blue value used to draw on the rendering target
/// \param a the alpha value used to draw on the rendering target; usually
///          `SDL_ALPHA_OPAQUE` (255). Use SDL_SetRenderDrawBlendMode to
///          specify how the alpha channel is used
/// \returns 0 on success or a negative error code on failure; call
///          SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_GetRenderDrawColor
/// \sa SDL_RenderClear
/// \sa SDL_RenderLine
/// \sa SDL_RenderLines
/// \sa SDL_RenderPoint
/// \sa SDL_RenderPoints
/// \sa SDL_RenderRect
/// \sa SDL_RenderRects
/// \sa SDL_RenderFillRect
/// \sa SDL_RenderFillRects
/// 
/// 
pub const SetRenderDrawColor = SDL_SetRenderDrawColor;
extern fn SDL_SetRenderDrawColor(
    renderer: ?*SDL_Renderer,
    r: u8,
    g: u8,
    b: u8,
    a: u8,
) c_int;

/// 
/// Get the color used for drawing operations (Rect, Line and Clear).
/// 
/// \param renderer the rendering context
/// \param r a pointer filled in with the red value used to draw on the
///          rendering target
/// \param g a pointer filled in with the green value used to draw on the
///          rendering target
/// \param b a pointer filled in with the blue value used to draw on the
///          rendering target
/// \param a a pointer filled in with the alpha value used to draw on the
///          rendering target; usually `SDL_ALPHA_OPAQUE` (255)
/// \returns 0 on success or a negative error code on failure; call
///          SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_SetRenderDrawColor
/// 
/// 
pub const GetRenderDrawColor = SDL_GetRenderDrawColor;
extern fn SDL_GetRenderDrawColor(
    renderer: ?*SDL_Renderer,
    r: ?*u8,
    g: ?*u8,
    b: ?*u8,
    a: ?*u8,
) c_int;

/// 
/// Set the blend mode used for drawing operations (Fill and Line).
/// 
/// If the blend mode is not supported, the closest supported mode is chosen.
/// 
/// \param renderer the rendering context
/// \param blendMode the SDL_BlendMode to use for blending
/// \returns 0 on success or a negative error code on failure; call
///          SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_GetRenderDrawBlendMode
/// \sa SDL_RenderLine
/// \sa SDL_RenderLines
/// \sa SDL_RenderPoint
/// \sa SDL_RenderPoints
/// \sa SDL_RenderRect
/// \sa SDL_RenderRects
/// \sa SDL_RenderFillRect
/// \sa SDL_RenderFillRects
/// 
/// 
pub const SetRenderDrawBlendMode = SDL_SetRenderDrawBlendMode;
extern fn SDL_SetRenderDrawBlendMode(
    renderer: ?*SDL_Renderer,
    blendMode: SDL_BlendMode,
) c_int;

/// 
/// Get the blend mode used for drawing operations.
/// 
/// \param renderer the rendering context
/// \param blendMode a pointer filled in with the current SDL_BlendMode
/// \returns 0 on success or a negative error code on failure; call
///          SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_SetRenderDrawBlendMode
/// 
/// 
pub const GetRenderDrawBlendMode = SDL_GetRenderDrawBlendMode;
extern fn SDL_GetRenderDrawBlendMode(
    renderer: ?*SDL_Renderer,
    blendMode: ?*SDL_BlendMode,
) c_int;

/// 
/// Clear the current rendering target with the drawing color.
/// 
/// This function clears the entire rendering target, ignoring the viewport and
/// the clip rectangle.
/// 
/// \param renderer the rendering context
/// \returns 0 on success or a negative error code on failure; call
///          SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_SetRenderDrawColor
/// 
/// 
pub const RenderClear = SDL_RenderClear;
extern fn SDL_RenderClear(
    renderer: ?*SDL_Renderer,
) c_int;

/// 
/// Draw a point on the current rendering target at subpixel precision.
/// 
/// \param renderer The renderer which should draw a point.
/// \param x The x coordinate of the point.
/// \param y The y coordinate of the point.
/// \return 0 on success, or -1 on error
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const RenderPoint = SDL_RenderPoint;
extern fn SDL_RenderPoint(
    renderer: ?*SDL_Renderer,
    x: f32,
    y: f32,
) c_int;

/// 
/// Draw multiple points on the current rendering target at subpixel precision.
/// 
/// \param renderer The renderer which should draw multiple points.
/// \param points The points to draw
/// \param count The number of points to draw
/// \return 0 on success, or -1 on error
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const RenderPoints = SDL_RenderPoints;
extern fn SDL_RenderPoints(
    renderer: ?*SDL_Renderer,
    points: ?*const SDL_FPoint,
    count: c_int,
) c_int;

/// 
/// Draw a line on the current rendering target at subpixel precision.
/// 
/// \param renderer The renderer which should draw a line.
/// \param x1 The x coordinate of the start point.
/// \param y1 The y coordinate of the start point.
/// \param x2 The x coordinate of the end point.
/// \param y2 The y coordinate of the end point.
/// \return 0 on success, or -1 on error
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const RenderLine = SDL_RenderLine;
extern fn SDL_RenderLine(
    renderer: ?*SDL_Renderer,
    x1: f32,
    y1: f32,
    x2: f32,
    y2: f32,
) c_int;

/// 
/// Draw a series of connected lines on the current rendering target at
/// subpixel precision.
/// 
/// \param renderer The renderer which should draw multiple lines.
/// \param points The points along the lines
/// \param count The number of points, drawing count-1 lines
/// \return 0 on success, or -1 on error
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const RenderLines = SDL_RenderLines;
extern fn SDL_RenderLines(
    renderer: ?*SDL_Renderer,
    points: ?*const SDL_FPoint,
    count: c_int,
) c_int;

/// 
/// Draw a rectangle on the current rendering target at subpixel precision.
/// 
/// \param renderer The renderer which should draw a rectangle.
/// \param rect A pointer to the destination rectangle, or NULL to outline the
///             entire rendering target.
/// \return 0 on success, or -1 on error
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const RenderRect = SDL_RenderRect;
extern fn SDL_RenderRect(
    renderer: ?*SDL_Renderer,
    rect: ?*const SDL_FRect,
) c_int;

/// 
/// Draw some number of rectangles on the current rendering target at subpixel
/// precision.
/// 
/// \param renderer The renderer which should draw multiple rectangles.
/// \param rects A pointer to an array of destination rectangles.
/// \param count The number of rectangles.
/// \return 0 on success, or -1 on error
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const RenderRects = SDL_RenderRects;
extern fn SDL_RenderRects(
    renderer: ?*SDL_Renderer,
    rects: ?*const SDL_FRect,
    count: c_int,
) c_int;

/// 
/// Fill a rectangle on the current rendering target with the drawing color at
/// subpixel precision.
/// 
/// \param renderer The renderer which should fill a rectangle.
/// \param rect A pointer to the destination rectangle, or NULL for the entire
///             rendering target.
/// \return 0 on success, or -1 on error
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const RenderFillRect = SDL_RenderFillRect;
extern fn SDL_RenderFillRect(
    renderer: ?*SDL_Renderer,
    rect: ?*const SDL_FRect,
) c_int;

/// 
/// Fill some number of rectangles on the current rendering target with the
/// drawing color at subpixel precision.
/// 
/// \param renderer The renderer which should fill multiple rectangles.
/// \param rects A pointer to an array of destination rectangles.
/// \param count The number of rectangles.
/// \return 0 on success, or -1 on error
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const RenderFillRects = SDL_RenderFillRects;
extern fn SDL_RenderFillRects(
    renderer: ?*SDL_Renderer,
    rects: ?*const SDL_FRect,
    count: c_int,
) c_int;

/// 
/// Copy a portion of the texture to the current rendering target at subpixel
/// precision.
/// 
/// \param renderer The renderer which should copy parts of a texture.
/// \param texture The source texture.
/// \param srcrect A pointer to the source rectangle, or NULL for the entire
///                texture.
/// \param dstrect A pointer to the destination rectangle, or NULL for the
///                entire rendering target.
/// \return 0 on success, or -1 on error
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const RenderTexture = SDL_RenderTexture;
extern fn SDL_RenderTexture(
    renderer: ?*SDL_Renderer,
    texture: ?*SDL_Texture,
    srcrect: ?*const SDL_Rect,
    dstrect: ?*const SDL_FRect,
) c_int;

/// 
/// Copy a portion of the source texture to the current rendering target, with
/// rotation and flipping, at subpixel precision.
/// 
/// \param renderer The renderer which should copy parts of a texture.
/// \param texture The source texture.
/// \param srcrect A pointer to the source rectangle, or NULL for the entire
///                texture.
/// \param dstrect A pointer to the destination rectangle, or NULL for the
///                entire rendering target.
/// \param angle An angle in degrees that indicates the rotation that will be
///              applied to dstrect, rotating it in a clockwise direction
/// \param center A pointer to a point indicating the point around which
///               dstrect will be rotated (if NULL, rotation will be done
///               around dstrect.w/2, dstrect.h/2).
/// \param flip An SDL_RendererFlip value stating which flipping actions should
///             be performed on the texture
/// \return 0 on success, or -1 on error
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const RenderTextureRotated = SDL_RenderTextureRotated;
extern fn SDL_RenderTextureRotated(
    renderer: ?*SDL_Renderer,
    texture: ?*SDL_Texture,
    srcrect: ?*const SDL_Rect,
    dstrect: ?*const SDL_FRect,
    angle: ?*const f64,
    center: ?*const SDL_FPoint,
    flip: ?*const SDL_RendererFlip,
) c_int;

/// 
/// Render a list of triangles, optionally using a texture and indices into the
/// vertex array Color and alpha modulation is done per vertex
/// (SDL_SetTextureColorMod and SDL_SetTextureAlphaMod are ignored).
/// 
/// \param renderer The rendering context.
/// \param texture (optional) The SDL texture to use.
/// \param vertices Vertices.
/// \param num_vertices Number of vertices.
/// \param indices (optional) An array of integer indices into the 'vertices'
///                array, if NULL all vertices will be rendered in sequential
///                order.
/// \param num_indices Number of indices.
/// \return 0 on success, or -1 if the operation is not supported
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_RenderGeometryRaw
/// \sa SDL_Vertex
/// 
/// 
pub const RenderGeometry = SDL_RenderGeometry;
extern fn SDL_RenderGeometry(
    renderer: ?*SDL_Renderer,
    texture: ?*SDL_Texture,
    vertices: ?*const SDL_Vertex,
    num_vertices: c_int,
    indices: ?*const c_int,
    num_indices: c_int,
) c_int;

/// 
/// Render a list of triangles, optionally using a texture and indices into the
/// vertex arrays Color and alpha modulation is done per vertex
/// (SDL_SetTextureColorMod and SDL_SetTextureAlphaMod are ignored).
/// 
/// \param renderer The rendering context.
/// \param texture (optional) The SDL texture to use.
/// \param xy Vertex positions
/// \param xy_stride Byte size to move from one element to the next element
/// \param color Vertex colors (as SDL_Color)
/// \param color_stride Byte size to move from one element to the next element
/// \param uv Vertex normalized texture coordinates
/// \param uv_stride Byte size to move from one element to the next element
/// \param num_vertices Number of vertices.
/// \param indices (optional) An array of indices into the 'vertices' arrays,
///                if NULL all vertices will be rendered in sequential order.
/// \param num_indices Number of indices.
/// \param size_indices Index size: 1 (byte), 2 (short), 4 (int)
/// \return 0 on success, or -1 if the operation is not supported
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_RenderGeometry
/// \sa SDL_Vertex
/// 
/// 
pub const RenderGeometryRaw = SDL_RenderGeometryRaw;
extern fn SDL_RenderGeometryRaw(
    renderer: ?*SDL_Renderer,
    texture: ?*SDL_Texture,
    xy: ?*const f32,
    xy_stride: c_int,
    color: ?*const SDL_Color,
    color_stride: c_int,
    uv: ?*const f32,
    uv_stride: c_int,
    num_vertices: c_int,
    indices: ?*const anyopaque,
    num_indices: c_int,
    size_indices: c_int,
) c_int;

/// 
/// Read pixels from the current rendering target to an array of pixels.
/// 
/// **WARNING**: This is a very slow operation, and should not be used
/// frequently. If you're using this on the main rendering target, it should be
/// called after rendering and before SDL_RenderPresent().
/// 
/// `pitch` specifies the number of bytes between rows in the destination
/// `pixels` data. This allows you to write to a subrectangle or have padded
/// rows in the destination. Generally, `pitch` should equal the number of
/// pixels per row in the `pixels` data times the number of bytes per pixel,
/// but it might contain additional padding (for example, 24bit RGB Windows
/// Bitmap data pads all rows to multiples of 4 bytes).
/// 
/// \param renderer the rendering context
/// \param rect an SDL_Rect structure representing the area to read, or NULL
///             for the entire render target
/// \param format an SDL_PixelFormatEnum value of the desired format of the
///               pixel data, or 0 to use the format of the rendering target
/// \param pixels a pointer to the pixel data to copy into
/// \param pitch the pitch of the `pixels` parameter
/// \returns 0 on success or a negative error code on failure; call
///          SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const RenderReadPixels = SDL_RenderReadPixels;
extern fn SDL_RenderReadPixels(
    renderer: ?*SDL_Renderer,
    rect: ?*const SDL_Rect,
    format: u32,
    pixels: ?*anyopaque,
    pitch: c_int,
) c_int;

/// 
/// Update the screen with any rendering performed since the previous call.
/// 
/// SDL's rendering functions operate on a backbuffer; that is, calling a
/// rendering function such as SDL_RenderLine() does not directly put a
/// line on the screen, but rather updates the backbuffer. As such, you compose
/// your entire scene and *present* the composed backbuffer to the screen as a
/// complete picture.
/// 
/// Therefore, when using SDL's rendering API, one does all drawing intended
/// for the frame, and then calls this function once per frame to present the
/// final drawing to the user.
/// 
/// The backbuffer should be considered invalidated after each present; do not
/// assume that previous contents will exist between frames. You are strongly
/// encouraged to call SDL_RenderClear() to initialize the backbuffer before
/// starting each new frame's drawing, even if you plan to overwrite every
/// pixel.
/// 
/// \param renderer the rendering context
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_RenderClear
/// \sa SDL_RenderLine
/// \sa SDL_RenderLines
/// \sa SDL_RenderPoint
/// \sa SDL_RenderPoints
/// \sa SDL_RenderRect
/// \sa SDL_RenderRects
/// \sa SDL_RenderFillRect
/// \sa SDL_RenderFillRects
/// \sa SDL_SetRenderDrawBlendMode
/// \sa SDL_SetRenderDrawColor
/// 
/// 
pub const RenderPresent = SDL_RenderPresent;
extern fn SDL_RenderPresent(
    renderer: ?*SDL_Renderer,
) void;

/// 
/// Destroy the specified texture.
/// 
/// Passing NULL or an otherwise invalid texture will set the SDL error message
/// to "Invalid texture".
/// 
/// \param texture the texture to destroy
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_CreateTexture
/// \sa SDL_CreateTextureFromSurface
/// 
/// 
pub const DestroyTexture = SDL_DestroyTexture;
extern fn SDL_DestroyTexture(
    texture: ?*SDL_Texture,
) void;

/// 
/// Destroy the rendering context for a window and free associated textures.
/// 
/// If `renderer` is NULL, this function will return immediately after setting
/// the SDL error message to "Invalid renderer". See SDL_GetError().
/// 
/// \param renderer the rendering context
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_CreateRenderer
/// 
/// 
pub const DestroyRenderer = SDL_DestroyRenderer;
extern fn SDL_DestroyRenderer(
    renderer: ?*SDL_Renderer,
) void;

/// 
/// Force the rendering context to flush any pending commands to the underlying
/// rendering API.
/// 
/// You do not need to (and in fact, shouldn't) call this function unless you
/// are planning to call into OpenGL/Direct3D/Metal/whatever directly in
/// addition to using an SDL_Renderer.
/// 
/// This is for a very-specific case: if you are using SDL's render API, you
/// asked for a specific renderer backend (OpenGL, Direct3D, etc), you set
/// SDL_HINT_RENDER_BATCHING to "1", and you plan to make OpenGL/D3D/whatever
/// calls in addition to SDL render API calls. If all of this applies, you
/// should call SDL_RenderFlush() between calls to SDL's render API and the
/// low-level API you're using in cooperation.
/// 
/// In all other cases, you can ignore this function. This is only here to get
/// maximum performance out of a specific situation. In all other cases, SDL
/// will do the right thing, perhaps at a performance loss.
/// 
/// This function is first available in SDL 2.0.10, and is not needed in 2.0.9
/// and earlier, as earlier versions did not queue rendering commands at all,
/// instead flushing them to the OS immediately.
/// 
/// \param renderer the rendering context
/// \returns 0 on success or a negative error code on failure; call
///          SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const RenderFlush = SDL_RenderFlush;
extern fn SDL_RenderFlush(
    renderer: ?*SDL_Renderer,
) c_int;

/// 
/// Bind an OpenGL/ES/ES2 texture to the current context.
/// 
/// This is for use with OpenGL instructions when rendering OpenGL primitives
/// directly.
/// 
/// If not NULL, `texw` and `texh` will be filled with the width and height
/// values suitable for the provided texture. In most cases, both will be 1.0,
/// however, on systems that support the GL_ARB_texture_rectangle extension,
/// these values will actually be the pixel width and height used to create the
/// texture, so this factor needs to be taken into account when providing
/// texture coordinates to OpenGL.
/// 
/// You need a renderer to create an SDL_Texture, therefore you can only use
/// this function with an implicit OpenGL context from SDL_CreateRenderer(),
/// not with your own OpenGL context. If you need control over your OpenGL
/// context, you need to write your own texture-loading methods.
/// 
/// Also note that SDL may upload RGB textures as BGR (or vice-versa), and
/// re-order the color channels in the shaders phase, so the uploaded texture
/// may have swapped color channels.
/// 
/// \param texture the texture to bind to the current OpenGL/ES/ES2 context
/// \param texw a pointer to a float value which will be filled with the
///             texture width or NULL if you don't need that value
/// \param texh a pointer to a float value which will be filled with the
///             texture height or NULL if you don't need that value
/// \returns 0 on success, or -1 if the operation is not supported; call
///          SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_GL_MakeCurrent
/// \sa SDL_GL_UnbindTexture
/// 
/// 
pub const GL_BindTexture = SDL_GL_BindTexture;
extern fn SDL_GL_BindTexture(
    texture: ?*SDL_Texture,
    texw: *f32,
    texh: *f32,
) c_int;

/// 
/// Unbind an OpenGL/ES/ES2 texture from the current context.
/// 
/// See SDL_GL_BindTexture() for examples on how to use these functions
/// 
/// \param texture the texture to unbind from the current OpenGL/ES/ES2 context
/// \returns 0 on success, or -1 if the operation is not supported
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_GL_BindTexture
/// \sa SDL_GL_MakeCurrent
/// 
/// 
pub const GL_UnbindTexture = SDL_GL_UnbindTexture;
extern fn SDL_GL_UnbindTexture(
    texture: ?*SDL_Texture,
) c_int;

/// 
/// Get the CAMetalLayer associated with the given Metal renderer.
/// 
/// This function returns `void *`, so SDL doesn't have to include Metal's
/// headers, but it can be safely cast to a `CAMetalLayer *`.
/// 
/// \param renderer The renderer to query
/// \returns a `CAMetalLayer *` on success, or NULL if the renderer isn't a
///          Metal renderer
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_GetRenderMetalCommandEncoder
/// 
/// 
pub const GetRenderMetalLayer = SDL_GetRenderMetalLayer;
extern fn SDL_GetRenderMetalLayer(
    renderer: ?*SDL_Renderer,
) ?*anyopaque;

/// 
/// Get the Metal command encoder for the current frame
/// 
/// This function returns `void *`, so SDL doesn't have to include Metal's
/// headers, but it can be safely cast to an `id<MTLRenderCommandEncoder>`.
/// 
/// Note that as of SDL 2.0.18, this will return NULL if Metal refuses to give
/// SDL a drawable to render to, which might happen if the window is
/// hidden/minimized/offscreen. This doesn't apply to command encoders for
/// render targets, just the window's backbacker. Check your return values!
/// 
/// \param renderer The renderer to query
/// \returns an `id<MTLRenderCommandEncoder>` on success, or NULL if the
///          renderer isn't a Metal renderer or there was an error.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_GetRenderMetalLayer
/// 
/// 
pub const GetRenderMetalCommandEncoder = SDL_GetRenderMetalCommandEncoder;
extern fn SDL_GetRenderMetalCommandEncoder(
    renderer: ?*SDL_Renderer,
) ?*anyopaque;

/// 
/// Toggle VSync of the given renderer.
/// 
/// \param renderer The renderer to toggle
/// \param vsync 1 for on, 0 for off. All other values are reserved
/// \returns a 0 int on success, or non-zero on failure
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const SetRenderVSync = SDL_SetRenderVSync;
extern fn SDL_SetRenderVSync(
    renderer: ?*SDL_Renderer,
    vsync: c_int,
) c_int;

/// 
/// Get VSync of the given renderer.
/// 
/// \param renderer The renderer to toggle
/// \param vsync an int filled with 1 for on, 0 for off. All other values are reserved
/// \returns a 0 int on success, or non-zero on failure
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const GetRenderVSync = SDL_GetRenderVSync;
extern fn SDL_GetRenderVSync(
    renderer: ?*SDL_Renderer,
    vsync: *c_int,
) c_int;

/// 
/// Get the number of milliseconds since SDL library initialization.
/// 
/// \returns an unsigned 64-bit value representing the number of milliseconds
///          since the SDL library initialized.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const GetTicks = SDL_GetTicks;
extern fn SDL_GetTicks() u64;

/// 
/// Get the number of nanoseconds since SDL library initialization.
/// 
/// \returns an unsigned 64-bit value representing the number of nanoseconds
///          since the SDL library initialized.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const GetTicksNS = SDL_GetTicksNS;
extern fn SDL_GetTicksNS() u64;

/// 
/// Get the current value of the high resolution counter.
/// 
/// This function is typically used for profiling.
/// 
/// The counter values are only meaningful relative to each other. Differences
/// between values can be converted to times by using
/// SDL_GetPerformanceFrequency().
/// 
/// \returns the current counter value.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_GetPerformanceFrequency
/// 
/// 
pub const GetPerformanceCounter = SDL_GetPerformanceCounter;
extern fn SDL_GetPerformanceCounter() u64;

/// 
/// Get the count per second of the high resolution counter.
/// 
/// \returns a platform-specific count per second.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_GetPerformanceCounter
/// 
/// 
pub const GetPerformanceFrequency = SDL_GetPerformanceFrequency;
extern fn SDL_GetPerformanceFrequency() u64;

/// 
/// Wait a specified number of milliseconds before returning.
/// 
/// This function waits a specified number of milliseconds before returning. It
/// waits at least the specified time, but possibly longer due to OS
/// scheduling.
/// 
/// \param ms the number of milliseconds to delay
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const Delay = SDL_Delay;
extern fn SDL_Delay(
    ms: u32,
) void;

/// 
/// Wait a specified number of nanoseconds before returning.
/// 
/// This function waits a specified number of nanoseconds before returning. It
/// waits at least the specified time, but possibly longer due to OS
/// scheduling.
/// 
/// \param ns the number of nanoseconds to delay
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const DelayNS = SDL_DelayNS;
extern fn SDL_DelayNS(
    ns: u64,
) void;

/// 
/// Call a callback function at a future time.
/// 
/// If you use this function, you must pass `SDL_INIT_TIMER` to SDL_Init().
/// 
/// The callback function is passed the current timer interval and the user
/// supplied parameter from the SDL_AddTimer() call and should return the next
/// timer interval. If the value returned from the callback is 0, the timer is
/// canceled.
/// 
/// The callback is run on a separate thread.
/// 
/// Timers take into account the amount of time it took to execute the
/// callback. For example, if the callback took 250 ms to execute and returned
/// 1000 (ms), the timer would only wait another 750 ms before its next
/// iteration.
/// 
/// Timing may be inexact due to OS scheduling. Be sure to note the current
/// time with SDL_GetTicksNS() or SDL_GetPerformanceCounter() in case your
/// callback needs to adjust for variances.
/// 
/// \param interval the timer delay, in milliseconds, passed to `callback`
/// \param callback the SDL_TimerCallback function to call when the specified
///                 `interval` elapses
/// \param param a pointer that is passed to `callback`
/// \returns a timer ID or 0 if an error occurs; call SDL_GetError() for more
///          information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_RemoveTimer
/// 
/// 
pub const AddTimer = SDL_AddTimer;
extern fn SDL_AddTimer(
    interval: u32,
    callback: SDL_TimerCallback,
    param: ?*anyopaque,
) SDL_TimerID;

/// 
/// Remove a timer created with SDL_AddTimer().
/// 
/// \param id the ID of the timer to remove
/// \returns SDL_TRUE if the timer is removed or SDL_FALSE if the timer wasn't
///          found.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_AddTimer
/// 
/// 
pub const RemoveTimer = SDL_RemoveTimer;
extern fn SDL_RemoveTimer(
    id: SDL_TimerID,
) bool;

/// 
///  \file SDL_thread.h
/// 
///  We compile SDL into a DLL. This means, that it's the DLL which
///  creates a new thread for the calling process with the SDL_CreateThread()
///  API. There is a problem with this, that only the RTL of the SDL3.DLL will
///  be initialized for those threads, and not the RTL of the calling
///  application!
/// 
///  To solve this, we make a little hack here.
/// 
///  We'll always use the caller's _beginthread() and _endthread() APIs to
///  start a new thread. This way, if it's the SDL3.DLL which uses this API,
///  then the RTL of SDL3.DLL will be used to create the new thread, and if it's
///  the application, then the RTL of the application will be used.
/// 
///  So, in short:
///  Always use the _beginthread() and _endthread() of the calling runtime
///  library!
/// 
/// 
pub const CreateThread = SDL_CreateThread;
extern fn SDL_CreateThread(
    @"fn": SDL_ThreadFunction,
    name: ?[*:0]const u8,
    data: ?*anyopaque,
    pfnBeginThread: pfnSDL_CurrentBeginThread,
    pfnEndThread: pfnSDL_CurrentEndThread,
) ?*SDL_Thread;

/// 
pub const CreateThreadWithStackSize = SDL_CreateThreadWithStackSize;
extern fn SDL_CreateThreadWithStackSize(
    @"fn": SDL_ThreadFunction,
    name: ?[*:0]const u8,
    stacksize: usize,
    data: ?*anyopaque,
    pfnBeginThread: pfnSDL_CurrentBeginThread,
    pfnEndThread: pfnSDL_CurrentEndThread,
) ?*SDL_Thread;

/// 
/// Create a new thread with a default stack size.
/// 
/// This is equivalent to calling:
/// 
/// ```c
/// SDL_CreateThreadWithStackSize(fn, name, 0, data);
/// ```
/// 
/// \param fn the SDL_ThreadFunction function to call in the new thread
/// \param name the name of the thread
/// \param data a pointer that is passed to `fn`
/// \returns an opaque pointer to the new thread object on success, NULL if the
///          new thread could not be created; call SDL_GetError() for more
///          information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_CreateThreadWithStackSize
/// \sa SDL_WaitThread
/// 
/// 
pub const CreateThread = SDL_CreateThread;
extern fn SDL_CreateThread(
    @"fn": SDL_ThreadFunction,
    name: ?[*:0]const u8,
    data: ?*anyopaque,
) ?*SDL_Thread;

/// 
/// Create a new thread with a specific stack size.
/// 
/// SDL makes an attempt to report `name` to the system, so that debuggers can
/// display it. Not all platforms support this.
/// 
/// Thread naming is a little complicated: Most systems have very small limits
/// for the string length (Haiku has 32 bytes, Linux currently has 16, Visual
/// C++ 6.0 has _nine_!), and possibly other arbitrary rules. You'll have to
/// see what happens with your system's debugger. The name should be UTF-8 (but
/// using the naming limits of C identifiers is a better bet). There are no
/// requirements for thread naming conventions, so long as the string is
/// null-terminated UTF-8, but these guidelines are helpful in choosing a name:
/// 
/// https://stackoverflow.com/questions/149932/naming-conventions-for-threads
/// 
/// If a system imposes requirements, SDL will try to munge the string for it
/// (truncate, etc), but the original string contents will be available from
/// SDL_GetThreadName().
/// 
/// The size (in bytes) of the new stack can be specified. Zero means "use the
/// system default" which might be wildly different between platforms. x86
/// Linux generally defaults to eight megabytes, an embedded device might be a
/// few kilobytes instead. You generally need to specify a stack that is a
/// multiple of the system's page size (in many cases, this is 4 kilobytes, but
/// check your system documentation).
/// 
/// In SDL 2.1, stack size will be folded into the original SDL_CreateThread
/// function, but for backwards compatibility, this is currently a separate
/// function.
/// 
/// \param fn the SDL_ThreadFunction function to call in the new thread
/// \param name the name of the thread
/// \param stacksize the size, in bytes, to allocate for the new thread stack.
/// \param data a pointer that is passed to `fn`
/// \returns an opaque pointer to the new thread object on success, NULL if the
///          new thread could not be created; call SDL_GetError() for more
///          information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_WaitThread
/// 
/// 
pub const CreateThreadWithStackSize = SDL_CreateThreadWithStackSize;
extern fn SDL_CreateThreadWithStackSize(
    @"fn": SDL_ThreadFunction,
    name: ?[*:0]const u8,
    stacksize: usize,
    data: ?*anyopaque,
) ?*SDL_Thread;

/// 
/// Get the thread name as it was specified in SDL_CreateThread().
/// 
/// This is internal memory, not to be freed by the caller, and remains valid
/// until the specified thread is cleaned up by SDL_WaitThread().
/// 
/// \param thread the thread to query
/// \returns a pointer to a UTF-8 string that names the specified thread, or
///          NULL if it doesn't have a name.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_CreateThread
/// 
/// 
pub const GetThreadName = SDL_GetThreadName;
extern fn SDL_GetThreadName(
    thread: ?*SDL_Thread,
) ?[*:0]const u8;

/// 
/// Get the thread identifier for the current thread.
/// 
/// This thread identifier is as reported by the underlying operating system.
/// If SDL is running on a platform that does not support threads the return
/// value will always be zero.
/// 
/// This function also returns a valid thread ID when called from the main
/// thread.
/// 
/// \returns the ID of the current thread.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_GetThreadID
/// 
/// 
pub const ThreadID = SDL_ThreadID;
extern fn SDL_ThreadID() SDL_threadID;

/// 
/// Get the thread identifier for the specified thread.
/// 
/// This thread identifier is as reported by the underlying operating system.
/// If SDL is running on a platform that does not support threads the return
/// value will always be zero.
/// 
/// \param thread the thread to query
/// \returns the ID of the specified thread, or the ID of the current thread if
///          `thread` is NULL.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_ThreadID
/// 
/// 
pub const GetThreadID = SDL_GetThreadID;
extern fn SDL_GetThreadID(
    thread: ?*SDL_Thread,
) SDL_threadID;

/// 
/// Set the priority for the current thread.
/// 
/// Note that some platforms will not let you alter the priority (or at least,
/// promote the thread to a higher priority) at all, and some require you to be
/// an administrator account. Be prepared for this to fail.
/// 
/// \param priority the SDL_ThreadPriority to set
/// \returns 0 on success or a negative error code on failure; call
///          SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const SetThreadPriority = SDL_SetThreadPriority;
extern fn SDL_SetThreadPriority(
    priority: SDL_ThreadPriority,
) c_int;

/// 
/// Wait for a thread to finish.
/// 
/// Threads that haven't been detached will remain (as a "zombie") until this
/// function cleans them up. Not doing so is a resource leak.
/// 
/// Once a thread has been cleaned up through this function, the SDL_Thread
/// that references it becomes invalid and should not be referenced again. As
/// such, only one thread may call SDL_WaitThread() on another.
/// 
/// The return code for the thread function is placed in the area pointed to by
/// `status`, if `status` is not NULL.
/// 
/// You may not wait on a thread that has been used in a call to
/// SDL_DetachThread(). Use either that function or this one, but not both, or
/// behavior is undefined.
/// 
/// It is safe to pass a NULL thread to this function; it is a no-op.
/// 
/// Note that the thread pointer is freed by this function and is not valid
/// afterward.
/// 
/// \param thread the SDL_Thread pointer that was returned from the
///               SDL_CreateThread() call that started this thread
/// \param status pointer to an integer that will receive the value returned
///               from the thread function by its 'return', or NULL to not
///               receive such value back.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_CreateThread
/// \sa SDL_DetachThread
/// 
/// 
pub const WaitThread = SDL_WaitThread;
extern fn SDL_WaitThread(
    thread: ?*SDL_Thread,
    status: *c_int,
) void;

/// 
/// Let a thread clean up on exit without intervention.
/// 
/// A thread may be "detached" to signify that it should not remain until
/// another thread has called SDL_WaitThread() on it. Detaching a thread is
/// useful for long-running threads that nothing needs to synchronize with or
/// further manage. When a detached thread is done, it simply goes away.
/// 
/// There is no way to recover the return code of a detached thread. If you
/// need this, don't detach the thread and instead use SDL_WaitThread().
/// 
/// Once a thread is detached, you should usually assume the SDL_Thread isn't
/// safe to reference again, as it will become invalid immediately upon the
/// detached thread's exit, instead of remaining until someone has called
/// SDL_WaitThread() to finally clean it up. As such, don't detach the same
/// thread more than once.
/// 
/// If a thread has already exited when passed to SDL_DetachThread(), it will
/// stop waiting for a call to SDL_WaitThread() and clean up immediately. It is
/// not safe to detach a thread that might be used with SDL_WaitThread().
/// 
/// You may not call SDL_WaitThread() on a thread that has been detached. Use
/// either that function or this one, but not both, or behavior is undefined.
/// 
/// It is safe to pass NULL to this function; it is a no-op.
/// 
/// \param thread the SDL_Thread pointer that was returned from the
///               SDL_CreateThread() call that started this thread
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_CreateThread
/// \sa SDL_WaitThread
/// 
/// 
pub const DetachThread = SDL_DetachThread;
extern fn SDL_DetachThread(
    thread: ?*SDL_Thread,
) void;

/// 
/// Create a piece of thread-local storage.
/// 
/// This creates an identifier that is globally visible to all threads but
/// refers to data that is thread-specific.
/// 
/// \returns the newly created thread local storage identifier or 0 on error.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_TLSGet
/// \sa SDL_TLSSet
/// 
/// 
pub const TLSCreate = SDL_TLSCreate;
extern fn SDL_TLSCreate() SDL_TLSID;

/// 
/// Get the current thread's value associated with a thread local storage ID.
/// 
/// \param id the thread local storage ID
/// \returns the value associated with the ID for the current thread or NULL if
///          no value has been set; call SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_TLSCreate
/// \sa SDL_TLSSet
/// 
/// 
pub const TLSGet = SDL_TLSGet;
extern fn SDL_TLSGet(
    id: SDL_TLSID,
) ?*anyopaque;

/// 
/// Set the current thread's value associated with a thread local storage ID.
/// 
/// The function prototype for `destructor` is:
/// 
/// ```c
/// void destructor(void *value)
/// ```
/// 
/// where its parameter `value` is what was passed as `value` to SDL_TLSSet().
/// 
/// \param id the thread local storage ID
/// \param value the value to associate with the ID for the current thread
/// \param destructor a function called when the thread exits, to free the
///                   value
/// \returns 0 on success or a negative error code on failure; call
///          SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_TLSCreate
/// \sa SDL_TLSGet
/// 
/// 
pub const TLSSet = SDL_TLSSet;
extern fn SDL_TLSSet(
    id: SDL_TLSID,
    value: ?*const anyopaque,
    destructor: @panic("cannot translate void ( SDLCALL * ) ( void * )"),
) c_int;

/// 
/// Cleanup all TLS data for this thread.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const TLSCleanup = SDL_TLSCleanup;
extern fn SDL_TLSCleanup() void;

/// 
/// Set a callback for every Windows message, run before TranslateMessage().
/// 
/// \param callback The SDL_WindowsMessageHook function to call.
/// \param userdata a pointer to pass to every iteration of `callback`
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const SetWindowsMessageHook = SDL_SetWindowsMessageHook;
extern fn SDL_SetWindowsMessageHook(
    callback: SDL_WindowsMessageHook,
    userdata: ?*anyopaque,
) void;

/// 
/// Get the D3D9 adapter index that matches the specified display index.
/// 
/// The returned adapter index can be passed to `IDirect3D9::CreateDevice` and
/// controls on which monitor a full screen application will appear.
/// 
/// \param displayIndex the display index for which to get the D3D9 adapter
///                     index
/// \returns the D3D9 adapter index on success or a negative error code on
///          failure; call SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const Direct3D9GetAdapterIndex = SDL_Direct3D9GetAdapterIndex;
extern fn SDL_Direct3D9GetAdapterIndex(
    displayIndex: c_int,
) c_int;

/// 
/// Get the D3D9 device associated with a renderer.
/// 
/// Once you are done using the device, you should release it to avoid a
/// resource leak.
/// 
/// \param renderer the renderer from which to get the associated D3D device
/// \returns the D3D9 device associated with given renderer or NULL if it is
///          not a D3D9 renderer; call SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const GetRenderD3D9Device = SDL_GetRenderD3D9Device;
extern fn SDL_GetRenderD3D9Device(
    renderer: ?*SDL_Renderer,
) ?*IDirect3DDevice9;

/// 
/// Get the D3D11 device associated with a renderer.
/// 
/// Once you are done using the device, you should release it to avoid a
/// resource leak.
/// 
/// \param renderer the renderer from which to get the associated D3D11 device
/// \returns the D3D11 device associated with given renderer or NULL if it is
///          not a D3D11 renderer; call SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const GetRenderD3D11Device = SDL_GetRenderD3D11Device;
extern fn SDL_GetRenderD3D11Device(
    renderer: ?*SDL_Renderer,
) ?*ID3D11Device;

/// 
/// Get the D3D12 device associated with a renderer.
/// 
/// Once you are done using the device, you should release it to avoid a
/// resource leak.
/// 
/// \param renderer the renderer from which to get the associated D3D12 device
/// \returns the D3D12 device associated with given renderer or NULL if it is
///          not a D3D12 renderer; call SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const RenderGetD3D12Device = SDL_RenderGetD3D12Device;
extern fn SDL_RenderGetD3D12Device(
    renderer: ?*SDL_Renderer,
) ?*ID3D12Device;

/// 
/// Get the DXGI Adapter and Output indices for the specified display index.
/// 
/// The DXGI Adapter and Output indices can be passed to `EnumAdapters` and
/// `EnumOutputs` respectively to get the objects required to create a DX10 or
/// DX11 device and swap chain.
/// 
/// Before SDL 2.0.4 this function did not return a value. Since SDL 2.0.4 it
/// returns an SDL_bool.
/// 
/// \param displayIndex the display index for which to get both indices
/// \param adapterIndex a pointer to be filled in with the adapter index
/// \param outputIndex a pointer to be filled in with the output index
/// \returns SDL_TRUE on success or SDL_FALSE on failure; call SDL_GetError()
///          for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const DXGIGetOutputInfo = SDL_DXGIGetOutputInfo;
extern fn SDL_DXGIGetOutputInfo(
    displayIndex: c_int,
    adapterIndex: *c_int,
    outputIndex: *c_int,
) bool;

/// 
/// Sets the UNIX nice value for a thread.
/// 
/// This uses setpriority() if possible, and RealtimeKit if available.
/// 
/// \param threadID the Unix thread ID to change priority of.
/// \param priority The new, Unix-specific, priority value.
/// \returns 0 on success, or -1 on error.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const LinuxSetThreadPriority = SDL_LinuxSetThreadPriority;
extern fn SDL_LinuxSetThreadPriority(
    threadID: i64,
    priority: c_int,
) c_int;

/// 
/// Sets the priority (not nice level) and scheduling policy for a thread.
/// 
/// This uses setpriority() if possible, and RealtimeKit if available.
/// 
/// \param threadID The Unix thread ID to change priority of.
/// \param sdlPriority The new SDL_ThreadPriority value.
/// \param schedPolicy The new scheduling policy (SCHED_FIFO, SCHED_RR,
///                    SCHED_OTHER, etc...)
/// \returns 0 on success, or -1 on error.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const LinuxSetThreadPriorityAndPolicy = SDL_LinuxSetThreadPriorityAndPolicy;
extern fn SDL_LinuxSetThreadPriorityAndPolicy(
    threadID: i64,
    sdlPriority: c_int,
    schedPolicy: c_int,
) c_int;

/// 
/// Use this function to set the animation callback on Apple iOS.
/// 
/// The function prototype for `callback` is:
/// 
/// ```c
/// void callback(void* callbackParam);
/// ```
/// 
/// Where its parameter, `callbackParam`, is what was passed as `callbackParam`
/// to SDL_iPhoneSetAnimationCallback().
/// 
/// This function is only available on Apple iOS.
/// 
/// For more information see:
/// https://github.com/libsdl-org/SDL/blob/main/docs/README-ios.md
/// 
/// This functions is also accessible using the macro
/// SDL_iOSSetAnimationCallback() since SDL 2.0.4.
/// 
/// \param window the window for which the animation callback should be set
/// \param interval the number of frames after which **callback** will be
///                 called
/// \param callback the function to call for every frame.
/// \param callbackParam a pointer that is passed to `callback`.
/// \returns 0 on success or a negative error code on failure; call
///          SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_iPhoneSetEventPump
/// 
/// 
pub const iPhoneSetAnimationCallback = SDL_iPhoneSetAnimationCallback;
extern fn SDL_iPhoneSetAnimationCallback(
    window: ?*SDL_Window,
    interval: c_int,
    callback: @panic("cannot translate void ( SDLCALL * ) ( void * )"),
    callbackParam: ?*anyopaque,
) c_int;

/// 
/// Use this function to enable or disable the SDL event pump on Apple iOS.
/// 
/// This function is only available on Apple iOS.
/// 
/// This functions is also accessible using the macro SDL_iOSSetEventPump()
/// since SDL 2.0.4.
/// 
/// \param enabled SDL_TRUE to enable the event pump, SDL_FALSE to disable it
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_iPhoneSetAnimationCallback
/// 
/// 
pub const iPhoneSetEventPump = SDL_iPhoneSetEventPump;
extern fn SDL_iPhoneSetEventPump(
    enabled: bool,
) void;

/// 
/// Get the Android Java Native Interface Environment of the current thread.
/// 
/// This is the JNIEnv one needs to access the Java virtual machine from native
/// code, and is needed for many Android APIs to be usable from C.
/// 
/// The prototype of the function in SDL's code actually declare a void* return
/// type, even if the implementation returns a pointer to a JNIEnv. The
/// rationale being that the SDL headers can avoid including jni.h.
/// 
/// \returns a pointer to Java native interface object (JNIEnv) to which the
///          current thread is attached, or 0 on error.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_AndroidGetActivity
/// 
/// 
pub const AndroidGetJNIEnv = SDL_AndroidGetJNIEnv;
extern fn SDL_AndroidGetJNIEnv() ?*anyopaque;

/// 
/// Retrieve the Java instance of the Android activity class.
/// 
/// The prototype of the function in SDL's code actually declares a void*
/// return type, even if the implementation returns a jobject. The rationale
/// being that the SDL headers can avoid including jni.h.
/// 
/// The jobject returned by the function is a local reference and must be
/// released by the caller. See the PushLocalFrame() and PopLocalFrame() or
/// DeleteLocalRef() functions of the Java native interface:
/// 
/// https://docs.oracle.com/javase/1.5.0/docs/guide/jni/spec/functions.html
/// 
/// \returns the jobject representing the instance of the Activity class of the
///          Android application, or NULL on error.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_AndroidGetJNIEnv
/// 
/// 
pub const AndroidGetActivity = SDL_AndroidGetActivity;
extern fn SDL_AndroidGetActivity() ?*anyopaque;

/// 
/// Query Android API level of the current device.
/// 
/// - API level 31: Android 12
/// - API level 30: Android 11
/// - API level 29: Android 10
/// - API level 28: Android 9
/// - API level 27: Android 8.1
/// - API level 26: Android 8.0
/// - API level 25: Android 7.1
/// - API level 24: Android 7.0
/// - API level 23: Android 6.0
/// - API level 22: Android 5.1
/// - API level 21: Android 5.0
/// - API level 20: Android 4.4W
/// - API level 19: Android 4.4
/// - API level 18: Android 4.3
/// - API level 17: Android 4.2
/// - API level 16: Android 4.1
/// - API level 15: Android 4.0.3
/// - API level 14: Android 4.0
/// - API level 13: Android 3.2
/// - API level 12: Android 3.1
/// - API level 11: Android 3.0
/// - API level 10: Android 2.3.3
/// 
/// \returns the Android API level.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const GetAndroidSDKVersion = SDL_GetAndroidSDKVersion;
extern fn SDL_GetAndroidSDKVersion() c_int;

/// 
/// Query if the application is running on Android TV.
/// 
/// \returns SDL_TRUE if this is Android TV, SDL_FALSE otherwise.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const IsAndroidTV = SDL_IsAndroidTV;
extern fn SDL_IsAndroidTV() bool;

/// 
/// Query if the application is running on a Chromebook.
/// 
/// \returns SDL_TRUE if this is a Chromebook, SDL_FALSE otherwise.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const IsChromebook = SDL_IsChromebook;
extern fn SDL_IsChromebook() bool;

/// 
/// Query if the application is running on a Samsung DeX docking station.
/// 
/// \returns SDL_TRUE if this is a DeX docking station, SDL_FALSE otherwise.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const IsDeXMode = SDL_IsDeXMode;
extern fn SDL_IsDeXMode() bool;

/// 
/// Trigger the Android system back button behavior.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const AndroidBackButton = SDL_AndroidBackButton;
extern fn SDL_AndroidBackButton() void;

/// 
/// Get the path used for internal storage for this application.
/// 
/// This path is unique to your application and cannot be written to by other
/// applications.
/// 
/// Your internal storage path is typically:
/// `/data/data/your.app.package/files`.
/// 
/// \returns the path used for internal storage or NULL on failure; call
///          SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_AndroidGetExternalStorageState
/// 
/// 
pub const AndroidGetInternalStoragePath = SDL_AndroidGetInternalStoragePath;
extern fn SDL_AndroidGetInternalStoragePath() ?[*:0]const u8;

/// 
/// Get the current state of external storage.
/// 
/// The current state of external storage, a bitmask of these values:
/// `SDL_ANDROID_EXTERNAL_STORAGE_READ`, `SDL_ANDROID_EXTERNAL_STORAGE_WRITE`.
/// 
/// If external storage is currently unavailable, this will return 0.
/// 
/// \returns the current state of external storage on success or 0 on failure;
///          call SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_AndroidGetExternalStoragePath
/// 
/// 
pub const AndroidGetExternalStorageState = SDL_AndroidGetExternalStorageState;
extern fn SDL_AndroidGetExternalStorageState() c_int;

/// 
/// Get the path used for external storage for this application.
/// 
/// This path is unique to your application, but is public and can be written
/// to by other applications.
/// 
/// Your external storage path is typically:
/// `/storage/sdcard0/Android/data/your.app.package/files`.
/// 
/// \returns the path used for external storage for this application on success
///          or NULL on failure; call SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_AndroidGetExternalStorageState
/// 
/// 
pub const AndroidGetExternalStoragePath = SDL_AndroidGetExternalStoragePath;
extern fn SDL_AndroidGetExternalStoragePath() ?[*:0]const u8;

/// 
/// Request permissions at runtime.
/// 
/// This blocks the calling thread until the permission is granted or denied.
/// 
/// \param permission The permission to request.
/// \returns SDL_TRUE if the permission was granted, SDL_FALSE otherwise.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const AndroidRequestPermission = SDL_AndroidRequestPermission;
extern fn SDL_AndroidRequestPermission(
    permission: ?[*:0]const u8,
) bool;

/// 
/// Shows an Android toast notification.
/// 
/// Toasts are a sort of lightweight notification that are unique to Android.
/// 
/// https://developer.android.com/guide/topics/ui/notifiers/toasts
/// 
/// Shows toast in UI thread.
/// 
/// For the `gravity` parameter, choose a value from here, or -1 if you don't
/// have a preference:
/// 
/// https://developer.android.com/reference/android/view/Gravity
/// 
/// \param message text message to be shown
/// \param duration 0=short, 1=long
/// \param gravity where the notification should appear on the screen.
/// \param xoffset set this parameter only when gravity >=0
/// \param yoffset set this parameter only when gravity >=0
/// \returns 0 if success, -1 if any error occurs.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const AndroidShowToast = SDL_AndroidShowToast;
extern fn SDL_AndroidShowToast(
    message: ?[*:0]const u8,
    duration: c_int,
    gravity: c_int,
    xoffset: c_int,
    yoffset: c_int,
) c_int;

/// 
/// Send a user command to SDLActivity.
/// 
/// Override "boolean onUnhandledMessage(Message msg)" to handle the message.
/// 
/// \param command user command that must be greater or equal to 0x8000
/// \param param user parameter
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const AndroidSendMessage = SDL_AndroidSendMessage;
extern fn SDL_AndroidSendMessage(
    command: u32,
    param: c_int,
) c_int;

/// 
/// Retrieve a WinRT defined path on the local file system.
/// 
/// Not all paths are available on all versions of Windows. This is especially
/// true on Windows Phone. Check the documentation for the given SDL_WinRT_Path
/// for more information on which path types are supported where.
/// 
/// Documentation on most app-specific path types on WinRT can be found on
/// MSDN, at the URL:
/// 
/// https://msdn.microsoft.com/en-us/library/windows/apps/hh464917.aspx
/// 
/// \param pathType the type of path to retrieve, one of SDL_WinRT_Path
/// \returns a UCS-2 string (16-bit, wide-char) containing the path, or NULL if
///          the path is not available for any reason; call SDL_GetError() for
///          more information.
/// 
/// \since This function is available since SDL 2.0.3.
/// 
/// \sa SDL_WinRTGetFSPathUTF8
/// 
/// 
pub const WinRTGetFSPathUNICODE = SDL_WinRTGetFSPathUNICODE;
extern fn SDL_WinRTGetFSPathUNICODE(
    pathType: SDL_WinRT_Path,
) ?[*:0]const c_wchar;

/// 
/// Retrieve a WinRT defined path on the local file system.
/// 
/// Not all paths are available on all versions of Windows. This is especially
/// true on Windows Phone. Check the documentation for the given SDL_WinRT_Path
/// for more information on which path types are supported where.
/// 
/// Documentation on most app-specific path types on WinRT can be found on
/// MSDN, at the URL:
/// 
/// https://msdn.microsoft.com/en-us/library/windows/apps/hh464917.aspx
/// 
/// \param pathType the type of path to retrieve, one of SDL_WinRT_Path
/// \returns a UTF-8 string (8-bit, multi-byte) containing the path, or NULL if
///          the path is not available for any reason; call SDL_GetError() for
///          more information.
/// 
/// \since This function is available since SDL 2.0.3.
/// 
/// \sa SDL_WinRTGetFSPathUNICODE
/// 
/// 
pub const WinRTGetFSPathUTF8 = SDL_WinRTGetFSPathUTF8;
extern fn SDL_WinRTGetFSPathUTF8(
    pathType: SDL_WinRT_Path,
) ?[*:0]const u8;

/// 
/// Detects the device family of WinRT platform at runtime.
/// 
/// \returns a value from the SDL_WinRT_DeviceFamily enum.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const WinRTGetDeviceFamily = SDL_WinRTGetDeviceFamily;
extern fn SDL_WinRTGetDeviceFamily() SDL_WinRT_DeviceFamily;

/// 
/// Query if the current device is a tablet.
/// 
/// If SDL can't determine this, it will return SDL_FALSE.
/// 
/// \returns SDL_TRUE if the device is a tablet, SDL_FALSE otherwise.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const IsTablet = SDL_IsTablet;
extern fn SDL_IsTablet() bool;

/// 
pub const OnApplicationWillTerminate = SDL_OnApplicationWillTerminate;
extern fn SDL_OnApplicationWillTerminate() void;

/// 
pub const OnApplicationDidReceiveMemoryWarning = SDL_OnApplicationDidReceiveMemoryWarning;
extern fn SDL_OnApplicationDidReceiveMemoryWarning() void;

/// 
pub const OnApplicationWillResignActive = SDL_OnApplicationWillResignActive;
extern fn SDL_OnApplicationWillResignActive() void;

/// 
pub const OnApplicationDidEnterBackground = SDL_OnApplicationDidEnterBackground;
extern fn SDL_OnApplicationDidEnterBackground() void;

/// 
pub const OnApplicationWillEnterForeground = SDL_OnApplicationWillEnterForeground;
extern fn SDL_OnApplicationWillEnterForeground() void;

/// 
pub const OnApplicationDidBecomeActive = SDL_OnApplicationDidBecomeActive;
extern fn SDL_OnApplicationDidBecomeActive() void;

/// 
pub const OnApplicationDidChangeStatusBarOrientation = SDL_OnApplicationDidChangeStatusBarOrientation;
extern fn SDL_OnApplicationDidChangeStatusBarOrientation() void;

/// 
/// Gets a reference to the global async task queue handle for GDK,
/// initializing if needed.
/// 
/// Once you are done with the task queue, you should call
/// XTaskQueueCloseHandle to reduce the reference count to avoid a resource
/// leak.
/// 
/// \param outTaskQueue a pointer to be filled in with task queue handle.
/// \returns 0 if success, -1 if any error occurs.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const GDKGetTaskQueue = SDL_GDKGetTaskQueue;
extern fn SDL_GDKGetTaskQueue(
    outTaskQueue: ?*XTaskQueueHandle,
) c_int;

/// 
/// Compose a custom blend mode for renderers.
/// 
/// The functions SDL_SetRenderDrawBlendMode and SDL_SetTextureBlendMode accept
/// the SDL_BlendMode returned by this function if the renderer supports it.
/// 
/// A blend mode controls how the pixels from a drawing operation (source) get
/// combined with the pixels from the render target (destination). First, the
/// components of the source and destination pixels get multiplied with their
/// blend factors. Then, the blend operation takes the two products and
/// calculates the result that will get stored in the render target.
/// 
/// Expressed in pseudocode, it would look like this:
/// 
/// ```c
/// dstRGB = colorOperation(srcRGB * srcColorFactor, dstRGB * dstColorFactor);
/// dstA = alphaOperation(srcA * srcAlphaFactor, dstA * dstAlphaFactor);
/// ```
/// 
/// Where the functions `colorOperation(src, dst)` and `alphaOperation(src,
/// dst)` can return one of the following:
/// 
/// - `src + dst`
/// - `src - dst`
/// - `dst - src`
/// - `min(src, dst)`
/// - `max(src, dst)`
/// 
/// The red, green, and blue components are always multiplied with the first,
/// second, and third components of the SDL_BlendFactor, respectively. The
/// fourth component is not used.
/// 
/// The alpha component is always multiplied with the fourth component of the
/// SDL_BlendFactor. The other components are not used in the alpha
/// calculation.
/// 
/// Support for these blend modes varies for each renderer. To check if a
/// specific SDL_BlendMode is supported, create a renderer and pass it to
/// either SDL_SetRenderDrawBlendMode or SDL_SetTextureBlendMode. They will
/// return with an error if the blend mode is not supported.
/// 
/// This list describes the support of custom blend modes for each renderer in
/// SDL 2.0.6. All renderers support the four blend modes listed in the
/// SDL_BlendMode enumeration.
/// 
/// - **direct3d**: Supports all operations with all factors. However, some
///   factors produce unexpected results with `SDL_BLENDOPERATION_MINIMUM` and
///   `SDL_BLENDOPERATION_MAXIMUM`.
/// - **direct3d11**: Same as Direct3D 9.
/// - **opengl**: Supports the `SDL_BLENDOPERATION_ADD` operation with all
///   factors. OpenGL versions 1.1, 1.2, and 1.3 do not work correctly with SDL
///   2.0.6.
/// - **opengles**: Supports the `SDL_BLENDOPERATION_ADD` operation with all
///   factors. Color and alpha factors need to be the same. OpenGL ES 1
///   implementation specific: May also support `SDL_BLENDOPERATION_SUBTRACT`
///   and `SDL_BLENDOPERATION_REV_SUBTRACT`. May support color and alpha
///   operations being different from each other. May support color and alpha
///   factors being different from each other.
/// - **opengles2**: Supports the `SDL_BLENDOPERATION_ADD`,
///   `SDL_BLENDOPERATION_SUBTRACT`, `SDL_BLENDOPERATION_REV_SUBTRACT`
///   operations with all factors.
/// - **psp**: No custom blend mode support.
/// - **software**: No custom blend mode support.
/// 
/// Some renderers do not provide an alpha component for the default render
/// target. The `SDL_BLENDFACTOR_DST_ALPHA` and
/// `SDL_BLENDFACTOR_ONE_MINUS_DST_ALPHA` factors do not have an effect in this
/// case.
/// 
/// \param srcColorFactor the SDL_BlendFactor applied to the red, green, and
///                       blue components of the source pixels
/// \param dstColorFactor the SDL_BlendFactor applied to the red, green, and
///                       blue components of the destination pixels
/// \param colorOperation the SDL_BlendOperation used to combine the red,
///                       green, and blue components of the source and
///                       destination pixels
/// \param srcAlphaFactor the SDL_BlendFactor applied to the alpha component of
///                       the source pixels
/// \param dstAlphaFactor the SDL_BlendFactor applied to the alpha component of
///                       the destination pixels
/// \param alphaOperation the SDL_BlendOperation used to combine the alpha
///                       component of the source and destination pixels
/// \returns an SDL_BlendMode that represents the chosen factors and
///          operations.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_SetRenderDrawBlendMode
/// \sa SDL_GetRenderDrawBlendMode
/// \sa SDL_SetTextureBlendMode
/// \sa SDL_GetTextureBlendMode
/// 
/// 
pub const ComposeCustomBlendMode = SDL_ComposeCustomBlendMode;
extern fn SDL_ComposeCustomBlendMode(
    srcColorFactor: SDL_BlendFactor,
    dstColorFactor: SDL_BlendFactor,
    colorOperation: SDL_BlendOperation,
    srcAlphaFactor: SDL_BlendFactor,
    dstAlphaFactor: SDL_BlendFactor,
    alphaOperation: SDL_BlendOperation,
) SDL_BlendMode;

/// 
/// Get the number of video drivers compiled into SDL.
/// 
/// \returns a number >= 1 on success or a negative error code on failure; call
///          SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_GetVideoDriver
/// 
/// 
pub const GetNumVideoDrivers = SDL_GetNumVideoDrivers;
extern fn SDL_GetNumVideoDrivers() c_int;

/// 
/// Get the name of a built in video driver.
/// 
/// The video drivers are presented in the order in which they are normally
/// checked during initialization.
/// 
/// \param index the index of a video driver
/// \returns the name of the video driver with the given **index**.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_GetNumVideoDrivers
/// 
/// 
pub const GetVideoDriver = SDL_GetVideoDriver;
extern fn SDL_GetVideoDriver(
    index: c_int,
) ?[*:0]const u8;

/// 
/// Get the name of the currently initialized video driver.
/// 
/// \returns the name of the current video driver or NULL if no driver has been
///          initialized.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_GetNumVideoDrivers
/// \sa SDL_GetVideoDriver
/// 
/// 
pub const GetCurrentVideoDriver = SDL_GetCurrentVideoDriver;
extern fn SDL_GetCurrentVideoDriver() ?[*:0]const u8;

/// 
/// Get the number of available video displays.
/// 
/// \returns a number >= 1 or a negative error code on failure; call
///          SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_GetDisplayBounds
/// 
/// 
pub const GetNumVideoDisplays = SDL_GetNumVideoDisplays;
extern fn SDL_GetNumVideoDisplays() c_int;

/// 
/// Get the name of a display in UTF-8 encoding.
/// 
/// \param displayIndex the index of display from which the name should be
///                     queried
/// \returns the name of a display or NULL for an invalid display index or
///          failure; call SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_GetNumVideoDisplays
/// 
/// 
pub const GetDisplayName = SDL_GetDisplayName;
extern fn SDL_GetDisplayName(
    displayIndex: c_int,
) ?[*:0]const u8;

/// 
/// Get the desktop area represented by a display.
/// 
/// The primary display (`displayIndex` zero) is always located at 0,0.
/// 
/// \param displayIndex the index of the display to query
/// \param rect the SDL_Rect structure filled in with the display bounds
/// \returns 0 on success or a negative error code on failure; call
///          SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_GetNumVideoDisplays
/// 
/// 
pub const GetDisplayBounds = SDL_GetDisplayBounds;
extern fn SDL_GetDisplayBounds(
    displayIndex: c_int,
    rect: ?*SDL_Rect,
) c_int;

/// 
/// Get the usable desktop area represented by a display.
/// 
/// The primary display (`displayIndex` zero) is always located at 0,0.
/// 
/// This is the same area as SDL_GetDisplayBounds() reports, but with portions
/// reserved by the system removed. For example, on Apple's macOS, this
/// subtracts the area occupied by the menu bar and dock.
/// 
/// Setting a window to be fullscreen generally bypasses these unusable areas,
/// so these are good guidelines for the maximum space available to a
/// non-fullscreen window.
/// 
/// The parameter `rect` is ignored if it is NULL.
/// 
/// This function also returns -1 if the parameter `displayIndex` is out of
/// range.
/// 
/// \param displayIndex the index of the display to query the usable bounds
///                     from
/// \param rect the SDL_Rect structure filled in with the display bounds
/// \returns 0 on success or a negative error code on failure; call
///          SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_GetDisplayBounds
/// \sa SDL_GetNumVideoDisplays
/// 
/// 
pub const GetDisplayUsableBounds = SDL_GetDisplayUsableBounds;
extern fn SDL_GetDisplayUsableBounds(
    displayIndex: c_int,
    rect: ?*SDL_Rect,
) c_int;

/// 
/// Get the dots/pixels-per-inch for a display.
/// 
/// Diagonal, horizontal and vertical DPI can all be optionally returned if the
/// appropriate parameter is non-NULL.
/// 
/// A failure of this function usually means that either no DPI information is
/// available or the `displayIndex` is out of range.
/// 
/// **WARNING**: This reports the DPI that the hardware reports, and it is not
/// always reliable! It is almost always better to use SDL_GetWindowSize() to
/// find the window size, which might be in logical points instead of pixels,
/// and then SDL_GetWindowSizeInPixels(), SDL_GL_GetDrawableSize(),
/// SDL_Vulkan_GetDrawableSize(), SDL_Metal_GetDrawableSize(), or
/// SDL_GetRendererOutputSize(), and compare the two values to get an actual
/// scaling value between the two. We will be rethinking how high-dpi details
/// should be managed in SDL3 to make things more consistent, reliable, and clear.
/// 
/// \param displayIndex the index of the display from which DPI information
///                     should be queried
/// \param ddpi a pointer filled in with the diagonal DPI of the display; may
///             be NULL
/// \param hdpi a pointer filled in with the horizontal DPI of the display; may
///             be NULL
/// \param vdpi a pointer filled in with the vertical DPI of the display; may
///             be NULL
/// \returns 0 on success or a negative error code on failure; call
///          SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_GetNumVideoDisplays
/// 
/// 
pub const GetDisplayDPI = SDL_GetDisplayDPI;
extern fn SDL_GetDisplayDPI(
    displayIndex: c_int,
    ddpi: *f32,
    hdpi: *f32,
    vdpi: *f32,
) c_int;

/// 
/// Get the orientation of a display.
/// 
/// \param displayIndex the index of the display to query
/// \returns The SDL_DisplayOrientation enum value of the display, or
///          `SDL_ORIENTATION_UNKNOWN` if it isn't available.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_GetNumVideoDisplays
/// 
/// 
pub const GetDisplayOrientation = SDL_GetDisplayOrientation;
extern fn SDL_GetDisplayOrientation(
    displayIndex: c_int,
) SDL_DisplayOrientation;

/// 
/// Get the number of available display modes.
/// 
/// The `displayIndex` needs to be in the range from 0 to
/// SDL_GetNumVideoDisplays() - 1.
/// 
/// \param displayIndex the index of the display to query
/// \returns a number >= 1 on success or a negative error code on failure; call
///          SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_GetDisplayMode
/// \sa SDL_GetNumVideoDisplays
/// 
/// 
pub const GetNumDisplayModes = SDL_GetNumDisplayModes;
extern fn SDL_GetNumDisplayModes(
    displayIndex: c_int,
) c_int;

/// 
/// Get information about a specific display mode.
/// 
/// The display modes are sorted in this priority:
/// 
/// - width -> largest to smallest
/// - height -> largest to smallest
/// - bits per pixel -> more colors to fewer colors
/// - packed pixel layout -> largest to smallest
/// - refresh rate -> highest to lowest
/// 
/// \param displayIndex the index of the display to query
/// \param modeIndex the index of the display mode to query
/// \param mode an SDL_DisplayMode structure filled in with the mode at
///             `modeIndex`
/// \returns 0 on success or a negative error code on failure; call
///          SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_GetNumDisplayModes
/// 
/// 
pub const GetDisplayMode = SDL_GetDisplayMode;
extern fn SDL_GetDisplayMode(
    displayIndex: c_int,
    modeIndex: c_int,
    mode: ?*SDL_DisplayMode,
) c_int;

/// 
/// Get information about the desktop's display mode.
/// 
/// There's a difference between this function and SDL_GetCurrentDisplayMode()
/// when SDL runs fullscreen and has changed the resolution. In that case this
/// function will return the previous native display mode, and not the current
/// display mode.
/// 
/// \param displayIndex the index of the display to query
/// \param mode an SDL_DisplayMode structure filled in with the current display
///             mode
/// \returns 0 on success or a negative error code on failure; call
///          SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_GetCurrentDisplayMode
/// \sa SDL_GetDisplayMode
/// \sa SDL_SetWindowDisplayMode
/// 
/// 
pub const GetDesktopDisplayMode = SDL_GetDesktopDisplayMode;
extern fn SDL_GetDesktopDisplayMode(
    displayIndex: c_int,
    mode: ?*SDL_DisplayMode,
) c_int;

/// 
/// Get information about the current display mode.
/// 
/// There's a difference between this function and SDL_GetDesktopDisplayMode()
/// when SDL runs fullscreen and has changed the resolution. In that case this
/// function will return the current display mode, and not the previous native
/// display mode.
/// 
/// \param displayIndex the index of the display to query
/// \param mode an SDL_DisplayMode structure filled in with the current display
///             mode
/// \returns 0 on success or a negative error code on failure; call
///          SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_GetDesktopDisplayMode
/// \sa SDL_GetDisplayMode
/// \sa SDL_GetNumVideoDisplays
/// \sa SDL_SetWindowDisplayMode
/// 
/// 
pub const GetCurrentDisplayMode = SDL_GetCurrentDisplayMode;
extern fn SDL_GetCurrentDisplayMode(
    displayIndex: c_int,
    mode: ?*SDL_DisplayMode,
) c_int;

/// 
/// Get the closest match to the requested display mode.
/// 
/// The available display modes are scanned and `closest` is filled in with the
/// closest mode matching the requested mode and returned. The mode format and
/// refresh rate default to the desktop mode if they are set to 0. The modes
/// are scanned with size being first priority, format being second priority,
/// and finally checking the refresh rate. If all the available modes are too
/// small, then NULL is returned.
/// 
/// \param displayIndex the index of the display to query
/// \param mode an SDL_DisplayMode structure containing the desired display
///             mode
/// \param closest an SDL_DisplayMode structure filled in with the closest
///                match of the available display modes
/// \returns the passed in value `closest` or NULL if no matching video mode
///          was available; call SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_GetDisplayMode
/// \sa SDL_GetNumDisplayModes
/// 
/// 
pub const GetClosestDisplayMode = SDL_GetClosestDisplayMode;
extern fn SDL_GetClosestDisplayMode(
    displayIndex: c_int,
    mode: ?*const SDL_DisplayMode,
    closest: ?*SDL_DisplayMode,
) ?*SDL_DisplayMode;

/// 
/// Get the index of the display containing a point
/// 
/// \param point the point to query
/// \returns the index of the display containing the point or a negative error
///          code on failure; call SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_GetDisplayBounds
/// \sa SDL_GetNumVideoDisplays
/// 
/// 
pub const GetDisplayIndexForPoint = SDL_GetDisplayIndexForPoint;
extern fn SDL_GetDisplayIndexForPoint(
    point: ?*const SDL_Point,
) c_int;

/// 
/// Get the index of the display primarily containing a rect
/// 
/// \param rect the rect to query
/// \returns the index of the display entirely containing the rect or closest
///          to the center of the rect on success or a negative error code on
///          failure; call SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_GetDisplayBounds
/// \sa SDL_GetNumVideoDisplays
/// 
/// 
pub const GetDisplayIndexForRect = SDL_GetDisplayIndexForRect;
extern fn SDL_GetDisplayIndexForRect(
    rect: ?*const SDL_Rect,
) c_int;

/// 
/// Get the index of the display associated with a window.
/// 
/// \param window the window to query
/// \returns the index of the display containing the center of the window on
///          success or a negative error code on failure; call SDL_GetError()
///          for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_GetDisplayBounds
/// \sa SDL_GetNumVideoDisplays
/// 
/// 
pub const GetWindowDisplayIndex = SDL_GetWindowDisplayIndex;
extern fn SDL_GetWindowDisplayIndex(
    window: ?*SDL_Window,
) c_int;

/// 
/// Set the display mode to use when a window is visible at fullscreen.
/// 
/// This only affects the display mode used when the window is fullscreen. To
/// change the window size when the window is not fullscreen, use
/// SDL_SetWindowSize().
/// 
/// \param window the window to affect
/// \param mode the SDL_DisplayMode structure representing the mode to use, or
///             NULL to use the window's dimensions and the desktop's format
///             and refresh rate
/// \returns 0 on success or a negative error code on failure; call
///          SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_GetWindowDisplayMode
/// \sa SDL_SetWindowFullscreen
/// 
/// 
pub const SetWindowDisplayMode = SDL_SetWindowDisplayMode;
extern fn SDL_SetWindowDisplayMode(
    window: ?*SDL_Window,
    mode: ?*const SDL_DisplayMode,
) c_int;

/// 
/// Query the display mode to use when a window is visible at fullscreen.
/// 
/// \param window the window to query
/// \param mode an SDL_DisplayMode structure filled in with the fullscreen
///             display mode
/// \returns 0 on success or a negative error code on failure; call
///          SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_SetWindowDisplayMode
/// \sa SDL_SetWindowFullscreen
/// 
/// 
pub const GetWindowDisplayMode = SDL_GetWindowDisplayMode;
extern fn SDL_GetWindowDisplayMode(
    window: ?*SDL_Window,
    mode: ?*SDL_DisplayMode,
) c_int;

/// 
/// Get the raw ICC profile data for the screen the window is currently on.
/// 
/// Data returned should be freed with SDL_free.
/// 
/// \param window the window to query
/// \param size the size of the ICC profile
/// \returns the raw ICC profile data on success or NULL on failure; call
///          SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const GetWindowICCProfile = SDL_GetWindowICCProfile;
extern fn SDL_GetWindowICCProfile(
    window: ?*SDL_Window,
    size: *usize,
) ?*anyopaque;

/// 
/// Get the pixel format associated with the window.
/// 
/// \param window the window to query
/// \returns the pixel format of the window on success or
///          SDL_PIXELFORMAT_UNKNOWN on failure; call SDL_GetError() for more
///          information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const GetWindowPixelFormat = SDL_GetWindowPixelFormat;
extern fn SDL_GetWindowPixelFormat(
    window: ?*SDL_Window,
) u32;

/// 
/// Create a window with the specified position, dimensions, and flags.
/// 
/// `flags` may be any of the following OR'd together:
/// 
/// - `SDL_WINDOW_FULLSCREEN`: fullscreen window
/// - `SDL_WINDOW_FULLSCREEN_DESKTOP`: fullscreen window at desktop resolution
/// - `SDL_WINDOW_OPENGL`: window usable with an OpenGL context
/// - `SDL_WINDOW_VULKAN`: window usable with a Vulkan instance
/// - `SDL_WINDOW_METAL`: window usable with a Metal instance
/// - `SDL_WINDOW_HIDDEN`: window is not visible
/// - `SDL_WINDOW_BORDERLESS`: no window decoration
/// - `SDL_WINDOW_RESIZABLE`: window can be resized
/// - `SDL_WINDOW_MINIMIZED`: window is minimized
/// - `SDL_WINDOW_MAXIMIZED`: window is maximized
/// - `SDL_WINDOW_INPUT_GRABBED`: window has grabbed input focus
/// - `SDL_WINDOW_ALLOW_HIGHDPI`: window should be created in high-DPI mode if
///   supported (>= SDL 2.0.1)
/// 
/// The SDL_Window is implicitly shown if SDL_WINDOW_HIDDEN is not set.
/// 
/// On Apple's macOS, you **must** set the NSHighResolutionCapable Info.plist
/// property to YES, otherwise you will not receive a High-DPI OpenGL canvas.
/// 
/// If the window is created with the `SDL_WINDOW_ALLOW_HIGHDPI` flag, its size
/// in pixels may differ from its size in screen coordinates on platforms with
/// high-DPI support (e.g. iOS and macOS). Use SDL_GetWindowSize() to query the
/// client area's size in screen coordinates, and SDL_GetWindowSizeInPixels() or
/// SDL_GetRendererOutputSize() to query the drawable size in pixels. Note that
/// when this flag is set, the drawable size can vary after the window is
/// created and should be queried after major window events such as when the
/// window is resized or moved between displays.
/// 
/// If the window is set fullscreen, the width and height parameters `w` and
/// `h` will not be used. However, invalid size parameters (e.g. too large) may
/// still fail. Window size is actually limited to 16384 x 16384 for all
/// platforms at window creation.
/// 
/// If the window is created with any of the SDL_WINDOW_OPENGL or
/// SDL_WINDOW_VULKAN flags, then the corresponding LoadLibrary function
/// (SDL_GL_LoadLibrary or SDL_Vulkan_LoadLibrary) is called and the
/// corresponding UnloadLibrary function is called by SDL_DestroyWindow().
/// 
/// If SDL_WINDOW_VULKAN is specified and there isn't a working Vulkan driver,
/// SDL_CreateWindow() will fail because SDL_Vulkan_LoadLibrary() will fail.
/// 
/// If SDL_WINDOW_METAL is specified on an OS that does not support Metal,
/// SDL_CreateWindow() will fail.
/// 
/// On non-Apple devices, SDL requires you to either not link to the Vulkan
/// loader or link to a dynamic library version. This limitation may be removed
/// in a future version of SDL.
/// 
/// \param title the title of the window, in UTF-8 encoding
/// \param x the x position of the window, `SDL_WINDOWPOS_CENTERED`, or
///          `SDL_WINDOWPOS_UNDEFINED`
/// \param y the y position of the window, `SDL_WINDOWPOS_CENTERED`, or
///          `SDL_WINDOWPOS_UNDEFINED`
/// \param w the width of the window, in screen coordinates
/// \param h the height of the window, in screen coordinates
/// \param flags 0, or one or more SDL_WindowFlags OR'd together
/// \returns the window that was created or NULL on failure; call
///          SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_CreateWindowFrom
/// \sa SDL_DestroyWindow
/// 
/// 
pub const CreateWindow = SDL_CreateWindow;
extern fn SDL_CreateWindow(
    title: ?[*:0]const u8,
    x: c_int,
    y: c_int,
    w: c_int,
    h: c_int,
    flags: u32,
) ?*SDL_Window;

/// 
/// Create an SDL window from an existing native window.
/// 
/// In some cases (e.g. OpenGL) and on some platforms (e.g. Microsoft Windows)
/// the hint `SDL_HINT_VIDEO_WINDOW_SHARE_PIXEL_FORMAT` needs to be configured
/// before using SDL_CreateWindowFrom().
/// 
/// \param data a pointer to driver-dependent window creation data, typically
///             your native window cast to a void*
/// \returns the window that was created or NULL on failure; call
///          SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_CreateWindow
/// \sa SDL_DestroyWindow
/// 
/// 
pub const CreateWindowFrom = SDL_CreateWindowFrom;
extern fn SDL_CreateWindowFrom(
    data: ?*const anyopaque,
) ?*SDL_Window;

/// 
/// Get the numeric ID of a window.
/// 
/// The numeric ID is what SDL_WindowEvent references, and is necessary to map
/// these events to specific SDL_Window objects.
/// 
/// \param window the window to query
/// \returns the ID of the window on success or 0 on failure; call
///          SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_GetWindowFromID
/// 
/// 
pub const GetWindowID = SDL_GetWindowID;
extern fn SDL_GetWindowID(
    window: ?*SDL_Window,
) SDL_WindowID;

/// 
/// Get a window from a stored ID.
/// 
/// The numeric ID is what SDL_WindowEvent references, and is necessary to map
/// these events to specific SDL_Window objects.
/// 
/// \param id the ID of the window
/// \returns the window associated with `id` or NULL if it doesn't exist; call
///          SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_GetWindowID
/// 
/// 
pub const GetWindowFromID = SDL_GetWindowFromID;
extern fn SDL_GetWindowFromID(
    id: SDL_WindowID,
) ?*SDL_Window;

/// 
/// Get the window flags.
/// 
/// \param window the window to query
/// \returns a mask of the SDL_WindowFlags associated with `window`
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_CreateWindow
/// \sa SDL_HideWindow
/// \sa SDL_MaximizeWindow
/// \sa SDL_MinimizeWindow
/// \sa SDL_SetWindowFullscreen
/// \sa SDL_SetWindowGrab
/// \sa SDL_ShowWindow
/// 
/// 
pub const GetWindowFlags = SDL_GetWindowFlags;
extern fn SDL_GetWindowFlags(
    window: ?*SDL_Window,
) u32;

/// 
/// Set the title of a window.
/// 
/// This string is expected to be in UTF-8 encoding.
/// 
/// \param window the window to change
/// \param title the desired window title in UTF-8 format
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_GetWindowTitle
/// 
/// 
pub const SetWindowTitle = SDL_SetWindowTitle;
extern fn SDL_SetWindowTitle(
    window: ?*SDL_Window,
    title: ?[*:0]const u8,
) void;

/// 
/// Get the title of a window.
/// 
/// \param window the window to query
/// \returns the title of the window in UTF-8 format or "" if there is no
///          title.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_SetWindowTitle
/// 
/// 
pub const GetWindowTitle = SDL_GetWindowTitle;
extern fn SDL_GetWindowTitle(
    window: ?*SDL_Window,
) ?[*:0]const u8;

/// 
/// Set the icon for a window.
/// 
/// \param window the window to change
/// \param icon an SDL_Surface structure containing the icon for the window
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const SetWindowIcon = SDL_SetWindowIcon;
extern fn SDL_SetWindowIcon(
    window: ?*SDL_Window,
    icon: ?*SDL_Surface,
) void;

/// 
/// Associate an arbitrary named pointer with a window.
/// 
/// `name` is case-sensitive.
/// 
/// \param window the window to associate with the pointer
/// \param name the name of the pointer
/// \param userdata the associated pointer
/// \returns the previous value associated with `name`.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_GetWindowData
/// 
/// 
pub const SetWindowData = SDL_SetWindowData;
extern fn SDL_SetWindowData(
    window: ?*SDL_Window,
    name: ?[*:0]const u8,
    userdata: ?*anyopaque,
) ?*anyopaque;

/// 
/// Retrieve the data pointer associated with a window.
/// 
/// \param window the window to query
/// \param name the name of the pointer
/// \returns the value associated with `name`.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_SetWindowData
/// 
/// 
pub const GetWindowData = SDL_GetWindowData;
extern fn SDL_GetWindowData(
    window: ?*SDL_Window,
    name: ?[*:0]const u8,
) ?*anyopaque;

/// 
/// Set the position of a window.
/// 
/// The window coordinate origin is the upper left of the display.
/// 
/// \param window the window to reposition
/// \param x the x coordinate of the window in screen coordinates, or
///          `SDL_WINDOWPOS_CENTERED` or `SDL_WINDOWPOS_UNDEFINED`
/// \param y the y coordinate of the window in screen coordinates, or
///          `SDL_WINDOWPOS_CENTERED` or `SDL_WINDOWPOS_UNDEFINED`
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_GetWindowPosition
/// 
/// 
pub const SetWindowPosition = SDL_SetWindowPosition;
extern fn SDL_SetWindowPosition(
    window: ?*SDL_Window,
    x: c_int,
    y: c_int,
) void;

/// 
/// Get the position of a window.
/// 
/// If you do not need the value for one of the positions a NULL may be passed
/// in the `x` or `y` parameter.
/// 
/// \param window the window to query
/// \param x a pointer filled in with the x position of the window, in screen
///          coordinates, may be NULL
/// \param y a pointer filled in with the y position of the window, in screen
///          coordinates, may be NULL
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_SetWindowPosition
/// 
/// 
pub const GetWindowPosition = SDL_GetWindowPosition;
extern fn SDL_GetWindowPosition(
    window: ?*SDL_Window,
    x: *c_int,
    y: *c_int,
) void;

/// 
/// Set the size of a window's client area.
/// 
/// The window size in screen coordinates may differ from the size in pixels,
/// if the window was created with `SDL_WINDOW_ALLOW_HIGHDPI` on a platform
/// with high-dpi support (e.g. iOS or macOS). Use SDL_GL_GetDrawableSize() or
/// SDL_GetRendererOutputSize() to get the real client area size in pixels.
/// 
/// Fullscreen windows automatically match the size of the display mode, and
/// you should use SDL_SetWindowDisplayMode() to change their size.
/// 
/// \param window the window to change
/// \param w the width of the window in pixels, in screen coordinates, must be
///          > 0
/// \param h the height of the window in pixels, in screen coordinates, must be
///          > 0
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_GetWindowSize
/// \sa SDL_SetWindowDisplayMode
/// 
/// 
pub const SetWindowSize = SDL_SetWindowSize;
extern fn SDL_SetWindowSize(
    window: ?*SDL_Window,
    w: c_int,
    h: c_int,
) void;

/// 
/// Get the size of a window's client area.
/// 
/// NULL can safely be passed as the `w` or `h` parameter if the width or
/// height value is not desired.
/// 
/// The window size in screen coordinates may differ from the size in pixels,
/// if the window was created with `SDL_WINDOW_ALLOW_HIGHDPI` on a platform
/// with high-dpi support (e.g. iOS or macOS). Use SDL_GetWindowSizeInPixels(),
/// SDL_GL_GetDrawableSize(), SDL_Vulkan_GetDrawableSize(), or
/// SDL_GetRendererOutputSize() to get the real client area size in pixels.
/// 
/// \param window the window to query the width and height from
/// \param w a pointer filled in with the width of the window, in screen
///          coordinates, may be NULL
/// \param h a pointer filled in with the height of the window, in screen
///          coordinates, may be NULL
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_GL_GetDrawableSize
/// \sa SDL_Vulkan_GetDrawableSize
/// \sa SDL_GetWindowSizeInPixels
/// \sa SDL_SetWindowSize
/// 
/// 
pub const GetWindowSize = SDL_GetWindowSize;
extern fn SDL_GetWindowSize(
    window: ?*SDL_Window,
    w: *c_int,
    h: *c_int,
) void;

/// 
/// Get the size of a window's borders (decorations) around the client area.
/// 
/// Note: If this function fails (returns -1), the size values will be
/// initialized to 0, 0, 0, 0 (if a non-NULL pointer is provided), as if the
/// window in question was borderless.
/// 
/// Note: This function may fail on systems where the window has not yet been
/// decorated by the display server (for example, immediately after calling
/// SDL_CreateWindow). It is recommended that you wait at least until the
/// window has been presented and composited, so that the window system has a
/// chance to decorate the window and provide the border dimensions to SDL.
/// 
/// This function also returns -1 if getting the information is not supported.
/// 
/// \param window the window to query the size values of the border
///               (decorations) from
/// \param top pointer to variable for storing the size of the top border; NULL
///            is permitted
/// \param left pointer to variable for storing the size of the left border;
///             NULL is permitted
/// \param bottom pointer to variable for storing the size of the bottom
///               border; NULL is permitted
/// \param right pointer to variable for storing the size of the right border;
///              NULL is permitted
/// \returns 0 on success or a negative error code on failure; call
///          SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_GetWindowSize
/// 
/// 
pub const GetWindowBordersSize = SDL_GetWindowBordersSize;
extern fn SDL_GetWindowBordersSize(
    window: ?*SDL_Window,
    top: *c_int,
    left: *c_int,
    bottom: *c_int,
    right: *c_int,
) c_int;

/// 
/// Get the size of a window in pixels.
/// 
/// This may differ from SDL_GetWindowSize() if we're rendering to a high-DPI
/// drawable, i.e. the window was created with `SDL_WINDOW_ALLOW_HIGHDPI` on a
/// platform with high-DPI support (Apple calls this "Retina"), and not
/// disabled by the `SDL_HINT_VIDEO_HIGHDPI_DISABLED` hint.
/// 
/// \param window the window from which the drawable size should be queried
/// \param w a pointer to variable for storing the width in pixels, may be NULL
/// \param h a pointer to variable for storing the height in pixels, may be
///          NULL
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_CreateWindow
/// \sa SDL_GetWindowSize
/// 
/// 
pub const GetWindowSizeInPixels = SDL_GetWindowSizeInPixels;
extern fn SDL_GetWindowSizeInPixels(
    window: ?*SDL_Window,
    w: *c_int,
    h: *c_int,
) void;

/// 
/// Set the minimum size of a window's client area.
/// 
/// \param window the window to change
/// \param min_w the minimum width of the window in pixels
/// \param min_h the minimum height of the window in pixels
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_GetWindowMinimumSize
/// \sa SDL_SetWindowMaximumSize
/// 
/// 
pub const SetWindowMinimumSize = SDL_SetWindowMinimumSize;
extern fn SDL_SetWindowMinimumSize(
    window: ?*SDL_Window,
    min_w: c_int,
    min_h: c_int,
) void;

/// 
/// Get the minimum size of a window's client area.
/// 
/// \param window the window to query
/// \param w a pointer filled in with the minimum width of the window, may be
///          NULL
/// \param h a pointer filled in with the minimum height of the window, may be
///          NULL
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_GetWindowMaximumSize
/// \sa SDL_SetWindowMinimumSize
/// 
/// 
pub const GetWindowMinimumSize = SDL_GetWindowMinimumSize;
extern fn SDL_GetWindowMinimumSize(
    window: ?*SDL_Window,
    w: *c_int,
    h: *c_int,
) void;

/// 
/// Set the maximum size of a window's client area.
/// 
/// \param window the window to change
/// \param max_w the maximum width of the window in pixels
/// \param max_h the maximum height of the window in pixels
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_GetWindowMaximumSize
/// \sa SDL_SetWindowMinimumSize
/// 
/// 
pub const SetWindowMaximumSize = SDL_SetWindowMaximumSize;
extern fn SDL_SetWindowMaximumSize(
    window: ?*SDL_Window,
    max_w: c_int,
    max_h: c_int,
) void;

/// 
/// Get the maximum size of a window's client area.
/// 
/// \param window the window to query
/// \param w a pointer filled in with the maximum width of the window, may be
///          NULL
/// \param h a pointer filled in with the maximum height of the window, may be
///          NULL
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_GetWindowMinimumSize
/// \sa SDL_SetWindowMaximumSize
/// 
/// 
pub const GetWindowMaximumSize = SDL_GetWindowMaximumSize;
extern fn SDL_GetWindowMaximumSize(
    window: ?*SDL_Window,
    w: *c_int,
    h: *c_int,
) void;

/// 
/// Set the border state of a window.
/// 
/// This will add or remove the window's `SDL_WINDOW_BORDERLESS` flag and add
/// or remove the border from the actual window. This is a no-op if the
/// window's border already matches the requested state.
/// 
/// You can't change the border state of a fullscreen window.
/// 
/// \param window the window of which to change the border state
/// \param bordered SDL_FALSE to remove border, SDL_TRUE to add border
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_GetWindowFlags
/// 
/// 
pub const SetWindowBordered = SDL_SetWindowBordered;
extern fn SDL_SetWindowBordered(
    window: ?*SDL_Window,
    bordered: bool,
) void;

/// 
/// Set the user-resizable state of a window.
/// 
/// This will add or remove the window's `SDL_WINDOW_RESIZABLE` flag and
/// allow/disallow user resizing of the window. This is a no-op if the window's
/// resizable state already matches the requested state.
/// 
/// You can't change the resizable state of a fullscreen window.
/// 
/// \param window the window of which to change the resizable state
/// \param resizable SDL_TRUE to allow resizing, SDL_FALSE to disallow
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_GetWindowFlags
/// 
/// 
pub const SetWindowResizable = SDL_SetWindowResizable;
extern fn SDL_SetWindowResizable(
    window: ?*SDL_Window,
    resizable: bool,
) void;

/// 
/// Set the window to always be above the others.
/// 
/// This will add or remove the window's `SDL_WINDOW_ALWAYS_ON_TOP` flag. This
/// will bring the window to the front and keep the window above the rest.
/// 
/// \param window The window of which to change the always on top state
/// \param on_top SDL_TRUE to set the window always on top, SDL_FALSE to
///               disable
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_GetWindowFlags
/// 
/// 
pub const SetWindowAlwaysOnTop = SDL_SetWindowAlwaysOnTop;
extern fn SDL_SetWindowAlwaysOnTop(
    window: ?*SDL_Window,
    on_top: bool,
) void;

/// 
/// Show a window.
/// 
/// \param window the window to show
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_HideWindow
/// \sa SDL_RaiseWindow
/// 
/// 
pub const ShowWindow = SDL_ShowWindow;
extern fn SDL_ShowWindow(
    window: ?*SDL_Window,
) void;

/// 
/// Hide a window.
/// 
/// \param window the window to hide
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_ShowWindow
/// 
/// 
pub const HideWindow = SDL_HideWindow;
extern fn SDL_HideWindow(
    window: ?*SDL_Window,
) void;

/// 
/// Raise a window above other windows and set the input focus.
/// 
/// \param window the window to raise
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const RaiseWindow = SDL_RaiseWindow;
extern fn SDL_RaiseWindow(
    window: ?*SDL_Window,
) void;

/// 
/// Make a window as large as possible.
/// 
/// \param window the window to maximize
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_MinimizeWindow
/// \sa SDL_RestoreWindow
/// 
/// 
pub const MaximizeWindow = SDL_MaximizeWindow;
extern fn SDL_MaximizeWindow(
    window: ?*SDL_Window,
) void;

/// 
/// Minimize a window to an iconic representation.
/// 
/// \param window the window to minimize
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_MaximizeWindow
/// \sa SDL_RestoreWindow
/// 
/// 
pub const MinimizeWindow = SDL_MinimizeWindow;
extern fn SDL_MinimizeWindow(
    window: ?*SDL_Window,
) void;

/// 
/// Restore the size and position of a minimized or maximized window.
/// 
/// \param window the window to restore
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_MaximizeWindow
/// \sa SDL_MinimizeWindow
/// 
/// 
pub const RestoreWindow = SDL_RestoreWindow;
extern fn SDL_RestoreWindow(
    window: ?*SDL_Window,
) void;

/// 
/// Set a window's fullscreen state.
/// 
/// `flags` may be `SDL_WINDOW_FULLSCREEN`, for "real" fullscreen with a
/// videomode change; `SDL_WINDOW_FULLSCREEN_DESKTOP` for "fake" fullscreen
/// that takes the size of the desktop; and 0 for windowed mode.
/// 
/// \param window the window to change
/// \param flags `SDL_WINDOW_FULLSCREEN`, `SDL_WINDOW_FULLSCREEN_DESKTOP` or 0
/// \returns 0 on success or a negative error code on failure; call
///          SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_GetWindowDisplayMode
/// \sa SDL_SetWindowDisplayMode
/// 
/// 
pub const SetWindowFullscreen = SDL_SetWindowFullscreen;
extern fn SDL_SetWindowFullscreen(
    window: ?*SDL_Window,
    flags: u32,
) c_int;

/// 
/// Get the SDL surface associated with the window.
/// 
/// A new surface will be created with the optimal format for the window, if
/// necessary. This surface will be freed when the window is destroyed. Do not
/// free this surface.
/// 
/// This surface will be invalidated if the window is resized. After resizing a
/// window this function must be called again to return a valid surface.
/// 
/// You may not combine this with 3D or the rendering API on this window.
/// 
/// This function is affected by `SDL_HINT_FRAMEBUFFER_ACCELERATION`.
/// 
/// \param window the window to query
/// \returns the surface associated with the window, or NULL on failure; call
///          SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_UpdateWindowSurface
/// \sa SDL_UpdateWindowSurfaceRects
/// 
/// 
pub const GetWindowSurface = SDL_GetWindowSurface;
extern fn SDL_GetWindowSurface(
    window: ?*SDL_Window,
) ?*SDL_Surface;

/// 
/// Copy the window surface to the screen.
/// 
/// This is the function you use to reflect any changes to the surface on the
/// screen.
/// 
/// This function is equivalent to the SDL 1.2 API SDL_Flip().
/// 
/// \param window the window to update
/// \returns 0 on success or a negative error code on failure; call
///          SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_GetWindowSurface
/// \sa SDL_UpdateWindowSurfaceRects
/// 
/// 
pub const UpdateWindowSurface = SDL_UpdateWindowSurface;
extern fn SDL_UpdateWindowSurface(
    window: ?*SDL_Window,
) c_int;

/// 
/// Copy areas of the window surface to the screen.
/// 
/// This is the function you use to reflect changes to portions of the surface
/// on the screen.
/// 
/// This function is equivalent to the SDL 1.2 API SDL_UpdateRects().
/// 
/// \param window the window to update
/// \param rects an array of SDL_Rect structures representing areas of the
///              surface to copy
/// \param numrects the number of rectangles
/// \returns 0 on success or a negative error code on failure; call
///          SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_GetWindowSurface
/// \sa SDL_UpdateWindowSurface
/// 
/// 
pub const UpdateWindowSurfaceRects = SDL_UpdateWindowSurfaceRects;
extern fn SDL_UpdateWindowSurfaceRects(
    window: ?*SDL_Window,
    rects: ?*const SDL_Rect,
    numrects: c_int,
) c_int;

/// 
/// Set a window's input grab mode.
/// 
/// When input is grabbed, the mouse is confined to the window. This function
/// will also grab the keyboard if `SDL_HINT_GRAB_KEYBOARD` is set. To grab the
/// keyboard without also grabbing the mouse, use SDL_SetWindowKeyboardGrab().
/// 
/// If the caller enables a grab while another window is currently grabbed, the
/// other window loses its grab in favor of the caller's window.
/// 
/// \param window the window for which the input grab mode should be set
/// \param grabbed SDL_TRUE to grab input or SDL_FALSE to release input
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_GetGrabbedWindow
/// \sa SDL_GetWindowGrab
/// 
/// 
pub const SetWindowGrab = SDL_SetWindowGrab;
extern fn SDL_SetWindowGrab(
    window: ?*SDL_Window,
    grabbed: bool,
) void;

/// 
/// Set a window's keyboard grab mode.
/// 
/// Keyboard grab enables capture of system keyboard shortcuts like Alt+Tab or
/// the Meta/Super key. Note that not all system keyboard shortcuts can be
/// captured by applications (one example is Ctrl+Alt+Del on Windows).
/// 
/// This is primarily intended for specialized applications such as VNC clients
/// or VM frontends. Normal games should not use keyboard grab.
/// 
/// When keyboard grab is enabled, SDL will continue to handle Alt+Tab when the
/// window is full-screen to ensure the user is not trapped in your
/// application. If you have a custom keyboard shortcut to exit fullscreen
/// mode, you may suppress this behavior with
/// `SDL_HINT_ALLOW_ALT_TAB_WHILE_GRABBED`.
/// 
/// If the caller enables a grab while another window is currently grabbed, the
/// other window loses its grab in favor of the caller's window.
/// 
/// \param window The window for which the keyboard grab mode should be set.
/// \param grabbed This is SDL_TRUE to grab keyboard, and SDL_FALSE to release.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_GetWindowKeyboardGrab
/// \sa SDL_SetWindowMouseGrab
/// \sa SDL_SetWindowGrab
/// 
/// 
pub const SetWindowKeyboardGrab = SDL_SetWindowKeyboardGrab;
extern fn SDL_SetWindowKeyboardGrab(
    window: ?*SDL_Window,
    grabbed: bool,
) void;

/// 
/// Set a window's mouse grab mode.
/// 
/// Mouse grab confines the mouse cursor to the window.
/// 
/// \param window The window for which the mouse grab mode should be set.
/// \param grabbed This is SDL_TRUE to grab mouse, and SDL_FALSE to release.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_GetWindowMouseGrab
/// \sa SDL_SetWindowKeyboardGrab
/// \sa SDL_SetWindowGrab
/// 
/// 
pub const SetWindowMouseGrab = SDL_SetWindowMouseGrab;
extern fn SDL_SetWindowMouseGrab(
    window: ?*SDL_Window,
    grabbed: bool,
) void;

/// 
/// Get a window's input grab mode.
/// 
/// \param window the window to query
/// \returns SDL_TRUE if input is grabbed, SDL_FALSE otherwise.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_SetWindowGrab
/// 
/// 
pub const GetWindowGrab = SDL_GetWindowGrab;
extern fn SDL_GetWindowGrab(
    window: ?*SDL_Window,
) bool;

/// 
/// Get a window's keyboard grab mode.
/// 
/// \param window the window to query
/// \returns SDL_TRUE if keyboard is grabbed, and SDL_FALSE otherwise.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_SetWindowKeyboardGrab
/// \sa SDL_GetWindowGrab
/// 
/// 
pub const GetWindowKeyboardGrab = SDL_GetWindowKeyboardGrab;
extern fn SDL_GetWindowKeyboardGrab(
    window: ?*SDL_Window,
) bool;

/// 
/// Get a window's mouse grab mode.
/// 
/// \param window the window to query
/// \returns SDL_TRUE if mouse is grabbed, and SDL_FALSE otherwise.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_SetWindowKeyboardGrab
/// \sa SDL_GetWindowGrab
/// 
/// 
pub const GetWindowMouseGrab = SDL_GetWindowMouseGrab;
extern fn SDL_GetWindowMouseGrab(
    window: ?*SDL_Window,
) bool;

/// 
/// Get the window that currently has an input grab enabled.
/// 
/// \returns the window if input is grabbed or NULL otherwise.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_GetWindowGrab
/// \sa SDL_SetWindowGrab
/// 
/// 
pub const GetGrabbedWindow = SDL_GetGrabbedWindow;
extern fn SDL_GetGrabbedWindow() ?*SDL_Window;

/// 
/// Confines the cursor to the specified area of a window.
/// 
/// Note that this does NOT grab the cursor, it only defines the area a cursor
/// is restricted to when the window has mouse focus.
/// 
/// \param window The window that will be associated with the barrier.
/// \param rect A rectangle area in window-relative coordinates. If NULL the
///             barrier for the specified window will be destroyed.
/// \returns 0 on success or a negative error code on failure; call
///          SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_GetWindowMouseRect
/// \sa SDL_SetWindowMouseGrab
/// 
/// 
pub const SetWindowMouseRect = SDL_SetWindowMouseRect;
extern fn SDL_SetWindowMouseRect(
    window: ?*SDL_Window,
    rect: ?*const SDL_Rect,
) c_int;

/// 
/// Get the mouse confinement rectangle of a window.
/// 
/// \param window The window to query
/// \returns A pointer to the mouse confinement rectangle of a window, or NULL
///          if there isn't one.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_SetWindowMouseRect
/// 
/// 
pub const GetWindowMouseRect = SDL_GetWindowMouseRect;
extern fn SDL_GetWindowMouseRect(
    window: ?*SDL_Window,
) ?*const SDL_Rect;

/// 
/// Set the opacity for a window.
/// 
/// The parameter `opacity` will be clamped internally between 0.0f
/// (transparent) and 1.0f (opaque).
/// 
/// This function also returns -1 if setting the opacity isn't supported.
/// 
/// \param window the window which will be made transparent or opaque
/// \param opacity the opacity value (0.0f - transparent, 1.0f - opaque)
/// \returns 0 on success or a negative error code on failure; call
///          SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_GetWindowOpacity
/// 
/// 
pub const SetWindowOpacity = SDL_SetWindowOpacity;
extern fn SDL_SetWindowOpacity(
    window: ?*SDL_Window,
    opacity: f32,
) c_int;

/// 
/// Get the opacity of a window.
/// 
/// If transparency isn't supported on this platform, opacity will be reported
/// as 1.0f without error.
/// 
/// The parameter `opacity` is ignored if it is NULL.
/// 
/// This function also returns -1 if an invalid window was provided.
/// 
/// \param window the window to get the current opacity value from
/// \param out_opacity the float filled in (0.0f - transparent, 1.0f - opaque)
/// \returns 0 on success or a negative error code on failure; call
///          SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_SetWindowOpacity
/// 
/// 
pub const GetWindowOpacity = SDL_GetWindowOpacity;
extern fn SDL_GetWindowOpacity(
    window: ?*SDL_Window,
    out_opacity: *f32,
) c_int;

/// 
/// Set the window as a modal for another window.
/// 
/// \param modal_window the window that should be set modal
/// \param parent_window the parent window for the modal window
/// \returns 0 on success or a negative error code on failure; call
///          SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const SetWindowModalFor = SDL_SetWindowModalFor;
extern fn SDL_SetWindowModalFor(
    modal_window: ?*SDL_Window,
    parent_window: ?*SDL_Window,
) c_int;

/// 
/// Explicitly set input focus to the window.
/// 
/// You almost certainly want SDL_RaiseWindow() instead of this function. Use
/// this with caution, as you might give focus to a window that is completely
/// obscured by other windows.
/// 
/// \param window the window that should get the input focus
/// \returns 0 on success or a negative error code on failure; call
///          SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_RaiseWindow
/// 
/// 
pub const SetWindowInputFocus = SDL_SetWindowInputFocus;
extern fn SDL_SetWindowInputFocus(
    window: ?*SDL_Window,
) c_int;

/// 
/// Provide a callback that decides if a window region has special properties.
/// 
/// Normally windows are dragged and resized by decorations provided by the
/// system window manager (a title bar, borders, etc), but for some apps, it
/// makes sense to drag them from somewhere else inside the window itself; for
/// example, one might have a borderless window that wants to be draggable from
/// any part, or simulate its own title bar, etc.
/// 
/// This function lets the app provide a callback that designates pieces of a
/// given window as special. This callback is run during event processing if we
/// need to tell the OS to treat a region of the window specially; the use of
/// this callback is known as "hit testing."
/// 
/// Mouse input may not be delivered to your application if it is within a
/// special area; the OS will often apply that input to moving the window or
/// resizing the window and not deliver it to the application.
/// 
/// Specifying NULL for a callback disables hit-testing. Hit-testing is
/// disabled by default.
/// 
/// Platforms that don't support this functionality will return -1
/// unconditionally, even if you're attempting to disable hit-testing.
/// 
/// Your callback may fire at any time, and its firing does not indicate any
/// specific behavior (for example, on Windows, this certainly might fire when
/// the OS is deciding whether to drag your window, but it fires for lots of
/// other reasons, too, some unrelated to anything you probably care about _and
/// when the mouse isn't actually at the location it is testing_). Since this
/// can fire at any time, you should try to keep your callback efficient,
/// devoid of allocations, etc.
/// 
/// \param window the window to set hit-testing on
/// \param callback the function to call when doing a hit-test
/// \param callback_data an app-defined void pointer passed to **callback**
/// \returns 0 on success or -1 on error (including unsupported); call
///          SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const SetWindowHitTest = SDL_SetWindowHitTest;
extern fn SDL_SetWindowHitTest(
    window: ?*SDL_Window,
    callback: SDL_HitTest,
    callback_data: ?*anyopaque,
) c_int;

/// 
/// Request a window to demand attention from the user.
/// 
/// \param window the window to be flashed
/// \param operation the flash operation
/// \returns 0 on success or a negative error code on failure; call
///          SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const FlashWindow = SDL_FlashWindow;
extern fn SDL_FlashWindow(
    window: ?*SDL_Window,
    operation: SDL_FlashOperation,
) c_int;

/// 
/// Destroy a window.
/// 
/// If `window` is NULL, this function will return immediately after setting
/// the SDL error message to "Invalid window". See SDL_GetError().
/// 
/// \param window the window to destroy
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_CreateWindow
/// \sa SDL_CreateWindowFrom
/// 
/// 
pub const DestroyWindow = SDL_DestroyWindow;
extern fn SDL_DestroyWindow(
    window: ?*SDL_Window,
) void;

/// 
/// Check whether the screensaver is currently enabled.
/// 
/// The screensaver is disabled by default since SDL 2.0.2. Before SDL 2.0.2
/// the screensaver was enabled by default.
/// 
/// The default can also be changed using `SDL_HINT_VIDEO_ALLOW_SCREENSAVER`.
/// 
/// \returns SDL_TRUE if the screensaver is enabled, SDL_FALSE if it is
///          disabled.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_DisableScreenSaver
/// \sa SDL_EnableScreenSaver
/// 
/// 
pub const ScreenSaverEnabled = SDL_ScreenSaverEnabled;
extern fn SDL_ScreenSaverEnabled() bool;

/// 
/// Allow the screen to be blanked by a screen saver.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_DisableScreenSaver
/// \sa SDL_ScreenSaverEnabled
/// 
/// 
pub const EnableScreenSaver = SDL_EnableScreenSaver;
extern fn SDL_EnableScreenSaver() void;

/// 
/// Prevent the screen from being blanked by a screen saver.
/// 
/// If you disable the screensaver, it is automatically re-enabled when SDL
/// quits.
/// 
/// The screensaver is disabled by default since SDL 2.0.2. Before SDL 2.0.2
/// the screensaver was enabled by default.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_EnableScreenSaver
/// \sa SDL_ScreenSaverEnabled
/// 
/// 
pub const DisableScreenSaver = SDL_DisableScreenSaver;
extern fn SDL_DisableScreenSaver() void;

/// 
/// Dynamically load an OpenGL library.
/// 
/// This should be done after initializing the video driver, but before
/// creating any OpenGL windows. If no OpenGL library is loaded, the default
/// library will be loaded upon creation of the first OpenGL window.
/// 
/// If you do this, you need to retrieve all of the GL functions used in your
/// program from the dynamic library using SDL_GL_GetProcAddress().
/// 
/// \param path the platform dependent OpenGL library name, or NULL to open the
///             default OpenGL library
/// \returns 0 on success or a negative error code on failure; call
///          SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_GL_GetProcAddress
/// \sa SDL_GL_UnloadLibrary
/// 
/// 
pub const GL_LoadLibrary = SDL_GL_LoadLibrary;
extern fn SDL_GL_LoadLibrary(
    path: ?[*:0]const u8,
) c_int;

/// 
/// Get an OpenGL function by name.
/// 
/// If the GL library is loaded at runtime with SDL_GL_LoadLibrary(), then all
/// GL functions must be retrieved this way. Usually this is used to retrieve
/// function pointers to OpenGL extensions.
/// 
/// There are some quirks to looking up OpenGL functions that require some
/// extra care from the application. If you code carefully, you can handle
/// these quirks without any platform-specific code, though:
/// 
/// - On Windows, function pointers are specific to the current GL context;
///   this means you need to have created a GL context and made it current
///   before calling SDL_GL_GetProcAddress(). If you recreate your context or
///   create a second context, you should assume that any existing function
///   pointers aren't valid to use with it. This is (currently) a
///   Windows-specific limitation, and in practice lots of drivers don't suffer
///   this limitation, but it is still the way the wgl API is documented to
///   work and you should expect crashes if you don't respect it. Store a copy
///   of the function pointers that comes and goes with context lifespan.
/// - On X11, function pointers returned by this function are valid for any
///   context, and can even be looked up before a context is created at all.
///   This means that, for at least some common OpenGL implementations, if you
///   look up a function that doesn't exist, you'll get a non-NULL result that
///   is _NOT_ safe to call. You must always make sure the function is actually
///   available for a given GL context before calling it, by checking for the
///   existence of the appropriate extension with SDL_GL_ExtensionSupported(),
///   or verifying that the version of OpenGL you're using offers the function
///   as core functionality.
/// - Some OpenGL drivers, on all platforms, *will* return NULL if a function
///   isn't supported, but you can't count on this behavior. Check for
///   extensions you use, and if you get a NULL anyway, act as if that
///   extension wasn't available. This is probably a bug in the driver, but you
///   can code defensively for this scenario anyhow.
/// - Just because you're on Linux/Unix, don't assume you'll be using X11.
///   Next-gen display servers are waiting to replace it, and may or may not
///   make the same promises about function pointers.
/// - OpenGL function pointers must be declared `APIENTRY` as in the example
///   code. This will ensure the proper calling convention is followed on
///   platforms where this matters (Win32) thereby avoiding stack corruption.
/// 
/// \param proc the name of an OpenGL function
/// \returns a pointer to the named OpenGL function. The returned pointer
///          should be cast to the appropriate function signature.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_GL_ExtensionSupported
/// \sa SDL_GL_LoadLibrary
/// \sa SDL_GL_UnloadLibrary
/// 
/// 
pub const GL_GetProcAddress = SDL_GL_GetProcAddress;
extern fn SDL_GL_GetProcAddress(
    proc: ?[*:0]const u8,
) SDL_FunctionPointer;

/// 
/// Get an EGL library function by name.
/// 
/// If an EGL library is loaded, this function allows applications to get entry
/// points for EGL functions. This is useful to provide to an EGL API and
/// extension loader.
/// 
/// \param proc the name of an EGL function
/// \returns a pointer to the named EGL function. The returned pointer should
///          be cast to the appropriate function signature.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_GL_GetCurrentEGLDisplay
/// 
/// 
pub const EGL_GetProcAddress = SDL_EGL_GetProcAddress;
extern fn SDL_EGL_GetProcAddress(
    proc: ?[*:0]const u8,
) SDL_FunctionPointer;

/// 
/// Unload the OpenGL library previously loaded by SDL_GL_LoadLibrary().
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_GL_LoadLibrary
/// 
/// 
pub const GL_UnloadLibrary = SDL_GL_UnloadLibrary;
extern fn SDL_GL_UnloadLibrary() void;

/// 
/// Check if an OpenGL extension is supported for the current context.
/// 
/// This function operates on the current GL context; you must have created a
/// context and it must be current before calling this function. Do not assume
/// that all contexts you create will have the same set of extensions
/// available, or that recreating an existing context will offer the same
/// extensions again.
/// 
/// While it's probably not a massive overhead, this function is not an O(1)
/// operation. Check the extensions you care about after creating the GL
/// context and save that information somewhere instead of calling the function
/// every time you need to know.
/// 
/// \param extension the name of the extension to check
/// \returns SDL_TRUE if the extension is supported, SDL_FALSE otherwise.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const GL_ExtensionSupported = SDL_GL_ExtensionSupported;
extern fn SDL_GL_ExtensionSupported(
    extension: ?[*:0]const u8,
) bool;

/// 
/// Reset all previously set OpenGL context attributes to their default values.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_GL_GetAttribute
/// \sa SDL_GL_SetAttribute
/// 
/// 
pub const GL_ResetAttributes = SDL_GL_ResetAttributes;
extern fn SDL_GL_ResetAttributes() void;

/// 
/// Set an OpenGL window attribute before window creation.
/// 
/// This function sets the OpenGL attribute `attr` to `value`. The requested
/// attributes should be set before creating an OpenGL window. You should use
/// SDL_GL_GetAttribute() to check the values after creating the OpenGL
/// context, since the values obtained can differ from the requested ones.
/// 
/// \param attr an SDL_GLattr enum value specifying the OpenGL attribute to set
/// \param value the desired value for the attribute
/// \returns 0 on success or a negative error code on failure; call
///          SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_GL_GetAttribute
/// \sa SDL_GL_ResetAttributes
/// 
/// 
pub const GL_SetAttribute = SDL_GL_SetAttribute;
extern fn SDL_GL_SetAttribute(
    attr: SDL_GLattr,
    value: c_int,
) c_int;

/// 
/// Get the actual value for an attribute from the current context.
/// 
/// \param attr an SDL_GLattr enum value specifying the OpenGL attribute to get
/// \param value a pointer filled in with the current value of `attr`
/// \returns 0 on success or a negative error code on failure; call
///          SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_GL_ResetAttributes
/// \sa SDL_GL_SetAttribute
/// 
/// 
pub const GL_GetAttribute = SDL_GL_GetAttribute;
extern fn SDL_GL_GetAttribute(
    attr: SDL_GLattr,
    value: *c_int,
) c_int;

/// 
/// Create an OpenGL context for an OpenGL window, and make it current.
/// 
/// Windows users new to OpenGL should note that, for historical reasons, GL
/// functions added after OpenGL version 1.1 are not available by default.
/// Those functions must be loaded at run-time, either with an OpenGL
/// extension-handling library or with SDL_GL_GetProcAddress() and its related
/// functions.
/// 
/// SDL_GLContext is an alias for `void *`. It's opaque to the application.
/// 
/// \param window the window to associate with the context
/// \returns the OpenGL context associated with `window` or NULL on error; call
///          SDL_GetError() for more details.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_GL_DeleteContext
/// \sa SDL_GL_MakeCurrent
/// 
/// 
pub const GL_CreateContext = SDL_GL_CreateContext;
extern fn SDL_GL_CreateContext(
    window: ?*SDL_Window,
) SDL_GLContext;

/// 
/// Set up an OpenGL context for rendering into an OpenGL window.
/// 
/// The context must have been created with a compatible window.
/// 
/// \param window the window to associate with the context
/// \param context the OpenGL context to associate with the window
/// \returns 0 on success or a negative error code on failure; call
///          SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_GL_CreateContext
/// 
/// 
pub const GL_MakeCurrent = SDL_GL_MakeCurrent;
extern fn SDL_GL_MakeCurrent(
    window: ?*SDL_Window,
    context: SDL_GLContext,
) c_int;

/// 
/// Get the currently active OpenGL window.
/// 
/// \returns the currently active OpenGL window on success or NULL on failure;
///          call SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const GL_GetCurrentWindow = SDL_GL_GetCurrentWindow;
extern fn SDL_GL_GetCurrentWindow() ?*SDL_Window;

/// 
/// Get the currently active OpenGL context.
/// 
/// \returns the currently active OpenGL context or NULL on failure; call
///          SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_GL_MakeCurrent
/// 
/// 
pub const GL_GetCurrentContext = SDL_GL_GetCurrentContext;
extern fn SDL_GL_GetCurrentContext() SDL_GLContext;

/// 
/// Get the currently active EGL display.
/// 
/// \returns the currently active EGL display or NULL on failure; call
///          SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const EGL_GetCurrentEGLDisplay = SDL_EGL_GetCurrentEGLDisplay;
extern fn SDL_EGL_GetCurrentEGLDisplay() SDL_EGLDisplay;

/// 
/// Get the currently active EGL config.
/// 
/// \returns the currently active EGL config or NULL on failure; call
///          SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const EGL_GetCurrentEGLConfig = SDL_EGL_GetCurrentEGLConfig;
extern fn SDL_EGL_GetCurrentEGLConfig() SDL_EGLConfig;

/// 
/// Get the EGL surface associated with the window.
/// 
/// \returns the EGLSurface pointer associated with the window, or NULL on
///          failure.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const EGL_GetWindowEGLSurface = SDL_EGL_GetWindowEGLSurface;
extern fn SDL_EGL_GetWindowEGLSurface(
    window: ?*SDL_Window,
) SDL_EGLSurface;

/// 
/// Sets the callbacks for defining custom EGLAttrib arrays for EGL
/// initialization.
/// 
/// Each callback should return a pointer to an EGL attribute array terminated
/// with EGL_NONE. Callbacks may return NULL pointers to signal an error, which
/// will cause the SDL_CreateWindow process to fail gracefully.
/// 
/// The arrays returned by each callback will be appended to the existing
/// attribute arrays defined by SDL.
/// 
/// NOTE: These callback pointers will be reset after SDL_GL_ResetAttributes.
/// 
/// \param platformAttribCallback Callback for attributes to pass to
///                               eglGetPlatformDisplay.
/// \param surfaceAttribCallback Callback for attributes to pass to
///                              eglCreateSurface.
/// \param contextAttribCallback Callback for attributes to pass to
///                              eglCreateContext.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const EGL_SetEGLAttributeCallbacks = SDL_EGL_SetEGLAttributeCallbacks;
extern fn SDL_EGL_SetEGLAttributeCallbacks(
    platformAttribCallback: SDL_EGLAttribArrayCallback,
    surfaceAttribCallback: SDL_EGLIntArrayCallback,
    contextAttribCallback: SDL_EGLIntArrayCallback,
) void;

/// 
/// Get the size of a window's underlying drawable in pixels.
/// 
/// This returns info useful for calling glViewport().
/// 
/// This may differ from SDL_GetWindowSize() if we're rendering to a high-DPI
/// drawable, i.e. the window was created with `SDL_WINDOW_ALLOW_HIGHDPI` on a
/// platform with high-DPI support (Apple calls this "Retina"), and not
/// disabled by the `SDL_HINT_VIDEO_HIGHDPI_DISABLED` hint.
/// 
/// \param window the window from which the drawable size should be queried
/// \param w a pointer to variable for storing the width in pixels, may be NULL
/// \param h a pointer to variable for storing the height in pixels, may be
///          NULL
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_CreateWindow
/// \sa SDL_GetWindowSize
/// 
/// 
pub const GL_GetDrawableSize = SDL_GL_GetDrawableSize;
extern fn SDL_GL_GetDrawableSize(
    window: ?*SDL_Window,
    w: *c_int,
    h: *c_int,
) void;

/// 
/// Set the swap interval for the current OpenGL context.
/// 
/// Some systems allow specifying -1 for the interval, to enable adaptive
/// vsync. Adaptive vsync works the same as vsync, but if you've already missed
/// the vertical retrace for a given frame, it swaps buffers immediately, which
/// might be less jarring for the user during occasional framerate drops. If an
/// application requests adaptive vsync and the system does not support it,
/// this function will fail and return -1. In such a case, you should probably
/// retry the call with 1 for the interval.
/// 
/// Adaptive vsync is implemented for some glX drivers with
/// GLX_EXT_swap_control_tear, and for some Windows drivers with
/// WGL_EXT_swap_control_tear.
/// 
/// Read more on the Khronos wiki:
/// https://www.khronos.org/opengl/wiki/Swap_Interval#Adaptive_Vsync
/// 
/// \param interval 0 for immediate updates, 1 for updates synchronized with
///                 the vertical retrace, -1 for adaptive vsync
/// \returns 0 on success or -1 if setting the swap interval is not supported;
///          call SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_GL_GetSwapInterval
/// 
/// 
pub const GL_SetSwapInterval = SDL_GL_SetSwapInterval;
extern fn SDL_GL_SetSwapInterval(
    interval: c_int,
) c_int;

/// 
/// Get the swap interval for the current OpenGL context.
/// 
/// If the system can't determine the swap interval, or there isn't a valid
/// current context, this function will set *interval to 0 as a safe default.
/// 
/// \param interval Output interval value. 0 if there is no vertical retrace synchronization, 1 if the buffer
///          swap is synchronized with the vertical retrace, and -1 if late
///          swaps happen immediately instead of waiting for the next retrace
/// 
/// \returns 0 on success or -1 error.
///          call SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_GL_SetSwapInterval
/// 
/// 
pub const GL_GetSwapInterval = SDL_GL_GetSwapInterval;
extern fn SDL_GL_GetSwapInterval(
    interval: *c_int,
) c_int;

/// 
/// Update a window with OpenGL rendering.
/// 
/// This is used with double-buffered OpenGL contexts, which are the default.
/// 
/// On macOS, make sure you bind 0 to the draw framebuffer before swapping the
/// window, otherwise nothing will happen. If you aren't using
/// glBindFramebuffer(), this is the default and you won't have to do anything
/// extra.
/// 
/// \param window the window to change
/// 
/// \returns 0 on success or a negative error code on failure; call
///          SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const GL_SwapWindow = SDL_GL_SwapWindow;
extern fn SDL_GL_SwapWindow(
    window: ?*SDL_Window,
) c_int;

/// 
/// Delete an OpenGL context.
/// 
/// \param context the OpenGL context to be deleted
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_GL_CreateContext
/// 
/// 
pub const GL_DeleteContext = SDL_GL_DeleteContext;
extern fn SDL_GL_DeleteContext(
    context: SDL_GLContext,
) void;

/// 
/// Get the version of SDL that is linked against your program.
/// 
/// If you are linking to SDL dynamically, then it is possible that the current
/// version will be different than the version you compiled against. This
/// function returns the current version, while SDL_VERSION() is a macro that
/// tells you what version you compiled with.
/// 
/// This function may be called safely at any time, even before SDL_Init().
/// 
/// \param ver the SDL_version structure that contains the version information
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_GetRevision
/// 
/// 
pub const GetVersion = SDL_GetVersion;
extern fn SDL_GetVersion(
    ver: ?*SDL_version,
) void;

/// 
/// Get the code revision of SDL that is linked against your program.
/// 
/// This value is the revision of the code you are linked with and may be
/// different from the code you are compiling with, which is found in the
/// constant SDL_REVISION.
/// 
/// The revision is arbitrary string (a hash value) uniquely identifying the
/// exact revision of the SDL library in use, and is only useful in comparing
/// against other revisions. It is NOT an incrementing number.
/// 
/// If SDL wasn't built from a git repository with the appropriate tools, this
/// will return an empty string.
/// 
/// Prior to SDL 2.0.16, before development moved to GitHub, this returned a
/// hash for a Mercurial repository.
/// 
/// You shouldn't use this function for anything but logging it for debugging
/// purposes. The string is not intended to be reliable in any way.
/// 
/// \returns an arbitrary string, uniquely identifying the exact revision of
///          the SDL library in use.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_GetVersion
/// 
/// 
pub const GetRevision = SDL_GetRevision;
extern fn SDL_GetRevision() ?[*:0]const u8;

/// 
/// Create a window that can be shaped with the specified position, dimensions,
/// and flags.
/// 
/// \param title The title of the window, in UTF-8 encoding.
/// \param x The x position of the window, ::SDL_WINDOWPOS_CENTERED, or
///          ::SDL_WINDOWPOS_UNDEFINED.
/// \param y The y position of the window, ::SDL_WINDOWPOS_CENTERED, or
///          ::SDL_WINDOWPOS_UNDEFINED.
/// \param w The width of the window.
/// \param h The height of the window.
/// \param flags The flags for the window, a mask of SDL_WINDOW_BORDERLESS with
///              any of the following: ::SDL_WINDOW_OPENGL,
///              ::SDL_WINDOW_INPUT_GRABBED, ::SDL_WINDOW_HIDDEN,
///              ::SDL_WINDOW_RESIZABLE, ::SDL_WINDOW_MAXIMIZED,
///              ::SDL_WINDOW_MINIMIZED, ::SDL_WINDOW_BORDERLESS is always set,
///              and ::SDL_WINDOW_FULLSCREEN is always unset.
/// \return the window created, or NULL if window creation failed.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_DestroyWindow
/// 
/// 
pub const CreateShapedWindow = SDL_CreateShapedWindow;
extern fn SDL_CreateShapedWindow(
    title: ?[*:0]const u8,
    x: c_uint,
    y: c_uint,
    w: c_uint,
    h: c_uint,
    flags: u32,
) ?*SDL_Window;

/// 
/// Return whether the given window is a shaped window.
/// 
/// \param window The window to query for being shaped.
/// \return SDL_TRUE if the window is a window that can be shaped, SDL_FALSE if
///         the window is unshaped or NULL.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_CreateShapedWindow
/// 
/// 
pub const IsShapedWindow = SDL_IsShapedWindow;
extern fn SDL_IsShapedWindow(
    window: ?*const SDL_Window,
) bool;

/// 
/// Set the shape and parameters of a shaped window.
/// 
/// \param window The shaped window whose parameters should be set.
/// \param shape A surface encoding the desired shape for the window.
/// \param shape_mode The parameters to set for the shaped window.
/// \return 0 on success, SDL_INVALID_SHAPE_ARGUMENT on an invalid shape
///         argument, or SDL_NONSHAPEABLE_WINDOW if the SDL_Window given does
///         not reference a valid shaped window.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_WindowShapeMode
/// \sa SDL_GetShapedWindowMode
/// 
/// 
pub const SetWindowShape = SDL_SetWindowShape;
extern fn SDL_SetWindowShape(
    window: ?*SDL_Window,
    shape: ?*SDL_Surface,
    shape_mode: ?*SDL_WindowShapeMode,
) c_int;

/// 
/// Get the shape parameters of a shaped window.
/// 
/// \param window The shaped window whose parameters should be retrieved.
/// \param shape_mode An empty shape-mode structure to fill, or NULL to check
///                   whether the window has a shape.
/// \return 0 if the window has a shape and, provided shape_mode was not NULL,
///         shape_mode has been filled with the mode data,
///         SDL_NONSHAPEABLE_WINDOW if the SDL_Window given is not a shaped
///         window, or SDL_WINDOW_LACKS_SHAPE if the SDL_Window given is a
///         shapeable window currently lacking a shape.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_WindowShapeMode
/// \sa SDL_SetWindowShape
/// 
/// 
pub const GetShapedWindowMode = SDL_GetShapedWindowMode;
extern fn SDL_GetShapedWindowMode(
    window: ?*SDL_Window,
    shape_mode: ?*SDL_WindowShapeMode,
) c_int;

/// 
/// Get the name of the platform.
/// 
/// Here are the names returned for some (but not all) supported platforms:
/// 
/// - "Windows"
/// - "macOS"
/// - "Linux"
/// - "iOS"
/// - "Android"
/// 
/// \returns the name of the platform. If the correct platform name is not
///          available, returns a string beginning with the text "Unknown".
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const GetPlatform = SDL_GetPlatform;
extern fn SDL_GetPlatform() ?[*:0]const u8;

/// 
/// Set the SDL error message for the current thread.
/// 
/// Calling this function will replace any previous error message that was set.
/// 
/// This function always returns -1, since SDL frequently uses -1 to signify an
/// failing result, leading to this idiom:
/// 
/// ```c
/// if (error_code) {
///     return SDL_SetError("This operation has failed: %d", error_code);
/// }
/// ```
/// 
/// \param fmt a printf()-style message format string
/// \param ... additional parameters matching % tokens in the `fmt` string, if
///            any
/// \returns always -1.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_ClearError
/// \sa SDL_GetError
/// 
/// 
pub const SetError = SDL_SetError;
extern fn SDL_SetError(
    fmt: [*:0]const u8,
    ...,
) c_int;

/// 
/// Retrieve a message about the last error that occurred on the current
/// thread.
/// 
/// It is possible for multiple errors to occur before calling SDL_GetError().
/// Only the last error is returned.
/// 
/// The message is only applicable when an SDL function has signaled an error.
/// You must check the return values of SDL function calls to determine when to
/// appropriately call SDL_GetError(). You should *not* use the results of
/// SDL_GetError() to decide if an error has occurred! Sometimes SDL will set
/// an error string even when reporting success.
/// 
/// SDL will *not* clear the error string for successful API calls. You *must*
/// check return values for failure cases before you can assume the error
/// string applies.
/// 
/// Error strings are set per-thread, so an error set in a different thread
/// will not interfere with the current thread's operation.
/// 
/// The returned string is internally allocated and must not be freed by the
/// application.
/// 
/// \returns a message with information about the specific error that occurred,
///          or an empty string if there hasn't been an error message set since
///          the last call to SDL_ClearError(). The message is only applicable
///          when an SDL function has signaled an error. You must check the
///          return values of SDL function calls to determine when to
///          appropriately call SDL_GetError().
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_ClearError
/// \sa SDL_SetError
/// 
/// 
pub const GetError = SDL_GetError;
extern fn SDL_GetError() ?[*:0]const u8;

/// 
/// Get the last error message that was set for the current thread.
/// 
/// This allows the caller to copy the error string into a provided buffer, but
/// otherwise operates exactly the same as SDL_GetError().
/// 
/// \param errstr A buffer to fill with the last error message that was set for
///               the current thread
/// \param maxlen The size of the buffer pointed to by the errstr parameter
/// \returns the pointer passed in as the `errstr` parameter.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_GetError
/// 
/// 
pub const GetErrorMsg = SDL_GetErrorMsg;
extern fn SDL_GetErrorMsg(
    errstr: ?[*:0]u8,
    maxlen: c_int,
) ?[*:0]u8;

/// 
/// Clear any previous error message for this thread.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_GetError
/// \sa SDL_SetError
/// 
/// 
pub const ClearError = SDL_ClearError;
extern fn SDL_ClearError() void;

/// 
///  \name Internal error functions
/// 
///  \internal
///  Private error reporting function - used internally.
/// 
/// 
pub const Error = SDL_Error;
extern fn SDL_Error(
    code: SDL_errorcode,
) c_int;

/// 
/// Allocate a new RGB surface with a specific pixel format.
/// 
/// \param width the width of the surface
/// \param height the height of the surface
/// \param format the SDL_PixelFormatEnum for the new surface's pixel format.
/// \returns the new SDL_Surface structure that is created or NULL if it fails;
///          call SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_CreateSurfaceFrom
/// \sa SDL_DestroySurface
/// 
/// 
pub const CreateSurface = SDL_CreateSurface;
extern fn SDL_CreateSurface(
    width: c_int,
    height: c_int,
    format: u32,
) ?*SDL_Surface;

/// 
/// Allocate a new RGB surface with with a specific pixel format and existing
/// pixel data.
/// 
/// No copy is made of the pixel data. Pixel data is not managed automatically;
/// you must free the surface before you free the pixel data.
/// 
/// \param pixels a pointer to existing pixel data
/// \param width the width of the surface
/// \param height the height of the surface
/// \param pitch the pitch of the surface in bytes
/// \param format the SDL_PixelFormatEnum for the new surface's pixel format.
/// \returns the new SDL_Surface structure that is created or NULL if it fails;
///          call SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_CreateSurface
/// \sa SDL_DestroySurface
/// 
/// 
pub const CreateSurfaceFrom = SDL_CreateSurfaceFrom;
extern fn SDL_CreateSurfaceFrom(
    pixels: ?*anyopaque,
    width: c_int,
    height: c_int,
    pitch: c_int,
    format: u32,
) ?*SDL_Surface;

/// 
/// Free an RGB surface.
/// 
/// It is safe to pass NULL to this function.
/// 
/// \param surface the SDL_Surface to free.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_CreateSurface
/// \sa SDL_CreateSurfaceFrom
/// \sa SDL_LoadBMP
/// \sa SDL_LoadBMP_RW
/// 
/// 
pub const DestroySurface = SDL_DestroySurface;
extern fn SDL_DestroySurface(
    surface: ?*SDL_Surface,
) void;

/// 
/// Set the palette used by a surface.
/// 
/// A single palette can be shared with many surfaces.
/// 
/// \param surface the SDL_Surface structure to update
/// \param palette the SDL_Palette structure to use
/// \returns 0 on success or a negative error code on failure; call
///          SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const SetSurfacePalette = SDL_SetSurfacePalette;
extern fn SDL_SetSurfacePalette(
    surface: ?*SDL_Surface,
    palette: ?*SDL_Palette,
) c_int;

/// 
/// Set up a surface for directly accessing the pixels.
/// 
/// Between calls to SDL_LockSurface() / SDL_UnlockSurface(), you can write to
/// and read from `surface->pixels`, using the pixel format stored in
/// `surface->format`. Once you are done accessing the surface, you should use
/// SDL_UnlockSurface() to release it.
/// 
/// Not all surfaces require locking. If `SDL_MUSTLOCK(surface)` evaluates to
/// 0, then you can read and write to the surface at any time, and the pixel
/// format of the surface will not change.
/// 
/// \param surface the SDL_Surface structure to be locked
/// \returns 0 on success or a negative error code on failure; call
///          SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_MUSTLOCK
/// \sa SDL_UnlockSurface
/// 
/// 
pub const LockSurface = SDL_LockSurface;
extern fn SDL_LockSurface(
    surface: ?*SDL_Surface,
) c_int;

/// 
/// Release a surface after directly accessing the pixels.
/// 
/// \param surface the SDL_Surface structure to be unlocked
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_LockSurface
/// 
/// 
pub const UnlockSurface = SDL_UnlockSurface;
extern fn SDL_UnlockSurface(
    surface: ?*SDL_Surface,
) void;

/// 
/// Load a BMP image from a seekable SDL data stream.
/// 
/// The new surface should be freed with SDL_DestroySurface(). Not doing so will
/// result in a memory leak.
/// 
/// src is an open SDL_RWops buffer, typically loaded with SDL_RWFromFile.
/// Alternitavely, you might also use the macro SDL_LoadBMP to load a bitmap
/// from a file, convert it to an SDL_Surface and then close the file.
/// 
/// \param src the data stream for the surface
/// \param freesrc non-zero to close the stream after being read
/// \returns a pointer to a new SDL_Surface structure or NULL if there was an
///          error; call SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_DestroySurface
/// \sa SDL_RWFromFile
/// \sa SDL_LoadBMP
/// \sa SDL_SaveBMP_RW
/// 
/// 
pub const LoadBMP_RW = SDL_LoadBMP_RW;
extern fn SDL_LoadBMP_RW(
    src: ?*SDL_RWops,
    freesrc: c_int,
) ?*SDL_Surface;

/// 
/// Save a surface to a seekable SDL data stream in BMP format.
/// 
/// Surfaces with a 24-bit, 32-bit and paletted 8-bit format get saved in the
/// BMP directly. Other RGB formats with 8-bit or higher get converted to a
/// 24-bit surface or, if they have an alpha mask or a colorkey, to a 32-bit
/// surface before they are saved. YUV and paletted 1-bit and 4-bit formats are
/// not supported.
/// 
/// \param surface the SDL_Surface structure containing the image to be saved
/// \param dst a data stream to save to
/// \param freedst non-zero to close the stream after being written
/// \returns 0 on success or a negative error code on failure; call
///          SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_LoadBMP_RW
/// \sa SDL_SaveBMP
/// 
/// 
pub const SaveBMP_RW = SDL_SaveBMP_RW;
extern fn SDL_SaveBMP_RW(
    surface: ?*SDL_Surface,
    dst: ?*SDL_RWops,
    freedst: c_int,
) c_int;

/// 
/// Set the RLE acceleration hint for a surface.
/// 
/// If RLE is enabled, color key and alpha blending blits are much faster, but
/// the surface must be locked before directly accessing the pixels.
/// 
/// \param surface the SDL_Surface structure to optimize
/// \param flag 0 to disable, non-zero to enable RLE acceleration
/// \returns 0 on success or a negative error code on failure; call
///          SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_BlitSurface
/// \sa SDL_LockSurface
/// \sa SDL_UnlockSurface
/// 
/// 
pub const SetSurfaceRLE = SDL_SetSurfaceRLE;
extern fn SDL_SetSurfaceRLE(
    surface: ?*SDL_Surface,
    flag: c_int,
) c_int;

/// 
/// Returns whether the surface is RLE enabled
/// 
/// It is safe to pass a NULL `surface` here; it will return SDL_FALSE.
/// 
/// \param surface the SDL_Surface structure to query
/// \returns SDL_TRUE if the surface is RLE enabled, SDL_FALSE otherwise.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_SetSurfaceRLE
/// 
/// 
pub const SurfaceHasRLE = SDL_SurfaceHasRLE;
extern fn SDL_SurfaceHasRLE(
    surface: ?*SDL_Surface,
) bool;

/// 
/// Set the color key (transparent pixel) in a surface.
/// 
/// The color key defines a pixel value that will be treated as transparent in
/// a blit. For example, one can use this to specify that cyan pixels should be
/// considered transparent, and therefore not rendered.
/// 
/// It is a pixel of the format used by the surface, as generated by
/// SDL_MapRGB().
/// 
/// RLE acceleration can substantially speed up blitting of images with large
/// horizontal runs of transparent pixels. See SDL_SetSurfaceRLE() for details.
/// 
/// \param surface the SDL_Surface structure to update
/// \param flag SDL_TRUE to enable color key, SDL_FALSE to disable color key
/// \param key the transparent pixel
/// \returns 0 on success or a negative error code on failure; call
///          SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_BlitSurface
/// \sa SDL_GetSurfaceColorKey
/// 
/// 
pub const SetSurfaceColorKey = SDL_SetSurfaceColorKey;
extern fn SDL_SetSurfaceColorKey(
    surface: ?*SDL_Surface,
    flag: c_int,
    key: u32,
) c_int;

/// 
/// Returns whether the surface has a color key
/// 
/// It is safe to pass a NULL `surface` here; it will return SDL_FALSE.
/// 
/// \param surface the SDL_Surface structure to query
/// \return SDL_TRUE if the surface has a color key, SDL_FALSE otherwise.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_SetSurfaceColorKey
/// \sa SDL_GetSurfaceColorKey
/// 
/// 
pub const SurfaceHasColorKey = SDL_SurfaceHasColorKey;
extern fn SDL_SurfaceHasColorKey(
    surface: ?*SDL_Surface,
) bool;

/// 
/// Get the color key (transparent pixel) for a surface.
/// 
/// The color key is a pixel of the format used by the surface, as generated by
/// SDL_MapRGB().
/// 
/// If the surface doesn't have color key enabled this function returns -1.
/// 
/// \param surface the SDL_Surface structure to query
/// \param key a pointer filled in with the transparent pixel
/// \returns 0 on success or a negative error code on failure; call
///          SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_BlitSurface
/// \sa SDL_SetSurfaceColorKey
/// 
/// 
pub const GetSurfaceColorKey = SDL_GetSurfaceColorKey;
extern fn SDL_GetSurfaceColorKey(
    surface: ?*SDL_Surface,
    key: ?*u32,
) c_int;

/// 
/// Set an additional color value multiplied into blit operations.
/// 
/// When this surface is blitted, during the blit operation each source color
/// channel is modulated by the appropriate color value according to the
/// following formula:
/// 
/// `srcC = srcC * (color / 255)`
/// 
/// \param surface the SDL_Surface structure to update
/// \param r the red color value multiplied into blit operations
/// \param g the green color value multiplied into blit operations
/// \param b the blue color value multiplied into blit operations
/// \returns 0 on success or a negative error code on failure; call
///          SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_GetSurfaceColorMod
/// \sa SDL_SetSurfaceAlphaMod
/// 
/// 
pub const SetSurfaceColorMod = SDL_SetSurfaceColorMod;
extern fn SDL_SetSurfaceColorMod(
    surface: ?*SDL_Surface,
    r: u8,
    g: u8,
    b: u8,
) c_int;

/// 
/// Get the additional color value multiplied into blit operations.
/// 
/// \param surface the SDL_Surface structure to query
/// \param r a pointer filled in with the current red color value
/// \param g a pointer filled in with the current green color value
/// \param b a pointer filled in with the current blue color value
/// \returns 0 on success or a negative error code on failure; call
///          SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_GetSurfaceAlphaMod
/// \sa SDL_SetSurfaceColorMod
/// 
/// 
pub const GetSurfaceColorMod = SDL_GetSurfaceColorMod;
extern fn SDL_GetSurfaceColorMod(
    surface: ?*SDL_Surface,
    r: ?*u8,
    g: ?*u8,
    b: ?*u8,
) c_int;

/// 
/// Set an additional alpha value used in blit operations.
/// 
/// When this surface is blitted, during the blit operation the source alpha
/// value is modulated by this alpha value according to the following formula:
/// 
/// `srcA = srcA * (alpha / 255)`
/// 
/// \param surface the SDL_Surface structure to update
/// \param alpha the alpha value multiplied into blit operations
/// \returns 0 on success or a negative error code on failure; call
///          SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_GetSurfaceAlphaMod
/// \sa SDL_SetSurfaceColorMod
/// 
/// 
pub const SetSurfaceAlphaMod = SDL_SetSurfaceAlphaMod;
extern fn SDL_SetSurfaceAlphaMod(
    surface: ?*SDL_Surface,
    alpha: u8,
) c_int;

/// 
/// Get the additional alpha value used in blit operations.
/// 
/// \param surface the SDL_Surface structure to query
/// \param alpha a pointer filled in with the current alpha value
/// \returns 0 on success or a negative error code on failure; call
///          SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_GetSurfaceColorMod
/// \sa SDL_SetSurfaceAlphaMod
/// 
/// 
pub const GetSurfaceAlphaMod = SDL_GetSurfaceAlphaMod;
extern fn SDL_GetSurfaceAlphaMod(
    surface: ?*SDL_Surface,
    alpha: ?*u8,
) c_int;

/// 
/// Set the blend mode used for blit operations.
/// 
/// To copy a surface to another surface (or texture) without blending with the
/// existing data, the blendmode of the SOURCE surface should be set to
/// `SDL_BLENDMODE_NONE`.
/// 
/// \param surface the SDL_Surface structure to update
/// \param blendMode the SDL_BlendMode to use for blit blending
/// \returns 0 on success or a negative error code on failure; call
///          SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_GetSurfaceBlendMode
/// 
/// 
pub const SetSurfaceBlendMode = SDL_SetSurfaceBlendMode;
extern fn SDL_SetSurfaceBlendMode(
    surface: ?*SDL_Surface,
    blendMode: SDL_BlendMode,
) c_int;

/// 
/// Get the blend mode used for blit operations.
/// 
/// \param surface the SDL_Surface structure to query
/// \param blendMode a pointer filled in with the current SDL_BlendMode
/// \returns 0 on success or a negative error code on failure; call
///          SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_SetSurfaceBlendMode
/// 
/// 
pub const GetSurfaceBlendMode = SDL_GetSurfaceBlendMode;
extern fn SDL_GetSurfaceBlendMode(
    surface: ?*SDL_Surface,
    blendMode: ?*SDL_BlendMode,
) c_int;

/// 
/// Set the clipping rectangle for a surface.
/// 
/// When `surface` is the destination of a blit, only the area within the clip
/// rectangle is drawn into.
/// 
/// Note that blits are automatically clipped to the edges of the source and
/// destination surfaces.
/// 
/// \param surface the SDL_Surface structure to be clipped
/// \param rect the SDL_Rect structure representing the clipping rectangle, or
///             NULL to disable clipping
/// \returns SDL_TRUE if the rectangle intersects the surface, otherwise
///          SDL_FALSE and blits will be completely clipped.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_BlitSurface
/// \sa SDL_GetSurfaceClipRect
/// 
/// 
pub const SetSurfaceClipRect = SDL_SetSurfaceClipRect;
extern fn SDL_SetSurfaceClipRect(
    surface: ?*SDL_Surface,
    rect: ?*const SDL_Rect,
) bool;

/// 
/// Get the clipping rectangle for a surface.
/// 
/// When `surface` is the destination of a blit, only the area within the clip
/// rectangle is drawn into.
/// 
/// \param surface the SDL_Surface structure representing the surface to be
///                clipped
/// \param rect an SDL_Rect structure filled in with the clipping rectangle for
///             the surface
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_BlitSurface
/// \sa SDL_SetSurfaceClipRect
/// 
/// 
pub const GetSurfaceClipRect = SDL_GetSurfaceClipRect;
extern fn SDL_GetSurfaceClipRect(
    surface: ?*SDL_Surface,
    rect: ?*SDL_Rect,
) void;

/// /*
/// Creates a new surface identical to the existing surface.
/// 
/// The returned surface should be freed with SDL_DestroySurface().
/// 
/// \param surface the surface to duplicate.
/// \returns a copy of the surface, or NULL on failure; call SDL_GetError() for
///          more information.
/// 
/// 
pub const DuplicateSurface = SDL_DuplicateSurface;
extern fn SDL_DuplicateSurface(
    surface: ?*SDL_Surface,
) ?*SDL_Surface;

/// 
/// Copy an existing surface to a new surface of the specified format.
/// 
/// This function is used to optimize images for faster *repeat* blitting. This
/// is accomplished by converting the original and storing the result as a new
/// surface. The new, optimized surface can then be used as the source for
/// future blits, making them faster.
/// 
/// \param surface the existing SDL_Surface structure to convert
/// \param format the SDL_PixelFormat structure that the new surface is
///               optimized for
/// \returns the new SDL_Surface structure that is created or NULL if it fails;
///          call SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_CreatePixelFormat
/// \sa SDL_ConvertSurfaceFormat
/// \sa SDL_CreateSurface
/// 
/// 
pub const ConvertSurface = SDL_ConvertSurface;
extern fn SDL_ConvertSurface(
    surface: ?*SDL_Surface,
    format: ?*const SDL_PixelFormat,
) ?*SDL_Surface;

/// 
/// Copy an existing surface to a new surface of the specified format enum.
/// 
/// This function operates just like SDL_ConvertSurface(), but accepts an
/// SDL_PixelFormatEnum value instead of an SDL_PixelFormat structure. As such,
/// it might be easier to call but it doesn't have access to palette
/// information for the destination surface, in case that would be important.
/// 
/// \param surface the existing SDL_Surface structure to convert
/// \param pixel_format the SDL_PixelFormatEnum that the new surface is
///                     optimized for
/// \returns the new SDL_Surface structure that is created or NULL if it fails;
///          call SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_CreatePixelFormat
/// \sa SDL_ConvertSurface
/// \sa SDL_CreateSurface
/// 
/// 
pub const ConvertSurfaceFormat = SDL_ConvertSurfaceFormat;
extern fn SDL_ConvertSurfaceFormat(
    surface: ?*SDL_Surface,
    pixel_format: u32,
) ?*SDL_Surface;

/// 
/// Copy a block of pixels of one format to another format.
/// 
/// \param width the width of the block to copy, in pixels
/// \param height the height of the block to copy, in pixels
/// \param src_format an SDL_PixelFormatEnum value of the `src` pixels format
/// \param src a pointer to the source pixels
/// \param src_pitch the pitch of the source pixels, in bytes
/// \param dst_format an SDL_PixelFormatEnum value of the `dst` pixels format
/// \param dst a pointer to be filled in with new pixel data
/// \param dst_pitch the pitch of the destination pixels, in bytes
/// \returns 0 on success or a negative error code on failure; call
///          SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const ConvertPixels = SDL_ConvertPixels;
extern fn SDL_ConvertPixels(
    width: c_int,
    height: c_int,
    src_format: u32,
    src: ?*const anyopaque,
    src_pitch: c_int,
    dst_format: u32,
    dst: ?*anyopaque,
    dst_pitch: c_int,
) c_int;

/// 
/// Premultiply the alpha on a block of pixels.
/// 
/// This is safe to use with src == dst, but not for other overlapping areas.
/// 
/// This function is currently only implemented for SDL_PIXELFORMAT_ARGB8888.
/// 
/// \param width the width of the block to convert, in pixels
/// \param height the height of the block to convert, in pixels
/// \param src_format an SDL_PixelFormatEnum value of the `src` pixels format
/// \param src a pointer to the source pixels
/// \param src_pitch the pitch of the source pixels, in bytes
/// \param dst_format an SDL_PixelFormatEnum value of the `dst` pixels format
/// \param dst a pointer to be filled in with premultiplied pixel data
/// \param dst_pitch the pitch of the destination pixels, in bytes
/// \returns 0 on success or a negative error code on failure; call
///          SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const PremultiplyAlpha = SDL_PremultiplyAlpha;
extern fn SDL_PremultiplyAlpha(
    width: c_int,
    height: c_int,
    src_format: u32,
    src: ?*const anyopaque,
    src_pitch: c_int,
    dst_format: u32,
    dst: ?*anyopaque,
    dst_pitch: c_int,
) c_int;

/// 
/// Perform a fast fill of a rectangle with a specific color.
/// 
/// `color` should be a pixel of the format used by the surface, and can be
/// generated by SDL_MapRGB() or SDL_MapRGBA(). If the color value contains an
/// alpha component then the destination is simply filled with that alpha
/// information, no blending takes place.
/// 
/// If there is a clip rectangle set on the destination (set via
/// SDL_SetSurfaceClipRect()), then this function will fill based on the intersection
/// of the clip rectangle and `rect`.
/// 
/// \param dst the SDL_Surface structure that is the drawing target
/// \param rect the SDL_Rect structure representing the rectangle to fill, or
///             NULL to fill the entire surface
/// \param color the color to fill with
/// \returns 0 on success or a negative error code on failure; call
///          SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_FillSurfaceRects
/// 
/// 
pub const FillSurfaceRect = SDL_FillSurfaceRect;
extern fn SDL_FillSurfaceRect(
    dst: ?*SDL_Surface,
    rect: ?*const SDL_Rect,
    color: u32,
) c_int;

/// 
/// Perform a fast fill of a set of rectangles with a specific color.
/// 
/// `color` should be a pixel of the format used by the surface, and can be
/// generated by SDL_MapRGB() or SDL_MapRGBA(). If the color value contains an
/// alpha component then the destination is simply filled with that alpha
/// information, no blending takes place.
/// 
/// If there is a clip rectangle set on the destination (set via
/// SDL_SetSurfaceClipRect()), then this function will fill based on the intersection
/// of the clip rectangle and `rect`.
/// 
/// \param dst the SDL_Surface structure that is the drawing target
/// \param rects an array of SDL_Rects representing the rectangles to fill.
/// \param count the number of rectangles in the array
/// \param color the color to fill with
/// \returns 0 on success or a negative error code on failure; call
///          SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_FillSurfaceRect
/// 
/// 
pub const FillSurfaceRects = SDL_FillSurfaceRects;
extern fn SDL_FillSurfaceRects(
    dst: ?*SDL_Surface,
    rects: ?*const SDL_Rect,
    count: c_int,
    color: u32,
) c_int;

/// 
///  Performs a fast blit from the source surface to the destination surface.
/// 
///  This assumes that the source and destination rectangles are
///  the same size.  If either \c srcrect or \c dstrect are NULL, the entire
///  surface (\c src or \c dst) is copied.  The final blit rectangles are saved
///  in \c srcrect and \c dstrect after all clipping is performed.
/// 
///  The blit function should not be called on a locked surface.
/// 
///  The blit semantics for surfaces with and without blending and colorkey
///  are defined as follows:
///  \verbatim
///     RGBA->RGB:
///       Source surface blend mode set to SDL_BLENDMODE_BLEND:
///         alpha-blend (using the source alpha-channel and per-surface alpha)
///         SDL_SRCCOLORKEY ignored.
///       Source surface blend mode set to SDL_BLENDMODE_NONE:
///         copy RGB.
///         if SDL_SRCCOLORKEY set, only copy the pixels matching the
///         RGB values of the source color key, ignoring alpha in the
///         comparison.
/// 
///     RGB->RGBA:
///       Source surface blend mode set to SDL_BLENDMODE_BLEND:
///         alpha-blend (using the source per-surface alpha)
///       Source surface blend mode set to SDL_BLENDMODE_NONE:
///         copy RGB, set destination alpha to source per-surface alpha value.
///       both:
///         if SDL_SRCCOLORKEY set, only copy the pixels matching the
///         source color key.
/// 
///     RGBA->RGBA:
///       Source surface blend mode set to SDL_BLENDMODE_BLEND:
///         alpha-blend (using the source alpha-channel and per-surface alpha)
///         SDL_SRCCOLORKEY ignored.
///       Source surface blend mode set to SDL_BLENDMODE_NONE:
///         copy all of RGBA to the destination.
///         if SDL_SRCCOLORKEY set, only copy the pixels matching the
///         RGB values of the source color key, ignoring alpha in the
///         comparison.
/// 
///     RGB->RGB:
///       Source surface blend mode set to SDL_BLENDMODE_BLEND:
///         alpha-blend (using the source per-surface alpha)
///       Source surface blend mode set to SDL_BLENDMODE_NONE:
///         copy RGB.
///       both:
///         if SDL_SRCCOLORKEY set, only copy the pixels matching the
///         source color key.
///     \endverbatim
/// 
/// \param src the SDL_Surface structure to be copied from
/// \param srcrect the SDL_Rect structure representing the rectangle to be
///                copied, or NULL to copy the entire surface
/// \param dst the SDL_Surface structure that is the blit target
/// \param dstrect the SDL_Rect structure representing the rectangle that is
///                copied into
/// \returns 0 on success or a negative error code on failure; call
///          SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_BlitSurface
/// 
/// 
pub const BlitSurface = SDL_BlitSurface;
extern fn SDL_BlitSurface(
    src: ?*SDL_Surface,
    srcrect: ?*const SDL_Rect,
    dst: ?*SDL_Surface,
    dstrect: ?*SDL_Rect,
) c_int;

/// 
/// Perform low-level surface blitting only.
/// 
/// This is a semi-private blit function and it performs low-level surface
/// blitting, assuming the input rectangles have already been clipped.
/// 
/// \param src the SDL_Surface structure to be copied from
/// \param srcrect the SDL_Rect structure representing the rectangle to be
///                copied, or NULL to copy the entire surface
/// \param dst the SDL_Surface structure that is the blit target
/// \param dstrect the SDL_Rect structure representing the rectangle that is
///                copied into
/// \returns 0 on success or a negative error code on failure; call
///          SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_BlitSurface
/// 
/// 
pub const BlitSurfaceUnchecked = SDL_BlitSurfaceUnchecked;
extern fn SDL_BlitSurfaceUnchecked(
    src: ?*SDL_Surface,
    srcrect: ?*SDL_Rect,
    dst: ?*SDL_Surface,
    dstrect: ?*SDL_Rect,
) c_int;

/// 
/// Perform a fast, low quality, stretch blit between two surfaces of the same
/// format.
/// 
/// Please use SDL_BlitScaled() instead.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const SoftStretch = SDL_SoftStretch;
extern fn SDL_SoftStretch(
    src: ?*SDL_Surface,
    srcrect: ?*const SDL_Rect,
    dst: ?*SDL_Surface,
    dstrect: ?*const SDL_Rect,
) c_int;

/// 
/// Perform bilinear scaling between two surfaces of the same format, 32BPP.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const SoftStretchLinear = SDL_SoftStretchLinear;
extern fn SDL_SoftStretchLinear(
    src: ?*SDL_Surface,
    srcrect: ?*const SDL_Rect,
    dst: ?*SDL_Surface,
    dstrect: ?*const SDL_Rect,
) c_int;

/// 
/// Perform a scaled surface copy to a destination surface.
/// 
/// \param src the SDL_Surface structure to be copied from
/// \param srcrect the SDL_Rect structure representing the rectangle to be
///                copied
/// \param dst the SDL_Surface structure that is the blit target
/// \param dstrect the SDL_Rect structure representing the rectangle that is
///                copied into
/// \returns 0 on success or a negative error code on failure; call
///          SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_BlitScaled
/// 
/// 
pub const BlitSurfaceScaled = SDL_BlitSurfaceScaled;
extern fn SDL_BlitSurfaceScaled(
    src: ?*SDL_Surface,
    srcrect: ?*const SDL_Rect,
    dst: ?*SDL_Surface,
    dstrect: ?*SDL_Rect,
) c_int;

/// 
/// Perform low-level surface scaled blitting only.
/// 
/// This is a semi-private function and it performs low-level surface blitting,
/// assuming the input rectangles have already been clipped.
/// 
/// \param src the SDL_Surface structure to be copied from
/// \param srcrect the SDL_Rect structure representing the rectangle to be
///                copied
/// \param dst the SDL_Surface structure that is the blit target
/// \param dstrect the SDL_Rect structure representing the rectangle that is
///                copied into
/// \returns 0 on success or a negative error code on failure; call
///          SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_BlitScaled
/// 
/// 
pub const BlitSurfaceUncheckedScaled = SDL_BlitSurfaceUncheckedScaled;
extern fn SDL_BlitSurfaceUncheckedScaled(
    src: ?*SDL_Surface,
    srcrect: ?*SDL_Rect,
    dst: ?*SDL_Surface,
    dstrect: ?*SDL_Rect,
) c_int;

/// 
/// Set the YUV conversion mode
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const SetYUVConversionMode = SDL_SetYUVConversionMode;
extern fn SDL_SetYUVConversionMode(
    mode: SDL_YUV_CONVERSION_MODE,
) void;

/// 
/// Get the YUV conversion mode
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const GetYUVConversionMode = SDL_GetYUVConversionMode;
extern fn SDL_GetYUVConversionMode() SDL_YUV_CONVERSION_MODE;

/// 
/// Get the YUV conversion mode, returning the correct mode for the resolution
/// when the current conversion mode is SDL_YUV_CONVERSION_AUTOMATIC
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const GetYUVConversionModeForResolution = SDL_GetYUVConversionModeForResolution;
extern fn SDL_GetYUVConversionModeForResolution(
    width: c_int,
    height: c_int,
) SDL_YUV_CONVERSION_MODE;

/// 
/// Initialize the HIDAPI library.
/// 
/// This function initializes the HIDAPI library. Calling it is not strictly
/// necessary, as it will be called automatically by SDL_hid_enumerate() and
/// any of the SDL_hid_open_*() functions if it is needed. This function should
/// be called at the beginning of execution however, if there is a chance of
/// HIDAPI handles being opened by different threads simultaneously.
/// 
/// Each call to this function should have a matching call to SDL_hid_exit()
/// 
/// \returns 0 on success and -1 on error.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_hid_exit
/// 
/// 
pub const hid_init = SDL_hid_init;
extern fn SDL_hid_init() c_int;

/// 
/// Finalize the HIDAPI library.
/// 
/// This function frees all of the static data associated with HIDAPI. It
/// should be called at the end of execution to avoid memory leaks.
/// 
/// \returns 0 on success and -1 on error.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_hid_init
/// 
/// 
pub const hid_exit = SDL_hid_exit;
extern fn SDL_hid_exit() c_int;

/// 
/// Check to see if devices may have been added or removed.
/// 
/// Enumerating the HID devices is an expensive operation, so you can call this
/// to see if there have been any system device changes since the last call to
/// this function. A change in the counter returned doesn't necessarily mean
/// that anything has changed, but you can call SDL_hid_enumerate() to get an
/// updated device list.
/// 
/// Calling this function for the first time may cause a thread or other system
/// resource to be allocated to track device change notifications.
/// 
/// \returns a change counter that is incremented with each potential device
///          change, or 0 if device change detection isn't available.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_hid_enumerate
/// 
/// 
pub const hid_device_change_count = SDL_hid_device_change_count;
extern fn SDL_hid_device_change_count() u32;

/// 
/// Enumerate the HID Devices.
/// 
/// This function returns a linked list of all the HID devices attached to the
/// system which match vendor_id and product_id. If `vendor_id` is set to 0
/// then any vendor matches. If `product_id` is set to 0 then any product
/// matches. If `vendor_id` and `product_id` are both set to 0, then all HID
/// devices will be returned.
/// 
/// \param vendor_id The Vendor ID (VID) of the types of device to open.
/// \param product_id The Product ID (PID) of the types of device to open.
/// \returns a pointer to a linked list of type SDL_hid_device_info, containing
///          information about the HID devices attached to the system, or NULL
///          in the case of failure. Free this linked list by calling
///          SDL_hid_free_enumeration().
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_hid_device_change_count
/// 
/// 
pub const hid_enumerate = SDL_hid_enumerate;
extern fn SDL_hid_enumerate(
    vendor_id: c_ushort,
    product_id: c_ushort,
) ?*SDL_hid_device_info;

/// 
/// Free an enumeration Linked List
/// 
/// This function frees a linked list created by SDL_hid_enumerate().
/// 
/// \param devs Pointer to a list of struct_device returned from
///             SDL_hid_enumerate().
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const hid_free_enumeration = SDL_hid_free_enumeration;
extern fn SDL_hid_free_enumeration(
    devs: ?*SDL_hid_device_info,
) void;

/// 
/// Open a HID device using a Vendor ID (VID), Product ID (PID) and optionally
/// a serial number.
/// 
/// If `serial_number` is NULL, the first device with the specified VID and PID
/// is opened.
/// 
/// \param vendor_id The Vendor ID (VID) of the device to open.
/// \param product_id The Product ID (PID) of the device to open.
/// \param serial_number The Serial Number of the device to open (Optionally
///                      NULL).
/// \returns a pointer to a SDL_hid_device object on success or NULL on
///          failure.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const hid_open = SDL_hid_open;
extern fn SDL_hid_open(
    vendor_id: c_ushort,
    product_id: c_ushort,
    serial_number: ?[*:0]const c_wchar,
) ?*SDL_hid_device;

/// 
/// Open a HID device by its path name.
/// 
/// The path name be determined by calling SDL_hid_enumerate(), or a
/// platform-specific path name can be used (eg: /dev/hidraw0 on Linux).
/// 
/// \param path The path name of the device to open
/// \returns a pointer to a SDL_hid_device object on success or NULL on
///          failure.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const hid_open_path = SDL_hid_open_path;
extern fn SDL_hid_open_path(
    path: ?[*:0]const u8,
    bExclusive: c_int,
) ?*SDL_hid_device;

/// 
/// Write an Output report to a HID device.
/// 
/// The first byte of `data` must contain the Report ID. For devices which only
/// support a single report, this must be set to 0x0. The remaining bytes
/// contain the report data. Since the Report ID is mandatory, calls to
/// SDL_hid_write() will always contain one more byte than the report contains.
/// For example, if a hid report is 16 bytes long, 17 bytes must be passed to
/// SDL_hid_write(), the Report ID (or 0x0, for devices with a single report),
/// followed by the report data (16 bytes). In this example, the length passed
/// in would be 17.
/// 
/// SDL_hid_write() will send the data on the first OUT endpoint, if one
/// exists. If it does not, it will send the data through the Control Endpoint
/// (Endpoint 0).
/// 
/// \param dev A device handle returned from SDL_hid_open().
/// \param data The data to send, including the report number as the first
///             byte.
/// \param length The length in bytes of the data to send.
/// \returns the actual number of bytes written and -1 on error.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const hid_write = SDL_hid_write;
extern fn SDL_hid_write(
    dev: ?*SDL_hid_device,
    data: ?[*c]const u8,
    length: usize,
) c_int;

/// 
/// Read an Input report from a HID device with timeout.
/// 
/// Input reports are returned to the host through the INTERRUPT IN endpoint.
/// The first byte will contain the Report number if the device uses numbered
/// reports.
/// 
/// \param dev A device handle returned from SDL_hid_open().
/// \param data A buffer to put the read data into.
/// \param length The number of bytes to read. For devices with multiple
///               reports, make sure to read an extra byte for the report
///               number.
/// \param milliseconds timeout in milliseconds or -1 for blocking wait.
/// \returns the actual number of bytes read and -1 on error. If no packet was
///          available to be read within the timeout period, this function
///          returns 0.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const hid_read_timeout = SDL_hid_read_timeout;
extern fn SDL_hid_read_timeout(
    dev: ?*SDL_hid_device,
    data: ?[*c]u8,
    length: usize,
    milliseconds: c_int,
) c_int;

/// 
/// Read an Input report from a HID device.
/// 
/// Input reports are returned to the host through the INTERRUPT IN endpoint.
/// The first byte will contain the Report number if the device uses numbered
/// reports.
/// 
/// \param dev A device handle returned from SDL_hid_open().
/// \param data A buffer to put the read data into.
/// \param length The number of bytes to read. For devices with multiple
///               reports, make sure to read an extra byte for the report
///               number.
/// \returns the actual number of bytes read and -1 on error. If no packet was
///          available to be read and the handle is in non-blocking mode, this
///          function returns 0.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const hid_read = SDL_hid_read;
extern fn SDL_hid_read(
    dev: ?*SDL_hid_device,
    data: ?[*c]u8,
    length: usize,
) c_int;

/// 
/// Set the device handle to be non-blocking.
/// 
/// In non-blocking mode calls to SDL_hid_read() will return immediately with a
/// value of 0 if there is no data to be read. In blocking mode, SDL_hid_read()
/// will wait (block) until there is data to read before returning.
/// 
/// Nonblocking can be turned on and off at any time.
/// 
/// \param dev A device handle returned from SDL_hid_open().
/// \param nonblock enable or not the nonblocking reads - 1 to enable
///                 nonblocking - 0 to disable nonblocking.
/// \returns 0 on success and -1 on error.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const hid_set_nonblocking = SDL_hid_set_nonblocking;
extern fn SDL_hid_set_nonblocking(
    dev: ?*SDL_hid_device,
    nonblock: c_int,
) c_int;

/// 
/// Send a Feature report to the device.
/// 
/// Feature reports are sent over the Control endpoint as a Set_Report
/// transfer. The first byte of `data` must contain the Report ID. For devices
/// which only support a single report, this must be set to 0x0. The remaining
/// bytes contain the report data. Since the Report ID is mandatory, calls to
/// SDL_hid_send_feature_report() will always contain one more byte than the
/// report contains. For example, if a hid report is 16 bytes long, 17 bytes
/// must be passed to SDL_hid_send_feature_report(): the Report ID (or 0x0, for
/// devices which do not use numbered reports), followed by the report data (16
/// bytes). In this example, the length passed in would be 17.
/// 
/// \param dev A device handle returned from SDL_hid_open().
/// \param data The data to send, including the report number as the first
///             byte.
/// \param length The length in bytes of the data to send, including the report
///               number.
/// \returns the actual number of bytes written and -1 on error.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const hid_send_feature_report = SDL_hid_send_feature_report;
extern fn SDL_hid_send_feature_report(
    dev: ?*SDL_hid_device,
    data: ?[*c]const u8,
    length: usize,
) c_int;

/// 
/// Get a feature report from a HID device.
/// 
/// Set the first byte of `data` to the Report ID of the report to be read.
/// Make sure to allow space for this extra byte in `data`. Upon return, the
/// first byte will still contain the Report ID, and the report data will start
/// in data[1].
/// 
/// \param dev A device handle returned from SDL_hid_open().
/// \param data A buffer to put the read data into, including the Report ID.
///             Set the first byte of `data` to the Report ID of the report to
///             be read, or set it to zero if your device does not use numbered
///             reports.
/// \param length The number of bytes to read, including an extra byte for the
///               report ID. The buffer can be longer than the actual report.
/// \returns the number of bytes read plus one for the report ID (which is
///          still in the first byte), or -1 on error.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const hid_get_feature_report = SDL_hid_get_feature_report;
extern fn SDL_hid_get_feature_report(
    dev: ?*SDL_hid_device,
    data: ?[*c]u8,
    length: usize,
) c_int;

/// 
/// Close a HID device.
/// 
/// \param dev A device handle returned from SDL_hid_open().
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const hid_close = SDL_hid_close;
extern fn SDL_hid_close(
    dev: ?*SDL_hid_device,
) void;

/// 
/// Get The Manufacturer String from a HID device.
/// 
/// \param dev A device handle returned from SDL_hid_open().
/// \param string A wide string buffer to put the data into.
/// \param maxlen The length of the buffer in multiples of wchar_t.
/// \returns 0 on success and -1 on error.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const hid_get_manufacturer_string = SDL_hid_get_manufacturer_string;
extern fn SDL_hid_get_manufacturer_string(
    dev: ?*SDL_hid_device,
    string: ?[*:0]c_wchar,
    maxlen: usize,
) c_int;

/// 
/// Get The Product String from a HID device.
/// 
/// \param dev A device handle returned from SDL_hid_open().
/// \param string A wide string buffer to put the data into.
/// \param maxlen The length of the buffer in multiples of wchar_t.
/// \returns 0 on success and -1 on error.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const hid_get_product_string = SDL_hid_get_product_string;
extern fn SDL_hid_get_product_string(
    dev: ?*SDL_hid_device,
    string: ?[*:0]c_wchar,
    maxlen: usize,
) c_int;

/// 
/// Get The Serial Number String from a HID device.
/// 
/// \param dev A device handle returned from SDL_hid_open().
/// \param string A wide string buffer to put the data into.
/// \param maxlen The length of the buffer in multiples of wchar_t.
/// \returns 0 on success and -1 on error.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const hid_get_serial_number_string = SDL_hid_get_serial_number_string;
extern fn SDL_hid_get_serial_number_string(
    dev: ?*SDL_hid_device,
    string: ?[*:0]c_wchar,
    maxlen: usize,
) c_int;

/// 
/// Get a string from a HID device, based on its string index.
/// 
/// \param dev A device handle returned from SDL_hid_open().
/// \param string_index The index of the string to get.
/// \param string A wide string buffer to put the data into.
/// \param maxlen The length of the buffer in multiples of wchar_t.
/// \returns 0 on success and -1 on error.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const hid_get_indexed_string = SDL_hid_get_indexed_string;
extern fn SDL_hid_get_indexed_string(
    dev: ?*SDL_hid_device,
    string_index: c_int,
    string: ?[*:0]c_wchar,
    maxlen: usize,
) c_int;

/// 
/// Start or stop a BLE scan on iOS and tvOS to pair Steam Controllers
/// 
/// \param active SDL_TRUE to start the scan, SDL_FALSE to stop the scan
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const hid_ble_scan = SDL_hid_ble_scan;
extern fn SDL_hid_ble_scan(
    active: bool,
) void;

/// 
/// Get the human readable name of a pixel format.
/// 
/// \param format the pixel format to query
/// \returns the human readable name of the specified pixel format or
///          `SDL_PIXELFORMAT_UNKNOWN` if the format isn't recognized.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const GetPixelFormatName = SDL_GetPixelFormatName;
extern fn SDL_GetPixelFormatName(
    format: u32,
) ?[*:0]const u8;

/// 
/// Convert one of the enumerated pixel formats to a bpp value and RGBA masks.
/// 
/// \param format one of the SDL_PixelFormatEnum values
/// \param bpp a bits per pixel value; usually 15, 16, or 32
/// \param Rmask a pointer filled in with the red mask for the format
/// \param Gmask a pointer filled in with the green mask for the format
/// \param Bmask a pointer filled in with the blue mask for the format
/// \param Amask a pointer filled in with the alpha mask for the format
/// \returns SDL_TRUE on success or SDL_FALSE if the conversion wasn't
///          possible; call SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_GetPixelFormatEnumForMasks
/// 
/// 
pub const GetMasksForPixelFormatEnum = SDL_GetMasksForPixelFormatEnum;
extern fn SDL_GetMasksForPixelFormatEnum(
    format: u32,
    bpp: *c_int,
    Rmask: ?*u32,
    Gmask: ?*u32,
    Bmask: ?*u32,
    Amask: ?*u32,
) bool;

/// 
/// Convert a bpp value and RGBA masks to an enumerated pixel format.
/// 
/// This will return `SDL_PIXELFORMAT_UNKNOWN` if the conversion wasn't
/// possible.
/// 
/// \param bpp a bits per pixel value; usually 15, 16, or 32
/// \param Rmask the red mask for the format
/// \param Gmask the green mask for the format
/// \param Bmask the blue mask for the format
/// \param Amask the alpha mask for the format
/// \returns one of the SDL_PixelFormatEnum values
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_GetMasksForPixelFormatEnum
/// 
/// 
pub const GetPixelFormatEnumForMasks = SDL_GetPixelFormatEnumForMasks;
extern fn SDL_GetPixelFormatEnumForMasks(
    bpp: c_int,
    Rmask: u32,
    Gmask: u32,
    Bmask: u32,
    Amask: u32,
) u32;

/// 
/// Create an SDL_PixelFormat structure corresponding to a pixel format.
/// 
/// Returned structure may come from a shared global cache (i.e. not newly
/// allocated), and hence should not be modified, especially the palette. Weird
/// errors such as `Blit combination not supported` may occur.
/// 
/// \param pixel_format one of the SDL_PixelFormatEnum values
/// \returns the new SDL_PixelFormat structure or NULL on failure; call
///          SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_DestroyPixelFormat
/// 
/// 
pub const CreatePixelFormat = SDL_CreatePixelFormat;
extern fn SDL_CreatePixelFormat(
    pixel_format: u32,
) ?*SDL_PixelFormat;

/// 
/// Free an SDL_PixelFormat structure allocated by SDL_CreatePixelFormat().
/// 
/// \param format the SDL_PixelFormat structure to free
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_CreatePixelFormat
/// 
/// 
pub const DestroyPixelFormat = SDL_DestroyPixelFormat;
extern fn SDL_DestroyPixelFormat(
    format: ?*SDL_PixelFormat,
) void;

/// 
/// Create a palette structure with the specified number of color entries.
/// 
/// The palette entries are initialized to white.
/// 
/// \param ncolors represents the number of color entries in the color palette
/// \returns a new SDL_Palette structure on success or NULL on failure (e.g. if
///          there wasn't enough memory); call SDL_GetError() for more
///          information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_DestroyPalette
/// 
/// 
pub const CreatePalette = SDL_CreatePalette;
extern fn SDL_CreatePalette(
    ncolors: c_int,
) ?*SDL_Palette;

/// 
/// Set the palette for a pixel format structure.
/// 
/// \param format the SDL_PixelFormat structure that will use the palette
/// \param palette the SDL_Palette structure that will be used
/// \returns 0 on success or a negative error code on failure; call
///          SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_CreatePalette
/// \sa SDL_DestroyPalette
/// 
/// 
pub const SetPixelFormatPalette = SDL_SetPixelFormatPalette;
extern fn SDL_SetPixelFormatPalette(
    format: ?*SDL_PixelFormat,
    palette: ?*SDL_Palette,
) c_int;

/// 
/// Set a range of colors in a palette.
/// 
/// \param palette the SDL_Palette structure to modify
/// \param colors an array of SDL_Color structures to copy into the palette
/// \param firstcolor the index of the first palette entry to modify
/// \param ncolors the number of entries to modify
/// \returns 0 on success or a negative error code if not all of the colors
///          could be set; call SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_CreatePalette
/// \sa SDL_CreateSurface
/// 
/// 
pub const SetPaletteColors = SDL_SetPaletteColors;
extern fn SDL_SetPaletteColors(
    palette: ?*SDL_Palette,
    colors: ?*const SDL_Color,
    firstcolor: c_int,
    ncolors: c_int,
) c_int;

/// 
/// Free a palette created with SDL_CreatePalette().
/// 
/// \param palette the SDL_Palette structure to be freed
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_CreatePalette
/// 
/// 
pub const DestroyPalette = SDL_DestroyPalette;
extern fn SDL_DestroyPalette(
    palette: ?*SDL_Palette,
) void;

/// 
/// Map an RGB triple to an opaque pixel value for a given pixel format.
/// 
/// This function maps the RGB color value to the specified pixel format and
/// returns the pixel value best approximating the given RGB color value for
/// the given pixel format.
/// 
/// If the format has a palette (8-bit) the index of the closest matching color
/// in the palette will be returned.
/// 
/// If the specified pixel format has an alpha component it will be returned as
/// all 1 bits (fully opaque).
/// 
/// If the pixel format bpp (color depth) is less than 32-bpp then the unused
/// upper bits of the return value can safely be ignored (e.g., with a 16-bpp
/// format the return value can be assigned to a Uint16, and similarly a Uint8
/// for an 8-bpp format).
/// 
/// \param format an SDL_PixelFormat structure describing the pixel format
/// \param r the red component of the pixel in the range 0-255
/// \param g the green component of the pixel in the range 0-255
/// \param b the blue component of the pixel in the range 0-255
/// \returns a pixel value
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_GetRGB
/// \sa SDL_GetRGBA
/// \sa SDL_MapRGBA
/// 
/// 
pub const MapRGB = SDL_MapRGB;
extern fn SDL_MapRGB(
    format: ?*const SDL_PixelFormat,
    r: u8,
    g: u8,
    b: u8,
) u32;

/// 
/// Map an RGBA quadruple to a pixel value for a given pixel format.
/// 
/// This function maps the RGBA color value to the specified pixel format and
/// returns the pixel value best approximating the given RGBA color value for
/// the given pixel format.
/// 
/// If the specified pixel format has no alpha component the alpha value will
/// be ignored (as it will be in formats with a palette).
/// 
/// If the format has a palette (8-bit) the index of the closest matching color
/// in the palette will be returned.
/// 
/// If the pixel format bpp (color depth) is less than 32-bpp then the unused
/// upper bits of the return value can safely be ignored (e.g., with a 16-bpp
/// format the return value can be assigned to a Uint16, and similarly a Uint8
/// for an 8-bpp format).
/// 
/// \param format an SDL_PixelFormat structure describing the format of the
///               pixel
/// \param r the red component of the pixel in the range 0-255
/// \param g the green component of the pixel in the range 0-255
/// \param b the blue component of the pixel in the range 0-255
/// \param a the alpha component of the pixel in the range 0-255
/// \returns a pixel value
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_GetRGB
/// \sa SDL_GetRGBA
/// \sa SDL_MapRGB
/// 
/// 
pub const MapRGBA = SDL_MapRGBA;
extern fn SDL_MapRGBA(
    format: ?*const SDL_PixelFormat,
    r: u8,
    g: u8,
    b: u8,
    a: u8,
) u32;

/// 
/// Get RGB values from a pixel in the specified format.
/// 
/// This function uses the entire 8-bit [0..255] range when converting color
/// components from pixel formats with less than 8-bits per RGB component
/// (e.g., a completely white pixel in 16-bit RGB565 format would return [0xff,
/// 0xff, 0xff] not [0xf8, 0xfc, 0xf8]).
/// 
/// \param pixel a pixel value
/// \param format an SDL_PixelFormat structure describing the format of the
///               pixel
/// \param r a pointer filled in with the red component
/// \param g a pointer filled in with the green component
/// \param b a pointer filled in with the blue component
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_GetRGBA
/// \sa SDL_MapRGB
/// \sa SDL_MapRGBA
/// 
/// 
pub const GetRGB = SDL_GetRGB;
extern fn SDL_GetRGB(
    pixel: u32,
    format: ?*const SDL_PixelFormat,
    r: ?*u8,
    g: ?*u8,
    b: ?*u8,
) void;

/// 
/// Get RGBA values from a pixel in the specified format.
/// 
/// This function uses the entire 8-bit [0..255] range when converting color
/// components from pixel formats with less than 8-bits per RGB component
/// (e.g., a completely white pixel in 16-bit RGB565 format would return [0xff,
/// 0xff, 0xff] not [0xf8, 0xfc, 0xf8]).
/// 
/// If the surface has no alpha component, the alpha will be returned as 0xff
/// (100% opaque).
/// 
/// \param pixel a pixel value
/// \param format an SDL_PixelFormat structure describing the format of the
///               pixel
/// \param r a pointer filled in with the red component
/// \param g a pointer filled in with the green component
/// \param b a pointer filled in with the blue component
/// \param a a pointer filled in with the alpha component
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_GetRGB
/// \sa SDL_MapRGB
/// \sa SDL_MapRGBA
/// 
/// 
pub const GetRGBA = SDL_GetRGBA;
extern fn SDL_GetRGBA(
    pixel: u32,
    format: ?*const SDL_PixelFormat,
    r: ?*u8,
    g: ?*u8,
    b: ?*u8,
    a: ?*u8,
) void;

/// 
/// Open a URL/URI in the browser or other appropriate external application.
/// 
/// Open a URL in a separate, system-provided application. How this works will
/// vary wildly depending on the platform. This will likely launch what makes
/// sense to handle a specific URL's protocol (a web browser for `http://`,
/// etc), but it might also be able to launch file managers for directories and
/// other things.
/// 
/// What happens when you open a URL varies wildly as well: your game window
/// may lose focus (and may or may not lose focus if your game was fullscreen
/// or grabbing input at the time). On mobile devices, your app will likely
/// move to the background or your process might be paused. Any given platform
/// may or may not handle a given URL.
/// 
/// If this is unimplemented (or simply unavailable) for a platform, this will
/// fail with an error. A successful result does not mean the URL loaded, just
/// that we launched _something_ to handle it (or at least believe we did).
/// 
/// All this to say: this function can be useful, but you should definitely
/// test it on every platform you target.
/// 
/// \param url A valid URL/URI to open. Use `file:///full/path/to/file` for
///            local files, if supported.
/// \returns 0 on success, or -1 on error; call SDL_GetError() for more
///          information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const OpenURL = SDL_OpenURL;
extern fn SDL_OpenURL(
    url: ?[*:0]const u8,
) c_int;

/// 
/// Get driver-specific information about a window.
/// 
/// You must include SDL_syswm.h for the declaration of SDL_SysWMinfo.
/// 
/// \param window the window about which information is being requested
/// \param info an SDL_SysWMinfo structure filled in with window information
/// \param version the version of info being requested, should be
///                SDL_SYSWM_CURRENT_VERSION
/// \returns 0 on success or a negative error code on failure; call
///          SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const GetWindowWMInfo = SDL_GetWindowWMInfo;
extern fn SDL_GetWindowWMInfo(
    window: ?*SDL_Window,
    info: ?*SDL_SysWMinfo,
    version: u32,
) c_int;

/// 
/// Create a CAMetalLayer-backed NSView/UIView and attach it to the specified
/// window.
/// 
/// On macOS, this does *not* associate a MTLDevice with the CAMetalLayer on
/// its own. It is up to user code to do that.
/// 
/// The returned handle can be casted directly to a NSView or UIView. To access
/// the backing CAMetalLayer, call SDL_Metal_GetLayer().
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_Metal_DestroyView
/// \sa SDL_Metal_GetLayer
/// 
/// 
pub const Metal_CreateView = SDL_Metal_CreateView;
extern fn SDL_Metal_CreateView(
    window: ?*SDL_Window,
) SDL_MetalView;

/// 
/// Destroy an existing SDL_MetalView object.
/// 
/// This should be called before SDL_DestroyWindow, if SDL_Metal_CreateView was
/// called after SDL_CreateWindow.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_Metal_CreateView
/// 
/// 
pub const Metal_DestroyView = SDL_Metal_DestroyView;
extern fn SDL_Metal_DestroyView(
    view: SDL_MetalView,
) void;

/// 
/// Get a pointer to the backing CAMetalLayer for the given view.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_Metal_CreateView
/// 
/// 
pub const Metal_GetLayer = SDL_Metal_GetLayer;
extern fn SDL_Metal_GetLayer(
    view: SDL_MetalView,
) ?*anyopaque;

/// 
/// Get the size of a window's underlying drawable in pixels (for use with
/// setting viewport, scissor & etc).
/// 
/// \param window SDL_Window from which the drawable size should be queried
/// \param w Pointer to variable for storing the width in pixels, may be NULL
/// \param h Pointer to variable for storing the height in pixels, may be NULL
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_GetWindowSize
/// \sa SDL_CreateWindow
/// 
/// 
pub const Metal_GetDrawableSize = SDL_Metal_GetDrawableSize;
extern fn SDL_Metal_GetDrawableSize(
    window: ?*SDL_Window,
    w: *c_int,
    h: *c_int,
) void;

/// 
/// Count the number of haptic devices attached to the system.
/// 
/// \returns the number of haptic devices detected on the system or a negative
///          error code on failure; call SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_HapticName
/// 
/// 
pub const NumHaptics = SDL_NumHaptics;
extern fn SDL_NumHaptics() c_int;

/// 
/// Get the implementation dependent name of a haptic device.
/// 
/// This can be called before any joysticks are opened. If no name can be
/// found, this function returns NULL.
/// 
/// \param device_index index of the device to query.
/// \returns the name of the device or NULL on failure; call SDL_GetError() for
///          more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_NumHaptics
/// 
/// 
pub const HapticName = SDL_HapticName;
extern fn SDL_HapticName(
    device_index: c_int,
) ?[*:0]const u8;

/// 
/// Open a haptic device for use.
/// 
/// The index passed as an argument refers to the N'th haptic device on this
/// system.
/// 
/// When opening a haptic device, its gain will be set to maximum and
/// autocenter will be disabled. To modify these values use SDL_HapticSetGain()
/// and SDL_HapticSetAutocenter().
/// 
/// \param device_index index of the device to open
/// \returns the device identifier or NULL on failure; call SDL_GetError() for
///          more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_HapticClose
/// \sa SDL_HapticIndex
/// \sa SDL_HapticOpenFromJoystick
/// \sa SDL_HapticOpenFromMouse
/// \sa SDL_HapticPause
/// \sa SDL_HapticSetAutocenter
/// \sa SDL_HapticSetGain
/// \sa SDL_HapticStopAll
/// 
/// 
pub const HapticOpen = SDL_HapticOpen;
extern fn SDL_HapticOpen(
    device_index: c_int,
) ?*SDL_Haptic;

/// 
/// Check if the haptic device at the designated index has been opened.
/// 
/// \param device_index the index of the device to query
/// \returns 1 if it has been opened, 0 if it hasn't or on failure; call
///          SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_HapticIndex
/// \sa SDL_HapticOpen
/// 
/// 
pub const HapticOpened = SDL_HapticOpened;
extern fn SDL_HapticOpened(
    device_index: c_int,
) c_int;

/// 
/// Get the index of a haptic device.
/// 
/// \param haptic the SDL_Haptic device to query
/// \returns the index of the specified haptic device or a negative error code
///          on failure; call SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_HapticOpen
/// \sa SDL_HapticOpened
/// 
/// 
pub const HapticIndex = SDL_HapticIndex;
extern fn SDL_HapticIndex(
    haptic: ?*SDL_Haptic,
) c_int;

/// 
/// Query whether or not the current mouse has haptic capabilities.
/// 
/// \returns SDL_TRUE if the mouse is haptic or SDL_FALSE if it isn't.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_HapticOpenFromMouse
/// 
/// 
pub const MouseIsHaptic = SDL_MouseIsHaptic;
extern fn SDL_MouseIsHaptic() c_int;

/// 
/// Try to open a haptic device from the current mouse.
/// 
/// \returns the haptic device identifier or NULL on failure; call
///          SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_HapticOpen
/// \sa SDL_MouseIsHaptic
/// 
/// 
pub const HapticOpenFromMouse = SDL_HapticOpenFromMouse;
extern fn SDL_HapticOpenFromMouse() ?*SDL_Haptic;

/// 
/// Query if a joystick has haptic features.
/// 
/// \param joystick the SDL_Joystick to test for haptic capabilities
/// \returns SDL_TRUE if the joystick is haptic, SDL_FALSE if it isn't, or a
///          negative error code on failure; call SDL_GetError() for more
///          information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_HapticOpenFromJoystick
/// 
/// 
pub const JoystickIsHaptic = SDL_JoystickIsHaptic;
extern fn SDL_JoystickIsHaptic(
    joystick: ?*SDL_Joystick,
) c_int;

/// 
/// Open a haptic device for use from a joystick device.
/// 
/// You must still close the haptic device separately. It will not be closed
/// with the joystick.
/// 
/// When opened from a joystick you should first close the haptic device before
/// closing the joystick device. If not, on some implementations the haptic
/// device will also get unallocated and you'll be unable to use force feedback
/// on that device.
/// 
/// \param joystick the SDL_Joystick to create a haptic device from
/// \returns a valid haptic device identifier on success or NULL on failure;
///          call SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_HapticClose
/// \sa SDL_HapticOpen
/// \sa SDL_JoystickIsHaptic
/// 
/// 
pub const HapticOpenFromJoystick = SDL_HapticOpenFromJoystick;
extern fn SDL_HapticOpenFromJoystick(
    joystick: ?*SDL_Joystick,
) ?*SDL_Haptic;

/// 
/// Close a haptic device previously opened with SDL_HapticOpen().
/// 
/// \param haptic the SDL_Haptic device to close
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_HapticOpen
/// 
/// 
pub const HapticClose = SDL_HapticClose;
extern fn SDL_HapticClose(
    haptic: ?*SDL_Haptic,
) void;

/// 
/// Get the number of effects a haptic device can store.
/// 
/// On some platforms this isn't fully supported, and therefore is an
/// approximation. Always check to see if your created effect was actually
/// created and do not rely solely on SDL_HapticNumEffects().
/// 
/// \param haptic the SDL_Haptic device to query
/// \returns the number of effects the haptic device can store or a negative
///          error code on failure; call SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_HapticNumEffectsPlaying
/// \sa SDL_HapticQuery
/// 
/// 
pub const HapticNumEffects = SDL_HapticNumEffects;
extern fn SDL_HapticNumEffects(
    haptic: ?*SDL_Haptic,
) c_int;

/// 
/// Get the number of effects a haptic device can play at the same time.
/// 
/// This is not supported on all platforms, but will always return a value.
/// 
/// \param haptic the SDL_Haptic device to query maximum playing effects
/// \returns the number of effects the haptic device can play at the same time
///          or a negative error code on failure; call SDL_GetError() for more
///          information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_HapticNumEffects
/// \sa SDL_HapticQuery
/// 
/// 
pub const HapticNumEffectsPlaying = SDL_HapticNumEffectsPlaying;
extern fn SDL_HapticNumEffectsPlaying(
    haptic: ?*SDL_Haptic,
) c_int;

/// 
/// Get the haptic device's supported features in bitwise manner.
/// 
/// \param haptic the SDL_Haptic device to query
/// \returns a list of supported haptic features in bitwise manner (OR'd), or 0
///          on failure; call SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_HapticEffectSupported
/// \sa SDL_HapticNumEffects
/// 
/// 
pub const HapticQuery = SDL_HapticQuery;
extern fn SDL_HapticQuery(
    haptic: ?*SDL_Haptic,
) c_uint;

/// 
/// Get the number of haptic axes the device has.
/// 
/// The number of haptic axes might be useful if working with the
/// SDL_HapticDirection effect.
/// 
/// \param haptic the SDL_Haptic device to query
/// \returns the number of axes on success or a negative error code on failure;
///          call SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const HapticNumAxes = SDL_HapticNumAxes;
extern fn SDL_HapticNumAxes(
    haptic: ?*SDL_Haptic,
) c_int;

/// 
/// Check to see if an effect is supported by a haptic device.
/// 
/// \param haptic the SDL_Haptic device to query
/// \param effect the desired effect to query
/// \returns SDL_TRUE if effect is supported, SDL_FALSE if it isn't, or a
///          negative error code on failure; call SDL_GetError() for more
///          information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_HapticNewEffect
/// \sa SDL_HapticQuery
/// 
/// 
pub const HapticEffectSupported = SDL_HapticEffectSupported;
extern fn SDL_HapticEffectSupported(
    haptic: ?*SDL_Haptic,
    effect: ?*SDL_HapticEffect,
) c_int;

/// 
/// Create a new haptic effect on a specified device.
/// 
/// \param haptic an SDL_Haptic device to create the effect on
/// \param effect an SDL_HapticEffect structure containing the properties of
///               the effect to create
/// \returns the ID of the effect on success or a negative error code on
///          failure; call SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_HapticDestroyEffect
/// \sa SDL_HapticRunEffect
/// \sa SDL_HapticUpdateEffect
/// 
/// 
pub const HapticNewEffect = SDL_HapticNewEffect;
extern fn SDL_HapticNewEffect(
    haptic: ?*SDL_Haptic,
    effect: ?*SDL_HapticEffect,
) c_int;

/// 
/// Update the properties of an effect.
/// 
/// Can be used dynamically, although behavior when dynamically changing
/// direction may be strange. Specifically the effect may re-upload itself and
/// start playing from the start. You also cannot change the type either when
/// running SDL_HapticUpdateEffect().
/// 
/// \param haptic the SDL_Haptic device that has the effect
/// \param effect the identifier of the effect to update
/// \param data an SDL_HapticEffect structure containing the new effect
///             properties to use
/// \returns 0 on success or a negative error code on failure; call
///          SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_HapticDestroyEffect
/// \sa SDL_HapticNewEffect
/// \sa SDL_HapticRunEffect
/// 
/// 
pub const HapticUpdateEffect = SDL_HapticUpdateEffect;
extern fn SDL_HapticUpdateEffect(
    haptic: ?*SDL_Haptic,
    effect: c_int,
    data: ?*SDL_HapticEffect,
) c_int;

/// 
/// Run the haptic effect on its associated haptic device.
/// 
/// To repeat the effect over and over indefinitely, set `iterations` to
/// `SDL_HAPTIC_INFINITY`. (Repeats the envelope - attack and fade.) To make
/// one instance of the effect last indefinitely (so the effect does not fade),
/// set the effect's `length` in its structure/union to `SDL_HAPTIC_INFINITY`
/// instead.
/// 
/// \param haptic the SDL_Haptic device to run the effect on
/// \param effect the ID of the haptic effect to run
/// \param iterations the number of iterations to run the effect; use
///                   `SDL_HAPTIC_INFINITY` to repeat forever
/// \returns 0 on success or a negative error code on failure; call
///          SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_HapticDestroyEffect
/// \sa SDL_HapticGetEffectStatus
/// \sa SDL_HapticStopEffect
/// 
/// 
pub const HapticRunEffect = SDL_HapticRunEffect;
extern fn SDL_HapticRunEffect(
    haptic: ?*SDL_Haptic,
    effect: c_int,
    iterations: u32,
) c_int;

/// 
/// Stop the haptic effect on its associated haptic device.
/// 
/// *
/// 
/// \param haptic the SDL_Haptic device to stop the effect on
/// \param effect the ID of the haptic effect to stop
/// \returns 0 on success or a negative error code on failure; call
///          SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_HapticDestroyEffect
/// \sa SDL_HapticRunEffect
/// 
/// 
pub const HapticStopEffect = SDL_HapticStopEffect;
extern fn SDL_HapticStopEffect(
    haptic: ?*SDL_Haptic,
    effect: c_int,
) c_int;

/// 
/// Destroy a haptic effect on the device.
/// 
/// This will stop the effect if it's running. Effects are automatically
/// destroyed when the device is closed.
/// 
/// \param haptic the SDL_Haptic device to destroy the effect on
/// \param effect the ID of the haptic effect to destroy
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_HapticNewEffect
/// 
/// 
pub const HapticDestroyEffect = SDL_HapticDestroyEffect;
extern fn SDL_HapticDestroyEffect(
    haptic: ?*SDL_Haptic,
    effect: c_int,
) void;

/// 
/// Get the status of the current effect on the specified haptic device.
/// 
/// Device must support the SDL_HAPTIC_STATUS feature.
/// 
/// \param haptic the SDL_Haptic device to query for the effect status on
/// \param effect the ID of the haptic effect to query its status
/// \returns 0 if it isn't playing, 1 if it is playing, or a negative error
///          code on failure; call SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_HapticRunEffect
/// \sa SDL_HapticStopEffect
/// 
/// 
pub const HapticGetEffectStatus = SDL_HapticGetEffectStatus;
extern fn SDL_HapticGetEffectStatus(
    haptic: ?*SDL_Haptic,
    effect: c_int,
) c_int;

/// 
/// Set the global gain of the specified haptic device.
/// 
/// Device must support the SDL_HAPTIC_GAIN feature.
/// 
/// The user may specify the maximum gain by setting the environment variable
/// `SDL_HAPTIC_GAIN_MAX` which should be between 0 and 100. All calls to
/// SDL_HapticSetGain() will scale linearly using `SDL_HAPTIC_GAIN_MAX` as the
/// maximum.
/// 
/// \param haptic the SDL_Haptic device to set the gain on
/// \param gain value to set the gain to, should be between 0 and 100 (0 - 100)
/// \returns 0 on success or a negative error code on failure; call
///          SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_HapticQuery
/// 
/// 
pub const HapticSetGain = SDL_HapticSetGain;
extern fn SDL_HapticSetGain(
    haptic: ?*SDL_Haptic,
    gain: c_int,
) c_int;

/// 
/// Set the global autocenter of the device.
/// 
/// Autocenter should be between 0 and 100. Setting it to 0 will disable
/// autocentering.
/// 
/// Device must support the SDL_HAPTIC_AUTOCENTER feature.
/// 
/// \param haptic the SDL_Haptic device to set autocentering on
/// \param autocenter value to set autocenter to (0-100)
/// \returns 0 on success or a negative error code on failure; call
///          SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_HapticQuery
/// 
/// 
pub const HapticSetAutocenter = SDL_HapticSetAutocenter;
extern fn SDL_HapticSetAutocenter(
    haptic: ?*SDL_Haptic,
    autocenter: c_int,
) c_int;

/// 
/// Pause a haptic device.
/// 
/// Device must support the `SDL_HAPTIC_PAUSE` feature. Call
/// SDL_HapticUnpause() to resume playback.
/// 
/// Do not modify the effects nor add new ones while the device is paused. That
/// can cause all sorts of weird errors.
/// 
/// \param haptic the SDL_Haptic device to pause
/// \returns 0 on success or a negative error code on failure; call
///          SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_HapticUnpause
/// 
/// 
pub const HapticPause = SDL_HapticPause;
extern fn SDL_HapticPause(
    haptic: ?*SDL_Haptic,
) c_int;

/// 
/// Unpause a haptic device.
/// 
/// Call to unpause after SDL_HapticPause().
/// 
/// \param haptic the SDL_Haptic device to unpause
/// \returns 0 on success or a negative error code on failure; call
///          SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_HapticPause
/// 
/// 
pub const HapticUnpause = SDL_HapticUnpause;
extern fn SDL_HapticUnpause(
    haptic: ?*SDL_Haptic,
) c_int;

/// 
/// Stop all the currently playing effects on a haptic device.
/// 
/// \param haptic the SDL_Haptic device to stop
/// \returns 0 on success or a negative error code on failure; call
///          SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const HapticStopAll = SDL_HapticStopAll;
extern fn SDL_HapticStopAll(
    haptic: ?*SDL_Haptic,
) c_int;

/// 
/// Check whether rumble is supported on a haptic device.
/// 
/// \param haptic haptic device to check for rumble support
/// \returns SDL_TRUE if effect is supported, SDL_FALSE if it isn't, or a
///          negative error code on failure; call SDL_GetError() for more
///          information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_HapticRumbleInit
/// \sa SDL_HapticRumblePlay
/// \sa SDL_HapticRumbleStop
/// 
/// 
pub const HapticRumbleSupported = SDL_HapticRumbleSupported;
extern fn SDL_HapticRumbleSupported(
    haptic: ?*SDL_Haptic,
) c_int;

/// 
/// Initialize a haptic device for simple rumble playback.
/// 
/// \param haptic the haptic device to initialize for simple rumble playback
/// \returns 0 on success or a negative error code on failure; call
///          SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_HapticOpen
/// \sa SDL_HapticRumblePlay
/// \sa SDL_HapticRumbleStop
/// \sa SDL_HapticRumbleSupported
/// 
/// 
pub const HapticRumbleInit = SDL_HapticRumbleInit;
extern fn SDL_HapticRumbleInit(
    haptic: ?*SDL_Haptic,
) c_int;

/// 
/// Run a simple rumble effect on a haptic device.
/// 
/// \param haptic the haptic device to play the rumble effect on
/// \param strength strength of the rumble to play as a 0-1 float value
/// \param length length of the rumble to play in milliseconds
/// \returns 0 on success or a negative error code on failure; call
///          SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_HapticRumbleInit
/// \sa SDL_HapticRumbleStop
/// \sa SDL_HapticRumbleSupported
/// 
/// 
pub const HapticRumblePlay = SDL_HapticRumblePlay;
extern fn SDL_HapticRumblePlay(
    haptic: ?*SDL_Haptic,
    strength: f32,
    length: u32,
) c_int;

/// 
/// Stop the simple rumble on a haptic device.
/// 
/// \param haptic the haptic device to stop the rumble effect on
/// \returns 0 on success or a negative error code on failure; call
///          SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_HapticRumbleInit
/// \sa SDL_HapticRumblePlay
/// \sa SDL_HapticRumbleSupported
/// 
/// 
pub const HapticRumbleStop = SDL_HapticRumbleStop;
extern fn SDL_HapticRumbleStop(
    haptic: ?*SDL_Haptic,
) c_int;

/// 
/// Use this function to create a new SDL_RWops structure for reading from
/// and/or writing to a named file.
/// 
/// The `mode` string is treated roughly the same as in a call to the C
/// library's fopen(), even if SDL doesn't happen to use fopen() behind the
/// scenes.
/// 
/// Available `mode` strings:
/// 
/// - "r": Open a file for reading. The file must exist.
/// - "w": Create an empty file for writing. If a file with the same name
///   already exists its content is erased and the file is treated as a new
///   empty file.
/// - "a": Append to a file. Writing operations append data at the end of the
///   file. The file is created if it does not exist.
/// - "r+": Open a file for update both reading and writing. The file must
///   exist.
/// - "w+": Create an empty file for both reading and writing. If a file with
///   the same name already exists its content is erased and the file is
///   treated as a new empty file.
/// - "a+": Open a file for reading and appending. All writing operations are
///   performed at the end of the file, protecting the previous content to be
///   overwritten. You can reposition (fseek, rewind) the internal pointer to
///   anywhere in the file for reading, but writing operations will move it
///   back to the end of file. The file is created if it does not exist.
/// 
/// **NOTE**: In order to open a file as a binary file, a "b" character has to
/// be included in the `mode` string. This additional "b" character can either
/// be appended at the end of the string (thus making the following compound
/// modes: "rb", "wb", "ab", "r+b", "w+b", "a+b") or be inserted between the
/// letter and the "+" sign for the mixed modes ("rb+", "wb+", "ab+").
/// Additional characters may follow the sequence, although they should have no
/// effect. For example, "t" is sometimes appended to make explicit the file is
/// a text file.
/// 
/// This function supports Unicode filenames, but they must be encoded in UTF-8
/// format, regardless of the underlying operating system.
/// 
/// As a fallback, SDL_RWFromFile() will transparently open a matching filename
/// in an Android app's `assets`.
/// 
/// Closing the SDL_RWops will close the file handle SDL is holding internally.
/// 
/// \param file a UTF-8 string representing the filename to open
/// \param mode an ASCII string representing the mode to be used for opening
///             the file.
/// \returns a pointer to the SDL_RWops structure that is created, or NULL on
///          failure; call SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_RWclose
/// \sa SDL_RWFromConstMem
/// \sa SDL_RWFromMem
/// \sa SDL_RWread
/// \sa SDL_RWseek
/// \sa SDL_RWtell
/// \sa SDL_RWwrite
/// 
/// 
pub const RWFromFile = SDL_RWFromFile;
extern fn SDL_RWFromFile(
    file: ?[*:0]const u8,
    mode: ?[*:0]const u8,
) ?*SDL_RWops;

/// 
/// Use this function to prepare a read-write memory buffer for use with
/// SDL_RWops.
/// 
/// This function sets up an SDL_RWops struct based on a memory area of a
/// certain size, for both read and write access.
/// 
/// This memory buffer is not copied by the RWops; the pointer you provide must
/// remain valid until you close the stream. Closing the stream will not free
/// the original buffer.
/// 
/// If you need to make sure the RWops never writes to the memory buffer, you
/// should use SDL_RWFromConstMem() with a read-only buffer of memory instead.
/// 
/// \param mem a pointer to a buffer to feed an SDL_RWops stream
/// \param size the buffer size, in bytes
/// \returns a pointer to a new SDL_RWops structure, or NULL if it fails; call
///          SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_RWclose
/// \sa SDL_RWFromConstMem
/// \sa SDL_RWFromFile
/// \sa SDL_RWFromMem
/// \sa SDL_RWread
/// \sa SDL_RWseek
/// \sa SDL_RWtell
/// \sa SDL_RWwrite
/// 
/// 
pub const RWFromMem = SDL_RWFromMem;
extern fn SDL_RWFromMem(
    mem: ?*anyopaque,
    size: c_int,
) ?*SDL_RWops;

/// 
/// Use this function to prepare a read-only memory buffer for use with RWops.
/// 
/// This function sets up an SDL_RWops struct based on a memory area of a
/// certain size. It assumes the memory area is not writable.
/// 
/// Attempting to write to this RWops stream will report an error without
/// writing to the memory buffer.
/// 
/// This memory buffer is not copied by the RWops; the pointer you provide must
/// remain valid until you close the stream. Closing the stream will not free
/// the original buffer.
/// 
/// If you need to write to a memory buffer, you should use SDL_RWFromMem()
/// with a writable buffer of memory instead.
/// 
/// \param mem a pointer to a read-only buffer to feed an SDL_RWops stream
/// \param size the buffer size, in bytes
/// \returns a pointer to a new SDL_RWops structure, or NULL if it fails; call
///          SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_RWclose
/// \sa SDL_RWFromConstMem
/// \sa SDL_RWFromFile
/// \sa SDL_RWFromMem
/// \sa SDL_RWread
/// \sa SDL_RWseek
/// \sa SDL_RWtell
/// 
/// 
pub const RWFromConstMem = SDL_RWFromConstMem;
extern fn SDL_RWFromConstMem(
    mem: ?*const anyopaque,
    size: c_int,
) ?*SDL_RWops;

/// 
/// Use this function to allocate an empty, unpopulated SDL_RWops structure.
/// 
/// Applications do not need to use this function unless they are providing
/// their own SDL_RWops implementation. If you just need a SDL_RWops to
/// read/write a common data source, you should use the built-in
/// implementations in SDL, like SDL_RWFromFile() or SDL_RWFromMem(), etc.
/// 
/// You must free the returned pointer with SDL_DestroyRW(). Depending on your
/// operating system and compiler, there may be a difference between the
/// malloc() and free() your program uses and the versions SDL calls
/// internally. Trying to mix the two can cause crashing such as segmentation
/// faults. Since all SDL_RWops must free themselves when their **close**
/// method is called, all SDL_RWops must be allocated through this function, so
/// they can all be freed correctly with SDL_DestroyRW().
/// 
/// \returns a pointer to the allocated memory on success, or NULL on failure;
///          call SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_DestroyRW
/// 
/// 
pub const CreateRW = SDL_CreateRW;
extern fn SDL_CreateRW() ?*SDL_RWops;

/// 
/// Use this function to free an SDL_RWops structure allocated by
/// SDL_CreateRW().
/// 
/// Applications do not need to use this function unless they are providing
/// their own SDL_RWops implementation. If you just need a SDL_RWops to
/// read/write a common data source, you should use the built-in
/// implementations in SDL, like SDL_RWFromFile() or SDL_RWFromMem(), etc, and
/// call the **close** method on those SDL_RWops pointers when you are done
/// with them.
/// 
/// Only use SDL_DestroyRW() on pointers returned by SDL_CreateRW(). The pointer is
/// invalid as soon as this function returns. Any extra memory allocated during
/// creation of the SDL_RWops is not freed by SDL_DestroyRW(); the programmer must
/// be responsible for managing that memory in their **close** method.
/// 
/// \param area the SDL_RWops structure to be freed
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_CreateRW
/// 
/// 
pub const DestroyRW = SDL_DestroyRW;
extern fn SDL_DestroyRW(
    area: ?*SDL_RWops,
) void;

/// 
/// Use this function to get the size of the data stream in an SDL_RWops.
/// 
/// Prior to SDL 2.0.10, this function was a macro.
/// 
/// \param context the SDL_RWops to get the size of the data stream from
/// \returns the size of the data stream in the SDL_RWops on success, -1 if
///          unknown or a negative error code on failure; call SDL_GetError()
///          for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const RWsize = SDL_RWsize;
extern fn SDL_RWsize(
    context: ?*SDL_RWops,
) i64;

/// 
/// Seek within an SDL_RWops data stream.
/// 
/// This function seeks to byte `offset`, relative to `whence`.
/// 
/// `whence` may be any of the following values:
/// 
/// - `SDL_RW_SEEK_SET`: seek from the beginning of data
/// - `SDL_RW_SEEK_CUR`: seek relative to current read point
/// - `SDL_RW_SEEK_END`: seek relative to the end of data
/// 
/// If this stream can not seek, it will return -1.
/// 
/// SDL_RWseek() is actually a wrapper function that calls the SDL_RWops's
/// `seek` method appropriately, to simplify application development.
/// 
/// Prior to SDL 2.0.10, this function was a macro.
/// 
/// \param context a pointer to an SDL_RWops structure
/// \param offset an offset in bytes, relative to **whence** location; can be
///               negative
/// \param whence any of `SDL_RW_SEEK_SET`, `SDL_RW_SEEK_CUR`, `SDL_RW_SEEK_END`
/// \returns the final offset in the data stream after the seek or -1 on error.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_RWclose
/// \sa SDL_RWFromConstMem
/// \sa SDL_RWFromFile
/// \sa SDL_RWFromMem
/// \sa SDL_RWread
/// \sa SDL_RWtell
/// \sa SDL_RWwrite
/// 
/// 
pub const RWseek = SDL_RWseek;
extern fn SDL_RWseek(
    context: ?*SDL_RWops,
    offset: i64,
    whence: c_int,
) i64;

/// 
/// Determine the current read/write offset in an SDL_RWops data stream.
/// 
/// SDL_RWtell is actually a wrapper function that calls the SDL_RWops's `seek`
/// method, with an offset of 0 bytes from `SDL_RW_SEEK_CUR`, to simplify
/// application development.
/// 
/// Prior to SDL 2.0.10, this function was a macro.
/// 
/// \param context a SDL_RWops data stream object from which to get the current
///                offset
/// \returns the current offset in the stream, or -1 if the information can not
///          be determined.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_RWclose
/// \sa SDL_RWFromConstMem
/// \sa SDL_RWFromFile
/// \sa SDL_RWFromMem
/// \sa SDL_RWread
/// \sa SDL_RWseek
/// \sa SDL_RWwrite
/// 
/// 
pub const RWtell = SDL_RWtell;
extern fn SDL_RWtell(
    context: ?*SDL_RWops,
) i64;

/// 
/// Read from a data source.
/// 
/// This function reads up `size` bytes from the data source to the area
/// pointed at by `ptr`. This function may read less bytes than requested.
/// It will return zero when the data stream is completely read, or
/// -1 on error. For streams that support non-blocking
/// operation, if nothing was read because it would require blocking,
/// this function returns -2 to distinguish that this is not an error or
/// end-of-file, and the caller can try again later.
/// 
/// SDL_RWread() is actually a function wrapper that calls the SDL_RWops's
/// `read` method appropriately, to simplify application development.
/// 
/// It is an error to specify a negative `size`, but this parameter is
/// signed so you definitely cannot overflow the return value on a
/// successful run with enormous amounts of data.
/// 
/// \param context a pointer to an SDL_RWops structure
/// \param ptr a pointer to a buffer to read data into
/// \param size the number of bytes to read from the data source.
/// \returns the number of bytes read, 0 at end of file, -1 on error, and -2 for data not ready with a non-blocking context.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_RWclose
/// \sa SDL_RWFromConstMem
/// \sa SDL_RWFromFile
/// \sa SDL_RWFromMem
/// \sa SDL_RWseek
/// \sa SDL_RWwrite
/// 
/// 
pub const RWread = SDL_RWread;
extern fn SDL_RWread(
    context: ?*SDL_RWops,
    ptr: ?*anyopaque,
    size: i64,
) i64;

/// 
/// Write to an SDL_RWops data stream.
/// 
/// This function writes exactly `size` bytes from the area pointed at by
/// `ptr` to the stream. If this fails for any reason, it'll return less
/// than `size` to demonstrate how far the write progressed. On success,
/// it returns `num`.
/// 
/// On error, this function still attempts to write as much as possible,
/// so it might return a positive value less than the requested write
/// size. If the function failed to write anything and there was an
/// actual error, it will return -1. For streams that support non-blocking
/// operation, if nothing was written because it would require blocking,
/// this function returns -2 to distinguish that this is not an error and
/// the caller can try again later.
/// 
/// SDL_RWwrite is actually a function wrapper that calls the SDL_RWops's
/// `write` method appropriately, to simplify application development.
/// 
/// It is an error to specify a negative `size`, but this parameter is
/// signed so you definitely cannot overflow the return value on a
/// successful run with enormous amounts of data.
/// 
/// \param context a pointer to an SDL_RWops structure
/// \param ptr a pointer to a buffer containing data to write
/// \param size the number of bytes to write
/// \returns the number of bytes written, which will be less than `num` on
///          error; call SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_RWclose
/// \sa SDL_RWFromConstMem
/// \sa SDL_RWFromFile
/// \sa SDL_RWFromMem
/// \sa SDL_RWread
/// \sa SDL_RWseek
/// 
/// 
pub const RWwrite = SDL_RWwrite;
extern fn SDL_RWwrite(
    context: ?*SDL_RWops,
    ptr: ?*const anyopaque,
    size: i64,
) i64;

/// 
/// Close and free an allocated SDL_RWops structure.
/// 
/// SDL_RWclose() closes and cleans up the SDL_RWops stream. It releases any
/// resources used by the stream and frees the SDL_RWops itself with
/// SDL_DestroyRW(). This returns 0 on success, or -1 if the stream failed to
/// flush to its output (e.g. to disk).
/// 
/// Note that if this fails to flush the stream to disk, this function reports
/// an error, but the SDL_RWops is still invalid once this function returns.
/// 
/// Prior to SDL 2.0.10, this function was a macro.
/// 
/// \param context SDL_RWops structure to close
/// \returns 0 on success or a negative error code on failure; call
///          SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_RWFromConstMem
/// \sa SDL_RWFromFile
/// \sa SDL_RWFromMem
/// \sa SDL_RWread
/// \sa SDL_RWseek
/// \sa SDL_RWwrite
/// 
/// 
pub const RWclose = SDL_RWclose;
extern fn SDL_RWclose(
    context: ?*SDL_RWops,
) c_int;

/// 
/// Load all the data from an SDL data stream.
/// 
/// The data is allocated with a zero byte at the end (null terminated) for
/// convenience. This extra byte is not included in the value reported via
/// `datasize`.
/// 
/// The data should be freed with SDL_free().
/// 
/// \param src the SDL_RWops to read all available data from
/// \param datasize if not NULL, will store the number of bytes read
/// \param freesrc if non-zero, calls SDL_RWclose() on `src` before returning
/// \returns the data, or NULL if there was an error.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const LoadFile_RW = SDL_LoadFile_RW;
extern fn SDL_LoadFile_RW(
    src: ?*SDL_RWops,
    datasize: *usize,
    freesrc: c_int,
) ?*anyopaque;

/// 
/// Load all the data from a file path.
/// 
/// The data is allocated with a zero byte at the end (null terminated) for
/// convenience. This extra byte is not included in the value reported via
/// `datasize`.
/// 
/// The data should be freed with SDL_free().
/// 
/// Prior to SDL 2.0.10, this function was a macro wrapping around
/// SDL_LoadFile_RW.
/// 
/// \param file the path to read all available data from
/// \param datasize if not NULL, will store the number of bytes read
/// \returns the data, or NULL if there was an error.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const LoadFile = SDL_LoadFile;
extern fn SDL_LoadFile(
    file: ?[*:0]const u8,
    datasize: *usize,
) ?*anyopaque;

/// 
/// Use this function to read a byte from an SDL_RWops.
/// 
/// \param src the SDL_RWops to read from
/// \returns the read byte on success or 0 on failure; call SDL_GetError() for
///          more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_WriteU8
/// 
/// 
pub const ReadU8 = SDL_ReadU8;
extern fn SDL_ReadU8(
    src: ?*SDL_RWops,
) u8;

/// 
/// Use this function to read 16 bits of little-endian data from an SDL_RWops
/// and return in native format.
/// 
/// SDL byteswaps the data only if necessary, so the data returned will be in
/// the native byte order.
/// 
/// \param src the stream from which to read data
/// \returns 16 bits of data in the native byte order of the platform.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_ReadBE16
/// 
/// 
pub const ReadLE16 = SDL_ReadLE16;
extern fn SDL_ReadLE16(
    src: ?*SDL_RWops,
) u16;

/// 
/// Use this function to read 16 bits of big-endian data from an SDL_RWops and
/// return in native format.
/// 
/// SDL byteswaps the data only if necessary, so the data returned will be in
/// the native byte order.
/// 
/// \param src the stream from which to read data
/// \returns 16 bits of data in the native byte order of the platform.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_ReadLE16
/// 
/// 
pub const ReadBE16 = SDL_ReadBE16;
extern fn SDL_ReadBE16(
    src: ?*SDL_RWops,
) u16;

/// 
/// Use this function to read 32 bits of little-endian data from an SDL_RWops
/// and return in native format.
/// 
/// SDL byteswaps the data only if necessary, so the data returned will be in
/// the native byte order.
/// 
/// \param src the stream from which to read data
/// \returns 32 bits of data in the native byte order of the platform.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_ReadBE32
/// 
/// 
pub const ReadLE32 = SDL_ReadLE32;
extern fn SDL_ReadLE32(
    src: ?*SDL_RWops,
) u32;

/// 
/// Use this function to read 32 bits of big-endian data from an SDL_RWops and
/// return in native format.
/// 
/// SDL byteswaps the data only if necessary, so the data returned will be in
/// the native byte order.
/// 
/// \param src the stream from which to read data
/// \returns 32 bits of data in the native byte order of the platform.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_ReadLE32
/// 
/// 
pub const ReadBE32 = SDL_ReadBE32;
extern fn SDL_ReadBE32(
    src: ?*SDL_RWops,
) u32;

/// 
/// Use this function to read 64 bits of little-endian data from an SDL_RWops
/// and return in native format.
/// 
/// SDL byteswaps the data only if necessary, so the data returned will be in
/// the native byte order.
/// 
/// \param src the stream from which to read data
/// \returns 64 bits of data in the native byte order of the platform.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_ReadBE64
/// 
/// 
pub const ReadLE64 = SDL_ReadLE64;
extern fn SDL_ReadLE64(
    src: ?*SDL_RWops,
) u64;

/// 
/// Use this function to read 64 bits of big-endian data from an SDL_RWops and
/// return in native format.
/// 
/// SDL byteswaps the data only if necessary, so the data returned will be in
/// the native byte order.
/// 
/// \param src the stream from which to read data
/// \returns 64 bits of data in the native byte order of the platform.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_ReadLE64
/// 
/// 
pub const ReadBE64 = SDL_ReadBE64;
extern fn SDL_ReadBE64(
    src: ?*SDL_RWops,
) u64;

/// 
/// Use this function to write a byte to an SDL_RWops.
/// 
/// \param dst the SDL_RWops to write to
/// \param value the byte value to write
/// \returns 1 on success or 0 on failure; call SDL_GetError() for more
///          information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_ReadU8
/// 
/// 
pub const WriteU8 = SDL_WriteU8;
extern fn SDL_WriteU8(
    dst: ?*SDL_RWops,
    value: u8,
) usize;

/// 
/// Use this function to write 16 bits in native format to a SDL_RWops as
/// little-endian data.
/// 
/// SDL byteswaps the data only if necessary, so the application always
/// specifies native format, and the data written will be in little-endian
/// format.
/// 
/// \param dst the stream to which data will be written
/// \param value the data to be written, in native format
/// \returns 1 on successful write, 0 on error.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_WriteBE16
/// 
/// 
pub const WriteLE16 = SDL_WriteLE16;
extern fn SDL_WriteLE16(
    dst: ?*SDL_RWops,
    value: u16,
) usize;

/// 
/// Use this function to write 16 bits in native format to a SDL_RWops as
/// big-endian data.
/// 
/// SDL byteswaps the data only if necessary, so the application always
/// specifies native format, and the data written will be in big-endian format.
/// 
/// \param dst the stream to which data will be written
/// \param value the data to be written, in native format
/// \returns 1 on successful write, 0 on error.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_WriteLE16
/// 
/// 
pub const WriteBE16 = SDL_WriteBE16;
extern fn SDL_WriteBE16(
    dst: ?*SDL_RWops,
    value: u16,
) usize;

/// 
/// Use this function to write 32 bits in native format to a SDL_RWops as
/// little-endian data.
/// 
/// SDL byteswaps the data only if necessary, so the application always
/// specifies native format, and the data written will be in little-endian
/// format.
/// 
/// \param dst the stream to which data will be written
/// \param value the data to be written, in native format
/// \returns 1 on successful write, 0 on error.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_WriteBE32
/// 
/// 
pub const WriteLE32 = SDL_WriteLE32;
extern fn SDL_WriteLE32(
    dst: ?*SDL_RWops,
    value: u32,
) usize;

/// 
/// Use this function to write 32 bits in native format to a SDL_RWops as
/// big-endian data.
/// 
/// SDL byteswaps the data only if necessary, so the application always
/// specifies native format, and the data written will be in big-endian format.
/// 
/// \param dst the stream to which data will be written
/// \param value the data to be written, in native format
/// \returns 1 on successful write, 0 on error.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_WriteLE32
/// 
/// 
pub const WriteBE32 = SDL_WriteBE32;
extern fn SDL_WriteBE32(
    dst: ?*SDL_RWops,
    value: u32,
) usize;

/// 
/// Use this function to write 64 bits in native format to a SDL_RWops as
/// little-endian data.
/// 
/// SDL byteswaps the data only if necessary, so the application always
/// specifies native format, and the data written will be in little-endian
/// format.
/// 
/// \param dst the stream to which data will be written
/// \param value the data to be written, in native format
/// \returns 1 on successful write, 0 on error.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_WriteBE64
/// 
/// 
pub const WriteLE64 = SDL_WriteLE64;
extern fn SDL_WriteLE64(
    dst: ?*SDL_RWops,
    value: u64,
) usize;

/// 
/// Use this function to write 64 bits in native format to a SDL_RWops as
/// big-endian data.
/// 
/// SDL byteswaps the data only if necessary, so the application always
/// specifies native format, and the data written will be in big-endian format.
/// 
/// \param dst the stream to which data will be written
/// \param value the data to be written, in native format
/// \returns 1 on successful write, 0 on error.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_WriteLE64
/// 
/// 
pub const WriteBE64 = SDL_WriteBE64;
extern fn SDL_WriteBE64(
    dst: ?*SDL_RWops,
    value: u64,
) usize;

/// 
/// Get the current power supply details.
/// 
/// You should never take a battery status as absolute truth. Batteries
/// (especially failing batteries) are delicate hardware, and the values
/// reported here are best estimates based on what that hardware reports. It's
/// not uncommon for older batteries to lose stored power much faster than it
/// reports, or completely drain when reporting it has 20 percent left, etc.
/// 
/// Battery status can change at any time; if you are concerned with power
/// state, you should call this function frequently, and perhaps ignore changes
/// until they seem to be stable for a few seconds.
/// 
/// It's possible a platform can only report battery percentage or time left
/// but not both.
/// 
/// \param seconds seconds of battery life left, you can pass a NULL here if you
///             don't care, will return -1 if we can't determine a value, or
///             we're not running on a battery
/// \param percent percentage of battery life left, between 0 and 100, you can pass
///            a NULL here if you don't care, will return -1 if we can't
///            determine a value, or we're not running on a battery
/// \returns an SDL_PowerState enum representing the current battery state.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const GetPowerInfo = SDL_GetPowerInfo;
extern fn SDL_GetPowerInfo(
    seconds: *c_int,
    percent: *c_int,
) SDL_PowerState;

/// 
/// Get the number of CPU cores available.
/// 
/// \returns the total number of logical CPU cores. On CPUs that include
///          technologies such as hyperthreading, the number of logical cores
///          may be more than the number of physical cores.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const GetCPUCount = SDL_GetCPUCount;
extern fn SDL_GetCPUCount() c_int;

/// 
/// Determine the L1 cache line size of the CPU.
/// 
/// This is useful for determining multi-threaded structure padding or SIMD
/// prefetch sizes.
/// 
/// \returns the L1 cache line size of the CPU, in bytes.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const GetCPUCacheLineSize = SDL_GetCPUCacheLineSize;
extern fn SDL_GetCPUCacheLineSize() c_int;

/// 
/// Determine whether the CPU has the RDTSC instruction.
/// 
/// This always returns false on CPUs that aren't using Intel instruction sets.
/// 
/// \returns SDL_TRUE if the CPU has the RDTSC instruction or SDL_FALSE if not.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_HasAltiVec
/// \sa SDL_HasAVX
/// \sa SDL_HasAVX2
/// \sa SDL_HasMMX
/// \sa SDL_HasSSE
/// \sa SDL_HasSSE2
/// \sa SDL_HasSSE3
/// \sa SDL_HasSSE41
/// \sa SDL_HasSSE42
/// 
/// 
pub const HasRDTSC = SDL_HasRDTSC;
extern fn SDL_HasRDTSC() bool;

/// 
/// Determine whether the CPU has AltiVec features.
/// 
/// This always returns false on CPUs that aren't using PowerPC instruction
/// sets.
/// 
/// \returns SDL_TRUE if the CPU has AltiVec features or SDL_FALSE if not.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_HasAVX
/// \sa SDL_HasAVX2
/// \sa SDL_HasMMX
/// \sa SDL_HasRDTSC
/// \sa SDL_HasSSE
/// \sa SDL_HasSSE2
/// \sa SDL_HasSSE3
/// \sa SDL_HasSSE41
/// \sa SDL_HasSSE42
/// 
/// 
pub const HasAltiVec = SDL_HasAltiVec;
extern fn SDL_HasAltiVec() bool;

/// 
/// Determine whether the CPU has MMX features.
/// 
/// This always returns false on CPUs that aren't using Intel instruction sets.
/// 
/// \returns SDL_TRUE if the CPU has MMX features or SDL_FALSE if not.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_HasAltiVec
/// \sa SDL_HasAVX
/// \sa SDL_HasAVX2
/// \sa SDL_HasRDTSC
/// \sa SDL_HasSSE
/// \sa SDL_HasSSE2
/// \sa SDL_HasSSE3
/// \sa SDL_HasSSE41
/// \sa SDL_HasSSE42
/// 
/// 
pub const HasMMX = SDL_HasMMX;
extern fn SDL_HasMMX() bool;

/// 
/// Determine whether the CPU has SSE features.
/// 
/// This always returns false on CPUs that aren't using Intel instruction sets.
/// 
/// \returns SDL_TRUE if the CPU has SSE features or SDL_FALSE if not.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_HasAltiVec
/// \sa SDL_HasAVX
/// \sa SDL_HasAVX2
/// \sa SDL_HasMMX
/// \sa SDL_HasRDTSC
/// \sa SDL_HasSSE2
/// \sa SDL_HasSSE3
/// \sa SDL_HasSSE41
/// \sa SDL_HasSSE42
/// 
/// 
pub const HasSSE = SDL_HasSSE;
extern fn SDL_HasSSE() bool;

/// 
/// Determine whether the CPU has SSE2 features.
/// 
/// This always returns false on CPUs that aren't using Intel instruction sets.
/// 
/// \returns SDL_TRUE if the CPU has SSE2 features or SDL_FALSE if not.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_HasAltiVec
/// \sa SDL_HasAVX
/// \sa SDL_HasAVX2
/// \sa SDL_HasMMX
/// \sa SDL_HasRDTSC
/// \sa SDL_HasSSE
/// \sa SDL_HasSSE3
/// \sa SDL_HasSSE41
/// \sa SDL_HasSSE42
/// 
/// 
pub const HasSSE2 = SDL_HasSSE2;
extern fn SDL_HasSSE2() bool;

/// 
/// Determine whether the CPU has SSE3 features.
/// 
/// This always returns false on CPUs that aren't using Intel instruction sets.
/// 
/// \returns SDL_TRUE if the CPU has SSE3 features or SDL_FALSE if not.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_HasAltiVec
/// \sa SDL_HasAVX
/// \sa SDL_HasAVX2
/// \sa SDL_HasMMX
/// \sa SDL_HasRDTSC
/// \sa SDL_HasSSE
/// \sa SDL_HasSSE2
/// \sa SDL_HasSSE41
/// \sa SDL_HasSSE42
/// 
/// 
pub const HasSSE3 = SDL_HasSSE3;
extern fn SDL_HasSSE3() bool;

/// 
/// Determine whether the CPU has SSE4.1 features.
/// 
/// This always returns false on CPUs that aren't using Intel instruction sets.
/// 
/// \returns SDL_TRUE if the CPU has SSE4.1 features or SDL_FALSE if not.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_HasAltiVec
/// \sa SDL_HasAVX
/// \sa SDL_HasAVX2
/// \sa SDL_HasMMX
/// \sa SDL_HasRDTSC
/// \sa SDL_HasSSE
/// \sa SDL_HasSSE2
/// \sa SDL_HasSSE3
/// \sa SDL_HasSSE42
/// 
/// 
pub const HasSSE41 = SDL_HasSSE41;
extern fn SDL_HasSSE41() bool;

/// 
/// Determine whether the CPU has SSE4.2 features.
/// 
/// This always returns false on CPUs that aren't using Intel instruction sets.
/// 
/// \returns SDL_TRUE if the CPU has SSE4.2 features or SDL_FALSE if not.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_HasAltiVec
/// \sa SDL_HasAVX
/// \sa SDL_HasAVX2
/// \sa SDL_HasMMX
/// \sa SDL_HasRDTSC
/// \sa SDL_HasSSE
/// \sa SDL_HasSSE2
/// \sa SDL_HasSSE3
/// \sa SDL_HasSSE41
/// 
/// 
pub const HasSSE42 = SDL_HasSSE42;
extern fn SDL_HasSSE42() bool;

/// 
/// Determine whether the CPU has AVX features.
/// 
/// This always returns false on CPUs that aren't using Intel instruction sets.
/// 
/// \returns SDL_TRUE if the CPU has AVX features or SDL_FALSE if not.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_HasAltiVec
/// \sa SDL_HasAVX2
/// \sa SDL_HasMMX
/// \sa SDL_HasRDTSC
/// \sa SDL_HasSSE
/// \sa SDL_HasSSE2
/// \sa SDL_HasSSE3
/// \sa SDL_HasSSE41
/// \sa SDL_HasSSE42
/// 
/// 
pub const HasAVX = SDL_HasAVX;
extern fn SDL_HasAVX() bool;

/// 
/// Determine whether the CPU has AVX2 features.
/// 
/// This always returns false on CPUs that aren't using Intel instruction sets.
/// 
/// \returns SDL_TRUE if the CPU has AVX2 features or SDL_FALSE if not.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_HasAltiVec
/// \sa SDL_HasAVX
/// \sa SDL_HasMMX
/// \sa SDL_HasRDTSC
/// \sa SDL_HasSSE
/// \sa SDL_HasSSE2
/// \sa SDL_HasSSE3
/// \sa SDL_HasSSE41
/// \sa SDL_HasSSE42
/// 
/// 
pub const HasAVX2 = SDL_HasAVX2;
extern fn SDL_HasAVX2() bool;

/// 
/// Determine whether the CPU has AVX-512F (foundation) features.
/// 
/// This always returns false on CPUs that aren't using Intel instruction sets.
/// 
/// \returns SDL_TRUE if the CPU has AVX-512F features or SDL_FALSE if not.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_HasAVX
/// 
/// 
pub const HasAVX512F = SDL_HasAVX512F;
extern fn SDL_HasAVX512F() bool;

/// 
/// Determine whether the CPU has ARM SIMD (ARMv6) features.
/// 
/// This is different from ARM NEON, which is a different instruction set.
/// 
/// This always returns false on CPUs that aren't using ARM instruction sets.
/// 
/// \returns SDL_TRUE if the CPU has ARM SIMD features or SDL_FALSE if not.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_HasNEON
/// 
/// 
pub const HasARMSIMD = SDL_HasARMSIMD;
extern fn SDL_HasARMSIMD() bool;

/// 
/// Determine whether the CPU has NEON (ARM SIMD) features.
/// 
/// This always returns false on CPUs that aren't using ARM instruction sets.
/// 
/// \returns SDL_TRUE if the CPU has ARM NEON features or SDL_FALSE if not.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const HasNEON = SDL_HasNEON;
extern fn SDL_HasNEON() bool;

/// 
/// Determine whether the CPU has LSX (LOONGARCH SIMD) features.
/// 
/// This always returns false on CPUs that aren't using LOONGARCH instruction
/// sets.
/// 
/// \returns SDL_TRUE if the CPU has LOONGARCH LSX features or SDL_FALSE if
///          not.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const HasLSX = SDL_HasLSX;
extern fn SDL_HasLSX() bool;

/// 
/// Determine whether the CPU has LASX (LOONGARCH SIMD) features.
/// 
/// This always returns false on CPUs that aren't using LOONGARCH instruction
/// sets.
/// 
/// \returns SDL_TRUE if the CPU has LOONGARCH LASX features or SDL_FALSE if
///          not.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const HasLASX = SDL_HasLASX;
extern fn SDL_HasLASX() bool;

/// 
/// Get the amount of RAM configured in the system.
/// 
/// \returns the amount of RAM configured in the system in MiB.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const GetSystemRAM = SDL_GetSystemRAM;
extern fn SDL_GetSystemRAM() c_int;

/// 
/// Report the alignment this system needs for SIMD allocations.
/// 
/// This will return the minimum number of bytes to which a pointer must be
/// aligned to be compatible with SIMD instructions on the current machine. For
/// example, if the machine supports SSE only, it will return 16, but if it
/// supports AVX-512F, it'll return 64 (etc). This only reports values for
/// instruction sets SDL knows about, so if your SDL build doesn't have
/// SDL_HasAVX512F(), then it might return 16 for the SSE support it sees and
/// not 64 for the AVX-512 instructions that exist but SDL doesn't know about.
/// Plan accordingly.
/// 
/// \returns the alignment in bytes needed for available, known SIMD
///          instructions.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_aligned_alloc
/// \sa SDL_aligned_free
/// 
/// 
pub const SIMDGetAlignment = SDL_SIMDGetAlignment;
extern fn SDL_SIMDGetAlignment() usize;

/// 
/// Create a new mutex.
/// 
/// All newly-created mutexes begin in the _unlocked_ state.
/// 
/// Calls to SDL_LockMutex() will not return while the mutex is locked by
/// another thread. See SDL_TryLockMutex() to attempt to lock without blocking.
/// 
/// SDL mutexes are reentrant.
/// 
/// \returns the initialized and unlocked mutex or NULL on failure; call
///          SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_DestroyMutex
/// \sa SDL_LockMutex
/// \sa SDL_TryLockMutex
/// \sa SDL_UnlockMutex
/// 
/// 
pub const CreateMutex = SDL_CreateMutex;
extern fn SDL_CreateMutex() ?*SDL_mutex;

/// 
/// Lock the mutex.
/// 
/// This will block until the mutex is available, which is to say it is in the
/// unlocked state and the OS has chosen the caller as the next thread to lock
/// it. Of all threads waiting to lock the mutex, only one may do so at a time.
/// 
/// It is legal for the owning thread to lock an already-locked mutex. It must
/// unlock it the same number of times before it is actually made available for
/// other threads in the system (this is known as a "recursive mutex").
/// 
/// \param mutex the mutex to lock
/// \return 0, or -1 on error.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const LockMutex = SDL_LockMutex;
extern fn SDL_LockMutex(
    mutex: ?*SDL_mutex,
) c_int;

/// 
/// Try to lock a mutex without blocking.
/// 
/// This works just like SDL_LockMutex(), but if the mutex is not available,
/// this function returns `SDL_MUTEX_TIMEOUT` immediately.
/// 
/// This technique is useful if you need exclusive access to a resource but
/// don't want to wait for it, and will return to it to try again later.
/// 
/// \param mutex the mutex to try to lock
/// \returns 0, `SDL_MUTEX_TIMEDOUT`, or -1 on error; call SDL_GetError() for
///          more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_CreateMutex
/// \sa SDL_DestroyMutex
/// \sa SDL_LockMutex
/// \sa SDL_UnlockMutex
/// 
/// 
pub const TryLockMutex = SDL_TryLockMutex;
extern fn SDL_TryLockMutex(
    mutex: ?*SDL_mutex,
) c_int;

/// 
/// Unlock the mutex.
/// 
/// It is legal for the owning thread to lock an already-locked mutex. It must
/// unlock it the same number of times before it is actually made available for
/// other threads in the system (this is known as a "recursive mutex").
/// 
/// It is an error to unlock a mutex that has not been locked by the current
/// thread, and doing so results in undefined behavior.
/// 
/// It is also an error to unlock a mutex that isn't locked at all.
/// 
/// \param mutex the mutex to unlock.
/// \returns 0, or -1 on error.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const UnlockMutex = SDL_UnlockMutex;
extern fn SDL_UnlockMutex(
    mutex: ?*SDL_mutex,
) c_int;

/// 
/// Destroy a mutex created with SDL_CreateMutex().
/// 
/// This function must be called on any mutex that is no longer needed. Failure
/// to destroy a mutex will result in a system memory or resource leak. While
/// it is safe to destroy a mutex that is _unlocked_, it is not safe to attempt
/// to destroy a locked mutex, and may result in undefined behavior depending
/// on the platform.
/// 
/// \param mutex the mutex to destroy
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_CreateMutex
/// \sa SDL_LockMutex
/// \sa SDL_TryLockMutex
/// \sa SDL_UnlockMutex
/// 
/// 
pub const DestroyMutex = SDL_DestroyMutex;
extern fn SDL_DestroyMutex(
    mutex: ?*SDL_mutex,
) void;

/// 
/// Create a semaphore.
/// 
/// This function creates a new semaphore and initializes it with the value
/// `initial_value`. Each wait operation on the semaphore will atomically
/// decrement the semaphore value and potentially block if the semaphore value
/// is 0. Each post operation will atomically increment the semaphore value and
/// wake waiting threads and allow them to retry the wait operation.
/// 
/// \param initial_value the starting value of the semaphore
/// \returns a new semaphore or NULL on failure; call SDL_GetError() for more
///          information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_DestroySemaphore
/// \sa SDL_SemPost
/// \sa SDL_SemTryWait
/// \sa SDL_SemValue
/// \sa SDL_SemWait
/// \sa SDL_SemWaitTimeout
/// 
/// 
pub const CreateSemaphore = SDL_CreateSemaphore;
extern fn SDL_CreateSemaphore(
    initial_value: u32,
) ?*SDL_sem;

/// 
/// Destroy a semaphore.
/// 
/// It is not safe to destroy a semaphore if there are threads currently
/// waiting on it.
/// 
/// \param sem the semaphore to destroy
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_CreateSemaphore
/// \sa SDL_SemPost
/// \sa SDL_SemTryWait
/// \sa SDL_SemValue
/// \sa SDL_SemWait
/// \sa SDL_SemWaitTimeout
/// 
/// 
pub const DestroySemaphore = SDL_DestroySemaphore;
extern fn SDL_DestroySemaphore(
    sem: ?*SDL_sem,
) void;

/// 
/// Wait until a semaphore has a positive value and then decrements it.
/// 
/// This function suspends the calling thread until either the semaphore
/// pointed to by `sem` has a positive value or the call is interrupted by a
/// signal or error. If the call is successful it will atomically decrement the
/// semaphore value.
/// 
/// This function is the equivalent of calling SDL_SemWaitTimeout() with a time
/// length of `SDL_MUTEX_MAXWAIT`.
/// 
/// \param sem the semaphore wait on
/// \returns 0 on success or a negative error code on failure; call
///          SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_CreateSemaphore
/// \sa SDL_DestroySemaphore
/// \sa SDL_SemPost
/// \sa SDL_SemTryWait
/// \sa SDL_SemValue
/// \sa SDL_SemWait
/// \sa SDL_SemWaitTimeout
/// 
/// 
pub const SemWait = SDL_SemWait;
extern fn SDL_SemWait(
    sem: ?*SDL_sem,
) c_int;

/// 
/// See if a semaphore has a positive value and decrement it if it does.
/// 
/// This function checks to see if the semaphore pointed to by `sem` has a
/// positive value and atomically decrements the semaphore value if it does. If
/// the semaphore doesn't have a positive value, the function immediately
/// returns SDL_MUTEX_TIMEDOUT.
/// 
/// \param sem the semaphore to wait on
/// \returns 0 if the wait succeeds, `SDL_MUTEX_TIMEDOUT` if the wait would
///          block, or a negative error code on failure; call SDL_GetError()
///          for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_CreateSemaphore
/// \sa SDL_DestroySemaphore
/// \sa SDL_SemPost
/// \sa SDL_SemValue
/// \sa SDL_SemWait
/// \sa SDL_SemWaitTimeout
/// 
/// 
pub const SemTryWait = SDL_SemTryWait;
extern fn SDL_SemTryWait(
    sem: ?*SDL_sem,
) c_int;

/// 
/// Wait until a semaphore has a positive value and then decrements it.
/// 
/// This function suspends the calling thread until either the semaphore
/// pointed to by `sem` has a positive value, the call is interrupted by a
/// signal or error, or the specified time has elapsed. If the call is
/// successful it will atomically decrement the semaphore value.
/// 
/// \param sem the semaphore to wait on
/// \param timeoutMS the length of the timeout, in milliseconds
/// \returns 0 if the wait succeeds, `SDL_MUTEX_TIMEDOUT` if the wait does not
///          succeed in the allotted time, or a negative error code on failure;
///          call SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_CreateSemaphore
/// \sa SDL_DestroySemaphore
/// \sa SDL_SemPost
/// \sa SDL_SemTryWait
/// \sa SDL_SemValue
/// \sa SDL_SemWait
/// 
/// 
pub const SemWaitTimeout = SDL_SemWaitTimeout;
extern fn SDL_SemWaitTimeout(
    sem: ?*SDL_sem,
    timeoutMS: i32,
) c_int;

/// 
/// Atomically increment a semaphore's value and wake waiting threads.
/// 
/// \param sem the semaphore to increment
/// \returns 0 on success or a negative error code on failure; call
///          SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_CreateSemaphore
/// \sa SDL_DestroySemaphore
/// \sa SDL_SemTryWait
/// \sa SDL_SemValue
/// \sa SDL_SemWait
/// \sa SDL_SemWaitTimeout
/// 
/// 
pub const SemPost = SDL_SemPost;
extern fn SDL_SemPost(
    sem: ?*SDL_sem,
) c_int;

/// 
/// Get the current value of a semaphore.
/// 
/// \param sem the semaphore to query
/// \returns the current value of the semaphore.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_CreateSemaphore
/// 
/// 
pub const SemValue = SDL_SemValue;
extern fn SDL_SemValue(
    sem: ?*SDL_sem,
) u32;

/// 
/// Create a condition variable.
/// 
/// \returns a new condition variable or NULL on failure; call SDL_GetError()
///          for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_CondBroadcast
/// \sa SDL_CondSignal
/// \sa SDL_CondWait
/// \sa SDL_CondWaitTimeout
/// \sa SDL_DestroyCond
/// 
/// 
pub const CreateCond = SDL_CreateCond;
extern fn SDL_CreateCond() ?*SDL_cond;

/// 
/// Destroy a condition variable.
/// 
/// \param cond the condition variable to destroy
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_CondBroadcast
/// \sa SDL_CondSignal
/// \sa SDL_CondWait
/// \sa SDL_CondWaitTimeout
/// \sa SDL_CreateCond
/// 
/// 
pub const DestroyCond = SDL_DestroyCond;
extern fn SDL_DestroyCond(
    cond: ?*SDL_cond,
) void;

/// 
/// Restart one of the threads that are waiting on the condition variable.
/// 
/// \param cond the condition variable to signal
/// \returns 0 on success or a negative error code on failure; call
///          SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_CondBroadcast
/// \sa SDL_CondWait
/// \sa SDL_CondWaitTimeout
/// \sa SDL_CreateCond
/// \sa SDL_DestroyCond
/// 
/// 
pub const CondSignal = SDL_CondSignal;
extern fn SDL_CondSignal(
    cond: ?*SDL_cond,
) c_int;

/// 
/// Restart all threads that are waiting on the condition variable.
/// 
/// \param cond the condition variable to signal
/// \returns 0 on success or a negative error code on failure; call
///          SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_CondSignal
/// \sa SDL_CondWait
/// \sa SDL_CondWaitTimeout
/// \sa SDL_CreateCond
/// \sa SDL_DestroyCond
/// 
/// 
pub const CondBroadcast = SDL_CondBroadcast;
extern fn SDL_CondBroadcast(
    cond: ?*SDL_cond,
) c_int;

/// 
/// Wait until a condition variable is signaled.
/// 
/// This function unlocks the specified `mutex` and waits for another thread to
/// call SDL_CondSignal() or SDL_CondBroadcast() on the condition variable
/// `cond`. Once the condition variable is signaled, the mutex is re-locked and
/// the function returns.
/// 
/// The mutex must be locked before calling this function. Locking the
/// mutex recursively (more than once) is not supported and leads to
/// undefined behavior.
/// 
/// This function is the equivalent of calling SDL_CondWaitTimeout() with a
/// time length of `SDL_MUTEX_MAXWAIT`.
/// 
/// \param cond the condition variable to wait on
/// \param mutex the mutex used to coordinate thread access
/// \returns 0 when it is signaled or a negative error code on failure; call
///          SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_CondBroadcast
/// \sa SDL_CondSignal
/// \sa SDL_CondWaitTimeout
/// \sa SDL_CreateCond
/// \sa SDL_DestroyCond
/// 
/// 
pub const CondWait = SDL_CondWait;
extern fn SDL_CondWait(
    cond: ?*SDL_cond,
    mutex: ?*SDL_mutex,
) c_int;

/// 
/// Wait until a condition variable is signaled or a certain time has passed.
/// 
/// This function unlocks the specified `mutex` and waits for another thread to
/// call SDL_CondSignal() or SDL_CondBroadcast() on the condition variable
/// `cond`, or for the specified time to elapse. Once the condition variable is
/// signaled or the time elapsed, the mutex is re-locked and the function
/// returns.
/// 
/// The mutex must be locked before calling this function. Locking the
/// mutex recursively (more than once) is not supported and leads to
/// undefined behavior.
/// 
/// \param cond the condition variable to wait on
/// \param mutex the mutex used to coordinate thread access
/// \param timeoutMS the maximum time to wait, in milliseconds, or `SDL_MUTEX_MAXWAIT`
///           to wait indefinitely
/// \returns 0 if the condition variable is signaled, `SDL_MUTEX_TIMEDOUT` if
///          the condition is not signaled in the allotted time, or a negative
///          error code on failure; call SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_CondBroadcast
/// \sa SDL_CondSignal
/// \sa SDL_CondWait
/// \sa SDL_CreateCond
/// \sa SDL_DestroyCond
/// 
/// 
pub const CondWaitTimeout = SDL_CondWaitTimeout;
extern fn SDL_CondWaitTimeout(
    cond: ?*SDL_cond,
    mutex: ?*SDL_mutex,
    timeoutMS: i32,
) c_int;

/// 
/// Use this function to get the number of built-in audio drivers.
/// 
/// This function returns a hardcoded number. This never returns a negative
/// value; if there are no drivers compiled into this build of SDL, this
/// function returns zero. The presence of a driver in this list does not mean
/// it will function, it just means SDL is capable of interacting with that
/// interface. For example, a build of SDL might have esound support, but if
/// there's no esound server available, SDL's esound driver would fail if used.
/// 
/// By default, SDL tries all drivers, in its preferred order, until one is
/// found to be usable.
/// 
/// \returns the number of built-in audio drivers.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_GetAudioDriver
/// 
/// 
pub const GetNumAudioDrivers = SDL_GetNumAudioDrivers;
extern fn SDL_GetNumAudioDrivers() c_int;

/// 
/// Use this function to get the name of a built in audio driver.
/// 
/// The list of audio drivers is given in the order that they are normally
/// initialized by default; the drivers that seem more reasonable to choose
/// first (as far as the SDL developers believe) are earlier in the list.
/// 
/// The names of drivers are all simple, low-ASCII identifiers, like "alsa",
/// "coreaudio" or "xaudio2". These never have Unicode characters, and are not
/// meant to be proper names.
/// 
/// \param index the index of the audio driver; the value ranges from 0 to
///              SDL_GetNumAudioDrivers() - 1
/// \returns the name of the audio driver at the requested index, or NULL if an
///          invalid index was specified.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_GetNumAudioDrivers
/// 
/// 
pub const GetAudioDriver = SDL_GetAudioDriver;
extern fn SDL_GetAudioDriver(
    index: c_int,
) ?[*:0]const u8;

/// 
/// Get the name of the current audio driver.
/// 
/// The returned string points to internal static memory and thus never becomes
/// invalid, even if you quit the audio subsystem and initialize a new driver
/// (although such a case would return a different static string from another
/// call to this function, of course). As such, you should not modify or free
/// the returned string.
/// 
/// \returns the name of the current audio driver or NULL if no driver has been
///          initialized.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const GetCurrentAudioDriver = SDL_GetCurrentAudioDriver;
extern fn SDL_GetCurrentAudioDriver() ?[*:0]const u8;

/// 
/// Get the number of built-in audio devices.
/// 
/// This function is only valid after successfully initializing the audio
/// subsystem.
/// 
/// Note that audio capture support is not implemented as of SDL 2.0.4, so the
/// `iscapture` parameter is for future expansion and should always be zero for
/// now.
/// 
/// This function will return -1 if an explicit list of devices can't be
/// determined. Returning -1 is not an error. For example, if SDL is set up to
/// talk to a remote audio server, it can't list every one available on the
/// Internet, but it will still allow a specific host to be specified in
/// SDL_OpenAudioDevice().
/// 
/// In many common cases, when this function returns a value <= 0, it can still
/// successfully open the default device (NULL for first argument of
/// SDL_OpenAudioDevice()).
/// 
/// This function may trigger a complete redetect of available hardware. It
/// should not be called for each iteration of a loop, but rather once at the
/// start of a loop:
/// 
/// ```c
/// // Don't do this:
/// for (int i = 0; i < SDL_GetNumAudioDevices(0); i++)
/// 
/// // do this instead:
/// const int count = SDL_GetNumAudioDevices(0);
/// for (int i = 0; i < count; ++i) { do_something_here(); }
/// ```
/// 
/// \param iscapture zero to request playback devices, non-zero to request
///                  recording devices
/// \returns the number of available devices exposed by the current driver or
///          -1 if an explicit list of devices can't be determined. A return
///          value of -1 does not necessarily mean an error condition.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_GetAudioDeviceName
/// \sa SDL_OpenAudioDevice
/// 
/// 
pub const GetNumAudioDevices = SDL_GetNumAudioDevices;
extern fn SDL_GetNumAudioDevices(
    iscapture: c_int,
) c_int;

/// 
/// Get the human-readable name of a specific audio device.
/// 
/// This function is only valid after successfully initializing the audio
/// subsystem. The values returned by this function reflect the latest call to
/// SDL_GetNumAudioDevices(); re-call that function to redetect available
/// hardware.
/// 
/// The string returned by this function is UTF-8 encoded, read-only, and
/// managed internally. You are not to free it. If you need to keep the string
/// for any length of time, you should make your own copy of it, as it will be
/// invalid next time any of several other SDL functions are called.
/// 
/// \param index the index of the audio device; valid values range from 0 to
///              SDL_GetNumAudioDevices() - 1
/// \param iscapture non-zero to query the list of recording devices, zero to
///                  query the list of output devices.
/// \returns the name of the audio device at the requested index, or NULL on
///          error.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_GetNumAudioDevices
/// \sa SDL_GetDefaultAudioInfo
/// 
/// 
pub const GetAudioDeviceName = SDL_GetAudioDeviceName;
extern fn SDL_GetAudioDeviceName(
    index: c_int,
    iscapture: c_int,
) ?[*:0]const u8;

/// 
/// Get the preferred audio format of a specific audio device.
/// 
/// This function is only valid after a successfully initializing the audio
/// subsystem. The values returned by this function reflect the latest call to
/// SDL_GetNumAudioDevices(); re-call that function to redetect available
/// hardware.
/// 
/// `spec` will be filled with the sample rate, sample format, and channel
/// count.
/// 
/// \param index the index of the audio device; valid values range from 0 to
///              SDL_GetNumAudioDevices() - 1
/// \param iscapture non-zero to query the list of recording devices, zero to
///                  query the list of output devices.
/// \param spec The SDL_AudioSpec to be initialized by this function.
/// \returns 0 on success, nonzero on error
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_GetNumAudioDevices
/// \sa SDL_GetDefaultAudioInfo
/// 
/// 
pub const GetAudioDeviceSpec = SDL_GetAudioDeviceSpec;
extern fn SDL_GetAudioDeviceSpec(
    index: c_int,
    iscapture: c_int,
    spec: ?*SDL_AudioSpec,
) c_int;

/// 
/// Get the name and preferred format of the default audio device.
/// 
/// Some (but not all!) platforms have an isolated mechanism to get information
/// about the "default" device. This can actually be a completely different
/// device that's not in the list you get from SDL_GetAudioDeviceSpec(). It can
/// even be a network address! (This is discussed in SDL_OpenAudioDevice().)
/// 
/// As a result, this call is not guaranteed to be performant, as it can query
/// the sound server directly every time, unlike the other query functions. You
/// should call this function sparingly!
/// 
/// `spec` will be filled with the sample rate, sample format, and channel
/// count, if a default device exists on the system. If `name` is provided,
/// will be filled with either a dynamically-allocated UTF-8 string or NULL.
/// 
/// \param name A pointer to be filled with the name of the default device (can
///             be NULL). Please call SDL_free() when you are done with this
///             pointer!
/// \param spec The SDL_AudioSpec to be initialized by this function.
/// \param iscapture non-zero to query the default recording device, zero to
///                  query the default output device.
/// \returns 0 on success, nonzero on error
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_GetAudioDeviceName
/// \sa SDL_GetAudioDeviceSpec
/// \sa SDL_OpenAudioDevice
/// 
/// 
pub const GetDefaultAudioInfo = SDL_GetDefaultAudioInfo;
extern fn SDL_GetDefaultAudioInfo(
    name: ?[*c][*c]u8,
    spec: ?*SDL_AudioSpec,
    iscapture: c_int,
) c_int;

/// 
/// Open a specific audio device.
/// 
/// Passing in a `device` name of NULL requests the most reasonable default.
/// The `device` name is a UTF-8 string reported by SDL_GetAudioDeviceName(), but
/// some drivers allow arbitrary and driver-specific strings, such as a
/// hostname/IP address for a remote audio server, or a filename in the
/// diskaudio driver.
/// 
/// An opened audio device starts out paused, and should be enabled for playing
/// by calling SDL_PlayAudioDevice(devid) when you are ready for your audio
/// callback function to be called. Since the audio driver may modify the
/// requested size of the audio buffer, you should allocate any local mixing
/// buffers after you open the audio device.
/// 
/// The audio callback runs in a separate thread in most cases; you can prevent
/// race conditions between your callback and other threads without fully
/// pausing playback with SDL_LockAudioDevice(). For more information about the
/// callback, see SDL_AudioSpec.
/// 
/// Managing the audio spec via 'desired' and 'obtained':
/// 
/// When filling in the desired audio spec structure:
/// 
/// - `desired->freq` should be the frequency in sample-frames-per-second (Hz).
/// - `desired->format` should be the audio format (`AUDIO_S16SYS`, etc).
/// - `desired->samples` is the desired size of the audio buffer, in _sample
///   frames_ (with stereo output, two samples--left and right--would make a
///   single sample frame). This number should be a power of two, and may be
///   adjusted by the audio driver to a value more suitable for the hardware.
///   Good values seem to range between 512 and 8096 inclusive, depending on
///   the application and CPU speed. Smaller values reduce latency, but can
///   lead to underflow if the application is doing heavy processing and cannot
///   fill the audio buffer in time. Note that the number of sample frames is
///   directly related to time by the following formula: `ms =
///   (sampleframes*1000)/freq`
/// - `desired->size` is the size in _bytes_ of the audio buffer, and is
///   calculated by SDL_OpenAudioDevice(). You don't initialize this.
/// - `desired->silence` is the value used to set the buffer to silence, and is
///   calculated by SDL_OpenAudioDevice(). You don't initialize this.
/// - `desired->callback` should be set to a function that will be called when
///   the audio device is ready for more data. It is passed a pointer to the
///   audio buffer, and the length in bytes of the audio buffer. This function
///   usually runs in a separate thread, and so you should protect data
///   structures that it accesses by calling SDL_LockAudioDevice() and
///   SDL_UnlockAudioDevice() in your code. Alternately, you may pass a NULL
///   pointer here, and call SDL_QueueAudio() with some frequency, to queue
///   more audio samples to be played (or for capture devices, call
///   SDL_DequeueAudio() with some frequency, to obtain audio samples).
/// - `desired->userdata` is passed as the first parameter to your callback
///   function. If you passed a NULL callback, this value is ignored.
/// 
/// `allowed_changes` can have the following flags OR'd together:
/// 
/// - `SDL_AUDIO_ALLOW_FREQUENCY_CHANGE`
/// - `SDL_AUDIO_ALLOW_FORMAT_CHANGE`
/// - `SDL_AUDIO_ALLOW_CHANNELS_CHANGE`
/// - `SDL_AUDIO_ALLOW_SAMPLES_CHANGE`
/// - `SDL_AUDIO_ALLOW_ANY_CHANGE`
/// 
/// These flags specify how SDL should behave when a device cannot offer a
/// specific feature. If the application requests a feature that the hardware
/// doesn't offer, SDL will always try to get the closest equivalent.
/// 
/// For example, if you ask for float32 audio format, but the sound card only
/// supports int16, SDL will set the hardware to int16. If you had set
/// SDL_AUDIO_ALLOW_FORMAT_CHANGE, SDL will change the format in the `obtained`
/// structure. If that flag was *not* set, SDL will prepare to convert your
/// callback's float32 audio to int16 before feeding it to the hardware and
/// will keep the originally requested format in the `obtained` structure.
/// 
/// The resulting audio specs, varying depending on hardware and on what
/// changes were allowed, will then be written back to `obtained`.
/// 
/// If your application can only handle one specific data format, pass a zero
/// for `allowed_changes` and let SDL transparently handle any differences.
/// 
/// \param device a UTF-8 string reported by SDL_GetAudioDeviceName() or a
///               driver-specific name as appropriate. NULL requests the most
///               reasonable default device.
/// \param iscapture non-zero to specify a device should be opened for
///                  recording, not playback
/// \param desired an SDL_AudioSpec structure representing the desired output
///                format
/// \param obtained an SDL_AudioSpec structure filled in with the actual output
///                 format
/// \param allowed_changes 0, or one or more flags OR'd together
/// \returns a valid device ID that is > 0 on success or 0 on failure; call
///          SDL_GetError() for more information.
/// 
///          For compatibility with SDL 1.2, this will never return 1, since
///          SDL reserves that ID for the legacy SDL_OpenAudio() function.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_CloseAudioDevice
/// \sa SDL_GetAudioDeviceName
/// \sa SDL_LockAudioDevice
/// \sa SDL_PlayAudioDevice
/// \sa SDL_PauseAudioDevice
/// \sa SDL_UnlockAudioDevice
/// 
/// 
pub const OpenAudioDevice = SDL_OpenAudioDevice;
extern fn SDL_OpenAudioDevice(
    device: ?[*:0]const u8,
    iscapture: c_int,
    desired: ?*const SDL_AudioSpec,
    obtained: ?*SDL_AudioSpec,
    allowed_changes: c_int,
) SDL_AudioDeviceID;

/// 
/// Use this function to get the current audio state of an audio device.
/// 
/// \param dev the ID of an audio device previously opened with
///            SDL_OpenAudioDevice()
/// \returns the SDL_AudioStatus of the specified audio device.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_PlayAudioDevice
/// \sa SDL_PauseAudioDevice
/// 
/// 
pub const GetAudioDeviceStatus = SDL_GetAudioDeviceStatus;
extern fn SDL_GetAudioDeviceStatus(
    dev: SDL_AudioDeviceID,
) SDL_AudioStatus;

/// 
/// Use this function to play audio on a specified device.
/// 
/// Newly-opened audio devices start in the paused state, so you must
/// call this function after opening the specified audio
/// device to start playing sound. This allows you to safely initialize data
/// for your callback function after opening the audio device. Silence will be
/// written to the audio device while paused, and the audio callback is
/// guaranteed to not be called. Pausing one device does not prevent other
/// unpaused devices from running their callbacks.
/// 
/// \param dev a device opened by SDL_OpenAudioDevice()
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_LockAudioDevice
/// \sa SDL_PauseAudioDevice
/// 
/// 
pub const PlayAudioDevice = SDL_PlayAudioDevice;
extern fn SDL_PlayAudioDevice(
    dev: SDL_AudioDeviceID,
) void;

/// 
/// Use this function to pause audio playback on a specified device.
/// 
/// This function pauses the audio callback processing for a given
/// device.  Silence will be written to the audio device while paused, and
/// the audio callback is guaranteed to not be called.
/// Pausing one device does not prevent other unpaused devices from running
/// their callbacks.
/// 
/// If you just need to protect a few variables from race conditions vs your
/// callback, you shouldn't pause the audio device, as it will lead to dropouts
/// in the audio playback. Instead, you should use SDL_LockAudioDevice().
/// 
/// \param dev a device opened by SDL_OpenAudioDevice()
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_LockAudioDevice
/// \sa SDL_PlayAudioDevice
/// 
/// 
pub const PauseAudioDevice = SDL_PauseAudioDevice;
extern fn SDL_PauseAudioDevice(
    dev: SDL_AudioDeviceID,
) void;

/// 
/// Load the audio data of a WAVE file into memory.
/// 
/// Loading a WAVE file requires `src`, `spec`, `audio_buf` and `audio_len` to
/// be valid pointers. The entire data portion of the file is then loaded into
/// memory and decoded if necessary.
/// 
/// If `freesrc` is non-zero, the data source gets automatically closed and
/// freed before the function returns.
/// 
/// Supported formats are RIFF WAVE files with the formats PCM (8, 16, 24, and
/// 32 bits), IEEE Float (32 bits), Microsoft ADPCM and IMA ADPCM (4 bits), and
/// A-law and mu-law (8 bits). Other formats are currently unsupported and
/// cause an error.
/// 
/// If this function succeeds, the pointer returned by it is equal to `spec`
/// and the pointer to the audio data allocated by the function is written to
/// `audio_buf` and its length in bytes to `audio_len`. The SDL_AudioSpec
/// members `freq`, `channels`, and `format` are set to the values of the audio
/// data in the buffer. The `samples` member is set to a sane default and all
/// others are set to zero.
/// 
/// It's necessary to use SDL_free() to free the audio data returned in
/// `audio_buf` when it is no longer used.
/// 
/// Because of the underspecification of the .WAV format, there are many
/// problematic files in the wild that cause issues with strict decoders. To
/// provide compatibility with these files, this decoder is lenient in regards
/// to the truncation of the file, the fact chunk, and the size of the RIFF
/// chunk. The hints `SDL_HINT_WAVE_RIFF_CHUNK_SIZE`,
/// `SDL_HINT_WAVE_TRUNCATION`, and `SDL_HINT_WAVE_FACT_CHUNK` can be used to
/// tune the behavior of the loading process.
/// 
/// Any file that is invalid (due to truncation, corruption, or wrong values in
/// the headers), too big, or unsupported causes an error. Additionally, any
/// critical I/O error from the data source will terminate the loading process
/// with an error. The function returns NULL on error and in all cases (with
/// the exception of `src` being NULL), an appropriate error message will be
/// set.
/// 
/// It is required that the data source supports seeking.
/// 
/// Example:
/// 
/// ```c
/// SDL_LoadWAV_RW(SDL_RWFromFile("sample.wav", "rb"), 1, &spec, &buf, &len);
/// ```
/// 
/// Note that the SDL_LoadWAV macro does this same thing for you, but in a less
/// messy way:
/// 
/// ```c
/// SDL_LoadWAV("sample.wav", &spec, &buf, &len);
/// ```
/// 
/// \param src The data source for the WAVE data
/// \param freesrc If non-zero, SDL will _always_ free the data source
/// \param spec An SDL_AudioSpec that will be filled in with the wave file's
///             format details
/// \param audio_buf A pointer filled with the audio data, allocated by the
///                  function.
/// \param audio_len A pointer filled with the length of the audio data buffer
///                  in bytes
/// \returns This function, if successfully called, returns `spec`, which will
///          be filled with the audio data format of the wave source data.
///          `audio_buf` will be filled with a pointer to an allocated buffer
///          containing the audio data, and `audio_len` is filled with the
///          length of that audio buffer in bytes.
/// 
///          This function returns NULL if the .WAV file cannot be opened, uses
///          an unknown data format, or is corrupt; call SDL_GetError() for
///          more information.
/// 
///          When the application is done with the data returned in
///          `audio_buf`, it should call SDL_free() to dispose of it.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_free
/// \sa SDL_LoadWAV
/// 
/// 
pub const LoadWAV_RW = SDL_LoadWAV_RW;
extern fn SDL_LoadWAV_RW(
    src: ?*SDL_RWops,
    freesrc: c_int,
    spec: ?*SDL_AudioSpec,
    audio_buf: ?[*c][*c]u8,
    audio_len: ?*u32,
) ?*SDL_AudioSpec;

/// 
/// Initialize an SDL_AudioCVT structure for conversion.
/// 
/// Before an SDL_AudioCVT structure can be used to convert audio data it must
/// be initialized with source and destination information.
/// 
/// This function will zero out every field of the SDL_AudioCVT, so it must be
/// called before the application fills in the final buffer information.
/// 
/// Once this function has returned successfully, and reported that a
/// conversion is necessary, the application fills in the rest of the fields in
/// SDL_AudioCVT, now that it knows how large a buffer it needs to allocate,
/// and then can call SDL_ConvertAudio() to complete the conversion.
/// 
/// \param cvt an SDL_AudioCVT structure filled in with audio conversion
///            information
/// \param src_format the source format of the audio data; for more info see
///                   SDL_AudioFormat
/// \param src_channels the number of channels in the source
/// \param src_rate the frequency (sample-frames-per-second) of the source
/// \param dst_format the destination format of the audio data; for more info
///                   see SDL_AudioFormat
/// \param dst_channels the number of channels in the destination
/// \param dst_rate the frequency (sample-frames-per-second) of the destination
/// \returns 1 if the audio filter is prepared, 0 if no conversion is needed,
///          or a negative error code on failure; call SDL_GetError() for more
///          information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_ConvertAudio
/// 
/// 
pub const BuildAudioCVT = SDL_BuildAudioCVT;
extern fn SDL_BuildAudioCVT(
    cvt: ?*SDL_AudioCVT,
    src_format: SDL_AudioFormat,
    src_channels: u8,
    src_rate: c_int,
    dst_format: SDL_AudioFormat,
    dst_channels: u8,
    dst_rate: c_int,
) c_int;

/// 
/// Convert audio data to a desired audio format.
/// 
/// This function does the actual audio data conversion, after the application
/// has called SDL_BuildAudioCVT() to prepare the conversion information and
/// then filled in the buffer details.
/// 
/// Once the application has initialized the `cvt` structure using
/// SDL_BuildAudioCVT(), allocated an audio buffer and filled it with audio
/// data in the source format, this function will convert the buffer, in-place,
/// to the desired format.
/// 
/// The data conversion may go through several passes; any given pass may
/// possibly temporarily increase the size of the data. For example, SDL might
/// expand 16-bit data to 32 bits before resampling to a lower frequency,
/// shrinking the data size after having grown it briefly. Since the supplied
/// buffer will be both the source and destination, converting as necessary
/// in-place, the application must allocate a buffer that will fully contain
/// the data during its largest conversion pass. After SDL_BuildAudioCVT()
/// returns, the application should set the `cvt->len` field to the size, in
/// bytes, of the source data, and allocate a buffer that is `cvt->len *
/// cvt->len_mult` bytes long for the `buf` field.
/// 
/// The source data should be copied into this buffer before the call to
/// SDL_ConvertAudio(). Upon successful return, this buffer will contain the
/// converted audio, and `cvt->len_cvt` will be the size of the converted data,
/// in bytes. Any bytes in the buffer past `cvt->len_cvt` are undefined once
/// this function returns.
/// 
/// \param cvt an SDL_AudioCVT structure that was previously set up by
///            SDL_BuildAudioCVT().
/// \returns 0 if the conversion was completed successfully or a negative error
///          code on failure; call SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_BuildAudioCVT
/// 
/// 
pub const ConvertAudio = SDL_ConvertAudio;
extern fn SDL_ConvertAudio(
    cvt: ?*SDL_AudioCVT,
) c_int;

/// 
/// Create a new audio stream.
/// 
/// \param src_format The format of the source audio
/// \param src_channels The number of channels of the source audio
/// \param src_rate The sampling rate of the source audio
/// \param dst_format The format of the desired audio output
/// \param dst_channels The number of channels of the desired audio output
/// \param dst_rate The sampling rate of the desired audio output
/// \returns 0 on success, or -1 on error.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_PutAudioStreamData
/// \sa SDL_GetAudioStreamData
/// \sa SDL_GetAudioStreamAvailable
/// \sa SDL_FlushAudioStream
/// \sa SDL_ClearAudioStream
/// \sa SDL_DestroyAudioStream
/// 
/// 
pub const CreateAudioStream = SDL_CreateAudioStream;
extern fn SDL_CreateAudioStream(
    src_format: SDL_AudioFormat,
    src_channels: u8,
    src_rate: c_int,
    dst_format: SDL_AudioFormat,
    dst_channels: u8,
    dst_rate: c_int,
) ?*SDL_AudioStream;

/// 
/// Add data to be converted/resampled to the stream.
/// 
/// \param stream The stream the audio data is being added to
/// \param buf A pointer to the audio data to add
/// \param len The number of bytes to write to the stream
/// \returns 0 on success, or -1 on error.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_CreateAudioStream
/// \sa SDL_GetAudioStreamData
/// \sa SDL_GetAudioStreamAvailable
/// \sa SDL_FlushAudioStream
/// \sa SDL_ClearAudioStream
/// \sa SDL_DestroyAudioStream
/// 
/// 
pub const PutAudioStreamData = SDL_PutAudioStreamData;
extern fn SDL_PutAudioStreamData(
    stream: ?*SDL_AudioStream,
    buf: ?*const anyopaque,
    len: c_int,
) c_int;

/// 
/// Get converted/resampled data from the stream
/// 
/// \param stream The stream the audio is being requested from
/// \param buf A buffer to fill with audio data
/// \param len The maximum number of bytes to fill
/// \returns the number of bytes read from the stream, or -1 on error
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_CreateAudioStream
/// \sa SDL_PutAudioStreamData
/// \sa SDL_GetAudioStreamAvailable
/// \sa SDL_FlushAudioStream
/// \sa SDL_ClearAudioStream
/// \sa SDL_DestroyAudioStream
/// 
/// 
pub const GetAudioStreamData = SDL_GetAudioStreamData;
extern fn SDL_GetAudioStreamData(
    stream: ?*SDL_AudioStream,
    buf: ?*anyopaque,
    len: c_int,
) c_int;

/// 
/// Get the number of converted/resampled bytes available.
/// 
/// The stream may be buffering data behind the scenes until it has enough to
/// resample correctly, so this number might be lower than what you expect, or
/// even be zero. Add more data or flush the stream if you need the data now.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_CreateAudioStream
/// \sa SDL_PutAudioStreamData
/// \sa SDL_GetAudioStreamData
/// \sa SDL_FlushAudioStream
/// \sa SDL_ClearAudioStream
/// \sa SDL_DestroyAudioStream
/// 
/// 
pub const GetAudioStreamAvailable = SDL_GetAudioStreamAvailable;
extern fn SDL_GetAudioStreamAvailable(
    stream: ?*SDL_AudioStream,
) c_int;

/// 
/// Tell the stream that you're done sending data, and anything being buffered
/// should be converted/resampled and made available immediately.
/// 
/// It is legal to add more data to a stream after flushing, but there will be
/// audio gaps in the output. Generally this is intended to signal the end of
/// input, so the complete output becomes available.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_CreateAudioStream
/// \sa SDL_PutAudioStreamData
/// \sa SDL_GetAudioStreamData
/// \sa SDL_GetAudioStreamAvailable
/// \sa SDL_ClearAudioStream
/// \sa SDL_DestroyAudioStream
/// 
/// 
pub const FlushAudioStream = SDL_FlushAudioStream;
extern fn SDL_FlushAudioStream(
    stream: ?*SDL_AudioStream,
) c_int;

/// 
/// Clear any pending data in the stream without converting it
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_CreateAudioStream
/// \sa SDL_PutAudioStreamData
/// \sa SDL_GetAudioStreamData
/// \sa SDL_GetAudioStreamAvailable
/// \sa SDL_FlushAudioStream
/// \sa SDL_DestroyAudioStream
/// 
/// 
pub const ClearAudioStream = SDL_ClearAudioStream;
extern fn SDL_ClearAudioStream(
    stream: ?*SDL_AudioStream,
) void;

/// 
/// Free an audio stream
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_CreateAudioStream
/// \sa SDL_PutAudioStreamData
/// \sa SDL_GetAudioStreamData
/// \sa SDL_GetAudioStreamAvailable
/// \sa SDL_FlushAudioStream
/// \sa SDL_ClearAudioStream
/// 
/// 
pub const DestroyAudioStream = SDL_DestroyAudioStream;
extern fn SDL_DestroyAudioStream(
    stream: ?*SDL_AudioStream,
) void;

/// 
/// Mix audio data in a specified format.
/// 
/// This takes an audio buffer `src` of `len` bytes of `format` data and mixes
/// it into `dst`, performing addition, volume adjustment, and overflow
/// clipping. The buffer pointed to by `dst` must also be `len` bytes of
/// `format` data.
/// 
/// This is provided for convenience -- you can mix your own audio data.
/// 
/// Do not use this function for mixing together more than two streams of
/// sample data. The output from repeated application of this function may be
/// distorted by clipping, because there is no accumulator with greater range
/// than the input (not to mention this being an inefficient way of doing it).
/// 
/// It is a common misconception that this function is required to write audio
/// data to an output stream in an audio callback. While you can do that,
/// SDL_MixAudioFormat() is really only needed when you're mixing a single
/// audio stream with a volume adjustment.
/// 
/// \param dst the destination for the mixed audio
/// \param src the source audio buffer to be mixed
/// \param format the SDL_AudioFormat structure representing the desired audio
///               format
/// \param len the length of the audio buffer in bytes
/// \param volume ranges from 0 - 128, and should be set to SDL_MIX_MAXVOLUME
///               for full audio volume
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// 
pub const MixAudioFormat = SDL_MixAudioFormat;
extern fn SDL_MixAudioFormat(
    dst: ?*u8,
    src: ?[*]const u8,
    format: SDL_AudioFormat,
    len: u32,
    volume: c_int,
) void;

/// 
/// Queue more audio on non-callback devices.
/// 
/// If you are looking to retrieve queued audio from a non-callback capture
/// device, you want SDL_DequeueAudio() instead. SDL_QueueAudio() will return
/// -1 to signify an error if you use it with capture devices.
/// 
/// SDL offers two ways to feed audio to the device: you can either supply a
/// callback that SDL triggers with some frequency to obtain more audio (pull
/// method), or you can supply no callback, and then SDL will expect you to
/// supply data at regular intervals (push method) with this function.
/// 
/// There are no limits on the amount of data you can queue, short of
/// exhaustion of address space. Queued data will drain to the device as
/// necessary without further intervention from you. If the device needs audio
/// but there is not enough queued, it will play silence to make up the
/// difference. This means you will have skips in your audio playback if you
/// aren't routinely queueing sufficient data.
/// 
/// This function copies the supplied data, so you are safe to free it when the
/// function returns. This function is thread-safe, but queueing to the same
/// device from two threads at once does not promise which buffer will be
/// queued first.
/// 
/// You may not queue audio on a device that is using an application-supplied
/// callback; doing so returns an error. You have to use the audio callback or
/// queue audio with this function, but not both.
/// 
/// You should not call SDL_LockAudio() on the device before queueing; SDL
/// handles locking internally for this function.
/// 
/// Note that SDL does not support planar audio. You will need to resample from
/// planar audio formats into a non-planar one (see SDL_AudioFormat) before
/// queuing audio.
/// 
/// \param dev the device ID to which we will queue audio
/// \param data the data to queue to the device for later playback
/// \param len the number of bytes (not samples!) to which `data` points
/// \returns 0 on success or a negative error code on failure; call
///          SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_ClearQueuedAudio
/// \sa SDL_GetQueuedAudioSize
/// 
/// 
pub const QueueAudio = SDL_QueueAudio;
extern fn SDL_QueueAudio(
    dev: SDL_AudioDeviceID,
    data: ?*const anyopaque,
    len: u32,
) c_int;

/// 
/// Dequeue more audio on non-callback devices.
/// 
/// If you are looking to queue audio for output on a non-callback playback
/// device, you want SDL_QueueAudio() instead. SDL_DequeueAudio() will always
/// return 0 if you use it with playback devices.
/// 
/// SDL offers two ways to retrieve audio from a capture device: you can either
/// supply a callback that SDL triggers with some frequency as the device
/// records more audio data, (push method), or you can supply no callback, and
/// then SDL will expect you to retrieve data at regular intervals (pull
/// method) with this function.
/// 
/// There are no limits on the amount of data you can queue, short of
/// exhaustion of address space. Data from the device will keep queuing as
/// necessary without further intervention from you. This means you will
/// eventually run out of memory if you aren't routinely dequeueing data.
/// 
/// Capture devices will not queue data when paused; if you are expecting to
/// not need captured audio for some length of time, use SDL_PauseAudioDevice()
/// to stop the capture device from queueing more data. This can be useful
/// during, say, level loading times. When unpaused, capture devices will start
/// queueing data from that point, having flushed any capturable data available
/// while paused.
/// 
/// This function is thread-safe, but dequeueing from the same device from two
/// threads at once does not promise which thread will dequeue data first.
/// 
/// You may not dequeue audio from a device that is using an
/// application-supplied callback; doing so returns an error. You have to use
/// the audio callback, or dequeue audio with this function, but not both.
/// 
/// You should not call SDL_LockAudio() on the device before dequeueing; SDL
/// handles locking internally for this function.
/// 
/// \param dev the device ID from which we will dequeue audio
/// \param data a pointer into where audio data should be copied
/// \param len the number of bytes (not samples!) to which (data) points
/// \returns the number of bytes dequeued, which could be less than requested;
///          call SDL_GetError() for more information.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_ClearQueuedAudio
/// \sa SDL_GetQueuedAudioSize
/// 
/// 
pub const DequeueAudio = SDL_DequeueAudio;
extern fn SDL_DequeueAudio(
    dev: SDL_AudioDeviceID,
    data: ?*anyopaque,
    len: u32,
) u32;

/// 
/// Get the number of bytes of still-queued audio.
/// 
/// For playback devices: this is the number of bytes that have been queued for
/// playback with SDL_QueueAudio(), but have not yet been sent to the hardware.
/// 
/// Once we've sent it to the hardware, this function can not decide the exact
/// byte boundary of what has been played. It's possible that we just gave the
/// hardware several kilobytes right before you called this function, but it
/// hasn't played any of it yet, or maybe half of it, etc.
/// 
/// For capture devices, this is the number of bytes that have been captured by
/// the device and are waiting for you to dequeue. This number may grow at any
/// time, so this only informs of the lower-bound of available data.
/// 
/// You may not queue or dequeue audio on a device that is using an
/// application-supplied callback; calling this function on such a device
/// always returns 0. You have to use the audio callback or queue audio, but
/// not both.
/// 
/// You should not call SDL_LockAudio() on the device before querying; SDL
/// handles locking internally for this function.
/// 
/// \param dev the device ID of which we will query queued audio size
/// \returns the number of bytes (not samples!) of queued audio.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_ClearQueuedAudio
/// \sa SDL_QueueAudio
/// \sa SDL_DequeueAudio
/// 
/// 
pub const GetQueuedAudioSize = SDL_GetQueuedAudioSize;
extern fn SDL_GetQueuedAudioSize(
    dev: SDL_AudioDeviceID,
) u32;

/// 
/// Drop any queued audio data waiting to be sent to the hardware.
/// 
/// Immediately after this call, SDL_GetQueuedAudioSize() will return 0. For
/// output devices, the hardware will start playing silence if more audio isn't
/// queued. For capture devices, the hardware will start filling the empty
/// queue with new data if the capture device isn't paused.
/// 
/// This will not prevent playback of queued audio that's already been sent to
/// the hardware, as we can not undo that, so expect there to be some fraction
/// of a second of audio that might still be heard. This can be useful if you
/// want to, say, drop any pending music or any unprocessed microphone input
/// during a level change in your game.
/// 
/// You may not queue or dequeue audio on a device that is using an
/// application-supplied callback; calling this function on such a device
/// always returns 0. You have to use the audio callback or queue audio, but
/// not both.
/// 
/// You should not call SDL_LockAudio() on the device before clearing the
/// queue; SDL handles locking internally for this function.
/// 
/// This function always succeeds and thus returns void.
/// 
/// \param dev the device ID of which to clear the audio queue
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_GetQueuedAudioSize
/// \sa SDL_QueueAudio
/// \sa SDL_DequeueAudio
/// 
/// 
pub const ClearQueuedAudio = SDL_ClearQueuedAudio;
extern fn SDL_ClearQueuedAudio(
    dev: SDL_AudioDeviceID,
) void;

/// 
/// Use this function to lock out the audio callback function for a specified
/// device.
/// 
/// The lock manipulated by these functions protects the audio callback
/// function specified in SDL_OpenAudioDevice(). During a
/// SDL_LockAudioDevice()/SDL_UnlockAudioDevice() pair, you can be guaranteed
/// that the callback function for that device is not running, even if the
/// device is not paused. While a device is locked, any other unpaused,
/// unlocked devices may still run their callbacks.
/// 
/// Calling this function from inside your audio callback is unnecessary. SDL
/// obtains this lock before calling your function, and releases it when the
/// function returns.
/// 
/// You should not hold the lock longer than absolutely necessary. If you hold
/// it too long, you'll experience dropouts in your audio playback. Ideally,
/// your application locks the device, sets a few variables and unlocks again.
/// Do not do heavy work while holding the lock for a device.
/// 
/// It is safe to lock the audio device multiple times, as long as you unlock
/// it an equivalent number of times. The callback will not run until the
/// device has been unlocked completely in this way. If your application fails
/// to unlock the device appropriately, your callback will never run, you might
/// hear repeating bursts of audio, and SDL_CloseAudioDevice() will probably
/// deadlock.
/// 
/// Internally, the audio device lock is a mutex; if you lock from two threads
/// at once, not only will you block the audio callback, you'll block the other
/// thread.
/// 
/// \param dev the ID of the device to be locked
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_UnlockAudioDevice
/// 
/// 
pub const LockAudioDevice = SDL_LockAudioDevice;
extern fn SDL_LockAudioDevice(
    dev: SDL_AudioDeviceID,
) void;

/// 
/// Use this function to unlock the audio callback function for a specified
/// device.
/// 
/// This function should be paired with a previous SDL_LockAudioDevice() call.
/// 
/// \param dev the ID of the device to be unlocked
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_LockAudioDevice
/// 
/// 
pub const UnlockAudioDevice = SDL_UnlockAudioDevice;
extern fn SDL_UnlockAudioDevice(
    dev: SDL_AudioDeviceID,
) void;

/// 
/// Use this function to shut down audio processing and close the audio device.
/// 
/// The application should close open audio devices once they are no longer
/// needed. Calling this function will wait until the device's audio callback
/// is not running, release the audio hardware and then clean up internal
/// state. No further audio will play from this device once this function
/// returns.
/// 
/// This function may block briefly while pending audio data is played by the
/// hardware, so that applications don't drop the last buffer of data they
/// supplied.
/// 
/// The device ID is invalid as soon as the device is closed, and is eligible
/// for reuse in a new SDL_OpenAudioDevice() call immediately.
/// 
/// \param dev an audio device previously opened with SDL_OpenAudioDevice()
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_OpenAudioDevice
/// 
/// 
pub const CloseAudioDevice = SDL_CloseAudioDevice;
extern fn SDL_CloseAudioDevice(
    dev: SDL_AudioDeviceID,
) void;

/// /* this tells Clang's static analysis that we're a custom assert function,
///    and that the analyzer should assume the condition was always true past this
///    SDL_assert test. */
/// 
pub const ReportAssertion = SDL_ReportAssertion;
extern fn SDL_ReportAssertion(
    param_name_not_specified: ?*SDL_AssertData,
    param_name_not_specified: ?[*:0]const u8,
    param_name_not_specified: ?[*:0]const u8,
    param_name_not_specified: c_int,
) SDL_AssertState;

/// 
/// Set an application-defined assertion handler.
/// 
/// This function allows an application to show its own assertion UI and/or
/// force the response to an assertion failure. If the application doesn't
/// provide this, SDL will try to do the right thing, popping up a
/// system-specific GUI dialog, and probably minimizing any fullscreen windows.
/// 
/// This callback may fire from any thread, but it runs wrapped in a mutex, so
/// it will only fire from one thread at a time.
/// 
/// This callback is NOT reset to SDL's internal handler upon SDL_Quit()!
/// 
/// \param handler the SDL_AssertionHandler function to call when an assertion
///                fails or NULL for the default handler
/// \param userdata a pointer that is passed to `handler`
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_GetAssertionHandler
/// 
/// 
pub const SetAssertionHandler = SDL_SetAssertionHandler;
extern fn SDL_SetAssertionHandler(
    handler: SDL_AssertionHandler,
    userdata: ?*anyopaque,
) void;

/// 
/// Get the default assertion handler.
/// 
/// This returns the function pointer that is called by default when an
/// assertion is triggered. This is an internal function provided by SDL, that
/// is used for assertions when SDL_SetAssertionHandler() hasn't been used to
/// provide a different function.
/// 
/// \returns the default SDL_AssertionHandler that is called when an assert
///          triggers.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_GetAssertionHandler
/// 
/// 
pub const GetDefaultAssertionHandler = SDL_GetDefaultAssertionHandler;
extern fn SDL_GetDefaultAssertionHandler() SDL_AssertionHandler;

/// 
/// Get the current assertion handler.
/// 
/// This returns the function pointer that is called when an assertion is
/// triggered. This is either the value last passed to
/// SDL_SetAssertionHandler(), or if no application-specified function is set,
/// is equivalent to calling SDL_GetDefaultAssertionHandler().
/// 
/// The parameter `puserdata` is a pointer to a void*, which will store the
/// "userdata" pointer that was passed to SDL_SetAssertionHandler(). This value
/// will always be NULL for the default handler. If you don't care about this
/// data, it is safe to pass a NULL pointer to this function to ignore it.
/// 
/// \param puserdata pointer which is filled with the "userdata" pointer that
///                  was passed to SDL_SetAssertionHandler()
/// \returns the SDL_AssertionHandler that is called when an assert triggers.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_SetAssertionHandler
/// 
/// 
pub const GetAssertionHandler = SDL_GetAssertionHandler;
extern fn SDL_GetAssertionHandler(
    puserdata: [*c][*c]anyopaque,
) SDL_AssertionHandler;

/// 
/// Get a list of all assertion failures.
/// 
/// This function gets all assertions triggered since the last call to
/// SDL_ResetAssertionReport(), or the start of the program.
/// 
/// The proper way to examine this data looks something like this:
/// 
/// ```c
/// const SDL_AssertData *item = SDL_GetAssertionReport();
/// while (item) {
///    printf("'%s', %s (%s:%d), triggered %u times, always ignore: %s.\\n",
///           item->condition, item->function, item->filename,
///           item->linenum, item->trigger_count,
///           item->always_ignore ? "yes" : "no");
///    item = item->next;
/// }
/// ```
/// 
/// \returns a list of all failed assertions or NULL if the list is empty. This
///          memory should not be modified or freed by the application.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_ResetAssertionReport
/// 
/// 
pub const GetAssertionReport = SDL_GetAssertionReport;
extern fn SDL_GetAssertionReport() ?*const SDL_AssertData;

/// 
/// Clear the list of all assertion failures.
/// 
/// This function will clear the list of all assertions triggered up to that
/// point. Immediately following this call, SDL_GetAssertionReport will return
/// no items. In addition, any previously-triggered assertions will be reset to
/// a trigger_count of zero, and their always_ignore state will be false.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_GetAssertionReport
/// 
/// 
pub const ResetAssertionReport = SDL_ResetAssertionReport;
extern fn SDL_ResetAssertionReport() void;

/// 
/// Get an ASCII string representation for a given ::SDL_GUID.
/// 
/// You should supply at least 33 bytes for pszGUID.
/// 
/// \param guid the ::SDL_GUID you wish to convert to string
/// \param pszGUID buffer in which to write the ASCII string
/// \param cbGUID the size of pszGUID
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_GUIDFromString
/// 
/// 
pub const GUIDToString = SDL_GUIDToString;
extern fn SDL_GUIDToString(
    guid: SDL_GUID,
    pszGUID: ?[*:0]u8,
    cbGUID: c_int,
) void;

/// 
/// Convert a GUID string into a ::SDL_GUID structure.
/// 
/// Performs no error checking. If this function is given a string containing
/// an invalid GUID, the function will silently succeed, but the GUID generated
/// will not be useful.
/// 
/// \param pchGUID string containing an ASCII representation of a GUID
/// \returns a ::SDL_GUID structure.
/// 
/// \since This function is available since SDL 3.0.0.
/// 
/// \sa SDL_GUIDToString
/// 
/// 
pub const GUIDFromString = SDL_GUIDFromString;
extern fn SDL_GUIDFromString(
    pchGUID: ?[*:0]const u8,
) SDL_GUID;

