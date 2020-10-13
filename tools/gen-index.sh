#!/bin/bash

cat >index.html << EOF
<!DOCTYPE html>
<meta charset="utf-8">
<!-- Yandex.Metrika counter -->
<script type="text/javascript" >
   (function(m,e,t,r,i,k,a){m[i]=m[i]||function(){(m[i].a=m[i].a||[]).push(arguments)};
   m[i].l=1*new Date();k=e.createElement(t),a=e.getElementsByTagName(t)[0],k.async=1,k.src=r,a.parentNode.insertBefore(k,a)})
   (window, document, "script", "https://mc.yandex.ru/metrika/tag.js", "ym");

   ym(68262424, "init", {
        clickmap:true,
        trackLinks:true,
        accurateTrackBounce:true
   });
</script>
<noscript><div><img src="https://mc.yandex.ru/watch/68262424" style="position:absolute; left:-9999px;" alt="" /></div></noscript>
<!-- /Yandex.Metrika counter -->
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
