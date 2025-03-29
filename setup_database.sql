-- Create the services database
CREATE DATABASE IF NOT EXISTS services;
USE services;

-- Create customers table
CREATE TABLE customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    address TEXT,
    membership_date DATE DEFAULT (CURRENT_DATE),
    status ENUM('active', 'inactive', 'suspended') DEFAULT 'active'
);

-- Create movies table
CREATE TABLE movies (
    movie_id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(100) NOT NULL,
    director VARCHAR(100),
    release_year YEAR,
    genre VARCHAR(50),
    duration_minutes INT,
    rating ENUM('G', 'PG', 'PG-13', 'R', 'NC-17'),
    daily_rental_rate DECIMAL(4,2) NOT NULL,
    total_copies INT DEFAULT 1,
    available_copies INT DEFAULT 1
);

-- Create rentals table
CREATE TABLE rentals (
    rental_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    movie_id INT,
    rental_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    due_date DATETIME,
    return_date DATETIME,
    rental_status ENUM('active', 'returned', 'overdue') DEFAULT 'active',
    total_amount DECIMAL(6,2),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (movie_id) REFERENCES movies(movie_id)
);

-- Create payments table
CREATE TABLE payments (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    rental_id INT,
    amount DECIMAL(6,2) NOT NULL,
    payment_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    payment_method ENUM('cash', 'credit_card', 'debit_card'),
    FOREIGN KEY (rental_id) REFERENCES rentals(rental_id)
);

-- Insert sample data into customers table
INSERT INTO customers (first_name, last_name, email, phone, address) VALUES
('John', 'Doe', 'john.doe@email.com', '555-0101', '123 Main St, City'),
('Jane', 'Smith', 'jane.smith@email.com', '555-0102', '456 Oak Ave, Town'),
('Mike', 'Johnson', 'mike.j@email.com', '555-0103', '789 Pine Rd, Village');

-- Insert sample data into movies table
INSERT INTO movies (title, director, release_year, genre, duration_minutes, rating, daily_rental_rate, total_copies, available_copies) VALUES
('The Matrix', 'Lana Wachowski', 1999, 'Sci-Fi', 136, 'R', 3.99, 3, 3),
('Inception', 'Christopher Nolan', 2010, 'Sci-Fi', 148, 'PG-13', 4.99, 2, 2),
('The Dark Knight', 'Christopher Nolan', 2008, 'Action', 152, 'PG-13', 4.99, 2, 2),
('Pulp Fiction', 'Quentin Tarantino', 1994, 'Crime', 154, 'R', 3.99, 2, 2),
('Forrest Gump', 'Robert Zemeckis', 1994, 'Drama', 142, 'PG-13', 3.99, 2, 2);

-- Insert sample data into rentals table
INSERT INTO rentals (customer_id, movie_id, rental_date, due_date, rental_status, total_amount) VALUES
(1, 1, '2024-03-01 10:00:00', '2024-03-03 10:00:00', 'returned', 7.98),
(2, 2, '2024-03-02 14:30:00', '2024-03-04 14:30:00', 'active', 9.98),
(3, 3, '2024-03-01 16:00:00', '2024-03-03 16:00:00', 'returned', 9.98);

-- Insert sample data into payments table
INSERT INTO payments (rental_id, amount, payment_date, payment_method) VALUES
(1, 7.98, '2024-03-03 11:00:00', 'credit_card'),
(3, 9.98, '2024-03-03 17:00:00', 'cash'); 