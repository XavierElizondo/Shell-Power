$RegistrationToken = "eyJhbGciOiJSUzI1NiIsImtpZCI6Ijk3NkE4Q0I1MTQwNjkyM0E4MkU4QUQ3MUYzQjE4NzEyN0Y2OTRDOTkiLCJ0eXAiOiJKV1QifQ.eyJSZWdpc3RyYXRpb25JZCI6IjQzMmY3YmU0LWUwZmEtNDhjNC04ZDQxLWUzNGQ4MWE4N2Y2YyIsIkJyb2tlclVyaSI6Imh0dHBzOi8vcmRicm9rZXItZy11cy1yMC53dmQubWljcm9zb2Z0LmNvbS8iLCJEaWFnbm9zdGljc1VyaSI6Imh0dHBzOi8vcmRkaWFnbm9zdGljcy1nLXVzLXIwLnd2ZC5taWNyb3NvZnQuY29tLyIsIkVuZHBvaW50UG9vbElkIjoiYjkxYTJkZDEtODZjYy00Nzk3LTgzM2QtYWVlYjM2N2Q4MzFjIiwiR2xvYmFsQnJva2VyVXJpIjoiaHR0cHM6Ly9yZGJyb2tlci53dmQubWljcm9zb2Z0LmNvbS8iLCJHZW9ncmFwaHkiOiJVUyIsIkdsb2JhbEJyb2tlclJlc291cmNlSWRVcmkiOiJodHRwczovL2I5MWEyZGQxLTg2Y2MtNDc5Ny04MzNkLWFlZWIzNjdkODMxYy5yZGJyb2tlci53dmQubWljcm9zb2Z0LmNvbS8iLCJCcm9rZXJSZXNvdXJjZUlkVXJpIjoiaHR0cHM6Ly9iOTFhMmRkMS04NmNjLTQ3OTctODMzZC1hZWViMzY3ZDgzMWMucmRicm9rZXItZy11cy1yMC53dmQubWljcm9zb2Z0LmNvbS8iLCJEaWFnbm9zdGljc1Jlc291cmNlSWRVcmkiOiJodHRwczovL2I5MWEyZGQxLTg2Y2MtNDc5Ny04MzNkLWFlZWIzNjdkODMxYy5yZGRpYWdub3N0aWNzLWctdXMtcjAud3ZkLm1pY3Jvc29mdC5jb20vIiwibmJmIjoxNjI4MDI1MDMyLCJleHAiOjE2MzAyOTYwMDAsImlzcyI6IlJESW5mcmFUb2tlbk1hbmFnZXIiLCJhdWQiOiJSRG1pIn0.D7e_cM7WFSncRnrdm5Uv5uI0bWd6DOp3iRakGNiLh90Vzab3tg_YssRZ5himX7A_ofNnkItExLESgNLyc87aeV4zo19POUdORyerbXcGtQABetxl7zLwW62tAyqUP8B4oJtn4Hb2DtfcqPkxGzKf1VvMIT5XItkc55i5EvF21fx7Mn-vulkVJHZk_CsPJiAEfg4GTxyo_VarSw31syOOKTsm0tAUCa9bLCHSP2MczyyNFl-nBno0qlYqeQ327OOn4HrGAq0-3igzmBfkLKKUaEcpCeDKw_JeJ23dTMk8Tq47_pVThgLc7uZLZriiUW0ary0PKJ1iu2FEf84_ZjnFwg"
$InstallFolder = "c:\temp"


if (!(Test-Path $InstallFolder))
{
New-Item -itemType Directory -Path c:\ -Name temp
}
else
{
write-host "Folder already exists"
}

if (!$RegistrationToken) {
    throw "No registration token specified"
}


function Test-IsAdmin {
    ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")
}



#Download WVD agent
invoke-WebRequest -Uri "https://query.prod.cms.rt.microsoft.com/cms/api/am/binary/RWrmXv" -OutFile "$InstallFolder\Microsoft.RDInfra.RDAgent.Installer-x64.msi"

#Download WVD agent bootloader
invoke-WebRequest -Uri "https://query.prod.cms.rt.microsoft.com/cms/api/am/binary/RWrxrH" -OutFile "$InstallFolder\Microsoft.RDInfra.RDAgentBootLoader.Installer-x64.msi"


# Install WVD agent bootLoader
Start-Process -FilePath "msiexec.exe" -ArgumentList "/i $InstallFolder\Microsoft.RDInfra.RDAgentBootLoader.Installer-x64.msi", "/quiet", "/qn", "/norestart", "/passive", "/l* $InstallFolder\AgentBootLoaderInstall.log" -Wait -Passthru

# Install WVD agent 
Start-Process -FilePath "msiexec.exe" -ArgumentList "/i $InstallFolder\Microsoft.RDInfra.RDAgent.Installer-x64.msi", "/quiet", "/qn", "/norestart", "/passive", "REGISTRATIONTOKEN=$RegistrationToken", "/l*v $InstallFolder\AgentInstall.log" -Wait -Passthru

# Install Chrome 
#$LocalTempDir = $env:TEMP; $ChromeInstaller = "ChromeInstaller.exe"; (new-object System.Net.WebClient).DownloadFile('http://dl.google.com/chrome/install/375.126/chrome_installer.exe', "$LocalTempDir\$ChromeInstaller"); & "$LocalTempDir\$ChromeInstaller" /silent /install; $Process2Monitor = "ChromeInstaller"; Do { $ProcessesFound = Get-Process | ?{$Process2Monitor -contains $_.Name} | Select-Object -ExpandProperty Name; If ($ProcessesFound) { "Still running: $($ProcessesFound -join ', ')" | Write-Host; Start-Sleep -Seconds 2 } else { rm "$LocalTempDir\$ChromeInstaller" -ErrorAction SilentlyContinue -Verbose } } Until (!$ProcessesFound)
#https://statics.teams.cdn.office.net/production-windows-x64/1.4.00.2879/Teams_windows_x64.msi
#https://query.prod.cms.rt.microsoft.com/cms/api/am/binary/RE4AQBt

#Add-Computer -DomainName xe.local -OUPath "OU=WVD-Computers,DC=xe,DC=local" -Restart









Get-ItemProperty -Path Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\RDInfraAgent 
Set-ItemProperty -Path Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\RDInfraAgent -Name RegistrationToken -Value "eyJhbGciOiJSUzI1NiIsImtpZCI6Ijk3NkE4Q0I1MTQwNjkyM0E4MkU4QUQ3MUYzQjE4NzEyN0Y2OTRDOTkiLCJ0eXAiOiJKV1QifQ.eyJSZWdpc3RyYXRpb25JZCI6IjcwMDM5NTM0LTRkZWUtNDRhMC05Y2NkLTdjNmU3NWIxZTdmYiIsIkJyb2tlclVyaSI6Imh0dHBzOi8vcmRicm9rZXItZy11cy1yMC53dmQubWljcm9zb2Z0LmNvbS8iLCJEaWFnbm9zdGljc1VyaSI6Imh0dHBzOi8vcmRkaWFnbm9zdGljcy1nLXVzLXIwLnd2ZC5taWNyb3NvZnQuY29tLyIsIkVuZHBvaW50UG9vbElkIjoiYjkxYTJkZDEtODZjYy00Nzk3LTgzM2QtYWVlYjM2N2Q4MzFjIiwiR2xvYmFsQnJva2VyVXJpIjoiaHR0cHM6Ly9yZGJyb2tlci53dmQubWljcm9zb2Z0LmNvbS8iLCJHZW9ncmFwaHkiOiJVUyIsIkdsb2JhbEJyb2tlclJlc291cmNlSWRVcmkiOiJodHRwczovL2I5MWEyZGQxLTg2Y2MtNDc5Ny04MzNkLWFlZWIzNjdkODMxYy5yZGJyb2tlci53dmQubWljcm9zb2Z0LmNvbS8iLCJCcm9rZXJSZXNvdXJjZUlkVXJpIjoiaHR0cHM6Ly9iOTFhMmRkMS04NmNjLTQ3OTctODMzZC1hZWViMzY3ZDgzMWMucmRicm9rZXItZy11cy1yMC53dmQubWljcm9zb2Z0LmNvbS8iLCJEaWFnbm9zdGljc1Jlc291cmNlSWRVcmkiOiJodHRwczovL2I5MWEyZGQxLTg2Y2MtNDc5Ny04MzNkLWFlZWIzNjdkODMxYy5yZGRpYWdub3N0aWNzLWctdXMtcjAud3ZkLm1pY3Jvc29mdC5jb20vIiwibmJmIjoxNjI2ODcwMDA5LCJleHAiOjE2MjgzMDg4MDAsImlzcyI6IlJESW5mcmFUb2tlbk1hbmFnZXIiLCJhdWQiOiJSRG1pIn0.gaxMGaRdjXMUeEghIWyrrFWTGAWrDHoJuj5xhS1PE5P-8Yg8J1d_h3mQ12pPyMaHFE8ovnKJZBaUfTAbrJt6Rx9IN0UAVbzMa10D21ihdljbxkk9MnrB41tBbi2153nKy8sS-JoOG6Jia8T-NOueZOqt1fM_ctyox75nx_XeLOOAy3Ogaz-HD-hJh7fafa5sfynejYwdNxL-gMs24Ywcb9Io1dpnDWlUibYyLVufpN_aI_o99yh1Nsw-Qcnht2TPfRrqsEKBrV2RsfJW1B2GVQkjmzN6FaZTTej-qMTCBhcstK35hrM7YjH5GKC4NdF5e_cPitshoJDyCBfLmnOjPQ"
Set-ItemProperty -Path Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\RDInfraAgent -Name IsRegistered -Value 0 
Restart-Service -Name RDAgentBootLoader
Get-ItemProperty -Path Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\RDInfraAgent 
