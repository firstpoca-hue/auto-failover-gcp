<?php
session_start();
?>
<!DOCTYPE html>
<html>
<head>
    <title>Student Login</title>
    <style>
        body { font-family: Arial; max-width: 400px; margin: 100px auto; padding: 20px; }
        .form-group { margin: 15px 0; }
        input[type="text"], input[type="password"] { width: 100%; padding: 8px; }
        button { background: #007cba; color: white; padding: 10px 20px; border: none; cursor: pointer; }
        .error { color: red; margin: 10px 0; }
    </style>
</head>
<body>
    <h2>Student Login</h2>
    
    <?php if (isset($_GET['error'])): ?>
        <div class="error">Invalid credentials</div>
    <?php endif; ?>
    
    <?php if (isset($_GET['message']) && $_GET['message'] == 'account_created'): ?>
        <div style="color: green; margin: 10px 0;">Account created successfully! Please login.</div>
    <?php endif; ?>
    
    <form method="POST" action="login.php">
        <div class="form-group">
            <label>Username:</label>
            <input type="text" name="username" required>
        </div>
        <div class="form-group">
            <label>Password:</label>
            <input type="password" name="password" required>
        </div>
        <button type="submit">Login</button>
        <a href="register.php" style="background: #28a745; color: white; padding: 10px 20px; text-decoration: none; margin-left: 10px;">Register</a>
    </form>
</body>
</html>