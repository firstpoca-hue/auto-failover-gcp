<?php
session_start();

if ($_POST['username'] && $_POST['password']) {
    include 'db.php';
    
    // Get user from database
    $stmt = $pdo->prepare("SELECT username, password FROM students WHERE username = ?");
    $stmt->execute([$_POST['username']]);
    $user = $stmt->fetch();
    
    // Verify password
    if ($user && password_verify($_POST['password'], $user['password'])) {
        $_SESSION['logged_in'] = true;
        $_SESSION['username'] = $_POST['username'];
        header("Location: dashboard.php");
        exit;
    }
}

header("Location: index.php?error=1");
?>