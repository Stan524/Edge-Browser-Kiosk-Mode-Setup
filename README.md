# Scripts and tips for Windows 10/11 Edge in Kiosk mode
Scripts and tips for setting up a Windows 10/11 PC with Edge and Chromium based derivatives in Kiosk mode.

This document contains:

1. Setup automatic login
2. Setup nightly reboots
3. Running Kiosk mode on boot
4. Preventing sleeping / disabling screen saver
5. Disable lock screen
6. Prepare Edge startup script

## Setup automatic login

You will need to have two local users: one administrator (for setup) and one non-administrator (for kiosk auto-login). Once you have this, do the following:

1. As administrator, press the Windows key and type "regedit" and Enter.
You will have to either change or create new entries depending on whether they already exist or not.
2. Under `HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System`:
    1. Change `LocalAccountTokenFilterPolicy` (32-bit DWORD) to 1 (hex or dec is the same).
3. Under `HKEY_LOCAL_MACHINE\Software\Microsoft\Windows NT\CurrentVersion\Winlogon`:
    1. Set `AutoAdminLogon` (STRING) to 1.
    2. Set `DefaultDomainName` (STRING) to the computer name.
    3. Set `DefaultUserName` (STRING) to the name of your non-administrator user.
    4. Set `DefaultPassword` (STRING) to the password of your non-administrator user. 
    5. Delete `AutoLogonCount` if it exists.

## Setup nightly reboots

It is a good idea to do a reboot every night or at least once a week, to ensure updates are run.
To schedule reboots, follow along:

1.	As administrator, press the Windows key and type `Task Scheduler` and Enter.
2.	In the right panel, click on `Create Basic Task`.
3.	Name `KioskNightlyReboot` and click Next.
4.	When asked `When do you want the task to start?`, select `Daily`. Click Next.
5.	Select some time in the night, like `05:00:00`
6.	Clicking Next will bring you to the Action page. Enter "powershell.exe" under "Program/script",
    and enter the path to -ExecutionPolicy Bypass PATH\TO\SCRIPT\ [restart-computer.ps1](https://github.com/Stan524/Edge-Browser-Kiosk-Mode-Setup/blob/master/restart-computer.ps1) under `Add arguments (optional)`. 
7.	Click Next to review all and finally click Finish.

**If it's not working, see https://community.spiceworks.com/how_to/17736-run-powershell-scripts-from-task-scheduler for info about setting execution policy.**

## Running Kiosk mode on boot

1.	As administrator, press the Windows key and type `Task Scheduler` and Enter.
2.	In the right panel, click on `Create Basic Task`.
3.	Name `KioskOnBoot` and click Next.
4.	When asked `When do you want the task to start?`, select `When I log on`. Click Next.
5.	When asked `What action do you wan the task to perform?` select `Start a program`
6.	Clicking Next will bring you to the Action page. Enter "powershell.exe" under "Program/script",
	and enter the path to -ExecutionPolicy Bypass PATH\TO\SCRIPT\ [start-edge-kiosk.ps1](https://github.com/Stan524/Edge-Browser-Kiosk-Mode-Setup/blob/master/start-edge-kiosk.ps1) under `Add arguments (optional)`
7.	Click Next to review all and finally click Finish.

## Preventing sleeping / disabling screen saver

Prevent screen from going black:
1. Click on the Windows-icon on the start menu and type `Power Options`
2. Click on Change Plan Setting-link for Balanced and set both `Turn off the display` and `Put the computer to sleep` to `Never`.

Turn off screen saver:
1. Make sure you are logged in as administrator, and click on the Windows-icon on the start menu and type regedit
2. Go to `HKEY_USERS\.DEFAULT\Control Panel\Desktop`
3. Set `ScreenSaveActive` string value to 0 (you might need to create this entry if it doesn't exist). 
For `Windows 10 Pro`, go here to find a useful instruction: https://www.tenforums.com/tutorials/6567-enable-disable-lock-screen-windows-10-a.html#option2

## Disable lock screen

There are different tips on how to disable the lock screen. None of these worked for us, since it's enforced by policy by GPO that is controlled by our Central IT. We were promised us a more permissive policy for kiosks, but progress is slow, so we have to do the "powerpoint trick". The computer will not lock while a presentation is running in the background.

## Prepare Edge startup script

See [start-edge-kiosk.ps1](https://github.com/Stan524/Edge-Browser-Kiosk-Mode-Setup/blob/master/start-edge-kiosk.ps1) for an example startup script for Edge.

The most important switch is the `--kiosk` switch, but there's also some more that are useful. Edge and Chrome are based on the chromium project. Unfortunately, the switches tend to change from version to version without much notice, so always check with the updated list of working switches here: https://peter.sh/experiments/chromium-command-line-switches/

**On Windows 10, the cursor starts out hidden and does not become visible until it is moved. This is perfect for kiosk screens.**

Useful switches:

- `--kiosk` : Enable kiosk mode (fullscreen with no menus)
- `--noerrdialogs`: Prevent error dialogs.
- `--disable-infobars`: Prevent the yellow information bars.
- `--inprivate` \ `--incognito`: inprivate on edge and incognito on other chromium browsers

In the [start-edge-kiosk.ps1](https://github.com/Stan524/Edge-Browser-Kiosk-Mode-Setup/blob/master/start-edge-kiosk.ps1) script, we are manually adding both the blank powerpoint path and the kiosk url.

**Soon<sup>TM</sup>**

	- Improve firefox support
	- priority of browsers to use edge/chrome/firefox so it is not hardcoded to a single browser
	- add a way of rebooting if the machine hangs/freezes and becomes unresponsive randomly
	- Unify the start scripts
	