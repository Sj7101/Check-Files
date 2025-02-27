function Check-Files {
    [CmdletBinding()]
    param(
        # Configuration object containing at least FolderPath and optionally DateToCheck as a numeric offset.
        [Parameter(Mandatory = $true)]
        [PSCustomObject]$Config
    )

    # Validate that FolderPath is provided
    if (-not $Config.FolderPath) {
        Write-Log -Type ERR -Message "FolderPath is not specified in the configuration."
        return $false
    }
    $folder = $Config.FolderPath

    # Verify that the folder exists
    if (-not (Test-Path $folder)) {
        Write-Log -Type ERR -Message "Folder '$folder' does not exist."
        return $false
    }

    # Determine the date to check.
    # DateToCheck is interpreted as a numeric offset: 0 for today, -1 for yesterday, etc.
    if ($null -ne $Config.DateToCheck) {
        try {
            $offset = [int]$Config.DateToCheck
        }
        catch {
            Write-Log -Type ERR -Message "Invalid DateToCheck value. Provide a numeric value (e.g., 0 for today, -2 for two days ago)."
            return $false
        }
    }
    else {
        $offset = 0
    }

    $dateToCheck = (Get-Date).AddDays($offset).Date

    # Retrieve files in the specified folder.
    $files = Get-ChildItem -Path $folder -File

    # Filter files with a creation date matching the desired date.
    $matchingFiles = $files | Where-Object { $_.CreationTime.Date -eq $dateToCheck }

    if ($matchingFiles) {
        Write-Log -Type INF -Message "Found $($matchingFiles.Count) file(s) in '$folder' with creation date $dateToCheck."
        foreach ($file in $matchingFiles) {
            Write-Log -Type INF -Message "File: $($file.FullName)"
        }
        return $true
    }
    else {
        Write-Log -Type WRN -Message "No files found in '$folder' with creation date $dateToCheck."
        return $false
    }
}

# Example usage:
# Assume your configuration has already been loaded from config.json into a variable named $Config.
# Check-Files -Config $Config
