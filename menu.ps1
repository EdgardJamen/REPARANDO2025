# Definir la ruta del archivo de usuarios
$usuariosArchivo = "$env:TEMP\usuarios.csv"

# Descargar la base de datos de usuarios desde GitHub
$usuariosUrl = "https://raw.githubusercontent.com/EdgardJamen/REPARANDO2025/refs/heads/main/usuarios.csv"
Invoke-WebRequest -Uri $usuariosUrl -OutFile $usuariosArchivo

# Verificar si la base de datos se descargó correctamente
if (!(Test-Path $usuariosArchivo)) {
    Write-Host "❌ Error: No se pudo descargar la base de datos de usuarios." -ForegroundColor Red
    Exit
}

# Leer usuarios y credenciales desde el archivo CSV
$usuarios = Import-Csv $usuariosArchivo

# Obtener el nombre de usuario del sistema
$usuarioActual = $env:USERNAME
$usuarioValido = $usuarios | Where-Object { $_.Nombre -eq $usuarioActual }

# Validar si el usuario existe en la base de datos
if ($usuarioValido) {
    $fechaVencimiento = $usuarioValido.Vence

    # Manejar el caso especial de "Acceso de por vida"
    if ($fechaVencimiento -eq "Acceso de por vida") {
        Write-Host "✅ Autenticación exitosa. Bienvenido, $usuarioActual" -ForegroundColor Green
        Write-Host "📌 Tu suscripción es válida de por vida!"
    } else {
        # Verificar si la suscripción ha expirado
        if ((Get-Date) -gt (Get-Date $fechaVencimiento)) {
            Write-Host "❌ Tu suscripción ha expirado. Contacta con soporte para renovarla." -ForegroundColor Red
            Exit
        }

        Write-Host "✅ Autenticación exitosa. Bienvenido, $usuarioActual" -ForegroundColor Green
        Write-Host "📌 Tu suscripción es válida hasta: $fechaVencimiento"
    }
} else {
    Write-Host "❌ Acceso denegado. Tu usuario no está registrado en el sistema." -ForegroundColor Red
    Exit
}

# Descargar el menú principal desde GitHub **sin ejecutarlo automáticamente**
$menuUrl = "https://raw.githubusercontent.com/EdgardJamen/REPARANDO2025/refs/heads/main/menu.ps1"
$menuLocal = "$env:TEMP\menu.ps1"
Invoke-WebRequest -Uri $menuUrl -OutFile $menuLocal

# Verificar que el menú se descargó correctamente antes de ejecutarlo manualmente
if (Test-Path $menuLocal) {
    Write-Host "`n✅ Menú descargado correctamente en: $menuLocal" -ForegroundColor Cyan
    Write-Host "📌 Para ejecutarlo manualmente, usa el siguiente comando en PowerShell:" -ForegroundColor Yellow
    Write-Host "`n  `"& $menuLocal`"" -ForegroundColor Cyan
} else {
    Write-Host "❌ Error: No se pudo descargar menu.ps1." -ForegroundColor Red
    Read-Host
}

