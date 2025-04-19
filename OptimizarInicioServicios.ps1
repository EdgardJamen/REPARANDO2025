[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
Clear-Host

# Obtener el ancho de la ventana y crear una línea de "=" para el encabezado
$width = $Host.UI.RawUI.WindowSize.Width
$line = "=" * $width

# Función para escribir un texto centrado en la consola
function Write-Centered {
    param(
        [string]$text,
        [ConsoleColor]$ForegroundColor = "White",
        [ConsoleColor]$BackgroundColor = "Black"
    )
    $padding = ($width - $text.Length) / 2
    if ($padding -lt 0) { $padding = 0 }
    $leftSpaces = " " * ([Math]::Floor($padding))
    Write-Host "$leftSpaces$text" -ForegroundColor $ForegroundColor -BackgroundColor $BackgroundColor
}

# Encabezado en rojo con fondo negro
Write-Host $line -ForegroundColor Red -BackgroundColor Black
Write-Centered "OPTIMIZACION DE INICIO Y SERVICIOS" -ForegroundColor Red -BackgroundColor Black
Write-Host $line -ForegroundColor Red -BackgroundColor Black
Write-Host ""

# Mensaje de advertencia visible
Write-Host "ADVERTENCIA:" -ForegroundColor Red
Write-Host "Este script modificara configuraciones de inicio y deshabilitara algunos servicios NO criticos." -ForegroundColor Red
Write-Host "Podria ocasionar problemas en el funcionamiento del sistema." -ForegroundColor Red
Write-Host "Asegurese de tener un respaldo y de conocer los cambios que se realizan." -ForegroundColor Red
Write-Host "Presione 'Y' para continuar o cualquier otra tecla para cancelar." -ForegroundColor Red
$confirm = Read-Host "Confirmar (Y/N)"
if ($confirm -notin @("Y", "y")) {
    Write-Host "Operacion cancelada por el usuario. Saliendo..." -ForegroundColor Yellow
    Start-Sleep -Seconds 2
    [System.Environment]::Exit(0)
}

# --- Limpieza de la carpeta de inicio ---
$startupFolder = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup"
if (Test-Path $startupFolder) {
    Write-Host "Limpiando accesos directos en la carpeta de inicio..." -ForegroundColor Green
    $shortcuts = Get-ChildItem -Path $startupFolder -Filter *.lnk -ErrorAction SilentlyContinue
    if ($shortcuts) {
        foreach ($sc in $shortcuts) {
            Write-Host "Eliminando $($sc.Name)" -ForegroundColor Green
            Remove-Item $sc.FullName -Force -ErrorAction SilentlyContinue
        }
    } else {
        Write-Host "No se encontraron accesos directos en la carpeta de inicio." -ForegroundColor Yellow
    }
} else {
    Write-Host "La carpeta de inicio no existe." -ForegroundColor Yellow
}

# --- Optimizacion de servicios no críticos ---
Write-Host "Optimizando servicios no críticos..." -ForegroundColor Green
# Lista de servicios que se supone son prescindibles; modificala según convenga.
$servicesToDisable = @("Fax", "RemoteRegistry", "XblGameSave", "XblAuthManager", "WMPNetworkSvc")
foreach ($svcName in $servicesToDisable) {
    try {
        $svc = Get-Service -Name $svcName -ErrorAction SilentlyContinue
        if ($svc) {
            Write-Host "Deshabilitando servicio: $svcName" -ForegroundColor Green
            Set-Service -Name $svcName -StartupType Disabled -ErrorAction SilentlyContinue
            Write-Host "Servicio $svcName deshabilitado." -ForegroundColor Cyan
        } else {
            Write-Host "Servicio $svcName no encontrado o ya modificado." -ForegroundColor Yellow
        }
    } catch {
        Write-Host "Error al modificar el servicio $($svcName): $($_.Exception.Message)" -ForegroundColor Red
    }
}


Write-Host ""
Write-Host "Optimizacion de inicio y servicios completada." -ForegroundColor Green
Write-Host "Presione Enter para salir..."
Read-Host
