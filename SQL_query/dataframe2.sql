use sakila;

# mostramos todos los datos de la tabla film

SELECT *
FROM film
LIMIT 10;

#Para mostrar por ejemplo la columna title , release_year y rental_duration y ordenador por año de estreno

SELECT title, release_year, rental_duration
FROM film
ORDER BY release_year;

# Agregamos la condicion Where para filtrar por 

SELECT title, release_year, rental_duration
FROM film
WHERE rental_duration = 3;


# Agregamos la condicion ordenar por precio ascendente para que nos muestre el listado de precios mas bajos
SELECT rental_id, amount
FROM payment
ORDER BY amount ASC;

#Cuenta las veces que se repite un precio y los agrupa por precio
SELECT amount, COUNT(*) AS total_amount
FROM payment
GROUP BY amount;


# Utilizamos Join porque la tabla film no tiene el idioma de las peliculas y filtramos por peliculas en ingles e italiano
SELECT title, rental_duration, name
FROM film
JOIN language ON film.language_id = language.language_id
WHERE name = 'English' OR name = 'Italian';

# Contar peliculas por categoria
SELECT name, COUNT(*) AS category
FROM category
GROUP BY name;

# Combinar varias consultas con Join para saber total de pelicula por categorias.
SELECT 
    category.name AS category,
    COUNT(film.film_id) AS total_films
FROM category
JOIN film_category ON category.category_id = film_category.category_id
JOIN film ON film_category.film_id = film.film_id
GROUP BY category.name
ORDER BY total_films DESC;

# Counsulta con Join para saber el dinero generado por peliculas


SELECT film.title, SUM(payment.amount) AS revenue
FROM film
LEFT JOIN inventory ON film.film_id = inventory.film_id
LEFT JOIN rental ON inventory.inventory_id = rental.inventory_id
LEFT JOIN payment ON rental.rental_id = payment.rental_id
GROUP BY film.title
ORDER BY revenue DESC;

# Consulta para saber numero de alquileres por pelicula

SELECT 
    f.title,
    COUNT(r.rental_id) AS total_rentals
FROM film f
LEFT JOIN inventory i ON f.film_id = i.film_id
LEFT JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY f.title
ORDER BY total_rentals DESC;

# Unimos tabla completa de clientes para tener datos de cliente, alquiler y duración de alquiler por pelicula mas la fecha y el gasto generado.

CREATE VIEW vista_customer_film_activity AS
SELECT
	c.customer_id,
    c.first_name,
    c.last_name,
    f.title AS film_title,
    r.rental_date,
    r.return_date,
    p.amount,
    p.payment_date
    FROM customer c
    JOIN rental r ON c.customer_id = r.customer_id
    JOIN inventory i ON r.inventory_id = i.inventory_id
    JOIN film f ON i.film_id = f.film_id
    JOIN payment p ON p.rental_id = r.rental_id;
    
    
    SELECT * FROM vista_customer_film_activity;
