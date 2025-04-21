# collect-securitylogs.ps1
# Script criado durante o curso de PowerShell para coleta de logs da Security Blue Team
# Coleta eventos de login bem-sucedido (ID 4624) do log de segurança do Windows

# Define o diretório onde os logs serão salvos
$outputPath = "C:\SecurityLogs"

# Verifica se o diretório existe; se não, cria
if (-not (Test-Path -Path $outputPath)) {
    New-Item -ItemType Directory -Path $outputPath
}

# Obtém a data atual no formato YYYYMMDD para nomear o arquivo
$currentDate = Get-Date -Format "yyyyMMdd"

# Define o intervalo de tempo: o dia atual
$startTime = (Get-Date).Date
$endTime = (Get-Date).Date.AddDays(1).AddSeconds(-1)

# Define o filtro para eventos de logon bem-sucedido (ID 4624) no log de segurança
$filterHashtable = @{
    LogName   = "Security"
    ID        = 4624
    StartTime = $startTime
    EndTime   = $endTime
}

# Coleta os eventos com base no filtro
$events = Get-WinEvent -FilterHashtable $filterHashtable

# Exporta os logs para um arquivo XML se houver eventos encontrados
if ($events) {
    $events | Export-CliXml -Path "$outputPath\$currentDate-SecurityLogs.xml"
    Write-Host "Security logs for successful logins on $currentDate have been collected and saved to: $outputPath" -ForegroundColor Green
} else {
    Write-Host "No security logs for successful logins found for $currentDate." -ForegroundColor Yellow
}
