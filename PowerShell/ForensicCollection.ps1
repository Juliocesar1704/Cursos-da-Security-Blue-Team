# ForensicCollection.ps1
# Script criado durante o curso de PowerShell para Forense Digital da Security Blue Team
# Coleta informações forenses básicas de um sistema Windows

# Coleta informações do sistema
Write-Output "Collecting system information..."
$systemInfo = Get-ComputerInfo
$systemInfo | Out-File -FilePath "C:\Forensics\SystemInfo.txt"

# Coleta informações de usuários locais
Write-Output "Collecting user information..."
$userInfo = Get-LocalUser
$userInfo | Out-File -FilePath "C:\Forensics\UserInfo.txt"

# Coleta lista de processos em execução
Write-Output "Collecting running processes..."
$processes = Get-Process
$processes | Out-File -FilePath "C:\Forensics\Processes.txt"

# Coleta conexões de rede TCP ativas
Write-Output "Collecting network connections..."
$networkConnections = Get-NetTCPConnection
$networkConnections | Out-File -FilePath "C:\Forensics\NetworkConnections.txt"

# Coleta os 100 eventos mais recentes do log do sistema
Write-Output "Collecting event logs..."
$eventLogs = Get-EventLog -LogName System -Newest 100
$eventLogs | Out-File -FilePath "C:\Forensics\EventLogs.txt"

Write-Output "Forensic data collection completed."
