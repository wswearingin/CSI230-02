# Check if Google Chrome is already running
$chromeProcess = Get-Process -Name "chrome" -ErrorAction SilentlyContinue

if ($chromeProcess) {
    # If Chrome is running, stop it
    Stop-Process -Name "chrome" -Force
    Write-Host "Google Chrome was running and has been stopped."
} else {
    # If Chrome is not running, start it and open Champlain.edu
    Start-Process "chrome.exe" "https://www.champlain.edu"
}
