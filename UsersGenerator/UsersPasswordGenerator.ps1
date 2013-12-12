# User/Password Generation Script
# generates random passwords for each user for importing to linux servers
# the script relying on Active Directory as users repository
# 
# ** set tunable in config.xml **
# 
# Written by Freiberg 16.6.2013
### TODOs:
###		* DN-Based Search
###		* Logging mechanism?

#Active Directory module is needed, must import it first.
Import-Module ActiveDirectory

# Define bad characters for UNIX users
$BadChars = [regex]"[!@#$%^&*()+=]"

#Generates a RANDOM password which is unix compatible
function Get-RandomPassword {
	param(
			$length=15,
			#allowed chars for UNIX password
			$chars='abcdefghijklmnprstuvwxyzABCDEFHIJKLMPRSTUVWXYZ123456789!'
		)	
	#select random characters
	$random=1..$length | ForEach-Object {Get-Random -Maximum $chars.length}
	#output random pwd
	$private:ofs=""
	[String]$chars[$random]
}

function IsUserExists {
write-host "Checking" $user
$ExistPass="" #assume that user doesnt exists
	foreach ($u in $currentUsers) {
		$u=$u.Split(":")
		$userfromfile=$u[0]
		$passfromfile=$u[1]
		if ($user -eq $userfromfile) {
			return $passfromfile #User Exists
		}
	}
Return $ExistPass
}

#Read config
###Load XML configuration file
Try {
[xml]$configFile=Get-Content config.xml -ErrorAction Stop
}
Catch {
Write-Host "Missing configuration file (config.xml)" -Foreground Red
exit
}
$FlushPasswords=$configFile.Config.Globals.FlushPasswords
$DNList=$configFile.Config.Globals.BaseDN.DN
$GroupList=$configFile.Config.Globals.SecurityGroups.Group

write-host "Create new password for existing users: "  -NoNewLine
if ($FlushPasswords -eq "true")
	{ write-host -Foreground Green $FlushPasswords }
elseif ($FlushPasswords -eq "false")
	{ write-host -Foreground Red $FlushPasswords }
	else {
		write-host -Foreground Red "Missing Configuration" #Bad value on config.xml
		exit
		}
		
#TODO: DN Based search - IGNORED
#write-host "Create linux users for users objects under OU(s):" 
#foreach ($DN in $DNList) { write-host -Foreground Yellow "---->" $DN }

write-host "Create UNIX-like users for objects under group(s):"
foreach ($Group in $GroupList) { write-host -Foreground Yellow "---->" $Group }
### Outputs Paths
$UsersFilePath=$configFile.Config.Outputs.UsersFilePath
$NewUsersDiff=$configFile.Config.Outputs.NewUsersDiff
$BadUsersPath=$configFile.Config.Outputs.BadUsersPath


#add security group members recursively by samAccountName.
foreach ($Group in $GroupList) { 
	write-host "Looking for group members in: " -NoNewLine 
	write-host -Foreground Yellow $Group
	try {
	$AllUsers += Get-ADGroupMember -Identity $Group -Recursive | select samAccountName 
	}
	catch{
		write-host "Probelm with AD Querying. stopping!"  -Foreground Red
		exit
	}
}

#Remove duplicate users
write-host "Removing duplicates... "
$AllUsers = $AllUsers | Select samAccountName -Unique

#Get current users file (if doesnt exists - create it)
Try { 
	$currentUsers = Get-Content $UsersFilePath -ErrorAction Stop 
} 
Catch {
	Write-Host "Users file does not exists. creating new one... (Path: $UsersFilePath)" -Foreground Red
	$FlushPasswords="True"
}

#generate passwords for each users
$userpass = New-Object string[] $AllUsers.Length
$diff = New-Object string[] $AllUsers.Length
$badusers = New-Object string[] $AllUsers.Length

for ($i=0; $i -lt $AllUsers.Length; $i++) {
    $user = $AllUsers[$i].samAccountName.Trim().ToLower()
    if ($BadChars.Match($user).Success) {
		write-host "User {0} contains bad characters, skipping" -f $user -foreground Yellow
		$badusers[$i] = "{0}" -f $user
	} else {
		#Check for existing users
		$result=IsUserExists
		if ($result -ne "") {
			write-host "User Exists" -foreground Green
			if ($FlushPasswords -eq "True") {
				#Create New Passwords for all users
				$pass = Get-RandomPassword	
			} else {
				$pass = $result
			}
			
			# Add user to the list
			$userpass[$i] = "{0}:{1}" -f $user, $pass
		}
			$pass=$result
			$userpass[$i] = "{0}:{1}" -f $user, $pass
		} else {
			write-host "User NOT Exists, adding it..." -foreground Red
			$pass = Get-RandomPassword
			$userpass[$i] = "{0}:{1}" -f $user, $pass
			$diff[$i] = "{0}:{1}" -f $user, $pass
		}
	}
}


###Write Outputs
$userpass | Out-File -Encoding Default $UsersFilePath
$diff | Out-File -Encoding Default $NewUsersDiff
$badusers | Out-File -Encoding Default $BadUsersPath

