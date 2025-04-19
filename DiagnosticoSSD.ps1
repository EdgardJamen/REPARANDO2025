# DiagnosticoSSD.ps1
# Script para diagnosticar y optimizar el SSD

Clear-Host

# Encabezado
Write-Host "============================================" -ForegroundColor Cyan
Write-Host "  Diagnostico y Optimizacion del SSD" -ForegroundColor Yellow
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""

# Información del disco
Write-Host "Obteniendo informacion del disco:" -ForegroundColor Green
Get-PhysicalDisk | Select-Object MediaType, HealthStatus, Size | Format-Table -AutoSize
Write-Host ""

# Verificar si TRIM está activado
Write-Host "Verificando si TRIM esta activado..." -ForegroundColor Green
$fsutilOutput = fsutil behavior query DisableDeleteNotify
if ($fsutilOutput -match "DisableDeleteNotify\s*=\s*0") {
    $trimStatus = "Activado"
} else {
    $trimStatus = "Desactivado"
}
Write-Host "Estado TRIM: $trimStatus" -ForegroundColor Yellow
Write-Host ""

# Ejecutar TRIM manualmente (Optimización del SSD)
Write-Host "Ejecutando Optimize-Volume para TRIM..." -ForegroundColor Green
Optimize-Volume -DriveLetter C -ReTrim -Verbose
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
