-- Lab | Stored procedures
-- In this lab, we will continue working on the Sakila database of movie rentals.

-- Instructions
-- Write queries, stored procedures to answer the following questions:

-- 1. In the previous lab we wrote a query to find first name, last name, and emails of all the customers who rented Action movies. Convert the query into a simple stored procedure. 
-- Use the following query:
USE sakila;
  
  DELIMITER //
CREATE PROCEDURE GetActionMovieCustomers()
BEGIN
    SELECT first_name, last_name, email
    FROM customer
    JOIN rental ON customer.customer_id = rental.customer_id
    JOIN inventory ON rental.inventory_id = inventory.inventory_id
    JOIN film ON film.film_id = inventory.film_id
    JOIN film_category ON film_category.film_id = film.film_id
    JOIN category ON category.category_id = film_category.category_id
    WHERE category.name = "Action"
    GROUP BY first_name, last_name, email;
END //
DELIMITER ;
-- OTRO METODO (no sabemos porque no funciona):
  CREATE PROCEDURE action_clients(first_name, last_name, email)
  BEGIN
	  select first_name, last_name, email
	  from customer
	  join rental on customer.customer_id = rental.customer_id
	  join inventory on rental.inventory_id = inventory.inventory_id
	  join film on film.film_id = inventory.film_id
	  join film_category on film_category.film_id = film.film_id
	  join category on category.category_id = film_category.category_id
	  where category.name = "Action"
	  group by first_name, last_name, email
  END;


  
  -- 2. Now keep working on the previous stored procedure to make it more dynamic. 
  -- Update the stored procedure in a such manner that it can take a string argument for the category name and return the results for all customers that rented movie of that category/genre. 
  -- For eg., it could be action, animation, children, classics, etc.
  
 DELIMITER //
 CREATE PROCEDURE GetCustomersByCategory(IN category_name VARCHAR(50))
BEGIN
    SELECT first_name, last_name, email
    FROM customer
    JOIN rental ON customer.customer_id = rental.customer_id
    JOIN inventory ON rental.inventory_id = inventory.inventory_id
    JOIN film ON film.film_id = inventory.film_id
    JOIN film_category ON film_category.film_id = film.film_id
    JOIN category ON category.category_id = film_category.category_id
    WHERE category.name = category_name
    GROUP BY first_name, last_name, email;
END //
DELIMITER ;
  
CALL GetCustomersByCategory('Action');
CALL GetCustomersByCategory('Animation');
  
 -- 3.  Write a query to check the number of movies released in each movie category. Convert the query in to a stored procedure to filter only those categories that have movies released greater than a certain number. 
 -- Pass that number as an argument in the stored procedure.

DELIMITER //
DELIMITER //

CREATE PROCEDURE category_count_limit1(IN amount_limit VARCHAR(50))
BEGIN
    SELECT category.name AS category_name, COUNT(film.film_id) AS movie_count
    FROM category
    JOIN film_category ON category.category_id = film_category.category_id
    JOIN film ON film.film_id = film_category.film_id
    GROUP BY category.name
    HAVING COUNT(film.film_id) >= amount_limit;
END //

DELIMITER ;

CALL category_count_limit1(60);


    SELECT category.name AS category_name, COUNT(film.film_id) AS movie_count
    FROM category
    JOIN film_category ON category.category_id = film_category.category_id
    JOIN film ON film.film_id = film_category.film_id
    GROUP BY category.name
    HAVING COUNT(film.film_id) = 60;
 