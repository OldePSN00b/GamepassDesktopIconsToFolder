$Desktop = [Environment]::GetFolderPath("Desktop")
$XboxFenceFolder = "C:\Users\terri\Gamepass Game Icons"

New-Item -ItemType Directory -Path $XboxFenceFolder -Force | Out-Null

Get-ChildItem -Path $Desktop -Filter "*.lnk" -File | ForEach-Object {
    try {
        $Bytes = [System.IO.File]::ReadAllBytes($_.FullName)

        $Text = (
            [System.Text.Encoding]::Unicode.GetString($Bytes) +
            [System.Text.Encoding]::UTF8.GetString($Bytes) +
            [System.Text.Encoding]::ASCII.GetString($Bytes)
        )

        if ($Text -match '(?i)(%systemdrive%|[A-Z]:)\\XboxGames\\') {
            Write-Output "Moving Xbox/Game Pass shortcut: $($_.Name)"
            Move-Item -Path $_.FullName -Destination $XboxFenceFolder -Force
        }
    }
    catch {
        $ErrorMessage = $_.Exception.Message
        Write-Warning ("Failed to process shortcut {0}: {1}" -f $_.FullName, $ErrorMessage)
    }
}