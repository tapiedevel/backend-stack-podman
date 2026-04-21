# Mi Stack LAMP en Podman

Servidor de desarrollo profesional para Linux con PHP, MySQL y Apache usando Podman.

## Estructura

```
.
├── www/              # Proyectos PHP (http://localhost:8080/mi-proyecto)
├── db_data/          # Datos MySQL (no borrar)
├── backups/          # Backups automáticos
├── dockerfile        # PHP 8.2 + PDO
├── docker-compose.yml
└── backup.sh        # Script de backup
```

## Requisitos

```bash
sudo dnf install podman-compose
```

## Uso

```bash
# Levantar servidores la primera vez
podman-compose up -d --build

# Detener
podman-compose stop

# Iniciar (si ya existe)
podman-compose start

# Ver contenedores
podman ps
```

## Acceso

| Servicio | URL | Credenciales |
|---|---|---|
| Web | http://localhost:8080 | - |
| phpMyAdmin | http://localhost:8081 | root / root_password_seguro |
| MySQL | host: `db`, puerto: `3306` | root / root_password_seguro |

## Backup

```bash
./backup.sh <password_mysql_root>
```

## Conexión PDO

```php
<?php
$host = 'db';
$db   = 'nombre_base';
$user = 'root';
$pass = 'root_password_seguro';

try {
    $pdo = new PDO("mysql:host=$host;dbname=$db;charset=utf8mb4", $user, $pass);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    echo "Conexión exitosa";
} catch (PDOException $e) {
    echo "Error: " . $e->getMessage();
}
```

## Solución de Problemas

**Permisos en /www:**
```bash
sudo chown -R $USER:$USER www/
```

**Abrir puertos en Fedora (firewalld):**
```bash
sudo firewall-cmd --permanent --add-port=8080/tcp
sudo firewall-cmd --permanent --add-port=8081/tcp
sudo firewall-cmd --reload
```
