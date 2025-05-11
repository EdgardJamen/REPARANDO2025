# Establecer la codificacion para evitar errores con caracteres especiales
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

# Asegurar que PowerShell tenga permisos para ejecutar scripts
$ExecutionPolicy = Get-ExecutionPolicy
if ($ExecutionPolicy -ne "Bypass") {
    Set-ExecutionPolicy Bypass -Scope CurrentUser -Force
}

# Verificar si el script tiene privilegios de administrador
function Check-Admin {
    $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($currentUser)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

if (!(Check-Admin)) {
    Write-Host "Error: Este script requiere permisos de administrador." -ForegroundColor Red
    Start-Sleep -Seconds 5
    Exit
}

# Eliminar el script `menu2.ps1` de TEMP al iniciar
$scriptPath = "$env:TEMP\menu2.ps1"
if (Test-Path $scriptPath) {
    Remove-Item -Path $scriptPath -Force -ErrorAction SilentlyContinue
}

do {
    Clear-Host
    Write-Host "============================================" -ForegroundColor Cyan
    Write-Host "          SECCION AVANZADA            " -ForegroundColor White -BackgroundColor DarkBlue
    Write-Host "============================================" -ForegroundColor Cyan

    Write-Host "  1.  - Activador de Windows/Office " -ForegroundColor Green
    Write-Host "  2.  - Optimizar inicio y servicios " -ForegroundColor Green
    Write-Host "--------------------------------------------" -ForegroundColor DarkGray
    Write-Host "  3.  - Escaneo de seguridad " -ForegroundColor Green
    Write-Host "  4.  - Recuperacion de datos en unidades " -ForegroundColor Green
    Write-Host "  5.  - Disponible para nuevas funciones " -ForegroundColor White
    Write-Host "--------------------------------------------" -ForegroundColor DarkGray
    Write-Host "  X.  - Volver al menu principal " -ForegroundColor Red

    # Capturar eleccion del usuario
    $opcion = Read-Host "Ingrese una opcion (1-5 o X para salir)"

    switch ($opcion) {
        "1" {
            Write-Host "Ejecutando activador de Windows/Office..." -ForegroundColor Green
            Start-Process -FilePath "powershell.exe" `
                -ArgumentList "-NoProfile -ExecutionPolicy Bypass -Command irm https://get.activated.win | iex" `
                -Verb RunAs

            Write-Host "`nFINALIZANDO... Presiona Enter para volver al menu." -ForegroundColor Cyan
            Read-Host
        }
        "2" {
            Write-Host "Ejecutando optimizacion de inicio y servicios..." -ForegroundColor Green
            $scriptUrl = "https://raw.githubusercontent.com/EdgardJamen/REPARANDO2025/main/OptimizarInicioServicios.ps1"
            $scriptPath = "$env:TEMP\OptimizarInicioServicios.ps1"

            Invoke-WebRequest -Uri $scriptUrl -OutFile $scriptPath
            Start-Sleep -Seconds 2

            if (Test-Path $scriptPath) {
                Write-Host "   Procediendo con la ejecucion..." -ForegroundColor Green
                Start-Process -FilePath "powershell.exe" `
                    -ArgumentList "-ExecutionPolicy Bypass -File `"$scriptPath`"" `
                    -Verb RunAs

                Start-Sleep -Seconds 2
                Remove-Item -Path $scriptPath -Force -ErrorAction SilentlyContinue
                Write-Host "Optimizando inicio y servicios. Espere..." -ForegroundColor Yellow
                Read-Host
            } else {
                Write-Host "Error: No se pudo encontrar correctamente el archivo." -ForegroundColor Red
            }
        }
        "3" {
    Write-Host "Descargando informacion sobre escaneo de seguridad..." -ForegroundColor Cyan

    $scriptUrl = "https://raw.githubusercontent.com/EdgardJamen/REPARANDO2025/refs/heads/main/AVANZADO/Write.ps1"
    $scriptPath = "$env:TEMP\Write.ps1"

    # Descargar el script correctamente
    Invoke-WebRequest -Uri $scriptUrl -OutFile $scriptPath  
    Start-Sleep -Seconds 2  

    # Verificar si la descarga fue exitosa antes de ejecutarlo
    if (Test-Path $scriptPath) {  
        Write-Host "Ejecutando informacion sobre escaneo de seguridad..." -ForegroundColor Green  

        # Ejecutar `Write.ps1` en la misma ventana para mostrar la interfaz
        powershell -ExecutionPolicy Bypass -NoProfile -File "$scriptPath"

        # Eliminar el script después de ejecutarse
        Remove-Item -Path $scriptPath -Force -ErrorAction SilentlyContinue  

        Write-Host "`nProceso completado." -ForegroundColor Cyan  
    } else {  
        Write-Host "Error: No se pudo cargar el escaneo de seguridad." -ForegroundColor Red  
    }  

    Write-Host "`nPresiona Enter para volver al menu..." -ForegroundColor Cyan  
    Read-Host  
}

        "4" {
    Write-Host "Ejecutando recuperacion de datos eliminados..." -ForegroundColor Green
    $scriptUrl = "https://raw.githubusercontent.com/EdgardJamen/REPARANDO2025/main/AVANZADO/RecuperarDatos.ps1"
    $scriptPath = "$env:TEMP\RecuperarDatos.ps1"

    Invoke-WebRequest -Uri $scriptUrl -OutFile $scriptPath
    Start-Sleep -Seconds 2

    if (Test-Path $scriptPath) {
        Write-Host "   Procediendo con la ejecucion..." -ForegroundColor Green
        Start-Process -FilePath "powershell.exe" `
            -ArgumentList "-ExecutionPolicy Bypass -File `"$scriptPath`"" `
            -Verb RunAs

        Start-Sleep -Seconds 2
        Remove-Item -Path $scriptPath -Force -ErrorAction SilentlyContinue
        Write-Host "Ejecutando recuperacion de datos. Espere..." -ForegroundColor Yellow
        Read-Host
    } else {
        Write-Host "Error: No se pudo encontrar correctamente el archivo." -ForegroundColor Red
    }
}

        "5" {
            Write-Host "Esta funcion aun no esta implementada." -ForegroundColor Yellow
            Read-Host "Presiona Enter para volver al menu..."
        }
        "X" {
            Write-Host "Volviendo al menu principal..." -ForegroundColor Red
            Start-Sleep -Seconds 1
            Clear-Host
            Exit
        }
        Default {
            Write-Host "Opcion no valida. Intenta nuevamente." -ForegroundColor Red
            Start-Sleep -Seconds 2
        }
    }
} while ($true)  # Mantiene el menu en ejecucion hasta que se seleccione "X"
