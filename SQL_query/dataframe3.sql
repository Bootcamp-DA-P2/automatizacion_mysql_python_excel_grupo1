use sakila;

#Normalizamos datos
CREATE OR REPLACE VIEW v_actors_clean AS
SELECT 
    actor_id,
    LOWER(first_name) AS first_name,
    LOWER(last_name) AS last_name,
    CONCAT(UPPER(SUBSTRING(first_name,1,1)), LOWER(SUBSTRING(first_name,2)), ' ', 
           UPPER(SUBSTRING(last_name,1,1)), LOWER(SUBSTRING(last_name,2))) AS actor_full_name
FROM actor;

#Verificamos si existen nombres duplicados (mismo nombre, distinto ID)
SELECT first_name, last_name, COUNT(*)
FROM v_actors_clean
GROUP BY first_name, last_name
HAVING COUNT(*) > 1;

#Identificar los IDs duplicados (han salido 2)
SELECT actor_id, first_name, last_name 
FROM actor 
WHERE first_name = 'SUSAN' AND last_name = 'DAVIS';

#Elegimos un ID "maestro"
A. Actualizamos las películas del actor 'duplicado' al actor 'maestro'
UPDATE film_actor 
SET actor_id = 101 -- El ID que te quedas
WHERE actor_id = 110; -- El ID que vas a borrar
B. Ahora que el ID 110 no tiene películas asociadas, lo borramos
DELETE FROM actor 
WHERE actor_id = 110;

#Verificamos de nuevo si existen nombres duplicados (mismo nombre, distinto ID)
SELECT first_name, last_name, COUNT(*)
FROM v_actors_clean
GROUP BY first_name, last_name
HAVING COUNT(*) > 1;

#Número de actores por película
SELECT 
    f.title AS pelicula,
    COUNT(fa.actor_id) AS numero_de_actores
FROM film f
INNER JOIN film_actor fa ON f.film_id = fa.film_id
GROUP BY f.film_id
ORDER BY numero_de_actores DESC;

#Número de películas por actor
SELECT 
    ac.actor_full_name,
    COUNT(fa.film_id) AS numero_de_peliculas
FROM v_actors_clean ac
INNER JOIN film_actor fa ON ac.actor_id = fa.actor_id
GROUP BY ac.actor_id
ORDER BY numero_de_peliculas DESC;

#Resumen
SELECT 
    f.title AS nombre_pelicula,
    ac.actor_full_name,
    -- Subconsulta para el total de actores en esa película
    (SELECT COUNT(*) FROM film_actor fa2 WHERE fa2.film_id = f.film_id) AS total_actores_pelicula,
    -- Subconsulta para el total de películas de ese actor
    (SELECT COUNT(*) FROM film_actor fa3 WHERE fa3.actor_id = ac.actor_id) AS total_peliculas_actor
FROM film f
JOIN film_actor fa ON f.film_id = fa.film_id
JOIN v_actors_clean ac ON fa.actor_id = ac.actor_id;