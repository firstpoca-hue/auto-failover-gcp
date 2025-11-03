<?php
session_start();
if (!isset($_SESSION['logged_in'])) {
    header("Location: index.php");
    exit;
}

include 'db.php';

try {
    $stmt = $pdo->prepare("INSERT INTO students (username, full_name, email, phone, course, year) VALUES (?, ?, ?, ?, ?, ?)");
    $stmt->execute([
        $_SESSION['username'],
        $_POST['full_name'],
        $_POST['email'],
        $_POST['phone'],
        $_POST['course'],
        $_POST['year']
    ]);
    
    header("Location: dashboard.php?registered=1");
} catch (Exception $e) {
    header("Location: register.php?error=1");
}
?>