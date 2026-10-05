#!/bin/bash

APP_USER="web-user"
APP_DIR="/opt/http-python-app"
LOG_FILE="/var/log/http-server-deploy.log"
SERVICE_NAME="http_python.service"
REPO_URL="https://github.com/robertson01/Dev_course_HW_13.git" # 
HEALTH_URL="http://localhost:8080/health"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}

if id $APP_USER >/dev/null 2>&1; then
    log "Пользователь $APP_USER уже существует"
else
    useradd -r $APP_USER
    log "Пользователь $APP_USER создан"
fi

if [ -d "$APP_DIR" ]; then
    log "Директория проекта уже существует"
else
    mkdir -p "$APP_DIR"
    sudo chown -R "$APP_USER:$APP_USER" "$APP_DIR"
    log "Директория проекта создана"
fi


log "Клонируем репозиторий..."
if sudo git clone "$REPO_URL" "$APP_DIR"; then
    log "Скачивание репозитория завершено успешно."
    sudo chown -R "$APP_USER:$APP_USER" "$APP_DIR"
else
    log "ОШИБКА: Не удалось клонировать репозиторий."
    exit 1
fi

log "Настраиваем службу systemd..."
sudo cp "$APP_DIR/http_python.service" /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable "$SERVICE_NAME"
sudo systemctl restart "$SERVICE_NAME"

sleep 2

log "Проверяем эндпоинт /health..."
RESPONSE=$(curl -s "$HEALTH_URL")
log "Ответ сервера: $RESPONSE"

if [[ "$RESPONSE" == *"ok"* ]]; then
    log "УСПЕХ: Приложение успешно развернуто и работает!"
    exit 0
else
    log "ОШИБКА: Эндпоинт не вернул 'ok'."
    exit 1
fi