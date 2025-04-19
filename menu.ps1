[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

# 🔒 AUTENTICACIÓN ANTES DE MOSTRAR EL MENÚ
Write-Host "Descargando lista de usuarios desde GitHub..." -ForegroundColor Yellow

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
    Write-Host "Autenticación exitosa. Cargando el menú..." -ForegroundColor Green
    Start-Sleep -Seconds 2
} else {
    Write-Host "Error: Nombre o contraseña incorrectos." -ForegroundColor Red
    Exit
}

# 🔹 CONTINÚA EL MENÚ
do {
    # Obtener el ancho de la ventana (en cada iteracion para adaptarse a cambios)
    $width = $Host.UI.RawUI.WindowSize.Width
    # Crear una linea de "=" que llene el ancho de la ventana
    $line = "=" * $width

    # Funcion para escribir un texto centrado en la consola
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
    Write-Centered "Reparando MERCEDES 2025" -ForegroundColor Yellow -BackgroundColor Black
    Write-Centered "Tecnico: Gabriel Jamen" -ForegroundColor Yellow -BackgroundColor Black
    Write-Host $line -ForegroundColor Cyan -BackgroundColor Black
    Write-Host ""

    # Mensaje de suscripcion bien visible
    Write-Host "POR SUSCRIPCION: COMUNICARSE AL +598 096790694" -ForegroundColor Magenta -BackgroundColor Black
    Write-Host ""

    # Menú de opciones con encabezado llamativo
    Write-Host "Elige una opcion:" -ForegroundColor White -BackgroundColor DarkBlue
    Write-Host ""
    Write-Host " 1. Optimizacion del sistema" -ForegroundColor Green
    Write-Host " 2. Activador de Windows /En desarrollo" -ForegroundColor Yellow
    Write-Host " 3. Activador de Excel /En desarrollo" -ForegroundColor Yellow
    Write-Host " 4. Limpieza de registros" -ForegroundColor Green
    Write-Host " 5. Diagnostico y optimizacion del disco duro HDD" -ForegroundColor Green
    Write-Host " 6. Diagnostico y optimizacion del disco duro SSD" -ForegroundColor Green
    Write-Host " 7. Crear Punto de Restauracion" -ForegroundColor Green
    Write-Host " 8. Optimizar inicio y servicios" -ForegroundColor Red
    Write-Host " 9. Registro de Actividades (Logs)" -ForegroundColor Green
    Write-Host " 10. Listar los archivos disponibles" -ForegroundColor Green
    Write-Host " 11. Salir" -ForegroundColor Red
    
    # Capturar eleccion del usuario
    $opcion = Read-Host "Selecciona una opcion (1-10)"
    
switch ($opcion) {

"1" {
    Write-Host "Ejecutando optimización del sistema..." -ForegroundColor Green

    # Descargar el script desde GitHub
    $scriptUrl = "https://raw.githubusercontent.com/EdgardJamen/REPARANDO2025/main/optimizacion.ps1"
    $scriptPath = "$env:TEMP\optimizacion.ps1"
    Invoke-WebRequest -Uri $scriptUrl -OutFile $scriptPath

    # Ejecutar el script descargado
    Start-Process -FilePath "powershell.exe" `
        -ArgumentList "-ExecutionPolicy Bypass -File $scriptPath" `
        -WindowStyle Hidden -Wait -Verb RunAs

    Write-Host "`nOptimización completada. Presiona Enter para volver al menú..." -ForegroundColor Cyan
    Read-Host
}

"2" {
    Write-Host "Esta función aún no está implementada." -ForegroundColor Yellow
    Write-Host "`nPresiona Enter para volver al menú..." -ForegroundColor Cyan
    Read-Host
}
"3" {
    Write-Host "Esta función aún no está implementada." -ForegroundColor Yellow
    Write-Host "`nPresiona Enter para volver al menú..." -ForegroundColor Cyan
    Read-Host
}
"4" {
    Write-Host "Ejecutando limpieza de registros..." -ForegroundColor Green
    $scriptUrl = "https://raw.githubusercontent.com/EdgardJamen/REPARANDO2025/main/LimpiezaRegistros.ps1"
    $scriptPath = "$env:TEMP\LimpiezaRegistros.ps1"
    Invoke-WebRequest -Uri $scriptUrl -OutFile $scriptPath
    Start-Process -FilePath "powershell.exe" `
        -ArgumentList "-ExecutionPolicy Bypass -File $scriptPath" `
        -WindowStyle Hidden -Wait -Verb RunAs
    Write-Host "`nLimpieza completada. Presiona Enter para volver al menú..." -ForegroundColor Cyan
    Read-Host
}
 "5" {
    Write-Host "Ejecutando diagnóstico del disco HDD..." -ForegroundColor Green
    $scriptUrl = "https://raw.githubusercontent.com/EdgardJamen/REPARANDO2025/main/DiagnosticoHDD.ps1"
    $scriptPath = "$env:TEMP\DiagnosticoHDD.ps1"
    Invoke-WebRequest -Uri $scriptUrl -OutFile $scriptPath
    Start-Process -FilePath "powershell.exe" `
        -ArgumentList "-ExecutionPolicy Bypass -File $scriptPath" `
        -WindowStyle Hidden -Wait -Verb RunAs
    Write-Host "`nDiagnóstico completado. Presiona Enter para volver al menú..." -ForegroundColor Cyan
    Read-Host
}

"6" {
    Write-Host "Ejecutando proceso de diagnóstico..." -ForegroundColor Green
    $scriptUrl = "https://raw.githubusercontent.com/EdgardJamen/REPARANDO2025/main/DiagnosticoSSD.ps1"
    $scriptPath = "$env:TEMP\DiagnosticoSSD.ps1"
    Invoke-WebRequest -Uri $scriptUrl -OutFile $scriptPath

    # Verificar si la descarga fue exitosa antes de ejecutarlo
    if (Test-Path $scriptPath) {
        Start-Process -FilePath "powershell.exe" `
            -ArgumentList "-ExecutionPolicy Bypass -File $scriptPath" `
            -WindowStyle Normal -Wait -Verb RunAs
    } else {
        Write-Host "Error: No se pudo completar el proceso." -ForegroundColor Red
    }

    # Mostrar mensaje antes de limpiar los archivos
    Write-Host "`nFINALIZANDO..." -ForegroundColor Cyan
    Start-Sleep -Seconds 2  # Pausa para mostrar el mensaje antes de eliminar el archivo
    Remove-Item "$scriptPath" -Force -ErrorAction SilentlyContinue

    Write-Host "Presiona Enter para volver al menú..." -ForegroundColor Cyan
    Read-Host
}
"7" {
    Write-Host "Creando un punto de restauración del sistema..." -ForegroundColor Green
    $scriptUrl = "https://raw.githubusercontent.com/EdgardJamen/REPARANDO2025/main/CrearPuntoRestauracion.ps1"
    $scriptPath = "$env:TEMP\CrearPuntoRestauracion.ps1"
    Invoke-WebRequest -Uri $scriptUrl -OutFile $scriptPath
    Start-Process -FilePath "powershell.exe" `
        -ArgumentList "-ExecutionPolicy Bypass -File $scriptPath" `
        -WindowStyle Hidden -Wait -Verb RunAs
    Write-Host "`nPunto de restauración creado. Presiona Enter para volver al menú..." -ForegroundColor Cyan
    Read-Host
}

"8" {
    Write-Host "Optimizando los servicios de inicio..." -ForegroundColor Green
    $scriptUrl = "https://raw.githubusercontent.com/EdgardJamen/REPARANDO2025/main/OptimizarInicioServicios.ps1"
    $scriptPath = "$env:TEMP\OptimizarInicioServicios.ps1"
    Invoke-WebRequest -Uri $scriptUrl -OutFile $scriptPath
    Start-Process -FilePath "powershell.exe" `
        -ArgumentList "-ExecutionPolicy Bypass -File $scriptPath" `
        -WindowStyle Hidden -Wait -Verb RunAs
    Write-Host "`nOptimización completada. Presiona Enter para volver al menú..." -ForegroundColor Cyan
    Read-Host
}

"9" {
    Write-Host "Registrando actividad del sistema..." -ForegroundColor Green
    $scriptUrl = "https://raw.githubusercontent.com/EdgardJamen/REPARANDO2025/main/RegistroActividades.ps1"
    $scriptPath = "$env:TEMP\RegistroActividades.ps1"
    Invoke-WebRequest -Uri $scriptUrl -OutFile $scriptPath
    Start-Process -FilePath "powershell.exe" `
        -ArgumentList "-ExecutionPolicy Bypass -File $scriptPath" `
        -WindowStyle Hidden -Wait -Verb RunAs
    Write-Host "`nRegistro completado. Presiona Enter para volver al menú..." -ForegroundColor Cyan
    Read-Host
}
"10" {
    Write-Host "Listando los archivos disponibles en el repositorio..." -ForegroundColor Green
    Start-Process "cmd.exe" -ArgumentList "/c start https://github.com/EdgardJamen/REPARANDO2025"
    Write-Host "`nLista de archivos abierta en el navegador. Presiona Enter para volver al menú..." -ForegroundColor Cyan
    Read-Host
}
"11" {
    Write-Host "Saliendo del sistema..." -ForegroundColor Red
    Exit
}
Default {
    Write-Host "Opción no válida. Intenta nuevamente." -ForegroundColor Red
}
}

# Si no se escogió la opción de salir, se pide presionar Enter para continuar.
if ($opcion -ne "10") {
    Write-Host ""
    Write-Host "Presiona Enter para volver al menú ..." -ForegroundColor Cyan
    Read-Host
}
} while ($true)
