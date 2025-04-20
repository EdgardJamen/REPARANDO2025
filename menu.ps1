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

# Limpieza de espacios y comparacion sin diferenciar mayúsculas/minúsculas
$autenticado = $usuarios | Where-Object { 
    $_.Nombre.Trim() -ieq $nombreIngresado.Trim() -and $_.Contrasena.Trim() -ieq $contrasenaIngresada.Trim() 
}

if ($autenticado) {
    Write-Host "Autenticacion exitosa. Cargando el menu..." -ForegroundColor Green
    Start-Sleep -Seconds 2
} else {
    Write-Host "❌ Error: Nombre o contraseña incorrectos." -ForegroundColor Red
    Exit
}

# 🔹 Limpiar pantalla después de la autenticación exitosa
Clear-Host

# 🏷 Mostrar nombre y fecha de vencimiento en el menú
Write-Host "============================================" -ForegroundColor Cyan
Write-Host " Reparando.mercedes es un trabajo desarrollado por :" -ForegroundColor Yellow
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""

# Obtener el nombre y la fecha de vencimiento del usuario autenticado
$nombreUsuario = $autenticado | Select-Object -First 1 -ExpandProperty Nombre
$fechaVencimiento = $autenticado | Select-Object -First 1 -ExpandProperty Vence

# Verificar si el usuario tiene acceso ilimitado
if ($fechaVencimiento -eq "Acceso de por vida") {
    Write-Host "👨‍🔧 Tecnico: $nombreUsuario" -ForegroundColor Yellow
    Write-Host "📅 Vence: Acceso de por vida" -ForegroundColor Yellow
} else {
    Write-Host "👨‍🔧 Tecnico: $nombreUsuario" -ForegroundColor Yellow
    Write-Host "📅 Vence: $fechaVencimiento" -ForegroundColor Yellow
}

Write-Host ""

# 🔹 CONTINÚA EL MENÚ...

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
    Write-Centered "Reparando.mercedes es un trabajo desarrollado por :" -ForegroundColor Yellow -BackgroundColor Black
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
}

    $opcion = Read-Host "Selecciona una opción (1-11)"

} while ($true)

switch ($opcion) {

"1" {
    Write-Host "Ejecutando proceso de optimización..." -ForegroundColor Green
    $scriptUrl = "https://raw.githubusercontent.com/EdgardJamen/REPARANDO2025/main/optimizacion.ps1"
    $scriptPath = "$env:TEMP\optimizacion.ps1"
    Invoke-WebRequest -Uri $scriptUrl -OutFile $scriptPath

    # Verificar si la descarga fue exitosa antes de ejecutarlo
    if (Test-Path $scriptPath) {
        Start-Process -FilePath "powershell.exe" `
            -ArgumentList "-ExecutionPolicy Bypass -File $scriptPath" `
            -WindowStyle Normal -Verb RunAs
    } else {
        Write-Host "Error: No se pudo completar el proceso." -ForegroundColor Red
    }

    Write-Host "`nFINALIZANDO... Presiona Enter para continuar." -ForegroundColor Cyan
    Read-Host
}
"2" {
    Write-Host "Esta función aun no esta implementada." -ForegroundColor Yellow
    Write-Host "`nPresiona Enter para volver al menú..." -ForegroundColor Cyan
    Read-Host
}
"3" {
    Write-Host "Esta función aun no esta implementada." -ForegroundColor Yellow
    Write-Host "`nPresiona Enter para volver al menú..." -ForegroundColor Cyan
    Read-Host
}
"4" {
    Write-Host "Ejecutando proceso de limpieza..." -ForegroundColor Green
    $scriptUrl = "https://raw.githubusercontent.com/EdgardJamen/REPARANDO2025/main/LimpiezaRegistros.ps1"
    $scriptPath = "$env:TEMP\LimpiezaRegistros.ps1"
    Invoke-WebRequest -Uri $scriptUrl -OutFile $scriptPath

    # Verificar si la descarga fue exitosa antes de ejecutarlo
    if (Test-Path $scriptPath) {
        Start-Process -FilePath "powershell.exe" `
            -ArgumentList "-ExecutionPolicy Bypass -File $scriptPath" `
            -WindowStyle Normal -Wait -Verb RunAs
    } else {
        Write-Host "Error: No se pudo completar el proceso." -ForegroundColor Red
    }

    Write-Host "`nFINALIZANDO... Presiona Enter para continuar." -ForegroundColor Cyan
    Read-Host
}

"5" {
    Write-Host "Ejecutando proceso de diagnóstico..." -ForegroundColor Green
    $scriptUrl = "https://raw.githubusercontent.com/EdgardJamen/REPARANDO2025/main/DiagnosticoHDD.ps1"
    $scriptPath = "$env:TEMP\DiagnosticoHDD.ps1"
    Invoke-WebRequest -Uri $scriptUrl -OutFile $scriptPath

    # Verificar si la descarga fue exitosa antes de ejecutarlo
    if (Test-Path $scriptPath) {
        Start-Process -FilePath "powershell.exe" `
            -ArgumentList "-ExecutionPolicy Bypass -File $scriptPath" `
            -WindowStyle Normal -Wait -Verb RunAs
    } else {
        Write-Host "Error: No se pudo completar el proceso." -ForegroundColor Red
    }

    Write-Host "`nFINALIZANDO... Presiona Enter para continuar." -ForegroundColor Cyan
    Read-Host
}
"6" {
    Write-Host "Ejecutando proceso de diagnostico..." -ForegroundColor Green
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

    Write-Host "`nFINALIZANDO... Presiona Enter para continuar." -ForegroundColor Cyan
    Read-Host
}
"7" {
    Write-Host "Ejecutando proceso de restauración..." -ForegroundColor Green
    $scriptUrl = "https://raw.githubusercontent.com/EdgardJamen/REPARANDO2025/main/CrearPuntoRestauracion.ps1"
    $scriptPath = "$env:TEMP\CrearPuntoRestauracion.ps1"

    # Descargar el script
    Invoke-WebRequest -Uri $scriptUrl -OutFile $scriptPath
    Start-Sleep -Seconds 2

    # Verificar si el archivo existe antes de ejecutarlo
    if (Test-Path $scriptPath) {
        Write-Host "✅ Archivo descargado correctamente. Procediendo con la ejecución..." -ForegroundColor Green
        
        Start-Process -FilePath "powershell.exe" `
            -ArgumentList "-ExecutionPolicy Bypass -File $scriptPath" `
            -WindowStyle Normal -Verb RunAs

        # Mantener la ventana abierta para ver errores
        Write-Host "Creando punto de restauracion .Espere." -ForegroundColor Yellow
        Read-Host
    } else {
        Write-Host " Error: No se pudo descargar correctamente el archivo." -ForegroundColor Red
    }
}

"8" {
    Write-Host "Ejecutando proceso de optimizacion..." -ForegroundColor Green
    $scriptUrl = "https://raw.githubusercontent.com/EdgardJamen/REPARANDO2025/main/OptimizarInicioServicios.ps1"
    $scriptPath = "$env:TEMP\OptimizarInicioServicios.ps1"
    Invoke-WebRequest -Uri $scriptUrl -OutFile $scriptPath

    # Verificar si la descarga fue exitosa antes de ejecutarlo
    if (Test-Path $scriptPath) {
        Start-Process -FilePath "powershell.exe" `
            -ArgumentList "-ExecutionPolicy Bypass -File $scriptPath" `
            -WindowStyle Hidden -Wait -Verb RunAs
    } else {
        Write-Host "Error: No se pudo completar el proceso." -ForegroundColor Red
    }

    Write-Host "`nFINALIZANDO... Presiona Enter para continuar." -ForegroundColor Cyan
    Read-Host
}
"9" {
    Write-Host "Ejecutando proceso de registro..." -ForegroundColor Green
    $scriptUrl = "https://raw.githubusercontent.com/EdgardJamen/REPARANDO2025/main/RegistroActividades.ps1"
    $scriptPath = "$env:TEMP\RegistroActividades.ps1"
    Invoke-WebRequest -Uri $scriptUrl -OutFile $scriptPath

    # Verificar si la descarga fue exitosa antes de ejecutarlo
    if (Test-Path $scriptPath) {
        Start-Process -FilePath "powershell.exe" `
            -ArgumentList "-ExecutionPolicy Bypass -File $scriptPath" `
            -WindowStyle Hidden -Wait -Verb RunAs
    } else {
        Write-Host "Error: No se pudo completar el proceso." -ForegroundColor Red
    }

    Write-Host "`nFINALIZANDO... Presiona Enter para continuar." -ForegroundColor Cyan
    Read-Host
}
"10" {
    Write-Host "Obteniendo lista de archivos disponibles..." -ForegroundColor Green

    # Definir los archivos disponibles en línea
    $archivosDisponibles = @(
        "optimizacion.ps1",
        "LimpiezaRegistros.ps1",
        "DiagnosticoHDD.ps1",
        "DiagnosticoSSD.ps1",
        "CrearPuntoRestauracion.ps1",
        "OptimizarInicioServicios.ps1",
        "RegistroActividades.ps1"
    )

    # Mostrar archivos sin revelar la ruta
    Write-Host "`nOpciones activas:" -ForegroundColor Cyan
    foreach ($archivo in $archivosDisponibles) {
        Write-Host " - $archivo" -ForegroundColor Yellow
    }

    Write-Host "`nFINALIZANDO... Presiona Enter para continuar." -ForegroundColor Cyan
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
