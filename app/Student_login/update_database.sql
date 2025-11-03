-- Add password column to existing students table
ALTER TABLE students ADD COLUMN password VARCHAR(255) AFTER username;