markdown
# Utilisation du Script de Gestion des Machines Virtuelles VirtualBox

## Aperçu

Ce script automatise la gestion des machines virtuelles (VMs) VirtualBox, permettant aux utilisateurs de créer, supprimer, démarrer, arrêter et lister les VMs avec des métadonnées telles que la date de création et le créateur. Le script capture les codes d'erreur des commandes et les enregistre dans un fichier pour faciliter le débogage.

## Nom du Script

`genMV.sh`

## Prérequis

- VirtualBox doit être installé sur votre système.
- L'outil en ligne de commande `VBoxManage` doit être accessible depuis votre terminal.
- Une image ISO de Debian (netinst) doit être disponible à l'emplacement spécifié dans le script.
- Assurez-vous que le serveur TFTP est correctement configuré si vous utilisez des options de démarrage PXE.

## Comment Utiliser

1. **Rendre le script exécutable :**

bash
   chmod +x genMV.sh

2. **Run the script with the appropriate command:**

   ### Options de Commande
   - `I` - Liste toutes les VMs enregistrées.
   - `L` - Liste toutes les VMs enregistrées avec les métadonnées (date de création et créateur).
   - `N [VM_NAME]` - Créer une nouvelle VM avec le nom spécifié (Par défaut `Debian1`).
   - `S [VM_NAME]` - Supprimer la VM spécifiée.
   - `D [VM_NAME]` - Démarrer la VM spécifiée.
   - `A [VM_NAME]` - Arrêter la VM spécifiée.

   ### Exemples d'Utilisation
   - Pour créer une nouvelle VM nommée `Debian1`:
   
   bash
   ./genMV.sh N Debian1

   - Pour lister toutes les VMs avec leurs métadonnées :

   bash
   ./genMV.sh L

3. **Journalisation des Erreurs :**
   - Si une commande échoue, le code d'erreur et la commande ayant échoué seront enregistrés dans un fichier nommé `error_genMV.sh.txt`.
   - Le fichier de journal d'erreurs s'ouvrira automatiquement après l'exécution du script.

## Limitations

- Le script est conçu pour gérer une seule VM à la fois. Essayer de créer plusieurs VMs simultanément peut entraîner des conflits.
- Le script suppose que le nom de VM par défaut est `Debian1` usauf indication contraire. Si une VM portant le même nom existe, elle sera supprimée automatiquement.
- Assurez-vous que les chemins spécifiés pour l'image ISO et le serveur TFTP sont corrects et accessibles.

## Problèmes Courants

- **Permission Refusée**: Si vous rencontrez une erreur de permission lors de l'exécution du script, assurez-vous d'avoir les permissions nécessaires pour exécuter les commandes `VBoxManage` .
- **ISO Manquante**: Si le chemin du fichier ISO est incorrect ou si le fichier n'existe pas, le script échouera lors du processus de création de la VM.
- **VirtualBox Introuvable**: Si `VBoxManage` n'est pas trouvé, assurez-vous que VirtualBox est installé et que ses binaires sont dans le PATH de votre système.

## Conclusion

Ce script simplifie la gestion des machines virtuelles VirtualBox grâce à des commandes automatisées et à la journalisation des erreurs.

