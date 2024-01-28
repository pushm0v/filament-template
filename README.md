# APP NAME
---
## Start local development
### Dashboard (Laravel)
- Ensure you have docker engine, & docker-compose installed on your workstation
- Copy `.env.example` file from `laravel/` and rename it to `.env`. Make any change if necessary
- Startup services by command `docker-compose up -d`
- Wait until all services up and running
- If `APP_KEY` is empty, generate new key by command `make exec arg="php artisan key:generate --show"`
- Install all composer dependencies, `make exec arg="composer install"`
- Migrate the database, `make migrateup`
- Execute Filament Shield plugin, `make exec arg="php artisan shield:install --fresh"`
- Create new admin user, `make createuser`
- Run all database seeders, `make allseeder`
- Open browser and go to http://localhost:8000/admin to login with your admin credential