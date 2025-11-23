import http.server
import socketserver
import os
from pathlib import Path

# Change to the directory containing this script
os.chdir(Path(__file__).parent)

PORT = 3000
Handler = http.server.SimpleHTTPRequestHandler

with socketserver.TCPServer(("", PORT), Handler) as httpd:
    print(f"Server running at http://localhost:{PORT}")
    print(f"Press Ctrl+C to stop the server")
    httpd.serve_forever()
