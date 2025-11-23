╔══════════════════════════════════════════════════════════════════════════════╗
║                                                                              ║
║                    ResonantUF Server - Startinstruktioner                    ║
║                                                                              ║
╚══════════════════════════════════════════════════════════════════════════════╝

Din ResonantUF-server är klar att köras! Följ dessa steg för att starta den:

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

1. ÖPPNA ADMINISTRATÖRS-POWERSHELL:
   - Högerklicka på Windows PowerShell
   - Välj "Kör som administratör"
   - Acceptera att appen får göra ändringar

2. KÖR SERVERN:
   Kopiera och klistra in detta kommando:
   
   cd "c:\efi\Webb\Företag"; powershell -ExecutionPolicy Bypass -File server-admin.ps1

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

3. ÅTKOMST:

   Från denna dator:
   → http://localhost:3000

   Från andra enheter på nätverket:
   → http://<din-dator-ip>:3000
   
   Din dator behöver administratörsrättigheter för att servern kan lyssna på
   port 3000 från nätverket.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

ALTERNATIV (utan administratörsrättigheter):
   
   Kör denna server (ingen administratörsåtkomst krävs):
   cd "c:\efi\Webb\Företag"; python -m http.server 3000
   
   (Kräver att Python är installerat)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

FILER:
   - server-admin.ps1 = Huvudserver (kräver administratörsrättigheter)
   - server.ps1 = Alternativ server
   - server.py = Python-alternativ

═════════════════════════════════════════════════════════════════════════════════
