#!/bin/bash

# Fichier de log pour les erreurs
log_file="log.txt"

# Écraser le fichier log à chaque exécution
> "$log_file"

# Fonction d'affichage de l'aide
function usage {
  echo "Usage: $0 L | N [nom_machine1 nom_machine2 ...] | S [nom_machine] | D [nom_machine1 nom_machine2 ...] | A [nom_machine1 nom_machine2 ...] | R"
  echo "Options:"
  echo "  L                         : Liste toutes les machines virtuelles"
  echo "  N [nom_machine1 ...]     : Crée une ou plusieurs nouvelles machines virtuelles"
  echo "  S [nom_machine]           : Supprime la machine virtuelle spécifiée"
  echo "  D [nom_machine1 ...]      : Démarre une ou plusieurs machines virtuelles"
  echo "  A [nom_machine1 ...]      : Arrête une ou plusieurs machines virtuelles"
  echo "  R                         : Supprime toutes les machines virtuelles"
  exit 1
}

# Vérification des arguments
if [ $# -eq 0 ]; then
  usage
fi

# Redirection des erreurs vers le fichier de log
exec 2>>"$log_file"

case "$1" in
  L)
    VBoxManage list vms 2>>"$log_file"
    ;;
  N)
    # Création d'une ou plusieurs nouvelles machines
    shift
    if [ $# -eq 0 ]; then
      usage
    fi

    for nom_machine in "$@"; do
      # Demander les paramètres de la VM
      read -p "Entrez la RAM pour $nom_machine (défaut: 4096 Mo) : " ram
      ram=${ram:-4096}
      
      read -p "Entrez la taille du disque pour $nom_machine (défaut: 10 GiB) : " disk
      disk=${disk:-10G}
      
      read -p "Entrez le chemin de l'ISO pour $nom_machine (défaut: /home/kali/Download/lubuntu.iso) : " iso
      iso=${iso:-/home/kali/Download/lubuntu.iso}

      # Création de la VM
      VBoxManage createvm --name "$nom_machine" --register 2>>"$log_file"
      VBoxManage modifyvm "$nom_machine" --memory "$ram" --cpus 2 --ostype Ubuntu_64 2>>"$log_file"
      VBoxManage createhd --filename "$nom_machine.vdi" --size "${disk%G*}000" --format VDI 2>>"$log_file"
      VBoxManage storagectl "$nom_machine" --name "SATA Controller" --add sata --controller IntelAhci 2>>"$log_file"
      VBoxManage storageattach "$nom_machine" --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium "$nom_machine.vdi" 2>>"$log_file"
      VBoxManage storageattach "$nom_machine" --storagectl "SATA Controller" --port 1 --device 0 --type dvddrive --medium "$iso" 2>>"$log_file"

      # Ajout des méta-données
      VBoxManage modifyvm "$nom_machine" --description "Machine virtuelle créée avec genMV.sh"
      
      # Enregistrement des métadonnées dans le fichier log
      {
        echo "Machine virtuelle créée : $nom_machine"
        echo "RAM : $ram Mo"
        echo "Disque : $disk"
        echo "ISO : $iso"
        echo "Date de création : $(date)"
      } >> "$log_file"

      echo "Machine virtuelle $nom_machine créée."
    done
    ;;
  S)
    # Suppression d'une machine
    shift
    if [ -z "$1" ]; then
      usage
    fi
    VBoxManage unregistervm "$1" --delete 2>>"$log_file"
    echo "Machine virtuelle supprimée : $1"
    ;;
  D)
    # Démarrage d'une ou plusieurs machines
    shift
    if [ $# -eq 0 ]; then
      usage
    fi
    for vm in "$@"; do
      VBoxManage startvm "$vm" --type headless 2>>"$log_file"
      echo "Machine virtuelle démarrée : $vm"
    done
    ;;
  A)
    # Arrêt d'une ou plusieurs machines
    shift
    if [ $# -eq 0 ]; then
      usage
    fi
    for vm in "$@"; do
      VBoxManage controlvm "$vm" poweroff 2>>"$log_file"
      echo "Machine virtuelle arrêtée : $vm"
    done
    ;;
  R)
    # Suppression de toutes les machines virtuelles
    for vm in $(VBoxManage list vms | awk '{print $1}' | tr -d '"'); do
      VBoxManage unregistervm "$vm" --delete 2>>"$log_file"
      echo "Machine virtuelle supprimée : $vm"
    done
    echo "Toutes les machines virtuelles ont été supprimées."
    ;;
  *)
    usage
    ;;
esac
