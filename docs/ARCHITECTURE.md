# FlowNote Architecture (from scratch)

## Stack decision — and why
- C# / .NET 8 / WPF. Windows-only v1 makes native Win32 interop (global hotkeys, foreground-window tracking, SendInput injection, WASAPI audio, tray) far more reliable than Electron/Tauri or the PowerShell spike. One language, one toolchain, real tests.
- The PowerShell app (FlowNote.ps1) is a THROWAWAY SPIKE. It proved dictation-in-a-window; it is not the foundation. Do not fix its 5 review bugs and do not port its code line by line. Copilot will move it to legacy/powershell-spike/ in a separate tidy-up commit after the new solution builds.

## Solution layout
- src/FlowNote.App — WPF app: tray icon, floating pill window, settings window, history window, app startup, DI composition.
- src/FlowNote.Core — pipeline state machine, cleanup rules, dictionary, history/settings models and service interfaces. No Win32, no WPF here — fully unit-testable.
- src/FlowNote.Audio — NAudio WASAPI capture at 16 kHz mono, level meter events, in-memory WAV buffer. No files by default.
- src/FlowNote.Transcription — Whisper.net (whisper.cpp) engine wrapper. Model manager: models stored in %AppData%/FlowNote/models, downloaded only on explicit user action, verified by size/hash where practical.
- src/FlowNote.Injection — foreground window capture at record-start, insertion via (1) clipboard save + Ctrl+V + restore, (2) fallback SendInput unicode typing for short text / paste-blocked fields, with success/failure result reported to the pipeline.
- tests/FlowNote.Core.Tests — xUnit tests, cleanup rules first (they are pure functions and must be test-driven).

## Pipeline
States: Idle -> Listening -> Processing -> Inserting -> Idle, with Error and Cancelled reachable from any active state. One dictation session at a time. All state changes go through FlowNote.Core DictationPipeline; the pill only renders state. Recognizer output enters Core on a background thread; UI updates only via the WPF dispatcher (the spike taught us why: cross-thread UI access crashes).

## Key technical risks (tackle in this order)
1. Text insertion reliability across apps — Phase 3 spike proves it early, before polishing anything.
2. Global hotkey behavior with modifier keys — use RegisterHotKey for the toggle combo; hold-to-talk may need a low-level keyboard hook. Keep the hook isolated in FlowNote.App and make sure it can never swallow keystrokes when FlowNote is not recording.
3. Whisper model size/speed on Davids PC — default base; keep tiny as the fallback if base is too slow. Measure and log timings from Phase 2 onward.
4. Focus theft — the pill must never take focus away from the target app (use WS_EX_NOACTIVATE style), or insertion lands in the pill itself.

## Data and privacy
- Settings: %AppData%/FlowNote/settings.json. History: SQLite at %AppData%/FlowNote/history.db, text + timestamp + target app name only. Dictionary: %AppData%/FlowNote/dictionary.json. Logs: rolling local text log, no transcript content in logs by default.
- No network calls in the app except the explicitly user-started model download.
