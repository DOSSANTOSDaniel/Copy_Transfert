#!/bin/bash

# TITRE: Tranferts de données
#================================================================#
# DESCRIPTION:
#  Ceci est un script qui servira à faire des sauvegardes
#  entre deux machines distantes ou en local.
#----------------------------------------------------------------#
# AUTEURS:
#  Daniel DOS SANTOS < danielitto91@gmail.com >
#  GITHUB: https://github.com/DOSSANTOSDaniel/copy_transfert
#----------------------------------------------------------------#
# DATE DE CRÉATION: 27/05/2018
#----------------------------------------------------------------#
# VERSIONS: 2
#----------------------------------------------------------------#
# USAGE: ./copy_transfert
#----------------------------------------------------------------#
# NOTES:
#  Pour indiquer les chemins il faut :
#  1 > Mettre un "/" à la fin du chemin si c'est un répertoire
#  2 > Ne pas mettre de "/" à la fin du chemin si c'est un fichier
#
#  Il est possible de compresser les données sur la machine 
#  locale avant d'envoyer les données sur la machine distante,
#  l'inverse n'est pas possible sur cette version du script.
#----------------------------------------------------------------#
# BASH VERSION: GNU bash, version 4.4.12
#================================================================#

#Déclaration variables
#-----------------------

#Variable date et heure du jour
dat='date_'$(date +%F'_heure_'%H-%M)

#Nom login
nom=$(logname)

#Déclaration du port par défaut 
portutil="22"

#déclaration des variables de couleur
vertclair='\e[1;32m'
orange='\e[0;33m'
jaune='\e[1;33m'
neutre='\e[0;m'
bleuclair='\e[1;34m'
rougefonce='\e[0;31m'

#déclaration des fonctions
#---------------------------

function erreur
{	
	echo -e" \n "
	echo -e   "$rougefonce *************************************** $neutre"
	echo -e   "$rougefonce *                                     * $neutre"
	echo -e   "$rougefonce *Erreur de saisie veuillez recommencer* $neutre"
	echo -e   "$rougefonce *                                     * $neutre"
	echo -e   "$rougefonce *************************************** $neutre"
	
	suivant
}

function info
        {
        echo -e "$jaune
         ______________
        ||             |
        || 
        || >_ $1
        || 
        ||_____________|
        |______________|
         \\== = = = = = =\\
          \\==============\\
           \\======____====\\
            \\_____\\___\\____\\
	$neutre"
	#read -p "Valider pour continuer !"
}

function ipid
{
	echo ""
	info "Configuration de la machine distante !"
#saisie et enregistrement de l'adresse IP de la machine
	read -p "IP de la machine distante? ==> :  " -n 15 ipadressedist
#saisie et enregistrement de l'id de la machine
	read -p "Identifient de la machine distante? ==> :  " idmachinedist
	echo  ""
}

#Archivage et compression
function complocloc
{
echo ""
read -p "Voulez vous compresser les données oui [o] non [n] : " comp
echo ""
case $comp in
	[oO]|"oui"|"OUI")
		if tar -zcvpf $1$dat.tar.gz $1
		then
			echo -e "\nCompression terminé\n"
		else
			echo -e "\nErreur de la Compression\n"
			suivant
		fi
		che="$(dirname $1)"
		sources="$che/*.tar.gz";;
	[nN]|"non"|"NON")
		continue;;
	*)
		erreur;;
esac
}

function complocdist
{
echo ""
read -p "Voulez vous compresser les données oui [o] non [n] : " comp
echo ""
case $comp in
	[oO]|"oui"|"OUI")
		if tar -zcvpf $1$dat.tar.gz $1
		then
			echo -e "\nCompression terminé\n"
		else
			echo -e "\nErreur de la Compression\n"
			suivant
		fi
		che="$(dirname $1)"
		cheminlocal="$che/*.tar.gz";;
	[nN]|"non"|"NON")
		continue;;
	*)
		erreur;;
esac
}


function suivant
{
	echo ""
	read -p "Voulez vous faire à nouveau un transfert? oui [o] non [n] : " suiv
	echo ""
	case $suiv in
	[oO]|"oui"|"OUI") continue;;
	[nN]|"non"|"NON") the_end;;
	*) erreur;;
	esac
}

function the_end
{
	for couleur in "$vertclair" "$orange" "$jaune" "$bleuclair" "$rougefonce"
        do
            clear
            echo -e "$couleur
             _____   _                                   _           _
            |  ___| (_)  _ __        ___    ___   _ __  (_)  _ __   | |_
            | |_    | | | '_ \      / __|  / __| | '__| | | | '_ \  | __|
            |  _|   | | | | | |     \__ \ | (__  | |    | | | |_) | | |_
            |_|     |_| |_| |_|     |___/  \___| |_|    |_| | .__/   \__|
                                                            |_|
			$neutre"
            sleep 1
        done
    exit 1
}

#code
#------
while :
do
clear
#bannière de présentation
cat << "EOF"
 ____            _       _   
/ ___|  ___ _ __(_)_ __ | |_ 
\___ \ / __| '__| | '_ \| __|
 ___) | (__| |  | | |_) | |_ 
|____/ \___|_|  |_| .__/ \__|
                  |_|        
                                               _      
 ___  __ _ _   ___   _____  __ _  __ _ _ __ __| | ___ 
/ __|/ _` | | | \ \ / / _ \/ _` |/ _` | '__/ _` |/ _ \
\__ \ (_| | |_| |\ V /  __/ (_| | (_| | | | (_| |  __/
|___/\__,_|\__,_| \_/ \___|\__, |\__,_|_|  \__,_|\___|
                           |___/                      
EOF
echo -e "\n"
#Ici le nom d'utilisateur sera utile pour configurer les logs
#L'option -p permet d'associer un message à read
read -p "Etes vous connecté sous << $(logname) >> ? ([O] [N]) ==> : " choix
if [ $choix == "N" ] || [ $choix == "n" ]
then
	echo ""
	read -p "Merci de préciser le nom d'utilisateur ici ==> : " nom
elif [ $choix == "O" ] || [ $choix == "o" ]
then
	echo ""
	echo "login: $(logname)"
else
	erreur
fi

#Création des logs
mkdir -p /home/$nom/sauvegardes/backup_log
exec > >(tee -a /home/$nom/sauvegardes/backup_log/sauv_$dat)
exec 2>&1

#L'option -n permet de délimiter les caractères saisis
echo ""
read -p "Voulez-vous faire une sauvegarde en local ?  ([O] [N]) ==> : " -n 1 loc	
echo ""
	
if [ $loc == "O" ] || [ $loc == "o" ]
then
	read -p "Chemin source ==> :  " sources
	read -p "Chemin cible ==> :  " cibles
	
#L'option -i permet d'interroger l'utilisateur avant d'écraser des fichiers réguliers existants
#L'option -v affiche le nom de chaque fichier avant de le copier.
#L'option -R copie récursivement les répertoires
#L'option -a copie des fichiers sous forme de sauvegarde parfaite dans un nouveau répertoire
	complocloc "$sources"
	cp -aivR $sources $cibles
	suivant
elif [ $loc == "N" ] || [ $loc == "n" ]
then
	clear
	info "Transfert de données sur une machine distante"
else
	erreur
fi

read -p " Utilisez-vous un port, autre que le 22 ? ([O] [N]) ==> :  " -n 1 port
echo ""

if [ $port == "O" ] || [ $port == "o" ]
then 
	read -p "Port utilisé ==> :  " -n 5 portutil
elif [ $port == "N" ] || [ $port == "n" ]
then
	clear
	info "Port par defaut: 22"	
else
	erreur
fi

echo ""
read -p "Voulez-vous envoyer ou recevoir des données ? ([E] [R]) ==> :  " -n 1 emplacement
echo ""
clear
#vérification du choix du technicien d'envoyer le fichier ou de le recevoir 
if [ $emplacement == "E" ] || [ $emplacement == "e" ]
then 
	ipid
	envoyer="$idmachinedist@$ipadressedist:"
	read -p "Chemin des données à envoyer ==> : " cheminlocal
	read -p "Chemin cible de sauvegarde sur la machine distante ==> : " chemindist
	
	echo ""
	read -p "Voulez-vous une sauvegarde incrémentielle? ([O] [N]) ==> : " -n 1 incre
#affiche le récapitulatif de l'opération
clear
info "Récapitulatif de l'opération!"
echo -e "IP machine distante ==> :  $vertclair $ipadressedist $neutre"
echo -e "Chemin cible de la copie de sauvegarde ==> :  $vertclair $chemindist $neutre"
echo -e "Chemin des données à sauvegarder ==> :  $vertclair $cheminlocal $neutre"

echo ""
read -p "Voulez-vous exécuter cette opération? ([O] [N]) ==> :  " -n 1 ok
echo ""
	if [ $ok == "O" ] || [ $ok == "o" ]
	then
#exécution de l'opération
		if [ $incre == "o" ] || [ $incre == "O" ]
		then 
#configuration pour le mode d'envoi incrémentiel
	
#-a c'est le mode archivage
#-v c'est le mode verbeux 
#-r copie récursive des répertoires
#-e indique un shell distant et ses option ici nous indiquant que la connexion se fait en ssh et nous indiquons un port
#--progress montre l'avancement pendant le transfert
#--stats affiche quelques statistiques de transfert de fichiers
			#Archivage et compression
			complocdist "$cheminlocal"
			
			rsync -avr -e "ssh -p $portutil" --progress --stats $cheminlocal $envoyer$chemindist
		elif [ $incre == "n" ] || [ $incre == "N" ]
		then
#configuration pour le mode d'envoi simple 
#-r Copie récursivement des répertoires entiers
#-P Spécifie un port de connexion à la machine distante
			complocdist "$cheminlocal"
			scp -r -P $portutil $cheminlocal $envoyer$chemindist
		else 
			erreur
		fi
	elif [ $ok == "N" ] || [ $ok == "n" ]
	then 
		clear
		info "Merci de relancer le script!"
		suivant
	else
		erreur
	fi
elif [ $emplacement == "R" ] || [ $emplacement == "r" ]
then
	ipid
	recevoir="$idmachinedist@$ipadressedist:"
	read -p "Chemin des données à récupérer sur la machine distante? ==> : " chemindist
	read -p "Chemin du dossier cible de sauvegarde sur la machine local ==> : " cheminlocal

	echo ""
	read -p "Voulez-vous faire une sauvegarde incrémentielle? ([O] [N]) ==> : " -n 1 incre
echo ""
#affiche le récapitulatif de l'opération
clear
info "Récapitulatif de l'opération"
echo -e "IP distante ==> :  $vertclair $ipadressedist $neutre"
echo -e "Chemin de la copie de sauvegarde ==> :  $vertclair $cheminlocal $neutre"
echo -e "Chemin des données à récupérer et à sauvegarder ==> :  $vertclair $chemindist $neutre"

echo ""
read -p "Voulez-vous exécuter cette opération? ([O] [N]) ==> :  " -n 1 ok
echo ""
	if [ $ok = "O" ] || [ $ok = "o" ]
	then
#exécution de l'opération
		if [ $incre = "o" ] || [ $incre = "O" ]
		then 
			rsync -avr -e "ssh -p $portutil" --progress --stats $recevoir$chemindist $cheminlocal
		elif [ $incre = "n" ] || [ $incre = "N" ]
		then
#configuration pour le mode de récupération d'une sauvegarde simple
			scp -r -P $portutil $recevoir$chemindist $cheminlocal
		else
			erreur
		fi
	elif [ $ok = "N" ] || [ $ok = "n" ]
	then
		clear
		info "Recommencez s'il vous plait!"
		suivant
	else
		erreur
	fi
else
	erreur
fi
suivant
done
