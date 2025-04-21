# Get-FileLastWriteTime.ps1
# Script desenvolvido durante o curso de PowerShell da Security Blue Team.
# Esse script coleta os arquivos de um diretório e os ordena pela data da última modificação (LastWriteTime).

# Define um parâmetro de entrada chamado "directory"
param (
    [string]$directory  # Diretório onde o script irá buscar os arquivos
)

# Lista os arquivos no diretório especificado (-File garante que só arquivos sejam listados)
# Ordena os arquivos pela data de última modificação (LastWriteTime)
# Seleciona e exibe o caminho completo (FullName) e a data da última modificação (LastWriteTime)
Get-ChildItem -Path $directory -File |
    Sort-Object LastWriteTime |
    Select-Object FullName, LastWriteTime
