# Specify the domain controller (replace 'yourdomaincontroller' with the actual domain controller)
$domainController = "yourdomaincontroller"

# Specify the path to the text files containing usernames and passwords
$usernamesFile = "C:\Path\To\Usernames.txt"
$passwordsFile = "C:\Path\To\Passwords.txt"

# Read usernames and passwords from the text files
$usernames = Get-Content -Path $usernamesFile
$passwords = Get-Content -Path $passwordsFile | ConvertTo-SecureString

# Attempt login for each user with the corresponding password
foreach ($username in $usernames) {
    $index = $usernames.IndexOf($username)
    $password = $passwords[$index]
    $credential = New-Object -TypeName PSCredential -ArgumentList $username, $password

    # Attempt to authenticate each user
    try {
        $user = Get-AdUser -Filter {SamAccountName -eq $username} -Server $domainController -ErrorAction Stop
        $authenticated = $null -ne (Get-AdUser -Filter {SamAccountName -eq $username} -Server $domainController -Credential $credential -Properties DistinguishedName -ErrorAction Stop)

        if ($authenticated) {
            Write-Host "Authentication successful for user $($user.SamAccountName). Password confirmed."
        } else {
            Write-Host "Authentication failed for user $username. Please check your credentials."
        }
    }
    catch {
        Write-Host "Error: $_"
    }
}
