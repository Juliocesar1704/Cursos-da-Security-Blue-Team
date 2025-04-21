# 📁 PowerShell Scripts - Security Blue Team Labs

Este diretório contém todos os scripts PowerShell desenvolvidos ao longo dos laboratórios do curso da **Security Blue Team**, focados em coleta, análise e geração de relatórios de logs de segurança em sistemas Windows.

---

## 📂 Estrutura

```
powershell/
├── collect-securitylogs.ps1       # Coleta logs do Windows e salva como XML
├── analyze-securitylogs.ps1       # Analisa os arquivos XML e resume eventos de login (ex: 4624)
├── full-securitylogs.ps1          # Coleta, analisa e gera um relatório HTML a partir de logs CSV
└── AnalysisReport.html            # Exemplo de relatório gerado
```

---

## 🔧 Descrição dos Arquivos

### 1. `collect-securitylogs.ps1`

- **Função:** Coleta logs de segurança usando o `Get-WinEvent`
- **Saída:** Logs salvos como arquivos `.xml` no diretório `C:\SecurityLogs`
- **Uso:**

```powershell
.\collect-securitylogs.ps1
```

### 2. `analyze-securitylogs.ps1`

- **Função:** Analisa os arquivos `.xml` gerados pela coleta e conta eventos de login bem-sucedidos (`4624`)
- **Uso:**

```powershell
.\analyze-securitylogs.ps1
```

- **Extras:** Pode ser agendado pelo Agendador de Tarefas do Windows

### 3. `full-securitylogs.ps1`

- **Função:** Script completo que:
  - Coleta logs de várias fontes (`System`, `Application`, `Security`, `Sysmon`)
  - Analisa eventos suspeitos (ex: `4625`, `4688`, etc.)
  - Gera um relatório em **HTML** destacando eventos relevantes
- **Saída:**
  - Vários arquivos `.csv` com logs brutos
  - Um arquivo `AnalysisReport.html` consolidado
- **Uso:**

```powershell
.\full-securitylogs.ps1
```

---

## ⚙️ Automatização

Para executar qualquer script automaticamente:

- Abra o **Agendador de Tarefas**
- Crie uma nova tarefa
- Configure:
  - Programa/script: `powershell.exe`
  - Argumentos: `-ExecutionPolicy Bypass -File "C:\Path\To\Script.ps1"`

---

## 🔪 Requisitos

- PowerShell 5.1+ ou PowerShell Core
- Permissões de administrador
- Sysmon instalado (opcional para logs mais ricos)

---

## 📌 Observações

- Os arquivos `.csv` podem ser analisados com ferramentas como o **Timeline Explorer**
- Os scripts são facilmente modificáveis para incluir outros `EventID`s ou gerar outros tipos de relatórios (PDF, JSON, etc.)
- Sinta-se à vontade para adaptar o fluxo para múltiplos dispositivos ou servidores

---

## 👨‍💻 Autor

Projeto desenvolvido por mim com auxilio de IA durante os laboratórios da **Security Blue Team (SBT).**
