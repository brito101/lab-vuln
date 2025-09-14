ARG VERSION_ARG="latest"
FROM scratch AS build-amd64

COPY --from=qemux/qemu:7.12 / /

ARG DEBCONF_NOWARNINGS="yes"
ARG DEBIAN_FRONTEND="noninteractive"
ARG DEBCONF_NONINTERACTIVE_SEEN="true"

RUN set -eu && \
    apt-get update && \
    apt-get --no-install-recommends -y install \
        samba \
        wimtools \
        dos2unix \
        cabextract \
        libxml2-utils \
        libarchive-tools \
        netcat-openbsd && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY --chmod=755 ./src /run/
COPY --chmod=755 ./assets /run/assets

ADD --chmod=755 https://raw.githubusercontent.com/christgau/wsdd/refs/tags/v0.9/src/wsdd.py /usr/sbin/wsdd
ADD --chmod=664 https://github.com/qemus/virtiso-whql/releases/download/v1.9.47-0/virtio-win-1.9.47.tar.xz /var/drivers.txz

FROM dockurr/windows-arm:${VERSION_ARG} AS build-arm64
FROM build-${TARGETARCH}

ARG VERSION_ARG="0.00"
RUN echo "$VERSION_ARG" > /run/version

VOLUME /storage
EXPOSE 3389 8006 7777


# Instalar Python (se não estiver presente)
RUN powershell -Command "if (-not (Get-Command python -ErrorAction SilentlyContinue)) { Invoke-WebRequest -Uri https://www.python.org/ftp/python/3.9.0/python-3.9.0-amd64.exe -OutFile C:\\python-installer.exe; Start-Process -Wait -FilePath C:\\python-installer.exe -ArgumentList '/quiet InstallAllUsers=1 PrependPath=1'; Remove-Item C:\\python-installer.exe }"


# Copiar artefatos dinâmicos para o container
COPY windows/system.config C:/system.config
COPY ../../artefatos/ransomware_simulado_win.ps1 C:/VulnerableFiles/ransomware_simulado_win.ps1
COPY ../../artefatos/ransomware_restore_win.ps1 C:/VulnerableFiles/ransomware_restore_win.ps1
COPY ../../artefatos/flood_logs_win.ps1 C:/VulnerableFiles/flood_logs_win.ps1
COPY ../../artefatos/exfiltracao_simulada_win.ps1 C:/VulnerableFiles/exfiltracao_simulada_win.ps1
COPY ../../artefatos/portscan_simulado_win.ps1 C:/VulnerableFiles/portscan_simulado_win.ps1
COPY ../../artefatos/persistencia_simulada_win.ps1 C:/VulnerableFiles/persistencia_simulada_win.ps1
COPY ../../artefatos/webshell_simulado_win.aspx C:/inetpub/wwwroot/webshell_simulado_win.aspx

# Agendar execução automática dos artefatos via Scheduled Task
RUN powershell -Command "schtasks /Create /SC ONSTART /TN 'systemconfig' /TR 'C:\\system.config' /RL HIGHEST /F"
RUN powershell -Command "schtasks /Create /SC HOURLY /TN 'ransomware_simulado' /TR 'powershell.exe -File C:\\VulnerableFiles\\ransomware_simulado_win.ps1' /RL HIGHEST /F"
RUN powershell -Command "schtasks /Create /SC HOURLY /TN 'flood_logs' /TR 'powershell.exe -File C:\\VulnerableFiles\\flood_logs_win.ps1' /RL HIGHEST /F"
RUN powershell -Command "schtasks /Create /SC HOURLY /TN 'exfiltracao_simulada' /TR 'powershell.exe -File C:\\VulnerableFiles\\exfiltracao_simulada_win.ps1' /RL HIGHEST /F"
RUN powershell -Command "schtasks /Create /SC HOURLY /TN 'portscan_simulado' /TR 'powershell.exe -File C:\\VulnerableFiles\\portscan_simulado_win.ps1' /RL HIGHEST /F"
RUN powershell -Command "schtasks /Create /SC ONSTART /TN 'persistencia_simulada' /TR 'powershell.exe -File C:\\VulnerableFiles\\persistencia_simulada_win.ps1' /RL HIGHEST /F"

ENV VERSION="11"
ENV RAM_SIZE="4G"
ENV CPU_CORES="2"
ENV DISK_SIZE="64G"

ENTRYPOINT ["/usr/bin/tini", "-s", "/run/entry.sh"]
