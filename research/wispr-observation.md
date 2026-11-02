# Wispr Flow behavioral research

**Status:** Phase 1 research draft; awaiting hands-on observations and product-owner confirmation.
**Researched:** 2026-11-03
**Reference platform:** Windows 11 Home Single Language (confirmed by the product owner).
**Requested transcription preference:** Local-only.

This is clean-room behavioral research from public product materials and user-provided observations. It does not use Wispr Flow binaries, source code, private APIs, or copied product assets. Public marketing claims are labeled as such. Behavior not established by the available sources remains explicitly unverified.

## Evidence legend

- **Publicly documented:** stated in a public Wispr Flow product page, help article, product listing, or release note.
- **Demonstrated:** shown in the public interactive demo or its written example.
- **Unverified:** public sources reviewed so far do not specify the behavior; requires direct testing.
- **Our product requirement:** a design constraint for this clean-room project, not a claim about Wispr Flow.

## Core flow

| Question | Current observation | Evidence / confidence |
|---|---|---|
| How dictation starts | The public demo instructs users to **press and hold Control** and start speaking. This documents the demo's interaction; it does not prove that the installed Windows app has the same default binding. | Demonstrated; medium confidence. [Interactive demo](https://wisprflow.ai/demo) |
| Hold versus toggle | Hold-to-talk is demonstrated by the wording “press and hold.” Whether the installed Windows app also supports toggle mode, configurable modifiers, or a different default is unverified. | Hold-to-talk: medium; desktop settings: unknown. |
| When capture starts | The privacy page says audio is captured on-device when the user presses the shortcut, and that nothing is captured before the shortcut is pressed. | Publicly documented; high confidence. [Privacy](https://wisprflow.ai/privacy) |
| Recording UI / states | The public site demonstrates spoken input, a “Cleaning up...” state, and a cleaned result. Release notes refer to a desktop dictation pill and report a microphone-no-sound warning. Exact pill layout and the full idle/listening/processing/inserting transition sequence need a user recording. | Processing and pill exist: high; exact UI states: unverified. [Product demo](https://wisprflow.ai/), [release notes](https://wisprflow.ai/whats-new) |
| Sound and animation | The help center says desktop start, stop, paste, lock, and achievement sounds can be disabled in Settings → System → Sound. The exact sound assets, animation, and visual feedback remain unverified. We will not copy proprietary sound or visual assets. | Publicly documented sounds: high; appearance: unverified. [Microphone guide](https://docs.wisprflow.ai/articles/9192039587-using-wispr-flow-discreetly-microphone-guide?lang=en) |
| Stop / insert | The public demo implies the shortcut-held utterance is transformed and entered into the destination text field. Exact stop timing, partial/final transcript timing, and error/retry behavior are unverified. | Basic dictation outcome: high; implementation/timing: unknown. |

## Text insertion and cleanup

Wispr Flow publicly describes working in text boxes across apps and websites; its Windows Store listing names Outlook, Word, Teams, browsers, ChatGPT, Claude, and VS Code. This does **not** establish how the product injects text (accessibility APIs, simulated typing, clipboard paste, or a fallback chain). That implementation is unverified.

| Cleanup behavior | Public evidence |
|---|---|
| Filler words and false starts | Product pages say fillers and false starts are removed. A public example removes “um,” “uh,” and a false start while preserving the message. |
| Self-corrections | Public examples change “meet at 4 pm, actually 3 pm” to “meet at 3 pm” and “not Friday, the following Monday” to Monday. These are marketing examples, not a guarantee for every ambiguous utterance. |
| Repeated words | Public examples show duplicate words being removed. |
| Punctuation and capitalization | Product pages say punctuation and capitalization are cleaned up. |
| Paragraphs and lists | Product pages and the public demo show structured paragraphs and a numbered grocery list. |
| App-aware tone and formatting | Public pages say Flow considers the current app and can apply styles (for example, more formal in documents and casual in messages). The data-controls page also says the app name is always used to format dictation. |
| Invention constraint | **Our product requirement:** cleanup must not add facts, names, commitments, or intent absent from the spoken text. Public examples do not establish how Wispr prevents invention. |
| Live versus post-utterance editing | The feature page says Flow edits as you speak, and the website shows a “Cleaning up...” step. Precise streaming, revision, or replacement behavior in the Windows app is unverified. |

Sources: [Wispr Flow home](https://wisprflow.ai/), [features](https://wisprflow.ai/features), [interactive demo](https://wisprflow.ai/demo), [Windows Store listing](https://apps.microsoft.com/detail/xp88w11pj2v0t8).

## Voice commands and personalization

| Capability | Current finding |
|---|---|
| Spoken editing commands | The public data-controls page mentions **Command Mode** and surrounding text context, but the reviewed material does not establish exact supported phrases or trigger rules. “New paragraph,” “scratch that,” and “make that formal” must not be presented as confirmed Wispr commands without testing. |
| Personal dictionary | Public pages describe adding terms manually and automatically learning corrected spellings. |
| Snippets | Public pages describe speaking a shortcut/cue to expand a saved phrase or formatted text. |
| Styles | Public feature page describes per-context writing styles; it says this feature is English-only and desktop-only. |
| Custom prompts | The Microsoft Store listing advertises custom prompts. Availability and exact behavior on Windows remain unverified. |
| Team vocabulary / snippets | Public feature page advertises shared dictionaries and snippets for teams; not needed in a first local-only release. |

Sources: [features](https://wisprflow.ai/features), [data controls](https://wisprflow.ai/data-controls), [Windows Store listing](https://apps.microsoft.com/detail/xp88w11pj2v0t8).

## Edge cases, privacy, and app surfaces

| Topic | Current observation |
|---|---|
| No microphone / no sound | A desktop release note says Flow warns when the microphone registers no sound. The help center recommends selecting a microphone manually, checking the live volume meter, and ensuring the OS and app use the same device. |
| Microphone selection | Help documentation describes Settings → General → Microphone → Change, selecting an input, and checking its live volume meter. Exact Windows UI should be confirmed by the tester. |
| No internet | **Unverified in Wispr.** The data-controls page says transcription occurs in the cloud. The product owner specifically requests local-only transcription in our MVP, so offline local inference is a product requirement even though it differs from Wispr's documented cloud transcription. |
| Long dictation | Maximum length, buffering behavior, interruption recovery, and performance are unverified. |
| Language | Product pages advertise 100+ languages and automatic language detection. Actual Windows language handling and mixed-language behavior need testing. |
| Code / email / chat | Public use-case pages promote use in VS Code, email, Slack, ChatGPT, and other apps. Public pages advertise app-aware style and developer syntax awareness. Exact formatting and insertion fidelity require testing. |
| Privacy and retention | Wispr's data-controls page says transcription occurs in the cloud; dictation cloud storage is separately configurable. The privacy page describes local history and retention options. This is separate from our requested local-only transcription and local storage. |
| History / settings | Public privacy/help pages establish data and sound settings, and describe local dictation history. Exact history screens, tray/menu interactions, onboarding, retention defaults, and Windows navigation remain unverified. |
| Sounds | Desktop sounds for start, stop, paste, lock, and achievements can be disabled in Settings → System → Sound. |
| App integrations | Product listing and use-case pages claim operation in text fields across apps without requiring a plugin. Exact secure-field, elevated-app, browser, and accessibility behavior remains unverified. |

Sources: [microphone guide](https://docs.wisprflow.ai/articles/9192039587-using-wispr-flow-discreetly-microphone-guide?lang=en), [release notes](https://wisprflow.ai/whats-new), [privacy](https://wisprflow.ai/privacy), [data controls](https://wisprflow.ai/data-controls), [use cases](https://wisprflow.ai/use-cases).

## Onboarding, tray, and history

- The public get-started page offers sign-in with Google, Apple, Microsoft, or SSO. The app onboarding steps and whether sign-in is required before Windows dictation are unverified.
- Wispr describes the desktop application as running in the background. The presence and exact contents of a Windows tray menu need direct observation.
- Public privacy materials establish history/retention controls, but the history page layout, search, editing, export, and default retention are unverified.
- The public changelog mentions the desktop pill, theme settings, sound controls, and microphone warnings. It does not fully specify the visual state machine.
- Public media includes a company YouTube channel, but a specific Windows product walkthrough was not verified during this research pass. The interactive demo was accessible and documents press-and-hold Control.

Sources: [get started](https://wisprflow.ai/get-started), [public YouTube channel](https://www.youtube.com/@WisprFlow), [What's new](https://wisprflow.ai/whats-new).

## Feature matrix proposal

| Priority | Candidate scope | Rationale / notes |
|---|---|---|
| **Must-Have (MVP)** | Windows background/tray app; configurable push-to-talk global hotkey; visible recording pill with timer and live microphone feedback; record → local transcription → review/cleanup → insert at current caret; clear cancel, no-mic, and transcription-error paths; basic punctuation/capitalization and conservative cleanup; local settings and a privacy-first default. | Matches the cross-app, low-friction core. Local-only transcription and no cloud sync follow the product owner's explicit preference, not Wispr's cloud-transcription behavior. Exact hotkey and insertion UX should be confirmed with the tester. |
| **Should-Have (V2)** | Per-app styles; dictionary and autocorrect learning; snippets; spoken editing commands; longer-dictation recovery; history search/retention/export; language auto-detection; additional local model choices; richer diff/review UI; app-specific formatting for email, chat, lists, and code. | These are valuable personalization and reliability improvements but expand model, UI, and settings scope. |
| **Skip for now** | Cloud accounts/sync; team dictionary/admin; meeting notetaker; mobile clients; cloud transcription; organization analytics, SSO, compliance features; custom prompt marketplace; copied Wispr branding, logos, sound, or visual assets. | Outside a Windows, local-only MVP and/or requires backend/account infrastructure. Revisit only if the product owner changes scope. |

**Product-owner feedback:** The tester does not currently have Wispr Flow installed and has not performed a hands-on test. They asked for similar features to be treated as must-have. The exact feature-parity boundary still needs confirmation; the table above is a proposal, not approved scope.

**Approval gate:** Phase 2 must wait until the product owner confirms or edits the feature matrix. A hands-on install is not required: the public interactive demo can provide limited observations about hold-to-talk and text cleanup, but cannot verify the native Windows app's tray, pill, global shortcut, or settings.

## First hands-on observation checklist

Wispr Flow observations supplied by the product owner so far: **the desktop app is not installed; no hands-on test has been performed**. If desired, use the public [interactive demo](https://wisprflow.ai/demo) first; it does not require the desktop app. Do not dictate private information into a public demo. If you later install the Windows app, record its version and a screenshot or brief screen recording if convenient:

1. In a plain text field (for example Notepad), press the default dictation shortcut and keep it held for one short sentence. Note the exact key shown in onboarding/settings, whether recording starts immediately, and whether it stops when you release.
2. Try the same shortcut with a brief press-and-release. Does it toggle recording, or do nothing?
3. During speech, note the pill's text, position, waveform/meter, timer, and any sound or animation. After you stop, note whether there is a separate processing state and when text appears.
4. Say: “Um, message Sam: meet at four—actually, six. New paragraph. Bring the draft.” Record the exact inserted text and whether “New paragraph” is treated as a command or literal words.
5. Test microphone feedback by opening the microphone picker/meter if available. Note whether the meter responds, which input is selected, and any warning when the mic is muted or unavailable (do not change privacy permissions without noting it).
6. Note what appears in the tray/menu, and whether the app exposes history, dictionary, snippets, or styles.

No screen recording is required; concise notes are sufficient. Avoid recording sensitive conversations or sharing unrelated private information.
