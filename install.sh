#!/bin/bash

set -e

echo "Copying configuration files..."

cp .env.example .env
cp docker/.env.example docker/.env

echo "Building and starting Docker containers..."

docker compose -f docker/docker-compose.yml down
docker compose -f docker/docker-compose.yml up -d --build

echo "Installing Composer dependencies..."
docker compose -f docker/docker-compose.yml exec -T app composer install

echo "Installing npm dependencies..."
docker compose -f docker/docker-compose.yml exec -T app npm install

echo "Generating application key..."
docker compose -f docker/docker-compose.yml exec -T app php artisan key:generate

echo "Waiting for MySQL to be ready..."
docker compose -f docker/docker-compose.yml exec -T app bash -c 'until php artisan tinker --execute="DB::connection()->getPdo();" >/dev/null 2>&1; do sleep 2; done; echo "MySQL is ready!"'

echo "Running migrations..."
docker compose -f docker/docker-compose.yml exec -T app php artisan migrate

echo "Installation completed!"