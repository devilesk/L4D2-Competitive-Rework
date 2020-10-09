#!/bin/bash

# edits to stripper cfgs and mapinfo.txt files
FILES=$(find cfg/stripper -type f -name '*.cfg' & find . -type f -name 'mapinfo.txt')
for a in $FILES
do
    # remove leading html
    sed -e's/^<.*>//' $a >$a-nohtml
    mv $a-nohtml $a
    # remove trailing whitespace
    sed -e's/[[:space:]]*$//' $a >$a-notrailing
    mv $a-notrailing $a
    # convert all tabs to spaces
    expand -t 4 $a >$a-tab
    mv $a-tab $a
    # convert leading 4 spaces to tabs
    unexpand -t 4 --first-only $a >$a-notab
    mv $a-notab $a
    # convert leading 3 spaces to tabs
    unexpand -t 3 --first-only $a >$a-notab
    mv $a-notab $a
    # remove any lingering spaces that follow a tab
    sed -e's/\t /\t/' $a >$a-notabspace
    mv $a-notabspace $a
    # replace double newlines with a single newline
    awk -v RS= -v ORS='\n\n' '1' $a >$a-singlenewline
    mv $a-singlenewline $a
    # remove leading and trailing newlines
    sed -e :a -e '/./,$!d;/^\n*$/{$d;N;};/\n$/ba' $a >$a-nonewline
    mv $a-nonewline $a
    # add back a newline to the end of the file
    sed -e '$a\' $a >$a-appendnewline
    mv $a-appendnewline $a
done

# edits to stripper cfgs only
FILES=$(find cfg/stripper -type f -name '*.cfg')
for a in $FILES
do
    # replace all whitespace between key values with a single space
    sed -e's/"[\t| ]\{1,\}"/" "/' $a >$a-singlespace
    mv $a-singlespace $a
done

# checks
grep -rnw cfg/stripper -e '.*"[\t| ]\{2,\}".*'
grep -rnw cfg/stripper -e $'[\t] .*'
grep -rnw cfg/stripper -e '^[^;] '
