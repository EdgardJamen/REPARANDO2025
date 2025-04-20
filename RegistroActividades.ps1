[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
Clear-Host

# Definir la ruta del archivo de log
$logFile = "$env:TEMP\system_log.txt"

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

# Encabezado
Write-Host $line -ForegroundColor Magenta -BackgroundColor Black
Write-Centered "REGISTRO DE ACTIVIDADES" -ForegroundColor Magenta -BackgroundColor Black
Write-Host $line -ForegroundColor Magenta -BackgroundColor Black
Write-Host ""

# Mostrar opciones del submenú
Write-Host "Seleccione una opcion:" -ForegroundColor Cyan
Write-Host " 1. Ver registro de actividades"
Write-Host " 2. Borrar registro de actividades"
Write-Host " 3. Salir"
Write-Host ""

$choice = Read-Host "Seleccione una opcion (1-3)"
switch ($choice) {
    "1" {
        Write-Host "`nMostrando registro de actividades:" -ForegroundColor Green
        if (Test-Path $logFile) {
            Get-Content $logFile | ForEach-Object { Write-Host $_ }
        } else {
            Write-Host "No se encontró un registro de actividades." -ForegroundColor Yellow
        }
        Write-Host "`nPresione Enter para continuar..."
        Read-Host
    }
    "2" {
        Write-Host "`n¿Está seguro de borrar el registro? (Y/N)" -ForegroundColor Red
        $confirm = Read-Host "Confirmar (Y/N)"
        if ($confirm -in @("Y", "y")) {
            if (Test-Path $logFile) {
                Clear-Content $logFile -ErrorAction SilentlyContinue
                Write-Host "Registro borrado." -ForegroundColor Green
            } else {
                Write-Host "No se encontró registro para borrar." -ForegroundColor Yellow
            }
        } else {
            Write-Host "No se borró el registro." -ForegroundColor Yellow
        }
        Write-Host "`nPresione Enter para continuar..."
        Read-Host
    }
    "3" {
        Write-Host "`nSaliendo del modulo de registro de actividades..." -ForegroundColor Red
        Start-Sleep -Seconds 2
        # Salir del script
        [System.Environment]::Exit(0)
    }
    Default {
        Write-Host "`nOpción no valida." -ForegroundColor Red
        Write-Host "Presione Enter para continuar..."
        Read-Host
    }
}

Write-Host "`nPresione Enter para salir ..."
Read-Host
[System.Environment]::Exit(0)
