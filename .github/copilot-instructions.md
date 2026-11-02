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

## Current state — FROM-SCRATCH BUILD (supersedes all earlier backlog notes)
- David decided on 2026-11-03 to build Wispr Flow from scratch. The PowerShell FlowNote.ps1 app is a throwaway spike that will be moved to legacy/powershell-spike/. Do NOT fix its earlier review bugs and do NOT build new features on it.
- New stack: C# / .NET 8 / WPF. Product contract: docs/SPEC.md. Design: docs/ARCHITECTURE.md. Build order: docs/ROADMAP.md, one phase at a time, with an Edison review gate between phases.
- Current order from Edison is in EDISON_RESPONSE.md: Phase 0 (foundation) only.
