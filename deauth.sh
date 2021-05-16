#!/bin/bash

#Estilos
BOLD_RED="\e[1;31m"
BOLD_WHITE="\e[1;37m"
WHITE="\e[0;97m"
BOLD_PURPLE="\e[1;35m"
BOLD_YELLOW="\e[1;33m"
BOLD_BLUE="\e[1;36m"

#Titulo del script
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
RANGO=1
function w_interfaces(){
    OUTPUT=$(iw dev | awk '{if ($1=="Interface") print $2}')
    i=1
    echo -e $WHITE
    if [ ${#OUTPUT} == 0 ]
    then
        echo -e "$BOLD_RED Error: $WHITE No se han encontrado interfaces inalambricas, no es posible continuar con el ataque"
    else
	for interface in ${OUTPUT}
	do
	    echo -e "   $BOLD_WHITE $RANGO.$WHITE $interface"
	    RANGO=$((RANGO+1))
	done
    fi
}

#Comprueba si el argumento que le pasamos es un numero
function is_number(){
    re='^[0-9]+$'
    is=false
    if [[ $1 =~ $re ]]
    then
        if [ $1 -gt $RANGO ] || [ $1 -lt 1 ]
        then
            echo -e "$BOLD_RED Error: $WHITE El valor introducido esta fuera del rango"
        fi
        is = true
    else
        echo -e "$BOLD_RED Error: $WHITE Introduce un valor numérico"
    fi
    return is
}


titulo

#Mostramos interfaces inalambricas disponibles
echo -e $BOLD_BLUE
echo -e " Interfaces inalambricas disponibles:"
w_interfaces
echo ""
echo -e -n " Elige una interface $BOLD_WHITE\033[5m>\033[0m"
read INTERFACE
if 
echo " Has escogido la inerface $INTERFACE"

#Pedimos al usuario una de las interfaces
ES_NUMERO=false
while [ ES_NUMERO = false ]
do
    echo -e -n " Elige una interface $BOLD_WHITE\033[5m>\033[0m"
    read INTERFACE
    is_number $INTERFACE
    ES_NUMERO = $?
done

echo "Has escogido la interfaz $INTERFACE"
