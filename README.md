# DevOps Course - HW 13

## Содержимое проекта
* `Lab_13_http.py` — исходный код Python HTTP-сервера.
* `http_python.service` — конфигурационный файл службы systemd.
* `deployed_app_python.sh` — Bash-скрипт для автоматического развертывания.

## Требования
* Права суперпользователя (`sudo`)
* Установленный `git` и `curl`

## Как запустить деплой

1. Сделайте скрипт исполняемым:
   ```bash
   chmod +x deployed_app_python.sh