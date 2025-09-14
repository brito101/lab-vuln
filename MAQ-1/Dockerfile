FROM mcr.microsoft.com/windows/servercore:ltsc2022

SHELL ["powershell", "-Command"]

COPY artefatos/svcmon.py C:\artefatos\svcmon.py
COPY artefatos/ransomware_simulado_win.ps1 C:\artefatos\ransomware_simulado_win.ps1
COPY artefatos/ransomware_restore_win.ps1 C:\artefatos\ransomware_restore_win.ps1
COPY artefatos/flood_logs_win.ps1 C:\artefatos\flood_logs_win.ps1
COPY artefatos/exfiltracao_simulada_win.ps1 C:\artefatos\exfiltracao_simulada_win.ps1
COPY artefatos/portscan_simulado_win.ps1 C:\artefatos\portscan_simulado_win.ps1
COPY artefatos/persistencia_simulada_win.ps1 C:\artefatos\persistencia_simulada_win.ps1
COPY artefatos/webshell_simulado_win.aspx C:\inetpub\wwwroot\webshell_simulado_win.aspx

RUN schtasks /Create /SC ONSTART /TN "svcmon" /TR "python.exe C:\artefatos\svcmon.py" /RU SYSTEM
RUN schtasks /Create /SC ONSTART /TN "persistencia_simulada" /TR "powershell.exe -File C:\artefatos\persistencia_simulada_win.ps1"
RUN schtasks /Create /SC DAILY /TN "ransomware_simulado" /TR "powershell.exe -File C:\artefatos\ransomware_simulado_win.ps1"
RUN schtasks /Create /SC DAILY /TN "flood_logs_win" /TR "powershell.exe -File C:\artefatos\flood_logs_win.ps1"
RUN schtasks /Create /SC DAILY /TN "exfiltracao_simulada_win" /TR "powershell.exe -File C:\artefatos\exfiltracao_simulada_win.ps1"
RUN schtasks /Create /SC DAILY /TN "portscan_simulado_win" /TR "powershell.exe -File C:\artefatos\portscan_simulado_win.ps1"

CMD ["powershell.exe"]
