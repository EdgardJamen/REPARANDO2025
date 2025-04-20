# Definir la fecha de vencimiento de la suscripción
$fechaVencimiento = "2025-12-31"
$usuario = $env:USERNAME

# Verificar si la suscripción ha expirado antes de iniciar el menú
if ((Get-Date) -gt (Get-Date $fechaVencimiento)) {
    Write-Host "❌ Tu suscripción ha expirado. Contacta con soporte para renovarla." -ForegroundColor Red
    Exit
}

# Mostrar información del usuario una sola vez
Write-Host "Bienvenido, $usuario"
Write-Host "Tu suscripción es válida hasta: $fechaVencimiento"

# Descargar el menú principal desde GitHub (URL corregida)
$menuUrl = "https://raw.githubusercontent.com/EdgardJamen/REPARANDO2025/main/menu.ps1"
$menuLocal = "$env:TEMP\menu.ps1"
Invoke-WebRequest -Uri $menuUrl -OutFile $menuLocal

# Verificar que el archivo se descargó correctamente antes de ejecutarlo
if (Test-Path $menuLocal) {
    Write-Host "`n✅ Menú descargado correctamente en: $menuLocal" -ForegroundColor Cyan
    Write-Host "📌 Para ejecutarlo manualmente, usa el siguiente comando en PowerShell:" -ForegroundColor Yellow
    Write-Host "`n  & `"$menuLocal`"" -ForegroundColor Cyan
} else {
    Write-Host "❌ Error: No se pudo descargar menu.ps1." -ForegroundColor Red
    Read-Host
}
