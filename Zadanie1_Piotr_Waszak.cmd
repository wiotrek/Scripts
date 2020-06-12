REM PIOTR WASZAK
@echo off
REM Wylacza nazwy komend 
ECHO [DEBUG] %0 %*
REM przystawka debug pokazuje w jaki sposob CMD interptuje wszyskie parametry
IF "%1" == "/?" GOTO :PokazSkladnie
IF "%~5" == "" GOTO :ZLASKLADNIA
REM zaznaczamy ze musi istniec 5 parametrow dodajac ~ jestesmy pewni ze uzytkownik
REM nie wpisze nam pustego parametru w cudzyslowiu
IF NOT EXIST "%~1\." ECHO Katalog nie istnieje: %~1
IF NOT EXIST "%~1\." GOTO :PokazSkladnie
REM jesli pierwszy parametr i jak nizej kazdy pozostaly 
REM nie istnieje to wyswietla sie komunikat i przechodzi do funkcji :pokazskladnie
REM dzieki ~ uzytkownik nie musi martwic sie o cudzyslow
IF NOT EXIST "%~2" ECHO Plik nie istnieje: %~2
IF NOT EXIST "%~2" GOTO :PokazSkladnie

IF NOT EXIST "%~3" ECHO Plik nie istnieje: %~3
IF NOT EXIST "%~3" GOTO :PokazSkladnie

IF NOT EXIST "%~4" ECHO Katalog nie istnieje: %~4
IF NOT EXIST "%~4" GOTO :PokazSkladnie

IF NOT EXIST "%~5" ECHO Plik nie istnieje: %~5
IF NOT EXIST "%~5" GOTO :PokazSkladnie

REM Jesli parametry sa poprawne skrypt przechodzi do funkcji :Poczatek

:Poczatek
DIR
REM wyswietla zawartosc katalogu
IF ERRORLEVEL 1 GOTO :BoToZlaKomenda
REM ERRORLEVEL sprawdza czy polecenie jest poprawne
REM 1 oznacza ze jesli jest blad 1, to program przechodzi do funkcji :BoToZlaKomenda
CD /D %1
REM CD przechodzi do katalogu z parametru pierwszego
IF ERRORLEVEL 1 GOTO :BoToZlaKomenda
TREE
REM Wyswietla drzewo katalgow
IF ERRORLEVEL 1 GOTO :BoToZlaKomenda
COPY %2 %4
REM kopiuje katalog ze sciezki z parametru 2 do sciezki z parametru 4
IF ERRORLEVEL 1 GOTO :BoToZlaKomenda
MOVE %3 %4
REM przenosi katalog ze sciezki z parametru 3 do sciezki z parametru 4
IF ERRORLEVEL 1 GOTO :BoToZlaKomenda
DEL %5
REM usuwa plik z parametru 5
IF ERRORLEVEL 1 GOTO :BoToZlaKomenda
GOTO EOF:
REM End of file konczy pozytywnie operacje

:BoToZlaKomenda
ECHO ostatnia komenda nie wykonala sie
GOTO :EOF

:ZLASKLADNIA
ECHO SKLADNIA NIEPOPRAWNA
GOTO :PokazSkladnie
REM pokazuje skladnie z funkcji :PokazSkladnie
GOTO :EOF

:PokazSkladnie
ECHO.
REM wyswietla pusta linie
ECHO Skladnia: %0 ścieżkaDoKataloguP3 ścieżkaDoPlikuDoSkopiowaniaP5 ścieżkaDoPlikuDoPrzeniesieniaP5 sciezkaDoKataloguDocelowegoP5 sciezkaDoPlikuDoUsunieciaP6
ECHO.
GOTO :EOF