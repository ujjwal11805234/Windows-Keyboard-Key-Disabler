# Windows Keyboard Key Disabler

A lightweight Windows utility that allows you to disable a particular keyboard key using VBScript and PowerShell.

This project currently comes configured to disable the **Up Arrow key**, which can be useful when dealing with a faulty or physically damaged laptop keyboard.

You can easily disable any other keyboard key by changing its corresponding Virtual Key (VK) value in the script. No need to modify the core implementation.

## 🚀 Features

- Disable a particular keyboard key.
- Currently configured to block the Up Arrow key.
- Customize the target key by changing its Virtual Key value.
- Runs silently in the background.
- Other keyboard keys continue working normally.
- No third-party software installation required.
- Easy to launch by double-clicking the `.vbs` file.
- Stop the utility through Windows Task Manager.
- Automatically restores the blocked key when the script terminates.

## 🛠️ How It Works

The utility uses:

- **VBScript:** Creates and launches the PowerShell helper script.
- **PowerShell:** Executes the keyboard-blocking functionality.
- **Windows API:** Uses `SetWindowsHookEx` with a low-level keyboard hook to intercept keyboard events.

The target keyboard key is identified using its Virtual Key (VK) code.

## 📥 Installation and Usage

### Step 1: Download the Script

Download `DisableUpArrow.vbs` from this repository.

### Step 2: Run the Script

1. Double-click `DisableUpArrow.vbs`.
2. The script launches silently in the background.
3. The configured keyboard key (Up Arrow by default) will be blocked.
4. All other keyboard keys should continue working normally.

### Step 3: Stop the Script

To enable the blocked key again:

1. Press `Ctrl + Shift + Esc` to open Task Manager.
2. Navigate to the **Details** tab.
3. Locate the PowerShell process running `BlockUpArrow.ps1`.
4. Right-click and select **End task**.

The keyboard hook will be removed, restoring normal keyboard functionality.

## ⚙️ Customize: Disable Any Keyboard Key

You can configure the script to disable a different keyboard key by changing its Virtual Key value.

Locate this line in the embedded C# code:

```csharp
private const int VK_UP = 0x26;
```

Change `0x26` to the Virtual Key code of the keyboard key you want to disable.

### Common Virtual Key Codes

| Keyboard Key | Virtual Key Code |
|---|---|
| Up Arrow | `0x26` |
| Down Arrow | `0x28` |
| Left Arrow | `0x25` |
| Right Arrow | `0x27` |
| Enter | `0x0D` |
| Space | `0x20` |
| Backspace | `0x08` |
| Delete | `0x2E` |
| Escape | `0x1B` |
| Tab | `0x09` |
| Caps Lock | `0x14` |
| F1 | `0x70` |
| F2 | `0x71` |
| F5 | `0x74` |
| A | `0x41` |
| B | `0x42` |

**Example:** To disable the Down Arrow key instead of the Up Arrow key, change:

```csharp
private const int VK_UP = 0x26;
```

To:

```csharp
private const int VK_UP = 0x28;
```

The variable name can remain unchanged; only the Virtual Key value determines which key is blocked.

## 💻 System Requirements

- Windows 10 / Windows 11
- Windows Script Host (VBScript)
- Windows PowerShell
- Permission to execute scripts under your Windows security policies

No additional libraries or third-party applications are required.

## ⚠️ Important Notes

- This is a temporary software workaround, not a hardware repair.
- The keyboard hook blocks the selected key system-wide while active.
- The utility runs invisibly in the background.
- Ending the associated PowerShell process restores the blocked key.
- Sleep mode generally preserves the running process; shutting down terminates it.
- Review the source code before running the script.
- Windows security software or organizational policies may restrict script execution.

## 🤝 Contributions

Contributions, suggestions, and improvements are welcome!

Feel free to fork this repository, improve its functionality, and submit a pull request.

## 📜 License

MIT License.

---

**Built to help Windows users manage faulty or unwanted keyboard keys through a simple script.**

If you find this project useful, consider giving the repository a ⭐ star!
