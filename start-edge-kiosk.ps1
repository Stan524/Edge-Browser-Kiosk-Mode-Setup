# Scriptoteket startup script for kiosk screens
# Author: Dan Michael
# Modified: 2019-07-01

# Modified by Stan524
# 3-25-2024

# ------------------------------------------------------------------------------------
# Settings:

# Path to some powerpoint file that can run in the background to prevent lock screen:
$powerpointFile = "REPLACE ME"

# The URL for the Kiosk application:
$kioskUrl = "REPLACE ME"

# ------------------------------------------------------------------------------------

# 1. Ensure clean slate where nothing is running already
$apps = @("POWERPNT", "msedge")
foreach ($app in $apps) {
	Get-Process -Name $app -ErrorAction SilentlyContinue | Stop-Process
	Wait-Process -Name $app -ErrorAction SilentlyContinue
}

# 2. Start Powerpoint in background to prevent lock screen
Write-Host "Starting powerpoint..."
$powerpoint = New-Object -ComObject powerpoint.application
$powerpoint.visible = [Microsoft.Office.Core.MsoTriState]::msoTrue
$presentation = $powerpoint.Presentations.open($powerpointFile) 
$presentation.SlideShowSettings.Run()

# 3. Wait for network	  
Write-Host "Waiting for network..."
do {
	$ping = Test-Connection -ComputerName uio.no -Count 1 -Quiet
} until ($ping)

# 4. Start Edge
Write-Host "Starting browser"
$edge = Join-Path ${env:ProgramFiles(x86)} "Microsoft\Edge\Application\msedge.exe"
$edge_args= "--kiosk $kioskUrl --edge-kiosl-type=fullscreen"
Start-Process $edge $edge_args
