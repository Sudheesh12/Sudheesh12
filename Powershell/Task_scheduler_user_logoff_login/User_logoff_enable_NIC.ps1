# the below script enables the NIC's and logs the data in "C:\ProgramData\UserLogoff_Error.log"
#
#
# --- Log the user who is logging off ---
try {
    $user = $env:USERNAME
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logEntry = "$timestamp - $user logged off"
    $logFile = "C:\ProgramData\UserLogoff.log"
    Add-Content -Path $logFile -Value $logEntry
} catch {
    Add-Content -Path "C:\ProgramData\UserLogoff_Error.log" -Value ("$timestamp - Error: " + $_.Exception.Message)
}

# --- Check and enable all network adapters (NICs), log actions ---
try {
    $allNics = Get-NetAdapter
    $alreadyUp = @()
    $enabledNow = @()

    foreach ($nic in $allNics) {
        if ($nic.Status -eq 'Up') {
            $alreadyUp += $nic.Name
        } else {
            Enable-NetAdapter -Name $nic.Name -Confirm:$false
            $enabledNow += $nic.Name
        }
    }

    $nicLog = "$timestamp - NIC Status:"
    if ($alreadyUp.Count -gt 0) {
        $nicLog += "`n    Already enabled: " + ($alreadyUp -join ', ')
    }
    if ($enabledNow.Count -gt 0) {
        $nicLog += "`n    Enabled now: " + ($enabledNow -join ', ')
    }
    if (($alreadyUp.Count + $enabledNow.Count) -eq 0) {
        $nicLog += "`n    No network adapters found."
    }
    # Add partition line after each log entry
    $nicLog += "`n------------------------------------------------------------"
    Add-Content -Path $logFile -Value $nicLog
} catch {
    Add-Content -Path "C:\ProgramData\UserLogoff_Error.log" -Value ("$timestamp - NIC Enable Error: " + $_.Exception.Message)
}
