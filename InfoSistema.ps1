# Establecer codificacion
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

Write-Host "`n==================================="
Write-Host "      INFORMACION DETALLADA DEL SISTEMA      "
Write-Host "==================================="

# Procesador y RAM
Write-Host "`nPROCESADOR Y MEMORIA RAM" -ForegroundColor Yellow
$cpu = Get-WmiObject Win32_Processor | Select-Object Name, MaxClockSpeed, NumberOfCores
$ram = (Get-WmiObject Win32_PhysicalMemory | Measure-Object Capacity -Sum).Sum / 1GB
Write-Host "Procesador: $($cpu.Name)" -ForegroundColor Green
Write-Host "Velocidad: $($cpu.MaxClockSpeed) MHz | Nucleos: $($cpu.NumberOfCores)" -ForegroundColor Green
Write-Host "Memoria RAM instalada: $ram GB" -ForegroundColor Green

# Tiempo de uso del sistema (corregido)
Write-Host "`nTIEMPO DE USO DEL SISTEMA" -ForegroundColor Yellow
$so = Get-WmiObject Win32_OperatingSystem | Select-Object LastBootUpTime
$ultimaInicio = [System.Management.ManagementDateTimeConverter]::ToDateTime($so.LastBootUpTime)
$tiempoUso = (Get-Date) - $ultimaInicio
Write-Host "Tiempo desde el ultimo arranque: $($tiempoUso.Days) dias, $($tiempoUso.Hours) horas, $($tiempoUso.Minutes) minutos" -ForegroundColor Green

# Estado de la bateria
Write-Host "`nESTADO DE LA BATERIA" -ForegroundColor Yellow
$bateria = Get-WmiObject Win32_Battery | Select-Object EstimatedChargeRemaining, Status
if ($bateria) {
    Write-Host "Estado: $($bateria.Status) | Carga: $($bateria.EstimatedChargeRemaining)%" -ForegroundColor Green
} else {
    Write-Host "No se detecto bateria en el sistema." -ForegroundColor Red
}

# Sistema Operativo
Write-Host "`nSISTEMA OPERATIVO" -ForegroundColor Yellow
Write-Host "Sistema Operativo: $($so.Caption) | Build: $($so.BuildNumber)" -ForegroundColor Green
Write-Host "Ultimo inicio: $($so.LastBootUpTime)" -ForegroundColor Green
Write-Host "Fecha de instalacion: $($so.InstallDate)" -ForegroundColor Green

# 🔹 Porcentaje de uso del disco
Write-Host "`nUSO DEL DISCO" -ForegroundColor Yellow
$discoC = Get-PSDrive C
$usoDisco = (($discoC.Used) / ($discoC.Used + $discoC.Free)) * 100
Write-Host "Disco C: $([math]::Round($usoDisco,2))% ocupado" -ForegroundColor Green

# Tarjeta grafica y VRAM
Write-Host "`nTARJETA GRAFICA" -ForegroundColor Yellow
$gpu = Get-WmiObject Win32_VideoController | Select-Object Name, AdapterRAM
$gpuRAMValue = $gpu.AdapterRAM | Select-Object -First 1

if ($gpuRAMValue -match "\d+") {
    $gpuVRAM = [math]::Round(($gpuRAMValue / 1073741824), 2)
    Write-Host "Tarjeta grafica: $($gpu.Name)" -ForegroundColor Green
    Write-Host "Memoria VRAM: $gpuVRAM GB" -ForegroundColor Green
} else {
    Write-Host "No se pudo obtener la memoria VRAM." -ForegroundColor Red
}

# 🔹 Version de DirectX
Write-Host "`nVERSION DE DIRECTX" -ForegroundColor Yellow
$directX = Get-WmiObject Win32_VideoController | Select-Object DriverVersion
Write-Host "Version instalada: $($directX.DriverVersion)" -ForegroundColor Green

Write-Host "`n===================================" -ForegroundColor Cyan
Write-Host "       FIN DEL INFORME       " -ForegroundColor Cyan
Write-Host "===================================" -ForegroundColor Cyan

Write-Host "`nPresiona una tecla para salir..." -ForegroundColor Green
Pause
