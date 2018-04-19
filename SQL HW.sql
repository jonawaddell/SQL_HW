use sakila;
select * from actor;
-- 1a. Display the first and last names of all actors from the table actor.
select actor.first_name, actor.last_name from actor;

-- 1b. Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name.
select concat(actor.first_name, ' ', actor.last_name) as actor_name from actor;

-- -------------------------------------------------------------

-- 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." What is one query would you use to obtain this information?
select actor.actor_id, actor.first_name, actor.last_name from actor
where first_name = 'Joe';

-- 2b. Find all actors whose last name contain the letters GEN:
select * from actor
where last_name like '%gen%';

-- 2c. Find all actors whose last names contain the letters LI. This time, order the rows by last name and first name, in that order:
select * from actor
where last_name like '%li%'
order by last_name and first_name asc;

-- 2d. Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China:
select * from country
where country in ('Afghanistan', 'Bangladesh', 'China');

-- --------------------------------------------------------------------------

-- 3a. Add a middle_name column to the table actor. Position it between first_name and last_name. Hint: you will need to specify the data type.
ALTER TABLE `sakila`.`actor` 
ADD COLUMN `middle_ name` VARCHAR(45) NULL AFTER `first_name`;

-- 3b. You realize that some of these actors have tremendously long last names. Change the data type of the middle_name column to blobs.
ALTER TABLE `sakila`.`actor` 
CHANGE COLUMN `middle_ name` `middle_ name` BLOB NULL DEFAULT NULL ;

-- 3c. Now delete the middle_name column.
ALTER TABLE `sakila`.`actor` 
DROP COLUMN `middle_ name`;

-- ----------------------------------------------------------------------------

-- 4a. List the last names of actors, as well as how many actors have that last name.
select last_name, count(*) as 'count' from actor
group by last_name;

-- 4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors
select last_name, count(*) as 'count' from actor
group by last_name
having count >= 2;

-- 4c. Oh, no! The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS, the name of Harpo's second cousin's husband's yoga teacher. Write a query to fix the record.
update actor 
set first_name = 'HARPO'
where first_name = 'GROUCHO' and last_name = 'Williams' ;

-- 4d. Perhaps we were too hasty in changing GROUCHO to HARPO. It turns out that GROUCHO was the correct name after all! In a single query, if the first name of the actor is currently HARPO, change it to GROUCHO. Otherwise, change the first name to MUCHO GROUCHO, as that is exactly what the actor will be with the grievous error. BE CAREFUL NOT TO CHANGE THE FIRST NAME OF EVERY ACTOR TO MUCHO GROUCHO, HOWEVER! (Hint: update the record using a unique identifier.)
UPDATE actor 
SET first_name= 'GROUCHO'
WHERE first_name='HARPO' AND last_name='WILLIAMS';

-- ------------------------------------------------------------------------------

-- 5a. You cannot locate the schema of the address table. Which query would you use to re-create it?
describe address;

-- -----------------------------------------------------

-- 6a. Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables staff and address:
select act.first_name, act.last_name, address.address from actor act
join address on act.actor_id = address.address_id;

-- 6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment.
select staff.staff_id, sum(payment.amount) as 'total_amount' from staff
join payment on staff.staff_id = payment.staff_id
group by staff_id;

-- 6c. List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join.
select f.title, count(a.actor_id) AS 'TOTAL'
from film f left join film_actor  a on f.film_id = a.film_id
group by f.title;

-- 6d. How many copies of the film Hunchback Impossible exist in the inventory system?
select film.title, count(inventory.film_id) as copy_count
from film left join inventory on film.film_id = inventory.film_id
where film.title like 'Hunchback Impossible';


-- 6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer. List the customers alphabetically by last name:
select customer.customer_id, customer.first_name, customer.last_name, sum(payment.amount) as 'total_paid'
from customer left join payment on customer.customer_id = payment.customer_id
group by customer_id order by customer.last_name;

-- -------------------------------------------------------------

-- 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, films starting with the letters K and Q have also soared in popularity. Use subqueries to display the titles of movies starting with the letters K and Q whose language is English.
select film.title 
from film 
where (title LIKE 'K%' or title like'Q%')
and language_id = (select language_id from language where name ='English');

-- 7b. Use subqueries to display all actors who appear in the film Alone Trip.
select * from actor 
	where actor_id in (select actor_id from film_actor 
		where film_id in (select film_id from film where title = 'Alone Trip'));

-- 7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. Use joins to retrieve this information.
SELECT first_name, last_name, email from customer
	where address_id in (select address_id from address
		where city_id in (select city_id from city 
			where country_id in (select country_id from country where country = 'Canada')));

-- 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as famiy films.
select title from film
	where film_id in (select film_id from film_category
		where category_id in (select category_id from category where name = 'Family'));

-- 7e. Display the most frequently rented movies in descending order.
select rental_id,  count(rental_id) as rental_count from payment
group by payment.rental_id





/*select count(rental_id), film.title from film
	where film_id in (select film_id from inventory
		where inventory_id in (select inventory_id from rental
			where rental_id in (select rental_id from payment)))
*/