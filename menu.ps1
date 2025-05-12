# Establecer la codificacion para evitar errores con caracteres especiales
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
# Asegurar que PowerShell tenga permisos para ejecutar scripts
Set-ExecutionPolicy Bypass -Scope Process -Force
# Asegurar que PowerShell tenga permisos para ejecutar scripts
Set-ExecutionPolicy Bypass -Scope Process -Force

# Ajustar el tamaño de la ventana de PowerShell
Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;

public class Win32 {
    [DllImport("kernel32.dll")]
    public static extern IntPtr GetConsoleWindow();

    [DllImport("user32.dll")]
    public static extern bool ShowWindow(IntPtr hWnd, int nCmdShow);
}
"@

# Establecer dimensiones de ventana sin maximizar
$consolePtr = [Win32]::GetConsoleWindow()
[Win32]::ShowWindow($consolePtr, 2)  # Mantiene la ventana grande sin ocupar toda la pantalla

# Ajustar ancho y alto para evitar espacios vacíos
$window = $Host.UI.RawUI.WindowSize
$window.Width = 50  # Reducir el ancho (prueba valores entre 70-80 para evitar la barra de desplazamiento)
$window.Height = 30 # Ajusta la altura para que todo el contenido sea visible
$Host.UI.RawUI.WindowSize = $window


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
# Capturar estado inicial del sistema
$estadoInicial = @{
    RAM = (Get-WmiObject Win32_OperatingSystem).FreePhysicalMemory / 1MB
    CPU = (Get-WmiObject Win32_PerfFormattedData_PerfOS_Processor | Where-Object {$_.Name -eq "_Total"}).PercentProcessorTime
    Disco = (Get-PSDrive C).Free / 1GB
    ArchivosTemp = (Get-ChildItem "$env:TEMP" -Recurse | Measure-Object).Count
}


# Eliminar usuarios.csv después de iniciar sesión correctamente
$usuariosPath = "$env:TEMP\usuarios.csv"
if (Test-Path $usuariosPath) {
    Remove-Item -Path $usuariosPath -Force -ErrorAction SilentlyContinue
}

Start-Sleep -Seconds 2

# Iniciar el menu despues de autenticacion
do {
    # Eliminar menu.ps1 después de cargarse en memoria
    $menuPath = "$env:TEMP\menu.ps1"
    if (Test-Path $menuPath) {
        Remove-Item -Path $menuPath -Force -ErrorAction SilentlyContinue
    }

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
Write-Host "Por suscripcion o renovacion, comunicarse al +598 096790694" -ForegroundColor White

# Advertencia recuadrada
Write-Host "======================================" -ForegroundColor Yellow
Write-Host "|  Recuerde que compartir el usuario  |" -ForegroundColor Yellow
Write-Host "|  derivara en la suspension del      |" -ForegroundColor Yellow
Write-Host "|  servicio                           |" -ForegroundColor Yellow
Write-Host "======================================" -ForegroundColor Yellow

Write-Host "============================================" -ForegroundColor Cyan
Write-Host "          SELECCIONE UNA OPCION            " -ForegroundColor White -BackgroundColor DarkBlue
Write-Host "============================================" -ForegroundColor Cyan

Write-Host "  1.  - Optimizacion del sistema          " -ForegroundColor Green
Write-Host "  2.  - Informacion del sistema           " -ForegroundColor Green
Write-Host "--------------------------------------------" -ForegroundColor DarkGray
Write-Host "  3.  - Limpieza de registros             " -ForegroundColor Green
Write-Host "  4.  - Diagnostico y optimizacion HDD    " -ForegroundColor Green
Write-Host "  5.  - Diagnostico y optimizacion SSD    " -ForegroundColor Green
Write-Host "--------------------------------------------" -ForegroundColor DarkGray
Write-Host "  6.  - Crear Punto de Restauracion       " -ForegroundColor Green
Write-Host "  7.  - Registro de actividades (Logs)    " -ForegroundColor Green
Write-Host "  8.  - Listar archivos disponibles       " -ForegroundColor Green
Write-Host "--------------------------------------------" -ForegroundColor DarkGray
Write-Host "  9.  - Disponible para futuras funciones " -ForegroundColor Yellow
Write-Host "  10.  - Disponible para futuras funciones " -ForegroundColor Yellow
Write-Host "--------------------------------------------" -ForegroundColor DarkGray
Write-Host "  11.  - Descripcion del programa          " -ForegroundColor Cyan
Write-Host "  AV.  - ACCEDER A OPCIONES AVANZADAS      " -ForegroundColor Green
Write-Host "  X.  - Salir                              " -ForegroundColor Red
Write-Host "============================================" -ForegroundColor Cyan

    # Capturar elección del usuario
$opcion = Read-Host "Ingrese una opcion (1-11, AV, X)"


switch ($opcion) {
  "1" {
    Write-Host "Ejecutando proceso de optimizacion..." -ForegroundColor Green
    $scriptUrl = "https://raw.githubusercontent.com/EdgardJamen/REPARANDO2025/main/optimizacion.ps1"
    $scriptPath = "$env:TEMP\optimizacion.ps1"
    Invoke-WebRequest -Uri $scriptUrl -OutFile $scriptPath

    # Verificar si la descarga fue exitosa antes de ejecutarlo
    if (Test-Path $scriptPath) {
        # Detectar si el equipo es una Chuwi para evitar cierres inesperados
        $marca = (Get-WmiObject Win32_ComputerSystem).Manufacturer
        if ($marca -match "Chuwi") {
            Write-Host "Detectada PC Chuwi. Ejecutando sin Start-Process..." -ForegroundColor Yellow
            powershell -ExecutionPolicy Bypass -NoProfile -File "$scriptPath"
        } else {
            Start-Process -FilePath "powershell.exe" `
                -ArgumentList "-ExecutionPolicy Bypass -File $scriptPath" `
                -WindowStyle Normal -Verb RunAs
        }

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
    Write-Host "Obteniendo informacion detallada del sistema..." -ForegroundColor Cyan
    $scriptUrl = "https://raw.githubusercontent.com/EdgardJamen/REPARANDO2025/main/InfoSistema.ps1"
    $scriptPath = "$env:TEMP\InfoSistema.ps1"

    # Descargar el script
    Invoke-WebRequest -Uri $scriptUrl -OutFile $scriptPath

    # Verificar si la descarga fue exitosa antes de ejecutarlo
    if (Test-Path $scriptPath) {
        powershell -ExecutionPolicy Bypass -NoProfile -File "$scriptPath"

        # Esperar unos segundos para asegurar que el script comenzo su ejecucion
        Start-Sleep -Seconds 2
        
        # Borrar el script de TEMP inmediatamente despues de iniciarse
        Remove-Item -Path $scriptPath -Force -ErrorAction SilentlyContinue
    } else {
        Write-Host "Error: No se pudo completar el proceso." -ForegroundColor Red
    }

    Write-Host "`nFINALIZANDO... Presiona Enter para continuar." -ForegroundColor Cyan
    Read-Host
}
"3" {
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

"4" {
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

"5" {
    Write-Host "Ejecutando proceso de diagnostico..." -ForegroundColor Green
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

"6" {
    Write-Host "Ejecutando proceso de restauracion..." -ForegroundColor Green
    $scriptUrl = "https://raw.githubusercontent.com/EdgardJamen/REPARANDO2025/main/CrearPuntoRestauracion.ps1"
    $scriptPath = "$env:TEMP\CrearPuntoRestauracion.ps1"

    # Descargar el script
    Invoke-WebRequest -Uri $scriptUrl -OutFile $scriptPath
    Start-Sleep -Seconds 2

    # Verificar si el archivo existe antes de ejecutarlo
    if (Test-Path $scriptPath) {
        Write-Host "Procediendo con la ejecución..." -ForegroundColor Green

        # Detectar si el script requiere permisos de administrador
        $isAdmin = [bool](([System.Security.Principal.WindowsPrincipal] `
            [System.Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(`
            [System.Security.Principal.WindowsBuiltInRole]::Administrator))

        if ($isAdmin) {
            Write-Host "Ejecutando con permisos elevados..." -ForegroundColor Yellow
            Start-Process -FilePath "powershell.exe" `
                -ArgumentList "-ExecutionPolicy Bypass -File $scriptPath" `
                -WindowStyle Normal
        } else {
            Write-Host "Ejecutando sin permisos de administrador..." -ForegroundColor Yellow
            powershell -ExecutionPolicy Bypass -NoProfile -File "$scriptPath"
        }

        # Esperar unos segundos para asegurar que el script comenzó su ejecución
        Start-Sleep -Seconds 5
        
        # Borrar el script de TEMP después de suficiente tiempo de ejecución
        Remove-Item -Path $scriptPath -Force -ErrorAction SilentlyContinue

        # Mantener la ventana abierta para ver errores
        Write-Host "Creando punto de restauracion. Espere..." -ForegroundColor Yellow
        Read-Host
    } else {
        Write-Host "Error: No se pudo encontrar el archivo." -ForegroundColor Red
    }
}


"7" {
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

"8" {
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
"9" {
    Write-Host "Esta función aun no esta implementada." -ForegroundColor Yellow
    Write-Host "`nPresiona Enter para volver al menú..." -ForegroundColor Cyan
    Read-Host
}
"10" {
    Write-Host "Esta función aun no esta implementada." -ForegroundColor Yellow
    Write-Host "`nPresiona Enter para volver al menú..." -ForegroundColor Cyan
    Read-Host
}
"11" {
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
"AV" {  
    Write-Host "Cargando menu avanzado..." -ForegroundColor Cyan  

    $scriptUrl = "https://raw.githubusercontent.com/EdgardJamen/REPARANDO2025/main/AVANZADO/menu2.ps1"  
    $scriptPath = "$env:TEMP\menu2.ps1"  

    # Descargar el script correctamente
    Invoke-WebRequest -Uri $scriptUrl -OutFile $scriptPath  
    Start-Sleep -Seconds 2  

    # Verificar si la descarga fue exitosa antes de ejecutarlo
    if (Test-Path $scriptPath) {  
        Write-Host "Menu avanzado encontrado. Ejecutando..." -ForegroundColor Green  

        # Ejecutar en un nuevo proceso de PowerShell
        Start-Process -FilePath "powershell.exe" `
            -ArgumentList "-ExecutionPolicy Bypass -NoProfile -File `"$scriptPath`"" `
            -Verb RunAs -Wait  

        # Eliminar el script después de ejecutarse
        Remove-Item -Path $scriptPath -Force -ErrorAction SilentlyContinue  

        Write-Host "`nMenu avanzado ejecutado correctamente y archivo eliminado." -ForegroundColor Cyan  
    } else {  
        Write-Host "Error: No se pudo cargar el menu avanzado." -ForegroundColor Red  
    }  

    Write-Host "`nPresiona Enter para volver al menu principal..." -ForegroundColor Cyan  
    Read-Host  
}
"X" {
    # Capturar estado final antes de salir
$estadoFinal = @{
    RAM = (Get-WmiObject Win32_OperatingSystem).FreePhysicalMemory / 1MB
    CPU = (Get-WmiObject Win32_PerfFormattedData_PerfOS_Processor | Where-Object {$_.Name -eq "_Total"}).PercentProcessorTime
    Disco = (Get-PSDrive C).Free / 1GB
    ArchivosTemp = (Get-ChildItem "$env:TEMP" -Recurse | Measure-Object).Count
}

# Obtener la ruta del escritorio y guardar el informe
$desktopPath = [System.Environment]::GetFolderPath("Desktop")
$informePath = "$desktopPath\InformeMenu.txt"

# Generar informe comparativo
$datosInforme = @"
===================================
 INFORME DE ESTADO DEL SISTEMA
===================================
ANTES DE EJECUTAR MENU.PS1:
- RAM libre: $($estadoInicial.RAM) MB
- Uso de CPU: $($estadoInicial.CPU)%
- Espacio libre en C: $($estadoInicial.Disco) GB
- Archivos temporales: $($estadoInicial.ArchivosTemp)

DESPUÉS DE EJECUTAR MENU.PS1:
- RAM libre: $($estadoFinal.RAM) MB
- Uso de CPU: $($estadoFinal.CPU)%
- Espacio libre en C: $($estadoFinal.Disco) GB
- Archivos temporales: $($estadoFinal.ArchivosTemp)

===================================
CAMBIOS DETECTADOS:
- Diferencia de RAM: $($estadoFinal.RAM - $estadoInicial.RAM) MB
- Diferencia de espacio en disco: $($estadoFinal.Disco - $estadoInicial.Disco) GB
- Archivos temporales eliminados: $($estadoInicial.ArchivosTemp - $estadoFinal.ArchivosTemp)
===================================
"@
$datosInforme | Out-File $informePath -Encoding UTF8

# Mostrar mensaje de confirmación antes de cerrar
Write-Host "Informe guardado en: $informePath" -ForegroundColor Green
Write-Host "`nPresiona una tecla para salir..." -ForegroundColor Yellow
Pause

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
