Param(
    [parameter(Mandatory=$true,
    ValueFromPipeline=$true)]
    [String[]]
    $user
)

 Get-MailBox | Where {$_.ResourceType -eq "Room"} | %{Add-MailboxPermission -Identity $_.Alias -User $user -AccessRights FullAccess}