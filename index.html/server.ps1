# Simple HTTP Server using PowerShell
$port = 3000
$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add("http://localhost:$port/")
$listener.Prefixes.Add("http://127.0.0.1:$port/")

# Get local IP address
$ipAddress = (Get-NetIPAddress -AddressFamily IPv4 | Where-Object {$_.IPAddress -notmatch "127.0.0.1"} | Select-Object -First 1).IPAddress
$listener.Prefixes.Add("http://$ipAddress`:$port/")

$listener.Start()

Write-Host "Server is running and accessible at:"
Write-Host "  - http://localhost:$port (local)"
Write-Host "  - http://$ipAddress`:$port (network)"
Write-Host ""
Write-Host "Other devices on your network can access at: http://$ipAddress`:$port"
Write-Host "Press Ctrl+C to stop the server"

$directory = Get-Location

while ($listener.IsListening) {
    $context = $listener.GetContext()
    $request = $context.Request
    $response = $context.Response
    
    $localPath = $request.Url.LocalPath
    if ($localPath -eq "/") {
        $localPath = "/Main.html"
    }
    
    $filePath = Join-Path $directory $localPath.TrimStart("/")
    
    if (Test-Path $filePath -PathType Leaf) {
        $fileContent = [System.IO.File]::ReadAllBytes($filePath)
        $response.ContentLength64 = $fileContent.Length
        
        # Set content type based on file extension
        $extension = [System.IO.Path]::GetExtension($filePath)
        switch ($extension.ToLower()) {
            ".html" { $response.ContentType = "text/html" }
            ".css" { $response.ContentType = "text/css" }
            ".js" { $response.ContentType = "application/javascript" }
            ".json" { $response.ContentType = "application/json" }
            ".png" { $response.ContentType = "image/png" }
            ".jpg" { $response.ContentType = "image/jpeg" }
            ".gif" { $response.ContentType = "image/gif" }
            ".ico" { $response.ContentType = "image/x-icon" }
            default { $response.ContentType = "application/octet-stream" }
        }
        
        $response.OutputStream.Write($fileContent, 0, $fileContent.Length)
    } else {
        $response.StatusCode = 404
        $message = "404 - File not found"
        $buffer = [System.Text.Encoding]::UTF8.GetBytes($message)
        $response.ContentLength64 = $buffer.Length
        $response.OutputStream.Write($buffer, 0, $buffer.Length)
    }
    
    $response.OutputStream.Close()
}

$listener.Stop()
