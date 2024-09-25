function ParseLogs {
    param (
        [string]$Path  # The folder containing Apache log files
    )

    $parsedLogs = @()  # Initialize an empty array to store parsed log objects

    # Regular expression to match IP address
    $ipRegex = '\b(?:\d{1,3}\.){3}\d{1,3}\b'

    # Read each line of the log file
    Get-Content $Path | ForEach-Object {
        $logLine = $_

        # Split the log line by spaces
        $logWords = $logLine -split ' '

        # Check if we have enough elements in the log line (to avoid errors)
        if ($logWords.Length -ge 10 -and $logWords[0] -match $ipRegex) {
            # Create a custom object from the log
            $logObject = [PSCustomObject]@{
                "IP"            = $logWords[0]
                "Identity"      = $logWords[1]
                "User"          = $logWords[2]
                "Timestamp"     = $logWords[3] + " " + $logWords[4]  # Timestamp is often split across two indices
                "RequestMethod" = ($logWords[5] -replace '"', '')  # Remove double quotes
                "URL"           = $logWords[6]
                "Protocol"      = ($logWords[7] -replace '"', '')  # Remove double quotes
                "HTTPStatus"    = $logWords[8]
                "BytesSent"     = $logWords[9]
                "Referrer"      = ($logWords[10] -replace '"', '')  # Remove double quotes
                "UserAgent"     = [string]::Join(' ', $logWords[11..($logWords.Length-1)])  # Join remaining parts for UserAgent
            }

            # Filter for IPs in the 10.* network
            if ($logObject.IP -like "10.*") {
                $parsedLogs += $logObject  # Add to the array if IP matches the 10.* network
            }
          }
        
      }

    return $parsedLogs  # Return the array of parsed log objects
}