# Check-Files PowerShell Function

This repository contains a PowerShell function, Check-Files, designed to verify whether files exist in a specified folder with a creation date based on a configurable offset. The function integrates with a custom logging mechanism using the Write-Log function and reads its settings from an external configuration object.

# Overview

The Check-Files function checks a given folder for files whose creation date matches a target date. The target date is determined by a numeric offset provided via a configuration object:

0: Indicates today’s date.

Negative values (e.g., -1, -2): Indicate files created one day, two days, etc., ago.

All operational messages are logged using the custom Write-Log function.

# Prerequisites

PowerShell version 5.1 or later (or PowerShell Core if applicable).

The custom Write-Log function must be available in your session. Ensure it is defined or imported before using Check-Files.

# Files

Check-Files.ps1: Contains the Check-Files function.

config.json: Example configuration file to set folder path and date offset.

README.md: This documentation file.

# Configuration

Create or update your configuration file (e.g., config.json) to include the following settings:

    {
		"FolderPath": "C:\\Path\\To\\Your\\Folder",
	
		"DateToCheck": -2
	}
	
FolderPath: The path to the folder you want to scan.
DateToCheck: A numeric value indicating the offset from today (0 for today, -1 for yesterday, etc.).

# Usage
Load the Configuration:

In your PowerShell session or script, load your JSON configuration file into a variable:

$Config = Get-Content -Path "config.json" -Raw | ConvertFrom-Json
Import or Define the Write-Log Function:

Ensure your custom Write-Log function is available. For example, you might have it defined in a separate script that you dot-source:

. .\Write-Log.ps1

Call the Check-Files Function:

With the configuration loaded, call the function as shown:

Check-Files -Config $Config

The function will scan the specified folder for files with a creation date corresponding to the offset and log the results using Write-Log.

# Custom Logging with Write-Log

The Write-Log function logs messages with the following types:

SYS: System messages.

INF: Informational messages.

ERR: Errors.

WRN: Warnings.

It writes log entries to a log file (e.g., VantageFeedsLog.log) in the same directory as the script and optionally to the Windows Event Log. Ensure that the Write-Log function is correctly set up before running Check-Files.

Example Code
Below is a snippet that demonstrates how to load the configuration, import logging, and call the Check-Files function:

# Load the configuration
$Config = Get-Content -Path "config.json" -Raw | ConvertFrom-Json

# Ensure the Write-Log function is available
. .\Write-Log.ps1

# Call the Check-Files function
Check-Files -Config $Config