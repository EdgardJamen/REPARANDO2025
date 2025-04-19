Write-Host "Iniciando programa..." -ForegroundColor Yellow

# Ruta del menú en Google Drive
$menuUrl = "https://drive.google.com/file/d/1A7eZ_l0stvm6VkGUwfE8mZxILUK2qBz1/view?usp=sharing"

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
