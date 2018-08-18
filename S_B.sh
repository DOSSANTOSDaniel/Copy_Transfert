#!/bin/bash

#Ceci est un script qui servira à faire des sauvegardes entre deux machines distantes ou en local

#déclaration des variables de couleur

vertclair='\e[1;32m'

orange='\e[0;33m'

jaune='\e[1;33m'

neutre='\e[0;m'

bleuclair='\e[1;34m'

rougefonce='\e[0;31m'

# Ici l'option -e permet l'interprétation des caractères spéciaux, le \n permet de faire un saut de ligne
echo -e "\n $bleuclair        __________________________________ $neutre \n"
echo    "|                                                |"
echo -e "\n $bleuclair               Script de sauvegarde $neutre \n"
echo    "|                                                |"
echo -e "\n $bleuclair        __________________________________ $neutre \n"


#L'option -p permet d'associer un message à read
#L'option -n permet de délimiter les caractères saisis 
read -p "Voulez-vous faire une sauvegarde en local ?  ([O] [N]) ===>" -n 1 loc
	
echo ""	
	
if [ $loc = "O" ] || [ $loc = "o" ]

then
	read -p "Chemin source ===> " sources
	
	read -p "Chemin cible ===> " cibles
	
#L'option -i permet d'interroger l'utilisateur avant d'écraser des fichiers réguliers existants
#L'option -v affiche le nom de chaque fichier avant de le copier.
#L'option -R copie récursivement les répertoires
#L'option -a copie des fichiers sous forme de sauvegarde parfaite dans un nouveau répertoire
	cp -aivR $sources $cibles 
	
	exit 7
	
elif [ $loc = "N" ] || [ $loc = "n" ]

then

	sleep 0

else
	echo -e" \n "
	echo -e   "$rougefonce *************************************** $neutre"
	echo -e   "$rougefonce *                                     * $neutre"
	echo -e   "$rougefonce *Erreur de saisie veuillez recommencer* $neutre"
	echo -e   "$rougefonce *                                     * $neutre"
	echo -e   "$rougefonce *************************************** $neutre"
	
	exit 5
fi
	
         
echo -e "\n $vertclair                 Sauvegarde à distance !                        $neutre \n"

read -p " Utilisez-vous un port, autre que le 22 ? ([O] [N]) ===> " -n 1 port

echo ""

if [ $port = "O" ] || [ $port = "o" ]

then 
	echo ""
	read -p "Port utilisé ===> " -n 5 portutil
	
elif [ $port = "N" ] || [ $port = "n" ]

then

#Déclaration du port par défaut 
	portutil="22"
	
else

	echo -e" \n "
	echo -e   "$rougefonce *************************************** $neutre"
	echo -e   "$rougefonce *                                     * $neutre"
	echo -e   "$rougefonce *Erreur de saisie veuillez recommencer* $neutre"
	echo -e   "$rougefonce *                                     * $neutre"
	echo -e   "$rougefonce *************************************** $neutre"
	
	exit 1
fi

echo ""

read -p "Voulez-vous envoyer ou recevoir des données ? ([E] [R]) ==> " -n 1 emplacement

echo ""

#vérification du choix du technicien d'envoyer le fichier ou de le recevoir 
if [ $emplacement == "E" ] || [ $emplacement == "e" ]

then 
	echo -e "\n $vertclair Configuration de la machine distante ! $neutre \n"

#saisie et enregistrement de l'adresse IP de la machine
	read -p "IP de la machine distante? ==> " -n 15 ipadressedist

#saisie et enregistrement de l'id de la machine
	read -p "Identifient de la machine distante? ==> " idmachinedist
	
	echo  ""

	envoyer="$idmachinedist@$ipadressedist:"
	
	read -p "Chemin des données à envoyer ===>" cheminlocal
	
	read -p "Chemin cible de sauvegarde sur la machine distante ===>" chemindist
	
	echo ""

	read -p "Voulez-vous une sauvegarde incrémentielle? ([O] [N]) ===>" -n 1 incre
	
#affiche le récapitulatif de l'opération
echo -e "\n $vertclair Récapitulatif de l'opération! $neutre \n"

echo -e "IP machine distante ===> $vertclair $ipadressedist $neutre"
echo -e "Chemin cible de la copie de sauvegarde ===> $vertclair $chemindist $neutre"
echo -e "Chemin des données à sauvegarder ===> $vertclair $cheminlocal $neutre"

echo ""

read -p "Voulez-vous exécuter cette opération? ([O] [N]) ===> " -n 1 ok

echo ""

	if [ $ok = "O" ] || [ $ok = "o" ]

	then

#exécution de l'opération
		if [ $incre = "o" ] || [ $incre = "O" ]

		then 

#configuration pour le mode d'envoi incrémentiel
	
#-a c'est le mode archivage
#-v c'est le mode verbeux 
#-r copie récursive des répertoires
#-e indique un shell distant et ses option ici nous indiquant que la connexion se fait en ssh et nous indiquons un port
#--progress montre l'avancement pendant le transfert
#--stats affiche quelques statistiques de transfert de fichiers

			rsync -avr -e "ssh -p $portutil" --progress --stats $cheminlocal $envoyer$chemindist
	
		elif [ $incre = "n" ] || [ $incre = "N" ]

		then
#configuration pour le mode d'envoi simple 

#-r Copie récursivement des répertoires entiers
#-P Spécifie un port de connexion à la machine distante
			scp -r -P $portutil $cheminlocal $envoyer$chemindist
	
		else 
			echo -e" \n "
			echo -e   "$rougefonce *************************************** $neutre"
			echo -e   "$rougefonce *                                     * $neutre"
			echo -e   "$rougefonce *Erreur de saisie veuillez recommencer* $neutre"
			echo -e   "$rougefonce *                                     * $neutre"
			echo -e   "$rougefonce *************************************** $neutre"
	
			exit 2
	
		fi
	
	elif [ $ok = "N" ] || [ $ok = "n" ]

	then 
	
		echo -e " $vertclair Recommencez s'il vous plait! $neutre"
	
		exit 3
	
	else
		echo -e" \n "
		echo -e   "$rougefonce ************************************** $neutre"
		echo -e   "$rougefonce *                                    * $neutre"
		echo -e   "$rougefonce *Erreur de saisie veuillez recomencer* $neutre"
		echo -e   "$rougefonce *                                    * $neutre"
		echo -e   "$rougefonce ************************************** $neutre"
	
		exit 4
	fi

elif [ $emplacement == "R" ] || [ $emplacement == "r" ]

then

	echo -e "\n $vertclair Configuration de la machine distante ! $neutre \n"

#mise en pause de 3 secondes
	sleep 0

#saisie et enregistrement de l'adresse IP de la machine
	read -p "IP de la machine distante? ==> " -n 15 ipadressedist

#saisie et enregistrement de l'id de la machine
	read -p "Identifient de la machine distante? ==> " idmachinedist

	echo ""

	recevoir="$idmachinedist@$ipadressedist:"
	
	read -p "Chemin des données à récupérer sur la machine distante? ===>" chemindist
	
	read -p "Chemin du dossier cible de sauvegarde sur la machine local ===>" cheminlocal
	
	
	echo ""
	
	read -p "Voulez-vous faire une sauvegarde incrémentielle? ([O] [N]) ===>" -n 1 incre
	
echo ""

#affiche le récapitulatif de l'opération
echo -e "\n $vertclair Récapitulatif de l'opération $neutre \n"

echo -e "IP distante ===> $vertclair $ipadressedist $neutre"
echo -e "Chemin de la copie de sauvegarde ===> $vertclair $cheminlocal $neutre"
echo -e "Chemin des données à récupérer et à sauvegarder ===> $vertclair $chemindist $neutre"

echo ""

read -p "Voulez-vous exécuter cette opération? ([O] [N]) ===> " -n 1 ok

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

			echo -e" \n "
			echo -e   "$rougefonce *************************************** $neutre"
			echo -e   "$rougefonce *                                     * $neutre"
			echo -e   "$rougefonce *Erreur de saisie veuillez recommencer* $neutre"
			echo -e   "$rougefonce *                                     * $neutre"
			echo -e   "$rougefonce *************************************** $neutre"
	
		exit 0
	
		fi
	
	elif [ $ok = "N" ] || [ $ok = "n" ]

	then 
	
		echo "$orange Recommencez s'il vous plait! $neutre"
	
	exit 3
	
	else
		echo -e" \n "
		echo -e   "$rougefonce *************************************** $neutre"
		echo -e   "$rougefonce *                                     * $neutre"
		echo -e   "$rougefonce *Erreur de saisie veuillez recommencer* $neutre"
		echo -e   "$rougefonce *                                     * $neutre"
		echo -e   "$rougefonce *************************************** $neutre"
	
	exit 4
	fi
	
else
		echo -e" \n "
		echo -e   "$rougefonce *************************************** $neutre"
		echo -e   "$rougefonce *                                     * $neutre"
		echo -e   "$rougefonce *Erreur de saisie veuillez recommencer* $neutre"
		echo -e   "$rougefonce *                                     * $neutre"
		echo -e   "$rougefonce *************************************** $neutre"
fi

echo ""

echo -e   "$orange ***FIN DU PROGRAMME*** $neutre"
