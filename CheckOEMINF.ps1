<#
.SYNOPSIS
  Name: CheckOEMINF.ps1
  The purpose of this script is to check whether NIC oem INF file exists in the machine
  
.DESCRIPTION
  This script verifies for oem inf file for all active NICs in the physical machine.
  It will check for oeminf only for Windows 7 and Windows 2008 R2 

#>
&{
    $OS = (Get-WmiObject Win32_OperatingSystem).Caption
    $System = Get-WmiObject -Class Win32_ComputerSystem
    $Computer = $env:COMPUTERNAME
    $Result = @()
	$OEMINF = $False
        try {
                $NICObjs = @() 
                $ActiveNICs = Get-WmiObject win32_networkadapter -ErrorAction Stop -filter "netconnectionstatus = 2" | Select-Object Name
                foreach ( $NIC in $ActiveNICs ) {
                     $NICObjs += get-wmiobject win32_PnPSignedDriver -ErrorAction Stop |
                                 where { $_.DeviceName -eq $NIC.Name -or 
                                         $_.Description -eq $NIC.Name -or 
                                         $_.FriendlyName -eq $NIC.Name }
                }
            } catch {
                 Write-Output "Exception : $_.Exception.Message"
                 Exit
            }
        foreach ($NIC in $NICObjs ){
               if ( $NIC.InfName -match "^oe[m]") {
                      $infPath = Join-Path $env:windir "\inf\$($NIC.InfName)"
                      if (Test-Path  $infPath) {
                          $Properties = @{ Computer = $Computer
                                           OS = $OS
                                           NIC = $NIC.DeviceName
                                           OEMINF  = "Present"
                                        }
                          $Result += New-Object -TypeName PSObject $Properties
                          $OEMINF = $True
                      } Else {
                          $Properties = @{ Computer = $Computer
                                           OS = $OS
                                           NIC = $NIC.DeviceName
                                           OEMINF  = "Missing" }
                          $Result += New-Object -TypeName PSObject $Properties 
                      }
               }Else {
                     $Properties = @{ Computer = $Computer
                                      OS = $OS
                                      NIC = $NIC.DeviceName
                                      OEMINF  = "Missing" }
                     $Result += New-Object -TypeName PSObject $Properties     
               }
        }
Write-Output $OEMINF
}
