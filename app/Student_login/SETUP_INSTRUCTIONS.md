# Student Registration Application Setup

## Prerequisites Installation

### 1. Install Nginx, PHP, and MySQL
```bash
sudo apt update
sudo apt install nginx php-fpm php-mysql mysql-server
```

### 2. Start Services
```bash
sudo systemctl start nginx
sudo systemctl start php7.4-fpm
sudo systemctl start mysql
sudo systemctl enable nginx php7.4-fpm mysql
```

## Database Setup

### 1. Secure MySQL Installation
```bash
sudo mysql_secure_installation
```

### 2. Create Database
```bash
sudo mysql -u root -p < setup.sql
```

### 3. Update Database Password
Edit `db.php` and replace `your_mysql_password` with your actual MySQL root password.

## Application Deployment

### 1. Copy Files to Web Directory
```bash
sudo mkdir -p /var/www/html/student-form
sudo cp *.php /var/www/html/student-form/
sudo chown -R www-data:www-data /var/www/html/student-form
sudo chmod -R 755 /var/www/html/student-form
```

### 2. Configure Nginx
```bash
sudo cp nginx.conf /etc/nginx/sites-available/student-form
sudo ln -s /etc/nginx/sites-available/student-form /etc/nginx/sites-enabled/
sudo rm /etc/nginx/sites-enabled/default
sudo nginx -t
sudo systemctl reload nginx
```

## Access Application

Open your browser and go to: `http://localhost:80`

## Usage

1. Enter any username/password to login (demo mode)
2. First-time users will see the registration form
3. Fill out the form and submit
4. Subsequent logins will show the dashboard with saved details

## Troubleshooting

- Check Nginx status: `sudo systemctl status nginx`
- Check PHP-FPM status: `sudo systemctl status php7.4-fpm`
- Check MySQL status: `sudo systemctl status mysql`
- View Nginx logs: `sudo tail -f /var/log/nginx/error.log`