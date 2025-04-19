[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

# 🔒 AUTENTICACIÓN ANTES DE MOSTRAR EL MENÚ
Write-Host "Descargando lista de usuarios desde la base de datos..." -ForegroundColor Yellow

# Descargar el archivo de Google Drive
$usuariosUrl = "https://drive.google.com/uc?id=1uTlgJQ_q1kU_52IVswok1rUyRSAUfi2X"
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
    Write-Host "Ejecutando optimización ..." -ForegroundColor Green
    
    # Descargar y ejecutar el script desde Google Drive
    $scriptUrl = "https://drive.google.com/uc?id=1PElKaMeOl-a2ku2intKEt6KVgG9S6UIm"
    $scriptContent = (Invoke-WebRequest -Uri $scriptUrl).Content
    
    # Ejecutar el script en tiempo real
    Invoke-Expression $scriptContent
    
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
    
    # Descargar y ejecutar el script desde Google Drive
    $scriptUrl = "https://drive.google.com/uc?id=1jko6e0AJGhmNHyDXSJQ8NMPqIP2iUdpT"
    $scriptContent = (Invoke-WebRequest -Uri $scriptUrl).Content
    
    # Ejecutar el script en tiempo real
    Invoke-Expression $scriptContent
    
    Write-Host "`nProceso completado. Presiona Enter para volver al menú..." -ForegroundColor Cyan
    Read-Host
}
 "5" {
    Write-Host "Ejecutando optimizacion de disco hdd..." -ForegroundColor Green
    
    # Descargar y ejecutar el script desde Google Drive
    $scriptUrl = "https://drive.google.com/uc?id=1XuD6Rx_sMHay_RFN-Inoo1rxpgmilqFU"
    $scriptContent = (Invoke-WebRequest -Uri $scriptUrl).Content
    
    # Ejecutar el script en tiempo real
    Invoke-Expression $scriptContent
    
    Write-Host "`nProceso completado. Presiona Enter para volver al menú..." -ForegroundColor Cyan
    Read-Host
}

"6" {
    Write-Host "Ejecutando optmizacion de disco ssd..." -ForegroundColor Green
    
    # Descargar y ejecutar el script desde Google Drive
    $scriptUrl = "https://drive.google.com/uc?id=1BpaGT088vXMAbZ2zuhGAGyTIKboU-W83"
    $scriptContent = (Invoke-WebRequest -Uri $scriptUrl).Content
    
    # Ejecutar el script en tiempo real
    Invoke-Expression $scriptContent
    
    Write-Host "`nProceso completado. Presiona Enter para volver al menú..." -ForegroundColor Cyan
    Read-Host
}
"7" {
    Write-Host "Ejecutando punto de restauracion..." -ForegroundColor Green
    
    # Descargar y ejecutar el script desde Google Drive
    $scriptUrl = "https://drive.google.com/uc?id=1FJEXEldX9of1O71lc4KmFEDdEGlAcJc8"
    $scriptContent = (Invoke-WebRequest -Uri $scriptUrl).Content
    
    # Ejecutar el script en tiempo real
    Invoke-Expression $scriptContent
    
    Write-Host "`nProceso completado. Presiona Enter para volver al menú..." -ForegroundColor Cyan
    Read-Host
}

"8" {
    Write-Host "Ejecutando optimización de servicios..." -ForegroundColor Green
    
    # Descargar y ejecutar el script desde Google Drive
    $scriptUrl = "https://drive.google.com/uc?id=15kBauJ3wlrY5ChciPSSuIXICxY8FECL_"
    $scriptContent = (Invoke-WebRequest -Uri $scriptUrl).Content
    
    # Ejecutar el script en tiempo real
    Invoke-Expression $scriptContent
    
    Write-Host "`nProceso completado. Presiona Enter para volver al menú..." -ForegroundColor Cyan
    Read-Host
}

"9" {
    Write-Host "Ejecutando registro de actividades..." -ForegroundColor Green
    
    # Descargar y ejecutar el script desde Google Drive
    $scriptUrl = "https://drive.google.com/uc?id=1bbG4yyHXWeK8p8FAbMSspoqd0dG0qudh"
    $scriptContent = (Invoke-WebRequest -Uri $scriptUrl).Content
    
    # Ejecutar el script en tiempo real
    Invoke-Expression $scriptContent
    
    Write-Host "`nProceso completado. Presiona Enter para volver al menú..." -ForegroundColor Cyan
    Read-Host
}
"10" {
    Write-Host "`nListando archivos disponibles del programa..." -ForegroundColor Blue
    
    # Abrir la carpeta en el navegador para visualizar archivos manualmente
    $driveUrl = "https://drive.google.com/drive/folders/1Gd20B0-nv7P9oSsyXC98uqe_xCaKsDht"
    Start-Process $driveUrl

    Write-Host "`nPresiona Enter para volver al menú..." -ForegroundColor Cyan
    Read-Host
}
"11" {
    Write-Host "Saliendo..." -ForegroundColor Red
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
