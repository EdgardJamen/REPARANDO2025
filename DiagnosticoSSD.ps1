# DiagnosticoSSD.ps1 - Script mejorado para diagnosticar y optimizar SSD

Clear-Host

# Encabezado
Write-Host "============================================" -ForegroundColor Cyan
Write-Host " Diagnostico y Optimizacion del SSD" -ForegroundColor Yellow
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""

# Información general del disco
Write-Host "Obteniendo informacion del SSD..." -ForegroundColor Green
Get-PhysicalDisk | Select-Object FriendlyName, MediaType, HealthStatus, OperationalStatus, Size | Format-Table -AutoSize
Write-Host ""

# Verificar si TRIM está activado
Write-Host "Verificando si TRIM esta activado..." -ForegroundColor Green
$fsutilOutput = fsutil behavior query DisableDeleteNotify
$trimStatus = if ($fsutilOutput -match "DisableDeleteNotify\s*=\s*0") { "Activado" } else { "Desactivado" }
Write-Host "Estado TRIM: $trimStatus" -ForegroundColor Yellow
Write-Host ""

# Ejecutar TRIM manualmente (Optimización del SSD)
Write-Host "Ejecutando Optimize-Volume para TRIM..." -ForegroundColor Green
Optimize-Volume -DriveLetter C -ReTrim -Verbose
Write-Host ""

# Información SMART del SSD
Write-Host "Obteniendo atributos SMART..." -ForegroundColor Green
wmic diskdrive get Model, Status, FirmwareRevision, SerialNumber, Size
Write-Host ""

# Estado de sectores defectuosos en el SSD
Write-Host "Verificando sectores defectuosos..." -ForegroundColor Green
wmic diskdrive get Status
Write-Host ""

# Análisis de uso del SSD
Write-Host "Analizando uso del almacenamiento..." -ForegroundColor Green
Get-Volume | Select-Object DriveLetter, FileSystem, SizeRemaining, Capacity | Format-Table -AutoSize
Write-Host ""

# Limpieza de archivos temporales
Write-Host "Limpiando archivos temporales..." -ForegroundColor Green
Remove-Item -Path "C:\Windows\Temp\*" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item -Path "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue
Write-Host ""

# Espera para que la ventana permanezca abierta
Write-Host "`nProceso completo. Presiona Enter para cerrar..." -ForegroundColor Cyan
Read-Host

# Esperar unos segundos antes de limpiar los archivos
Start-Sleep -Seconds 2  

# Eliminar el archivo descargado de forma silenciosa
Remove-Item "$PSCommandPath" -Force -ErrorAction SilentlyContinue
