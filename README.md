# Air-deauth

## Pablo Vilallave - Seguridad Informática (EI1056)

Script que gracias a la herramienta de aircrack-ng permite realizar un ataque de deautentificación puediendo asi, guardar los 'handshakes' interceptados durante el ataque.

# Dependencias
Esta serie de paquetes es para que tanto airodump-ng, como aireplay-ng y aircrack-ng funcionen de manera correcta en nuestro sistema

```sudo apt-get install build-essential autoconf automake libtool pkg-config libnl-3-dev libnl-genl-3-dev libssl-dev ethtool shtool rfkill zlib1g-dev libpcap-dev libsqlite3-dev libpcre3-dev libhwloc-dev libcmocka-dev hostapd wpasupplicant tcpdump screen iw usbutils```

# Instalación y uso
1. Instalación de aircrack-ng:
`sudo apt-get update`
`sudo apt-get install aircrack-ng`
2. Una vez instalado aircrack-ng, para usar el script: `sudo ./deauth.sh`
