setlocal 
REM ********************************************************************* 
REM Environment customization begins here. Modify variables below. 
REM ********************************************************************* 
REM Set DeployServer to a network-accessible location containing the Office source files. 
set DeployServer=\\dc2\MSOffice\Install
REM Set ConfigFile to the configuration file to be used for deployment (required) 
set ConfigFile=\\dc2\MSOffice\Install\configuration.xml
REM Set LogLocation to a central directory to collect script log files (install log files are set in XML file). 
set LogLocation=\\dc2\MSOffice\Logs
set Remove=\\dc2\MSOffice\Remove
REM *********************************************************************
REM Deployment code begins here. Do not modify anything below this line (check quotes are quotes though).
REM *********************************************************************
REM echo %date% %time% Setup started. >> %LogLocation%\%computername%.txt
REM PowerShell.exe -ExecutionPolicy Bypass -File %Remove%\Remove-PreviousOfficeInstalls.ps1
IF NOT "%ProgramFiles(x86)%"=="" (goto ARP64) else (goto ARP86)
REM Operating system is X64. Check for 32 bit Office in emulated Wow6432 registry key
:ARP64
reg query HKLM\SOFTWARE\WOW6432NODE\Microsoft\Office\16.0\ClickToRunStore\Packages\{9AC08E99-230B-47e8-9721-4577B7F124EA}
if NOT %errorlevel%==1 (goto End)
REM Check for 32 and 64 bit versions of Office 2016 in regular registry key.(Office 64bit would also appear here on a 64bit OS)
:ARP86
reg query HKLM\SOFTWARE\Microsoft\Office\16.0\ClickToRunStore\Packages\{9AC08E99-230B-47e8-9721-4577B7F124EA}
if %errorlevel%==1 (goto DeployOffice) else (goto End)
REM If 1 returned, the product was not found. Run setup here.
:DeployOffice
echo %date% %time% Setup started. >> %LogLocation%\%computername%.txt
PowerShell.exe -ExecutionPolicy Bypass -File %Remove%\Remove-PreviousOfficeInstalls.ps1
echo %date% %time% Office removed. >> %LogLocation%\%computername%.txt
pushd "%DeployServer%"
start /wait setup.exe /configure "%ConfigFile%"
echo %date% %time% Setup ended with error code %errorlevel%. >> %LogLocation%\%computername%.txt
REM If 0 or other was returned, the product was found or another error occurred. Do nothing.
:End
Endlocal


