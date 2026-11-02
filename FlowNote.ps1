$ErrorActionPreference = 'Stop'

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName System.Speech

[System.Windows.Forms.Application]::EnableVisualStyles()

$script:recognitionEvents = [System.Collections.Concurrent.ConcurrentQueue[object]]::new()
$script:lastSpeechTime = [datetime]::MinValue
$script:lastAudioLevel = 0
$script:recognizer = $null

$colors = @{
    Background = [System.Drawing.Color]::FromArgb(16, 18, 24)
    Surface    = [System.Drawing.Color]::FromArgb(25, 28, 37)
    Editor     = [System.Drawing.Color]::FromArgb(20, 23, 31)
    Text       = [System.Drawing.Color]::FromArgb(239, 241, 247)
    Muted      = [System.Drawing.Color]::FromArgb(151, 158, 175)
    Accent     = [System.Drawing.Color]::FromArgb(111, 92, 255)
    Border     = [System.Drawing.Color]::FromArgb(47, 51, 65)
    Green      = [System.Drawing.Color]::FromArgb(83, 207, 151)
}

$form = New-Object System.Windows.Forms.Form
$form.Text = 'FlowNote - Voice typing'
$form.StartPosition = 'CenterScreen'
$form.Size = New-Object System.Drawing.Size(940, 700)
$form.MinimumSize = New-Object System.Drawing.Size(720, 560)
$form.BackColor = $colors.Background
$form.ForeColor = $colors.Text
$form.Font = New-Object System.Drawing.Font('Segoe UI', 10)
$form.KeyPreview = $true

$layout = New-Object System.Windows.Forms.TableLayoutPanel
$layout.Dock = 'Fill'
$layout.Padding = New-Object System.Windows.Forms.Padding(28, 20, 28, 20)
$layout.ColumnCount = 1
$layout.RowCount = 4
[void]$layout.ColumnStyles.Add((New-Object System.Windows.Forms.ColumnStyle([System.Windows.Forms.SizeType]::Percent, 100)))
[void]$layout.RowStyles.Add((New-Object System.Windows.Forms.RowStyle([System.Windows.Forms.SizeType]::Absolute, 88)))
[void]$layout.RowStyles.Add((New-Object System.Windows.Forms.RowStyle([System.Windows.Forms.SizeType]::Absolute, 54)))
[void]$layout.RowStyles.Add((New-Object System.Windows.Forms.RowStyle([System.Windows.Forms.SizeType]::Percent, 100)))
[void]$layout.RowStyles.Add((New-Object System.Windows.Forms.RowStyle([System.Windows.Forms.SizeType]::Absolute, 58)))
$form.Controls.Add($layout)

$header = New-Object System.Windows.Forms.Panel
$header.Dock = 'Fill'

$languagePanel = New-Object System.Windows.Forms.Panel
$languagePanel.Dock = 'Right'
$languagePanel.Width = 270
$header.Controls.Add($languagePanel)

$brand = New-Object System.Windows.Forms.Label
$brand.Text = 'FlowNote'
$brand.Location = New-Object System.Drawing.Point(0, 4)
$brand.AutoSize = $true
$brand.Font = New-Object System.Drawing.Font('Segoe UI Semibold', 24, [System.Drawing.FontStyle]::Bold)
$brand.ForeColor = $colors.Text
$header.Controls.Add($brand)

$subtitle = New-Object System.Windows.Forms.Label
$subtitle.Text = 'Speak naturally. Your words appear here.'
$subtitle.Location = New-Object System.Drawing.Point(2, 48)
$subtitle.AutoSize = $true
$subtitle.Font = New-Object System.Drawing.Font('Segoe UI', 10)
$subtitle.ForeColor = $colors.Muted
$header.Controls.Add($subtitle)

$languageLabel = New-Object System.Windows.Forms.Label
$languageLabel.Text = 'SPEECH LANGUAGE'
$languageLabel.AutoSize = $true
$languageLabel.Location = New-Object System.Drawing.Point(0, 4)
$languageLabel.Font = New-Object System.Drawing.Font('Segoe UI', 8, [System.Drawing.FontStyle]::Bold)
$languageLabel.ForeColor = $colors.Muted
$languagePanel.Controls.Add($languageLabel)

$languagePicker = New-Object System.Windows.Forms.ComboBox
$languagePicker.DropDownStyle = 'DropDownList'
$languagePicker.Location = New-Object System.Drawing.Point(0, 28)
$languagePicker.Size = New-Object System.Drawing.Size(270, 32)
$languagePicker.BackColor = $colors.Surface
$languagePicker.ForeColor = $colors.Text
$languagePicker.FlatStyle = 'Flat'
$languagePicker.Font = New-Object System.Drawing.Font('Segoe UI', 10)
$recognizers = [System.Speech.Recognition.SpeechRecognitionEngine]::InstalledRecognizers()
foreach ($installedRecognizer in $recognizers) {
    $languagePicker.Items.Add([PSCustomObject]@{
        Id      = $installedRecognizer.Id
        Display = ('{0} - {1}' -f $installedRecognizer.Culture.Name, $installedRecognizer.Culture.NativeName)
    }) | Out-Null
}
$languagePicker.DisplayMember = 'Display'
if ($languagePicker.Items.Count -gt 0) {
    $languagePicker.SelectedIndex = 0
}
$languagePanel.Controls.Add($languagePicker)
$layout.Controls.Add($header, 0, 0)

$toolbar = New-Object System.Windows.Forms.FlowLayoutPanel
$toolbar.Dock = 'Fill'
$toolbar.FlowDirection = 'LeftToRight'
$toolbar.WrapContents = $false
$toolbar.Padding = New-Object System.Windows.Forms.Padding(0, 5, 0, 0)

function New-ToolbarButton {
    param(
        [string]$Text,
        [int]$Width
    )

    $button = New-Object System.Windows.Forms.Button
    $button.Text = $Text
    $button.Width = $Width
    $button.Height = 36
    $button.Margin = New-Object System.Windows.Forms.Padding(0, 0, 10, 0)
    $button.FlatStyle = 'Flat'
    $button.FlatAppearance.BorderColor = $colors.Border
    $button.FlatAppearance.BorderSize = 1
    $button.BackColor = $colors.Surface
    $button.ForeColor = $colors.Text
    $button.Font = New-Object System.Drawing.Font('Segoe UI', 9)
    $button.Cursor = [System.Windows.Forms.Cursors]::Hand
    return $button
}

$newButton = New-ToolbarButton -Text 'New draft' -Width 94
$copyButton = New-ToolbarButton -Text 'Copy text' -Width 94
$saveButton = New-ToolbarButton -Text 'Save as...' -Width 94
$toolbar.Controls.AddRange(@($newButton, $copyButton, $saveButton))
$layout.Controls.Add($toolbar, 0, 1)

$editorPanel = New-Object System.Windows.Forms.Panel
$editorPanel.Dock = 'Fill'
$editorPanel.Padding = New-Object System.Windows.Forms.Padding(1)
$editorPanel.BackColor = $colors.Border

$editor = New-Object System.Windows.Forms.RichTextBox
$editor.Dock = 'Fill'
$editor.BorderStyle = 'None'
$editor.BackColor = $colors.Editor
$editor.ForeColor = $colors.Text
$editor.Font = New-Object System.Drawing.Font('Segoe UI', 13)
$editor.AcceptsTab = $true
$editor.DetectUrls = $false
$editor.WordWrap = $true
$editor.ScrollBars = 'Vertical'
$editor.HideSelection = $false
$editorPanel.Controls.Add($editor)

$placeholder = New-Object System.Windows.Forms.Label
$placeholder.Text = "Click here to type, or press Start dictating and speak.`r`n`r`nYour transcript stays in this window until you copy or save it."
$placeholder.Dock = 'Top'
$placeholder.Height = 72
$placeholder.Padding = New-Object System.Windows.Forms.Padding(20, 18, 16, 0)
$placeholder.BackColor = $colors.Editor
$placeholder.ForeColor = $colors.Muted
$placeholder.Font = New-Object System.Drawing.Font('Segoe UI', 11)
$editorPanel.Controls.Add($placeholder)
$placeholder.BringToFront()
$layout.Controls.Add($editorPanel, 0, 2)

$footer = New-Object System.Windows.Forms.TableLayoutPanel
$footer.Dock = 'Fill'
$footer.ColumnCount = 5
$footer.RowCount = 1
[void]$footer.ColumnStyles.Add((New-Object System.Windows.Forms.ColumnStyle([System.Windows.Forms.SizeType]::Percent, 100)))
[void]$footer.ColumnStyles.Add((New-Object System.Windows.Forms.ColumnStyle([System.Windows.Forms.SizeType]::Absolute, 36)))
[void]$footer.ColumnStyles.Add((New-Object System.Windows.Forms.ColumnStyle([System.Windows.Forms.SizeType]::Absolute, 82)))
[void]$footer.ColumnStyles.Add((New-Object System.Windows.Forms.ColumnStyle([System.Windows.Forms.SizeType]::Absolute, 90)))
[void]$footer.ColumnStyles.Add((New-Object System.Windows.Forms.ColumnStyle([System.Windows.Forms.SizeType]::Absolute, 164)))
[void]$footer.RowStyles.Add((New-Object System.Windows.Forms.RowStyle([System.Windows.Forms.SizeType]::Percent, 100)))

$statusLabel = New-Object System.Windows.Forms.Label
$statusLabel.Text = 'Ready to dictate'
$statusLabel.AutoSize = $false
$statusLabel.Dock = 'Fill'
$statusLabel.TextAlign = 'MiddleLeft'
$statusLabel.ForeColor = $colors.Muted
$statusLabel.Font = New-Object System.Drawing.Font('Segoe UI', 9)
$footer.Controls.Add($statusLabel, 0, 0)

$wordCountLabel = New-Object System.Windows.Forms.Label
$wordCountLabel.Text = '0 words'
$wordCountLabel.AutoSize = $false
$wordCountLabel.Dock = 'Fill'
$wordCountLabel.TextAlign = 'MiddleRight'
$wordCountLabel.Margin = New-Object System.Windows.Forms.Padding(3, 0, 6, 0)
$wordCountLabel.ForeColor = $colors.Muted
$wordCountLabel.Font = New-Object System.Drawing.Font('Segoe UI', 9)
$footer.Controls.Add($wordCountLabel, 3, 0)

$microphoneLevel = New-Object System.Windows.Forms.ProgressBar
$microphoneLevel.Minimum = 0
$microphoneLevel.Maximum = 100
$microphoneLevel.Size = New-Object System.Drawing.Size(72, 10)
$microphoneLevel.Anchor = 'None'
$microphoneLevel.Margin = New-Object System.Windows.Forms.Padding(3, 0, 5, 0)
$microphoneLevel.Style = 'Continuous'
$footer.Controls.Add($microphoneLevel, 2, 0)

$microphoneLabel = New-Object System.Windows.Forms.Label
$microphoneLabel.Text = 'Mic'
$microphoneLabel.AutoSize = $false
$microphoneLabel.Dock = 'Fill'
$microphoneLabel.TextAlign = 'MiddleLeft'
$microphoneLabel.ForeColor = $colors.Muted
$microphoneLabel.Font = New-Object System.Drawing.Font('Segoe UI', 9)
$footer.Controls.Add($microphoneLabel, 1, 0)

$recordButton = New-Object System.Windows.Forms.Button
$recordButton.Name = 'recordButton'
$recordButton.Text = 'Start dictating'
$recordButton.Size = New-Object System.Drawing.Size(164, 42)
$recordButton.Dock = 'Fill'
$recordButton.Margin = New-Object System.Windows.Forms.Padding(0, 5, 0, 5)
$recordButton.FlatStyle = 'Flat'
$recordButton.FlatAppearance.BorderSize = 0
$recordButton.BackColor = $colors.Accent
$recordButton.ForeColor = [System.Drawing.Color]::White
$recordButton.Font = New-Object System.Drawing.Font('Segoe UI Semibold', 10, [System.Drawing.FontStyle]::Bold)
$recordButton.Cursor = [System.Windows.Forms.Cursors]::Hand
$footer.Controls.Add($recordButton, 4, 0)
$layout.Controls.Add($footer, 0, 3)

function Update-WordCount {
    $text = $editor.Text.Trim()
    if ([string]::IsNullOrWhiteSpace($text)) {
        $count = 0
    }
    else {
        $count = [regex]::Split($text, '\s+').Length
    }
    $wordCountLabel.Text = '{0} {1}' -f $count, $(if ($count -eq 1) { 'word' } else { 'words' })
}

$editor.add_TextChanged({
    $placeholder.Visible = [string]::IsNullOrEmpty($editor.Text)
    Update-WordCount
})
$editor.add_Enter({ $placeholder.Visible = [string]::IsNullOrEmpty($editor.Text) })
$placeholder.add_Click({
    $editor.Focus()
})

$newButton.add_Click({
    if ([string]::IsNullOrWhiteSpace($editor.Text)) {
        return
    }

    $choice = [System.Windows.Forms.MessageBox]::Show(
        $form,
        'Start a new draft? Unsaved text in the editor will be cleared.',
        'New draft',
        [System.Windows.Forms.MessageBoxButtons]::YesNo,
        [System.Windows.Forms.MessageBoxIcon]::Question
    )
    if ($choice -eq [System.Windows.Forms.DialogResult]::Yes) {
        $editor.Clear()
        $statusLabel.Text = 'New draft'
    }
})

$copyButton.add_Click({
    if ([string]::IsNullOrWhiteSpace($editor.Text)) {
        $statusLabel.Text = 'There is no text to copy'
        return
    }
    try {
        [System.Windows.Forms.Clipboard]::SetText($editor.Text)
        $statusLabel.Text = 'Copied to clipboard'
    }
    catch {
        $statusLabel.Text = 'Could not access the clipboard'
        [System.Windows.Forms.MessageBox]::Show(
            $form,
            "The text could not be copied.`r`n`r`n$($_.Exception.Message)",
            'Clipboard error',
            [System.Windows.Forms.MessageBoxButtons]::OK,
            [System.Windows.Forms.MessageBoxIcon]::Error
        ) | Out-Null
    }
})

$saveButton.add_Click({
    if ([string]::IsNullOrWhiteSpace($editor.Text)) {
        $statusLabel.Text = 'There is no text to save'
        return
    }

    $dialog = New-Object System.Windows.Forms.SaveFileDialog
    $dialog.Title = 'Save your transcript'
    $dialog.Filter = 'Text documents (*.txt)|*.txt|All files (*.*)|*.*'
    $dialog.FileName = 'Dictation.txt'
    if ($dialog.ShowDialog($form) -eq [System.Windows.Forms.DialogResult]::OK) {
        try {
            $encoding = New-Object System.Text.UTF8Encoding($false)
            [System.IO.File]::WriteAllText($dialog.FileName, $editor.Text, $encoding)
            $statusLabel.Text = 'Transcript saved'
        }
        catch {
            $statusLabel.Text = 'Could not save transcript'
            [System.Windows.Forms.MessageBox]::Show(
                $form,
                "The transcript could not be saved.`r`n`r`n$($_.Exception.Message)",
                'Save error',
                [System.Windows.Forms.MessageBoxButtons]::OK,
                [System.Windows.Forms.MessageBoxIcon]::Error
            ) | Out-Null
        }
    }
    $dialog.Dispose()
})

$recordButton.add_Click({
    if ($null -ne $script:recognizer) {
        try {
            $script:recognizer.RecognizeAsyncCancel()
        }
        catch {
            $statusLabel.Text = 'Could not stop speech recognition'
            [System.Windows.Forms.MessageBox]::Show(
                $form,
                "Speech recognition could not be stopped.`r`n`r`n$($_.Exception.Message)",
                'Dictation error',
                [System.Windows.Forms.MessageBoxButtons]::OK,
                [System.Windows.Forms.MessageBoxIcon]::Error
            ) | Out-Null
        }
        $script:recognizer.Dispose()
        $script:recognizer = $null
        $recordButton.Text = 'Start dictating'
        $recordButton.BackColor = $colors.Accent
        $statusLabel.Text = 'Dictation stopped'
        $languagePicker.Enabled = $true
        return
    }

    $selectedRecognizer = $languagePicker.SelectedItem
    if ($null -eq $selectedRecognizer) {
        [System.Windows.Forms.MessageBox]::Show(
            $form,
            'No Windows speech recognition language is installed. Add a speech language in Windows Settings, then reopen FlowNote.',
            'Speech language unavailable',
            [System.Windows.Forms.MessageBoxButtons]::OK,
            [System.Windows.Forms.MessageBoxIcon]::Warning
        ) | Out-Null
        return
    }

    $engine = $null
    try {
        $engine = New-Object System.Speech.Recognition.SpeechRecognitionEngine($selectedRecognizer.Id)
        $engine.LoadGrammar((New-Object System.Speech.Recognition.DictationGrammar))
        $engine.SetInputToDefaultAudioDevice()
        $engine.add_SpeechRecognized({
            param($sender, $eventArgs)
            $recognizedText = $eventArgs.Result.Text.Trim()
            if (-not [string]::IsNullOrWhiteSpace($recognizedText)) {
                $script:recognitionEvents.Enqueue([PSCustomObject]@{
                    Type = 'recognized'
                    Text = $recognizedText
                })
            }
        })
        $engine.add_SpeechRecognitionRejected({
            param($sender, $eventArgs)
            $script:recognitionEvents.Enqueue([PSCustomObject]@{
                Type = 'rejected'
                Text = $null
            })
        })
        $engine.add_SpeechDetected({
            param($sender, $eventArgs)
            $script:recognitionEvents.Enqueue([PSCustomObject]@{
                Type = 'detected'
                Text = $null
            })
        })
        $engine.add_AudioLevelUpdated({
            param($sender, $eventArgs)
            [System.Threading.Interlocked]::Exchange([ref]$script:lastAudioLevel, [int]$eventArgs.AudioLevel) | Out-Null
        })
        $engine.add_AudioSignalProblemOccurred({
            param($sender, $eventArgs)
            $script:recognitionEvents.Enqueue([PSCustomObject]@{
                Type = 'audio-problem'
                Text = $eventArgs.AudioSignalProblem.ToString()
            })
        })
        $engine.RecognizeAsync([System.Speech.Recognition.RecognizeMode]::Multiple)
        $script:recognizer = $engine
        $recordButton.Text = 'Stop dictating'
        $recordButton.BackColor = [System.Drawing.Color]::FromArgb(184, 67, 83)
        $statusLabel.Text = 'Listening - speak naturally'
        $script:lastSpeechTime = Get-Date
        [System.Threading.Interlocked]::Exchange([ref]$script:lastAudioLevel, 0) | Out-Null
        $microphoneLevel.Value = 0
        $languagePicker.Enabled = $false
    }
    catch {
        if ($null -ne $engine) {
            $engine.Dispose()
        }
        $statusLabel.Text = 'Could not start dictation'
        [System.Windows.Forms.MessageBox]::Show(
            $form,
            "Dictation could not start. Check that a microphone is connected and Windows allows desktop apps to use it.`r`n`r`n$($_.Exception.Message)",
            'Dictation error',
            [System.Windows.Forms.MessageBoxButtons]::OK,
            [System.Windows.Forms.MessageBoxIcon]::Error
        ) | Out-Null
    }
})

$queueTimer = New-Object System.Windows.Forms.Timer
$queueTimer.Interval = 150
$queueTimer.add_Tick({
    $audioLevel = [System.Threading.Interlocked]::Exchange([ref]$script:lastAudioLevel, 0)
    if ($audioLevel -lt $microphoneLevel.Minimum) {
        $audioLevel = $microphoneLevel.Minimum
    }
    if ($audioLevel -gt $microphoneLevel.Maximum) {
        $audioLevel = $microphoneLevel.Maximum
    }
    $microphoneLevel.Value = $audioLevel

    $recognitionEvent = $null
    while ($script:recognitionEvents.TryDequeue([ref]$recognitionEvent)) {
        switch ($recognitionEvent.Type) {
            'recognized' {
                if (-not [string]::IsNullOrWhiteSpace($recognitionEvent.Text)) {
                    $editor.SelectionStart = $editor.TextLength
                    $editor.SelectionLength = 0
                    if ($editor.TextLength -gt 0 -and -not [char]::IsWhiteSpace($editor.Text[$editor.TextLength - 1])) {
                        $editor.SelectedText = ' '
                    }
                    $editor.SelectedText = $recognitionEvent.Text + ' '
                    $script:lastSpeechTime = Get-Date
                    $statusLabel.Text = 'Listening - speech added'
                }
            }
            'detected' {
                $script:lastSpeechTime = Get-Date
                $statusLabel.Text = 'Speech detected - processing'
            }
            'rejected' {
                $script:lastSpeechTime = Get-Date
                $statusLabel.Text = 'Speech heard but not recognized - check the selected language'
            }
            'audio-problem' {
                $statusLabel.Text = 'Microphone audio problem: {0}' -f $recognitionEvent.Text
            }
        }
        $recognitionEvent = $null
    }

    if ($null -ne $script:recognizer -and $script:lastSpeechTime -ne [datetime]::MinValue) {
        $silenceDuration = (Get-Date) - $script:lastSpeechTime
        if ($silenceDuration.TotalSeconds -ge 15 -and $audioLevel -eq 0) {
            $statusLabel.Text = 'No microphone audio - check Windows microphone permission, input device, and volume'
        }
        elseif ($silenceDuration.TotalSeconds -ge 15 -and $audioLevel -gt 0) {
            $statusLabel.Text = 'Microphone active - try matching the selected speech language'
        }
    }
})
$queueTimer.Start()

$form.add_KeyDown({
    param($sender, $eventArgs)
    if ($eventArgs.Control -and $eventArgs.KeyCode -eq [System.Windows.Forms.Keys]::Enter) {
        $recordButton.PerformClick()
        $eventArgs.SuppressKeyPress = $true
    }
})

$form.add_FormClosing({
    $queueTimer.Stop()
    if ($null -ne $script:recognizer) {
        $script:recognizer.RecognizeAsyncCancel()
        $script:recognizer.Dispose()
        $script:recognizer = $null
    }
})

[void]$form.ShowDialog()
