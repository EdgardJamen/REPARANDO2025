# Establecer la codificación para evitar errores con caracteres especiales
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

# 🔒 AUTENTICACION ANTES DE MOSTRAR EL MENU
Write-Host "Autenticando..." -ForegroundColor Yellow

# Descargar el archivo de usuarios desde GitHub
$usuariosUrl = "https://raw.githubusercontent.com/EdgardJamen/REPARANDO2025/main/usuarios.csv"
$usuariosPath = "$env:TEMP\usuarios.csv"
Invoke-WebRequest -Uri $usuariosUrl -OutFile $usuariosPath

# Importar datos de usuarios desde el CSV descargado
$usuarios = Import-Csv $usuariosPath

# Solicitar credenciales
$nombreIngresado = Read-Host "Ingrese su nombre"
$contrasenaIngresada = Read-Host "Ingrese su contrasena"

# Limpieza de espacios y comparación sin diferenciar mayúsculas/minúsculas
$autenticado = $usuarios | Where-Object { 
    $_.Nombre.Trim() -ieq $nombreIngresado.Trim() -and 
    $_.Contrasena.Trim() -ieq $contrasenaIngresada.Trim() 
}

if ($autenticado) {
    Write-Host "✅ Autenticación exitosa. Cargando el menú..." -ForegroundColor Green
    Start-Sleep -Seconds 2
} else {
    Write-Host "❌ Error: Nombre o contraseña incorrectos." -ForegroundColor Red
    Exit
}
