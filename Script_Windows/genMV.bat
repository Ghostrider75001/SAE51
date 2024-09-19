@echo off
setlocal enabledelayedexpansion

REM Variables
set /p MACHINE_NAME=Entrez le nom de la machine virtuelle (par défaut Debian1) : 
set MACHINE_NAME=!MACHINE_NAME:-Debian1!

set /p RAM_SIZE=Entrez la taille de la RAM en Mo (par défaut 4096 Mo) : 
set RAM_SIZE=!RAM_SIZE:-4096!

set /p DISK_SIZE=Entrez la taille du disque en Go (par défaut 20Go) : 
set DISK_SIZE=!DISK_SIZE:-20!

REM Convertir la taille du disque de Go en GiB
set /a DISK_SIZE_GiB=DISK_SIZE * 9313 / 10000

set ISO_PATH=C:\path\to\debian-netinst.iso
set TFTP_SERVER=your_tftp_server_path
set USER_ID=%USERNAME%
set ERROR_LOG=error_%~n0.txt

REM Fonction pour enregistrer les erreurs
:log_error
set error_code=%1
set command=%2
echo Erreur lors de l'exécution de la commande: '%command%' avec le code d'erreur: !error_code! >> %ERROR_LOG%

REM Fonction pour lister les machines
:list_machines
vboxmanage list vms

REM Fonction pour créer une nouvelle machine
:create_machine
vboxmanage showvminfo !MACHINE_NAME! >nul 2>nul
if !errorlevel! equ 0 (
    echo Une machine nommée '!MACHINE_NAME!' existe déjà. Suppression en cours...
    call :delete_machine
)

echo Création de la machine '!MACHINE_NAME'...
vboxmanage createvm --name !MACHINE_NAME! --ostype Debian_64 --register 2>> %ERROR_LOG%
if not errorlevel 1 (
    call :log_error "vboxmanage createvm" !errorlevel!
)
vboxmanage modifyvm !MACHINE_NAME! --memory !RAM_SIZE! --cpus 2 --nic1 nat --boot1 net 2>> %ERROR_LOG%
if not errorlevel 1 (
    call :log_error "vboxmanage modifyvm" !errorlevel!
)
vboxmanage createhd --filename "!MACHINE_NAME.vdi" --size !DISK_SIZE! 2>> %ERROR_LOG%
if not errorlevel 1 (
    call :log_error "vboxmanage createhd" !errorlevel!
)
vboxmanage storagectl !MACHINE_NAME! --name "SATA Controller" --add sata --controller IntelAhci 2>> %ERROR_LOG%
if not errorlevel 1 (
    call :log_error "vboxmanage storagectl" !errorlevel!
)
vboxmanage storageattach !MACHINE_NAME! --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium "!MACHINE_NAME.vdi" 2>> %ERROR_LOG%
if not errorlevel 1 (
    call :log_error "vboxmanage storageattach (HDD)" !errorlevel!
)
vboxmanage storageattach !MACHINE_NAME! --storagectl "SATA Controller" --port 1 --device 0 --type dvddrive --medium "%ISO_PATH%" 2>> %ERROR_LOG%
if not errorlevel 1 (
    call :log_error "vboxmanage storageattach (DVD)" !errorlevel!
)

REM Ajouter des métadonnées
set CREATION_DATE=%date% %time%
vboxmanage setextradata !MACHINE_NAME! "creation_date" "!CREATION_DATE!" 2>> %ERROR_LOG%
if not errorlevel 1 (
    call :log_error "vboxmanage setextradata (creation_date)" !errorlevel!
)
vboxmanage setextradata !MACHINE_NAME! "creator" "!USER_ID!" 2>> %ERROR_LOG%
if not errorlevel 1 (
    call :log_error "vboxmanage setextradata (creator)" !errorlevel!
)

echo Machine '!MACHINE_NAME!' créée avec succès.


REM Fonction pour supprimer une machine
:delete_machine
vboxmanage unregistervm !MACHINE_NAME! --delete >nul 2>nul
if not errorlevel 1 (
    call :log_error "vboxmanage unregistervm" !errorlevel!
)
echo Machine '!MACHINE_NAME!' supprimée.

REM Fonction pour démarrer une machine
:start_machine
vboxmanage startvm !MACHINE_NAME! --type headless 2>> %ERROR_LOG%
if not errorlevel 1 (
    call :log_error "vboxmanage startvm" !errorlevel!
)
echo Machine '!MACHINE_NAME!' démarrée.

REM Fonction pour arrêter une machine
:stop_machine
vboxmanage controlvm !MACHINE_NAME! poweroff 2>> %ERROR_LOG%
if not errorlevel 1 (
    call :log_error "vboxmanage controlvm poweroff" !errorlevel!
)
echo Machine '!MACHINE_NAME!' arrêtée.

REM Vérification des arguments
if "%~1"=="" (
    echo Usage: %0 [L|N|S|D|A] [nom_machine]
    exit /b 1
)

set ACTION=%~1
set MACHINE_NAME=%~2
if "%MACHINE_NAME%"=="" set MACHINE_NAME=!MACHINE_NAME!

if "%ACTION%"=="L" (
    call :list_machines
) else if "%ACTION%"=="N" (
    call :create_machine
    timeout /t 5 >nul
) else if "%ACTION%"=="S" (
    call :delete_machine
) else if "%ACTION%"=="D" (
    call :start_machine
) else if "%ACTION%"=="A" (
    call :stop_machine
) else (
    echo Action non reconnue : %ACTION%
    exit /b 1
)

REM Ouvrir le fichier de log d'erreurs automatiquement
if exist "%ERROR_LOG%" (
    start "" "%ERROR_LOG%"
)