# Script de Gestion de Machines Virtuelles - genMV.sh

## Description
Le script `genMV.sh` permet de gérer des machines virtuelles à l'aide de VirtualBox. Il offre des fonctionnalités pour créer, lister, démarrer, arrêter et supprimer des machines virtuelles, ainsi que pour enregistrer les actions et les erreurs dans un fichier de log.

## Fonctionnalités
- **Lister les machines virtuelles**
- **Créer une nouvelle machine virtuelle** avec des options personnalisables (nom, RAM, taille du disque, chemin ISO).
- **Supprimer une machine virtuelle** spécifiée.
- **Démarrer une machine virtuelle** spécifiée.
- **Arrêter une machine virtuelle** spécifiée.
- **Supprimer toutes les machines virtuelles** en une seule commande.
- **Enregistrer les métadonnées** des machines virtuelles créées.
- **Gérer les erreurs** en redirigeant les messages d'erreur dans un fichier de log.

## Prérequis
- VirtualBox doit être installé sur votre système.
- `VBoxManage` doit être accessible depuis le terminal.
- Un environnement de bureau pour l'utilisation de `xdg-open` (pour ouvrir le fichier log).

## Installation
1. Clonez ce dépôt ou téléchargez le fichier `genMV.sh`.
2. Rendez le script exécutable :

bash
   chmod +x genMV.sh

## Utilisation
Exécutez le script avec les options suivantes :

bash
./genMV.sh [OPTION] [ARGUMENT]

### Options disponibles
- `L` : Lister toutes les machines virtuelles.
- `N [nom]` : Créer une nouvelle machine virtuelle. Si le nom n'est pas spécifié, un nom par défaut sera utilisé (`Debian1`).
- `S [nom]` : Supprimer la machine virtuelle spécifiée.
- `D [nom]` : Démarrer la machine virtuelle spécifiée en mode headless.
- `A [nom]` : Arrêter la machine virtuelle spécifiée.
- `R` : Supprimer toutes les machines virtuelles.

### Exemples d'utilisation
1. Lister les machines virtuelles :

bash
   ./genMV.sh L

2. Créer une nouvelle machine virtuelle :

bash
   ./genMV.sh N

or 

bash
   ./genMV.sh N Debian1

or 

bash
   ./genMV.sh N Debian1 Debian2

3. Supprimer une machine virtuelle :

bash
   ./genMV.sh S NomDeLaVM

4. Démarrer une machine virtuelle :

bash
   ./genMV.sh D NomDesVM

5. Arrêter une machine virtuelle :

bash
   ./genMV.sh A NomDesVM

6. Supprimer toutes les machines virtuelles :

bash
   ./genMV.sh R

## Fichier Log
Un fichier `log.txt` sera créé dans le répertoire courant pour enregistrer toutes les actions et les erreurs générées par le script. Ce fichier sera écrasé à chaque exécution du script.

## Avertissements
- Assurez-vous d'avoir les permissions nécessaires pour exécuter les commandes avec `VBoxManage`.
- Utiliser la commande de suppression (`S` ou `R`) avec prudence, car cela supprimera définitivement les machines virtuelles.

## Contribution
Les contributions sont les bienvenues. N'hésitez pas à soumettre des suggestions ou des améliorations.
