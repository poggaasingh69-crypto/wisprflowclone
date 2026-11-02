# FlowNote Roadmap — Build Order

Rule for every phase: build it, run the phase tests, push, then STOP. Edison reviews the pushed commit and David runs the manual tests before the next phase starts. If blocked, use HELP_NEEDED.md per the collaboration protocol.

## Phase 0 — Foundation (START HERE)
- Check dotnet SDK: run dotnet --info. If .NET 8 SDK is missing, stop and tell David to install it (winget install Microsoft.DotNet.SDK.8). Do not substitute another stack.
- Move FlowNote.ps1, Run-FlowNote.cmd to legacy/powershell-spike/ (keep README accurate: update its Run section to point at the new build once Phase 1 runs; for now note the spike location).
- Create the solution exactly as in docs/ARCHITECTURE.md: FlowNote.sln, src/ projects, tests/FlowNote.Core.Tests with xUnit.
- App at this stage: starts, shows a tray icon with an Exit menu, and a pill window that can be shown/hidden from the tray. Nothing else.
- Done when: dotnet build succeeds with no warnings-as-errors failures, the app launches on Davids PC, tray + pill show, and the commit is pushed. Report the build output summary to David.

## Phase 1 — Hotkey, pill, audio
Global hotkey (default Ctrl+Alt+Space, toggle), pill states Listening with live level meter from NAudio capture, Esc cancels, foreground window is recorded at start. No transcription yet — pill shows captured seconds and peak level on stop.
Tests: manual M1 — from Notepad, hotkey, speak 5 seconds, hotkey: pill showed Listening, meter moved, stop summary matches. Esc test: cancel works and no state gets stuck.

## Phase 2 — Local transcription
Whisper.net integration, model manager (tiny/base/small, explicit download), transcribe the Phase 1 buffer, show RAW transcript in the pill with timing.
Tests: M2 — dictate a known sentence; raw transcript is recognizably correct in airplane mode. Log transcription time.

## Phase 3 — Insertion (the make-or-break phase)
Clipboard-paste insertion into the recorded foreground window with clipboard restore, SendInput typing fallback, clear failure state in the pill.
Tests: acceptance A1, A2, A6 from docs/SPEC.md.

## Phase 4 — Cleanup
Test-driven cleanup rules from docs/SPEC.md in FlowNote.Core (tests first), wired between transcription and insertion, raw-vs-cleaned shown in history detail.
Tests: acceptance A3, plus the unit suite green.

## Phase 5 — Dictionary, history, settings
Dictionary UI + transcription biasing, history window over SQLite, settings window (hotkey, hold-vs-toggle, model, language, autostart).
Tests: acceptance A5, A7, plus dictionary word survives cleanup.

## Phase 6 — Packaging
Autostart polish, single-command build script, installer (MSIX or Inno Setup — decide with Edison), README rewrite with real install/run steps.
