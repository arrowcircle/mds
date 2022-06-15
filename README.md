# Модель для сборки - плейлисты

[https://mds.redde.ru](https://mds.redde.ru)
[![Build Status](https://travis-ci.org/arrowcircle/mds.svg?branch=master)](https://travis-ci.org/arrowcircle/mds)
[![Maintainability](https://api.codeclimate.com/v1/badges/45a9142908273b150803/maintainability)](https://codeclimate.com/github/arrowcircle/mds/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/45a9142908273b150803/test_coverage)](https://codeclimate.com/github/arrowcircle/mds/test_coverage)

## Зависимости

* Ruby 3.1+
* Postgresql 14+
* Imgproxy
* S3 (AWS или Minio)

## Конфигурация

Все настройки передаются через ENV-переменные. Список переменных можно посмотреть в `.env.sample`.

## Развертывание окружения разработки

* Настроить стандартное оружение Rails: Ruby 3.1.2, Postgresql 14. Устанавливать руби можно через asdf, rvm ,rbenv или через Docker.
* Установить minio в систему или через докер
* Установить Imgproxy в систему или через докер
* `cp .env.sample .env` и отредактировать значения
* `cp config/database.yml.sample config/database.yml` и отредактировать значения
* Создать бакеты public: `mds/images` и `cache` и private: `mds/audio`

## Werf

* Установить [multiwerf](https://github.com/flant/multiwerf)
* Инициализировать в терминале `. $(multiwerf use 1.1 stable --as-file)`
* Запустить сборку `werf build-and-publish --stages-storage :local --images-repo arrowcircle/mds --tag-git-tag v0.1.6`
