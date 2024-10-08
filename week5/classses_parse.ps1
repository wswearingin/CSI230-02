# Dot-source the gatherClasses.ps1 script to include the function
. $PSScriptRoot\parseClasses.ps1

# Call the gatherClasses function and store the result
$classes = gatherClasses

# Format Dates
$classes = daysTranslator $classes

# Print the returned table
# $classes | Format-Table -AutoSize

# List Classes of the instructor Furkan Paligu
# $classes | Where-Object {$_.Professor -eq "Furkan Paligu"} | Format-Table -Autosize

# List all the classes of JOYC 310 on Mondays, only display Class Code and Times. Sort by Start Time
# $classes | Where-Object {
    # $_.Location -eq "JOYC 310" -and $_.Days -contains "Monday"
# } | Sort-Object StartTime | Select-Object "Class Code", "StartTime", "EndTime" | Format-Table -AutoSize

# ITS Professors
$ITSInstructors = $classes | Where-Object { 
    ($_.“Class Code” -like "SYS*") -or
    ($_.“Class Code” -like "NET*") -or
    ($_.“Class Code” -like "SEC*") -or
    ($_.“Class Code” -like "FOR*") -or
    ($_.“Class Code” -like "CSI*") -or
    ($_.“Class Code” -like "DAT*")
}

# Group the classes by Professor and count the number of classes they teach
$instructorCounts = $ITSInstructors | Group-Object -Property Professor | Select-Object Name, Count

# Sort the instructors by the number of classes they are teaching, in descending order
$sortedInstructors = $instructorCounts | Sort-Object -Property Count -Descending

# Display the list of instructors with the number of classes they teach
$sortedInstructors | Format-Table -AutoSize