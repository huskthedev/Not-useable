$TosText = @"
TERMS OF SERVICE

Dieses Tool benoetigt Ihre ausdrueckliche Zustimmung, bevor es Dateien herunterlaedt
oder Installer ausfuehrt. Durch Eingabe von 'I AGREE' stimmen Sie zu.
"@

$InstallerUrl = "https://github.com/winsiderss/systeminformer/releases/download/v3.2.25011.2103/systeminformer-3.2.25011-release-setup.exe"
$InstallerPath = Join-Path $env:TEMP ([IO.Path]::GetFileName($InstallerUrl))

function Accept-TOS {
    Clear-Host
    Write-Host $TosText
    $input = Read-Host "Geben Sie 'I AGREE' ein, um fortzufahren"
    if ($input -ne "I AGREE") {
        Write-Host "Einverstaendnis nicht erteilt. Abbruch."
        exit 1
    }
}

function Confirm($Message) {
    do {
        $resp = Read-Host "$Message (y/n)"
    } while ($resp.ToLower() -notin @('y','n'))
    return $resp.ToLower() -eq 'y'
}

function Download-Installer {
    param([string]$Url, [string]$OutPath)
    Write-Host "Herunterladen von $Url..."
    try {
        Invoke-WebRequest -Uri $Url -OutFile $OutPath -UseBasicParsing
        Write-Host "Download abgeschlossen: $OutPath"
        return $true
    } catch {
        Write-Host "Fehler beim Herunterladen: $_"
        return $false
    }
}

function Run-Installer {
    param([string]$Path)
    if (-not (Test-Path $Path)) {
        Write-Host "Installer nicht gefunden: $Path"
        exit 1
    }
    if (Confirm "Installer ausfuehren?") {
        Write-Host "Starte Installer..."
        Start-Process -FilePath $Path -Wait
        Write-Host "Installer beendet."
    } else {
        Write-Host "Installer wurde uebersprungen."
    }
}

Accept-TOS

if (-not (Confirm "Moechten Sie den Installer jetzt herunterladen?")) {
    Write-Host "Abbruch durch Benutzer."
    exit 1
}

if (-not (Download-Installer -Url $InstallerUrl -OutPath $InstallerPath)) {
    Write-Host "Download fehlgeschlagen. Abbruch."
    exit 1
}

Run-Installer -Path $InstallerPath

Write-Host "Fertig. Das Skript ist abgeschlossen."
