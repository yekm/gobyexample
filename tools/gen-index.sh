#!/bin/bash

cat >index.html << EOF
<!DOCTYPE html>
<meta charset="utf-8">
<body>
EOF

i=0
for f in $@; do
    echo "preocessing $f"
    bn=$(basename $f)
    echo "<a href=e/$bn>$i $f</a><br>" >>index.html
    let 'i += 1'
done

echo '</body>' >>index.html
