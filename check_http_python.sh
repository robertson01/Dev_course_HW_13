#!/bin/bash
SERVICE_NAME="http_python.service"
PORT="8080"
HEALTH_URL="http://localhost:$PORT/health"

check_status=$(systemctl status $SERVICE_NAME | awk '/Active:/ {print $2}')
if [ "$check_status" != "active" ]; then
    echo $SERVICE_NAME "не активен, рестарт службы"
    sudo systemctl restart $SERVICE_NAME
else
    echo "Служба $SERVICE_NAME($check_status)-работает" 
fi


if nc -zv localhost "$PORT" 2>&1 | grep -q "succeeded"; then
    echo "Порт $PORT открыт и слушается"
else
    echo "Порт $PORT недоступен!"
    exit 1
fi


RESPONSE=$(curl -s "$HEALTH_URL")
if [[ "$RESPONSE" == *"ok"* ]]; then 
    echo "Эндпоинт /health ответил верно"
else
    echo "Эндпоинт /health ответил не верно"
    exit 1
fi

