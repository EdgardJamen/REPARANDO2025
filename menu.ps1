# Establecer la codificacion para evitar errores con caracteres especiales
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
# Autenticacion antes de mostrar el menu
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

# Limpieza de espacios y comparacion sin diferenciar mayusculas/minusculas
$usuarioActivo = $usuarios | Where-Object { 
    $_.Nombre.Trim() -ieq $nombreIngresado.Trim() -and 
    $_.Contrasena.Trim() -ieq $contrasenaIngresada.Trim() 
}

if ($usuarioActivo) {
    $nombreUsuario = $usuarioActivo.Nombre
    $suscripcionVence = $usuarioActivo.Vence

    Write-Host "Autenticacion exitosa. Cargando el menu..." -ForegroundColor Green
    Start-Sleep -Seconds 2
} else {
    Write-Host "Error: Nombre o contrasena incorrectos." -ForegroundColor Red
    Exit
}
# Iniciar el menu despues de autenticacion
do {
 # Obtener el ancho de la ventana
$width = $Host.UI.RawUI.WindowSize.Width
$line = "=" * $width

# Función para escribir texto centrado
function Write-Centered {
    param(
        [string]$text,
        [ConsoleColor]$ForegroundColor = "White",
        [ConsoleColor]$BackgroundColor = "Black"
    )
    $padding = ($width - $text.Length) / 2
    if ($padding -lt 0) { $padding = 0 }
    $leftSpaces = " " * [Math]::Floor($padding)
    Write-Host "$leftSpaces$text" -ForegroundColor $ForegroundColor -BackgroundColor $BackgroundColor
}

# Crear un recuadro elegante para la cabecera
Clear-Host
Write-Host $line -ForegroundColor Cyan -BackgroundColor Black
Write-Centered "SISTEMA DESARROLLADO POR" -ForegroundColor White -BackgroundColor Black
Write-Centered "TECNICO: GABRIEL JAMEN" -ForegroundColor Yellow -BackgroundColor Black
Write-Host $line -ForegroundColor Cyan -BackgroundColor Black
Write-Host ""

# Eliminar fondo azul del texto del menu

# Mostrar informacion del usuario logueado
Write-Host "Usuario: $nombreUsuario" -ForegroundColor White
Write-Host "Suscripcion vence el: $suscripcionVence" -ForegroundColor Yellow
Write-Host ""

# Mensaje de suscripcion
Write-Host "Por suscripcion, comunicarse al +598 096790694" -ForegroundColor Magenta
Write-Host ""

Write-Host "Seleccione una opcion:" -ForegroundColor White

    Write-Host ""

    Write-Host "Seleccione una opcion:" -ForegroundColor White -BackgroundColor DarkBlue
    Write-Host " 1. Optimizacion del sistema" -ForegroundColor Green
    Write-Host " 2. Activador de Windows (En desarrollo)" -ForegroundColor Yellow
    Write-Host " 3. Activador de Excel (En desarrollo)" -ForegroundColor Yellow
    Write-Host " 4. Limpieza de registros" -ForegroundColor Green
    Write-Host " 5. Diagnostico y optimizacion del disco duro HDD" -ForegroundColor Green
    Write-Host " 6. Diagnostico y optimizacion del disco duro SSD" -ForegroundColor Green
    Write-Host " 7. Crear Punto de Restauracion" -ForegroundColor Green
    Write-Host " 8. Optimizar inicio y servicios" -ForegroundColor Red
    Write-Host " 9. Registro de actividades (Logs)" -ForegroundColor Green
    Write-Host " 10. Listar los archivos disponibles" -ForegroundColor Green
    Write-Host " 11. Salir" -ForegroundColor Red

    # Capturar eleccion del usuario
    $opcion = Read-Host "Ingrese una opcion (1-11)"

    if ($opcion -eq "11") {
        Write-Host "Saliendo del sistema..." -ForegroundColor Red
        break
    }
} while ($true)  # ✅ Se asegura que
