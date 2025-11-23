# ResonantUF Server - Run as Administrator
$port = 3000

# Get local IP address
$ipAddress = (Get-NetIPAddress -AddressFamily IPv4 | Where-Object {$_.IPAddress -notmatch "127.0.0.1"} | Select-Object -First 1).IPAddress

$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add("http://0.0.0.0:$port/")
$listener.Start()

Write-Host "======================================"
Write-Host "ResonantUF Server - RUNNING"
Write-Host "======================================"
Write-Host ""
Write-Host "Access from this computer:"
Write-Host "  http://localhost:$port"
Write-Host ""
Write-Host "Access from other devices on network:"
Write-Host "  http://$ipAddress`:$port"
Write-Host ""
Write-Host "======================================"
Write-Host "Press Ctrl+C to stop the server"
Write-Host "======================================"
Write-Host ""

$directory = Get-Location

while ($listener.IsListening) {
    try {
        $context = $listener.GetContext()
        $request = $context.Request
        $response = $context.Response
        
        $localPath = $request.Url.LocalPath
        if ($localPath -eq "/" -or $localPath -eq "") {
            $localPath = "/Main.html"
        }
        
        $filePath = Join-Path $directory $localPath.TrimStart("/")
        
        if (Test-Path $filePath -PathType Leaf) {
            $fileContent = [System.IO.File]::ReadAllBytes($filePath)
            $response.ContentLength64 = $fileContent.Length
            
            # Set content type based on file extension
            $extension = [System.IO.Path]::GetExtension($filePath)
            switch ($extension.ToLower()) {
                ".html" { $response.ContentType = "text/html; charset=utf-8" }
                ".css" { $response.ContentType = "text/css" }
                ".js" { $response.ContentType = "application/javascript" }
                ".json" { $response.ContentType = "application/json" }
                ".png" { $response.ContentType = "image/png" }
                ".jpg" { $response.ContentType = "image/jpeg" }
                ".avif" { $response.ContentType = "image/avif" }
                ".gif" { $response.ContentType = "image/gif" }
                ".ico" { $response.ContentType = "image/x-icon" }
                default { $response.ContentType = "application/octet-stream" }
            }
            
            $response.OutputStream.Write($fileContent, 0, $fileContent.Length)
            Write-Host "[$(Get-Date -Format 'HH:mm:ss')] 200 OK - $localPath"
        } else {
            $response.StatusCode = 404
            $message = "404 - File not found: $localPath"
            $buffer = [System.Text.Encoding]::UTF8.GetBytes($message)
            $response.ContentLength64 = $buffer.Length
            $response.OutputStream.Write($buffer, 0, $buffer.Length)
            Write-Host "[$(Get-Date -Format 'HH:mm:ss')] 404 NOT FOUND - $localPath"
        }
        
        $response.OutputStream.Close()
    } catch {
        Write-Host "Error: $_"
    }
}

$listener.Stop()
