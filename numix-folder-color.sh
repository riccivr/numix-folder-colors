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
        -c| --color)
            echo -e \
                "This is a list of currently supported folder\n" \
                "\rcolours that can be used to replace the default.\n\n" \
                "\r1)  default  - reverts any previous colour change\n" \
                "\r2)  blue     - 42a5f5\n" \
                "\r3)  brown    - 8d6e63\n" \
                "\r4)  green    - 66bb6a\n" \
                "\r5)  grey     - bdbdbd\n" \
                "\r6)  orange   - f57c00\n" \
                "\r7)  pink     - f06292\n" \
                "\r8)  purple   - 7e57c2\n" \
                "\r9)  red      - ef5350\n" \
                "\r10) yellow   - ffca28\n"
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

read -p "Which folder color do you want? " answer
if [ -d files/"$answer" ] && [ "$answer" != colours ]; then
    style="$answer"
else
    echo -e \
        "Oops! You've chosen an invalid color number.\n" \
        "\rRun '$(basename -- $0) --styles' for an option list"
    gerror
fi

# renaming folders to become the default ones
cp -rH files/"${style}"/Numix/* "${dir}"/Numix/
chown -R "$cuser" "${dir}"/Numix/
if [ -d "${dir}"/Numix-Circle/ ]; then
    cp -rH files/"${style}"/Numix-Circle/* "${dir}"/Numix-Circle/
    chown -R "$cuser" "${dir}"/Numix-Circle/
fi
if [ -d "${dir}"/Numix-Square/ ]; then
    cp -rH files/"${style}"/Numix-Square/* "${dir}"/Numix-Square/
    chown -R "$cuser" "${dir}"/Numix-Square/
fi

echo "Folder color change complete!"
sucess