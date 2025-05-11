# Establecer codificacion
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

# Crear la carpeta donde se guardará el informe si no existe
$informeDirectorio = "C:\Usuarios\Publico\Documentos"
if (!(Test-Path $informeDirectorio)) {
    New-Item -ItemType Directory -Path $informeDirectorio -Force
}

# Definir ruta segura para el informe
$archivoInforme = "$informeDirectorio\InformeMenu.txt"

# Capturar estado inicial del sistema
$inicioRAM = (Get-WmiObject Win32_OperatingSystem).FreePhysicalMemory / 1MB
$inicioCPU = (Get-WmiObject Win32_PerfFormattedData_PerfOS_Processor | Where-Object {$_.Name -eq "_Total"}).PercentProcessorTime
$inicioDisco = (Get-PSDrive C).Free / 1GB
$inicioArchivosTemp = (Get-ChildItem "$env:TEMP" -Recurse | Measure-Object).Count

# Guardar los valores iniciales
$datosInicio = @"
===================================
  INFORME DE ESTADO DEL SISTEMA  
===================================
ANTES DE EJECUTAR MENU.PS1:
- RAM libre: $inicioRAM MB
- Uso de CPU: $inicioCPU%
- Espacio libre en C: $inicioDisco GB
- Archivos temporales: $inicioArchivosTemp
===================================
"@
$datosInicio | Out-File $archivoInforme

# Esperar a que `menu.ps1` termine su ejecución
Write-Host "`nEjecutando `menu.ps1`, espere..."

# Capturar estado final del sistema después de las optimizaciones
Start-Sleep -Seconds 10
$finalRAM = (Get-WmiObject Win32_OperatingSystem).FreePhysicalMemory / 1MB
$finalCPU = (Get-WmiObject Win32_PerfFormattedData_PerfOS_Processor | Where-Object {$_.Name -eq "_Total"}).PercentProcessorTime
$finalDisco = (Get-PSDrive C).Free / 1GB
$finalArchivosTemp = (Get-ChildItem "$env:TEMP" -Recurse | Measure-Object).Count

# Agregar los valores finales al informe
$datosFinal = @"
DESPUES DE EJECUTAR MENU.PS1:
- RAM libre: $finalRAM MB
- Uso de CPU: $finalCPU%
- Espacio libre en C: $finalDisco GB
- Archivos temporales: $finalArchivosTemp
===================================
CAMBIOS DETECTADOS:
- Diferencia de RAM: $(($finalRAM - $inicioRAM)) MB
- Diferencia de espacio en disco: $(($finalDisco - $inicioDisco)) GB
- Archivos temporales eliminados: $(($inicioArchivosTemp - $finalArchivosTemp))
===================================
"@
$datosFinal | Out-File -Append $archivoInforme

# Mostrar el informe solo al finalizar menu.ps1
if ($args[0] -eq "mostrar") {
    Get-Content $archivoInforme
    Write-Host "`nPresiona una tecla para salir..." -ForegroundColor Green
    Pause
}

Get-Content $archivoInforme
Write-Host "`nPresiona una tecla para salir..." -ForegroundColor Green
Pause
