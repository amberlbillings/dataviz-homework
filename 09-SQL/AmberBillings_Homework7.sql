-- Amber Billings

USE sakila;

-- 1a
SELECT first_name, last_name FROM actor;

-- 1b
SELECT UPPER(CONCAT(first_name, ' ', last_name)) 
AS 'Actor Name'
FROM actor;

-- 2a
SELECT actor_id, first_name, last_name
FROM actor
WHERE first_name = 'Joe';

-- 2b
SELECT * FROM actor
WHERE last_name LIKE '%GEN%';

-- 2c
SELECT * FROM actor
WHERE last_name LIKE '%LI%'
ORDER BY last_name, first_name;

-- 2d
SELECT country_id, country
FROM country
WHERE country IN ('Afghanistan', 'Bangladesh', 'China');

-- 3a
ALTER TABLE actor
ADD description BLOB;

-- 3b
ALTER TABLE actor
DROP description;

-- 4a
SELECT last_name, COUNT(last_name) AS 'Last Name Count'
FROM actor
GROUP BY last_name;

-- 4b
SELECT last_name, COUNT(last_name) AS 'Last Name Count'
FROM actor
GROUP BY last_name
HAVING COUNT(last_name) > 1;

-- 4c
UPDATE actor
SET first_name = 'HARPO'
WHERE first_name = 'GROUCHO'
AND last_name = 'WILLIAMS';

-- 4d
UPDATE actor
SET first_name = 'GROUCHO'
WHERE first_name = 'HARPO';

-- 5a
CREATE TABLE address (
	address_id INTEGER AUTO_INCREMENT NOT NULL,
    address VARCHAR(30) NOT NULL,
    address2 VARCHAR(30),
    district VARCHAR(30) NOT NULL,
    city_id INTEGER,
    postal_code INTEGER,
    phone INTEGER,
    location BLOB,
    last_update VARCHAR(40),
    PRIMARY KEY (address_id),
    FOREIGN KEY (city_id) REFERENCES city(city_id)
);

-- 6a
SELECT staff.first_name, staff.last_name, address.address
FROM staff INNER JOIN address 
ON staff.address_id = address.address_id;

-- 6b
SELECT staff.first_name, staff.last_name, SUM(payment.amount)
FROM staff INNER JOIN payment 
ON staff.staff_id = payment.staff_id
GROUP BY staff.staff_id;

-- 6c
SELECT film.title, COUNT(film_actor.actor_id) AS 'Number of Actors'
FROM film INNER JOIN film_actor
ON film.film_id = film_actor.film_id
GROUP BY film.film_id;

-- 6d ... answer = 6
SELECT film_id, COUNT(film_id)
FROM inventory
WHERE film_id IN (
	SELECT film_id
    FROM film
    WHERE title = 'Hunchback Impossible'
    )
GROUP BY film_id;

-- 6e
SELECT customer.first_name, customer.last_name, SUM(payment.amount) AS 'Total Amount Paid'
FROM customer INNER JOIN payment 
ON customer.customer_id = payment.customer_id
GROUP BY customer.customer_id
ORDER BY customer.last_name, customer.first_name;

-- 7a
SELECT title
FROM film
WHERE title IN (
	SELECT title
    FROM film
    WHERE title LIKE 'K%' OR title LIKE 'Q%'
    AND language_id = 1
    );
    
-- 7b
SELECT first_name, last_name
FROM actor
WHERE actor_id IN(
	SELECT actor_id
    FROM film_actor
    WHERE film_id IN(
		SELECT film_id
        FROM film
        WHERE title = 'Alone Trip'
        )
	);
    
-- 7c
SELECT first_name, last_name, email
FROM customer
WHERE address_id IN(
	SELECT address_id
    FROM address
    WHERE city_id IN(
		SELECT city_id
        FROM city
        WHERE country_id IN(
			SELECT country_id
            FROM country
            WHERE country = 'Canada'
            )
		)
	)
;

-- 7d
SELECT title
FROM film
WHERE film_id IN(
	SELECT film_id
    FROM film_category
    WHERE category_id IN(
		SELECT category_id
        FROM category
        WHERE name = 'Family'
        )
	)
;

-- 7e
SELECT film.title, COUNT(film.film_id)
FROM inventory
INNER JOIN film
	ON inventory.film_id = film.film_id
INNER JOIN rental
	ON inventory.inventory_id = rental.inventory_id
GROUP BY film.title
HAVING COUNT(film.film_id) >= 30
ORDER BY COUNT(film.film_id) DESC
;

-- 7f
SELECT inventory.store_id, SUM(payment.amount)
FROM rental
INNER JOIN payment
	ON rental.rental_id = payment.rental_id
INNER JOIN inventory
	ON rental.inventory_id = inventory.inventory_id
GROUP BY inventory.store_id;