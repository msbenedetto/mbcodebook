#!/bin/sh

# File name: filesplitter.sh
# Author: Mathilde Benedetto, sept 2023

###########################
# ARGUMENTS received, set to parameters:
# 1st argument of the command line: the file name to split
fileToSplit=$1
# 2nd argument of the command line: the number of line you want in each splitted file
numLines=$2
# 3rd argument of the command line: the extension you want on each splitted file, for example .txt or .csv
extension=$3
# 4th argument of the command line: the name you want before extension on each splitted file /!\ DIFFERENT from original file to split
fileName=$4

###########################
# ACTIONS:

# FILE BACK UP
# For safety, we can do a back-up of the file, comment or uncomment if needed:
# cp $fileToSplit $fileToSplit'.bk'

# 1: Keep the header of the file in a parameter:
header=$(head -1 $fileToSplit)

# 2: Delete the header:
sed -i '1d' $fileToSplit 

# 3: Split the data into X lines per file:
split -dl $numLines --additional-suffix=$extension $fileToSplit $fileName

# 4: Append the header back into each file from split:
for part in `ls -1 $fileName*`
do
  printf "%s\n%s" "$header" "`cat $part`" > $part
done

# 5: Append the header back into the original file:
printf "%s\n%s" "$header" "`cat $fileToSplit`" > $fileToSplit

###########################
<<comment
How to use this script in command line:
Example:
$ sh filesplitter.sh myfilename.txt 1000 .txt newFileName
comment
