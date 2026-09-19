# Модель для сборки - плейлисты

[https://mds.redde.ru](https://mds.redde.ru)
[![Maintainability](https://api.codeclimate.com/v1/badges/45a9142908273b150803/maintainability)](https://codeclimate.com/github/arrowcircle/mds/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/45a9142908273b150803/test_coverage)](https://codeclimate.com/github/arrowcircle/mds/test_coverage)

## Зависимости

* Ruby 4.0+ / Node.js 24+ / pnpm 12 (версии в `mise.toml`)
* Postgresql 14+
* Imgproxy
* S3 (AWS или Minio)

## Конфигурация

Все настройки передаются через ENV-переменные. Список переменных можно посмотреть в `.env.sample`.

## Развертывание окружения разработки

* Установить toolchain через [mise](https://mise.jdx.dev): `mise install`
* Postgresql 14+, minio и Imgproxy — в систему или через Docker
* `cp .env.sample .env` и отредактировать значения
* `cp config/database.yml.sample config/database.yml` и отредактировать значения
* `bundle install && pnpm install`
* Создать бакеты public: `mds/images` и `cache` и private: `mds/audio`
