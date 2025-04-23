# Limpiar archivos temporales antes de iniciar el escaneo
Write-Host 'Limpiando archivos temporales...' -ForegroundColor Yellow
Remove-Item -Path "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue
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
# Evaluar consumo de CPU de procesos y detectar actividad inusual
Write-Host "Evaluando procesos con alto consumo de CPU..." -ForegroundColor Yellow
$procesosCPU = Get-Process | Sort-Object CPU -Descending | Select-Object -First 10

if ($procesosCPU) {
    Write-Host "Procesos que más consumen CPU:" -ForegroundColor Cyan
    $procesosCPU | Format-Table ProcessName, CPU -AutoSize
}
# Escaneo de conexiones de red activas
Write-Host "Detectando conexiones activas desconocidas..." -ForegroundColor Yellow
$redConexiones = Get-NetTCPConnection | Where-Object { $_.State -eq "Established" -and $_.RemoteAddress -ne "127.0.0.1" }

if ($redConexiones) {
    Write-Host "Conexiones de red activas detectadas:" -ForegroundColor Cyan
    $redConexiones | Format-Table LocalAddress, RemoteAddress, RemotePort, State -AutoSize
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

# Ruta del archivo de informe
$reportePath = "$env:TEMP\Escaneo_Resultado.txt"

# Crear el archivo e incluir resultados del escaneo
Write-Host "Generando informe de seguridad..." -ForegroundColor Yellow
@"
====================================
      INFORME DE ESCANEO DE SEGURIDAD
====================================

Procesos sospechosos encontrados:
$($procesos | Out-String)

Procesos con alto consumo de CPU:
$($procesosCPU | Out-String)

Archivos ocultos sospechosos detectados:
$($archivosOcultos | Out-String)

Archivos ejecutables fuera de ubicaciones seguras:
$($archivosEjecutables | Out-String)

Conexiones de red activas desconocidas:
$($redConexiones | Out-String)

====================================
"@ | Out-File -FilePath $reportePath -Encoding UTF8 -Force
Write-Host "Informe guardado en: $reportePath" -ForegroundColor Green


# Opción adicional para descargar el informe
Write-Host "`nPresione X para cerrar la ventana, Y para ejecutar el escaneo avanzado, o D para descargar el informe." -ForegroundColor Cyan
$accion = Read-Host "Ingrese su opcion (X/Y/D)"

if ($accion -eq "X") {
    Write-Host "Cerrando la ventana..." -ForegroundColor Red
    Start-Sleep -Seconds 1
    Exit
} elseif ($accion -eq "Y") {
    Write-Host "Ejecutando escaneo avanzado con permisos elevados..." -ForegroundColor Green
    Start-Sleep -Seconds 1
    Start-Process -FilePath "powershell.exe" `
        -ArgumentList "-ExecutionPolicy Bypass -File `"$env:TEMP\EscaneoSeguridad.ps1`"" `
        -Verb RunAs
} elseif ($accion -eq "D") {
    Write-Host "Abriendo carpeta TEMP para acceder al informe..." -ForegroundColor Green
    Start-Process "explorer.exe" $env:TEMP
} else {
    Write-Host "Opcion no valida. Intente nuevamente." -ForegroundColor Yellow
}
