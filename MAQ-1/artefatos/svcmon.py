import os
import time
import requests

LOG_FILE = "C:\svcmon.log" if os.name == "nt" else "/var/log/svcmon.log"
C2_URL = "https://www.rodrigobrito.dev.br"

while True:
    try:
        resp = requests.get(C2_URL)
        status = f"status: {resp.status_code}"
    except Exception as e:
        status = f"erro: {str(e)}"
    with open(LOG_FILE, "a") as f:
        f.write(f"{time.strftime('%Y-%m-%dT%H:%M:%S')} - {status}\n")
    time.sleep(300)
