#!/bin/bash

VALHEIM_DIR=""
SCREEN_NAME="valheim_server"
WEBHOOK_DISCORD=""

start_server() {
    # Mise à jour ou install du serveur Valheim
    steamcmd +@sSteamCmdForcePlatformType linux +force_install_dir "${VALHEIM_DIR}" +login anonymous +app_update 896660 -beta none validate +quit
    if [ $? -ne 0 ]; then
        echo "Erreur lors de la mise à jour du serveur Valheim"
        exit 1
    fi
    
    # Lancement du serveur Valheim
    cd "${VALHEIM_DIR}"
    curl -X POST -H "Content-Type: application/json" -d '{"content":"Start serveur"}' $WEBHOOK_DISCORD
    screen -dmS "${SCREEN_NAME}" ./start_server_bepinex.sh
    echo "Valheim server started!"
}

long_alert() {
    # Simple message d'alerte
    curl -X POST -H "Content-Type: application/json" -d '{"content":"Attention le serveur stop dans 10min"}' $WEBHOOK_DISCORD
    echo "Attention le serveur s'eteindra dans 10min"
}

short_alert() {
    # Simple message d'alerte
    curl -X POST -H "Content-Type: application/json" -d '{"content":"Attention le serveur stop dans 5min"}' $WEBHOOK_DISCORD
    echo "Attention le serveur s'eteint dans 5min"
}

stop_server() {
    # Stop différé du serveur et le redémarre physiquement
    curl -X POST -H "Content-Type: application/json" -d '{"content":"Arrêt programmé du serveur"}' $WEBHOOK_DISCORD
    echo "Valheim server stopped!"
    sleep 30min
    screen -S "${SCREEN_NAME}" -X quit
    curl -X POST -H "Content-Type: application/json" -d '{"content":"Serveur arrété"}' $WEBHOOK_DISCORD
    echo "Valheim server stopped!"
    sudo reboot
}

force_stop_server() {
    # Stop immédiat
    screen -S "${SCREEN_NAME}" -X quit
    sleep 10s
    curl -X POST -H "Content-Type: application/json" -d '{"content":"Serveur arrété"}' $WEBHOOK_DISCORD
    echo "Valheim server force stopped!"
}

status_server() {
    # Donne le statut du serveur
    if screen -list | grep -q "${SCREEN_NAME}"; then
        curl -X POST -H "Content-Type: application/json" -d '{"content":"Le serveur est démarré"}' $WEBHOOK_DISCORD
        echo "Valheim server is running."
    else
        curl -X POST -H "Content-Type: application/json" -d '{"content":"Le serveur est hors-ligne"}' $WEBHOOK_DISCORD
        echo "Valheim server is not running."
    fi
}

case "$1" in
    start)
        start_server
    ;;
    long)
        long_alert
    ;;
    short)
        short_alert
    ;;
    stop)
        stop_server
    ;;
    force)
        force_stop_server
    ;;
    status)
        status_server
    ;;
    *)
        echo "Usage: $0 {start|long|short|stop|force|status}"
        exit 1
    ;;
esac

exit 0
