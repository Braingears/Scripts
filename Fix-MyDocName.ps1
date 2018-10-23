$Path = Read-Host "Please input the folder location you want to search"
$Objs = @() #define an empty array		
				
Function Set-Permission
{
	#Determines whether the path exist.
	if(Test-Path $Path) #it returns TRUE($true) then go to modify block.
	{
		$folders = Get-ChildItem -Path $Path -Force | Where-Object{$_.PsIsContainer} | ForEach-Object{$_.FullName}
		foreach ($folder in $folders)
		{
			$DesktopPath = Get-ChildItem $folder -Filter desktop.ini -Force
    		if ($DesktopPath -ne $null)
    		{
        		try
				{
					$desktopACL = (Get-Item $DesktopPath.FullName -Force).GetAccessControl("Access")
         			$AclSet = New-Object System.Security.Accesscontrol.Filesystemaccessrule("administrators","Read","Deny")
         			$desktopACL.SetAccessRule($AclSet)
         			Set-Acl $DesktopPath.FullName $desktopACL 
					$Status =  "Success"
				
					#define a custom object
					$objInfo = New-Object -TypeName PSObject
					Add-Member -InputObject $objInfo -MemberType NoteProperty -Name "Path" -Value $DesktopPath.FullName
					Add-Member -InputObject $objInfo -MemberType NoteProperty -Name "Permission" -Value "Read"
					Add-Member -InputObject $objInfo -MemberType NoteProperty -Name "Allow/Deny" -Value Deny
					Add-Member -InputObject $objInfo -MemberType NoteProperty -Name "Status" -Value $Status
					$Objs += $objInfo
				}
			 	<#If the error messages displays the "Attempted to perform an unauthorized operation",
				it means the operation is unsuccessful.#>
				catch
				{
					$Status =  "Not Modified"
				
					$objInfo = New-Object -TypeName PSObject
					Add-Member -InputObject $objInfo -MemberType NoteProperty -Name "Path" -Value $DesktopPath.FullName
					Add-Member -InputObject $objInfo -MemberType NoteProperty -Name "Permission" -Value "Read"
					Add-Member -InputObject $objInfo -MemberType NoteProperty -Name "Allow/Deny" -Value Deny
					Add-Member -InputObject $objInfo -MemberType NoteProperty -Name "Status" -Value $Status
					$Objs += $objInfo
				}
    		}
			else
			{
				Write-Host "The desktop.ini file was not found in the $folder." -ForegroundColor Red
			}
		}
		$Objs | Format-Table -AutoSize
	}
	else
	{
		Write-Host "Cannot find this location,it does not exist." -ForegroundColor Red
	}
}

Set-Permission

