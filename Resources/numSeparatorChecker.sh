#!/bin/sh

###########################
# File name: numSeparatorChecker.sh
# Author: Mathilde Benedetto, sept 2023
###########################
# Purpose: This script can check which line number has more than X separators and will print out the lines in cause. If everything is fine, there's no output.
###########################
# ARGUMENTS received, set to parameters:
# 1st argument of the command line: the separator we want in our file
separator=$1
# 2nd argument of the command line: the number of fields we normally have in our file
numFields=$2
# 3rd argument of the command line: the name of the file we want to analyse
fileName=$3

###########################
# ACTIONS:
awk -F "$separator" "NF!=$numFields {print NR}" ${fileName}

# awk -F ';' 'NF != 46 {print NR}' nameofmyfile.extension
# -> In this command line, we have 46 FIELDS (45 separators expected) -> 'NF !=46 ... 
# Oracle doc: "The  variable  NF  is  set  to  the total number of fields in the input record."
# So we pass 46 and also the type of separator (here a semicolon ";") -> -F ';'
# Oracle doc: -F fs-> field-separator input, for ex ';', or '|' or ',' etc, expected after -F
# The command line will print the line number(s) where it finds a number of separators different from 45 separators

###########################
<<comment
How to use this script in command line:
Example:
$ sh sh numSeparatorChecker.sh '|' 4 mydatafile.txt
$ sh sh numSeparatorChecker.sh "|" 4 mydatafile.txt
comment
