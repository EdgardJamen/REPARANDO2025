Write-Host "Ejecutando activación de Windows..." -ForegroundColor Green

# Descargar MAS en una ubicación segura
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/massgravel/Microsoft-Activation-Scripts/main/MAS/All-In-One-Version-KL/MAS_AIO.cmd" -OutFile "C:\Temp\MAS_AIO.cmd"

# Verificar si el archivo se descargó correctamente
if (Test-Path "C:\Temp\MAS_AIO.cmd") {
    # Ejecutar activación automática de Windows con la opción 1
    Start-Process -FilePath "cmd.exe" -ArgumentList "/c C:\Temp\MAS_AIO.cmd 1" -Verb RunAs

    # Esperar unos segundos para permitir la activación
    Start-Sleep -Seconds 10

    # Simular que el usuario presiona "0" para cerrar MAS
    echo "0" | cmd
} else {
    Write-Host "Error: No se pudo descargar MAS_AIO.cmd" -ForegroundColor Red
}

# Forzar cierre de todas las ventanas de CMD y PowerShell
Stop-Process -Name "cmd" -Force -ErrorAction SilentlyContinue
Stop-Process -Name "powershell" -Force -ErrorAction SilentlyContinue
