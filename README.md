# Приложение представляет собой простой веб-сервер, который отвечает на запросы по адресу http://localhost:80/ 
## Приложение возвращает основнные метрики мониторинга Docker контейров, которые бегут позади веб-сервера, такие как CPU MEM DISK INODE.
## Приложение написано на языке BASH
## Структура приложения:
- Корневая директория приложения: /app
  Которая содержит следующие файлы:
  - index.html - файл с HTML разметкой
  - data.json - файл с данными метрик
  - Dockerfile - файл с инструкциями для сборки Docker образа
  - nginx.conf - файл с конфигурацией nginx в контейнере
  - README.md - файл с описанием приложения
- Директория /app/scripts
  Которая содержит следующие файлы:
  - app.sh - файл с основным кодом приложения
- Директория /app/.github/workflows
  Которая содержит следующие файлы:
  - docker-image.yml - файл с инструкциями для тестовой сборки Docker образа
  - docker-publish.yml - файл с инструкциями для публикации Docker образа в Docker Hub:
    - https://hub.docker.com/repository/docker/popadukdv/basic_metrics
- Директория /app/and_user_files
  Которая содержит следующие файлы:
  - Docker-compose.yml - файл с инструкциями для запуска приложения в Docker контейнере
  - Dockerfile - файл с инструкциями для сборки Docker образа
  - nginx.conf - файл с конфигурацией nginx web-сервера
## Логика работы приложения:
- Приложение запускается в Docker контейнере с помощью Docker-compose и Dockerfile в директории /app/and_user_files. Для запуска приложения необходимо выполнить команду:
  - docker-compose up -d
- Поднимается веб-сервер nginx, который слушает порт 80 и отвечает на запросы по адресу http://localhost:80/ и c помощью load balancer проксирует запросы к приложения поднятым в 2-x других Docker контейнерах
- Если Вы сделаете изменения в коде приложения, отправте изменения в репозиторий на GitHub, то GitHub Actions автоматически соберет новый Docker образ и опубликует его в Docker Hub: - https://hub.docker.com/repository/docker/popadukdv/basic_metrics
- Дериктория /app/and_user_files ни как не связана с приложением, она нужна для того, чтобы Вы могли запустить приложение в Docker контейнере на своем компьютере и  может распространяться отдельно от приложения.
## Требования
- Для запуска приложения необходимо чтобы на компьютере был установлен Docker Engine