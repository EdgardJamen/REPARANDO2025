Write-Host "Descargando menu.ps1 desde GitHub..." -ForegroundColor Yellow

# Ruta del menú en GitHub
$menuUrl = "https://raw.githubusercontent.com/EdgardJamen/REPARANDO2025/a43fdf7ccdf93373ca39c4a908111b9ad35be3a9/menu.ps1"


# Guardar el archivo en la carpeta temporal del sistema
$menuPath = "$env:TEMP\menu.ps1"
Invoke-WebRequest -Uri $menuUrl -OutFile $menuPath

# Verificar si la descarga fue exitosa
if (Test-Path $menuPath) {
    Write-Host "Ejecución de menu.ps1..." -ForegroundColor Green
    Start-Process -FilePath "powershell.exe" -ArgumentList "-ExecutionPolicy Bypass -File $menuPath" -Wait
} else {
    Write-Host "Error: No se pudo descargar menu.ps1." -ForegroundColor Red
}
