# FlowNote

FlowNote is a small Windows voice-dictation desktop app. Speak into its editor, then edit, copy, or save your transcript as a UTF-8 text file.

## Run

1. Use Windows 10 or 11 with Windows PowerShell 5.1.
2. Make sure a microphone is connected and Windows has a speech recognition language installed for it.
3. Double-click `Run-FlowNote.cmd`.
4. Choose an installed speech language and select **Start dictating** (or press **Ctrl+Enter**).

Speech recognition uses the installed Windows speech engine. Results depend on the language and recognition components available on your PC. The app does not send audio to an AI service.

## If dictation does not work

1. In Windows, open **Settings > Privacy & security > Microphone** and enable microphone access and desktop-app access.
2. Open **Settings > System > Sound > Input**, choose the microphone you are using, and confirm its input volume is up.
3. In FlowNote, select the speech language that matches the language you are speaking.
4. Speak after selecting **Start dictating**. The **Mic** meter should respond to microphone audio. After 15 seconds of silence, FlowNote explains whether it detected microphone audio.

## Included

- Live speech-to-text in an editable transcript.
- Selection of installed Windows speech recognition languages.
- Microphone activity meter and feedback for rejected speech or unavailable audio.
- Copy, save, and new-draft actions.
- Word count and a Ctrl+Enter dictation shortcut.

FlowNote is a starter version: dictation goes into its own editor, rather than automatically typing into every other app. Your draft is kept in memory until you save or copy it.
