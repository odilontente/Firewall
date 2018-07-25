#!/bin/bash
#################################################
#												#
# #		 Micro-Firewall Start Bridge			#
# 												#
#################################################
#												#
## 			Script By:Odilon Tente				#
#												#
#################################################
#Parando Serviço de Rede
echo "Parando Serviço de Rede"
service network stop

#ADD Link WAN na br0
echo "ADD Link WAN na br0"
brctl addif br0 "Placa de rede"# EX:enp1s0,eth0...
echo "WAN OK...\n"

#ADD Link WAN na br0
echo "ADD Link LAN na br0"
brctl addif br0 "Placa de rede"# EX:enp1s0,eth0...
echo "LAN OK..."

#Abilitando STP na br0
echo "Abilitando stp na br0"
brctl stp br0 on
echo "br0 OK..."

#Iniciando Serviço de Rede
echo "Iniciando Serviço de Rede"
service network start
exit 0
