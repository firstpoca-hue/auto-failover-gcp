<?php
$host = '10.141.240.2';
$dbname = 'appdb';
$username = 'appuser';
$password = 'StrongPassword123!';

try {
    $options = [
        PDO::MYSQL_ATTR_SSL_VERIFY_SERVER_CERT => false,
        PDO::MYSQL_ATTR_SSL_CA => null,
        PDO::MYSQL_ATTR_SSL_CERT => null,
        PDO::MYSQL_ATTR_SSL_KEY => null,
        PDO::MYSQL_ATTR_SSL_MODE => PDO::MYSQL_SSL_MODE_DISABLED,
    ];
    $pdo = new PDO("mysql:host=$host;dbname=$dbname;sslmode=disable", $username, $password, $options);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
} catch (PDOException $e) {
    die("Connection failed: " . $e->getMessage());
}
?>