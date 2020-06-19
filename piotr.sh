#!/bin/bash
function syntaxNull
{
	echo "wprowadz parametr"
	exit 1
}
function syntaxExist
{
	echo "Wprowadz poprawna nazwe"
	exit 1	
}

#Sprawdz czy istnieje taki uzytkownik
       if [[ -z "$1" ]] ; then
                syntaxNull
        else
		if getent passwd $1 > /dev/null 2>&1 ; then
                        echo "Uzytkownik  $1 juz istnieje"
			syntaxExist
                else
                        #sudo useradd $1
			echo "dodano uzytkownika"
                fi
        fi
#Sprawdz czy istnieje taka grupa	
	if [[ -z "$2" ]] ; then
                syntaxNull 
        else
		if [ $(getent group $2) ] ; then
			echo "Grupa $2 juz istnieje"
			syntaxExist
		else
			#sudo groupadd $2
			echo "stworzono grupe"
			#sudo usermod -a -G $2 $1
			echo "dodano uzytkownika do grupy"
		fi
        fi

#Sprawdz czy istnieje taki folder
	sciezka=pwd

        if [[ -z "$3" ]] ; then
                syntaxNull
        else
                if [ -d $3  ] ; then
                        echo "folder $3 istnieje"
			cd $3

			#sprawdzamy czy pobrana wczesniej sciekza zmienila sie po komendzie cd do folderu z parametru 3
			if [ sciezka == $PWD ] ; then
				echo "nie udalo sie otworzyc folderu 1"
				exit 1
			else
				echo "udalo sie"
			fi

                else
                        syntaxExist
                fi
        fi

#Sprawdz czy istnieje taki plik
       if [[ -z "$4" ]] ; then
                syntaxNull
        else
                if [ -f $4  ] ; then
                        echo "plik $4 istnieje"
                else
                        syntaxExist
                fi
        fi

#Sprawdz czy istnieje taki folder2
        if [[ -z "$5" ]] ; then
                syntaxNull
        else
                if [ -d $5  ] ; then
                        echo "folder $5 istnieje"
                else
                        syntaxExist
                fi
        fi

#Sprawdz czy istnieje taki plik2
       if [[ -z "$6" ]] ; then
                syntaxNull
        else
                if [ -f $4  ] ; then
                        echo "plik $6 istnieje"
                else
                        syntaxExist
                fi
        fi

#Ustaw biezacy folder folder1
