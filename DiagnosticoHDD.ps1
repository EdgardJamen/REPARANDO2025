# Diagnóstico y optimizacion del disco HDD
Clear-Host
Write-Host "============================================" -ForegroundColor Cyan
Write-Host " Diagnostico y Optimizacion del HDD" -ForegroundColor Yellow
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""

# Paso 1: Obtener lista de discos disponibles
Write-Host "Obteniendo lista de discos conectados..." -ForegroundColor Green
$discos = Get-PhysicalDisk | Select-Object DeviceId, MediaType, Size

# Mostrar la lista de discos
$discos | Format-Table -AutoSize
Write-Host "`nSeleccione el disco que desea analizar con CHKDSK."
$discoSeleccionado = Read-Host "Ingrese el número del disco (DeviceId)"

# Verificar si la entrada es válida
if ($discos.DeviceId -contains [int]$discoSeleccionado) {
    # Obtener la letra de unidad del disco seleccionado
    $unidad = (Get-Partition | Where-Object { $_.DiskNumber -eq $discoSeleccionado } | Select-Object -ExpandProperty DriveLetter)

    if ($unidad) {
        Write-Host "`nEjecutando CHKDSK en la unidad $unidad: (puede requerir tiempo...)" -ForegroundColor Green
        Start-Process -FilePath "cmd.exe" -ArgumentList "/c chkdsk $unidad: /f /r" -WindowStyle Normal -Wait
    } else {
        Write-Host "No se encontro una letra de unidad asignada al disco seleccionado. CHKDSK no se ejecutara." -ForegroundColor Red
    }
} else {
    Write-Host "Selección invalida. No se ejecutara CHKDSK." -ForegroundColor Red
}

Start-Sleep -Seconds 2

# Paso 2: Desfragmentación del disco (optimizacion para HDD)
Write-Host "Ejecutando desfragmentacion del disco..." -ForegroundColor Green
Optimize-Volume -DriveLetter C -Defrag -Verbose
Write-Host ""
Start-Sleep -Seconds 2

# Paso 3: Limpieza de archivos temporales para liberar espacio
Write-Host "Limpiando ..." -ForegroundColor Green
Remove-Item -Path "C:\Windows\Temp\*" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item -Path "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue
Write-Host "Su disco se optimizo al maximo" -ForegroundColor Green
Start-Sleep -Seconds 2

# Paso 4: Mantener la ventana abierta para visualizar resultados
Write-Host "`nProceso completado. Presiona Enter para cerrar..." -ForegroundColor Cyan
Read-Host
