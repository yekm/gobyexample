#!/bin/bash

cat >index.html << EOF
<!DOCTYPE html>
<meta charset="utf-8">
<script async src="https://www.googletagmanager.com/gtag/js?id=UA-143362407-2"></script>
<script>
  window.dataLayer = window.dataLayer || [];
  function gtag(){dataLayer.push(arguments);}
  gtag('js', new Date());

  gtag('config', 'UA-143362407-2');
</script>
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
