# WMS - Sistema de Gestión de Internet (v1.0.0)

Sistema profesional de gestión de clientes e integraciones (Wisphub/Mikrotik) diseñado con una interfaz ultra-densa estilo SaaS.

## 🚀 Despliegue Rápido (VPS)

Para desplegar este sistema en un VPS con un solo comando, asegúrate de tener instalado **Docker** y **Docker Compose**, luego ejecuta:

```bash
git clone <URL_REPOSITORIO> . && cp .env.example .env && docker compose up -d --build
```

### ⚙️ Pasos Post-Instalación
1. **Generar Key**: `docker compose exec app php artisan key:generate`
2. **Migrar Base de Datos**: `docker compose exec app php artisan migrate --force`
3. **Sincronizar Wisphub**: `docker compose exec app php artisan tinker --execute="(new \App\Services\Integrations\WisphubService())->sync()"`

## ✨ Características Principales
- **Interfaz SaaS Pro**: Diseño ultra-denso sin scroll lateral.
- **Sincronización Wisphub**: Gestión total de clientes, planes y servicios.
- **Modo Oscuro**: Tema premium persistente.
- **Acciones Rápidas**: Control de activación/suspensión manual de clientes.

## 🛠️ Requerimientos
- Docker 20.10+
- Docker Compose v2.0+
- 1GB RAM (Mínimo recomendado)

---
Desarrollado con ❤️ para gestión eficiente de ISP.
