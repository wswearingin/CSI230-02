# Find all .csv files and rename them to .log
Get-ChildItem -Path . -Filter *.csv -Recurse | ForEach-Object {
    $newName = $_.FullName -replace '\.csv$', '.log'
    Rename-Item -Path $_.FullName -NewName $newName
}

# Recursively display all files after renaming
Get-ChildItem -Path . -Recurse
