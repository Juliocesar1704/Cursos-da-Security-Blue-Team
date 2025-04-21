# analyze-securitylogs.ps1
# Script criado durante o curso de PowerShell para análise de logs da Security Blue Team
# Analisa arquivos XML de logs de segurança coletados e resume logins bem-sucedidos (ID 4624)

# Define o diretório onde os arquivos XML estão armazenados
$inputPath = "C:\SecurityLogs"

# Verifica se o diretório existe
if (-not (Test-Path -Path $inputPath)) {
    Write-Host "The specified input path does not exist." -ForegroundColor Red
    exit
}

# Coleta todos os arquivos .xml do diretório
$xmlFiles = Get-ChildItem -Path $inputPath -Filter "*.xml"
if ($xmlFiles.Count -eq 0) {
    Write-Host "No XML files found for analysis." -ForegroundColor Yellow
    exit
}

# Inicializa o contador de logins bem-sucedidos
$successfulLoginCount = 0

# Percorre todos os arquivos XML encontrados
foreach ($file in $xmlFiles) {
    # Carrega o conteúdo XML do arquivo
    [xml]$xmlContent = Get-Content -Path $file.FullName

    # Conta quantos eventos têm ID 4624 (logins bem-sucedidos)
    $successfulLoginCount += ($xmlContent.Objs.Obj |
        Where-Object {
            $_.Props.I32.N -eq "Id" -and $_.Props.I32."#text" -eq "4624"
        }).Count
}

# Exibe o total de logins bem-sucedidos
Write-Host "Total successful logins: $successfulLoginCount" -ForegroundColor Green
