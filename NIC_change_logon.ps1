# Auto-elevate if not running as Administrator
If (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)) {
    Start-Process powershell.exe -ExecutionPolicy Bypass -File $PSCommandPath -Verb RunAs
    Exit
}

# Define log path
$logPath = "C:\ProgramData\NICSwitchLog.txt"
"--- NIC Switch Script Run $(Get-Date) ---" | Out-File -Append $logPath

# Function to get the logged-in user
function Get-LoggedInUser {
    try {
        $session = qwinsta | Where-Object { $_ -match "Active" } | ForEach-Object {
            $fields = $_.Trim() -split "\s+"
            if ($fields[1] -notmatch "^(rdp|console)$") { $fields[1] }
        }
        if ($session) {
            return $session.ToLower()
        } else {
            "No active user session found" | Out-File -Append $logPath
            return $null
        }
    } catch {
        "Error detecting logged-in user: $_" | Out-File -Append $logPath
        return $null
    }
}

# Get current user
$currentUser = Get-LoggedInUser
"Logged in user: $currentUser" | Out-File -Append $logPath

# Define NIC names (Ensure exact match with your system)
$nicC = "Network-C"
$nicR = "Network-R"

# Function to enable or disable NIC safely with status check
function Set-NIC {
    param (
        [string]$nicName,
        [bool]$enable
    )
    try {
        $adapter = Get-NetAdapter -Name $nicName -ErrorAction Stop
        $desiredState = if ($enable) { 'Up' } else { 'Disabled' }

        if (($enable -and $adapter.Status -ne 'Up') -or (-not $enable -and $adapter.Status -ne 'Disabled')) {
            if ($enable) {
                Enable-NetAdapter -Name $nicName -Confirm:$false -ErrorAction Stop
            } else {
                Disable-NetAdapter -Name $nicName -Confirm:$false -ErrorAction Stop
            }
            "$nicName set to $desiredState" | Out-File -Append $logPath
        } else {
            "$nicName already $desiredState" | Out-File -Append $logPath
        }
    } catch {
        "Error with ${nicName}: $_" | Out-File -Append $logPath
    }
}

# Pre-check function to verify if correct NIC is already active
function Test-CorrectNIC {
    param (
        [string]$user
    )
    try {
        $adapterC = Get-NetAdapter -Name $nicC -ErrorAction Stop
        $adapterR = Get-NetAdapter -Name $nicR -ErrorAction Stop

        switch ($user) {
            "aperez-c" {
                if ($adapterC.Status -eq 'Up' -and $adapterR.Status -eq 'Disabled') {
                    "User $user is already on correct network ($nicC enabled, $nicR disabled). No action needed." | Out-File -Append $logPath
                    return $true
                }
            }
            "aperez-r" {
                if ($adapterR.Status -eq 'Up' -and $adapterC.Status -eq 'Disabled') {
                    "User $user is already on correct network ($nicR enabled, $nicC disabled). No action needed." | Out-File -Append $logPath
                    return $true
                }
            }
            default {
                "Unknown user or no user detected. No pre-check performed." | Out-File -Append $logPath
                return $false
            }
        }
        return $false
    } catch {
        "Error in pre-check: $_" | Out-File -Append $logPath
        return $false
    }
}

# Exit if no user is detected
if (-not $currentUser) {
    "No valid user detected. Exiting." | Out-File -Append $logPath
    "--- End ---`n" | Out-File -Append $logPath
    Exit
}

# Run pre-check and skip if already on correct network
if (Test-CorrectNIC -user $currentUser) {
    "--- End (No changes made) ---`n" | Out-File -Append $logPath
    Exit
}

# SAFETY: Enable the required NIC first → wait → Disable the other NIC
switch ($currentUser) {
    "aperez-c" {
        Set-NIC -nicName $nicC -enable $true
        Start-Sleep -Seconds 5
        Set-NIC -nicName $nicR -enable $false
    }
    "aperez-r" {
        Set-NIC -nicName $nicR -enable $true
        Start-Sleep -Seconds 5
        Set-NIC -nicName $nicC -enable $false
    }
    default {
        "Unknown user. No action taken." | Out-File -Append $logPath
    }
}

"--- End ---`n" | Out-File -Append $logPath