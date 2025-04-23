# Limpiar archivos temporales al inicio
Write-Host 'Limpiando archivos temporales...' -ForegroundColor Yellow
Remove-Item -Path "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue

Write-Host '======================================' -ForegroundColor Cyan
Write-Host '    INFORMACION SOBRE ESCANEO DE SEGURIDAD       ' -ForegroundColor Cyan
Write-Host '======================================' -ForegroundColor Cyan
Write-Host ''

Write-Host 'PROCESOS' -ForegroundColor Yellow
Write-Host '  - Detectar procesos sospechosos' -ForegroundColor Green
Write-Host '  - Evaluar consumo de CPU y actividad inusual' -ForegroundColor Green

Write-Host ''
Write-Host 'ARCHIVOS' -ForegroundColor Yellow
Write-Host '  - Identificar archivos ocultos sospechosos' -ForegroundColor Green
Write-Host '  - Analizar ejecutables en ubicaciones no seguras' -ForegroundColor Green

Write-Host ''
Write-Host 'RED' -ForegroundColor Yellow
Write-Host '  - Detectar conexiones activas desconocidas' -ForegroundColor Green
Write-Host '  - Revisar intentos de acceso remoto' -ForegroundColor Green

Write-Host ''
Write-Host 'ELIMINACION (Modo Avanzado)' -ForegroundColor Yellow
Write-Host '  - Permite eliminar amenazas detectadas' -ForegroundColor Green
Write-Host '  - Confirmacion manual antes de borrar archivos o procesos' -ForegroundColor Green
Write-Host '  - En esta opcion usted debe tener conocimientos avanzados sobre ADMINISTRACION DE SISTEMAS OPERATIVOS ' -ForegroundColor Green

Write-Host ''
Write-Host Write-Host '======================================' -ForegroundColor Cyan
Write-Host '           FIN DEL INFORME            ' -ForegroundColor Cyan
Write-Host '======================================' -ForegroundColor Cyan
Write-Host ''

# Opciones de accion
Write-Host 'Seleccione una opcion:' -ForegroundColor Yellow
Write-Host '  [X] Cerrar la ventana' -ForegroundColor Red
Write-Host '  [Y] Ejecutar Escaneo de Seguridad' -ForegroundColor Green

# Capturar eleccion del usuario
$opcion = Read-Host 'Ingrese su eleccion (X/Y)'

# Logica segun opcion elegida
if ($opcion -eq 'X') {
    Write-Host 'Cerrando la ventana...' -ForegroundColor Red
    Start-Sleep -Seconds 1
    Exit
} elseif ($opcion -eq 'Y') {
    Write-Host 'Ejecutando Escaneo de Seguridad con permisos elevados...' -ForegroundColor Green
    Start-Sleep -Seconds 1

    # URL del script a descargar
    $scanScriptUrl = "https://raw.githubusercontent.com/EdgardJamen/REPARANDO2025/refs/heads/main/AVANZADO/EscaneoSeguridad.ps1"
    $scanScriptPath = "$env:TEMP\EscaneoSeguridad.ps1"

    # Descargar el script antes de ejecutarlo
    Invoke-WebRequest -Uri $scanScriptUrl -OutFile $scanScriptPath  
    Start-Sleep -Seconds 2  

    # Ejecutar el script si la descarga fue exitosa
    if (Test-Path $scanScriptPath) {
        Start-Process -FilePath "powershell.exe" `
            -ArgumentList "-ExecutionPolicy Bypass -NoProfile -File `"$scanScriptPath`"" `
            -Verb RunAs -Wait -WindowStyle Normal
    } else {
        Write-Host "Error: No se pudo descargar EscaneoSeguridad.ps1." -ForegroundColor Red
    }
} else {
    Write-Host 'Opcion no valida. Intente nuevamente.' -ForegroundColor Yellow
}
