<#
.SYNOPSIS
  Name: CheckPvsVmBoot.ps1
  
.DESCRIPTION
  This script verifies for PvsVmBoot in BootExecute for Xenapp Machines

#>

$OS = (Get-WmiObject Win32_OperatingSystem).Caption
$Computer = $env:COMPUTERNAME
$Result = @()

$Location = @()
$Location = "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager", "HKLM:\SYSTEM\ControlSet001\Control\Session Manager", "HKLM:\SYSTEM\ControlSet002\Control\Session Manager"
$ErrorActionPreference = "Stop"

Try {
    foreach ($loc in $Location) {
        $x = (Get-ItemProperty -Path $loc).BootExecute
        $found = $false
        
        foreach ($value in $x) {
            if ($value -like "*PvsVMBoot*") {
               $found = $true
            }
        }
        if ($found -eq $false) {
            $Properties = @{ Path = $Loc
                OS                    = $OS
                RegValue              = "NotPresent" 
            }
            $Result += New-Object -TypeName PSObject $Properties
        }
    }
}
catch [System.Exception] {
    switch ($_.Exception.GetType().FullName) {
        'System.Management.Automation.ItemNotFoundException' {
            #write-host 'ItemNotFound'
        }
        default {'well, darn'}
    }
}
Finally {
    $ErrorActionPreference = "Continue"
    Write-Output $Result
}

