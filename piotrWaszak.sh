#!/bin/bash

#Skrypt najlepiej dziala jesli podajemy parametry bez sciezek
#czyli w katalogu w ktorym jest skrypt rownolegle jest folder($3) a w ktorym sa [dwa foldery i dwa pliki]($4-$7)

function syntaxNull()
{
        echo "#####################################"
	echo "Niepoprawna skladnia"
        echo "1. Nazwa uzytkownika"
        echo "2. Nazwa grupy"
        echo "3. Nazwa lub sciezka do folder 1"
        echo "4. Nazwa lub sciezka do pliku 1"
        echo "5. Nazwa lub sciezka do folderu 2"
        echo "6. Nazwa lub sciezka do pliku 2"
        echo "7. Nazwa lub sciezka do folderu 3"
        echo "#####################################"
	exit 1
}
function syntaxExist()
{
	echo "Wprowadz poprawna nazwe"
	exit 1	
}
 #sciezka do raportu
sciezkaDoRaportu=$3/raport.txt

#Sprawdza na poczatku czy jest wlasciwa ilosc parametrow, aby uninkac niepotrzebnego wykonywania
       if [[ -z "$8" ]] ; then
                echo "0. Prawidlowa ilosc parametrow" >> $sciezkaDoRaportu
        else
                echo "Zbyt duzo parametrow"
                syntaxNull
        fi

#Sprawdz czy istnieje taki uzytkownik
       if [[ -z "$1" ]] ; then
                syntaxNull
                # jesli nie istnieje parametr przechodzi do funkcji syntaxnull
        else
		if getent passwd $1 > /dev/null 2>&1 ; then
                        echo "Uzytkownik  $1 juz istnieje"
			syntaxExist
                else
                        #tworzymy uzytkownika
                        sudo useradd $1

                        echo "1. Dodalismy uzytkownika" >> $sciezkaDoRaportu
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
			sudo groupadd $2
			sudo usermod -a -G $2 $1

                        echo "2. Stworzylismy grupe oraz dodalismy uzytkownika do niej" >> $sciezkaDoRaportu
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
                        if [ $(stat -c '%a' $4) == 777 ] ; then 
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
                        if [ $(stat -c '%a' $5) == 777 ] ; then 
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
                        if [ $(stat -c '%a' $6) == 777 ] ; then 
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
                        if [ $(stat -c '%a' $7) == 777 ] ; then 
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
#oraz zmieniamy jej uprawnienia aby tylko wlasciciel mogl otwierac i zapisywac

#sciezka do kopiowanego pliku
sciezkaKopiowanyPlik=$5/$4
cp $4 $5 && sudo chmod 611 $sciezkaKopiowanyPlik

#Jesli nie uda nam sie skopiowac pliku to wystapi wystapi blad i zakonczy sie skrypt
if [ $? == 0 ] ; then
        echo "9. Udalo sie skopiowac plik" >> raport.txt
else
        echo "Nie udalo sie skopiowac $4 do podanego folderu"
        exit 1
fi

#przenosimy plik z paramteru 6 do folderu z paremtru 7
#oraz zmieniamy jej uprawnienia aby tylko wlasciciel mogl otwierac i zapisywac

#sciezka do przeniesionego pliku
sciezkaPrzeniesionyPlik=$7/$6
mv $6 $7 && sudo chmod 611 $sciezkaPrzeniesionyPlik

if [ $? == 0 ] ; then
        echo "10. Udalo sie przeniesc plik $6" >> raport.txt
else
        echo "Nie udalo sie przeniesc pliku $6"
        exit 1
fi

#Otwieramy vi w tle

nohup vi &>/dev/null &
#nohup przytrzymuje proces aby mogl trwac w tle
#niestety po sprawdzaniu kilka razy komenda ps
#proces i tak sam ginie
if [ $? == 0 ] ; then
        echo "11. Udalo sie uruchomic edytor vi w tle" >> raport.txt
else
        echo "Nie udalo sie uruchmoic edytora vi w tle"
        exit 1
fi
#zabijamy nasz proces
kill -SIGKILL $(pidof vi)

if [ $? == 0 ] ; then
        echo "12. Udalo sie zabic proces" >> raport.txt
else
        echo "12. Nie udalo sie zabic procesu, jednak jest to koncowka skryptu dlatego" >> raport.txt
        echo "nie zostanie zatrzymany. Prawie sie udalo" >> raport.txt
fi

echo "Jesli jest 12 krokow, to wszystko poszlo tak jak zakladalem" >> raport.txt
echo "Gratuluje !!" >> raport.txt
exit 0



