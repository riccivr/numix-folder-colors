#!/bin/bash

#/ Author: Ricardo Veronese Ricci <ricci.vr@gmail.com>
#/ Usage: numix-folder-color.sh
#/ Usage: list available colors: numix-folder-color.sh -c
#/ changes all the folders icons color to the one you set, current development for the numix icons only
#/
#/ the script requires super user priviledges
#/
#/ Copyright (C) 2015
#/ This program is free software: you can redistribute it and/or modify
#/ it under the terms of the GNU General Public License (version 3+) as
#/ published by the Free Software Foundation. You should have received
#/ a copy of the GNU General Public License along with this program.
#/ If not, see <http://www.gnu.org/licenses/>.

# allows timeout when launched via 'Run in Terminal'
function sucess() { sleep 3; exit 0; }
function gerror() { sleep 3; exit 1; }

# displays a message depending on the arg given
if [ -z "$1" ]; then
    :
else
    case "$1" in
        -s|--styles)
            echo -e \
                "This is a list of currently supported folder\n" \
                "\rstyles that can be used to replace the default.\n\n" \
                "\r0 - default folder theme (uninstall)\n" \
                "\r1 - the original folder design\n" \
                "\r2 - plain design which matches our Legacy themes\n" \
                "\r3 - tilted design which never made it to production\n" \
                "\r4 - one that launched with the redesign of Circle\n" \
                "\r5 - curvy design which never made it to production\n" \
                "\r6 - the current new design that landed in 2015"
            sucess ;;
        -c| --color)
            echo -e \
                "This is a list of currently supported folder\n" \
                "\rcolors that can be used to replace the default.\n\n" \
                "\r0 - default - reverts any previous colour change\n" \
                "\r1 - blue    - 42a5f5\n" \
                "\r2 - brown   - 8d6e63\n" \
                "\r3 - green   - 66bb6a\n" \
                "\r4 - grey    - bdbdbd\n" \
                "\r5 - orange  - f57c00\n" \
                "\r6 - pink    - f06292\n" \
                "\r7 - purple  - 7e57c2\n" \
                "\r8 - red     - ef5350\n" \
                "\r9 - yellow  - ffca28\n"
            sucess ;;
        -h|--help)
            echo -e \
                "A script for changing the Numix base folder\n" \
                "\rstyle and colour.\n\n" \
                "\rRunning as root makes the change globally,\n" \
                "\rotherwise it is only made locally. Run as\n" \
                "\rappropriate to your Numix installation.\n\n" \
                "\rUsage: ./$(basename -- $0) [OPTION]\n" \
                "\r  -c, --colors \t List of available colors.\n" \
                "\r  -s, --styles \t\t List of available styles.\n" \
                "\r  -h, --help \t\t Displays this help menu.\n" \
                "\r  -v, --version \t Displays program version."
            sucess ;;
        -v|--version)
            echo -e \
                "$(basename -- $0) $version\n"
            sucess ;;
        *)
            echo -e \
                "invalid option -- '$1'\n"
            gerror ;;
    esac
fi

# checking default path where numix is installed
cuser="${SUDO_USER:-$USER}"
if [ -d /home/"$cuser"/.local/share/icons/Numix/ ]; then
    dir=/home/"$cuser"/.local/share/icons
elif [ -d /home/"$cuser"/.icons/Numix ]; then
    dir=/home/"$cuser"/.icons
elif [ -d /usr/share/icons/Numix/ ]; then
    if [[ $UID -ne 0 ]]; then
        echo -e \
            "You appear to have Numix instaled globally.\n" \
            "\rPlease run this script again as root"
        gerror
    else
        dir=/usr/share/icons
    fi
else
    echo -e \
        "You don't appear to have Numix installed! Please\n" \
        "\rinstall it and run this script again."
    gerror
fi

# folder style stdin
read -p "Which folder style do you want? type the style list number " answer
if [ -d files/"$answer" ]; then
    style="$answer"
else
    echo -e \
        "You've chosen an invalid style number.\n" \
        "\rRun '$(basename -- $0) --styles' for an option list"
    gerror
fi

declare -A colors
colors=(
    [0]=default 
    [1]=blue
    [2]=brown 
    [3]=green
    [4]=grey 
    [5]=orange
    [6]=pink 
    [7]=purple
    [8]=red 
    [9]=yellow
    )

# folder color stdin
read -p "Which folder color do you want? type the color list number " answer
for i in "${!colors[@]}"
do
    if [ "$answer" == $i ]; then
        color="${colors[$i]}"
    fi
done

# check if color variable is unset
if [ -z "$color" ]; then 
    echo -e \
        "You've chosen an invalid color number.\n" \
        "\rRun '$(basename -- $0) --color' for an option list"
    gerror 
else 
    echo "wait..."

    # changing the folder style
    cp -rH files/"${style}"/Numix/* "${dir}"/Numix/

    #find all files that starts with the selected color and move them with another name to the default numix folder
    find files/"${style}"/Numix/ -iname "${color}*" -type f -exec cp "{}" /home/ricci/dog/ \;
    
    chown -R "$cuser" "${dir}"/Numix/
    if [ -d "${dir}"/Numix-Circle/ ]; then
        cp -rH files/"${style}"/Numix-Circle/* "${dir}"/Numix-Circle/
        chown -R "$cuser" "${dir}"/Numix-Circle/
    fi
    if [ -d "${dir}"/Numix-Square/ ]; then
        cp -rH files/"${style}"/Numix-Square/* "${dir}"/Numix-Square/
        chown -R "$cuser" "${dir}"/Numix-Square/
    fi

    echo "Folder style and color change complete!"
    
    #exiting
    sucess
fi


