function gatherClasses() {
    $page = Invoke-WebRequest -TimeoutSec 2 http://127.0.0.1/courses.html

    # Get all the tr elements of HTML document
    $trs = $page.ParsedHtml.body.getElementsByTagName("tr")

    # Empty array to hold results
    $FullTable = @()
    
    for ($i = 1; $i -lt $trs.length; $i++) { # Going over every tr element
        # Get every td element of current tr element
        $tds = $trs[$i].getElementsByTagName("td")
        
        # Want to separate start time and end time from one time field
        $Times = $tds[5].innerText.Split("-")

        $FullTable += [PSCustomObject]@{
            "Class Code" = $tds[0].innerText;
            "Title"      = $tds[1].innerText;
            "Credits"    = $tds[2].innerText;
            "Capacity"   = $tds[3].innerText;
            "Days"       = $tds[4].innerText;
            "StartTime"  = $Times[0];
            "EndTime"    = $Times[1];
            "Professor"  = $tds[6].innerText;
            "Dates"      = $tds[7].innerText;
            "Prereq"     = $tds[8].innerText;
            "Location"   = $tds[9].innerText
        }
    }
    return $FullTable
}

function daysTranslator($table) {
    # Mapping of day abbreviations to full day names, excluding Saturday and Sunday
    $dayAbbreviations = @{
        "M"  = "Monday"
        "T"  = "Tuesday"
        "W"  = "Wednesday"
        "TH" = "Thursday"
        "F"  = "Friday"
    }

    # Regex pattern to match the abbreviations
    $pattern = 'TH|M|T|W|F'

    # Iterate over each class object in the table
    foreach ($class in $table) {
        $daysString = $class.Days

        # Find all matches of day abbreviations in the Days string
        $matches = [regex]::Matches($daysString, $pattern)
        $abbreviations = $matches | ForEach-Object { $_.Value }

        # Map each abbreviation to the full day name
        $fullDays = $abbreviations | ForEach-Object { $dayAbbreviations[$_] }

        # Replace the Days property with the array of full day names
        $class.Days = $fullDays
    }

    # Return the updated table
    return $table
}