function Get-FilteredIPs {
    param (
        [string]$PageVisited,     # The page visited or referred from (e.g., index.html)
        [string]$HttpCode,        # HTTP code returned (e.g., 404)
        [string]$Browser          # Name of the web browser (e.g., Chrome, Firefox)
    )

    $ipList = @()  # Initialize an empty array to store IPs

    # Regular expression to match IP address
    $ipRegex = '\b(?:\d{1,3}\.){3}\d{1,3}\b'

    # Path variable
    $Path = 'C:\xampp\apache\logs\'

    # Iterate through log files and extract IPs based on the provided criteria
    Get-ChildItem $Path -Filter *.log | ForEach-Object {
        Select-String -Path $_.FullName -Pattern $HttpCode | ForEach-Object {
            # Check if the line contains the page and browser, and then extract the IP
            if ($_.Line -match $PageVisited -and $_.Line -match $Browser -and $_.Line -match $ipRegex) {
                $ipList += [PSCustomObject]@{ "IP Address" = $matches[0] }  # Store as custom object
            }
        }
    }
    return $ipList
}