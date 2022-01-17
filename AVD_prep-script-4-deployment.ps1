<#	
	.NOTES
	===========================================================================
		 Created on:   	07/08/2020 10:37
	 Created by:   	Xavier Elizondo
	 	===========================================================================
	.DESCRIPTION
		This script is to be used with Azure Custom Scrpt Extentions to deploy Apps to a Windows 10 Multi Session Host.
		
		Steps....
		1. add regkey to state environment is a WVD Environment
		2. Download the Chrome
		3. Install Chrome
	
#>

$InstallFolder = "c:\temp"

if (!(Test-Path $InstallFolder))
{
New-Item -itemType Directory -Path c:\ -Name temp
}
else
{
write-host "Folder already exists"
}

function Test-IsAdmin {
    ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")
}

# Add registry Keys
reg add "HKLM\SOFTWARE\Microsoft\Teams" /v IsWVDEnvironment /t REG_DWORD /d 1 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\office\16.0\common\officeupdate" /v preventteamsinstall /t REG_DWORD /d 1 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\office\16.0\common\officeupdate" /v PreventFirstLaunchAfterInstall /t REG_DWORD /d 1 /f

$LocalTempDir = $env:TEMP; $ChromeInstaller = "ChromeInstaller.exe"; (new-object System.Net.WebClient).DownloadFile('http://dl.google.com/chrome/install/375.126/chrome_installer.exe', "$LocalTempDir\$ChromeInstaller"); & "$LocalTempDir\$ChromeInstaller" /silent /install; $Process2Monitor = "ChromeInstaller"; Do { $ProcessesFound = Get-Process | ?{$Process2Monitor -contains $_.Name} | Select-Object -ExpandProperty Name; If ($ProcessesFound) { "Still running: $($ProcessesFound -join ', ')" | Write-Host; Start-Sleep -Seconds 2 } else { rm "$LocalTempDir\$ChromeInstaller" -ErrorAction SilentlyContinue -Verbose } } Until (!$ProcessesFound)
#https://statics.teams.cdn.office.net/production-windows-x64/1.4.00.2879/Teams_windows_x64.msi
#https://query.prod.cms.rt.microsoft.com/cms/api/am/binary/RE4AQBt