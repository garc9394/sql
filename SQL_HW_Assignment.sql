## SQL Homework Assignment
## By Gar Cheuy
## January 8, 2018

# Use database "sakila"
USE sakila;

# 1a. First and last names of all actors from table actor
SELECT first_name AS 'First Name'
,last_name AS 'Last Name'
FROM actor
ORDER BY first_name
,last_name;

# 1b. First and last names in single column in upper case letters
SELECT CONCAT(first_name, ' ', last_name) AS 'Actor Name'
FROM actor
ORDER BY first_name
,last_name;

# 2a. Find actor with first name of "Joe"
SELECT actor_id AS 'ID Number'
,first_name AS 'First Name'
,last_name AS 'Last Name'
FROM actor
WHERE first_name = 'Joe';

# 2b. All actors whose last name contain the letters "GEN"
SELECT first_name AS 'First Name'
,last_name AS 'Last Name'
FROM actor
WHERE last_name LIKE '%GEN%'
ORDER BY first_name
,last_name;

# 2c. All actors whose last name contain the letters "LI", order the rows by last name and first name
SELECT last_name AS 'Last Name'
,first_name AS 'First Name'
FROM actor
WHERE last_name LIKE '%LI%'
ORDER BY last_name
,first_name;

# 2d. Display country_id and country of Afghanistan, Bangladesh, and China using IN
SELECT country_id AS 'Country ID'
,country AS 'Country Name'
FROM country
WHERE country IN
('Afghanistan', 'Bangladesh', 'China');

# 3a. Add "middle_name" column to table actor, after the "first_name" column, and before the "last_name" column
ALTER TABLE `sakila`.`actor` 
ADD COLUMN `middle_name` VARCHAR(45) NULL AFTER `first_name`;

# 3b. Change data type of column "middle_name" to BLOB
ALTER TABLE `sakila`.`actor` 
MODIFY COLUMN `middle_name` BLOB;

# 3c. Drop "middle_name" column
ALTER TABLE `sakila`.`actor` 
DROP COLUMN `middle_name`;

# 4a. List last names of actors, as well as how many actors having that last name
SELECT last_name AS 'Last Name'
,COUNT(last_name) AS 'Number of Actors'
FROM actor
GROUP BY last_name
ORDER BY last_name;

# 4b. List last names of actors, as well as how many actors having that last name, for names that are shared by at least two actors
SELECT last_name AS 'Last Name'
,COUNT(last_name) AS cnt
FROM actor
GROUP BY last_name
HAVING cnt >= 2
ORDER BY last_name;

# 4c. Update first name to "HARPO" for "GROUCHO WILLIAMS" in the actor table
UPDATE actor
SET first_name = 'HARPO'
WHERE first_name = 'GROUCHO'
AND last_name = 'WILLIAMS';

# 4d. Update first name for "HARPO WILLIAMS" or "GROUCHO WILLIAMS" using a unique identifier (actor_id)
UPDATE actor AS a
INNER JOIN actor AS b
ON a.actor_id = b.actor_id
SET a.first_name = (CASE WHEN b.first_name = 'HARPO' THEN 'GROUCHO' WHEN b.first_name = 'GROUCHO' THEN 'MUCHO GROUCHO'  END)
WHERE (b.first_name = 'HARPO' OR b.first_name = 'GROUCHO')
AND b.last_name = 'WILLIAMS';

# Verification
SELECT *
FROM actor
WHERE (first_name = 'HARPO' OR first_name = 'GROUCHO')
AND last_name = 'WILLIAMS';

# 5a. Re-create schema for "address" table
# 5a. Re-create schema for "address" table
# DESCRIBE address;
# SHOW COLUMNS FROM address;
# EXPLAIN address;
# SHOW CREATE TABLE address;
DESC address;

# 6a. Display names and address of staff from the "staff" and "address" tables
SELECT s.first_name AS 'First Name'
,s.last_name AS 'Last Name'
,a.address AS 'Address'
,a.address2 AS 'Address 2'
,a.district AS 'District'
,a.city_id AS 'City ID'
,a.postal_code AS 'Postal Code'
,a.location AS 'Location'
FROM staff s LEFT OUTER JOIN address a
ON s.address_id = a.address_id;

# 6b. Total amount rung up by staff in August 2005
SELECT CONCAT(s.first_name, ' ', s.last_name) AS 'Staff'
,SUM(p.amount) AS 'Total Amount'
FROM staff s LEFT OUTER JOIN payment p
ON s.staff_id = p.staff_id
WHERE MONTH(p.payment_date) = 8
AND YEAR(p.payment_date) = 2005
GROUP BY Staff
ORDER BY Staff;

# 6c. List film and the number of actors that that film; use INNER JOIN
SELECT f.title AS Title
,COUNT(a.actor_id) AS 'Number of Actors'
FROM film f INNER JOIN film_actor a
ON f.film_id = a.film_id
GROUP BY title
ORDER BY title;

# 6d. Number of copies of the film "Hunchback Impossible" in inventory
SELECT f.title AS Title
,SUM(i.inventory_id) AS 'Number of Copies'
FROM film f JOIN inventory i
ON f.film_id = i.film_id
WHERE f.title = 'Hunchback Impossible'
GROUP BY f.title;

# 6e. List total paid by each customer using JOIN, ordered by last name
SELECT c.last_name AS 'Customer Last Name'
,c.first_name AS 'Customer First Name'
,SUM(p.amount) AS 'Total Paid'
FROM customer c JOIN payment p
ON c.customer_id = p.customer_id
GROUP BY c.last_name
,c.first_name
ORDER BY c.last_name
,c.first_name;

# 7a. Display titles of movies starting with letters K and Q whose language is English, using subquery
SELECT title
FROM film
WHERE (title LIKE 'K%' OR title LIKE 'Q%')
AND language_id IN
(SELECT language_id
FROM language
WHERE name = 'English')
ORDER BY title;

# 7b. Display actors who appear in the film "Alone Trip" using subqueries
SELECT CONCAT(first_name, ' ', last_name) AS Actor
FROM actor
WHERE actor_id IN
(SELECT actor_id
FROM film_actor
WHERE film_id IN
(SELECT film_id
FROM film
WHERE title = 'Alone Trip'))
ORDER BY Actor;

# 7c. List all Canadian customers using joins
SELECT c.first_name AS 'First Name'
,c.last_name AS 'Last Name'
,c.email AS Email
FROM customer c JOIN address a
ON c.address_id = a.address_id
JOIN city ct ON a.city_id = ct.city_id
JOIN country cntry ON ct.country_id = cntry.country_id
WHERE cntry.country = 'Canada';

# 7c using subqueries
SELECT first_name AS 'First Name'
,last_name AS 'Last Name'
,email AS Email
FROM customer
WHERE address_id IN
(SELECT address_id
FROM address
WHERE city_id IN
(SELECT city_id
FROM city
WHERE country_id IN
(SELECT country_id
FROM country
WHERE country = 'Canada')));

# 7d. Indentify all movies categorized as family films
SELECT f.title AS Title
FROM film f JOIN film_category fc
ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
WHERE c.name = 'Family';

# 7e. Display the most frequency rented movies in descending order
SELECT f.title AS Title
,SUM(r.rental_id) AS 'Number of Times Rented'
FROM film f JOIN inventory i
ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY f.title
ORDER BY SUM(r.rental_id) DESC;

# 7f. Display total revenue for each store (alternative: join store and payment on manager_staff_id and staff_id)
SELECT s.store_id AS 'Store ID'
,ct.city AS City
,SUM(p.amount) AS 'Total Revenue'
FROM store s JOIN customer c
ON s.store_id = c.store_id
JOIN payment p ON c.customer_id = p.customer_id
JOIN address a ON s.address_id = a.address_id
JOIN city ct ON a.city_id = ct.city_id
GROUP BY s.store_id
,ct.city;

# 7g. Display store ID, city, and country for each store
SELECT s.store_id AS 'Store ID'
,ct.city AS City
,cntry.country AS Country
FROM store s JOIN address a
ON s.address_id = a.address_id
JOIN city ct ON a.city_id = ct.city_id
JOIN country cntry ON ct.country_id = cntry.country_id;

# 7h. List top 5 genres by revenue
SELECT c.name AS Genre
,SUM(p.amount) AS 'Total Amount'
FROM payment p JOIN rental r
ON p.rental_id = r.rental_id
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film_category f ON i.film_id = f.film_id
JOIN category c ON f.category_id = c.category_id
GROUP BY c.name
ORDER BY SUM(p.amount) DESC LIMIT 5;

# 8a. Create a view for the top 5 genres by revenue
CREATE VIEW `top_five_genres` AS
SELECT c.name AS Genre
,SUM(p.amount) AS 'Total Amount'
FROM payment p JOIN rental r
ON p.rental_id = r.rental_id
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film_category f ON i.film_id = f.film_id
JOIN category c ON f.category_id = c.category_id
GROUP BY c.name
ORDER BY SUM(p.amount) DESC LIMIT 5;

# 8b. Display "top_five_genres" view
SELECT *
FROM top_five_genres;

# 8c. Delete "top_five_genres" view
DROP VIEW top_five_genres;