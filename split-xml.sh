#! /usr/bin/env bash

# $1 file

# Often, you want to split a huge XML file in a number of smaller ones
# to debug the Escenic Content Engine import.  This script will split
# the contents of the passed file into files with exactly one entry in
# each.
#
# The structure looks like this↓
# <item>
#   <articleid>...</articleid>
#   <articleid>...</articleid>
# </item>
first_level_element="$1"
second_level_element="$2"
input_file=$3
i=1

dir="$(basename $input_file .xml)-files"
mkdir -p $dir || {
  echo $(basename $0) "couldn't write to $(pwd)/$dir :-("
  exit 1
}

cat $input_file | \
    sed -n -e ":a" -e "$ s/\n//gp;N;b a" | \
    sed "s/<${second_level_element}>/\n<${second_level_element}>/g" | \

while read line; do 
    if [ $(echo $line | grep ^"<${second_level_element}>" | wc -l) -eq 0 ]; then
        continue
    fi

    file=$dir/${input_file}.${i}.xml

    cat > $file <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<${first_level_element}>
  $line
EOF
    if [ $(echo "$line" | grep "</${first_level_element}>" | wc -l) -eq 0 ]; then
        echo "</${first_level_element}>" >> $file
    fi

    i=$(( i + 1 ))
done

echo "$(basename $0): split files in $dir are ready"
