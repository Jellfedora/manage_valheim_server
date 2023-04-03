# Valheim Server Manager

Ce script en bash permet de gérer facilement un serveur Valheim, en lançant le serveur, en le stoppant, en vérifiant son statut, etc.
Il appelle start_server_bepinex.sh penser à le modifier si votre serveur n'utilise pas bepinex!

## Configuration

Le fichier de configuration se trouve en haut du script manage-server.sh et peut être modifié en fonction de vos besoins :

- `VALHEIM_DIR` : Le dossier d'installation du serveur Valheim.
- `SCREEN_NAME` : Le nom de la session screen dans laquelle le serveur Valheim sera lancé.
- `WEBHOOK_DISCORD` : L'URL du webhook Discord pour les notifications.

Est inclus aussi le install-server.sh pour installer valheim via Steam CLI

## Utilisation

Les commandes disponibles sont :

- `start` : Lance le serveur Valheim et vérifie si une mise à jour est disponible, si oui il l'installe
- `long` : Envoie une alerte pour signaler que le serveur va être stoppé dans 10 minutes.
- `short` : Envoie une alerte pour signaler que le serveur va être stoppé dans 5 minutes.
- `stop` : Arrête le serveur Valheim et redémarre la machine.
- `force` : Arrête immédiatement le serveur Valheim.
- `status` : Affiche le statut du serveur Valheim.

Exemple d'utilisation : `./valheim-server-manager.sh start`

## Exemples de tâches cron

A installer avec `sudo crontab -e

### Message arret 10min

20 5 \* \* \* /path_to_folder/manage_valheim_server/manage-server.sh long

### Message arret 5min

25 5 \* \* \* /path_to_folder/manage_valheim_server/manage-server.sh short

### Arret du serveur

56 23 \* \* \* sudo path_to_folder/manage_valheim_server/manage-server.sh stop

### Demarrage du serveur lors du redémarrage physique

@reboot /path_to_folder/manage_valheim_server/manage-server.sh start

Assurez-vous de modifier le chemin vers le fichier `valheim-server-manager.sh` en fonction de l'emplacement où vous l'avez enregistré.

## Avertissement

Ce script est fourni tel quel, sans garantie d'aucune sorte. Veuillez l'utiliser à vos propres risques.
