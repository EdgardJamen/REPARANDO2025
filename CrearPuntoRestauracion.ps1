[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

# Funcion para comprobar si se ejecuta como administrador
function Test-Admin {
    $currentIdentity = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($currentIdentity)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

# Si NO se esta ejecutando como administrador, reinicia el script con elevacion.
if (-not (Test-Admin)) {
    Write-Host "Este script requiere privilegios de administrador. Reiniciando con elevacion..." -ForegroundColor Yellow
    Start-Process powershell.exe -ArgumentList "-ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    Exit
}

# Comprobar si la proteccion del sistema esta deshabilitada
$estadoProteccion = (vssadmin list shadows 2>&1) -match "no tiene dispositivos habilitados asociados"

if ($estadoProteccion) {
    Write-Host "⚠️ La proteccion del sistema esta deshabilitada. Activandola en C:\..." -ForegroundColor Yellow
    Enable-ComputerRestore -Drive "C:\"
}

# Activar el servicio de restauracion del sistema antes de ejecutar
Write-Host "Activando el servicio de restauracion del sistema..." -ForegroundColor Yellow
Start-Service -Name "VSS" -ErrorAction SilentlyContinue

# Crear el punto de restauracion
try {
    Write-Host "Creando un punto de restauracion. Por favor espere..." -ForegroundColor Cyan
    Checkpoint-Computer -Description "Backup Pre-Optimizacion" -RestorePointType MODIFY_SETTINGS -ErrorAction Stop
    Write-Host "✅ Punto de restauracion creado exitosamente." -ForegroundColor Green
}
catch {
    Write-Host "❌ Error al crear el punto de restauracion: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "Presiona Enter para continuar..."
Read-Host

catch {
    Write-Host "❌ Error al crear el punto de restauración: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "Presiona Enter para continuar..."
Read-Host
