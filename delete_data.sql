USE services;

-- First, get the rental_id to delete
SET @rental_id_to_delete = (
    SELECT rental_id 
    FROM rentals 
    ORDER BY rental_id 
    LIMIT 1
);

-- Delete payments for the selected rental
DELETE FROM payments 
WHERE rental_id = @rental_id_to_delete;

-- Delete the selected rental
DELETE FROM rentals 
WHERE rental_id = @rental_id_to_delete;

-- Get movie IDs that are not referenced in rentals
SET @movie_ids_to_delete = (
    SELECT GROUP_CONCAT(movie_id) 
    FROM movies m
    WHERE NOT EXISTS (
        SELECT 1 FROM rentals r 
        WHERE r.movie_id = m.movie_id
    )
    ORDER BY movie_id
    LIMIT 2
);

-- Delete movies that are not referenced
DELETE FROM movies 
WHERE FIND_IN_SET(movie_id, @movie_ids_to_delete);

-- Get customer IDs that are not referenced in rentals
SET @customer_ids_to_delete = (
    SELECT GROUP_CONCAT(customer_id) 
    FROM customers c
    WHERE NOT EXISTS (
        SELECT 1 FROM rentals r 
        WHERE r.customer_id = c.customer_id
    )
    ORDER BY customer_id
    LIMIT 1
);

-- Delete customers that are not referenced
DELETE FROM customers 
WHERE FIND_IN_SET(customer_id, @customer_ids_to_delete); 