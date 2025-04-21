<#
    full-securitylogs.ps1
    Script de coleta, análise e geração de relatório de logs de segurança
    Parte do curso de PowerShell da Security Blue Team
#>

# --- CONFIGURAÇÕES INICIAIS ---
# Fontes de logs a serem coletadas
$logSources = @("System", "Application", "Security")

# Diretório de saída
$outputDir = "C:\SecurityLogs"
New-Item -ItemType Directory -Path $outputDir -Force | Out-Null

# --- COLETA DE LOGS PADRÃO DO EVENTVIEWER ---
foreach ($source in $logSources) {
    $logs = Get-EventLog -LogName $source -Newest 1000
    $logs | Export-Csv -Path "$outputDir\$source.csv" -NoTypeInformation
}

# --- COLETA DE LOGS DO SYSMON ---
$sysmonLogs = Get-WinEvent -LogName "Microsoft-Windows-Sysmon/Operational" -MaxEvents 1000
$sysmonLogs | Export-Csv -Path "$outputDir\Sysmon.csv" -NoTypeInformation

# --- FUNÇÃO: Leitura básica dos logs CSV ---
function Parse-Log {
    param ([string]$logFile)
    
    $logData = Import-Csv -Path $logFile
    foreach ($entry in $logData) {
        $eventID = $entry.EventID
        $timeGenerated = $entry.TimeGenerated
        $message = $entry.Message

        Write-Output "EventID: $eventID | Time: $timeGenerated | Message: $message"
    }
}

# --- FUNÇÃO: Análise de logs com foco em possíveis incidentes ---
function Analyze-Log {
    param ([string]$logFile)
    
    $logData = Import-Csv -Path $logFile
    foreach ($entry in $logData) {
        $eventID = $entry.EventID
        $timeGenerated = $entry.TimeGenerated
        $message = $entry.Message

        if ($eventID -in 4625, 4648, 4688, 4689, 4768) {
            Write-Output "[ALERTA] Incidente potencial detectado: EventID $eventID em $timeGenerated"
        }
    }
}

# --- FUNÇÃO: Geração de relatório HTML com eventos relevantes ---
function Generate-Report {
    param ([string]$reportFile)
    
    $html = @"
<!DOCTYPE html>
<html>
<head>
    <title>Security Log Analysis Report</title>
    <style>
        body { font-family: Arial; }
        table { border-collapse: collapse; width: 100%; }
        th, td { border: 1px solid #ccc; padding: 8px; }
        th { background-color: #eee; }
    </style>
</head>
<body>
    <h1>Security Log Analysis Report</h1>
    <table>
        <tr><th>EventID</th><th>Time</th><th>Message</th></tr>
"@

    $logFiles = Get-ChildItem -Path $outputDir -Filter *.csv
    foreach ($logFile in $logFiles) {
        $logData = Import-Csv -Path $logFile.FullName
        foreach ($entry in $logData) {
            $eventID = $entry.EventID
            $timeGenerated = $entry.TimeGenerated
            $message = $entry.Message

            if ($eventID -in 4625, 4648, 4688, 4689, 4768) {
                $html += "<tr><td>$eventID</td><td>$timeGenerated</td><td>$message</td></tr>"
            }
        }
    }

    $html += @"
    </table>
</body>
</html>
"@

    $html | Out-File -FilePath $reportFile
}

# --- EXECUÇÃO DAS FUNÇÕES ---
$logFiles = Get-ChildItem -Path $outputDir -Filter *.csv
foreach ($logFile in $logFiles) {
    Parse-Log -logFile $logFile.FullName
    Analyze-Log -logFile $logFile.FullName
}

# --- GERAÇÃO DO RELATÓRIO FINAL ---
$reportFile = "$outputDir\AnalysisReport.html"
Generate-Report -reportFile $reportFile

Write-Host "`n✅ Relatório gerado em: $reportFile" -ForegroundColor Green
