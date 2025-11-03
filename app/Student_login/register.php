<?php
session_start();
?>
<!DOCTYPE html>
<html>
<head>
    <title>Student Registration</title>
    <style>
        body { font-family: Arial; max-width: 500px; margin: 50px auto; padding: 20px; }
        .form-group { margin: 15px 0; }
        input[type="text"], input[type="email"], input[type="password"], select { width: 100%; padding: 8px; }
        button { background: #007cba; color: white; padding: 10px 20px; border: none; cursor: pointer; margin-right: 10px; }
        .cancel { background: #6c757d; }
        .error { color: red; margin: 10px 0; }
    </style>
</head>
<body>
    <h2>Student Registration</h2>
    
    <?php if (isset($_GET['error'])): ?>
        <div class="error">Username already exists!</div>
    <?php endif; ?>
    
    <form method="POST" action="create_account.php">
        <div class="form-group">
            <label>Username:</label>
            <input type="text" name="username" required>
        </div>
        <div class="form-group">
            <label>Password:</label>
            <input type="password" name="password" required>
        </div>
        <div class="form-group">
            <label>Full Name:</label>
            <input type="text" name="full_name" required>
        </div>
        <div class="form-group">
            <label>Email:</label>
            <input type="email" name="email" required>
        </div>
        <div class="form-group">
            <label>Phone:</label>
            <input type="text" name="phone" required>
        </div>
        <div class="form-group">
            <label>Course:</label>
            <select name="course" required>
                <option value="">Select Course</option>
                <option value="Computer Science">Computer Science</option>
                <option value="Mathematics">Mathematics</option>
                <option value="Physics">Physics</option>
                <option value="Chemistry">Chemistry</option>
            </select>
        </div>
        <div class="form-group">
            <label>Year:</label>
            <select name="year" required>
                <option value="">Select Year</option>
                <option value="1">First Year</option>
                <option value="2">Second Year</option>
                <option value="3">Third Year</option>
                <option value="4">Fourth Year</option>
            </select>
        </div>
        <button type="submit">Create Account</button>
        <a href="index.php"><button type="button" class="cancel">Back to Login</button></a>
    </form>
</body>
</html>