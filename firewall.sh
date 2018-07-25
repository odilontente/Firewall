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
#
####################################################>>> Regras do Firewall <<<############################################################
#
iptables -F
iptables -F FORWARD
iptables -P FORWARD ACCEPT #DROP

###############>>> Ativa os LOG <<<##############
#
iptables -t filter -I FORWARD -j LOG
#
###############################################>>>Bloqueios<<<############################################
url_blok=$(cat url_blok | egrep -v "^[#;]")
for blok in $url_blok  ; do
	if [ "$url_blok" != "blok" ];then
        	iptables -I FORWARD -m string --string $blok --algo bm -j DROP
        	echo $blok "URL bloqueada !"
	else
        	echo $blok "URL bloqueada !"
	fi
done
#
################################################>>> Fim Bloqueios <<<######################################
#
#
iptables -A FORWARD -m state --state ESTABLISHED,RELATED -j ACCEPT
#
###############>>> Variaves <<<####################
#
WWW_IP="0/0"
IF_ON="enp5s0"
IF_OFF="enp9s0"
IF_SSH="enp14s0"
#
###########################>>> Ativa LOGs HTTP/HTTPS/SSH <<<###################################
#
iptables -t filter -A FORWARD -p tcp --dport 80 -j LOG --log-prefix "FW_HTTP: "
iptables -t filter -A FORWARD -p tcp --dport 443 -j LOG --log-prefix "FW_HTTPS: "
iptables -t filter -I INPUT -p tcp --dport 22 -j LOG --log-prefix "FW_SSH: " 
#
#################################>>> Libera Trafego Portas Entrada <<<####################################################
iptables -t filter -I FORWARD -p tcp -s $WWW_IP -d $WWW_IP --dport 80 -m physdev --physdev-in $IF_OFF --physdev-out $IF_ON -j ACCEPT #(HTTP)
iptables -t filter -I FORWARD -p tcp -s $WWW_IP -d $WWW_IP --dport 443 -m physdev --physdev-in  $IF_OFF --physdev-out $IF_ON -j ACCEPT #(HTTPS)
#iptables -t filter -I FORWARD -p tcp -s 0.0.0.0/0 -d $WWW_IP --dport 110 -m physdev --physdev-in  $IF_OFF --physdev-out $IF_ON -j ACCEPT #(POP)
#iptables -t filter -I FORWARD -p tcp -s 0.0.0.0/0 -d $WWW_IP --dport 465 -m physdev --physdev-in  $IF_OFF --physdev-out $IF_ON -j ACCEPT #(SMTP)
#iptables -t filter -I FORWARD -p tcp -s 0.0.0.0/0 -d $WWW_IP --dport 587 -m physdev --physdev-in  $IF_OFF --physdev-out $IF_ON -j ACCEPT #(SMTP)
#iptables -t filter -I FORWARD -p tcp -s 0.0.0.0/0 -d $WWW_IP --dport 143 -m physdev --physdev-in  $IF_OFF --physdev-out $IF_ON -j ACCEPT #(IMAP)
#iptables -t filter -I FORWARD -p tcp -s 0.0.0.0/0 -d $WWW_IP --dport 993 -m physdev --physdev-in  $IF_OFF --physdev-out $IF_ON -j ACCEPT #(IMAP)
iptables -t filter -I INPUT -p tcp -s $WWW_IP -d $WWW_IP --dport 22 -m physdev --physdev-in  $IF_SSH --physdev-out $IF_ON -j ACCEPT #(SSH)
#
##################>>>Libera Conexão do WWW indo para a Internet <<<###################################
#
iptables -I FORWARD -p tcp -s $WWW_IP -d $WWW_IP -m physdev --physdev-in $IF_ON --physdev-out $IF_OFF -j ACCEPT 
iptables -I FORWARD -p tcp -s $WWW_IP -d $WWW_IP -m physdev --physdev-in $IF_OFF --physdev-out $IF_ON -j ACCEPT
#
################################>>> Regra de Liberação do Firewall <<<################################
#
##Libera para IPs Especificos
#
IP_LIB=$(cat ips_lib | grep -v "^[#;]")
for IP in $IP_LIB  ; do
	if [ "$IP_LIB" != "IP" ];then
        	iptables -t filter -I FORWARD -s $IP -d 0/0 -j ACCEPT
		iptables -t filter -I FORWARD -s 0/0 -d $IP -j ACCEPT
        	echo $IP "liberado !"
	else
        	echo $IP "liberado !"
	fi
done
#
##

