<?php
session_start();
if (!isset($_SESSION['logged_in'])) {
    header("Location: index.php");
    exit;
}

include 'db.php';
$stmt = $pdo->prepare("SELECT * FROM students WHERE username = ?");
$stmt->execute([$_SESSION['username']]);
$student = $stmt->fetch();
?>
<!DOCTYPE html>
<html>
<head>
    <title>Student Dashboard</title>
    <style>
        body { font-family: Arial; max-width: 600px; margin: 50px auto; padding: 20px; }
        .info { background: #f0f0f0; padding: 15px; margin: 20px 0; }
        .success { color: green; margin: 10px 0; }
        button { background: #dc3545; color: white; padding: 8px 16px; border: none; cursor: pointer; }
    </style>
</head>
<body>
    <h2>Welcome, <?php echo htmlspecialchars($_SESSION['username']); ?>!</h2>
    
    <?php if (isset($_GET['registered'])): ?>
        <div class="success">Registration completed successfully!</div>
    <?php endif; ?>
    
    <?php if (isset($_GET['updated'])): ?>
        <div class="success">Profile updated successfully!</div>
    <?php endif; ?>
    
    <?php if ($student): ?>
        <div class="info">
            <h3>Your Registration Details:</h3>
            <p><strong>Name:</strong> <?php echo htmlspecialchars($student['full_name']); ?></p>
            <p><strong>Email:</strong> <?php echo htmlspecialchars($student['email']); ?></p>
            <p><strong>Phone:</strong> <?php echo htmlspecialchars($student['phone']); ?></p>
            <p><strong>Course:</strong> <?php echo htmlspecialchars($student['course']); ?></p>
            <p><strong>Year:</strong> <?php echo htmlspecialchars($student['year']); ?></p>
        </div>
    <?php endif; ?>
    
    <a href="edit.php" style="background: #28a745; color: white; padding: 8px 16px; text-decoration: none; margin-right: 10px;">Edit Profile</a>
    
    <form method="POST" action="logout.php" style="display: inline;">
        <button type="submit">Logout</button>
    </form>
</body>
</html>