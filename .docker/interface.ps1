# Get the current directory
$currentDir = Get-Location

Write-Host ""
Write-Host "Which of the following would you like to open?"
Write-Host "1) Neovim"
Write-Host "2) VS Code"
Write-Host "3) Terminal (default)"
Write-Host ""
Write-Host "Note: If you select VS Code, this container will launch a VS Code server."
Write-Host "      You can then access the server by pointing a web browser to http://localhost:56610"
Write-Host ""

$choice = Read-Host "Enter your choice [1-3]"

# Default to 3 if no input
if ([string]::IsNullOrWhiteSpace($choice)) {
    $choice = "3"
}

Write-Host ""

switch ($choice) {
    "1" {
        Write-Host "Opening Neovim"
        Write-Host ""
        docker run --rm -it -v ${currentDir}:/repo taylorabarnes/devenv bash /.nvim/entrypoint.sh
    }
    "2" {
        # Check if any container is already using the port
        $PORT = 56610
        $containerId = ""
        $containerId = docker ps --filter "publish=$PORT" -q | Select-Object -First 1
        if ($containerId) {
            Write-Host "Cleaning up old container on port $PORT..."
            docker stop $containerId | Out-Null
            Write-Host ""
        }

        Write-Host "Launching VS Code through code-server."
        Write-Host "To use it, open a web browser to http://localhost:56610"
        Write-Host ""
        docker run --rm -it -v ${currentDir}:/repo -p 127.0.0.1:${PORT}:8080 taylorabarnes/devenv bash /.code-server/entrypoint.sh
    }
    "3" {
        Write-Host "Entering an interactive terminal session"
        Write-Host ""
    docker run --rm -it -v ${currentDir}:/repo taylorabarnes/devenv
    }
    Default {
        Write-Host "Invalid option."
        exit 1
    }
}
