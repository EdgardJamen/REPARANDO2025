Write-Host "Descargando menu.ps1 desde GitHub..." -ForegroundColor Yellow

# Ruta del menú en GitHub
$menuUrl = "https://raw.githubusercontent.com/EdgardJamen/REPARANDO2025/main/menu.ps1"


# Guardar el archivo en la carpeta temporal del sistema
$menuPath = "$env:TEMP\menu.ps1"
Invoke-WebRequest -Uri $menuUrl -OutFile $menuPath

# Verificar si la descarga fue exitosa
if (Test-Path $menuPath) {
    Write-Host "✅ Descarga completada. Ejecutando menu.ps1..." -ForegroundColor Green

    # Ejecutar en la misma instancia de PowerShell
    & $menuPath

    Write-Host "📌 Menú ejecutado. Presiona Enter para continuar..." -ForegroundColor Cyan
    Read-Host
} else {
    Write-Host "❌ Error: No se pudo descargar menu.ps1." -ForegroundColor Red
    Write-Host "📌 Verifica la conexión a Internet o la URL del archivo." -ForegroundColor Yellow
    Read-Host
}
