#!/bin/bash
#renamepics3.sh - script to change name on all image files to the form YYYY.MM.DD-HH.MM.SS.*
#using exiftool

# convert jpgs

exiftool -v -d "%Y%m%d-%H%M%S%%-c.%%le" "-filename<CreateDate" *.jpg *.JPG
exiftool -d "%Y.%m" "-directory<datetimeoriginal" *.jpg

# convert raw

exiftool -v -d "%Y%m%d-%H%M%S%%-c.%%le" "-filename<CreateDate" *.CR2
exiftool -d "%Y.%m/RAW" "-directory<datetimeoriginal" *.cr2

# convert MOV

exiftool -v -d "%Y%m%d-%H%M%S%%-c.%%le" "-filename<CreateDate" *.MOV
exiftool -d "canon_70d/%Y.%m" "-directory<datetimeoriginal" *.mov

