$folderPath = "$PSScriptRoot\outfolder"
if (-not (Test-Path -Path $folderPath)) {
    New-Item -Path $folderPath -ItemType Directory
    Write-Host "Folder 'outfolder' created."
} else {
    Write-Host "Folder 'outfolder' already exists."
}
