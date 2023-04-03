#!/bin/bash

VALHEIM_DIR="/home/fserver/valheim-server/serverfiles/"
SCREEN_NAME="valheim_server"
WEBHOOK_DISCORD="https://discord.com/api/webhooks/1091877560587124766/BltUqAhyqz7OXk6gDowTofABpOufim0c-21w8b0ym32hGLoFyFvFzzRZ-O1xahF4vi9a"

start_server() {
    cd "${VALHEIM_DIR}"
    curl -X POST -H "Content-Type: application/json" -d '{"content":"Start serveur"}' $WEBHOOK_DISCORD
    screen -dmS "${SCREEN_NAME}" ./start_server_bepinex.sh
    echo "Valheim server started!"
}

long_alert() {
    curl -X POST -H "Content-Type: application/json" -d '{"content":"Attention le serveur stop dans 10min"}' $WEBHOOK_DISCORD
    echo "Attention le serveur s'eteindra dans 10min"
}

short_alert() {
    curl -X POST -H "Content-Type: application/json" -d '{"content":"Attention le serveur stop dans 5min"}' $WEBHOOK_DISCORD
    echo "Attention le serveur s'eteint dans 5min"
}

stop_server() {
    curl -X POST -H "Content-Type: application/json" -d '{"content":"Arrêt programmé du serveur"}' $WEBHOOK_DISCORD
    echo "Valheim server stopped!"
    sleep 30m
    screen -S "${SCREEN_NAME}" -X quit
    curl -X POST -H "Content-Type: application/json" -d '{"content":"Serveur arrété"}' $WEBHOOK_DISCORD
    echo "Valheim server stopped!"
}

force_stop_server() {
    screen -S "${SCREEN_NAME}" -X quit
    sleep 10s
    curl -X POST -H "Content-Type: application/json" -d '{"content":"Serveur arrété"}' $WEBHOOK_DISCORD
    echo "Valheim server force stopped!"
    sudo reboot
}

status_server() {
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
