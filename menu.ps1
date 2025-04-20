# Establecer la codificación para evitar errores con caracteres especiales
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

# 🔒 AUTENTICACION ANTES DE MOSTRAR EL MENU
Write-Host "Autenticando..." -ForegroundColor Yellow

# Descargar el archivo de usuarios desde GitHub
$usuariosUrl = "https://raw.githubusercontent.com/EdgardJamen/REPARANDO2025/main/usuarios.csv"
$usuariosPath = "$env:TEMP\usuarios.csv"
Invoke-WebRequest -Uri $usuariosUrl -OutFile $usuariosPath

# Importar datos de usuarios desde el CSV descargado
$usuarios = Import-Csv $usuariosPath

# Solicitar credenciales
$nombreIngresado = Read-Host "Ingrese su nombre"
$contrasenaIngresada = Read-Host "Ingrese su contrasena"

# Limpieza de espacios y comparación sin diferenciar mayúsculas/minúsculas
$autenticado = $usuarios | Where-Object { 
    $_.Nombre.Trim() -ieq $nombreIngresado.Trim() -and 
    $_.Contrasena.Trim() -ieq $contrasenaIngresada.Trim() 
}

if ($autenticado) {
    Write-Host "✅ Autenticación exitosa. Cargando el menú..." -ForegroundColor Green
    Start-Sleep -Seconds 2
} else {
    Write-Host "❌ Error: Nombre o contraseña incorrectos." -ForegroundColor Red
    Exit
}
# 🔹 INTERFAZ MEJORADA DEL MENÚ

# Obtener el ancho de la ventana para adaptarse a cambios
$width = $Host.UI.RawUI.WindowSize.Width
$line = "=" * $width

# Función para escribir un texto centrado en la consola
function Write-Centered {
    param(
        [string]$text,
        [ConsoleColor]$ForegroundColor = "White",
        [ConsoleColor]$BackgroundColor = "Black"
    )
    # Calcular la cantidad de espacios a la izquierda para centrar
    $padding = ($width - $text.Length) / 2
    if ($padding -lt 0) { $padding = 0 }
    $leftSpaces = " " * [Math]::Floor($padding)
    Write-Host "$leftSpaces$text" -ForegroundColor $ForegroundColor -BackgroundColor $BackgroundColor
}

Clear-Host
# Encabezado con fondo oscuro para resaltar
Write-Host $line -ForegroundColor Cyan -BackgroundColor Black
Write-Centered "Reparando.mercedes es un trabajo desarrollado por :" -ForegroundColor Yellow -BackgroundColor Black
Write-Centered "Técnico: Gabriel Jamen" -ForegroundColor Yellow -BackgroundColor Black
Write-Host $line -ForegroundColor Cyan -BackgroundColor Black
Write-Host ""

# Mensaje de suscripción bien visible
Write-Host "POR SUSCRIPCIÓN: COMUNICARSE AL +598 096790694" -ForegroundColor Magenta -BackgroundColor Black
Write-Host ""

# Menú de opciones con encabezado llamativo
Write-Host "Elige una opción:" -ForegroundColor White -BackgroundColor DarkBlue
Write-Host ""
Write-Host " 1. Optimización del sistema" -ForegroundColor Green
Write-Host " 2. Activador de Windows /En desarrollo" -ForegroundColor Yellow
Write-Host " 3. Activador de Excel /En desarrollo" -ForegroundColor Yellow
Write-Host " 4. Limpieza de registros" -ForegroundColor Green
Write-Host " 5. Diagnóstico y optimización del disco duro HDD" -ForegroundColor Green
Write-Host " 6. Diagnóstico y optimización del disco duro SSD" -ForegroundColor Green
Write-Host " 7. Crear Punto de Restauración" -ForegroundColor Green
Write-Host " 8. Optimizar inicio y servicios" -ForegroundColor Red
Write-Host " 9. Registro de Actividades (Logs)" -ForegroundColor Green
Write-Host " 10. Listar los archivos disponibles" -ForegroundColor Green
Write-Host " 11. Salir" -ForegroundColor Red

# Capturar elección del usuario
$opcion = Read-Host "Selecciona una opción (1-11)"
