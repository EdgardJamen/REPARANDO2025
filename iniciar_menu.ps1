$menuUrl = "https://raw.githubusercontent.com/EdgardJamen/REPARANDO2025/main/menu.ps1"
$menuPath = "$env:TEMP\menu.ps1"

# Descargar el script desde GitHub
Invoke-WebRequest -Uri $menuUrl -OutFile $menuPath

# Ejecutar el script descargado
Start-Process -FilePath "powershell.exe" -ArgumentList "-ExecutionPolicy Bypass -File $menuPath" -Wait
