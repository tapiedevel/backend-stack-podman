#!/bin/bash

# --- CONFIGURACIÓN ---
FECHA=$(date +%Y-%m-%d_%H-%M)
DESTINO="./backups"
DB_CONTAINER="servidor-mysql"
NOMBRE_BACKUP="backup_stack_$FECHA.tar.gz"

if [ -z "$1" ]; then
    echo "Uso: $0 <password_mysql_root>"
    exit 1
fi
MYSQL_ROOT_PASSWORD="$1"

mkdir -p $DESTINO

echo "🚀 Iniciando backup del stack LAMP..."

# 1. Exportar cada base de datos en archivo SQL separado
echo "📦 Exportando bases de datos..."
DATABASES=$(podman exec $DB_CONTAINER mysql -u root -p$MYSQL_ROOT_PASSWORD -N -e "SHOW DATABASES;" 2>/dev/null | grep -v -E '(information_schema|performance_schema|mysql|sys)')
SQL_FILES=""
for DB in $DATABASES; do
    SQL_FILE="$DESTINO/${DB}_$FECHA.sql"
    podman exec $DB_CONTAINER mysqldump -u root -p$MYSQL_ROOT_PASSWORD --single-transaction "$DB" > "$SQL_FILE"
    SQL_FILES="$SQL_FILES $SQL_FILE"
    echo "   - $DB exportado"
done

# 2. Comprimir código fuente (www), bases de datos (SQL) y configuración (docker-compose)
echo "🗜️ Comprimiendo archivos..."
tar --exclude='node_modules' -czf "$DESTINO/$NOMBRE_BACKUP" \
    ./www \
    ./dockerfile \
    ./docker-compose.yml \
    $SQL_FILES

# 3. Limpiar archivos SQL temporales
rm $SQL_FILES

echo "✅ Backup completado con éxito: $DESTINO/$NOMBRE_BACKUP"
echo "-------------------------------------------------------"
