# Import the Active Directory module
Import-Module ActiveDirectory

# Specify the directory path for the output file
$outputDirectory = "C:\Path\To"
$outputFilePath = Join-Path $outputDirectory "Output.txt"

# Check if the directory exists, create it if not
if (-not (Test-Path -Path $outputDirectory -PathType Container)) {
    New-Item -Path $outputDirectory -ItemType Directory -Force
}

# Get all users
$users = Get-ADUser -Filter *

# Create or overwrite the output file
foreach ($user in $users) {
    # Get the domain password policy
    $domainPolicy = Get-ADDefaultDomainPasswordPolicy

    # Build the output string
    $output = @"
User: $($user.SamAccountName)
  Lockout Threshold: $($domainPolicy.LockoutThreshold)
  Lockout Observation Window: $($domainPolicy.LockoutObservationWindow.TotalMinutes) minutes
  Lockout Duration: $($domainPolicy.LockoutDuration.TotalMinutes) minutes
---
"@

    # Append the output to the file
    $output | Out-File -FilePath $outputFilePath -Append
}

Write-Host "Output has been written to: $outputFilePath"
