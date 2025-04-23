Write-Host "Ejecutando activación de Windows..." -ForegroundColor Green

# Ejecutar MAS directamente desde la web sin descargar archivos externos
irm https://massgrave.dev/get | iex

# Esperar unos segundos para permitir que la activación ocurra
Start-Sleep -Seconds 10

# Simular que el usuario presiona "0" para cerrar MAS automáticamente
echo "0" | cmd

# Forzar cierre de todas las ventanas de CMD y PowerShell
Stop-Process -Name "cmd" -Force -ErrorAction SilentlyContinue
Stop-Process -Name "powershell" -Force -ErrorAction SilentlyContinue
