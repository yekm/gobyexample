#!/bin/bash

infile=$1
tmp=$2

#mkdir -p $tmp
touch $tmp/0000.output # for first diff invocation
t=$(mktemp -p $tmp).go # main shrink file
ti=$t.imp.go           # shrinked file with fixed imports

fromline=$(grep -n 'func main' $infile | head -n1 | cut -f1 -d:)
toline=$(wc -l $infile | cut -f1 -d' ')
for i in $(seq $fromline $toline); do
    head -n $i $infile >$t
    echo '}' >>$t
    $(go env GOPATH)/bin/goimports $t >$ti
    ec=$?
    io=$tmp/$i.output # stdout of $i's shrink
    ie=$tmp/$i.err
    timeout -k 2s 10s go run $ti 2>$ie >$io
    if [ ! $? -eq 0 ]; then
        cat $ie | \
            grep 'declared and not used' | \
            cut -f4 -d' ' | \
            while read var; do
                # find unused variable and replace with _
                line=$(grep -n $var $ti | head -n1 | cut -f1 -d:)
                sed -i "${line}s?$var?_?" $ti
            done
        timeout -k 2s 10s go run $ti 2>/dev/null >$io
    fi
    
    [ ! -s $io ] && rm $io && continue # do not need empty file
    # use onlu newly added strings
    diff $(ls -1c $tmp/*.output | tac | tail -n2) 2>/dev/null | grep '^> ' | cut -c3- >$io.d
    [ ! -s $io.d ] && rm $io.d # do not need empty file
    [ ! -s $ie ] && rm $ie # useless anyway
done

true
