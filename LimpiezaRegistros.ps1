<#
    LimpiezaRegistros.ps1
    Script para limpiar entradas innecesarias en el registro de Windows,
    enfocado en las claves de ejecución automática (Run) de HKLM y HKCU.
    
    ¡IMPORTANTE! Se recomienda crear una copia de seguridad del registro antes de ejecutarlo.
#>

Clear-Host

Write-Host "============================================" -ForegroundColor Cyan
Write-Host "     Limpieza del Registro de Windows" -ForegroundColor Yellow
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""

# Mostrar una advertencia muy visible mediante un MessageBox
Add-Type -AssemblyName System.Windows.Forms
$mensajeAlerta = "¡¡¡¡ ADVERTENCIA CRITICA !!!!" + [Environment]::NewLine +
                 "Se recomienda crear una COPIA DE SEGURIDAD DEL REGISTRO" + [Environment]::NewLine +
                 "ANTES DE PROCEDER." + [Environment]::NewLine + [Environment]::NewLine +
                 "¿Desea continuar?"
$resultado = [System.Windows.Forms.MessageBox]::Show($mensajeAlerta, "ALERTA CRITICA", `
                [System.Windows.Forms.MessageBoxButtons]::YesNo, `
                [System.Windows.Forms.MessageBoxIcon]::Warning)

if ($resultado -ne [System.Windows.Forms.DialogResult]::Yes) {
    Write-Host "Operacion cancelada." -ForegroundColor Red
    Exit
}

# Definir las claves "Run" a revisar
$runKeys = @(
    "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run",
    "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run"
)

foreach ($key in $runKeys) {
    Write-Host "`nRevisando la llave: $key" -ForegroundColor Yellow
    try {
        $itemProperties = Get-ItemProperty -Path $key -ErrorAction Stop
        foreach ($property in $itemProperties.PSObject.Properties) {
            # Excluir las propiedades inherentes del objeto
            if ($property.Name -in @("PSPath","PSParentPath","PSChildName","PSDrive","PSProvider")) { continue }
            
            $entryName  = $property.Name
            $entryValue = $property.Value
            
            # Intentar extraer la ruta del ejecutable
            if ($entryValue -match '"([^"]+)"') {
                $executable = $matches[1]
            } else {
                $executable = $entryValue.Split(" ")[0].Trim()
            }
            
            # Verificar que el archivo exista
            if (-not (Test-Path $executable)) {
                Write-Host "Entrada invalida encontrada: $entryName => $entryValue" -ForegroundColor Red
                try {
                    Remove-ItemProperty -Path $key -Name $entryName -ErrorAction Stop
                    Write-Host "Entrada eliminada: $entryName" -ForegroundColor Green
                } catch {
                    Write-Host "Error al eliminar la entrada: $entryName" -ForegroundColor Red
                }
            } else {
                Write-Host "Entrada valida: $entryName => $entryValue" -ForegroundColor Green
            }
        }
    } catch {
        Write-Host "No se pudo acceder a la llave: $key" -ForegroundColor Red
    }
}

Write-Host "`nLimpieza del registro completada." -ForegroundColor Cyan
Write-Host "Presiona Enter para cerrar..."
Read-Host
