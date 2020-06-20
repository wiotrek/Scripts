#!/bin/bash
function syntaxNull()
{
	echo "wprowadz parametr"
	exit 1
}
function syntaxExist()
{
	echo "Wprowadz poprawna nazwe"
	exit 1	
}

#Sprawdz czy istnieje taki uzytkownik
       if [[ -z "$1" ]] ; then
                syntaxNull
                # jesli nie istnieje parametr przechodzi do funkcji syntaxnull
        else
		if getent passwd $1 > /dev/null 2>&1 ; then
                        echo "Uzytkownik  $1 juz istnieje"
			syntaxExist
                else
                        sudo useradd $1
                        #tworzymy uzytkownika
                        echo "1. Dodalismy uzytkownika" > raport.txt
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
                        echo ""
			sudo groupadd $2
			#echo "stworzono grupe"
			sudo usermod -a -G $2 $1
			#echo "dodano uzytkownika do grupy"

                        echo "2. Stworzylismy grupe oraz dodalismy uzytkownika do niej" >> raport.txt
		fi
        fi

#Sprawdz czy istnieje taki folder
	

        if [[ -z "$3" ]] ; then
                syntaxNull
        else
                if [ -d $3  ] ; then
                        # Jesli parametr $3 istnieje, oraz istnieje taki folder 

                        #dodawanie biezacej sciezki do zmiennej
                        sciezka=pwd
                        
			cd $3
                        
			#sprawdzamy czy pobrana wczesniej sciekza zmienila sie po komendzie cd do folderu z parametru 3
			if [ sciezka == $PWD ] ; then
				echo "nie udalo sie otworzyc folderu 1"
				exit 1
			else
				echo "3. Udalo nam sie wejsc do danej danej sciezki" >> raport.txt
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
                        sudo chmod 777 $4
                        if [ $(stat -c '%a' $4) == 777] ; then 
                                echo "4. Zmienielismy uprawnienia plikowi nr 1, wiec jest gotowy do dzialan" >> raport.txt
                        else
                                echo "Nie da sie skpiowac pliku $4"
                                exit 1
                        fi
                else
                        syntaxExist
                fi
        fi

#Sprawdz czy istnieje taki folder2
        if [[ -z "$5" ]] ; then
                syntaxNull
        else
                if [ -d $5  ] ; then
                        #echo "folder $5 istnieje"

                        #zmiana uprawinien dla docelowego katalogu
                        sudo chmod 777 $5
                        if [ $(stat -c '%a' $5) == 777] ; then 
                                echo "5. Zmienielismy uprawnienia folderowi nr 2, wiec jest gotowy do dzialan" >> raport.txt
                        else
                                echo "Nie udalo sie zmienic uprawnien katalogu $5"
                                exit 1
                        fi
                else
                        syntaxExist
                fi
        fi

#Sprawdz czy istnieje taki plik2
#plik2 jest do usuniecia
       if [[ -z "$6" ]] ; then
                syntaxNull
        else
                if [ -f $6  ] ; then
                        sudo chmod 777 $6
                        if [ $(stat -c '%a' $6) == 777] ; then 
                                echo "6. Zmienielismy uprawnienia plikowi nr 2, wiec jest gotowy do dzialania" >> raport.txt
                        else
                                echo "Nie da sie usunac pliku $6"
                                exit 1
                        fi
                else
                        syntaxExist
                fi
        fi

#Sprawdz czy istnieje taki folder3
        if [[ -z "$7" ]] ; then
                syntaxNull
        else
                if [ -d $5  ] ; then
                        #echo "folder $5 istnieje"

                        #zmiana uprawinien dla docelowego katalogu
                        sudo chmod 777 $7
                        if [ $(stat -c '%a' $7) == 777] ; then 
                                echo "7. Zmienielismy uprawnienia folderowi nr 3, wiec jest gotowy do dzialan" >> raport.txt
                        else
                                echo "Nie udalo sie zmienic uprawnien katalogu $7"
                                exit 1
                        fi
                else
                        syntaxExist
                fi
        fi

#folder biezacy to folder z parametru 3
#wyswietlamy liste katalogow
tree -d
echo "8. Zostalo wyswietlone drzewo folderow" >> raport.txt 

#kopiujemy plik z parametru 4 do folderu z parametru 5
cp $4 $5

#Jesli nie uda nam sie skopiowac pliku to wystapi wystapi blad i zakonczy sie skrypt
if [ $? == 0 ] ; then
        echo "9. Udalo sie skopiowac plik" >> raport.txt
else
        echo "Nie udalo sie skopiowac $4 do podanego folderu"
        exit 1
fi

#przenosimy plik z paramteru 6 do folderu z paremtru 7
mv $6 $7

