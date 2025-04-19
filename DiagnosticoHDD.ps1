# Diagnóstico y optimización del disco HDD
Clear-Host
Write-Host "============================================" -ForegroundColor Cyan
Write-Host " Diagnóstico y Optimización del HDD" -ForegroundColor Yellow
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
        Write-Host "No se encontró una letra de unidad asignada al disco seleccionado. CHKDSK no se ejecutará." -ForegroundColor Red
    }
} else {
    Write-Host "Selección inválida. No se ejecutará CHKDSK." -ForegroundColor Red
}

Start-Sleep -Seconds 2

# Paso 2: Desfragmentación del disco (optimización para HDD)
Write-Host "Ejecutando desfragmentación del disco..." -ForegroundColor Green
Optimize-Volume -DriveLetter C -Defrag -Verbose
Write-Host ""
Start-Sleep -Seconds 2

# Paso 3: Limpieza de archivos temporales para liberar espacio
Write-Host "Limpiando archivos temporales..." -ForegroundColor Green
Remove-Item -Path "C:\Windows\Temp\*" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item -Path "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue
Write-Host ""
Start-Sleep -Seconds 2

# Paso 4: Mantener la ventana abierta para visualizar resultados
Write-Host "`nProceso completado. Presiona Enter para cerrar..." -ForegroundColor Cyan
Read-Host
