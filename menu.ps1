# Establecer la codificacion para evitar errores con caracteres especiales
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
# Asegurar que PowerShell tenga permisos para ejecutar scripts
Set-ExecutionPolicy Bypass -Scope Process -Force

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
Write-Centered "Version ESTABLE 20.4.2025.22:33" -ForegroundColor White -BackgroundColor Black
Write-Centered "DESARROLLADO POR GABRIEL JAMEN" -ForegroundColor Yellow -BackgroundColor Black
Write-Host $line -ForegroundColor Cyan -BackgroundColor Black
Write-Host ""

# Eliminar fondo azul del texto del menu

# Mostrar informacion del tecnico logueado
Write-Host "Tecnico: $nombreUsuario" -ForegroundColor White
Write-Host "Suscripcion vence el: $suscripcionVence" -ForegroundColor Yellow
Write-Host ""

# Mensaje de suscripcion
Write-Host "Por suscripcion o renovacion, comunicarse al +598 096790694" -ForegroundColor Magenta
Write-Host "Recuerde que compartir el usuario deribara en la suspencion del servicio" -ForegroundColor Red


Write-Host "Seleccione una opcion:" -ForegroundColor White

    Write-Host ""

    Write-Host "Seleccione una opcion:]" -ForegroundColor White -BackgroundColor DarkBlue
    Write-Host " 1.  [Optimizacion del sistema]" -ForegroundColor Green
    Write-Host " 2.  [Activador de Windows (En desarrollo)]" -ForegroundColor Yellow
    Write-Host " 3.  [Activador de Excel (En desarrollo)]" -ForegroundColor Yellow
    Write-Host " 4.  [Limpieza de registros]" -ForegroundColor Green
    Write-Host " 5.  [Diagnostico y optimizacion del disco duro HDD]" -ForegroundColor Green
    Write-Host " 6.  [Diagnostico y optimizacion del disco duro SSD]" -ForegroundColor Green
    Write-Host " 7.  [Crear Punto de Restauracion]" -ForegroundColor Green
    Write-Host " 8.  [Optimizar inicio y servicios]" -ForegroundColor Red
    Write-Host " 9.  [Registro de actividades (Logs)]" -ForegroundColor Green
    Write-Host " 10. [Listar los archivos disponibles]" -ForegroundColor Green
    Write-Host " 11. [Disponible para futuras funciones]" -ForegroundColor Yellow
    Write-Host " 12. [Disponible para futuras funciones]" -ForegroundColor Yellow
    Write-Host " 13. [Descripcion del programa" -ForegroundColor Cyan
    Write-Host " X.  [Salir" -ForegroundColor Red

    # Capturar eleccion del usuario
$opcion = Read-Host "Ingrese una opcion (1-13)"

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

        # Esperar unos segundos para asegurar que el script comenzó su ejecución
        Start-Sleep -Seconds 2
        
        # Borrar el script de TEMP inmediatamente después de iniciarse
        Remove-Item -Path $scriptPath -Force -ErrorAction SilentlyContinue
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
            -WindowStyle Normal -Verb RunAs

        # Esperar unos segundos para asegurar que el script comenzó su ejecución
        Start-Sleep -Seconds 2
        
        # Borrar el script de TEMP inmediatamente después de iniciarse
        Remove-Item -Path $scriptPath -Force -ErrorAction SilentlyContinue
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

        # Esperar unos segundos para asegurar que el script comenzó su ejecución
        Start-Sleep -Seconds 2
        
        # Borrar el script de TEMP inmediatamente después de iniciarse
        Remove-Item -Path $scriptPath -Force -ErrorAction SilentlyContinue
    } else {
        Write-Host "Error: No se pudo completar el proceso." -ForegroundColor Red
    }

    Write-Host "`nFINALIZANDO... Presiona Enter para continuar." -ForegroundColor Cyan
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

        # Esperar unos segundos para asegurar que el script comenzó su ejecución
        Start-Sleep -Seconds 2
        
        # Borrar el script de TEMP inmediatamente después de iniciarse
        Remove-Item -Path $scriptPath -Force -ErrorAction SilentlyContinue
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
        Write-Host "  Procediendo con la ejecución..." -ForegroundColor Green
        
        Start-Process -FilePath "powershell.exe" `
            -ArgumentList "-ExecutionPolicy Bypass -File $scriptPath" `
            -WindowStyle Normal -Verb RunAs

        # Esperar unos segundos para asegurar que el script comenzó su ejecución
        Start-Sleep -Seconds 2
        
        # Borrar el script de TEMP inmediatamente después de iniciarse
        Remove-Item -Path $scriptPath -Force -ErrorAction SilentlyContinue

        # Mantener la ventana abierta para ver errores
        Write-Host "Creando punto de restauracion. Espere." -ForegroundColor Yellow
        Read-Host
    } else {
        Write-Host " Error: No se pudo encontrar el archivo." -ForegroundColor Red
    }
}

"8" {
    Write-Host "Ejecutando proceso de optimizacion de inicio y servicios..." -ForegroundColor Green
    $scriptUrl = "https://raw.githubusercontent.com/EdgardJamen/REPARANDO2025/main/OptimizarInicioServicios.ps1"
    $scriptPath = "$env:TEMP\OptimizarInicioServicios.ps1"

    # Descargar el script
    Invoke-WebRequest -Uri $scriptUrl -OutFile $scriptPath
    Start-Sleep -Seconds 2

    # Verificar si el archivo existe antes de ejecutarlo
    if (Test-Path $scriptPath) {
        Write-Host "   Procediendo con la ejecucion..." -ForegroundColor Green
        
        Start-Process -FilePath "powershell.exe" `
            -ArgumentList "-ExecutionPolicy Bypass -File $scriptPath" `
            -WindowStyle Normal -Verb RunAs

        # Esperar unos segundos para asegurar que el script comenzó su ejecución
        Start-Sleep -Seconds 2
        
        # Borrar el script de TEMP inmediatamente después de iniciarse
        Remove-Item -Path $scriptPath -Force -ErrorAction SilentlyContinue

        # Mantener la ventana abierta para ver errores
        Write-Host "Optimizando inicio y servicios. Espere..." -ForegroundColor Yellow
        Read-Host
    } else {
        Write-Host " Error: No se pudo encontrar correctamente el archivo." -ForegroundColor Red
    }
}

"9" {
    Write-Host "Ejecutando proceso de registro de actividades..." -ForegroundColor Green
    $scriptUrl = "https://raw.githubusercontent.com/EdgardJamen/REPARANDO2025/main/RegistroActividades.ps1"
    $scriptPath = "$env:TEMP\RegistroActividades.ps1"

    # Descargar el script
    Invoke-WebRequest -Uri $scriptUrl -OutFile $scriptPath
    Start-Sleep -Seconds 2

    # Verificar si el archivo existe antes de ejecutarlo
    if (Test-Path $scriptPath) {
        Write-Host " Archivo encontrado. Procediendo con la ejecucion..." -ForegroundColor Green
        
        Start-Process -FilePath "powershell.exe" `
            -ArgumentList "-ExecutionPolicy Bypass -File $scriptPath" `
            -WindowStyle Normal -Verb RunAs

        # Esperar unos segundos para asegurar que el script comenzo su ejecucion
        Start-Sleep -Seconds 2
        
        # Borrar el script de TEMP inmediatamente despues de iniciarse
        Remove-Item -Path $scriptPath -Force -ErrorAction SilentlyContinue

        # Mantener la ventana abierta para ver errores
        Write-Host "Registrando actividades. Espere..." -ForegroundColor Yellow
        Read-Host
    } else {
        Write-Host " Error: No se pudo encontrar correctamente el archivo." -ForegroundColor Red
    }
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
"13" {
    Write-Host "Cargando descripcion del programa..." -ForegroundColor Cyan
    $descripcionUrl = "https://raw.githubusercontent.com/EdgardJamen/REPARANDO2025/refs/heads/main/descripcion.txt"
    $descripcionPath = "$env:TEMP\descripcion.txt"

    # Descargar el archivo desde GitHub
    Invoke-WebRequest -Uri $descripcionUrl -OutFile $descripcionPath
    Start-Sleep -Seconds 2

    # Verificar si el archivo existe antes de mostrarlo
    if (Test-Path $descripcionPath) {
        Write-Host "`nDescripcion del programa:" -ForegroundColor Green
        Get-Content $descripcionPath | ForEach-Object { Write-Host $_ }

        # Esperar unos segundos para asegurar que el usuario lo haya visto
        Start-Sleep -Seconds 2
        
        # Borrar el archivo de descripcion despues de mostrarlo
        Remove-Item -Path $descripcionPath -Force -ErrorAction SilentlyContinue
    } else {
        Write-Host " Error: No se pudo obtener la descripcion del programa." -ForegroundColor Red
    }

    Write-Host "`nPresiona Enter para continuar..." -ForegroundColor Cyan
    Read-Host
}

"X" {
    Write-Host "Saliendo del sistema..." -ForegroundColor Red
    Start-Sleep -Seconds 1
    Clear-Host
    Exit
}
Default {
    Write-Host "Opcion no valida. Intenta nuevamente." -ForegroundColor Red
}

} # Cierre correcto del bloque switch

# Si no se escogio la opcion de salir, se pide presionar Enter para continuar.
if ($opcion -ne "X") {
    Write-Host ""
    Write-Host "Presiona Enter para volver al menu ..." -ForegroundColor Cyan
    Read-Host
}

} while ($true) # Cierre correcto del bucle do-while
