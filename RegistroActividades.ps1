# Definir la ruta del archivo de log en el escritorio (mas accesible)
$logFile = "$env:USERPROFILE\Desktop\system_log.txt"

# Verificar si el archivo de registro existe, si no, crearlo
if (!(Test-Path $logFile)) {
    New-Item -Path $logFile -ItemType File -Force
    Add-Content -Path $logFile -Value "Registro creado - $(Get-Date)"
}

# Encabezado
Write-Host "============================================" -ForegroundColor Magenta
Write-Host "          REGISTRO DE ACTIVIDADES          " -ForegroundColor Magenta
Write-Host "============================================" -ForegroundColor Magenta
Write-Host ""

# Mostrar opciones del submenu
Write-Host "Seleccione una opcion:" -ForegroundColor Cyan
Write-Host " 1. Ver registro de actividades"
Write-Host " 2. Ver registro en vista grafica (GridView)"
Write-Host " 3. Borrar registro de actividades"
Write-Host " 4. Salir"
Write-Host ""

$choice = Read-Host "Seleccione una opcion (1-4)"
switch ($choice) {
    "1" {
        Write-Host "`nMostrando registro de actividades:" -ForegroundColor Green
        if (Test-Path $logFile) {
            Get-Content $logFile | ForEach-Object { Write-Host $_ }
        } else {
            Write-Host "No se encontro un registro de actividades." -ForegroundColor Yellow
        }
        Write-Host "`nPresione Enter para continuar..."
        Read-Host
    }
    "2" {
        Write-Host "`nMostrando registro en vista grafica..." -ForegroundColor Cyan
        if (Test-Path $logFile) {
            Get-Content $logFile | Out-GridView -Title "Registro de Actividades"
        } else {
            Write-Host "No se encontro un registro de actividades." -ForegroundColor Yellow
        }
        Write-Host "`nPresione Enter para continuar..."
        Read-Host
    }
    "3" {
        Write-Host "`nEsta seguro de borrar el registro? (Y/N)" -ForegroundColor Red
        $confirm = Read-Host "Confirmar (Y/N)"
        if ($confirm -in @("Y", "y")) {
            if (Test-Path $logFile) {
                Clear-Content $logFile -ErrorAction SilentlyContinue
                Write-Host "Registro borrado." -ForegroundColor Green
            } else {
                Write-Host "No se encontro registro para borrar." -ForegroundColor Yellow
            }
        } else {
            Write-Host "No se borro el registro." -ForegroundColor Yellow
        }
        Write-Host "`nPresione Enter para continuar...."
        Read-Host
    }
    "4" {
        Write-Host "`nSaliendo del modulo de registro de actividades...." -ForegroundColor Red
        Start-Sleep -Seconds 2
        [System.Environment]::Exit(0)
    }
    Default {
        Write-Host "`nOpcion no valida." -ForegroundColor Red
        Write-Host "Presione Enter para continuar...."
        Read-Host
    }
}

Write-Host "`nPresione Enter para salir...."
Read-Host
[System.Environment]::Exit(0)
