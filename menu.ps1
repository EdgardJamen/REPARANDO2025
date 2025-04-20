# menu.ps1 - Parte 1: Configuración inicial y autenticación

# Definir la fecha de vencimiento de la suscripción
$fechaVencimiento = "2025-12-31"
$usuario = $env:USERNAME

# Verificar si la suscripción ha expirado
if ((Get-Date) -gt (Get-Date $fechaVencimiento)) {
    Write-Host "Tu suscripción ha expirado. Contacta con soporte para renovarla."
    Exit
}

# Mostrar información del usuario
Write-Host "Bienvenido, $usuario"
Write-Host "Tu suscripción es válida hasta: $fechaVencimiento"

# Descargar el menú principal desde GitHub
$menuUrl = "https://raw.githubusercontent.com/EdgardJamen/REPARANDO2025/main/menu.ps1"
$menuLocal = "$env:TEMP\menu.ps1"

Invoke-WebRequest -Uri $menuUrl -OutFile $menuLocal
& $menuLocal
