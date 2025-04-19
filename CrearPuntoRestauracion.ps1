[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

# Función para comprobar si se ejecuta como administrador
function Test-Admin {
    $currentIdentity = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($currentIdentity)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

# Si NO se está ejecutando como administrador, reinicia el script con elevación.
if (-not (Test-Admin)) {
    Write-Host "Este script requiere privilegios de administrador. Reiniciando con elevacion..." -ForegroundColor Yellow
    Start-Process powershell.exe -ArgumentList "-ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    Exit
}

try {
    Write-Host "Creando un punto de restauracion. Por favor espere..." -ForegroundColor Cyan
    # Se crea el punto de restauracion con una descripción personalizada.
    Checkpoint-Computer -Description "Backup Pre-Optimizacion" -RestorePointType MODIFY_SETTINGS -ErrorAction Stop
    Write-Host "Punto de restauracion creado exitosamente." -ForegroundColor Green
}
catch {
    Write-Host "Error al crear el punto de restauracion: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "Presiona Enter para continuar..."
Read-Host
