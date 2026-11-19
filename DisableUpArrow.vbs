Option Explicit

Dim fso, shell, tempPath, psPath, ts, ps

Set fso = CreateObject("Scripting.FileSystemObject")
Set shell = CreateObject("WScript.Shell")

tempPath = shell.ExpandEnvironmentStrings("%TEMP%")
psPath = tempPath & "\BlockUpArrow.ps1"

ps = ""

ps = ps & "Add-Type -TypeDefinition @'" & vbCrLf
ps = ps & "using System;" & vbCrLf
ps = ps & "using System.Runtime.InteropServices;" & vbCrLf
ps = ps & "" & vbCrLf
ps = ps & "public static class UpArrowBlocker" & vbCrLf
ps = ps & "{" & vbCrLf
ps = ps & "    private const int WH_KEYBOARD_LL = 13;" & vbCrLf
ps = ps & "    private const int VK_UP = 0x26;" & vbCrLf
ps = ps & "    private delegate IntPtr HookProc(int nCode, IntPtr wParam, IntPtr lParam);" & vbCrLf
ps = ps & "    private static HookProc callback = HookCallback;" & vbCrLf
ps = ps & "    private static IntPtr hook = IntPtr.Zero;" & vbCrLf
ps = ps & "" & vbCrLf
ps = ps & "    [StructLayout(LayoutKind.Sequential)]" & vbCrLf
ps = ps & "    private struct MSG {" & vbCrLf
ps = ps & "        public IntPtr hwnd;" & vbCrLf
ps = ps & "        public uint message;" & vbCrLf
ps = ps & "        public UIntPtr wParam;" & vbCrLf
ps = ps & "        public IntPtr lParam;" & vbCrLf
ps = ps & "        public uint time;" & vbCrLf
ps = ps & "        public POINT pt;" & vbCrLf
ps = ps & "    }" & vbCrLf
ps = ps & "" & vbCrLf
ps = ps & "    [StructLayout(LayoutKind.Sequential)]" & vbCrLf
ps = ps & "    private struct POINT {" & vbCrLf
ps = ps & "        public int x;" & vbCrLf
ps = ps & "        public int y;" & vbCrLf
ps = ps & "    }" & vbCrLf
ps = ps & "" & vbCrLf
ps = ps & "    [DllImport(""user32.dll"", SetLastError = true)]" & vbCrLf
ps = ps & "    private static extern IntPtr SetWindowsHookEx(int idHook, HookProc lpfn, IntPtr hMod, uint dwThreadId);" & vbCrLf
ps = ps & "    [DllImport(""user32.dll"")]" & vbCrLf
ps = ps & "    private static extern bool UnhookWindowsHookEx(IntPtr hhk);" & vbCrLf
ps = ps & "    [DllImport(""user32.dll"")]" & vbCrLf
ps = ps & "    private static extern IntPtr CallNextHookEx(IntPtr hhk, int nCode, IntPtr wParam, IntPtr lParam);" & vbCrLf
ps = ps & "    [DllImport(""user32.dll"", SetLastError = true)]" & vbCrLf
ps = ps & "    private static extern int GetMessage(out MSG msg, IntPtr hwnd, uint min, uint max);" & vbCrLf
ps = ps & "    [DllImport(""user32.dll"")]" & vbCrLf
ps = ps & "    private static extern bool TranslateMessage(ref MSG msg);" & vbCrLf
ps = ps & "    [DllImport(""user32.dll"")]" & vbCrLf
ps = ps & "    private static extern IntPtr DispatchMessage(ref MSG msg);" & vbCrLf
ps = ps & "" & vbCrLf
ps = ps & "    private static IntPtr HookCallback(int nCode, IntPtr wParam, IntPtr lParam) {" & vbCrLf
ps = ps & "        if (nCode >= 0) {" & vbCrLf
ps = ps & "            int key = Marshal.ReadInt32(lParam);" & vbCrLf
ps = ps & "            if (key == VK_UP) return (IntPtr)1;" & vbCrLf
ps = ps & "        }" & vbCrLf
ps = ps & "        return CallNextHookEx(hook, nCode, wParam, lParam);" & vbCrLf
ps = ps & "    }" & vbCrLf
ps = ps & "" & vbCrLf
ps = ps & "    public static void Run() {" & vbCrLf
ps = ps & "        hook = SetWindowsHookEx(WH_KEYBOARD_LL, callback, IntPtr.Zero, 0);" & vbCrLf
ps = ps & "        if (hook == IntPtr.Zero) throw new System.ComponentModel.Win32Exception(Marshal.GetLastWin32Error());" & vbCrLf
ps = ps & "        try {" & vbCrLf
ps = ps & "            MSG msg;" & vbCrLf
ps = ps & "            int result;" & vbCrLf
ps = ps & "            while ((result = GetMessage(out msg, IntPtr.Zero, 0, 0)) > 0) {" & vbCrLf
ps = ps & "                TranslateMessage(ref msg);" & vbCrLf
ps = ps & "                DispatchMessage(ref msg);" & vbCrLf
ps = ps & "            }" & vbCrLf
ps = ps & "            if (result == -1) throw new System.ComponentModel.Win32Exception(Marshal.GetLastWin32Error());" & vbCrLf
ps = ps & "        } finally {" & vbCrLf
ps = ps & "            UnhookWindowsHookEx(hook);" & vbCrLf
ps = ps & "        }" & vbCrLf
ps = ps & "    }" & vbCrLf
ps = ps & "}" & vbCrLf
ps = ps & "'@" & vbCrLf
ps = ps & "[UpArrowBlocker]::Run()" & vbCrLf

Set ts = fso.CreateTextFile(psPath, True, False)
ts.Write ps
ts.Close

' Run silently in background
shell.Run "powershell.exe -NoProfile -WindowStyle Hidden -ExecutionPolicy Bypass -File """ & psPath & """", 0, False

Set ts = Nothing
Set fso = Nothing
Set shell = Nothing