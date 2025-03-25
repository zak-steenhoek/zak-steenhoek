#!/bin/bash
source ~/.bashrc

#============================================= FILE HEADER =============================================
# Title: MakeNewFile
# File Type: Shell Script (.sh)
# Author: Zakary Steenhoek
#
# Created: March 2025
# Updated: March 2025
#
# Purpose: 
#
# In: 
#
# Out: 
#
#
#=======================================================================================================

# **BEGIN**

# Global defines
TEMPLATE_PATH="$HOME/etc"
AUTHOR="Zakary Steenhoek"
DATE=$(date '+%d %B %Y')
day=$(date '+%d')
month=$(date '+%B')
year=$(date '+%Y')

# Function: Generalized Template Copier
create_file_from_template() {
    local template_file="$1"
    local new_filename="$2"
    local target_path="$3"
	local file_extension="$4"

    local newfile="${target_path}/${new_filename}"

    if [[ -e "$newfile" ]]; then
        echo "File '$newfile' already exists."
        return 1
    fi

    cp "${TEMPLATE_PATH}/${template_file}" "$newfile"

    sed -i "s/{{AUTHOR}}/${AUTHOR}/g" "$newfile"
    sed -i "s/{{DATE}}/${DATE}/g" "$newfile"
    sed -i "s/{{FILENAME}}/${new_filename%.*}/g" "$newfile"
    sed -i "s/{{FILENAME^^}}/$(echo ${new_filename%.*} | tr '[:lower:]' '[:upper:]')/g" "$newfile"
	sed -i "s/{{TYPE}}/${file_extension}/g" "$newfile"

    echo "Created file: $newfile"
}

# Main Script Logic
case "$1" in
    matscript)
        create_file_from_template "MatlabScriptTemplate.txt" "$2.m" "${3:-$(pwd)}" "m"
        ;;
    matfunc)
        create_file_from_template "MatlabFunctionTemplate.txt" "$2.m" "${3:-$(pwd)}" "m"
        ;;
    text)
        create_file_from_template "TextTemplate.txt" "$2.txt" "${3:-$(pwd)}" "txt"
        ;;
    shell)
        create_file_from_template "ShellTemplate.txt" "$2.sh" "${3:-$(pwd)}" "sh"
        chmod +x "${3:-$(pwd)}/$2.sh"
        ;;
	custom)
        if [[ -z "$4" ]]; then
            echo "Usage: $0 custom <filename_without_extension> [target_path] <extension>"
            exit 1
        fi
        create_file_from_template "GeneralTemplate.txt" "$2.$4" "${3:-$(pwd)}" "$4"
        ;;
    *)
        echo "Usage: $0 {matscript|matfunc|text|shell|custom} <filename_without_extension> [target_path]"
        exit 1
        ;;
esac


# **END**
