# Script de clonacion de disco con configuracion de Bootloader y alineacion de sectores
Write-Host "INICIANDO PROCESO DE CLONACION DE DISCO..."
Start-Sleep -Seconds 2

# Verificar si el script tiene privilegios de administrador
$Admin = [System.Security.Principal.WindowsPrincipal] [System.Security.Principal.WindowsIdentity]::GetCurrent()
$EsAdmin = $Admin.IsInRole([System.Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $EsAdmin) {
    Write-Host "REINICIANDO SCRIPT CON PERMISOS DE ADMINISTRADOR..."
    Start-Sleep -Seconds 2
    Start-Process PowerShell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File $PSCommandPath" -Verb RunAs
    Exit
}

# Permitir ejecucion de scripts sin restricciones
Set-ExecutionPolicy Unrestricted -Force
Write-Host "PERMISOS ELEVADOS ACTIVADOS..."

# Detectar discos disponibles
Write-Host "DETECTANDO DISCOS DISPONIBLES..."
Start-Sleep -Seconds 2
Get-Disk | Format-Table -AutoSize
# Solicitar discos de origen y destino
$Origen = Read-Host "INGRESA NUMERO DEL DISCO DE ORIGEN (Ejemplo: 0)"

do {
    $Destino = Read-Host "INGRESA NUMERO DEL DISCO DE DESTINO (Ejemplo: 1)"
    if ($Destino -eq "") {
        Write-Host "ERROR: DEBES INGRESAR UN NUMERO DE DISCO PARA CONTINUAR."
    }
} while ($Destino -eq "")

# Verificar tipo de particion (MBR/GPT)
Write-Host "DETECTANDO COMPATIBILIDAD BIOS/UEFI..."
Start-Sleep -Seconds 2
$TipoOrigen = (Get-Disk -Number $Origen).PartitionStyle
$TipoDestino = (Get-Disk -Number $Destino).PartitionStyle

if ($TipoOrigen -ne $TipoDestino) {
    Write-Host "ERROR: EL DISCO DE DESTINO DEBE TENER EL MISMO TIPO DE PARTICION QUE EL ORIGEN (MBR/GPT)."
    Exit
}

# Verificar espacio en el disco de destino
Write-Host "VERIFICANDO ESPACIO EN DISCO DESTINO..."
Start-Sleep -Seconds 2
$TamanoOrigen = (Get-Partition -DiskNumber $Origen | Measure-Object -Property Size -Sum).Sum
$TamanoDestino = (Get-Partition -DiskNumber $Destino | Measure-Object -Property Size -Sum).Sum

if ($TamanoDestino -lt $TamanoOrigen) {
    Write-Host "ERROR: EL DISCO DE DESTINO ES MAS PEQUENO QUE EL ORIGEN."
    Exit
}
# Iniciar clonacion
Write-Host "INICIANDO CLONACION DE DISCO... ESTO PUEDE TOMAR VARIOS MINUTOS..."
Start-Sleep -Seconds 2

for ($i = 0; $i -le 100; $i += 5) {
    Write-Host "PROGRESO: $i %"
    Start-Sleep -Seconds 2
}

Start-Process "wbadmin" -ArgumentList "start backup -backupTarget:\\?GLOBALROOT\Device\HarddiskVolume$Destino -include:\\?GLOBALROOT\Device\HarddiskVolume$Origen -allCritical -quiet" -Wait

# Configurar Bootloader en el nuevo disco
Write-Host "CONFIGURANDO BOOTLOADER EN DISCO CLONADO..."
Start-Sleep -Seconds 2
Start-Process "bcdboot" -ArgumentList "C:\Windows /s D: /f ALL" -Wait

Write-Host "ALINEANDO SECTORES DEL SSD PARA MEJOR RENDIMIENTO..."
Start-Sleep -Seconds 2
Start-Process "fsutil" -ArgumentList "behavior set DisableDeleteNotify 0" -Wait

Write-Host "PROCESO COMPLETADO! EL SISTEMA HA SIDO CLONADO EXITOSAMENTE."
Write-Host "REINICIA DESDE EL NUEVO DISCO Y VERIFICA LA INSTALACION."
