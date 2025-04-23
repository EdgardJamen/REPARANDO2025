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

# Temperatura del CPU
Write-Host "`nTEMPERATURA DEL CPU" -ForegroundColor Yellow
$cpuTempWmic = wmic /namespace:\\root\wmi PATH MSAcpi_ThermalZoneTemperature GET CurrentTemperature
if ($cpuTempWmic -match "\d+") {
    $tempCelsius = ($cpuTempWmic - 2732) / 10
    Write-Host "Temperatura del CPU: $tempCelsius C" -ForegroundColor Green
} else {
    Write-Host "No se pudo obtener la temperatura del CPU." -ForegroundColor Red
}

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
$so = Get-WmiObject Win32_OperatingSystem | Select-Object Caption, BuildNumber, InstallDate, LastBootUpTime
Write-Host "Sistema Operativo: $($so.Caption) | Build: $($so.BuildNumber)" -ForegroundColor Green
Write-Host "Ultimo inicio: $($so.LastBootUpTime)" -ForegroundColor Green
Write-Host "Fecha de instalacion: $($so.InstallDate)" -ForegroundColor Green

# Discos y almacenamiento
Write-Host "`nINFORMACION DE DISCOS" -ForegroundColor Yellow
$discos = Get-PhysicalDisk | Select-Object DeviceID, MediaType, Size, HealthStatus
$discos | Format-Table DeviceID, MediaType, Size, HealthStatus -AutoSize

# Uso de CPU y RAM
Write-Host "`nRENDIMIENTO DEL SISTEMA" -ForegroundColor Yellow
$usoCPU = (Get-WmiObject Win32_PerfFormattedData_PerfOS_Processor | Where-Object {$_.Name -eq "_Total"}).PercentProcessorTime
$usoRAM = (Get-WmiObject Win32_OperatingSystem).FreePhysicalMemory / 1MB
Write-Host "Uso de CPU: $usoCPU%" -ForegroundColor Green
Write-Host "RAM libre: $usoRAM MB" -ForegroundColor Green

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

# Red y conexion
Write-Host "`nCONEXION DE RED" -ForegroundColor Yellow
$ipPrivada = (Get-NetIPAddress -AddressFamily IPv4 | Where-Object { $_.InterfaceAlias -ne "Loopback" }).IPAddress
$velocidadRed = Get-NetAdapter | Select-Object Name, LinkSpeed
Write-Host "IP Privada: $ipPrivada" -ForegroundColor Green
Write-Host "Velocidad de conexion: $($velocidadRed.LinkSpeed)" -ForegroundColor Green

# Programas instalados
Write-Host "`nPROGRAMAS INSTALADOS" -ForegroundColor Yellow
$programas = Get-WmiObject Win32_Product | Select-Object Name, Version | Sort-Object Name
$programas | Format-Table Name, Version -AutoSize

Write-Host "`n===================================" -ForegroundColor Cyan
Write-Host "       FIN DEL INFORME       " -ForegroundColor Cyan
Write-Host "===================================" -ForegroundColor Cyan

Write-Host "`nPresiona Enter para volver al menu..." -ForegroundColor Green
Read-Host
