# FlowNote Spec — Clean-Room Wispr Flow Clone (from scratch)

Owner: David. Platform: Windows 11. Build starts 2026-11-03.
This spec is the product contract. If code and spec disagree, stop and flag it in HELP_NEEDED.md.

## What FlowNote is
Press a global hotkey anywhere in Windows, speak, release/press again, and cleaned text appears at the cursor in the app you were already using. Everything — capture, transcription, cleanup — runs locally on the PC.

## Non-negotiables
- LOCAL-ONLY processing: audio and text never leave the PC. No cloud transcription, no telemetry. The only allowed download is a speech model file, only when David explicitly starts it.
- Clean-room: no Wispr binaries, code, private APIs, branding, sounds, or assets. Behavior targets come from research/wispr-observation.md.
- Works in other apps: Notepad, VS Code, Chrome text fields are the acceptance apps for v1.
- Fail visibly, never silently: no mic, no model, injection failure, or low confidence must show a clear pill/status message.
- Audio is not retained by default. History stores TEXT only, locally, and can be cleared.

## Core flow (v1)
1. App lives in the system tray, near-zero footprint when idle.
2. Global hotkey starts capture (toggle mode default; hold-to-talk mode in settings). A small floating pill appears near the bottom-center: state, live mic level, elapsed time, cancel button.
3. Hotkey again (or release in hold mode) stops capture. Pill shows Processing.
4. Local Whisper transcription produces raw text.
5. Cleanup pass (rules, section below) produces final text.
6. Final text is inserted at the cursor of the window that was focused when capture STARTED. Pill flashes Done and fades.
7. Esc at any point cancels with nothing inserted.

## Cleanup rules (v1, deterministic, no invention)
- Remove fillers: um, uh, er, hmm (and repeated filler sequences).
- Collapse repeated words and false-start fragments when unambiguous.
- Fix spacing around punctuation; ensure sentence capitalization; end final sentence cleanly.
- Spoken commands: "new line", "new paragraph", "full stop", "comma", "question mark", "exclamation mark" — only when they appear as clear commands, with examples in tests.
- Self-correction pattern "X, actually Y" / "no, Y": keep Y. Conservative: when unsure, keep the literal words.
- NEVER add facts, names, numbers, or intent that were not spoken.

## v1 scope (in)
Tray app, global hotkey (toggle + hold), recording pill with level meter and states (Idle, Listening, Processing, Inserting, Done, Error, Cancelled), local Whisper transcription with a model picker (tiny/base/small, default base), cleanup rules above, text insertion (clipboard-paste primary, typed fallback), personal dictionary (list of words/phrases biasing transcription and protected from cleanup), text-only history (view, copy, delete, clear-all), settings (hotkey, mode, model, language auto/default, start with Windows), first-run setup that checks mic and model.

## Out of scope for v1
Cloud anything, accounts, sync, mobile, macOS/Linux, team features, meeting notes, local-LLM cleanup (possible v2 via Ollama, off by default), snippets (v2), per-app styles (v2).

## Acceptance tests (David runs these; record results in docs/TEST_LOG.md)
A1. In Notepad: dictate "hello world this is a test" -> cleaned text lands in Notepad, FlowNote editor not involved.
A2. Same in a VS Code file and in a Chrome text box.
A3. Say: "um uh send the report on friday actually saturday" -> result keeps Saturday, drops fillers and Friday.
A4. Say a sentence, press Esc mid-recording -> nothing is inserted anywhere.
A5. Mute/unplug mic, start dictation -> clear error in pill, app does not crash.
A6. Clipboard safety: copy something first, dictate, afterwards your original clipboard content is restored if paste-insert was used.
A7. Airplane mode: full flow still works end to end.
