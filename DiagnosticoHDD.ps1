# DiagnosticoHDD.ps1
# Script para diagnosticar y optimizar un disco HDD

Clear-Host

# Encabezado
Write-Host "============================================" -ForegroundColor Cyan
Write-Host "  Diagnóstico y Optimización del HDD" -ForegroundColor Yellow
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""

# Paso 1: Mostrar información del disco
Write-Host "Obteniendo información del disco:" -ForegroundColor Green
Get-PhysicalDisk | Select-Object MediaType, HealthStatus, Size | Format-Table -AutoSize
Write-Host ""

# Paso 2: Ejecutar CHKDSK para detectar y reparar errores en el disco
Write-Host "Ejecutando CHKDSK en el disco C: (puede requerir tiempo...)" -ForegroundColor Green
# Se usa cmd.exe para ejecutar CHKDSK; la opción /f intenta corregir errores y /r localiza sectores defectuosos.
Start-Process -FilePath "cmd.exe" -ArgumentList "/c chkdsk C: /f /r" -NoNewWindow -Wait
Write-Host ""

# Paso 3: Desfragmentación del disco (optimización para HDD)
Write-Host "Ejecutando desfragmentación del disco..." -ForegroundColor Green
# Para discos HDD se recomienda la desfragmentación; Optimize-Volume con -Defrag realiza esta tarea.
Optimize-Volume -DriveLetter C -Defrag -Verbose
Write-Host ""

# Paso 4: Limpieza de archivos temporales para liberar espacio
Write-Host "Limpiando archivos temporales..." -ForegroundColor Green
Remove-Item -Path "C:\Windows\Temp\*" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item -Path "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue
Write-Host ""

# Paso 5: Mantener la ventana abierta para visualizar resultados
Write-Host "`nProceso completado. Presiona Enter para cerrar..." -ForegroundColor Cyan
Read-Host
