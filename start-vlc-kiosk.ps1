# Scriptoteket startup script for kiosk screens
# Author: Dan Michael
# Modified: 2019-07-01

# Modified by Stan524
# 3-25-2024

# ------------------------------------------------------------------------------------
# Settings:

# The URL for the Kiosk application:
$kioskUrl = "C:\PROMO.mp4"

# ------------------------------------------------------------------------------------

# 1. Ensure clean slate where nothing is running already
$apps = @("POWERPNT", "vlc")
foreach ($app in $apps) {
	Get-Process -Name $app -ErrorAction SilentlyContinue | Stop-Process
	Wait-Process -Name $app -ErrorAction SilentlyContinue
}

# 2. Wait for network	  
Write-Host "Waiting for network..."
do {
	$ping = Test-Connection -ComputerName uio.no -Count 1 -Quiet
} until ($ping)

# 3. Start VLC
Write-Host "Starting VLC"
$vlc = Join-Path ${env:ProgramFiles} "VideoLAN\VLC\vlc.exe"
$vlc_args= "--no-audio -f -L $kioskUrl"
Start-Process $vlc $vlc_args
