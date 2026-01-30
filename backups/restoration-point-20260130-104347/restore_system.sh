#!/bin/bash
# 🔄 Sistema de Restauración Completa
# Creado: $(date)
# Punto de restauración antes de mejoras UI/UX

set -e

echo "🔄 Iniciando restauración del sistema..."

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Obtener el directorio de este script
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_ROOT="/home/gidomare/sistema-antigravity"

echo -e "${YELLOW}⚠️  ADVERTENCIA: Esto restaurará el sistema al estado anterior a las mejoras UI/UX${NC}"
echo -e "${YELLOW}   - Se revertirá el código a la versión estable${NC}"
echo -e "${YELLOW}   - Se restaurará la base de datos${NC}"
echo ""
read -p "¿Deseas continuar? (yes/no): " -r
if [[ ! $REPLY =~ ^[Yy][Ee][Ss]$ ]]; then
    echo "Restauración cancelada."
    exit 1
fi

# 1. Restaurar código desde Git
echo -e "${GREEN}📦 Paso 1/4: Restaurando código desde Git...${NC}"
cd "$PROJECT_ROOT"

# Encontrar el tag más reciente de restauración
RESTORE_TAG=$(git tag -l "v1.0-stable-*" | sort -r | head -1)

if [ -z "$RESTORE_TAG" ]; then
    echo -e "${RED}❌ No se encontró tag de restauración${NC}"
    exit 1
fi

echo "   Restaurando a tag: $RESTORE_TAG"
git checkout "$RESTORE_TAG"

# 2. Restaurar base de datos
echo -e "${GREEN}💾 Paso 2/4: Restaurando base de datos...${NC}"

if [ -f "$SCRIPT_DIR/database.sql" ]; then
    echo "   Importando dump de base de datos..."
    docker exec -i wms-db mysql -u root -proot wms_db < "$SCRIPT_DIR/database.sql"
    echo -e "${GREEN}   ✅ Base de datos restaurada${NC}"
else
    echo -e "${RED}   ❌ No se encontró database.sql${NC}"
    exit 1
fi

# 3. Limpiar cachés
echo -e "${GREEN}🧹 Paso 3/4: Limpiando cachés...${NC}"
docker exec wms-app php artisan optimize:clear
docker exec wms-app php artisan config:clear
docker exec wms-app php artisan view:clear
docker exec wms-app php artisan route:clear

# 4. Reiniciar servicios
echo -e "${GREEN}🔄 Paso 4/4: Reiniciando servicios...${NC}"
cd "$PROJECT_ROOT"
docker-compose restart wms-app

echo ""
echo -e "${GREEN}✅ ¡Restauración completada exitosamente!${NC}"
echo ""
echo "📊 Estado del sistema:"
echo "   - Código: $RESTORE_TAG"
echo "   - Base de datos: Restaurada desde backup"
echo "   - Cachés: Limpiados"
echo ""
echo "🌐 El sistema está listo en: http://localhost"
echo ""
