# --- Eliminación de aplicaciones innecesarias ---
$apps = @(
    "Microsoft.3DViewer",
    "Microsoft.BingWeather",
    "Microsoft.GetHelp",
    "Microsoft.Getstarted",
    "Microsoft.MicrosoftSolitaireCollection",
    "Microsoft.MixedReality.Portal",
    "Microsoft.People",
    "Microsoft.WindowsCommunicationsApps",
    "Microsoft.ZuneMusic",
    "Microsoft.ZuneVideo"
)

foreach ($app in $apps) {
    $installedApp = Get-AppxPackage -Name $app
    if ($installedApp) {
        Write-Host "Eliminando: $app" -ForegroundColor Yellow
        Remove-AppxPackage -Package $installedApp.PackageFullName -ErrorAction SilentlyContinue
    } else {
        Write-Host "$app no está instalado, se omite." -ForegroundColor Green
    }
}

# --- Desinstalar OneDrive completamente ---
Write-Host "Desinstalando OneDrive..." -ForegroundColor Green
taskkill /f /im OneDrive.exe 2>$null

$OneDrivePath = "$env:SystemRoot\System32\OneDriveSetup.exe"
if (Test-Path $OneDrivePath) {
    Start-Process -FilePath $OneDrivePath -ArgumentList "/uninstall" -NoNewWindow -Wait
} else {
    Write-Host "Error: No se encontró OneDriveSetup.exe en System32. Revisar ubicación." -ForegroundColor Red
}

$pathsToRemove = @("$env:LOCALAPPDATA\Microsoft\OneDrive", "$env:ProgramData\Microsoft OneDrive")
foreach ($path in $pathsToRemove) {
    if (Test-Path $path) {
        Remove-Item -Path $path -Recurse -Force -ErrorAction SilentlyContinue
        Write-Host "$path eliminado correctamente." -ForegroundColor Cyan
    }
}
# --- Eliminación completa de Xbox ---
Write-Host "Forzando eliminación de Xbox y dependencias..." -ForegroundColor Green
$XboxApps = @(
    "Microsoft.XboxApp",
    "Microsoft.Xbox.TCUI",
    "Microsoft.XboxGameOverlay",
    "Microsoft.XboxGamingOverlay",
    "Microsoft.XboxIdentityProvider",
    "Microsoft.XboxSpeechToTextOverlay"
)

foreach ($app in $XboxApps) {
    $installedApp = Get-AppxPackage -Name $app
    if ($installedApp) {
        Write-Host "Eliminando: $app"
        Remove-AppxPackage -Package $installedApp.PackageFullName
        Get-AppxProvisionedPackage -Online | Where-Object DisplayName -Like "*Xbox*" |
        ForEach-Object { Remove-AppxProvisionedPackage -Online -PackageName $_.PackageName }
    } else {
        Write-Host "$app no está instalado, se omite." -ForegroundColor Yellow
    }
}
Write-Host "Todas las aplicaciones de Xbox han sido eliminadas correctamente." -ForegroundColor Green
Write-Host "Eliminando Outlook..." -ForegroundColor Green

# Intento con Winget (Solo en Windows 10 y 11)
try {
    winget uninstall --id Microsoft.Outlook 2>$null
} catch {
    Write-Host "Error al desinstalar Outlook con Winget." -ForegroundColor Red
}

# Método alternativo con WMI
$OutlookApp = Get-WmiObject -Class Win32_Product | Where-Object { $_.Name -match "Outlook" }
if ($OutlookApp) {
    Write-Host "Outlook encontrado, eliminando..." -ForegroundColor Yellow
    $OutlookApp.Uninstall()
} else {
    Write-Host "Outlook no está instalado, probando método alternativo..." -ForegroundColor Cyan
}

# Verificar si Outlook es parte de Office y eliminar Office si es necesario
$OfficePath = Get-WmiObject -Class Win32_Product | Where-Object { $_.Name -match "Microsoft Office" }
if ($OfficePath) {
    Write-Host "Microsoft Office encontrado, eliminando..." -ForegroundColor Yellow
    $OfficePath.Uninstall()
} else {
    Write-Host "No se encontró instalación de Outlook ni Office." -ForegroundColor Cyan
}

Write-Host "Proceso de eliminación de Outlook terminado." -ForegroundColor Green

# --- Configurar rendimiento máximo del sistema ---
$regPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects"

# Si la clave no existe, crearla
if (!(Test-Path $regPath)) {
    New-Item -Path $regPath -Force
}

# Modificar valores para rendimiento máximo
Set-ItemProperty -Path $regPath -Name "VisualFXSetting" -Value 2

$effects = @(
    "HKCU:\Control Panel\Desktop", "FontSmoothing",
    "HKCU:\Control Panel\Desktop", "DragFullWindows",
    "HKCU:\Control Panel\Desktop", "MenuShowDelay"
)
For ($i = 0; $i -lt $effects.Length; $i += 2) {
    Set-ItemProperty -Path $effects[$i] -Name $effects[$i+1] -Value 0
}

Write-Host "Configuración de rendimiento aplicada correctamente." -ForegroundColor Cyan

$startupApps = Get-CimInstance Win32_StartupCommand | Select-Object Name, Command
foreach ($app in $startupApps) {
    Stop-Process -Name $app.Name -Force -ErrorAction SilentlyContinue
}

Write-Host "Programas de inicio innecesarios deshabilitados correctamente." -ForegroundColor Cyan

$tasksToDisable = @(
    "\Microsoft\Windows\Speech\SpeechModelDownload",
    "\Microsoft\Windows\UpdateOrchestrator\Schedule Scan",
    "\Microsoft\Windows\PushToInstall\LoginCheck",
    "\Microsoft\Windows\Windows Defender\Verification",
    "\Microsoft\Windows\SoftwareProtectionPlatform\SvcRestartTask"
)
foreach ($task in $tasksToDisable) {
    schtasks /Change /TN $task /Disable 2>$null
}

Write-Host "Tareas programadas deshabilitadas correctamente." -ForegroundColor Cyan

$tasksToDisable = @(
    "\Microsoft\Windows\Speech\SpeechModelDownload",
    "\Microsoft\Windows\UpdateOrchestrator\Schedule Scan",
    "\Microsoft\Windows\PushToInstall\LoginCheck",
    "\Microsoft\Windows\Windows Defender\Verification",
    "\Microsoft\Windows\SoftwareProtectionPlatform\SvcRestartTask"
)
foreach ($task in $tasksToDisable) {
    schtasks /Change /TN $task /Disable 2>$null
}

Write-Host "Tareas programadas deshabilitadas correctamente." -ForegroundColor Cyan

# --- Optimización de memoria RAM ---
Write-Host "Optimizando uso de memoria RAM..." -ForegroundColor Green
$procesos = Get-Process | Where-Object { $_.WorkingSet -gt 200MB }

foreach ($proceso in $procesos) {
    try {
        Write-Host "Cerrando proceso pesado: $($proceso.ProcessName)" -ForegroundColor Yellow
        Stop-Process -Name $proceso.ProcessName -Force -ErrorAction SilentlyContinue
    } catch {
        Write-Host "No se pudo cerrar $($proceso.ProcessName). Puede ser un proceso crítico." -ForegroundColor Red
    }
}

Write-Host "Optimización de memoria RAM completada correctamente." -ForegroundColor Cyan
# --- Limpieza de Archivos Basura y Papelera ---
Write-Host "Iniciando limpieza de archivos basura..." -ForegroundColor Green

# Limpiar archivos temporales
$pathsToClean = @("C:\Windows\Temp", "$env:TEMP", "C:\Users\*\AppData\Local\Temp")
foreach ($path in $pathsToClean) {
    if (Test-Path $path) {
        $files = Get-ChildItem -Path $path -Force -ErrorAction SilentlyContinue
        if ($files) {
            Write-Host "Limpiando: $path" -ForegroundColor Yellow
            Remove-Item -Path "$path\*" -Recurse -Force -ErrorAction SilentlyContinue
        } else {
            Write-Host "Advertencia: No hay archivos en $path para eliminar." -ForegroundColor Cyan
        }
    } else {
        Write-Host "Advertencia: La carpeta $path no existe." -ForegroundColor Cyan
    }
}

Write-Host "Archivos temporales eliminados correctamente." -ForegroundColor Green

# Vaciar la papelera de reciclaje
Write-Host "Vaciando la papelera de reciclaje..." -ForegroundColor Green
try {
    Clear-RecycleBin -Force -ErrorAction SilentlyContinue
    Write-Host "Papelera vaciada correctamente." -ForegroundColor Cyan
} catch {
    Write-Host "Error al vaciar la papelera: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "Limpieza de archivos basura completada." -ForegroundColor Cyan
Write-Host "Presiona Enter para cerrar..." -ForegroundColor Cyan
Read-Host

if (Test-Path "C:\Windows\Temp") {
    Clear-Content C:\Windows\Temp\* -ErrorAction SilentlyContinue
}

if (Test-Path "C:\Users\*\AppData\Local\Temp") {
    Clear-Content C:\Users\*\AppData\Local\Temp\* -ErrorAction SilentlyContinue
}

cmd.exe /c "echo off | clip"

Write-Host "¡Optimizacion completada! 🚀 Tu sistema debería ir más rápido." -ForegroundColor Green
Write-Host "`nFinalizando script correctamente..." -ForegroundColor Cyan
