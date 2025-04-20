# Establecer la codificación para evitar errores con caracteres especiales
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

# Autenticación antes de mostrar el menú
Write-Host "Autenticando..." -ForegroundColor Yellow

# Descargar el archivo de usuarios desde GitHub
$usuariosUrl = "https://raw.githubusercontent.com/EdgardJamen/REPARANDO2025/main/usuarios.csv"
$usuariosPath = "$env:TEMP\usuarios.csv"
Invoke-WebRequest -Uri $usuariosUrl -OutFile $usuariosPath

# Importar datos de usuarios desde el CSV descargado
$usuarios = Import-Csv $usuariosPath

# Solicitar credenciales
$nombreIngresado = Read-Host "Ingrese su nombre"
$contrasenaIngresada = Read-Host "Ingrese su contraseña"

# Limpieza de espacios y comparación sin diferenciar mayúsculas/minúsculas
$autenticado = $usuarios | Where-Object { 
    $_.Nombre.Trim() -ieq $nombreIngresado.Trim() -and 
    $_.Contrasena.Trim() -ieq $contrasenaIngresada.Trim() 
}

if ($autenticado) {
    Write-Host "Autenticación exitosa. Cargando el menú..." -ForegroundColor Green
    Start-Sleep -Seconds 2
} else {
    Write-Host "Error: Nombre o contraseña incorrectos." -ForegroundColor Red
    Exit
}

# Iniciar el menú después de autenticación
do {
    Clear-Host
    Write-Host "=" * ($Host.UI.RawUI.WindowSize.Width) -ForegroundColor Cyan

    Write-Host "Sistema desarrollado por:" -ForegroundColor Yellow
    Write-Host "Técnico: Gabriel Jamen" -ForegroundColor Yellow
    Write-Host "=" * ($Host.UI.RawUI.WindowSize.Width) -ForegroundColor Cyan
    Write-Host ""

    Write-Host "Por suscripción, comunicarse al +598 096790694" -ForegroundColor Magenta
    Write-Host ""

    Write-Host "Seleccione una opción:" -ForegroundColor White -BackgroundColor DarkBlue
    Write-Host " 1. Optimización del sistema" -ForegroundColor Green
    Write-Host " 2. Activador de Windows (En desarrollo)" -ForegroundColor Yellow
    Write-Host " 3. Activador de Excel (En desarrollo)" -ForegroundColor Yellow
    Write-Host " 4. Limpieza de registros" -ForegroundColor Green
    Write-Host " 5. Diagnóstico y optimización del disco duro HDD" -ForegroundColor Green
    Write-Host " 6. Diagnóstico y optimización del disco duro SSD" -ForegroundColor Green
    Write-Host " 7. Crear Punto de Restauración" -ForegroundColor Green
    Write-Host " 8. Optimizar inicio y servicios" -ForegroundColor Red
    Write-Host " 9. Registro de actividades (Logs)" -ForegroundColor Green
    Write-Host " 10. Listar los archivos disponibles" -ForegroundColor Green
    Write-Host " 11. Salir" -ForegroundColor Red

    # Capturar elección del usuario
    $opcion = Read-Host "Ingrese una opción (1-11)"

    if ($opcion -eq "11") {
        Write-Host "Saliendo del sistema..." -ForegroundColor Red
        break
    }
} while ($true)  # ✅ Se asegura que el bucle tenga su cierre correcto
