USE sakila; 

-- Write a query to display for each store its store ID, city, and country.
SELECT * FROM sakila.address;
SELECT * FROM sakila.country;
SELECT * FROM sakila.store;
SELECT * FROM sakila.city; 

SELECT  a.city_id, s.store_id, c.city_id, co.country_id
FROM sakila.address as a 
JOIN sakila.store as s
ON a.address_id = s.address_id
JOIN sakila.city as c 
ON a.city_id = c.city_id 
JOIN sakila.country as co 
ON c.country_id = co.country_id;

-- Write a query to display how much business, in dollars, each store brought in.
SELECT * FROM sakila.payment; 
SELECT * FROM sakila.customer;
SELECT * FROM sakila.store;

SELECT SUM(amount), c.store_id
FROM sakila.payment as p 
JOIN sakila.customer as c 
ON p.customer_id = c.customer_id 
JOIN sakila.store as s 
ON c.store_id = s.store_id 
GROUP BY s.store_id
ORDER BY SUM(amount) DESC;

-- Which film categories are longest?
SELECT * FROM sakila.film; 
SELECT * FROM sakila.film_category;
SELECT * FROM sakila.category;

SELECT c.name AS category , ROUND(AVG(f.length), 2) AS avg_length
FROM sakila.film as f 
JOIN sakila.film_category as f_c
ON f.film_id = f_c.film_id 
JOIN sakila.category as c 
ON f_c.category_id = c.category_id 
GROUP BY c.category_id 
ORDER BY ROUND(AVG(f.length), 2) DESC;

-- Display the most frequently rented movies in descending order.
SELECT * FROM sakila.rental; 
SELECT * FROM sakila.inventory; 
SELECT * FROM sakila.film;

SELECT f.title, f.film_id, r.rental_id, r.inventory_id, COUNT(*) as rented_count 
FROM sakila.rental as r 
JOIN sakila.inventory as i 
ON r.inventory_id = i.inventory_id
JOIN sakila.film as f
ON i.film_id = f.film_id
GROUP BY r.inventory_id
ORDER BY COUNT(*) DESC;

-- List the top five genres in gross revenue in descending order.
SELECT * FROM sakila.film; 
SELECT * FROM sakila.film_category;
SELECT * FROM sakila.category;

SELECT  c.name as genre, (COUNT(*)*f.rental_rate) as gross_revenue, COUNT(*) as number_of_times_rented, f.rental_rate
FROM sakila.film as f 
JOIN sakila.film_category as f_c 
ON f.film_id = f_c.film_id 
JOIN sakila.category as c 
ON f_c.category_id = c.category_id 
GROUP BY c.name
ORDER BY (COUNT(*)*f.rental_rate) DESC;

-- Is "Academy Dinosaur" available for rent from Store 1?
SELECT * FROM sakila.rental;
SELECT * FROM sakila.inventory; 
SELECT * FROM sakila.film;

SELECT f.title, f.film_id, r.rental_id, i.store_id, r.rental_date, r.return_date, r.last_update
FROM sakila.film as f 
JOIN sakila.inventory as i 
ON f.film_id = i.film_id 
JOIN sakila.rental as r 
ON i.inventory_id = r.inventory_id
WHERE f.title = "ACADEMY DINOSAUR"
LIMIT 1;

-- Get all pairs of actors that worked together. *I GOT THIS SOLUTION FOLLOWING STEPS I FOUND ONLINE AND DO NOT FULLY UNDERSTAND HOW IT WORKS, WOULD APPRECIATE ANY CHANCE TO REVIEW IT* 
SELECT * FROM sakila.actor; 
SELECT * FROM sakila.film_actor;
SELECT * FROM sakila.film;

SELECT f_a.actor_id as actor_a, f_a2.actor_id as actor_b, COUNT(f_a.film_id) as casted_together
FROM sakila.film_actor as f_a
JOIN sakila.film_actor as f_a2
ON f_a.film_id = f_a2.film_id 
AND f_a.actor_id > f_a2.actor_id 
JOIN sakila.film as f 
ON f_a.film_id = f.film_id 
JOIN sakila.actor as a 
ON f_a.actor_id = a.actor_id
GROUP BY f_a.actor_id, f_a2.actor_id 
ORDER BY casted_together DESC;

-- Get all pairs of customers that have rented the same film more than 3 times. *CAN'T GET THIS ONE TO WORK*
SELECT * FROM sakila.rental;
SELECT * FROM sakila.payment;

SELECT p.customer_id as customer_1, p2.customer_id as customer_2, COUNT(r.inventory_id) as same_film_rented 
FROM sakila.payment as p 
JOIN sakila.payment as p2
ON p.customer_id = p2.customer_id 
AND p.customer_id < p2.customer_id 
JOIN sakila.rental as r 
ON p.rental_id = r.rental_id 
GROUP BY p.customer_id, p2.customer_id
ORDER BY same_film_rented DESC;

-- For each film, list actor that has acted in more films. *I GOT THIS SOLUTION FOLLOWING STEPS I FOUND ONLINE AND DO NOT FULLY UNDERSTAND HOW IT WORKS, WOULD APPRECIATE ANY CHANCE TO REVIEW IT* 
SELECT * FROM sakila.actor; 
SELECT * FROM sakila.film_actor;
SELECT * FROM sakila.film;

SELECT COUNT(f_a.actor_id) AS num_of_films, CONCAT(a.first_name," ", a.last_name) as actor, f_a.actor_id 
FROM actor as a 
INNER JOIN film_actor as f_a 
ON a.actor_id = f_a.actor_id
GROUP BY f_a.actor_id
ORDER BY COUNT(f_a.actor_id) DESC;