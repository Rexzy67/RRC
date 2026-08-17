"""Standalone Windows profile popup for RRSCRIPT.lua.

This helper monitors configured mouse buttons or keyboard keys itself. It does
not receive messages from Logitech G HUB and requires no third-party packages.
Keep its profile and input settings aligned with RRSCRIPT.lua before starting
the helper.
"""

from __future__ import annotations

import argparse
import ctypes
import os
from ctypes import wintypes


PROFILE_ORDER = (
    "SMG11",
    "SMG12",
    "C8-SFW",
    "F2",
    "R4C",
    "P90",
    "MP5",
    "MPX",
    "MP5K",
    "MP5SD",
    "MP7",
    "P10 Roni",
    "Vector",
    "XK23",
    "AK-12",
    "AK74M",
    "C7E",
    "416-C",
    "9x19",
    "F90",
    "K1A",
    "M762",
    "POF-9",
    "Scorpion",
    "T-5",
    "T-95 LSW",
    "TCSG12",
    "UMP45",
    "UZK50GI",
    "G36C",
    "L85A2",
    "M4",
    "PARA-308",
    "SPEAR .308",
    "SPEAR .308 HOLO",
    "V308",
    "552 COMMANDO",
    "556XI",
    "Custom",
)
INITIAL_PROFILE = "Custom"

# Choose ``"keyboard"`` when G HUB maps the profile buttons to keys, or
# ``"mouse"`` to monitor physical Windows mouse buttons 1 through 5.
# The keyboard default matches a common G HUB mapping: Mouse 7 -> ``-`` and
# Mouse 8 -> ``,``. Key matching is case-insensitive for letters.
INPUT_MODE = "keyboard"
PREVIOUS_PROFILE_KEY = "-"
NEXT_PROFILE_KEY = ","

# Used only when INPUT_MODE is "mouse". Keep these aligned with the Lua
# profile-button values. Do not use Mouse 1 or Mouse 3 unless the Lua trigger
# bindings were changed as well.
PREVIOUS_PROFILE_MOUSE_BUTTON = 4
NEXT_PROFILE_MOUSE_BUTTON = 5
SUPPORTED_MOUSE_BUTTONS = frozenset(range(1, 6))

if os.name != "nt":
    raise SystemExit("ProfilePopup.pyw runs on Windows only.")


user32 = ctypes.WinDLL("user32", use_last_error=True)
kernel32 = ctypes.WinDLL("kernel32", use_last_error=True)
shell32 = ctypes.WinDLL("shell32", use_last_error=True)
gdi32 = ctypes.WinDLL("gdi32", use_last_error=True)

LRESULT = ctypes.c_ssize_t
ULONG_PTR = ctypes.c_size_t
UINT_PTR = ctypes.c_size_t
HHOOK = wintypes.HANDLE
HICON = wintypes.HANDLE
HMENU = wintypes.HANDLE
WCHAR16 = ctypes.c_uint16

WM_DESTROY = 0x0002
WM_COMMAND = 0x0111
WM_CTLCOLORSTATIC = 0x0138
WM_TIMER = 0x0113
WM_LBUTTONDOWN = 0x0201
WM_MBUTTONDOWN = 0x0207
WM_RBUTTONDOWN = 0x0204
WM_XBUTTONDOWN = 0x020B
WM_KEYDOWN = 0x0100
WM_KEYUP = 0x0101
WM_SYSKEYDOWN = 0x0104
WM_SYSKEYUP = 0x0105
WM_LBUTTONDBLCLK = 0x0203
WM_RBUTTONUP = 0x0205
WM_CONTEXTMENU = 0x007B
WM_APP = 0x8000
WM_TRAYICON = WM_APP + 1
WM_NEXT_PROFILE = WM_APP + 2
WM_PREVIOUS_PROFILE = WM_APP + 3

WH_MOUSE_LL = 14
WH_KEYBOARD_LL = 13
HC_ACTION = 0
XBUTTON1 = 0x0001  # Windows' first extended mouse button: Mouse 4.
XBUTTON2 = 0x0002  # Windows' second extended mouse button: Mouse 5.

WS_OVERLAPPED = 0x00000000
WS_POPUP = 0x80000000
WS_BORDER = 0x00800000
WS_EX_TOOLWINDOW = 0x00000080
WS_EX_TOPMOST = 0x00000008
WS_EX_NOACTIVATE = 0x08000000
WS_CHILD = 0x40000000
WS_VISIBLE = 0x10000000
SS_CENTER = 0x00000001
SS_CENTERIMAGE = 0x00000200

SW_HIDE = 0
SW_SHOWNOACTIVATE = 4
HWND_TOPMOST = wintypes.HWND(-1)
SWP_NOACTIVATE = 0x0010
SWP_SHOWWINDOW = 0x0040

NIM_ADD = 0x00000000
NIM_MODIFY = 0x00000001
NIM_DELETE = 0x00000002
NIM_SETVERSION = 0x00000004
NIF_MESSAGE = 0x00000001
NIF_ICON = 0x00000002
NIF_TIP = 0x00000004
NIF_INFO = 0x00000010
NIIF_INFO = 0x00000001
NOTIFYICON_VERSION_4 = 4
IDI_INFORMATION = 32516

MF_STRING = 0x00000000
MF_CHECKED = 0x00000008
MF_SEPARATOR = 0x00000800
MF_POPUP = 0x00000010
TPM_RIGHTBUTTON = 0x0002

ID_ABOUT = 1001
ID_TEST = 1002
ID_EXIT = 1003
ID_SET_PROFILE_BASE = 2000
POPUP_TIMER_ID = 1
POPUP_DURATION_MS = 1500
POPUP_MARGIN_PX = 50
POPUP_HORIZONTAL_PADDING_PX = 8
POPUP_VERTICAL_PADDING_PX = 6
POPUP_LINE_GAP_PX = 2

WM_SETFONT = 0x0030
DEFAULT_GUI_FONT = 17
WHITE_BRUSH = 0
BLACK = 0x000000
WHITE = 0xFFFFFF
MUTED_GRAY = 0x929292
MB_OK = 0x00000000
MB_ICONINFORMATION = 0x00000040
SPI_GETWORKAREA = 0x0030
SM_CXSCREEN = 0
SM_CYSCREEN = 1


class GUID(ctypes.Structure):
    _fields_ = [
        ("Data1", wintypes.DWORD),
        ("Data2", wintypes.WORD),
        ("Data3", wintypes.WORD),
        ("Data4", wintypes.BYTE * 8),
    ]


class NOTIFYICONDATAW(ctypes.Structure):
    _fields_ = [
        ("cbSize", wintypes.DWORD),
        ("hWnd", wintypes.HWND),
        ("uID", wintypes.UINT),
        ("uFlags", wintypes.UINT),
        ("uCallbackMessage", wintypes.UINT),
        ("hIcon", HICON),
        ("szTip", WCHAR16 * 128),
        ("dwState", wintypes.DWORD),
        ("dwStateMask", wintypes.DWORD),
        ("szInfo", WCHAR16 * 256),
        ("uTimeoutOrVersion", wintypes.UINT),
        ("szInfoTitle", WCHAR16 * 64),
        ("dwInfoFlags", wintypes.DWORD),
        ("guidItem", GUID),
        ("hBalloonIcon", HICON),
    ]


class MSLLHOOKSTRUCT(ctypes.Structure):
    _fields_ = [
        ("pt", wintypes.POINT),
        ("mouseData", wintypes.DWORD),
        ("flags", wintypes.DWORD),
        ("time", wintypes.DWORD),
        ("dwExtraInfo", ULONG_PTR),
    ]


class KBDLLHOOKSTRUCT(ctypes.Structure):
    _fields_ = [
        ("vkCode", wintypes.DWORD),
        ("scanCode", wintypes.DWORD),
        ("flags", wintypes.DWORD),
        ("time", wintypes.DWORD),
        ("dwExtraInfo", ULONG_PTR),
    ]


class SIZE(ctypes.Structure):
    _fields_ = [("cx", ctypes.c_long), ("cy", ctypes.c_long)]


WNDPROC = ctypes.WINFUNCTYPE(LRESULT, wintypes.HWND, wintypes.UINT, wintypes.WPARAM, wintypes.LPARAM)
HOOKPROC = ctypes.WINFUNCTYPE(LRESULT, ctypes.c_int, wintypes.WPARAM, wintypes.LPARAM)


class WNDCLASSW(ctypes.Structure):
    _fields_ = [
        ("style", wintypes.UINT),
        ("lpfnWndProc", WNDPROC),
        ("cbClsExtra", ctypes.c_int),
        ("cbWndExtra", ctypes.c_int),
        ("hInstance", wintypes.HINSTANCE),
        ("hIcon", HICON),
        ("hCursor", wintypes.HANDLE),
        ("hbrBackground", wintypes.HANDLE),
        ("lpszMenuName", wintypes.LPCWSTR),
        ("lpszClassName", wintypes.LPCWSTR),
    ]


user32.DefWindowProcW.argtypes = [wintypes.HWND, wintypes.UINT, wintypes.WPARAM, wintypes.LPARAM]
user32.DefWindowProcW.restype = LRESULT
user32.RegisterClassW.argtypes = [ctypes.POINTER(WNDCLASSW)]
user32.RegisterClassW.restype = wintypes.ATOM
user32.CreateWindowExW.argtypes = [
    wintypes.DWORD,
    wintypes.LPCWSTR,
    wintypes.LPCWSTR,
    wintypes.DWORD,
    ctypes.c_int,
    ctypes.c_int,
    ctypes.c_int,
    ctypes.c_int,
    wintypes.HWND,
    HMENU,
    wintypes.HINSTANCE,
    wintypes.LPVOID,
]
user32.CreateWindowExW.restype = wintypes.HWND
user32.DestroyWindow.argtypes = [wintypes.HWND]
user32.DestroyWindow.restype = wintypes.BOOL
user32.ShowWindow.argtypes = [wintypes.HWND, ctypes.c_int]
user32.SetWindowPos.argtypes = [
    wintypes.HWND,
    wintypes.HWND,
    ctypes.c_int,
    ctypes.c_int,
    ctypes.c_int,
    ctypes.c_int,
    wintypes.UINT,
]
user32.GetCursorPos.argtypes = [ctypes.POINTER(wintypes.POINT)]
user32.GetCursorPos.restype = wintypes.BOOL
user32.SystemParametersInfoW.argtypes = [wintypes.UINT, wintypes.UINT, wintypes.LPVOID, wintypes.UINT]
user32.SystemParametersInfoW.restype = wintypes.BOOL
user32.GetSystemMetrics.argtypes = [ctypes.c_int]
user32.GetSystemMetrics.restype = ctypes.c_int
user32.SetTimer.argtypes = [wintypes.HWND, UINT_PTR, wintypes.UINT, wintypes.LPVOID]
user32.SetTimer.restype = UINT_PTR
user32.KillTimer.argtypes = [wintypes.HWND, UINT_PTR]
user32.KillTimer.restype = wintypes.BOOL
user32.SetWindowsHookExW.argtypes = [ctypes.c_int, ctypes.c_void_p, wintypes.HINSTANCE, wintypes.DWORD]
user32.SetWindowsHookExW.restype = HHOOK
user32.UnhookWindowsHookEx.argtypes = [HHOOK]
user32.UnhookWindowsHookEx.restype = wintypes.BOOL
user32.CallNextHookEx.argtypes = [HHOOK, ctypes.c_int, wintypes.WPARAM, wintypes.LPARAM]
user32.CallNextHookEx.restype = LRESULT
user32.PostMessageW.argtypes = [wintypes.HWND, wintypes.UINT, wintypes.WPARAM, wintypes.LPARAM]
user32.PostMessageW.restype = wintypes.BOOL
user32.GetMessageW.argtypes = [ctypes.POINTER(wintypes.MSG), wintypes.HWND, wintypes.UINT, wintypes.UINT]
user32.GetMessageW.restype = ctypes.c_int
user32.TranslateMessage.argtypes = [ctypes.POINTER(wintypes.MSG)]
user32.DispatchMessageW.argtypes = [ctypes.POINTER(wintypes.MSG)]
user32.PostQuitMessage.argtypes = [ctypes.c_int]
user32.LoadIconW.argtypes = [wintypes.HINSTANCE, ctypes.c_void_p]
user32.LoadIconW.restype = HICON
user32.CreatePopupMenu.restype = HMENU
user32.AppendMenuW.argtypes = [HMENU, wintypes.UINT, UINT_PTR, wintypes.LPCWSTR]
user32.TrackPopupMenu.argtypes = [HMENU, wintypes.UINT, ctypes.c_int, ctypes.c_int, ctypes.c_int, wintypes.HWND, ctypes.c_void_p]
user32.DestroyMenu.argtypes = [HMENU]
user32.SetForegroundWindow.argtypes = [wintypes.HWND]
gdi32.GetStockObject.argtypes = [ctypes.c_int]
gdi32.GetStockObject.restype = wintypes.HANDLE
gdi32.SetTextColor.argtypes = [wintypes.HDC, wintypes.COLORREF]
gdi32.SetTextColor.restype = wintypes.COLORREF
gdi32.SetBkColor.argtypes = [wintypes.HDC, wintypes.COLORREF]
gdi32.SetBkColor.restype = wintypes.COLORREF
gdi32.SelectObject.argtypes = [wintypes.HDC, wintypes.HANDLE]
gdi32.SelectObject.restype = wintypes.HANDLE
gdi32.GetTextExtentPoint32W.argtypes = [wintypes.HDC, wintypes.LPCWSTR, ctypes.c_int, ctypes.POINTER(SIZE)]
gdi32.GetTextExtentPoint32W.restype = wintypes.BOOL
user32.SendMessageW.argtypes = [wintypes.HWND, wintypes.UINT, wintypes.WPARAM, wintypes.LPARAM]
user32.SendMessageW.restype = LRESULT
user32.SetWindowTextW.argtypes = [wintypes.HWND, wintypes.LPCWSTR]
user32.SetWindowTextW.restype = wintypes.BOOL
user32.GetDC.argtypes = [wintypes.HWND]
user32.GetDC.restype = wintypes.HDC
user32.ReleaseDC.argtypes = [wintypes.HWND, wintypes.HDC]
user32.ReleaseDC.restype = ctypes.c_int
user32.MessageBoxW.argtypes = [wintypes.HWND, wintypes.LPCWSTR, wintypes.LPCWSTR, wintypes.UINT]
user32.MessageBoxW.restype = ctypes.c_int
kernel32.GetModuleHandleW.argtypes = [wintypes.LPCWSTR]
kernel32.GetModuleHandleW.restype = wintypes.HMODULE
shell32.Shell_NotifyIconW.argtypes = [wintypes.DWORD, ctypes.POINTER(NOTIFYICONDATAW)]
shell32.Shell_NotifyIconW.restype = wintypes.BOOL


def raise_last_error(message: str) -> None:
    error = ctypes.get_last_error()
    raise OSError(error, f"{message} (Windows error {error})")


def write_wide_string(structure: ctypes.Structure, field_name: str, value: str) -> None:
    """Write UTF-16 text to a fixed-size WCHAR array in a Win32 structure.

    Python 3.14 represents ``ctypes.c_wchar`` with four bytes, while Windows
    structures require two-byte UTF-16 WCHAR values. The notification-area API
    therefore uses explicit 16-bit arrays and this helper to populate them.
    """

    target = getattr(structure, field_name)
    target_size = ctypes.sizeof(target)
    encoded = value.encode("utf-16-le")[: target_size - 2]
    ctypes.memset(ctypes.addressof(target), 0, target_size)
    ctypes.memmove(ctypes.addressof(target), encoded, len(encoded))


KEY_NAME_TO_VK = {chr(code): code for code in range(ord("A"), ord("Z") + 1)}
KEY_NAME_TO_VK.update({str(number): ord(str(number)) for number in range(10)})
KEY_NAME_TO_VK.update({
    "-": 0xBD,
    "=": 0xBB,
    "[": 0xDB,
    "]": 0xDD,
    "\\": 0xDC,
    ";": 0xBA,
    "'": 0xDE,
    ",": 0xBC,
    ".": 0xBE,
    "/": 0xBF,
    "SPACE": 0x20,
    "TAB": 0x09,
    "ENTER": 0x0D,
    "BACKSPACE": 0x08,
    "ESC": 0x1B,
})
KEY_NAME_TO_VK.update({f"F{number}": 0x6F + number for number in range(1, 25)})


def normalized_key_name(key_name: object) -> str | None:
    if not isinstance(key_name, str):
        return None
    normalized = key_name.strip().upper()
    return normalized if normalized else None


def keyboard_key_to_vk(key_name: object) -> int | None:
    normalized = normalized_key_name(key_name)
    return KEY_NAME_TO_VK.get(normalized) if normalized else None


def keyboard_key_label(key_name: object) -> str:
    return normalized_key_name(key_name) or "<invalid key>"


def validate_configuration() -> None:
    if INITIAL_PROFILE not in PROFILE_ORDER:
        raise ValueError("INITIAL_PROFILE must be one of the entries in PROFILE_ORDER.")

    if INPUT_MODE not in ("mouse", "keyboard"):
        raise ValueError('INPUT_MODE must be either "mouse" or "keyboard".')

    if INPUT_MODE == "mouse":
        for name, button in (
            ("PREVIOUS_PROFILE_MOUSE_BUTTON", PREVIOUS_PROFILE_MOUSE_BUTTON),
            ("NEXT_PROFILE_MOUSE_BUTTON", NEXT_PROFILE_MOUSE_BUTTON),
        ):
            if type(button) is not int or button not in SUPPORTED_MOUSE_BUTTONS:
                raise ValueError(f"{name} must be a whole mouse-button number from 1 through 5.")
        if PREVIOUS_PROFILE_MOUSE_BUTTON == NEXT_PROFILE_MOUSE_BUTTON:
            raise ValueError("Previous and next profile buttons must be different.")
        return

    previous_key = keyboard_key_to_vk(PREVIOUS_PROFILE_KEY)
    next_key = keyboard_key_to_vk(NEXT_PROFILE_KEY)
    if previous_key is None:
        raise ValueError("PREVIOUS_PROFILE_KEY must be a supported letter, number, symbol, or named key.")
    if next_key is None:
        raise ValueError("NEXT_PROFILE_KEY must be a supported letter, number, symbol, or named key.")
    if previous_key == next_key:
        raise ValueError("Previous and next profile keys must be different.")


def mouse_button_from_event(message: int, event: MSLLHOOKSTRUCT) -> int | None:
    """Return the physical button number for a low-level button-down event."""

    if message == WM_LBUTTONDOWN:
        return 1
    if message == WM_MBUTTONDOWN:
        return 2
    if message == WM_RBUTTONDOWN:
        return 3
    if message == WM_XBUTTONDOWN:
        xbutton = (event.mouseData >> 16) & 0xFFFF
        if xbutton == XBUTTON1:
            return 4
        if xbutton == XBUTTON2:
            return 5
    return None


APP: ProfilePopupApp | None = None


@WNDPROC
def window_proc(hwnd: int, message: int, wparam: int, lparam: int) -> int:
    if APP is not None:
        try:
            return APP.handle_message(hwnd, message, wparam, lparam)
        except Exception:
            return user32.DefWindowProcW(hwnd, message, wparam, lparam)
    return user32.DefWindowProcW(hwnd, message, wparam, lparam)


class ProfilePopupApp:
    class_name = "RrcStandaloneProfilePopup"

    def __init__(self) -> None:
        validate_configuration()

        self.profile_index = PROFILE_ORDER.index(INITIAL_PROFILE)
        self.instance = kernel32.GetModuleHandleW(None)
        self.hwnd: int | None = None
        self.popup_hwnd: int | None = None
        self.previous_label_hwnd: int | None = None
        self.current_label_hwnd: int | None = None
        self.next_label_hwnd: int | None = None
        self.mouse_hook: int | None = None
        self.mouse_proc = HOOKPROC(self.mouse_hook_proc)
        self.keyboard_hook: int | None = None
        self.keyboard_proc = HOOKPROC(self.keyboard_hook_proc)
        self.keys_down: set[int] = set()
        self.tray_icon = user32.LoadIconW(None, ctypes.c_void_p(IDI_INFORMATION))

    def run(self) -> None:
        self.create_hidden_window()
        self.add_tray_icon()
        if INPUT_MODE == "mouse":
            self.install_mouse_hook()
        else:
            self.install_keyboard_hook()
        self.show_startup_notification()

        message = wintypes.MSG()
        while (result := user32.GetMessageW(ctypes.byref(message), None, 0, 0)) != 0:
            if result == -1:
                raise_last_error("Unable to retrieve a Windows message")
            user32.TranslateMessage(ctypes.byref(message))
            user32.DispatchMessageW(ctypes.byref(message))

    def create_hidden_window(self) -> None:
        window_class = WNDCLASSW()
        window_class.lpfnWndProc = window_proc
        window_class.hInstance = self.instance
        window_class.hbrBackground = gdi32.GetStockObject(WHITE_BRUSH)
        window_class.lpszClassName = self.class_name

        atom = user32.RegisterClassW(ctypes.byref(window_class))
        if not atom and ctypes.get_last_error() != 1410:  # Class already exists.
            raise_last_error("Unable to register the profile popup window class")

        self.hwnd = user32.CreateWindowExW(
            WS_EX_TOOLWINDOW,
            self.class_name,
            "RRC Profile Popup",
            WS_OVERLAPPED,
            0,
            0,
            0,
            0,
            None,
            None,
            self.instance,
            None,
        )
        if not self.hwnd:
            raise_last_error("Unable to create the profile popup window")

    def add_tray_icon(self) -> None:
        data = self.notify_data(NIF_MESSAGE | NIF_ICON | NIF_TIP)
        data.uCallbackMessage = WM_TRAYICON
        data.hIcon = self.tray_icon
        write_wide_string(data, "szTip", "RRC Profile Popup")

        if not shell32.Shell_NotifyIconW(NIM_ADD, ctypes.byref(data)):
            raise_last_error("Unable to add the system-tray icon")

        version = self.notify_data(0)
        version.uTimeoutOrVersion = NOTIFYICON_VERSION_4
        shell32.Shell_NotifyIconW(NIM_SETVERSION, ctypes.byref(version))

    def remove_tray_icon(self) -> None:
        if self.hwnd:
            data = self.notify_data(0)
            shell32.Shell_NotifyIconW(NIM_DELETE, ctypes.byref(data))

    def show_startup_notification(self) -> None:
        data = self.notify_data(NIF_INFO)
        write_wide_string(data, "szInfoTitle", "RRC Profile Popup is running")
        write_wide_string(data, "szInfo", (
            "This helper shows the selected profile in the top-right corner. "
            f"{self.input_description()} goes back; {self.next_input_description()} goes forward. "
            "Right-click this tray icon for help or Exit."
        ))
        data.uTimeoutOrVersion = 8000
        data.dwInfoFlags = NIIF_INFO
        shell32.Shell_NotifyIconW(NIM_MODIFY, ctypes.byref(data))

    def notify_data(self, flags: int) -> NOTIFYICONDATAW:
        data = NOTIFYICONDATAW()
        data.cbSize = ctypes.sizeof(NOTIFYICONDATAW)
        data.hWnd = self.hwnd
        data.uID = 1
        data.uFlags = flags
        return data

    def install_mouse_hook(self) -> None:
        self.mouse_hook = user32.SetWindowsHookExW(
            WH_MOUSE_LL,
            ctypes.cast(self.mouse_proc, ctypes.c_void_p),
            self.instance,
            0,
        )
        if not self.mouse_hook:
            raise_last_error("Unable to monitor the configured profile buttons")

    def remove_mouse_hook(self) -> None:
        if self.mouse_hook:
            user32.UnhookWindowsHookEx(self.mouse_hook)
            self.mouse_hook = None

    def install_keyboard_hook(self) -> None:
        self.keyboard_hook = user32.SetWindowsHookExW(
            WH_KEYBOARD_LL,
            ctypes.cast(self.keyboard_proc, ctypes.c_void_p),
            self.instance,
            0,
        )
        if not self.keyboard_hook:
            raise_last_error("Unable to monitor the configured profile keys")

    def remove_keyboard_hook(self) -> None:
        if self.keyboard_hook:
            user32.UnhookWindowsHookEx(self.keyboard_hook)
            self.keyboard_hook = None
        self.keys_down.clear()

    def input_description(self) -> str:
        if INPUT_MODE == "mouse":
            return f"Mouse {PREVIOUS_PROFILE_MOUSE_BUTTON}"
        return f"Key {keyboard_key_label(PREVIOUS_PROFILE_KEY)}"

    def next_input_description(self) -> str:
        if INPUT_MODE == "mouse":
            return f"Mouse {NEXT_PROFILE_MOUSE_BUTTON}"
        return f"Key {keyboard_key_label(NEXT_PROFILE_KEY)}"

    def mouse_hook_proc(self, code: int, wparam: int, lparam: int) -> int:
        if code == HC_ACTION:
            event = ctypes.cast(lparam, ctypes.POINTER(MSLLHOOKSTRUCT)).contents
            button = mouse_button_from_event(wparam, event)
            if button == PREVIOUS_PROFILE_MOUSE_BUTTON and self.hwnd:
                user32.PostMessageW(self.hwnd, WM_PREVIOUS_PROFILE, 0, 0)
            elif button == NEXT_PROFILE_MOUSE_BUTTON and self.hwnd:
                user32.PostMessageW(self.hwnd, WM_NEXT_PROFILE, 0, 0)

        return user32.CallNextHookEx(self.mouse_hook, code, wparam, lparam)

    def keyboard_hook_proc(self, code: int, wparam: int, lparam: int) -> int:
        if code == HC_ACTION:
            event = ctypes.cast(lparam, ctypes.POINTER(KBDLLHOOKSTRUCT)).contents
            key_code = event.vkCode
            if wparam in (WM_KEYUP, WM_SYSKEYUP):
                self.keys_down.discard(key_code)
            elif wparam in (WM_KEYDOWN, WM_SYSKEYDOWN) and key_code not in self.keys_down:
                self.keys_down.add(key_code)
                if key_code == keyboard_key_to_vk(PREVIOUS_PROFILE_KEY) and self.hwnd:
                    user32.PostMessageW(self.hwnd, WM_PREVIOUS_PROFILE, 0, 0)
                elif key_code == keyboard_key_to_vk(NEXT_PROFILE_KEY) and self.hwnd:
                    user32.PostMessageW(self.hwnd, WM_NEXT_PROFILE, 0, 0)

        return user32.CallNextHookEx(self.keyboard_hook, code, wparam, lparam)

    def handle_message(self, hwnd: int, message: int, wparam: int, lparam: int) -> int:
        if message == WM_NEXT_PROFILE:
            self.next_profile()
            return 0

        if message == WM_PREVIOUS_PROFILE:
            self.previous_profile()
            return 0

        if message == WM_CTLCOLORSTATIC:
            if lparam in (self.previous_label_hwnd, self.next_label_hwnd):
                gdi32.SetTextColor(wparam, MUTED_GRAY)
            else:
                gdi32.SetTextColor(wparam, BLACK)
            gdi32.SetBkColor(wparam, WHITE)
            return gdi32.GetStockObject(WHITE_BRUSH)

        if message == WM_TIMER and wparam == POPUP_TIMER_ID:
            if self.popup_hwnd:
                user32.ShowWindow(self.popup_hwnd, SW_HIDE)
            user32.KillTimer(hwnd, POPUP_TIMER_ID)
            return 0

        if message == WM_COMMAND:
            command = wparam & 0xFFFF
            if ID_SET_PROFILE_BASE <= command < ID_SET_PROFILE_BASE + len(PROFILE_ORDER):
                self.set_profile(command - ID_SET_PROFILE_BASE)
            elif command == ID_ABOUT:
                self.show_about()
            elif command == ID_TEST:
                self.show_popup("Previous", "TEST", "Next")
            elif command == ID_EXIT:
                user32.DestroyWindow(hwnd)
            return 0

        if message == WM_TRAYICON:
            event = lparam & 0xFFFF
            if event == WM_LBUTTONDBLCLK:
                self.show_about()
            elif event in (WM_RBUTTONUP, WM_CONTEXTMENU):
                self.show_tray_menu()
            return 0

        if message == WM_DESTROY:
            self.remove_mouse_hook()
            self.remove_keyboard_hook()
            self.remove_tray_icon()
            user32.PostQuitMessage(0)
            return 0

        return user32.DefWindowProcW(hwnd, message, wparam, lparam)

    def next_profile(self) -> None:
        self.profile_index = (self.profile_index + 1) % len(PROFILE_ORDER)
        self.show_profile_context()

    def previous_profile(self) -> None:
        self.profile_index = (self.profile_index - 1) % len(PROFILE_ORDER)
        self.show_profile_context()

    def set_profile(self, profile_index: int) -> None:
        self.profile_index = profile_index
        self.show_profile_context()

    def show_profile_context(self) -> None:
        previous_profile = PROFILE_ORDER[(self.profile_index - 1) % len(PROFILE_ORDER)]
        current_profile = PROFILE_ORDER[self.profile_index]
        next_profile = PROFILE_ORDER[(self.profile_index + 1) % len(PROFILE_ORDER)]
        self.show_popup(previous_profile, current_profile, next_profile)

    def show_popup(self, previous_profile: str, current_profile: str, next_profile: str) -> None:
        if not self.popup_hwnd:
            self.popup_hwnd = user32.CreateWindowExW(
                WS_EX_TOPMOST | WS_EX_TOOLWINDOW | WS_EX_NOACTIVATE,
                self.class_name,
                "",
                WS_POPUP | WS_BORDER,
                0,
                0,
                0,
                0,
                None,
                None,
                self.instance,
                None,
            )
            if not self.popup_hwnd:
                raise_last_error("Unable to create the profile popup")

            self.previous_label_hwnd = self.create_profile_label()
            self.current_label_hwnd = self.create_profile_label()
            self.next_label_hwnd = self.create_profile_label()

        previous_text = f"Previous: {previous_profile}"
        current_text = f"Current: {current_profile}"
        next_text = f"Next: {next_profile}"
        user32.SetWindowTextW(self.previous_label_hwnd, previous_text)
        user32.SetWindowTextW(self.current_label_hwnd, current_text)
        user32.SetWindowTextW(self.next_label_hwnd, next_text)

        width, height, line_height = self.popup_size((previous_text, current_text, next_text))
        self.layout_profile_labels(width, line_height)
        work_area = self.work_area()
        x = work_area.right - POPUP_MARGIN_PX - width
        y = work_area.top + POPUP_MARGIN_PX

        user32.SetWindowPos(
            self.popup_hwnd,
            HWND_TOPMOST,
            x,
            y,
            width,
            height,
            SWP_NOACTIVATE | SWP_SHOWWINDOW,
        )
        user32.SetTimer(self.hwnd, POPUP_TIMER_ID, POPUP_DURATION_MS, None)

    def create_profile_label(self) -> int:
        label = user32.CreateWindowExW(
            0,
            "STATIC",
            "",
            WS_CHILD | WS_VISIBLE | SS_CENTER | SS_CENTERIMAGE,
            0,
            0,
            0,
            0,
            self.popup_hwnd,
            None,
            self.instance,
            None,
        )
        if not label:
            raise_last_error("Unable to create a profile popup label")

        font = gdi32.GetStockObject(DEFAULT_GUI_FONT)
        user32.SendMessageW(label, WM_SETFONT, font, 1)
        return label

    def popup_size(self, text_lines: tuple[str, str, str]) -> tuple[int, int, int]:
        device_context = user32.GetDC(self.popup_hwnd)
        if not device_context:
            raise_last_error("Unable to measure the popup text")

        try:
            font = gdi32.GetStockObject(DEFAULT_GUI_FONT)
            previous_font = gdi32.SelectObject(device_context, font)
            text_sizes = []
            for text in text_lines:
                text_size = SIZE()
                if not gdi32.GetTextExtentPoint32W(device_context, text, len(text), ctypes.byref(text_size)):
                    raise_last_error("Unable to measure the popup text")
                text_sizes.append(text_size)
            gdi32.SelectObject(device_context, previous_font)
        finally:
            user32.ReleaseDC(self.popup_hwnd, device_context)

        line_height = max(size.cy for size in text_sizes)
        width = max(size.cx for size in text_sizes) + (POPUP_HORIZONTAL_PADDING_PX * 2) + 2
        height = (line_height * 3) + (POPUP_VERTICAL_PADDING_PX * 2) + (POPUP_LINE_GAP_PX * 2) + 2
        return width, height, line_height

    def layout_profile_labels(self, width: int, line_height: int) -> None:
        label_width = width - (POPUP_HORIZONTAL_PADDING_PX * 2) - 2
        y = POPUP_VERTICAL_PADDING_PX + 1

        for label in (self.previous_label_hwnd, self.current_label_hwnd, self.next_label_hwnd):
            user32.SetWindowPos(
                label,
                None,
                POPUP_HORIZONTAL_PADDING_PX,
                y,
                label_width,
                line_height,
                SWP_NOACTIVATE | SWP_SHOWWINDOW,
            )
            y += line_height + POPUP_LINE_GAP_PX

    def work_area(self) -> wintypes.RECT:
        area = wintypes.RECT()
        if user32.SystemParametersInfoW(SPI_GETWORKAREA, 0, ctypes.byref(area), 0):
            return area

        area.left = 0
        area.top = 0
        area.right = user32.GetSystemMetrics(SM_CXSCREEN)
        area.bottom = user32.GetSystemMetrics(SM_CYSCREEN)
        return area

    def show_tray_menu(self) -> None:
        menu = user32.CreatePopupMenu()
        if not menu:
            raise_last_error("Unable to create the tray menu")

        try:
            user32.AppendMenuW(menu, MF_STRING, ID_ABOUT, "About RRC Profile Popup")
            user32.AppendMenuW(menu, MF_STRING, ID_TEST, "Test profile popup")
            user32.AppendMenuW(menu, MF_SEPARATOR, 0, None)
            self.add_profile_selection_menu(menu)
            user32.AppendMenuW(menu, MF_SEPARATOR, 0, None)
            user32.AppendMenuW(menu, MF_STRING, ID_EXIT, "Exit")

            cursor = wintypes.POINT()
            user32.GetCursorPos(ctypes.byref(cursor))
            user32.SetForegroundWindow(self.hwnd)
            user32.TrackPopupMenu(menu, TPM_RIGHTBUTTON, cursor.x, cursor.y, 0, self.hwnd, None)
        finally:
            user32.DestroyMenu(menu)

    def add_profile_selection_menu(self, parent_menu: int) -> None:
        profile_menu = user32.CreatePopupMenu()
        if not profile_menu:
            raise_last_error("Unable to create the profile selection menu")

        for index, profile in enumerate(PROFILE_ORDER):
            flags = MF_STRING | (MF_CHECKED if index == self.profile_index else 0)
            user32.AppendMenuW(profile_menu, flags, ID_SET_PROFILE_BASE + index, profile)

        user32.AppendMenuW(parent_menu, MF_POPUP, profile_menu, "Set popup profile")

    def show_about(self) -> None:
        user32.MessageBoxW(
            self.hwnd,
            "This standalone helper monitors the configured mouse buttons or keyboard keys and follows the same "
            "profile order as RRSCRIPT.lua. "
            f"{self.input_description()} selects the previous profile and {self.next_input_description()} selects the next profile. "
            "It does not receive messages from or "
            "access files through Logitech G HUB.\n\n"
            "Set INITIAL_PROFILE and the active input-mode fields before "
            "starting it. If the popup gets out of sync, right-click the tray icon and choose Set popup profile, then select the weapon currently active in G HUB. Right-click the tray icon and select Exit to close it.",
            "About RRC Profile Popup",
            MB_OK | MB_ICONINFORMATION,
        )


def main() -> None:
    parser = argparse.ArgumentParser(description="Standalone configurable mouse/keyboard profile popup for RRSCRIPT.lua.")
    parser.add_argument("--validate-only", action="store_true", help="Validate the local configuration without starting the helper.")
    arguments = parser.parse_args()

    try:
        validate_configuration()
    except ValueError as error:
        raise SystemExit(str(error)) from error

    if arguments.validate_only:
        if INPUT_MODE == "mouse":
            previous_input = f"Mouse {PREVIOUS_PROFILE_MOUSE_BUTTON}"
            next_input = f"Mouse {NEXT_PROFILE_MOUSE_BUTTON}"
        else:
            previous_input = f"Key {keyboard_key_label(PREVIOUS_PROFILE_KEY)}"
            next_input = f"Key {keyboard_key_label(NEXT_PROFILE_KEY)}"
        print(
            "Profile popup configuration is valid "
            f"({INITIAL_PROFILE} starts; {previous_input} goes back; {next_input} goes forward)."
        )
        return

    global APP
    APP = ProfilePopupApp()
    APP.run()


if __name__ == "__main__":
    main()
