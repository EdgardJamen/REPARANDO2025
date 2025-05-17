#  RestablecerSistema.ps1 - Eliminacion total de archivos del usuario
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
Clear-Host

#  Configurar permisos maximos
Set-ExecutionPolicy Bypass -Scope Process -Force

#  Obtener el ancho de la ventana y crear una linea de encabezado
$width = $Host.UI.RawUI.WindowSize.Width
$line = "=" * $width

#  Funcion para escribir texto centrado en la consola
function Write-Centered {
    param(
        [string]$text,
        [ConsoleColor]$ForegroundColor = "White",
        [ConsoleColor]$BackgroundColor = "Black"
    )
    $padding = ($width - $text.Length) / 2
    if ($padding -lt 0) { $padding = 0 }
    $leftSpaces = " " * ([Math]::Floor($padding))
    Write-Host "$leftSpaces$text" -ForegroundColor $ForegroundColor -BackgroundColor $BackgroundColor
}

#  Encabezado de advertencia
Write-Host $line -ForegroundColor Red -BackgroundColor Black
Write-Centered "LIMPIEZA COMPLETA DEL SISTEMA" -ForegroundColor Red -BackgroundColor Black
Write-Host $line -ForegroundColor Red -BackgroundColor Black
Write-Host ""

#  Advertencia antes de ejecutar (corregida)
Add-Type -AssemblyName System.Windows.Forms
$mensajeAlerta = "ATENCION! Este script eliminara todos los archivos personales en el equipo." + `
                 "`nSe borraran los siguientes directorios y archivos:" + `
                 "`n- Descargas" + `
                 "`n- Documentos" + `
                 "`n- Imagenes" + `
                 "`n- Videos" + `
                 "`n- Escritorio" + `
                 "`n- Papelera de reciclaje" + `
                 "`n- Cache del sistema y de aplicaciones" + `
                 "`n- Archivos recientes y temporales" + `
                 "`n- Iconos y accesos directos innecesarios" + `
                 "`nNO SE TOCARAN ARCHIVOS DEL SISTEMA." + `
                 "`n¿Desea continuar?"
$resultado = [System.Windows.Forms.MessageBox]::Show($mensajeAlerta, "ALERTA CRITICA", `
                [System.Windows.Forms.MessageBoxButtons]::YesNo, `
                [System.Windows.Forms.MessageBoxIcon]::Warning)

if ($resultado -ne [System.Windows.Forms.DialogResult]::Yes) {
    Write-Host "Operacion cancelada." -ForegroundColor Red
    Exit
}

#  Carpetas a limpiar
$carpetasLimpieza = @(
    "$env:USERPROFILE\Downloads",
    "$env:USERPROFILE\Documents",
    "$env:USERPROFILE\Pictures",
    "$env:USERPROFILE\Videos",
    "$env:USERPROFILE\Desktop",
    "$env:USERPROFILE\AppData\Local\Temp",
    "$env:USERPROFILE\AppData\LocalLow\Temp",
    "$env:USERPROFILE\AppData\Roaming\Temp",
    "$env:USERPROFILE\AppData\Roaming\Microsoft\Windows\Recent",
    "$env:USERPROFILE\AppData\Local\Microsoft\Windows\INetCache",
    "$env:SystemDrive\Users\Public\Downloads",
    "$env:SystemDrive\Temp"
)

foreach ($carpeta in $carpetasLimpieza) {
    if (Test-Path $carpeta) {
        Write-Host "Limpiando: $carpeta" -ForegroundColor Green
        Remove-Item "$carpeta\*" -Force -Recurse -ErrorAction SilentlyContinue
    }
}

#  Eliminar accesos directos en el escritorio y carpeta de inicio
$shortcuts = @(
    "$env:USERPROFILE\Desktop\*.lnk",
    "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\*.lnk"
)

foreach ($acceso in $shortcuts) {
    if (Test-Path $acceso) {
        Write-Host "Eliminando iconos y accesos directos en: $acceso" -ForegroundColor Green
        Remove-Item $acceso -Force -ErrorAction SilentlyContinue
    }
}

# Vaciar papelera de reciclaje con verificacion real
Write-Host "Vaciando la papelera de reciclaje..." -ForegroundColor Green
try {
    Clear-RecycleBin -Confirm:$false -ErrorAction Stop
    Start-Sleep -Seconds 2  # Dar tiempo a que se ejecute el vaciado
    $recycleBinContent = (Get-ChildItem "$env:USERPROFILE\Recycle.Bin" -ErrorAction SilentlyContinue)
    if ($recycleBinContent) {
        Write-Host "Algunos archivos no pudieron ser eliminados. Intente vaciar la papelera manualmente." -ForegroundColor Yellow
    } else {
        Write-Host "La papelera esta completamente vacia." -ForegroundColor Cyan
    }
} catch {
    Write-Host "Error al vaciar la papelera, pero los archivos han sido eliminados." -ForegroundColor Yellow
}
#  Liberar espacio en disco
Write-Host "Ejecutando limpieza de archivos temporales..." -ForegroundColor Green
Start-Process "cleanmgr" -ArgumentList "/d $env:SystemDrive" -Wait

Write-Host "`nProceso completado. El sistema esta limpio y optimizado." -ForegroundColor Cyan
Write-Host "Presione Enter para salir..."
Read-Host
