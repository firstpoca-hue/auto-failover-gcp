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

if (!$student) {
    header("Location: register.php");
    exit;
}
?>
<!DOCTYPE html>
<html>
<head>
    <title>Edit Profile</title>
    <style>
        body { font-family: Arial; max-width: 500px; margin: 50px auto; padding: 20px; }
        .form-group { margin: 15px 0; }
        input[type="text"], input[type="email"], select { width: 100%; padding: 8px; }
        button { background: #007cba; color: white; padding: 10px 20px; border: none; cursor: pointer; margin-right: 10px; }
        .cancel { background: #6c757d; }
        .success { color: green; margin: 10px 0; }
    </style>
</head>
<body>
    <h2>Edit Profile</h2>
    
    <?php if (isset($_GET['updated'])): ?>
        <div class="success">Profile updated successfully!</div>
    <?php endif; ?>
    
    <form method="POST" action="update_student.php">
        <div class="form-group">
            <label>Full Name:</label>
            <input type="text" name="full_name" value="<?php echo htmlspecialchars($student['full_name']); ?>" required>
        </div>
        <div class="form-group">
            <label>Email:</label>
            <input type="email" name="email" value="<?php echo htmlspecialchars($student['email']); ?>" required>
        </div>
        <div class="form-group">
            <label>Phone:</label>
            <input type="text" name="phone" value="<?php echo htmlspecialchars($student['phone']); ?>" required>
        </div>
        <div class="form-group">
            <label>Course:</label>
            <select name="course" required>
                <option value="Computer Science" <?php echo $student['course'] == 'Computer Science' ? 'selected' : ''; ?>>Computer Science</option>
                <option value="Mathematics" <?php echo $student['course'] == 'Mathematics' ? 'selected' : ''; ?>>Mathematics</option>
                <option value="Physics" <?php echo $student['course'] == 'Physics' ? 'selected' : ''; ?>>Physics</option>
                <option value="Chemistry" <?php echo $student['course'] == 'Chemistry' ? 'selected' : ''; ?>>Chemistry</option>
            </select>
        </div>
        <div class="form-group">
            <label>Year:</label>
            <select name="year" required>
                <option value="1" <?php echo $student['year'] == 1 ? 'selected' : ''; ?>>First Year</option>
                <option value="2" <?php echo $student['year'] == 2 ? 'selected' : ''; ?>>Second Year</option>
                <option value="3" <?php echo $student['year'] == 3 ? 'selected' : ''; ?>>Third Year</option>
                <option value="4" <?php echo $student['year'] == 4 ? 'selected' : ''; ?>>Fourth Year</option>
            </select>
        </div>
        <button type="submit">Update Profile</button>
        <a href="dashboard.php"><button type="button" class="cancel">Cancel</button></a>
    </form>
</body>
</html>