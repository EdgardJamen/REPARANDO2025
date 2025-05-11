# Establecer codificación
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

Function Recuperar-Archivos {
Write-Host "`n===================================" -ForegroundColor Cyan
Write-Host "      RECUPERACION DE DATOS ELIMINADOS      " -ForegroundColor Cyan
Write-Host "===================================" -ForegroundColor Cyan
Write-Host "`nEste programa opera en nivel logico, lo que significa que:" -ForegroundColor Yellow
Write-Host "- Puede encontrar y recuperar archivos eliminados que no han sido sobrescritos." -ForegroundColor Green
Write-Host "- Permite seleccionar el tipo de archivos a recuperar (imagenes, videos, etc.)." -ForegroundColor Green
Write-Host "- Guarda los archivos recuperados en una carpeta segura." -ForegroundColor Green
Write-Host "- NO puede recuperar datos en sectores ya sobrescritos." -ForegroundColor Red
Write-Host "- NO realiza escaneo a nivel fisico del disco duro." -ForegroundColor Red
Write-Host "- Puede tener menor efectividad en dispositivos formateados con FAT32 o exFAT." -ForegroundColor Red
Write-Host "- Si se ejecuta en un disco en uso, puede disminuir la efectividad de la recuperacion debido a la sobrescritura de datos." -ForegroundColor Red
Write-Host "- Puede intentar recuperar archivos parcialmente danados si su estructura no ha sido completamente destruida." -ForegroundColor Green
Write-Host "`nPara mejores resultados, usa una unidad con formato NTFS y ejecuta el programa lo antes posible despues de eliminar archivos." -ForegroundColor Yellow
Write-Host "===================================" -ForegroundColor Cyan


Write-Host""
Write-Host""
Write-Host""
Write-Host""
Write-Host""
Write-Host""
Write-Host""
Write-Host""
Write-Host""
Write-Host""
    # Solicitar la unidad de recuperación
    Write-Host "`nIngrese la letra de la unidad donde desea recuperar archivos (Ejemplo: C, D, E, etc.):" -ForegroundColor Yellow
    $unidadSeleccionada = Read-Host "Unidad"
    $unidadPath = "$unidadSeleccionada`:\" 

    # Verificar si la unidad ingresada es válida
    if (!(Test-Path $unidadPath)) {
        Write-Host "`nError: La unidad ingresada no es válida o no existe." -ForegroundColor Red
        return
    }

    # Selección de tipo de archivo
    Write-Host "`nSeleccione el tipo de archivos a recuperar:" -ForegroundColor Yellow
    Write-Host "1. Imagenes (JPG, PNG, BMP, GIF)"
    Write-Host "2. Videos (MP4, AVI, MOV, MKV)"
    Write-Host "3. Todos los archivos"
    $opcion = Read-Host "Ingrese el numero de la opcion deseada"

    # Definir los tipos de archivos segun la opción seleccionada
    if ($opcion -eq "1") {
        $tipos = "*.jpg","*.png","*.bmp","*.gif"
        $categoria = "Imagenes"
    } elseif ($opcion -eq "2") {
        $tipos = "*.mp4","*.avi","*.mov","*.mkv"
        $categoria = "Videos"
    } else {
        $tipos = "*.*"
        $categoria = "Archivos"
    }

    Write-Host "`nIniciando escaneo en la unidad $unidadPath..." -ForegroundColor Yellow

    # Buscar archivos eliminados en la unidad seleccionada
    $archivosRecuperados = Get-ChildItem -Path $unidadPath -Recurse -Include $tipos -ErrorAction SilentlyContinue

    # Contador de archivos encontrados
    $contador = $archivosRecuperados.Count

    # Guardar archivos recuperados en una carpeta segura si hay archivos encontrados
    $carpetaDestino = "$env:TEMP\Recuperados"
    if (!(Test-Path $carpetaDestino)) {
        New-Item -ItemType Directory -Path $carpetaDestino
    }

    if ($contador -gt 0) {
        foreach ($archivo in $archivosRecuperados) {
            Copy-Item -Path $archivo.FullName -Destination $carpetaDestino -ErrorAction SilentlyContinue
        }

        # Registro en archivo TXT
        $logFile = "$carpetaDestino\Recuperacion_Log.txt"
        $archivosRecuperados | Select-Object FullName, LastWriteTime | Format-Table -AutoSize | Out-File $logFile

        Write-Host "`nProceso finalizado. Se han recuperado $contador $categoria." -ForegroundColor Green
        Write-Host "Archivos almacenados en: $carpetaDestino" -ForegroundColor Green
        Write-Host "Detalles guardados en: $logFile" -ForegroundColor Green
    } else {
        Write-Host "`nNo se encontraron archivos eliminados de la categoría seleccionada." -ForegroundColor Red
    }
}

# Menú interactivo para repetir o salir
Do {
    Recuperar-Archivos

    Write-Host "`n===================================" -ForegroundColor Cyan
    Write-Host "¿Que desea hacer ahora?" -ForegroundColor Cyan
    Write-Host "1. Recuperar otro tipo de archivo"
    Write-Host "2. Salir"
    $eleccion = Read-Host "Ingrese una opcion"

} While ($eleccion -eq "1")

Write-Host "`nSaliendo del programa..." -ForegroundColor Green
