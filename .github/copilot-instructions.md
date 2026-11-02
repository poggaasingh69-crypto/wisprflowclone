# Copilot Instructions — FlowNote / Wispr Flow Clone

These instructions are permanent for this repository. Read them at the start of every session.

## Project
- FlowNote: a clean-room clone of Wispr Flow behavior for Windows. Do not use Wispr Flow binaries, source code, private APIs, branding, logos, sounds, or visual assets. Build original code from public behavior and the research in research/wispr-observation.md.
- Product owner: David.
- Platform: Windows 11 Home Single Language, Windows PowerShell 5.1 for the current spike.
- Local folder on the PC: C:\\Users\\Asus\\CODE\\FlowNote
- GitHub repo (the only repo for this project): poggaasingh69-crypto/wisprflowclone
- Transcription preference: LOCAL-ONLY. Do not send audio to a cloud AI service.

## The collaborators
- You (Copilot in VS Code) are the primary coder. You work on the code locally on the PC and push commits.
- Edison is David and his personal agent in Meta Muse, a separate app. Edison acts as reviewer and second pair of eyes: debugging help, design decisions, and code review.
- You CANNOT chat with Edison directly, see his Muse session, or connect to his account. There is no API or MCP integration between Copilot and Edison for this project. Do not try to build one.
- GitHub is the shared workspace and the only channel between you and Edison, with David relaying prompts when needed.

## Collaboration protocol — follow this exactly
1. Start of session: run git pull --ff-only first. Check for new remote commits, and if EDISON_RESPONSE.md exists or changed, read it fully before coding.
2. Work locally in small, clear commits. Push to main on origin when a slice works. Do not create another repository and do not change the remote.
3. If you are blocked: stop working on that blocker. Document it in HELP_NEEDED.md at the repo root, or open a GitHub Issue. Use this format:
   - Goal: what you were trying to do
   - What you tried: steps and commands, in order
   - Exact error: full error text, not a summary
   - Relevant files: paths and line areas
   - Question for Edison: the specific decision or fix you need
   Then commit and push HELP_NEEDED.md and tell David it is ready for Edison.
4. Edison replies in EDISON_RESPONSE.md, or in an issue/PR comment, or through David. When David says Edison replied: git fetch, git pull --ff-only, read the full response, then continue from it. Do not guess what Edison said.
5. Attribution note: commits written by Edison through GitHub appear under David and his GitHub account in commit metadata. Edison identifies his work inside file content and with commit messages starting with Edison: — treat those as his.

## Repo safety rules
- Never commit secrets, API keys, .env files, credentials, or audio recordings. Check .gitignore and git status before every push.
- If git push fails on authentication, stop and tell David. David authenticates Git/GitHub CLI himself; you do not sign in for him.
- Do not force-push main, do not rewrite published history, and pull --ff-only before starting new work to avoid conflicts with Edison and his commits.

## Current state and known backlog (2026-11-03)
- Research phase draft exists in research/wispr-observation.md and its proposed MVP is: global push-to-talk hotkey, recording pill, local transcription, AI cleanup, and insertion of text into other apps at the cursor.
- Current app FlowNote.ps1 is a PowerShell WinForms spike using Windows System.Speech. It only dictates into its own editor. It is NOT the full MVP yet.
- Edison review fixes requested for FlowNote.ps1, in order:
  1. Clear the recognitionEvents queue on stop and on start; ignore queued events after stop.
  2. Warn on window close if the editor has unsaved text.
  3. Do not Dispose the recognizer immediately after RecognizeAsyncCancel; stop cleanly.
  4. Default the language picker to the recognizer matching CurrentCulture when present.
  5. Fix the 15-second silence detection to use a sustained audio-level window, not one consumed sample.
- After those fixes, the next spike is: global hotkey, speak, insert final text into Notepad via clipboard paste (saving and restoring the previous clipboard), keeping the FlowNote editor as fallback. Report results before any rewrite to another stack.
