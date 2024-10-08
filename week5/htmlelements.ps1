$scraped_page = Invoke-WebRequest -TimeoutSec 10 http://127.0.0.1/ToBeScraped.html

$divs = $scraped_page.ParsedHtml.getElementsByTagName("div") | Where-Object { $_.className -eq "div-1" }

foreach ($div in $divs) {
    Write-Output $div.innerText}