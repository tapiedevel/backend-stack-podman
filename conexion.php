<?php
$host = 'db'; // El nombre del servicio definido en el docker-compose
$db   = 'nombre_de_tu_base_de_datos';
$user = 'root';
$pass = 'root_password_seguro';
$charset = 'utf8mb4';

$dsn = "mysql:host=$host;dbname=$db;charset=$charset";

try {
     $pdo = new PDO($dsn, $user, $pass);
     echo "¡Conexión PDO exitosa a MySQL!";
} catch (\PDOException $e) {
     throw new \PDOException($e->getMessage(), (int)$e->getCode());
}
?>
