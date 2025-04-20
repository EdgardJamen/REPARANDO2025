[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

# Función para comprobar si se ejecuta como administrador
function Test-Admin {
    $currentIdentity = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($currentIdentity)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

# Si NO se está ejecutando como administrador, reinicia el script con elevación.
if (-not (Test-Admin)) {
    Write-Host "Este script requiere privilegios de administrador. Reiniciando con elevación..." -ForegroundColor Yellow
    Start-Process powershell.exe -ArgumentList "-ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    Exit
}

# Comprobar si la restauración del sistema está desactivada
$estadoRestauracion = (vssadmin list shadows 2>&1) -match "No se encuentran copias de seguridad"

if ($estadoRestauracion) {
    Write-Host "Activando la protección del sistema en la unidad C:..." -ForegroundColor Yellow
    Enable-ComputerRestore -Drive "C:\"
}

# Activar el servicio de restauración del sistema antes de ejecutar
Write-Host "Activando el servicio de restauración del sistema..." -ForegroundColor Yellow
Start-Service -Name "VSS" -ErrorAction SilentlyContinue

# Crear el punto de restauración
try {
    Write-Host "Creando un punto de restauración. Por favor espere..." -ForegroundColor Cyan
    Checkpoint-Computer -Description "Backup Pre-Optimización" -RestorePointType MODIFY_SETTINGS -ErrorAction Stop
    Write-Host "Punto de restauración creado exitosamente." -ForegroundColor Green
}
catch {
    Write-Host "Error al crear el punto de restauración: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "Presiona Enter para continuar..."
Read-Host
