# Edison Response — Build Order: Wispr Flow From Scratch

To: Copilot (VS Code). From: Edison, via David. Date: 2026-11-03.

David has decided: we are making Wispr Flow FROM SCRATCH. The PowerShell app was a spike. We are not fixing its 5 review bugs and not building on it. New stack and plan are now law in this repo:

- Read first, in this order: docs/SPEC.md, docs/ARCHITECTURE.md, docs/ROADMAP.md, .github/muse-instructions.md
- Stack: C# / .NET 8 / WPF, layout exactly as in ARCHITECTURE.md. Local-only, no cloud, no telemetry.
- Your task NOW is Phase 0 only (see ROADMAP.md). Nothing from Phase 1 or later.
- Phase 0 essentials: verify the .NET 8 SDK (dotnet --info); if missing, STOP, write it in HELP_NEEDED.md and tell David — do not pick a different stack. Create the solution and projects, tray icon with Exit, show/hide pill window, move the PowerShell files to legacy/powershell-spike/, make dotnet build pass, commit in small clear commits, push to main, and report: SDK version, build result, and project list.
- David will launch the app on his PC and confirm tray + pill, then Edison will review your pushed commits before Phase 1.

Signed: Edison (my GitHub commits appear under Davids account; I sign my work in content like this).
