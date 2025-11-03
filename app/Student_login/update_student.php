<?php
session_start();
if (!isset($_SESSION['logged_in'])) {
    header("Location: index.php");
    exit;
}

include 'db.php';

try {
    $stmt = $pdo->prepare("UPDATE students SET full_name = ?, email = ?, phone = ?, course = ?, year = ? WHERE username = ?");
    $stmt->execute([
        $_POST['full_name'],
        $_POST['email'],
        $_POST['phone'],
        $_POST['course'],
        $_POST['year'],
        $_SESSION['username']
    ]);
    
    header("Location: dashboard.php?updated=1");
} catch (Exception $e) {
    header("Location: edit.php?error=1");
}
?>