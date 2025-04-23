Write-Host "Ejecutando activación de Windows..." -ForegroundColor Green

# Ejecutar activador MAS desde la web
irm https://get.activated.win | iex

# Simular la opción 1 (activar Windows automáticamente)
echo "1" | cmd

# Esperar unos segundos para que la activación se complete
Start-Sleep -Seconds 10 

# Cerrar el activador MAS y la ventana de PowerShell
Stop-Process -Name "cmd" -Force -ErrorAction SilentlyContinue
Stop-Process -Name "powershell" -Force -ErrorAction SilentlyContinue
