#!/bin/bash

#============================================= FILE HEADER =============================================
# Title: MakeNewText
# File Type: Bash Script (.bash)
# Author: Zakary Steenhoek
#
# Created: July 2024
# Updated: March 2025 
#
# Purpose: This is a script to create a new text file in the current or specified directory with
# 		   the general template seen here.
#
# In: TARGET_PATH - Optional parameter to specify location in which to create file. Defaults to 
# 					current wd if no parameter is provided
#	  fileName - Name of the file to create, read in from user
# 	  
# Out: A new text file in the specified or current location with the user entered name, a general
# 	   header and an option to open and edit in Notepad++, or if the file already exists, provide 
# 	   options to cat/view the file, override the file, or choose a different name. 
#=======================================================================================================

# **BEGIN**

# Global defines 
{
	# TARGET_PATH: Check if a parameter is provided, else use the current directory
	TARGET_PATH=${1:-$(pwd)}
}

# Function define: makeHeader()
makeHeader() 
{
	# Local Defines
	{
	local AUTHOR="Zakary Steenhoek"
	local FILE_TYPE="Plaintext File (.txt)"
	local MAX_TOP_HEAD=45
	local MAX_BOTTOM_HEAD=103
	local BLANK_SPACE=5
	local day=$(date '+%d')
	local month=$(date '+%B')
	local year=$(date '+%Y')
	}
	
	# Top header line
	printf "#" >> $fileName
	for ((i=0; i<$MAX_TOP_HEAD; i++)); do
		printf "=" >> $fileName
	done
	printf " FILE HEADER " >> $fileName
	for ((i=0; i<$MAX_TOP_HEAD; i++)); do
		printf "=" >> $fileName
	done; printf "\n" >> $fileName
	
	# Info field population
	printf "# Title: %s\n" $shortFileName >> $fileName
	printf "# File Type: %s %s %s\n" $FILE_TYPE >> $fileName
	printf "# Author: %s %s\n" $AUTHOR >> $fileName
	printf "#\n" >> $fileName
	printf "# Created: %s %s - ${month} ${year}\n" $AUTHOR >> $fileName
	printf "# Updated: %s %s - ${month} ${year}\n" $AUTHOR >> $fileName
	printf "#\n" >> $fileName
	printf "# Purpose: \n" >> $fileName
	printf "#\n" >> $fileName
	
	# Bottom header line
	printf "#" >> $fileName
	for ((i=0; i<$MAX_BOTTOM_HEAD; i++)); do
		printf "=" >> $fileName
	done; printf "\n\n" >> $fileName
}

# Function define: main()
main() 
{	
	# Get user input for filename
	printf "\nEnter filename to create: "
	read shortFileName
	fileName="${shortFileName}.txt"
	printf "\n"
	
	# cd into target path for file creation
	cd $TARGET_PATH
	
	# Do-while not done
	done=false
	while ! $done; do
		# If file already exists
		if [[ -e $fileName ]]; then
		
			# Get user input on view file
			printf "File exists in directory. Would you like to view this file? [y/n]: "
			read viewFile
			printf "\n"
			
			# do-while
			while true; do
				if [ $viewFile == 'y' ] || [ $viewFile == 'Y' ]; then
					cat $fileName
					printf "\n\n"
					break
				elif [ $viewFile == 'n' ] || [ $viewFile == 'N' ]; then
					break
				else
					printf "Invalid option. [y/n]: "
					read viewFile
				fi
			done
			
			# Get user input on overwrite
			printf "Would you like to overwrite this file?\n"
			printf "WARNING: This action cannot be undone. [y/n]: "
			read doOverwrite
			printf "\n\n"
			
			# Do-while
			while true; do
				if [ $doOverwrite == 'y' ] || [ $doOverwrite == 'Y' ]; then
					printf "Overwriting file %s...\n\n" $fileName
					makeHeader
					cat $fileName
					done=true
					break
				elif [ $doOverwrite == 'n' ] || [ $doOverwrite == 'N' ]; then
					printf "Please choose a different file name: "
					read shortFileName
					fileName="${shortFileName}.bash"
					printf "\n\n"
					break
				else
					printf "Invalid option. [y/n]: "
					read doOverwrite
				fi
			done
		
		# Else create file with general header
		else
			printf "Creating file %s in %s...\n\n" $fileName $TARGET_PATH
			makeHeader
			cat $fileName
			break
		fi
	done
	
	# Get user input on edit
	printf "\n\n"
	printf "Would you like to start editing this file? [y/n]: "
	read doEdit
	printf "\n\n"
	
	if [ $doEdit == y ] || [ $doEdit == Y ]; then
		/cygdrive/c/Program\ Files/Notepad++/notepad++.exe $fileName
	fi
}

# Execute
main

# **END**
