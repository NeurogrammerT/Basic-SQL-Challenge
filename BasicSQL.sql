USE sakila;

#1a. Display the first and last names of all actors from the table actor
SELECT first_name, last_name FROM actor;

#2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." 
alter table actor add actor_name varchar(100) not null;
update actor set actor_name = concat(first_name, ' ', last_name);
SELECT * FROM actor WHERE first_name = "Joe";

#2b. Find all actors whose last name contain the letters GEN:
SELECT * FROM actor WHERE last_name like "%GEN%";

#2c. Find all actors whose last names contain the letters LI. This time, order the rows by last name and first name, in that order:
SELECT * FROM actor WHERE last_name like "%LI%" order by last_name, first_name;

#2d. Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China:
SELECT * FROM country WHERE country_id and country in ("Afghanistan", "Bangladesh", "China");

#3a.Create a column in the table actor named description and use the data type BLOB
alter table actor add description blob not null;
SELECT * FROM actor;

#3b. Delete the description column.
alter table actor drop description;
SELECT * FROM actor;


#4a. List the last names of actors, as well as how many actors have that last name.
SELECT last_name,COUNT(*) as count FROM actor GROUP BY last_name ORDER BY count DESC;

#4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors
SELECT last_name,COUNT(*) as count FROM actor GROUP BY last_name having Count(*) >=2 ORDER BY count DESC;

#4c. The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS. Write a query to fix the record.
update actor set actor_name = "HARPO WILLIAMS" where actor_name = "GROUCHO WILLIAMS";
SELECT * FROM actor WHERE actor_name="HARPO WILLIAMS";

#4d. In a single query, if the first name of the actor is currently HARPO, change it to GROUCHO.
update actor set first_name = "GROUCHO" where first_name = "Harpo";
SELECT * FROM actor WHERE first_name="GROUCHO";

#5a. You cannot locate the schema of the address table. Which query would you use to re-create it?
show create table address;
SELECT * FROM address limit 10;

#6a. Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables staff and address:
SELECT staff.first_name, staff.last_name, address.address
FROM staff
INNER JOIN address ON staff.address_id=address.address_id;

#6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment
SELECT staff.first_name, staff.last_name, SUM(payment.amount) as amount
FROM staff
INNER JOIN payment ON staff.staff_id=payment.staff_id
WHERE payment.payment_date like ("%2005-08%")
GROUP BY last_name;

#6c. List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join.
SELECT film.title, COUNT(film_actor.actor_id) as actor_total
FROM film
INNER JOIN film_actor ON film.film_id=film_actor.film_id
GROUP BY title;

#6d. How many copies of the film Hunchback Impossible exist in the inventory system?
SELECT * FROM film;
SELECT * FROM inventory;
SELECT film.title, COUNT(inventory.film_id) as Total_Copies
FROM film
INNER JOIN inventory ON film.film_id=inventory.film_id
WHERE title="Hunchback Impossible";

#6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer. List the customers alphabetically by last name:
SELECT customer.first_name, customer.last_name, SUM(payment.amount) as Total_Amount_Paid
FROM customer
INNER JOIN payment ON customer.customer_id=payment.customer_id
GROUP BY last_name 
ORDER BY last_name;

#7a.Use subqueries to display the titles of movies starting with the letters K and Q whose language is English.
SELECT * FROM film
WHERE title like ("K%") or title like ("Q%");

#7b. Use subqueries to display all actors who appear in the film Alone Trip.
SELECT * FROM film limit 10;
SELECT * FROM film_actor limit 10;
SELECT * FROM actor limit 10;
SELECT film.title, actor.actor_name
FROM film
INNER JOIN film_actor ON film.film_id=film_actor.film_id
INNER JOIN actor ON film_actor.actor_id=actor.actor_id
WHERE title="Alone Trip";


#7c. You need the names and email addresses of all Canadian customers. Use joins to retrieve this information.**
SELECT * FROM country limit 10;
SELECT * FROM city limit 10;
SELECT * FROM customer limit 10;
SELECT * FROM address limit 10;
SELECT customer.first_name, customer.last_name, customer.email, country.country
FROM customer
INNER JOIN address ON customer.address_id=address.address_id
INNER JOIN city ON address.city_id=city.city_id
INNER JOIN country ON city.country_id=country.country_id
WHERE country="Canada"
GROUP BY last_name;

#7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.
SELECT * FROM film limit 10;
SELECT * FROM category limit 10;
SELECT * FROM film_category limit 10;
SELECT film.title, category.name
FROM film
INNER JOIN film_category ON film.film_id=film_category.film_id
INNER JOIN category ON film_category.category_id=category.category_id
WHERE name="Family";

#7e. Display the most frequently rented movies in descending order***
SELECT * FROM inventory limit 10;
SELECT * FROM rental limit 10;
SELECT * FROM film limit 10;
SELECT film.title, inventory.film_id, count(rental.rental_id) as Rental_Total
FROM inventory
INNER JOIN film on inventory.film_id=film.film_id
INNER JOIN rental on inventory.inventory_id=rental.inventory_id
GROUP BY film_id
ORDER BY Rental_Total desc;

#7f. Write a query to display how much business, in dollars, each store brought in.
SELECT * FROM store;
SELECT * FROM payment;
SELECT store.manager_staff_id, format(sum(payment.amount), 2) as total
FROM store
INNER JOIN payment ON store.manager_staff_id=payment.staff_id
GROUP BY manager_staff_id;

#7g. Write a query to display for each store its store ID, city, and country
SELECT store.store_id, city.city_id, country.country_id
FROM store
INNER JOIN address ON store.address_id=address.address_id
INNER JOIN city ON address.city_id=city.city_id
INNER JOIN country ON city.country_id=country.country_id
GROUP BY store_id;

#7h. List the top five genres in gross revenue in descending order. (Hint: you may need to use the following tables: category, film_category, inventory, payment, and rental.)
SELECT * FROM category limit 10;
SELECT * FROM film_category limit 10;
SELECT * FROM inventory limit 10;
SELECT * FROM rental limit 10;
SELECT * FROM payment limit 10;
SELECT category.name, format(sum(payment.amount), 2) as Gross_Revenue
FROM category
INNER JOIN film_category ON category.category_id=film_category.category_id
INNER JOIN inventory ON film_category.film_id=inventory.film_id
INNER JOIN rental ON inventory.inventory_id=rental.inventory_id
INNER JOIN payment ON rental.rental_id=payment.rental_id
GROUP BY category.name
ORDER BY Gross_Revenue desc
limit 5;

#8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. 
CREATE VIEW Top_Five_View AS
SELECT category.name, format(sum(payment.amount), 2) as Gross_Revenue
FROM category
INNER JOIN film_category ON category.category_id=film_category.category_id
INNER JOIN inventory ON film_category.film_id=inventory.film_id
INNER JOIN rental ON inventory.inventory_id=rental.inventory_id
INNER JOIN payment ON rental.rental_id=payment.rental_id
GROUP BY category.name
ORDER BY Gross_Revenue desc
limit 5;

#8b. How would you display the view that you created in 8a?
SELECT * FROM Top_Five_View;

#8c. You find that you no longer need the view top_five_genres. Write a query to delete it.
DROP VIEW Top_Five_View;

