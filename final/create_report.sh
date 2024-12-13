#!/bin/bash

report_file="$1"
output_dir="/var/www/html"
output_file="$output_dir/report.html"

cat <<EOF > "$output_file"
<html>
<head>
<title>Access logs with IOC indicators</title>
</head>
<body>
<h1>Access logs with IOC indicators:</h1>
<table border="1" cellpadding="5" cellspacing="0">
<tr><th>IP</th><th>Date/Time</th><th>Page</th></tr>
EOF

while read -r ip dt page; do
    echo "<tr><td>$ip</td><td>$dt</td><td>$page</td></tr>" >> "$output_file"
done < "$report_file"

cat <<EOF >> "$output_file"
</table>
</body>
</html>
EOF
