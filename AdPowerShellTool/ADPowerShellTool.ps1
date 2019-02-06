<#	
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2019 v5.6.156
	 Created on:   	21.01.2019 13:07
	 Created by:   	@Tr4pSec
	 Organization: 	
	 Filename:     	ADPowerShellTool.ps1
	===========================================================================
	.DESCRIPTION
		Console tool for grabbing information from Active Directory and LAPS.
#>


#region
$pshost = get-host

$pswindow = $pshost.ui.rawui

$newsize = $pswindow.buffersize

$newsize.height = 3000

$newsize.width = 150

$pswindow.buffersize = $newsize


$newsize = $pswindow.windowsize

$newsize.height = 79

$newsize.width = 75

$pswindow.windowsize = $newsize

$host.ui.RawUI.WindowTitle = "AD Powershell tool - @Tr4pSec"
#endregion




function Show-Menu
{
	param (
		[string]$Title = 'AD Powershell tool - @Tr4pSec'
		
	)
	[console]::ForegroundColor = "Green"
	[console]::BackgroundColor = "black"
	
	$Env:ADPS_LoadDefaultDrive = 0
	Import-Module ActiveDirectory
	[System.Console]::Clear();
	Write-Output "================ $Title ================"
	
	Write-Output "1: Press '1' for AD user info by username."
	Write-Output "2: Press '2' for AD user info by employee ID."
	Write-Output "3: Press '3' for AD user info by full name."
	Write-Output "4: Press '4' to unlock an AD account."
	Write-Output "5: Press '5' for LAPS password from hostname."
	Write-Output "Q: Press 'Q' to quit."
	Write-Output "==========================================================="
	Write-Output "    
>    ______  ______     __ __       _____          
>   / ____ \/_  __/____/ // / ____ / ___/___  _____
>  / / __ `/ / / / ___/ // /_/ __ \\__ \/ _ \/ ___/
> / / /_/ / / / / /  /__  __/ /_/ /__/ /  __/ /__  
> \ \__,_/ /_/ /_/     /_/ / .___/____/\___/\___/  
>  \____/                 /_/                      
"
	Write-Output "==========================================================="
}



do
{
	Show-Menu
	$input = Read-Host "Please make a selection"
	$found = "This is the information I was able to find:"
	$userinfo = "USER INFORMATION"
	$contactinfo = "CONTACT INFORMATION"
	$accountinfo = "ACCOUNT INFORMATION"
	$pwdinfo = "PASSWORD INFORMATION"
	$miscinfo = "MISC"
	$nouserfound = "No user found, please try again!"
	$logo = "    
>    ______  ______     __ __       _____          
>   / ____ \/_  __/____/ // / ____ / ___/___  _____
>  / / __ `/ / / / ___/ // /_/ __ \\__ \/ _ \/ ___/
> / / /_/ / / / / /  /__  __/ /_/ /__/ /  __/ /__  
> \ \__,_/ /_/ /_/     /_/ / .___/____/\___/\___/  
>  \____/                 /_/                      
"
	switch ($input)
	{
		'1' {
			[System.Console]::Clear();
			$user = read-host "Username"
			$userquery1 = Get-ADUser -Identity $user -Properties *
			$managerquery = (get-aduser (get-aduser $user -Properties manager).manager).samaccountName
			
			if ($userquery1)
			{
				[System.Console]::Clear();
				Write-Output "$found"
				Write-Output "==========================================================================="
				Write-Output "$userinfo"
				Write-Output "==========================================================================="
				$userquery1 | select-object DisplayName, EmployeeID, departmentNumber, Description, EmployeeType, Department, Title, Office, City, co | format-list | out-host
				Write-Output "Manager: $managerquery"
				write-host "`n"
				Write-Output "==========================================================================="
				Write-Output "$contactinfo"
				Write-Output "==========================================================================="
				$userquery1 | select-object mobile, OfficePhone, mail | format-list | out-host
				Write-Output "==========================================================================="
				Write-Output "$accountinfo"
				Write-Output "==========================================================================="
				$userquery1 | select-object Created, AccountExpirationDate, Enabled, LockedOut | format-list | out-host
				Write-Output "==========================================================================="
				Write-Output "$pwdinfo"
				Write-Output "==========================================================================="
				$userquery1 | select-object PasswordLastSet, PasswordExpired, CannotChangePassword | format-list | out-host
				$userInfo = $userquery1 | select-object PasswordLastSet, PasswordExpired, CannotChangePassword
				Write-Output "Password Expires:"
				$($userInfo.PasswordLastSet).AddDays(90) | select-object -expandproperty DateTime | format-list | out-host
				write-host "`n"
				Write-Output "==========================================================================="
				Write-Output "$miscinfo"
				Write-Output "==========================================================================="
				$userquery1 | select-object SID | format-list | out-host
				Write-Output "==========================================================================="
				Write-Output "$logo"
			}
			if ($userquery1 -eq $null)
			{
				[System.Console]::Clear();
				$nouserfound
			}
		} '2' {
			[System.Console]::Clear();
			$en = read-host "Employee Number"
			$userquery2 = $null
			$userquery2 = Get-ADUser -LDAPFilter "(employeeid=$en)" -Properties *
			$user2 = $userquery2.samaccountname
			$managerquery = (get-aduser (get-aduser $user2 -Properties manager).manager).samaccountName
			
			if ($userquery2)
			{
				[System.Console]::Clear();
				Write-Output "$found"
				Write-Output "==========================================================================="
				Write-Output "$userinfo"
				Write-Output "==========================================================================="
				$userquery2 | select-object DisplayName, EmployeeID, departmentNumber, Description, EmployeeType, Department, Title, Office, City, co | format-list | out-host
				Write-Output "Manager: $managerquery"
				write-host "`n"
				Write-Output "==========================================================================="
				Write-Output "$contactinfo"
				Write-Output "==========================================================================="
				$userquery2 | select-object mobile, OfficePhone, mail | format-list | out-host
				Write-Output "==========================================================================="
				Write-Output "$accountinfo"
				Write-Output "==========================================================================="
				$userquery2 | select-object Created, AccountExpirationDate, Enabled, LockedOut | format-list | out-host
				Write-Output "==========================================================================="
				Write-Output "$pwdinfo"
				Write-Output "==========================================================================="
				$userquery2 | select-object PasswordLastSet, PasswordExpired, CannotChangePassword | format-list | out-host
				$userInfo = $userquery2 | select-object PasswordLastSet, PasswordExpired, CannotChangePassword
				Write-Output "Password Expires:"
				$($userInfo.PasswordLastSet).AddDays(90) | select-object -expandproperty DateTime | format-list | out-host
				write-host "`n"
				Write-Output "==========================================================================="
				Write-Output "$miscinfo"
				Write-Output "==========================================================================="
				$userquery2 | select-object SID | format-list | out-host
				Write-Output "==========================================================================="
				Write-Output "$logo"
			}
			if ($userquery2 -eq $null)
			{
				[System.Console]::Clear();
				$nouserfound
			}
		} '3' {
			[System.Console]::Clear();
			$fullname = read-host "Full name"
			$userquery3 = $null
			$userquery3 = Get-ADUser -LDAPFilter "(name=$fullname)" -Properties *
			$user3 = $userquery3.samaccountname
			$managerquery = (get-aduser (get-aduser $user3 -Properties manager).manager).samaccountName
			
			if ($userquery3)
			{
				[System.Console]::Clear();
				Write-Output "$found"
				Write-Output "==========================================================================="
				Write-Output "$userinfo"
				Write-Output "==========================================================================="
				$userquery3 | select-object DisplayName, EmployeeID, departmentNumber, Description, EmployeeType, Department, Title, Office, City, co | format-list | out-host
				Write-Output "Manager: $managerquery"
				write-host "`n"
				Write-Output "==========================================================================="
				Write-Output "$contactinfo"
				Write-Output "==========================================================================="
				$userquery3 | select-object mobile, OfficePhone, mail | format-list | out-host
				Write-Output "==========================================================================="
				Write-Output "$accountinfo"
				Write-Output "==========================================================================="
				$userquery3 | select-object Created, AccountExpirationDate, Enabled, LockedOut | format-list | out-host
				Write-Output "==========================================================================="
				Write-Output "$pwdinfo"
				Write-Output "==========================================================================="
				$userquery3 | select-object PasswordLastSet, PasswordExpired, CannotChangePassword | format-list | out-host
				$userInfo = $userquery3 | select-object PasswordLastSet, PasswordExpired, CannotChangePassword
				Write-Output "Password Expires:"
				$($userInfo.PasswordLastSet).AddDays(90) | select-object -expandproperty DateTime | format-list | out-host
				Write-Output "==========================================================================="
				Write-Output "$miscinfo"
				Write-Output "==========================================================================="
				$userquery3 | select-object SID
				Write-Output "==========================================================================="
				Write-Output "$logo"
			}
			if ($userquery3 -eq $null)
			{
				[System.Console]::Clear();
				$nouserfound
			}
		} '4' {
			[System.Console]::Clear();
			$Userquery5 = read-host "Username to unlock"
			[System.Console]::Clear();
			try
			{
				Unlock-ADAccount $userquery5
				
				Write-Output "$Userquery5 was unlocked! Success!" | format-list | out-host
				
			}
			catch
			{
				Write-Output "Did you spell that wrong? Try again" | format-list | out-host
			}
			
		} '5' {
			[System.Console]::Clear();
			$Userquery6 = read-host "Hostname"
			[System.Console]::Clear();
			try
			{
				
				$lapsfind = Get-AdmPwdPassword -ComputerName $Userquery6 | Select-Object password
				write-host "`n"
				$lapsfind | format-list | out-host
				
			}
			catch
			{
				Write-Output "No LAPS pwd found for $userquery6. Try again"
			}
			
		} 'q' {
			return
		}
	}
	pause
}
until ($input -eq 'q')

