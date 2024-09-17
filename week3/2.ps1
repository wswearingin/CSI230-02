Function Get-LoginLogoutEvents {
    Param(
        [Parameter(Mandatory = $true)]
        [int]$Days
    )

    # Initialize an empty array to store custom event objects
    $loginoutsTable = @()

    # Define the event IDs for logon and logoff events
    $eventIDs = @(4624, 4634)

    # Get the logon and logoff events from the Security log for the specified number of days
    $events = Get-WinEvent -FilterHashtable @{
        LogName = 'Security';
        Id      = $eventIDs;
        StartTime = (Get-Date).AddDays(-$Days)
    }

    # Loop over each event and process it
    foreach ($event in $events) {
        # Access the event properties
        $eventData = [xml]$event.ToXml()

        # Determine the event type based on ID
        $eventType = switch ($event.Id) {
            4624 { "Logon" }
            4634 { "Logoff" }
        }

        # Extract the User from event data
        $userName = switch ($event.Id) {
            4624 { $eventData.Event.EventData.Data | Where-Object { $_.Name -eq 'TargetUserName' } | Select-Object -ExpandProperty '#text' }
            4634 { $eventData.Event.EventData.Data | Where-Object { $_.Name -eq 'TargetUserName' } | Select-Object -ExpandProperty '#text' }
        }

        # Create a new custom object with the specified properties
        $customEvent = [PSCustomObject]@{
            Time  = $event.TimeCreated
            Id    = $event.Id
            Event = $eventType
            User  = $userName
        }

        # Add the custom object to the array
        $loginoutsTable += $customEvent
    }

    # Return the table of results
    return $loginoutsTable
}

# Call the function with the parameter (e.g., 14 days) and print the results
$results = Get-LoginLogoutEvents -Days 14
$results

Function Get-StartupShutdownEvents {
    Param(
        [Parameter(Mandatory = $true)]
        [int]$Days
    )

    # Initialize an empty array to store custom event objects
    $startupShutdownTable = @()

    # Define the event IDs for startup and shutdown events
    $eventIDs = @(6005, 6006)

    # Get the startup and shutdown events from the System log for the specified number of days
    $events = Get-WinEvent -FilterHashtable @{
        LogName = 'System';
        Id      = $eventIDs;
        StartTime = (Get-Date).AddDays(-$Days)
    }

    # Loop over each event and process it
    foreach ($event in $events) {
        # Access the event properties
        $eventData = [xml]$event.ToXml()

        # Determine the event type based on ID
        $eventType = switch ($event.Id) {
            6005 { "Startup" }
            6006 { "Shutdown" }
        }

        # Username will always be System
        $userName = "System"

        # Create a new custom object with the specified properties
        $customEvent = [PSCustomObject]@{
            Time  = $event.TimeCreated
            Id    = $event.Id
            Event = $eventType
            User  = $userName
        }

        # Add the custom object to the array
        $startupShutdownTable += $customEvent
    }

    # Return the table of results
    return $startupShutdownTable
}

# Call the function with the parameter (e.g., 14 days) and print the results
$results2 = Get-StartupShutdownEvents -Days 14
$results2
