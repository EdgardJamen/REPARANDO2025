Write-Host "Ejecutando activación de Windows..." -ForegroundColor Green

# Pausa para que el usuario tenga tiempo de aceptar permisos
Write-Host "Por favor, acepta los permisos cuando aparezcan..." -ForegroundColor Yellow
Start-Sleep -Seconds 5

# Ejecutar MAS directamente
irm https://massgrave.dev/get | iex

# Esperar unos segundos para la activación
Start-Sleep -Seconds 10

# Pausa antes de cerrar para ver si hubo errores
Write-Host "Presiona Enter si deseas revisar mensajes antes de que se cierre." -ForegroundColor Yellow
Read-Host

# Cerrar después de la activación
Stop-Process -Name "cmd" -Force -ErrorAction SilentlyContinue
Stop-Process -Name "powershell" -Force -ErrorAction SilentlyContinue
