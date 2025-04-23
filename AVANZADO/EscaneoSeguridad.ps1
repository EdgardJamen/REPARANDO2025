#  Modo estandar: Solo escanea
$modo = Read-Host "Elige modo de escaneo (1=Estandar, 2=Avanzado)"

#  Mensaje de advertencia si el usuario selecciona el modo avanzado
if ($modo -eq "2") {
    Write-Host "======================================" -ForegroundColor Red
    Write-Host "   ADVERTENCIA: MODO AVANZADO        " -ForegroundColor Red
    Write-Host "======================================" -ForegroundColor Red
    Write-Host ""
    Write-Host "En esta opcion, usted tiene control total sobre que archivos o procesos eliminar." -ForegroundColor Yellow
    Write-Host "La eliminacion sin conocimiento adecuado puede causar fallos en el sistema." -ForegroundColor Yellow
    Write-Host "Asegurese de conocer la funcion de cada archivo antes de borrarlo!" -ForegroundColor White
    Write-Host ""
    
    # Confirmacion antes de continuar
    $confirmacion = Read-Host "Esta seguro de continuar en modo avanzado? (s/n)"
    if ($confirmacion -ne "s") {
        Write-Host "Modo avanzado cancelado. Ejecutando escaneo estandar..." -ForegroundColor Cyan
        $modo = "1"
    }
}

Write-Host "Iniciando escaneo..." -ForegroundColor Yellow

#  Detener el escaneo si el usuario cancelo el modo avanzado
if ($modo -ne "2") {
    Write-Host "Escaneo estandar activado. No se eliminaran archivos." -ForegroundColor Cyan
}

#  Escaneo de procesos sospechosos
$procesos = Get-Process | Where-Object { $_.ProcessName -match "unknown" }
if ($procesos) {
    Write-Host "Procesos sospechosos encontrados:"
    $procesos | Format-Table -AutoSize

    #  En modo avanzado, preguntar antes de eliminar procesos
    if ($modo -eq "2") {
        foreach ($proc in $procesos) {
            $respuesta = Read-Host "Eliminar proceso $($proc.ProcessName)? (s/n)"
            if ($respuesta -eq "s") { Stop-Process -Id $proc.Id -Force }
        }
    }
}

#  Escaneo de archivos ocultos sospechosos
$archivosOcultos = Get-ChildItem -Path C:\Users -Force -Recurse -ErrorAction SilentlyContinue |
    Where-Object { $_.Attributes -match "Hidden" }

if ($archivosOcultos) {
    Write-Host "Archivos ocultos sospechosos detectados:"
    $archivosOcultos | Format-Table -AutoSize

    #  En modo avanzado, preguntar antes de eliminar archivos ocultos
    if ($modo -eq "2") {
        foreach ($archivo in $archivosOcultos) {
            $respuesta = Read-Host "Eliminar archivo $($archivo.Name)? (s/n)"
            if ($respuesta -eq "s") { Remove-Item -Path $archivo.FullName -Force }
        }
    }
}

#  Escaneo de archivos ejecutables desconocidos fuera de carpetas del sistema
$listaBlanca = @("C:\Windows", "C:\Program Files", "C:\Program Files (x86)", "C:\Users\Default", "C:\Users\Public")
$archivosEjecutables = Get-ChildItem -Path C:\Users -Force -Recurse -ErrorAction SilentlyContinue |
    Where-Object { $_.Extension -match "^(exe|dll|bat)$" -and ($listaBlanca -notcontains $_.DirectoryName) }

if ($archivosEjecutables) {
    Write-Host "Archivos ejecutables sospechosos detectados:"
    $archivosEjecutables | Format-Table -AutoSize

    #  En modo avanzado, preguntar antes de eliminar ejecutables sospechosos
    if ($modo -eq "2") {
        foreach ($archivo in $archivosEjecutables) {
            $respuesta = Read-Host "Eliminar archivo $($archivo.Name)? (s/n)"
            if ($respuesta -eq "s") { Remove-Item -Path $archivo.FullName -Force }
        }
    }
}

#  Pausa para evitar cierre automatico
Write-Host "`nPresione X para cerrar la ventana o Y para ejecutar el escaneo avanzado." -ForegroundColor Cyan
$accion = Read-Host "Ingrese su opcion (X/Y)"

if ($accion -eq "X") {
    Write-Host "Cerrando la ventana..." -ForegroundColor Red
    Start-Sleep -Seconds 1
    Exit
} elseif ($accion -eq "Y") {
    Write-Host "Ejecutando escaneo avanzado con permisos elevados..." -ForegroundColor Green
    Start-Sleep -Seconds 1
    Start-Process -FilePath "powershell.exe" `
        -ArgumentList "-ExecutionPolicy Bypass -File C:\Users\gabriel\Desktop\FUNCIONESAVANZADAS\Escaneoseguridad\EscaneoSeguridad.ps1" `
        -Verb RunAs
} else {
    Write-Host "Opcion no valida. Intente nuevamente." -ForegroundColor Yellow
}
