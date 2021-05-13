#!/bin/bash

#Estilos
BOLD_RED="\e[1;31m"
BOLD_WHITE="\e[1;37m"
WHITE="\e[0;97m"
BOLD_PURPLE="\e[1;35m"
BOLD_YELLOW="\e[1;33m"
BOLD_BLUE="\e[1;36m"

function titulo(){
    echo -e $BOLD_RED
    echo  " ______                        __                            __    __ "
    echo  "/\  _  \  __                  /\ \                          /\ \__/\ \ "
    echo  "\ \ \L\ \/\_\  ____           \_\ \    ____   ____    __  __\ \ ,_\ \ \____"
    echo  " \ \  __ \/\ \/\ __\ _______  /_   \  / __ \ / __ \  /\ \/\ \\\ \ \/\ \   _ \ "
    echo  "  \ \ \/\ \ \ \ \ \//\______\/\ \L\ \/\  __//\ \L\.\_\ \ \_\ \\\ \ \_\ \ \ \ \\ "
    echo  "   \ \_\ \_\ \_\ \_\\\/______/\ \___,_\ \____\ \__/.\_\\\ \____/ \ \__\\\ \_\ \_\ "
    echo  "    \/_/\/_/\/_/\/_/          \/__,_ /\/____/\/__/\/_/ \/___/   \/__/ \/_/\/_/  V 1.0"
    echo -e $WHITE
    echo  "---------------[ Deautentificador via Aircrack-ng por PabloVilallave ]---------------"
    echo  -e "-------------------[ Repo: $BOLD_WHITE https://github.com/Ousdeferro/Deauth$WHITE]--------------------\n"
}

#Muestra las diferentes interfaces inalambricas disponibles
function w_interfaces(){
    OUTPUT=$(iw dev | awk '{if ($1=="Interface") print $2}')
    echo -e $WHITE
    if [ ${#OUTPUT} == 0 ]
    then
        echo -e "$BOLD_RED Error: $WHITE No se han encontrado interfaces inalambricas, no es posible continuar con el ataque"
    else
        echo " ${OUTPUT}"
    fi
}

titulo
echo -e $BOLD_BLUE
echo -e " Interfaces inalambricas disponibles:"
w_interfaces

