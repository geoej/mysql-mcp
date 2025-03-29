-- Create a duplicate of the services database
CREATE DATABASE IF NOT EXISTS services_duplicate;
USE services_duplicate;

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

-- Insert expanded sample data into customers table
INSERT INTO customers (first_name, last_name, email, phone, address, membership_date, status) VALUES
('John', 'Doe', 'john.doe@email.com', '555-0101', '123 Main St, City', '2024-01-15', 'active'),
('Jane', 'Smith', 'jane.smith@email.com', '555-0102', '456 Oak Ave, Town', '2024-01-20', 'active'),
('Mike', 'Johnson', 'mike.j@email.com', '555-0103', '789 Pine Rd, Village', '2024-02-01', 'active'),
('Sarah', 'Williams', 'sarah.w@email.com', '555-0104', '321 Elm St, City', '2024-02-10', 'active'),
('David', 'Brown', 'david.b@email.com', '555-0105', '654 Maple Ave, Town', '2024-02-15', 'inactive'),
('Emma', 'Davis', 'emma.d@email.com', '555-0106', '987 Cedar Rd, Village', '2024-03-01', 'active'),
('James', 'Wilson', 'james.w@email.com', '555-0107', '147 Birch St, City', '2024-03-05', 'suspended'),
('Lisa', 'Anderson', 'lisa.a@email.com', '555-0108', '258 Spruce Ave, Town', '2024-03-10', 'active'),
('Robert', 'Taylor', 'robert.t@email.com', '555-0109', '369 Willow Rd, Village', '2024-03-15', 'active'),
('Mary', 'Thomas', 'mary.t@email.com', '555-0110', '741 Ash St, City', '2024-03-20', 'active');

-- Insert expanded sample data into movies table
INSERT INTO movies (title, director, release_year, genre, duration_minutes, rating, daily_rental_rate, total_copies, available_copies) VALUES
('The Matrix', 'Lana Wachowski', 1999, 'Sci-Fi', 136, 'R', 3.99, 3, 3),
('Inception', 'Christopher Nolan', 2010, 'Sci-Fi', 148, 'PG-13', 4.99, 2, 2),
('The Dark Knight', 'Christopher Nolan', 2008, 'Action', 152, 'PG-13', 4.99, 2, 2),
('Pulp Fiction', 'Quentin Tarantino', 1994, 'Crime', 154, 'R', 3.99, 2, 2),
('Forrest Gump', 'Robert Zemeckis', 1994, 'Drama', 142, 'PG-13', 3.99, 2, 2),
('The Shawshank Redemption', 'Frank Darabont', 1994, 'Drama', 142, 'R', 4.99, 2, 2),
('The Godfather', 'Francis Ford Coppola', 1972, 'Crime', 175, 'R', 4.99, 2, 2),
('Star Wars: Episode IV', 'George Lucas', 1977, 'Sci-Fi', 121, 'PG', 4.99, 3, 3),
('The Lord of the Rings', 'Peter Jackson', 2001, 'Fantasy', 178, 'PG-13', 5.99, 2, 2),
('Titanic', 'James Cameron', 1997, 'Romance', 194, 'PG-13', 4.99, 2, 2),
('Avatar', 'James Cameron', 2009, 'Sci-Fi', 162, 'PG-13', 5.99, 2, 2),
('The Avengers', 'Joss Whedon', 2012, 'Action', 143, 'PG-13', 4.99, 3, 3),
('Jurassic Park', 'Steven Spielberg', 1993, 'Sci-Fi', 127, 'PG-13', 4.99, 2, 2),
('The Lion King', 'Roger Allers', 1994, 'Animation', 88, 'G', 3.99, 2, 2),
('The Silence of the Lambs', 'Jonathan Demme', 1991, 'Thriller', 118, 'R', 4.99, 2, 2);

-- Insert expanded sample data into rentals table
INSERT INTO rentals (customer_id, movie_id, rental_date, due_date, return_date, rental_status, total_amount) VALUES
(1, 1, '2024-03-01 10:00:00', '2024-03-03 10:00:00', '2024-03-03 09:00:00', 'returned', 7.98),
(2, 2, '2024-03-02 14:30:00', '2024-03-04 14:30:00', NULL, 'active', 9.98),
(3, 3, '2024-03-01 16:00:00', '2024-03-03 16:00:00', '2024-03-03 15:30:00', 'returned', 9.98),
(4, 4, '2024-03-03 11:00:00', '2024-03-05 11:00:00', NULL, 'active', 7.98),
(5, 5, '2024-03-02 15:00:00', '2024-03-04 15:00:00', '2024-03-04 14:00:00', 'returned', 7.98),
(6, 6, '2024-03-01 09:00:00', '2024-03-03 09:00:00', NULL, 'overdue', 9.98),
(7, 7, '2024-03-02 13:00:00', '2024-03-04 13:00:00', '2024-03-04 12:00:00', 'returned', 9.98),
(8, 8, '2024-03-03 16:00:00', '2024-03-05 16:00:00', NULL, 'active', 14.97),
(9, 9, '2024-03-01 12:00:00', '2024-03-03 12:00:00', '2024-03-03 11:30:00', 'returned', 11.98),
(10, 10, '2024-03-02 10:00:00', '2024-03-04 10:00:00', NULL, 'active', 9.98),
(1, 11, '2024-03-03 14:00:00', '2024-03-05 14:00:00', NULL, 'active', 11.98),
(2, 12, '2024-03-01 11:00:00', '2024-03-03 11:00:00', '2024-03-03 10:30:00', 'returned', 14.97),
(3, 13, '2024-03-02 16:00:00', '2024-03-04 16:00:00', NULL, 'active', 9.98),
(4, 14, '2024-03-03 09:00:00', '2024-03-05 09:00:00', NULL, 'active', 7.98),
(5, 15, '2024-03-01 13:00:00', '2024-03-03 13:00:00', '2024-03-03 12:30:00', 'returned', 9.98);

-- Insert expanded sample data into payments table
INSERT INTO payments (rental_id, amount, payment_date, payment_method) VALUES
(1, 7.98, '2024-03-03 09:00:00', 'credit_card'),
(3, 9.98, '2024-03-03 15:30:00', 'cash'),
(5, 7.98, '2024-03-04 14:00:00', 'debit_card'),
(7, 9.98, '2024-03-04 12:00:00', 'credit_card'),
(9, 11.98, '2024-03-03 11:30:00', 'cash'),
(12, 14.97, '2024-03-03 10:30:00', 'credit_card'),
(15, 9.98, '2024-03-03 12:30:00', 'debit_card'); 