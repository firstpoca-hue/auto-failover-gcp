<?php
session_start();
include 'db.php';

try {
    // Check if username already exists
    $stmt = $pdo->prepare("SELECT id FROM students WHERE username = ?");
    $stmt->execute([$_POST['username']]);
    
    if ($stmt->fetch()) {
        header("Location: register.php?error=1");
        exit;
    }
    
    // Hash password for security
    $hashed_password = password_hash($_POST['password'], PASSWORD_DEFAULT);
    
    // Insert new student
    $stmt = $pdo->prepare("INSERT INTO students (username, password, full_name, email, phone, course, year) VALUES (?, ?, ?, ?, ?, ?, ?)");
    $stmt->execute([
        $_POST['username'],
        $hashed_password,
        $_POST['full_name'],
        $_POST['email'],
        $_POST['phone'],
        $_POST['course'],
        $_POST['year']
    ]);
    
    header("Location: index.php?message=account_created");
} catch (Exception $e) {
    header("Location: register.php?error=1");
}
?>