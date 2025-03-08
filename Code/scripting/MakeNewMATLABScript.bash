#!/bin/bash

#============================================= FILE HEADER =============================================
# Title: MakeNewMATLABScript
# File Type: Bash Script (.bash)
# Author: Zakary Steenhoek
#
# Created: Zakary Steenhoek - March 2025
# Updated: Zakary Steenhoek - March 2025
#
# Purpose: This is a script to create a new matlab file in the MATLAB directory or specified directory 
# 		   with the general script template seen here.
#
# In: TARGET_PATH - Optional parameter to specify location in which to create file. Defaults to 
# 					user MATLAB software bin
#	  fileName - Name of the file to create, read in from user
#
# Out: A new matlab .m file in the specified or default location with the user entered name, a general
# 	   header and an option to open and edit in Notepad++, or if the file already exists, provide 
# 	   options to cat/view the file, override the file, or choose a different name. 
#=======================================================================================================

# **BEGIN**

# Global defines 
{
	# TARGET_PATH: creation location
	TARGET_PATH=$1
}

# Function define: makeHeader()
makeHeader() 
{
	# Local Defines
	{
	local AUTHOR="Zakary Steenhoek"
	local FILE_TYPE="MATLAB Code (.m)"
	local SECTION_BLANK_SPACE=5
	local day=$(date '+%d')
	local month=$(date '+%B')
	local year=$(date '+%Y')
	}
	
	# Header
	printf "%%%% Header\n" >> $fileName
	printf "%% Author: %s %s\n" $AUTHOR >> $fileName
	printf "%% Date: ${day} ${month} ${year}\n" >> $fileName
	printf "%% Title: ${shortFileName}\n\n" >> $fileName
	printf "%% Reset: \n" >> $fileName
	printf "clear; clc;\n\n" >> $fileName
	
	# Setup
	printf "%%%% Setup\n\n" >> $fileName
	printf "%% Variables\n" >> $fileName
	printf "syms \n\n" >> $fileName
	printf "%% Equations\n\n" >> $fileName
	printf "%% Functions\n\n" >> $fileName
	printf "\n" >> $fileName
	printf "%%%% Math\n\n%%\n\n" >> $fileName
	printf "%%%% Plots\n\n%%\n\n" >> $fileName
	
}

# Function define: main()
main() 
{	
	# Get user input for filename
	printf "\nEnter filename to create: "
	read shortFileName
	fileName="${shortFileName}.m"
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
